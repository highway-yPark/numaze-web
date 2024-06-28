import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:dio/dio.dart';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:numaze_web/common/const/widgets.dart';
import 'package:numaze_web/repository.dart';
import 'package:numaze_web/utils.dart';

import 'common/const/colors.dart';
import 'common/const/text.dart';
import 'list_model.dart';
import 'model.dart';
import 'provider.dart';
import 'time_slots_provider.dart';
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

  int duration = 0;

  late TextEditingController customerRequestController;

  Uint8List? imageOne;
  Uint8List? imageTwo;
  Uint8List? imageThree;
  Uint8List? imageFour;
  Uint8List? imageFive;

  // bool isLoading = false;
  //
  // Future<void> pickAndCropImage(int index) async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //
  //     Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
  //
  //     if (bytesFromPicker != null) {
  //       Uint8List processedImage = await compute(processImage, bytesFromPicker);
  //       setState(() {
  //         switch (index) {
  //           case 1:
  //             imageOne = processedImage;
  //             break;
  //           case 2:
  //             imageTwo = processedImage;
  //             break;
  //           case 3:
  //             imageThree = processedImage;
  //             break;
  //           case 4:
  //             imageFour = processedImage;
  //             break;
  //           case 5:
  //             imageFive = processedImage;
  //             break;
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     print('An error occurred while picking images: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  bool isLoadingOne = false;
  bool isLoadingTwo = false;
  bool isLoadingThree = false;
  bool isLoadingFour = false;
  bool isLoadingFive = false;

  int heavyComputation(int input) {
    // Simulate a heavy computation task
    int result = 0;
    for (int i = 0; i < input; i++) {
      result += i;
    }
    return result;
  }

  void _runComputation(Uint8List image) async {
    Uint8List result = await compute(processImage, image);
    setState(() {
      imageOne = result;
    });
  }

  Future<void> pickAndCropImage(int index) async {
    try {
      setState(() {
        switch (index) {
          case 1:
            isLoadingOne = true;
            // _runComputation;
            break;
          case 2:
            isLoadingTwo = true;
            break;
          case 3:
            isLoadingThree = true;
            break;
          case 4:
            isLoadingFour = true;
            break;
          case 5:
            isLoadingFive = true;
            break;
        }
      });

      Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();

      if (bytesFromPicker != null) {
        setState(() {
          switch (index) {
            case 1:
              imageOne = processImage(bytesFromPicker);
              // _runComputation(bytesFromPicker);
              break;
            case 2:
              imageTwo = processImage(bytesFromPicker);
              break;
            case 3:
              imageThree = processImage(bytesFromPicker);
              break;
            case 4:
              imageFour = processImage(bytesFromPicker);
            case 5:
              imageFive = processImage(bytesFromPicker);
              break;
          }
        });
      }
    } catch (e) {
      print('An error occurred while picking images: $e');
    } finally {
      setState(() {
        switch (index) {
          case 1:
            isLoadingOne = false;
            break;
          case 2:
            isLoadingTwo = false;
            break;
          case 3:
            isLoadingThree = false;
            break;
          case 4:
            isLoadingFour = false;
            break;
          case 5:
            isLoadingFive = false;
            break;
        }
      });
    }
  }

  // List<Uint8List> images = [];

  // Future<void> pickAndCropImages() async {
  //   try {
  //     int remainingSlots = 5 - images.length;
  //     if (remainingSlots <= 0) {
  //       // Display a message if the user tries to pick more than the allowed number of images
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('You can only pick up to 5 images.')),
  //       );
  //       return;
  //     }
  //
  //     // FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     //   allowMultiple: true,
  //     //   type: FileType.image,
  //     //   withData: true,
  //     // );
  //     Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
  //
  //     if (bytesFromPicker != null) {
  //       setState(() {
  //         images.add(processImage(bytesFromPicker));
  //       });
  //     }
  //
  //     // if (result != null && result.files.isNotEmpty) {
  //     //   // List<Uint8List> selectedImages = result.files
  //     //   //     .take(remainingSlots)
  //     //   //     .map((file) => processImage(file.bytes!))
  //     //   //     .toList();
  //     //
  //     //   int pickedCount = result.files.length;
  //     //
  //     //   if (pickedCount > remainingSlots) {
  //     //     ScaffoldMessenger.of(context).showSnackBar(
  //     //       SnackBar(
  //     //           content: Text(
  //     //               'You can only pick up to $remainingSlots more images.')),
  //     //     );
  //     //     return;
  //     //   }
  //     //
  //     //   // List<Uint8List> selectedImages =
  //     //   //     result.files.map((file) => processImage(file.bytes!)).toList();
  //     //
  //     //   List<Uint8List> selectedImages =
  //     //       result.files.map((file) => file.bytes!).toList();
  //     //
  //     //   setState(() {
  //     //     images.addAll(selectedImages);
  //     //   });
  //     // }
  //   } catch (e) {
  //     print('An error occurred while picking images: $e');
  //   }
  // }

  Uint8List processImage(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes)!;

    const size = 720;

    int x, y, cropSize;
    if (image.width > image.height) {
      cropSize = image.height;
      x = (image.width - cropSize) ~/ 2;
      y = 0;
    } else {
      cropSize = image.width;
      x = 0;
      y = (image.height - cropSize) ~/ 2;
    }

    final cropped = img.copyCrop(
      image,
      x: x,
      y: y,
      width: cropSize,
      height: cropSize,
    );

    final resized = img.copyResize(
      cropped,
      width: size,
      height: size,
      interpolation: img.Interpolation.cubic,
    );

    return Uint8List.fromList(img.encodeJpg(resized, quality: 80));
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            codeSent = false;
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
    customerRequestController = TextEditingController();
    duration = ref.read(durationProvider);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    customerRequestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboardOpen = bottomInsets != 0;

    final treatmentsState = ref.watch(treatmentProvider(widget.shopDomain));
    final optionsState = ref.watch(optionsProvider(widget.shopDomain));
    final selectedTreatments = ref.watch(selectedTreatmentProvider);
    final shopMessagesState = ref.watch(shopMessageProvider(widget.shopDomain));

    final selectedDateTime = ref.watch(selectedDateTimeProvider);
    final selectedDesigner = ref.watch(selectedDesignerProvider);
    if (treatmentsState is ListLoading ||
        optionsState is ListLoading ||
        shopMessagesState is ShopMessageLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (treatmentsState is ListError ||
        optionsState is ListError ||
        shopMessagesState is ShopMessageError) {
      return const Center(
        child: Text('에러가 발생했습니다.'),
      );
    }

    if (selectedDateTime.selectedDate == null ||
        selectedDateTime.selectedTimeSlot == null ||
        selectedTreatments.isEmpty) {
      context.go('/s/${widget.shopDomain}');
    }

    final treatments = (treatmentsState as ListModel<TreatmentCategory>).data;
    final options = (optionsState as ListModel<OptionCategory>).data;
    final shopMessages = shopMessagesState as ShopMessageInfo;

    final buttonColor = name.isEmpty ||
            phoneNumber.isEmpty ||
            verificationCode.isEmpty ||
            !codeVerified ||
            selectedTreatments.isEmpty
        ? Colors.grey
        : Colors.black;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 57,
                  child: InkWell(
                    onTap: () {
                      if (buttonColor == Colors.black) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            // return FutureBuilder<List<Uint8List>>(
                            //   future: processImages(images),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.connectionState ==
                            //         ConnectionState.waiting) {
                            //       return Center(
                            //           child: CircularProgressIndicator());
                            //     } else if (snapshot.hasError) {
                            //       return Center(
                            //           child: Text('Error processing images'));
                            //     } else {
                            //       final resizedImages = snapshot.data!;
                            //       return ReservationBottomSheet(
                            //         shopDomain: widget.shopDomain,
                            //         shopMessages: shopMessages,
                            //         name: name,
                            //         phoneNumber: phoneNumber,
                            //         customerRequest:
                            //             customerRequestController.text,
                            //         images: resizedImages,
                            //       );
                            //     }
                            //   },
                            // );
                            // final resizedImages = images
                            //     .map((image) => processImage(image))
                            //     .toList();
                            // combine the non null ones out of five images into a list of Uint8List
                            final images = [
                              imageOne,
                              imageTwo,
                              imageThree,
                              imageFour,
                              imageFive,
                            ].whereType<Uint8List>().toList();
                            print(images.length);
                            return ReservationBottomSheet(
                              shopDomain: widget.shopDomain,
                              shopMessages: shopMessages,
                              name: name,
                              phoneNumber: phoneNumber,
                              customerRequest: customerRequestController.text,
                              images: images,
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      color: buttonColor,
                      child: Center(
                        child: Text(
                          '다음',
                          style: TextDesign.bold16W,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 57,
                child: ListView(
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
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              if (phoneNumber.length == 11) {
                                setState(() {
                                  codeSent = true;
                                });
                                if (_start == 0) {
                                  _start = 180;
                                }
                                // only start the timer if time is not running
                                if (_start == 180) {
                                  startTimer();
                                }
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
                                  _start > 0 ? '인증' : '재전송',
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
                                    if (codeSent) {
                                      setState(() {
                                        verificationCode = value;
                                      });
                                    }
                                  },
                                  isNumber: true,
                                  remainingTime: _start,
                                ),
                                Positioned(
                                  right: 16,
                                  top: 0,
                                  bottom: 0,
                                  child: Center(
                                    child: CountdownTimerWidget(
                                        remainingTime: _start),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              if (verificationCode == '999999' && codeSent) {
                                print('verify code');
                                setState(() {
                                  codeVerified = true;
                                });
                              }
                              FocusScope.of(context).unfocus();
                            },
                            child: Container(
                              height: 45,
                              width: 85,
                              decoration: BoxDecoration(
                                color: verificationCode.length == 6 && codeSent
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Column(
                        children: [
                          const CommonTitle(
                            title: '요청사항',
                          ),
                          TextFormField(
                            controller: customerRequestController,
                            scrollPadding: const EdgeInsets.only(bottom: 100),
                            maxLength: 300,
                            style: TextDesign.medium14G,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: ContainerColors.mediumGrey,
                              hintStyle: TextDesign.medium14G,
                              border: InputBorder.none,
                              counterText: '',
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            cursorColor: StrokeColors.black,
                            maxLines: null,
                            onTapOutside: (PointerDownEvent event) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                          // i want to show selected images with x button at top right corner to delete the image
                          // i want to show a button to add more images
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            children: [
                              _buildImageBox(imageOne, isLoadingOne, 1),
                              _buildImageBox(imageTwo, isLoadingTwo, 2),
                              _buildImageBox(imageThree, isLoadingThree, 3),
                              _buildImageBox(imageFour, isLoadingFour, 4),
                              _buildImageBox(imageFive, isLoadingFive, 5),
                            ],
                          ),
                          // if (images.isNotEmpty)
                          //   Column(
                          //     children: [
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       SizedBox(
                          //         height: 74,
                          //         child: ListView.builder(
                          //           scrollDirection: Axis.horizontal,
                          //           itemCount: images.length,
                          //           itemBuilder: (context, index) {
                          //             final image = images[index];
                          //             return Container(
                          //               margin:
                          //                   const EdgeInsets.only(right: 10),
                          //               height: 74,
                          //               width: 74,
                          //               child: Stack(
                          //                 children: [
                          //                   Positioned(
                          //                     left: 0,
                          //                     bottom: 0,
                          //                     child: Image.memory(
                          //                       image,
                          //                       width: 64,
                          //                       height: 64,
                          //                       fit: BoxFit.cover,
                          //                     ),
                          //                   ),
                          //                   Positioned(
                          //                     top: 0,
                          //                     right: 0,
                          //                     child: GestureDetector(
                          //                       onTap: () {
                          //                         setState(() {
                          //                           images.removeAt(index);
                          //                         });
                          //                       },
                          //                       child: const Icon(
                          //                         Icons.close_outlined,
                          //                         size: 16,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             );
                          //             // return Stack(
                          //             //   children: [
                          //             //     Positioned(
                          //             //       left: 0,
                          //             //       bottom: 0,
                          //             //       child: Container(
                          //             //         height: 64,
                          //             //         width: 64,
                          //             //         decoration: BoxDecoration(
                          //             //           image: DecorationImage(
                          //             //             image: MemoryImage(image),
                          //             //             fit: BoxFit.cover,
                          //             //           ),
                          //             //         ),
                          //             //       ),
                          //             //     ),
                          //             //     Positioned(
                          //             //       top: 0,
                          //             //       right: 0,
                          //             //       child: GestureDetector(
                          //             //         onTap: () {
                          //             //           setState(() {
                          //             //             images.removeAt(index);
                          //             //           });
                          //             //         },
                          //             //         child: const Icon(
                          //             //           Icons.close_outlined,
                          //             //           size: 16,
                          //             //         ),
                          //             //       ),
                          //             //       // IconButton(
                          //             //       //   onPressed: () {
                          //             //       //     setState(() {
                          //             //       //       images.removeAt(index);
                          //             //       //     });
                          //             //       //   },
                          //             //       //   icon: const Icon(Icons.close_outlined),
                          //             //       // ),
                          //             //     ),
                          //             //   ],
                          //             // );
                          //           },
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // // Use Flexible to handle ListView inside a Column
                          // if (images.length < 5)
                          //   Column(
                          //     children: [
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       InkWell(
                          //         onTap: pickAndCropImages,
                          //         child: Container(
                          //           height: 50,
                          //           width: MediaQuery.of(context).size.width,
                          //           decoration: BoxDecoration(
                          //             border: Border.all(
                          //               color: StrokeColors.grey,
                          //               width: 1,
                          //             ),
                          //             borderRadius: BorderRadius.circular(3),
                          //           ),
                          //           child: Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.center,
                          //             children: [
                          //               const Icon(
                          //                 Icons.add,
                          //                 color: BrandColors.orange,
                          //                 size: 10,
                          //               ),
                          //               const SizedBox(width: 10),
                          //               Text(
                          //                 '사진 추가',
                          //                 style: TextDesign.medium14B,
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                        ],
                      ),
                    ),
                    ConstWidgets.greyBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Column(
                        children: [
                          const CommonTitle(
                            title: '선택한 시술',
                          ),
                          // Use Flexible to handle ListView inside a Column
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: selectedTreatments.length,
                            itemBuilder: (context, index) {
                              final selectedCategory =
                                  selectedTreatments.entries.toList()[index];
                              final selectedTreatment = selectedCategory
                                  .value.selectedTreatments.first;

                              final treatment = treatments
                                  .expand((category) => category.treatments)
                                  .firstWhere((t) =>
                                      t.id == selectedTreatment.treatmentId);

                              final selectedOptions = options
                                  .map((category) => category.copyWith(
                                        options: category.options
                                            .where((option) => selectedTreatment
                                                .selectedOptions.values
                                                .contains(option.id))
                                            .toList(),
                                      ))
                                  .toList();

                              selectedOptions.removeWhere(
                                  (element) => element.options.isEmpty);

                              final categoryName = treatments
                                  .firstWhere((category) =>
                                      category.id == selectedCategory.key)
                                  .name;

                              // if (duration == 0) {
                              //   final optionDuration = selectedOptions
                              //           .isNotEmpty
                              //       ? selectedOptions
                              //           .map((e) => e.options.first)
                              //           .map((e) => e.duration)
                              //           .reduce(
                              //               (value, element) => value + element)
                              //       : 0;
                              //   duration +=
                              //       (optionDuration + treatment.duration);
                              // }

                              return Column(
                                children: [
                                  TreatmentWidget(
                                    categoryName: categoryName,
                                    treatment: treatment,
                                    options: selectedOptions,
                                    thumbnail: selectedTreatment.styleImage ==
                                            null
                                        ? selectedTreatment.monthlyPickImage ==
                                                null
                                            ? selectedTreatment
                                                        .treatmentStyleImage ==
                                                    null
                                                ? treatment.thumbnail
                                                : selectedTreatment
                                                    .treatmentStyleImage!
                                            : selectedTreatment
                                                .monthlyPickImage!
                                        : selectedTreatment.styleImage!,
                                    //treatmentOptions,
                                    // selectedTreatments: selectedTreatments,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    ConstWidgets.greyBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Column(
                        children: [
                          const CommonTitle(
                            title: '예약 정보',
                          ),
                          TextWithTitle(
                              title: '날짜',
                              text: DataUtils.formatDateWithDay(
                                  selectedDateTime.selectedDate!)),
                          TextWithTitle(
                            title: '시간',
                            text: DataUtils.convertTime(
                              selectedDateTime.selectedTimeSlot!,
                              duration,
                            ),
                          ),
                          if (selectedDesigner != null)
                            TextWithTitle(
                              title: '디자이너',
                              text: selectedDesigner.designerNickname,
                            ),
                          // Use Flexible to handle ListView inside a Column
                        ],
                      ),
                      // ListView.builder(
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   shrinkWrap: true,
                      //   itemCount: 1,
                      //   itemBuilder: (context, index) {
                      //     return Column(
                      //       children: [
                      //         const CommonTitle(
                      //           title: '예약 정보',
                      //         ),
                      //         TextWithTitle(
                      //             title: '날짜',
                      //             text: DataUtils.formatDateWithDay(
                      //                 selectedDateTime.selectedDate!)),
                      //         TextWithTitle(
                      //           title: '시간',
                      //           text: DataUtils.convertTime(
                      //             selectedDateTime.selectedTimeSlot!,
                      //             duration,
                      //           ),
                      //         ),
                      //         if (selectedDesigner != null)
                      //           TextWithTitle(
                      //             title: '디자이너',
                      //             text: selectedDesigner.designerNickname,
                      //           ),
                      //         // Use Flexible to handle ListView inside a Column
                      //       ],
                      //     );
                      //   },
                      // ),
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

  Widget _buildImageBox(Uint8List? image, bool isLoading, int index) {
    return GestureDetector(
      onTap: () => pickAndCropImage(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : image != null
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: Image.memory(
                          image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              switch (index) {
                                case 1:
                                  imageOne = null;
                                  break;
                                case 2:
                                  imageTwo = null;
                                  break;
                                case 3:
                                  imageThree = null;
                                  break;
                                case 4:
                                  imageFour = null;
                                  break;
                                case 5:
                                  imageFive = null;
                                  break;
                              }
                            });
                          },
                          child: const Icon(
                            Icons.close_outlined,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.grey,
                    ),
                  ),
      ),
    );
  }
}

class TextWithTitle extends StatelessWidget {
  final String title;
  final String text;
  const TextWithTitle({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextDesign.regular14G,
          ),
          Text(
            text,
            style: TextDesign.medium14B,
          ),
        ],
      ),
    );
  }
}

class TreatmentWidget extends StatelessWidget {
  final String categoryName;
  final TreatmentModel treatment;
  final List<OptionCategory?> options;
  final String thumbnail;
  // final Map<int, SelectedCategory> selectedTreatments;

  const TreatmentWidget({
    super.key,
    required this.categoryName,
    required this.treatment,
    required this.options,
    required this.thumbnail,
    // required this.selectedTreatments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: StrokeColors.grey,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            thumbnail,
            width: 115,
            height: 115,
          ),
          const SizedBox(
              width: 20), // Add some space between the image and the text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$categoryName > ${treatment.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextDesign.bold16B,
                ),
                const SizedBox(
                  height: 10,
                ),
                if (options.isNotEmpty)
                  ...options.map((optionCategory) {
                    return Column(
                      children: [
                        Text(
                          '${optionCategory!.name}: ${optionCategory.options.first.name}',
                          style: TextDesign.medium14G,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                      ],
                    );
                  }),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  DataUtils.formatDurationWithZero(
                    treatment.duration +
                        // options
                        //     .map((e) => e.options.isNotEmpty
                        //         ? e.options.first.duration
                        //         : 0)
                        //     .reduce((value, element) => value + element)),
                        (options.isNotEmpty
                            ? options
                                .map((e) => e!.options.first.duration)
                                .reduce((value, element) => value + element)
                            : 0),
                  ),
                  style: TextDesign.regular14B,
                ),
              ],
            ),
          ),
        ],
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
              // prevent input from desktop as well
              inputFormatters: [
                if (isNumber) FilteringTextInputFormatter.digitsOnly,
              ],
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

class ReservationBottomSheet extends ConsumerStatefulWidget {
  final String shopDomain;
  final ShopMessageInfo shopMessages;
  final String name;
  final String phoneNumber;
  final String customerRequest;
  final List<Uint8List> images;
  const ReservationBottomSheet({
    super.key,
    required this.shopDomain,
    required this.shopMessages,
    required this.name,
    required this.phoneNumber,
    required this.customerRequest,
    required this.images,
  });

  @override
  ConsumerState<ReservationBottomSheet> createState() =>
      _ReservationBottomSheetState();
}

class _ReservationBottomSheetState
    extends ConsumerState<ReservationBottomSheet> {
  bool _depositRuleAccepted = false;
  bool _changeCancelRuleAccepted = false;
  bool _otherInfoAccepted = false;
  bool _serviceAgreementAccepted = false;

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _depositRuleKey = GlobalKey();
  final GlobalKey _changeCancelRuleKey = GlobalKey();
  final GlobalKey _otherInfoKey = GlobalKey();
  final GlobalKey _serviceAgreementKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.shopMessages.hasDeposit) {
      _depositRuleAccepted = true;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToNextCheckbox(GlobalKey currentKey) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = currentKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          alignment: 0.3,
        );
      }
    });
  }

  Uint8List processImage(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes)!;

    const size = 720;

    int x, y, cropSize;
    if (image.width > image.height) {
      cropSize = image.height;
      x = (image.width - cropSize) ~/ 2;
      y = 0;
    } else {
      cropSize = image.width;
      x = 0;
      y = (image.height - cropSize) ~/ 2;
    }

    final cropped = img.copyCrop(
      image,
      x: x,
      y: y,
      width: cropSize,
      height: cropSize,
    );

    final resized = img.copyResize(
      cropped,
      width: size,
      height: size,
      interpolation: img.Interpolation.cubic,
    );

    return Uint8List.fromList(img.encodeJpg(resized, quality: 80));
  }

  TreatmentOptionPair convertToTreatmentOptionPair(
      SelectedTreatment selectedTreatment) {
    return TreatmentOptionPair(
      treatment_id: selectedTreatment.treatmentId,
      option_ids: selectedTreatment.selectedOptions.values.toList(),
      style_id:
          selectedTreatment.styleId ?? (selectedTreatment.treatmentStyleId),
      monthly_pick_id: selectedTreatment.monthlyPickId,
    );
  }

  List<TreatmentOptionPair> collectAndConvert(
      Map<int, SelectedCategory> selectedTreatmentProvider) {
    List<TreatmentOptionPair> treatmentOptionPairs = [];
    selectedTreatmentProvider.forEach((key, selectedCategory) {
      for (var selectedTreatment in selectedCategory.selectedTreatments) {
        treatmentOptionPairs
            .add(convertToTreatmentOptionPair(selectedTreatment));
      }
    });
    return treatmentOptionPairs;
  }

  SelectedTreatmentsRequest createSelectedTreatmentsRequest(
      Map<int, SelectedCategory> selectedTreatmentProvider) {
    List<TreatmentOptionPair> treatmentOptionPairs =
        collectAndConvert(selectedTreatmentProvider);
    return SelectedTreatmentsRequest(
        treatment_option_pairs: treatmentOptionPairs);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 500,
        ),
        child: Stack(
          children: [
            Container(
              color: ContainerColors.white,
              child: ListView(
                controller: _scrollController,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        const Icon(
                          Icons.alarm,
                          size: 62,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          '예약 전 유의 사항',
                          style: TextDesign.bold26B,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          '반드시 하단의 안내 사항을 모두 읽어주세요',
                          style: TextDesign.medium16BO,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          color: ContainerColors.mediumGrey,
                          child: Column(
                            children: [
                              TextWithNumber(
                                text: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: '발송된 ',
                                          style: TextDesign.medium14CG),
                                      TextSpan(
                                        text: '안내 메시지',
                                        style: TextDesign.bold14CG,
                                      ),
                                      TextSpan(
                                        text: '를 반드시 확인해주세요',
                                        style: TextDesign.medium14CG,
                                      ),
                                    ],
                                  ),
                                ),
                                number: '01',
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextWithNumber(
                                text: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: '안내된 계좌번호로 ',
                                          style: TextDesign.medium14CG),
                                      TextSpan(
                                        text: '예약금',
                                        style: TextDesign.bold14CG,
                                      ),
                                      TextSpan(
                                        text: '을 입금해주세요',
                                        style: TextDesign.medium14CG,
                                      ),
                                    ],
                                  ),
                                ),
                                number: '02',
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextWithNumber(
                                text: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '예약자명과 ',
                                        style: TextDesign.medium14CG,
                                      ),
                                      TextSpan(
                                        text: '예금주명',
                                        style: TextDesign.bold14CG,
                                      ),
                                      TextSpan(
                                        text: '을 일치시켜주세요',
                                        style: TextDesign.medium14CG,
                                      ),
                                    ],
                                  ),
                                ),
                                number: '03',
                              ),
                              if (widget.shopMessages.hasDeposit)
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextWithNumber(
                                      text: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '입금 후 ',
                                              style: TextDesign.medium14CG,
                                            ),
                                            TextSpan(
                                              text: '예약 확인 요청 링크',
                                              style: TextDesign.bold14CG,
                                            ),
                                            TextSpan(
                                              text: '를 반드시 눌러주세요',
                                              style: TextDesign.medium14CG,
                                            ),
                                          ],
                                        ),
                                      ),
                                      number: '04',
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  ConstWidgets.greyBox(),
                  if (widget.shopMessages.hasDeposit)
                    Column(
                      children: [
                        buildCheckboxTile(
                          title: '예약금 규정 (필수)',
                          value: _depositRuleAccepted,
                          onChanged: (value) {
                            setState(() {
                              _depositRuleAccepted = value!;
                            });
                            if (value!) {
                              _scrollToNextCheckbox(_changeCancelRuleKey);
                            }
                          },
                          guide: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                '※ 회원권 고객님의 경우 예약금 입금 없이 정액권에서 차감됩니다.',
                                style: TextDesign.medium14BO,
                              ),
                            ],
                          ),
                          key: _depositRuleKey,
                        ),
                        ConstWidgets.greyBox(),
                      ],
                    ),
                  buildCheckboxTile(
                    title: '예약 변경 및 취소 규정',
                    content: widget.shopMessages.reservationMessage,
                    value: _changeCancelRuleAccepted,
                    onChanged: (value) {
                      setState(() {
                        _changeCancelRuleAccepted = value!;
                      });
                      if (value!) {
                        _scrollToNextCheckbox(_otherInfoKey);
                      }
                    },
                    guide: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '※ 예약 변경 및 취소는 ',
                                style: TextDesign.medium14G,
                              ),
                              TextSpan(
                                text: '카카오톡 채널',
                                style: TextDesign.bold14G,
                              ),
                              TextSpan(
                                text: '을 통해 부탁드립니다.',
                                style: TextDesign.medium14G,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    key: _changeCancelRuleKey,
                  ),
                  ConstWidgets.greyBox(),
                  buildCheckboxTile(
                    title: '기타 안내사항',
                    content: widget.shopMessages.additionalMessage,
                    value: _otherInfoAccepted,
                    onChanged: (value) {
                      setState(() {
                        _otherInfoAccepted = value!;
                      });
                      if (value!) {
                        _scrollToNextCheckbox(_serviceAgreementKey);
                      }
                    },
                    guide: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '※ ',
                                style: TextDesign.medium14G,
                              ),
                              TextSpan(
                                text: '예약 확정까지는 일정 시간',
                                style: TextDesign.bold14G,
                              ),
                              TextSpan(
                                text: '이 소요되며, 예약은 샵의 사정으로 인해 취소될 수 있습니다.',
                                style: TextDesign.medium14G,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    key: _otherInfoKey,
                  ),
                  ConstWidgets.greyBox(),
                  buildCheckboxTile(
                    title: '누메이즈 서비스 이용 동의',
                    content:
                        '(주)도두는 통신판매중개자이며 통신판매의 당사자가 아닙니다. (주)도두는 예약 및 구매관련 통신판매업자가 제공하는 상품, 거래정보 및 거래 등에 대하여 책임을 지지 않습니다.',
                    value: _serviceAgreementAccepted,
                    onChanged: (value) {
                      setState(() {
                        _serviceAgreementAccepted = value!;
                      });
                    },
                    key: _serviceAgreementKey,
                  ),
                  const SizedBox(
                    height: 57,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 57,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      if (!_depositRuleAccepted ||
                          !_changeCancelRuleAccepted ||
                          !_otherInfoAccepted ||
                          !_serviceAgreementAccepted) {
                        return;
                      }
                      final designer = ref.read(selectedDesignerProvider);
                      final selectedDateTime =
                          ref.read(selectedDateTimeProvider);
                      final selectedTreatments =
                          ref.read(selectedTreatmentProvider);
                      final resp = await ref
                          .read(repositoryProvider)
                          .createAppointment(
                            shopDomain: widget.shopDomain,
                            request: CustomerNewAppointmentRequest(
                              designer_id: designer?.designerId,
                              appointment_date: selectedDateTime.selectedDate!,
                              start_time: selectedDateTime.selectedTimeSlot!,
                              customer_name: widget.name,
                              customer_phone_number: widget.phoneNumber,
                              customer_request: widget.customerRequest,
                              treatment_option_pairs: collectAndConvert(
                                selectedTreatments,
                              ),
                            ),
                          );

                      List<MultipartFile> multipartFiles =
                          widget.images.map((image) {
                        return MultipartFile.fromBytes(
                          image,
                          filename:
                              '${DateTime.now().millisecondsSinceEpoch}.jpeg',
                          // contentType: MediaType('image', 'jpeg'),
                        );
                      }).toList();

                      ref.read(repositoryProvider).customerRequestImages(
                            appointmentId: resp.data,
                            files: multipartFiles,
                          );

                      if (!context.mounted) return;
                      context.go(
                          '/s/${widget.shopDomain}/complete?appointmentId=${resp.data}');

                      // ref.read(selectedTreatmentProvider.notifier).state = {};
                    },
                    child: Ink(
                      color: _depositRuleAccepted &&
                              _changeCancelRuleAccepted &&
                              _otherInfoAccepted &&
                              _serviceAgreementAccepted
                          ? Colors.black
                          : Colors.grey,
                      child: Center(
                        child: Text(
                          '예약 신청하기',
                          style: TextDesign.bold16W,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCheckboxTile({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    String? content,
    Widget? guide,
    required GlobalKey key,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              customCheckbox(
                value: value,
                onChanged: onChanged,
              ),
              const SizedBox(
                width: 11,
              ),
              Text(
                title,
                style: TextDesign.bold18B,
              ),
              Text(
                ' (필수)',
                style: TextDesign.bold18BO,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          if (content == null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              color: ContainerColors.mediumGrey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '예약금',
                        style: TextDesign.regular14G,
                      ),
                      Text(
                        widget.shopMessages.depositAmount,
                        style: TextDesign.medium14B,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '입금 기한',
                        style: TextDesign.regular14G,
                      ),
                      Text(
                        widget.shopMessages.depositTimeLimit > 0
                            ? '${DataUtils.formatDurationWithZero(
                                widget.shopMessages.depositTimeLimit,
                              )} 이내'
                            : '없음',
                        style: TextDesign.medium14B,
                      )
                    ],
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              color: ContainerColors.mediumGrey,
              child: Text(
                content,
                style: TextDesign.medium14CG,
              ),
            ),
          if (guide != null) guide,
        ],
      ),
    );
  }

  Widget customCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        height: 24,
        width: 24,
        color: value ? BrandColors.orange : ContainerColors.mediumGrey2,
        child: const Icon(
          Icons.check,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}

class TextWithNumber extends StatelessWidget {
  final String number;
  final RichText text;
  const TextWithNumber({
    super.key,
    required this.text,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(number, style: TextDesign.bold14BO),
        const SizedBox(width: 10),
        text,
      ],
    );
  }
}
