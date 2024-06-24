// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:numaze_web/common/const/widgets.dart';
//
// import 'common/const/colors.dart';
// import 'common/const/text.dart';
// import 'list_model.dart';
// import 'model.dart';
// import 'provider.dart';
// import 'treatments_provider.dart';
//
// class ReservationDetailsScreen extends ConsumerStatefulWidget {
//   final String shopDomain;
//
//   const ReservationDetailsScreen({
//     super.key,
//     required this.shopDomain,
//   });
//
//   @override
//   ConsumerState<ReservationDetailsScreen> createState() =>
//       _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends ConsumerState<ReservationDetailsScreen> {
//   String name = '';
//   String phoneNumber = '';
//   String verificationCode = '';
//   bool codeSent = false;
//   bool codeVerified = false;
//
//   Timer? _timer;
//   int _start = 180;
//
//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (_start == 0) {
//           setState(() {
//             timer.cancel();
//           });
//         } else {
//           setState(() {
//             _start--;
//           });
//         }
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
//     bool isKeyboardOpen = bottomInsets != 0;
//
//     final treatmentsState = ref.watch(treatmentProvider(widget.shopDomain));
//     // final optionsState = ref.watch(optionsProvider(widget.shopDomain));
//
//     if (treatmentsState is ListLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//     if (treatmentsState is ListError) {
//       return const Center(
//         child: Text('에러가 발생했습니다.'),
//       );
//     }
//     final treatments = (treatmentsState as ListModel<TreatmentCategory>).data;
//     final selectedTreatments = ref.watch(selectedTreatmentProvider);
//
//     final optionsState = ref.watch(optionsProvider(widget.shopDomain));
//     if (optionsState is ListLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//     if (optionsState is ListError) {
//       return const Center(
//         child: Text('에러가 발생했습니다.'),
//       );
//     }
//
//     final options = (optionsState as ListModel<OptionCategory>).data;
//
//     // final relatedOptions = options
//     //     .map((category) => category.copyWith(
//     //   options: category.options
//     //       .where((option) => treatment.optionIds.contains(option.id))
//     //       .toList(),
//     // ))
//     //     .where((category) => category.options.isNotEmpty)
//     //     .toList();
//
//     return Scaffold(
//       body: Center(
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxWidth: 500,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min, // Adjust based on content size
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               const CommonTitle(
//                 title: '예약자 정보',
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12.5,
//                 ),
//                 child: CommonInputField(
//                   title: '이름',
//                   maxLength: 20,
//                   hint: '이름을 입력해 주세요',
//                   onChanged: (value) {
//                     setState(() {
//                       name = value;
//                     });
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12.5,
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: CommonInputField(
//                         title: '휴대폰 번호',
//                         maxLength: 11,
//                         hint: '전화번호를 입력해 주세요',
//                         onChanged: (value) {
//                           setState(() {
//                             phoneNumber = value;
//                           });
//                         },
//                         isNumber: true,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     InkWell(
//                       onTap: () async {
//                         if (phoneNumber.length == 11) {
//                           setState(() {
//                             codeSent = true;
//                           });
//                           startTimer();
//                         }
//                         FocusScope.of(context).unfocus();
//                       },
//                       child: Container(
//                         height: 45,
//                         width: 85,
//                         decoration: BoxDecoration(
//                           color: phoneNumber.length == 11
//                               ? ContainerColors.black
//                               : ContainerColors.darkGrey,
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                         child: Center(
//                           child: Text(
//                             '인증',
//                             style: TextDesign.medium14W,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12.5,
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Stack(
//                         children: [
//                           CommonInputField(
//                             title: '인증번호',
//                             maxLength: 6,
//                             hint: '인증번호를 입력해 주세요',
//                             onChanged: (value) {
//                               setState(() {
//                                 verificationCode = value;
//                               });
//                             },
//                             isNumber: true,
//                             remainingTime: _start,
//                           ),
//                           Positioned(
//                             right: 16,
//                             top: 0,
//                             bottom: 0,
//                             child: Center(
//                               child:
//                                   CountdownTimerWidget(remainingTime: _start),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     InkWell(
//                       onTap: () async {
//                         if (verificationCode == '999999') {
//                           setState(() {
//                             codeVerified = true;
//                           });
//                         }
//                         startTimer();
//                         FocusScope.of(context).unfocus();
//                       },
//                       child: Container(
//                         height: 45,
//                         width: 85,
//                         decoration: BoxDecoration(
//                           color: verificationCode.length == 6
//                               ? ContainerColors.black
//                               : ContainerColors.darkGrey,
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                         child: Center(
//                           child: Text(
//                             '확인',
//                             style: TextDesign.medium14W,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               ConstWidgets.greyBox(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 20,
//                 ),
//                 child: Column(
//                   children: [
//                     CommonTitle(
//                       title: '선택한 시술',
//                     ),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: selectedTreatments.length,
//                         itemBuilder: (context, index) {
//                           final treatmentCategory = treatments[index];
//                           return TreatmentCategoryWidget(
//                             treatmentCategory: treatmentCategory,
//                             options: options,
//                             selectedTreatments: selectedTreatments,
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class TreatmentCategoryWidget extends StatelessWidget {
//   final TreatmentCategory treatmentCategory;
//   final List<OptionCategory> options;
//   final Map<int, SelectedCategory> selectedTreatments;
//
//   const TreatmentCategoryWidget({
//     super.key,
//     required this.treatmentCategory,
//     required this.options,
//     required this.selectedTreatments,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: Text(treatmentCategory.name),
//       children: treatmentCategory.treatments.map((treatment) {
//         // final treatmentOptions = options
//         //     .where((optionCategory) =>
//         //         treatment.optionIds.contains(optionCategory.options.map((e) => e.id)))
//         //     .toList();
//         // i want all options that the treatment has
//         final treatmentOptions = options
//             .where((optionCategory) => optionCategory.options
//                 .any((option) => treatment.optionIds.contains(option.id)))
//             .toList();
//
//         return TreatmentWidget(
//           treatment: treatment,
//           options: treatmentOptions,
//           selectedTreatments: selectedTreatments,
//         );
//       }).toList(),
//     );
//   }
// }
//
// class TreatmentWidget extends StatelessWidget {
//   final TreatmentModel treatment;
//   final List<OptionCategory> options;
//   final Map<int, SelectedCategory> selectedTreatments;
//
//   const TreatmentWidget({
//     super.key,
//     required this.treatment,
//     required this.options,
//     required this.selectedTreatments,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         title: Text(treatment.name),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(treatment.thumbnail),
//             Text('Duration: ${treatment.duration} minutes'),
//             ...options.map((optionCategory) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: optionCategory.options.map((option) {
//                   return Text('${option.name}: ${option.description}');
//                 }).toList(),
//               );
//             }).toList(),
//           ],
//         ),
//         trailing: Text('${treatment.minPrice} 원'),
//       ),
//     );
//   }
// }
//
// class CommonInputField extends StatelessWidget {
//   final String title;
//   final int maxLength;
//   final String? initialText;
//   final String hint;
//   final Function(String) onChanged;
//   final bool isNumber;
//   final int? remainingTime;
//
//   const CommonInputField({
//     super.key,
//     required this.title,
//     required this.maxLength,
//     this.initialText,
//     required this.hint,
//     required this.onChanged,
//     this.isNumber = false,
//     this.remainingTime,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 70,
//           child: Text(
//             title,
//             style: TextDesign.medium14G,
//             textAlign: TextAlign.left,
//           ),
//         ),
//         Expanded(
//           child: SizedBox(
//             height: 45, // Ensure fixed height for the input field
//             child: TextFormField(
//               scrollPadding: const EdgeInsets.only(bottom: 100),
//               maxLength: maxLength,
//               initialValue: initialText,
//               style: TextDesign.medium14G,
//               keyboardType:
//                   isNumber ? TextInputType.number : TextInputType.text,
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: ContainerColors.mediumGrey,
//                 hintText: hint,
//                 hintStyle: TextDesign.medium14G,
//                 border: InputBorder.none,
//                 counterText: '',
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//               ),
//               cursorColor: StrokeColors.black,
//               onChanged: onChanged,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class CountdownTimerWidget extends StatelessWidget {
//   final int remainingTime;
//
//   const CountdownTimerWidget({
//     super.key,
//     required this.remainingTime,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
//     final seconds = (remainingTime % 60).toString().padLeft(2, '0');
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Text(
//         '$minutes:$seconds',
//         style: const TextStyle(
//           color: Colors.red, // Set the timer color to red as in the image
//           fontSize: 16, // Adjust the font size as needed
//         ),
//       ),
//     );
//   }
// }
//
// class CommonTitle extends StatelessWidget {
//   final String title;
//
//   const CommonTitle({
//     super.key,
//     required this.title,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 45,
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: Text(
//         title,
//         style: TextDesign.bold18B,
//         textAlign: TextAlign.left,
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numaze_web/common/const/widgets.dart';

import 'common/const/colors.dart';
import 'common/const/text.dart';
import 'list_model.dart';
import 'model.dart';
import 'provider.dart';
import 'treatments_provider.dart';

class ReservationDetailsScreen extends ConsumerStatefulWidget {
  final String shopDomain;

  const ReservationDetailsScreen({
    super.key,
    required this.shopDomain,
  });

  @override
  ConsumerState<ReservationDetailsScreen> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<ReservationDetailsScreen> {
  String name = '';
  String phoneNumber = '';
  String verificationCode = '';
  bool codeSent = false;
  bool codeVerified = false;

  Timer? _timer;
  int _start = 180;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboardOpen = bottomInsets != 0;

    final treatmentsState = ref.watch(treatmentProvider(widget.shopDomain));
    final optionsState = ref.watch(optionsProvider(widget.shopDomain));
    final selectedTreatments = ref.watch(selectedTreatmentProvider);

    if (treatmentsState is ListLoading || optionsState is ListLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (treatmentsState is ListError || optionsState is ListError) {
      return const Center(
        child: Text('에러가 발생했습니다.'),
      );
    }

    final treatments = (treatmentsState as ListModel<TreatmentCategory>).data;
    final options = (optionsState as ListModel<OptionCategory>).data;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 500,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              const CommonTitle(
                title: '예약자 정보',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12.5,
                ),
                child: CommonInputField(
                  title: '이름',
                  maxLength: 20,
                  hint: '이름을 입력해 주세요',
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12.5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CommonInputField(
                        title: '휴대폰 번호',
                        maxLength: 11,
                        hint: '전화번호를 입력해 주세요',
                        onChanged: (value) {
                          setState(() {
                            phoneNumber = value;
                          });
                        },
                        isNumber: true,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        if (phoneNumber.length == 11) {
                          setState(() {
                            codeSent = true;
                          });
                          startTimer();
                        }
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        height: 45,
                        width: 85,
                        decoration: BoxDecoration(
                          color: phoneNumber.length == 11
                              ? ContainerColors.black
                              : ContainerColors.darkGrey,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            '인증',
                            style: TextDesign.medium14W,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12.5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          CommonInputField(
                            title: '인증번호',
                            maxLength: 6,
                            hint: '인증번호를 입력해 주세요',
                            onChanged: (value) {
                              setState(() {
                                verificationCode = value;
                              });
                            },
                            isNumber: true,
                            remainingTime: _start,
                          ),
                          Positioned(
                            right: 16,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child:
                                  CountdownTimerWidget(remainingTime: _start),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        if (verificationCode == '999999') {
                          setState(() {
                            codeVerified = true;
                          });
                        }
                        startTimer();
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        height: 45,
                        width: 85,
                        decoration: BoxDecoration(
                          color: verificationCode.length == 6
                              ? ContainerColors.black
                              : ContainerColors.darkGrey,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            '확인',
                            style: TextDesign.medium14W,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ConstWidgets.greyBox(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    CommonTitle(
                      title: '선택한 시술',
                    ),
                    // Use Flexible to handle ListView inside a Column
                    SizedBox(
                      height: 600,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: selectedTreatments.length,
                        itemBuilder: (context, index) {
                          final selectedCategory =
                              selectedTreatments.entries.toList()[index];
                          final selectedTreatment =
                              selectedCategory.value.selectedTreatments.first;

                          final treatment = treatments
                              .expand((category) => category.treatments)
                              .firstWhere(
                                  (t) => t.id == selectedTreatment.treatmentId);

                          final treatmentOptions = options
                              .where((optionCategory) => optionCategory.options
                                  .any((option) =>
                                      treatment.optionIds.contains(option.id)))
                              .toList();

                          print(treatment.name);

                          return TreatmentWidget(
                            treatment: treatment,
                            options: treatmentOptions,
                            selectedTreatments: selectedTreatments,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TreatmentWidget extends StatelessWidget {
  final TreatmentModel treatment;
  final List<OptionCategory> options;
  final Map<int, SelectedCategory> selectedTreatments;

  const TreatmentWidget({
    super.key,
    required this.treatment,
    required this.options,
    required this.selectedTreatments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListTile(
        title: Text(treatment.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(treatment.thumbnail),
            Text('Duration: ${treatment.duration} minutes'),
            ...options.map((optionCategory) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: optionCategory.options.map((option) {
                  return Text('${option.name}: ${option.description}');
                }).toList(),
              );
            }),
          ],
        ),
        trailing: Text('${treatment.minPrice} 원'),
      ),
    );
  }
}

class CommonInputField extends StatelessWidget {
  final String title;
  final int maxLength;
  final String? initialText;
  final String hint;
  final Function(String) onChanged;
  final bool isNumber;
  final int? remainingTime;

  const CommonInputField({
    super.key,
    required this.title,
    required this.maxLength,
    this.initialText,
    required this.hint,
    required this.onChanged,
    this.isNumber = false,
    this.remainingTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            title,
            style: TextDesign.medium14G,
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 45, // Ensure fixed height for the input field
            child: TextFormField(
              scrollPadding: const EdgeInsets.only(bottom: 100),
              maxLength: maxLength,
              initialValue: initialText,
              style: TextDesign.medium14G,
              keyboardType:
                  isNumber ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: ContainerColors.mediumGrey,
                hintText: hint,
                hintStyle: TextDesign.medium14G,
                border: InputBorder.none,
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              cursorColor: StrokeColors.black,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class CountdownTimerWidget extends StatelessWidget {
  final int remainingTime;

  const CountdownTimerWidget({
    super.key,
    required this.remainingTime,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = (remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingTime % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        '$minutes:$seconds',
        style: const TextStyle(
          color: Colors.red, // Set the timer color to red as in the image
          fontSize: 16, // Adjust the font size as needed
        ),
      ),
    );
  }
}

class CommonTitle extends StatelessWidget {
  final String title;

  const CommonTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: TextDesign.bold18B,
        textAlign: TextAlign.left,
      ),
    );
  }
}
