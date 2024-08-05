import 'dart:async';
import 'dart:html' as html;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:numaze_web/common/const/icons.dart';
import 'package:numaze_web/common/const/widgets.dart';
import 'package:numaze_web/repository.dart';
import 'package:numaze_web/utils.dart';
import 'package:numaze_web/view/empty_treatment_page.dart';

import '../auth/auth_repository.dart';
import '../common/const/colors.dart';
import '../common/const/text.dart';
import '../components/common_image.dart';
import '../components/common_input_field.dart';
import '../components/common_title.dart';
import '../components/custom_snackbar.dart';
import '../components/inkwell_button.dart';
import '../components/text_with_number.dart';
import '../main.dart';
import '../model/list_model.dart';
import '../model/model.dart';
import '../provider/provider.dart';
import '../provider/time_slots_provider.dart';
import '../provider/treatments_provider.dart';

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
  TextEditingController verificationCodeController = TextEditingController();
  bool codeVerified = false;
  bool codeNotMatch = false;

  Timer? _timer;
  int _start = 180;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer?.cancel();
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            codeVerified = false;
            // customSnackBar(
            //   message: '인증번호 유효시간이 만료되었어요.',
            //   context: context,
            //   error: true,
            // );
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future<void> sendVerificationCode(BuildContext context, WidgetRef ref) async {
    if (phoneNumber.length == 11) {
      final resp = await ref
          .read(authRepositoryProvider)
          .sendVerificationCode(phoneNumber: phoneNumber, register: false);
      if (!context.mounted) return;
      if (resp == 200) {
        setState(() {
          codeVerified = false;
          // verificationCode = '';
          verificationCodeController.clear();
        });
        if (_timer != null && _start < 180) {
          _start = 180;
        }
        startTimer();
      } else if (resp == 400) {
        /** for register only
         * 400: PHONE_NUMBER_ALREADY_REGISTERED
         */
        customSnackBar(
          message: '이미 등록된 전화번호 입니다',
          context: context,
          error: true,
        );
      } else {
        customSnackBar(
            message: '잠시 후 다시 시도해주세요', context: context, error: true);
      }
    } else if (phoneNumber.length == 11 && _start == 0) {
      setState(() {
        codeVerified = false;
        codeNotMatch = false;
        _start = 180;
        _timer?.cancel();
        // verificationCode = '';
        verificationCodeController.clear();
      });
    }
    FocusScope.of(context).unfocus();
  }

  Future<void> verifyCode(BuildContext context, WidgetRef ref) async {
    if (_start > 0 && _start < 180) {
      final resp =
          await ref.read(authRepositoryProvider).verifyVerificationCode(
                phoneNumber: phoneNumber,
                // code: verificationCode,
                code: verificationCodeController.text,
              );
      if (!context.mounted) return;
      if (resp == 200) {
        setState(() {
          codeVerified = true;
          codeNotMatch = false;
        });
        // widget.onVerified(phoneNumber);
      } else if (resp == 400) {
        setState(() {
          codeNotMatch = true;
          codeVerified = false;
        });
      } else {
        setState(() {
          codeVerified = false;
        });
        errorSnackBar(
          context: context,
        );
      }
    }
    FocusScope.of(context).unfocus();
  }

  int duration = 0;

  late TextEditingController customerRequestController;

  Uint8List? imageOne;
  Uint8List? imageTwo;
  Uint8List? imageThree;
  Uint8List? imageFour;

  bool isLoadingOne = false;
  bool isLoadingTwo = false;
  bool isLoadingThree = false;
  bool isLoadingFour = false;

  // Future<void> pickAndCropImage(int index) async {
  //   try {
  //     setState(() {
  //       switch (index) {
  //         case 1:
  //           isLoadingOne = true;
  //           break;
  //         case 2:
  //           isLoadingTwo = true;
  //           break;
  //         case 3:
  //           isLoadingThree = true;
  //           break;
  //         case 4:
  //           isLoadingFour = true;
  //           break;
  //       }
  //     });
  //
  //     // Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
  //     final imagePicker = ImagePickerPlugin();
  //     // final imagePicker = ImagePicker();
  //     final pickedFile = await imagePicker.getImageFromSource(
  //       source: ImageSource.gallery,
  //       options: const ImagePickerOptions(
  //         maxWidth: 720,
  //         maxHeight: 720,
  //         imageQuality: 100,
  //       ),
  //     );
  //
  //     if (pickedFile != null) {
  //       final bytesFromPicker = await pickedFile.readAsBytes();
  //       setState(() async {
  //         switch (index) {
  //           case 1:
  //             imageOne = await processImage(bytesFromPicker);
  //             break;
  //           case 2:
  //             imageTwo = await processImage(bytesFromPicker);
  //             break;
  //           case 3:
  //             imageThree = await processImage(bytesFromPicker);
  //             break;
  //           case 4:
  //             imageFour = await processImage(bytesFromPicker);
  //         }
  //       });
  //     } else {
  //       setState(() {
  //         switch (index) {
  //           case 1:
  //             isLoadingOne = false;
  //             break;
  //           case 2:
  //             isLoadingTwo = false;
  //             break;
  //           case 3:
  //             isLoadingThree = false;
  //             break;
  //           case 4:
  //             isLoadingFour = false;
  //             break;
  //         }
  //       });
  //     }
  //   } catch (e) {
  //     showError();
  //   } finally {
  //     setState(() {
  //       switch (index) {
  //         case 1:
  //           isLoadingOne = false;
  //           break;
  //         case 2:
  //           isLoadingTwo = false;
  //           break;
  //         case 3:
  //           isLoadingThree = false;
  //           break;
  //         case 4:
  //           isLoadingFour = false;
  //           break;
  //       }
  //     });
  //   }
  // }
  Future<void> pickAndCropImage(int index) async {
    try {
      // Set loading state before starting the image processing
      setState(() {
        switch (index) {
          case 1:
            isLoadingOne = true;
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
        }
      });

      // Pick the image
      final imagePicker = ImagePickerPlugin();
      final pickedFile = await imagePicker.getImageFromSource(
        source: ImageSource.gallery,
        options: const ImagePickerOptions(
          maxWidth: 720,
          maxHeight: 720,
          imageQuality: 80,
        ),
      );

      // If an image is picked, process it
      if (pickedFile != null) {
        final bytesFromPicker = await pickedFile.readAsBytes();
        // final processedImage = await processImage(bytesFromPicker);
        final processedImage = processImage(bytesFromPicker);

        // Update the state with the processed image
        setState(() {
          switch (index) {
            case 1:
              imageOne = processedImage;
              break;
            case 2:
              imageTwo = processedImage;
              break;
            case 3:
              imageThree = processedImage;
              break;
            case 4:
              imageFour = processedImage;
              break;
          }
        });
      } else {
        // Reset the loading state if no image was picked
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
          }
        });
      }
    } catch (e) {
      showError();
    } finally {
      // Reset the loading state
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
        }
      });
    }
  }

  void showError() {
    errorSnackBar(context: context);
  }

  Uint8List processImage(Uint8List imageBytes) {
    final image = img.decodeImage(imageBytes)!;

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

    return Uint8List.fromList(
      img.encodeJpg(
        // resized,
        cropped,
        quality: 80,
      ),
    );
  }
  // Future<Uint8List> processImage(Uint8List imageBytes) async {
  //   try {
  //     // Compress the image using flutter_image_compress
  //     final compressedImageBytes = await FlutterImageCompress.compressWithList(
  //       imageBytes,
  //       quality: 80,
  //       format: CompressFormat.jpeg,
  //     );
  //
  //     final image = img.decodeImage(compressedImageBytes);
  //
  //     if (image != null && image.width > image.height) {
  //       // final cropped = img.copyCrop(
  //       //   image,
  //       //   x: (image.width - image.height) ~/ 2,
  //       //   y: 0,
  //       //   width: image.height,
  //       //   height: image.height,
  //       // );
  //       // crop center
  //       final cropped = img.copyCrop(
  //         image,
  //         x: (image.width - image.height) ~/ 2,
  //         y: 0,
  //         width: image.height,
  //         height: image.height,
  //       );
  //       return Uint8List.fromList(
  //         img.encodeJpg(cropped, quality: 80),
  //       );
  //     }
  //     return compressedImageBytes;
  //   } catch (e) {
  //     debugPrint('Error compressing image: $e');
  //     if (!context.mounted) return imageBytes;
  //     showDialog(
  //       context: context,
  //       builder: (context) => Dialog(
  //         child: Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: Text(
  //             e.toString(),
  //           ),
  //         ),
  //       ),
  //     );
  //     showError(); // Assuming showError is a custom function to handle errors
  //     return imageBytes; // Return the original image if compression fails
  //   }
  // }

  int sumOfEachTreatmentOptionDuration(TreatmentHistoryResponse treatment) {
    int sum = 0;
    sum += treatment.treatmentDuration;
    if (treatment.options != null) {
      for (var option in treatment.options!) {
        sum += option.optionDuration;
      }
    }
    return sum;
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
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;

    final selectedTreatments = ref.watch(selectedTreatmentProvider);

    final selectedDateTime = ref.watch(selectedDateTimeProvider);
    final selectedDesigner = ref.watch(selectedDesignerProvider);

    if (selectedDateTime.selectedDate == null ||
        selectedDateTime.selectedTimeSlot == null ||
        selectedTreatments.isEmpty) {
      imageOne = null;
      imageTwo = null;
      imageThree = null;
      imageFour = null;

      return EmptyTreatmentPage(
        shopDomain: widget.shopDomain,
      );
    }

    final treatmentsState = ref.watch(treatmentProvider(widget.shopDomain));
    final optionsState = ref.watch(optionsProvider(widget.shopDomain));
    final shopMessagesState = ref.watch(shopMessageProvider(widget.shopDomain));

    if (treatmentsState is ListLoading ||
        optionsState is ListLoading ||
        shopMessagesState is ShopMessageLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: StrokeColors.black,
        ),
      );
    }
    if (treatmentsState is ListError ||
        optionsState is ListError ||
        shopMessagesState is ShopMessageError) {
      return const Center(
        child: Text('에러가 발생했습니다.'),
      );
    }

    final treatments = (treatmentsState as ListModel<TreatmentCategory>).data;
    final options = (optionsState as ListModel<OptionCategory>).data;
    final shopMessages = shopMessagesState as ShopMessageInfo;

    final buttonColor = name.trim().isEmpty ||
            phoneNumber.trim().isEmpty ||
            // verificationCode.isEmpty ||
            verificationCodeController.text.trim().isEmpty ||
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
              // if (!isKeyboardOpen)

              Positioned.fill(
                // bottom: 72,
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: CommonWidgets.sixteenTenPadding(),
                          child: const CommonTitle(
                            title: '선택한 시술',
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: selectedTreatments.length,
                          itemBuilder: (context, index) {
                            final selectedCategory =
                                selectedTreatments.entries.toList()[index];

                            final selectedTreatment =
                                selectedCategory.value.selectedTreatments.first;

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

                            /// 0 is treatment, 1 is style, 2 is monthly pick
                            int treatmentType = selectedTreatment.styleId ==
                                        null &&
                                    selectedTreatment.treatmentStyleId == null
                                ? selectedTreatment.monthlyPickId == null
                                    ? 0
                                    : 2
                                : 1;

                            return Column(
                              children: [
                                TreatmentWidget(
                                  categoryName: categoryName,
                                  treatment: treatment,
                                  treatmentType: treatmentType,
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
                                          : selectedTreatment.monthlyPickImage!
                                      : selectedTreatment.styleImage!,
                                  //treatmentOptions,
                                  // selectedTreatments: selectedTreatments,
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ConstWidgets.greyBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: CommonWidgets.sixteenTenPadding(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              bottom: 10,
                            ),
                            child: CommonTitle(
                              title: '예약 정보',
                            ),
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
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ConstWidgets.greyBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: CommonWidgets.sixteenTenPadding(),
                      child: const CommonTitle(
                        title: '예약자 정보',
                      ),
                    ),
                    Padding(
                      padding: CommonWidgets.sixteenTenPadding(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 81,
                            child: Text(
                              '이름',
                              style: TextDesign.medium14G,
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CommonInputField(
                              maxLength: 10,
                              // controller: nameController,
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                              isLogin: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: CommonWidgets.sixteenTenPadding(),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 81,
                            child: Text(
                              '전화번호',
                              style: TextDesign.medium14G,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: CommonInputField(
                              onChanged: (value) {
                                setState(() {
                                  phoneNumber = value;
                                  codeVerified = false;
                                });
                              },
                              isPhoneNumber: true,
                              maxLength: 11,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              await sendVerificationCode(context, ref);
                              verificationCodeController.clear();
                            },
                            child: Container(
                              height: 44,
                              width: 85,
                              decoration: BoxDecoration(
                                color: phoneNumber.length == 11
                                    ? ContainerColors.black
                                    : ContainerColors.darkGrey,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Center(
                                child: Text(
                                  _start == 180 ? '인증' : '재인증',
                                  style: TextDesign.medium14W,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: CommonWidgets.sixteenTenPadding(),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 81,
                                child: Text(
                                  '인증번호',
                                  style: TextDesign.medium14G,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Stack(
                                  children: [
                                    CommonInputField(
                                      controller: verificationCodeController,
                                      maxLength: 6,
                                      isPhoneNumber: true,
                                    ),
                                    if (_start < 180 &&
                                        _start > 0 &&
                                        !codeVerified)
                                      Positioned(
                                        right: 17,
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: CountdownTimerWidget(
                                            remainingTime: _start,
                                          ),
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
                                  if (verificationCodeController.text
                                              .trim()
                                              .length ==
                                          6 &&
                                      _start > 0 &&
                                      _start < 180 &&
                                      !codeVerified) {
                                    await verifyCode(context, ref);
                                  }
                                },
                                child: Container(
                                  height: 44,
                                  width: 85,
                                  decoration: BoxDecoration(
                                    color: verificationCodeController.text
                                                    .trim()
                                                    .length ==
                                                6 &&
                                            _start > 0 &&
                                            _start < 180 &&
                                            !codeVerified
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
                          Row(
                            children: [
                              const SizedBox(
                                width: 97,
                              ),
                              if (codeVerified)
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '인증 되었어요.',
                                      style: TextDesign.regular12BO,
                                    ),
                                  ],
                                ),
                              if (_start == 0 && !codeVerified)
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '인증번호 유효시간이 만료되었어요.',
                                      style: TextDesign.regular12BO,
                                    ),
                                  ],
                                ),
                              if (_start > 0 && codeNotMatch)
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '인증번호를 다시 확인해주세요.',
                                      style: TextDesign.regular12BO,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ConstWidgets.greyBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: CommonWidgets.sixteenTenPadding(),
                          child: const CommonTitle(
                            title: '요청사항',
                          ),
                        ),
                        Padding(
                          padding: CommonWidgets.sixteenTenPadding(),
                          child: CommonInputField(
                            controller: customerRequestController,
                            hintText: '요청사항을 입력해주세요',
                            isCentered: false,
                            isPhoneNumber: false,
                            maxLength: 30,
                            isLogin: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: SizedBox(
                            height: 82,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: _buildImageBox(
                                    index == 0
                                        ? imageOne
                                        : index == 1
                                            ? imageTwo
                                            : index == 2
                                                ? imageThree
                                                : imageFour,
                                    index == 0
                                        ? isLoadingOne
                                        : index == 1
                                            ? isLoadingTwo
                                            : index == 2
                                                ? isLoadingThree
                                                : isLoadingFour,
                                    index + 1,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 110,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (bottomInset == 0)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ConditionalInkwellButton(
                    onTap: () {
                      if (buttonColor == Colors.black) {
                        analytics.logEvent(name: 'pop_up_reservation_button');
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            final images = [
                              imageOne,
                              imageTwo,
                              imageThree,
                              imageFour,
                            ].whereType<Uint8List>().toList();
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
                    condition: buttonColor == Colors.grey,
                    text: '다음',
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
        height: 82,
        width: 82,
        decoration: BoxDecoration(
          border: Border.all(
            color: StrokeColors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: isLoading
            ? Container(
                color: ContainerColors.sBGrey,
                child: Center(
                  child: Text(
                    '준비중..',
                    style: TextDesign.medium14G,
                  ),
                ))
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
                              }
                            });
                          },
                          child: CommonIcons.close(),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: SizedBox(
                      height: 28,
                      width: 28,
                      child: CommonIcons.add(),
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
  final int treatmentType;
  final List<OptionCategory?> options;
  final String thumbnail;
  // final Map<int, SelectedCategory> selectedTreatments;

  const TreatmentWidget({
    super.key,
    required this.categoryName,
    required this.treatment,
    required this.treatmentType,
    required this.options,
    required this.thumbnail,
    // required this.selectedTreatments,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9.0, left: 15, right: 15),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: CommonWidgets.greyBorder(ContainerColors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  DataUtils.getTreatmentText(treatmentType),
                  style: TextDesign.bold14B,
                ),
                Text(
                  ' 예약',
                  style: TextDesign.medium14B,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CommonWidgets.customDivider(StrokeColors.lightGrey),
            const SizedBox(
              height: 13,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonImage(
                  imageUrl: thumbnail,
                  width: 98,
                  height: 98,
                ),
                const SizedBox(
                  width: 17,
                ), // Add some space between the image and the text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$categoryName > ${treatment.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextDesign.bold14B,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (options.isNotEmpty)
                        ...options.map((optionCategory) {
                          return Column(
                            children: [
                              Text(
                                '${optionCategory!.name}: ${optionCategory.options.first.name}',
                                style: TextDesign.regular12DG,
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                            ],
                          );
                        }),
                      Text(
                        '소요시간 : ${DataUtils.formatDuration(
                          treatment.duration +
                              (options.isNotEmpty
                                  ? options
                                      .map((e) => e!.options.first.duration)
                                      .reduce(
                                          (value, element) => value + element)
                                  : 0),
                        )}',
                        style: TextDesign.regular12DG,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          if (treatment.discount > 0)
                            Text(
                              '${treatment.discount}% ',
                              style: TextDesign.bold12BO,
                            ),
                          Text(
                            "${DataUtils.formatKoreanWon(treatment.minPrice * (100 - treatment.discount) ~/ 100)}${treatment.maxPrice != null ? ' ~ ${DataUtils.formatKoreanWon(treatment.maxPrice! * (100 - treatment.discount) ~/ 100)}' : ''}",
                            style: TextDesign.bold14B,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        '$minutes:$seconds',
        style: TextDesign.regular14BO,
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

  bool above14 = false;
  bool allChecked = false;
  bool privacyAgree = false;
  bool thirdPartyAgree = false;

  bool isLoading = false;

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

  bool checkConditions() {
    return !_depositRuleAccepted ||
        !_changeCancelRuleAccepted ||
        !_otherInfoAccepted ||
        !allChecked;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: Stack(
          children: [
            Container(
              color: ContainerColors.white,
              child: ListView(
                controller: _scrollController,
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CommonIcons.triangleAlert(),
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: ContainerColors.mediumGrey,
                              ),
                              child: Column(
                                children: [
                                  TextWithNumber(
                                    text: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '발송된 ',
                                            style: TextDesign.medium14CG,
                                          ),
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
                                                    text: '안내된 계좌번호로 ',
                                                    style:
                                                        TextDesign.medium14CG),
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
                                      ],
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
                                      ],
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
                      Positioned(
                        top: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CommonIcons.lineClose(),
                        ),
                      ),
                    ],
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
                    title: '예약 변경 및 취소 규정 (필수)',
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
                                style: TextDesign.medium14BO,
                              ),
                              TextSpan(
                                text: '카카오톡 채널',
                                style: TextDesign.bold14BO,
                              ),
                              TextSpan(
                                text: '을 통해 부탁드립니다.',
                                style: TextDesign.medium14BO,
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
                    title: '기타 안내사항 (필수)',
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
                                style: TextDesign.medium14BO,
                              ),
                              TextSpan(
                                text: '예약 확정까지는 일정 시간',
                                style: TextDesign.bold14BO,
                              ),
                              TextSpan(
                                text: '이 소요됩니다. ',
                                style: TextDesign.medium14BO,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    key: _otherInfoKey,
                  ),
                  ConstWidgets.greyBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      key: _serviceAgreementKey,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 13.5,
                          ),
                          child: Row(
                            children: [
                              customCheckbox(
                                  value: allChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      allChecked = value;
                                      privacyAgree = value;
                                      thirdPartyAgree = value;
                                      above14 = value;
                                    });
                                  }),
                              const SizedBox(width: 15),
                              Text(
                                '모두 동의합니다.',
                                style: TextDesign.bold16B,
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: IconColors.basic,
                        ),
                        const SizedBox(height: 10),
                        buildCheckBoxRow(
                          '만 14세 이상입니다. (필수)',
                          above14,
                          (value) {
                            setState(() {
                              above14 = value;
                              allChecked =
                                  privacyAgree && thirdPartyAgree && above14;
                            });
                          },
                          null,
                        ),
                        buildCheckBoxRow(
                          '개인정보 수집 동의 및 이용 (필수)',
                          privacyAgree,
                          (value) {
                            setState(() {
                              privacyAgree = value;
                              allChecked =
                                  privacyAgree && thirdPartyAgree && above14;
                            });
                          },
                          'https://numaze.co.kr/privacy_numaze',
                        ),
                        buildCheckBoxRow(
                          '개인정보 제3자 제공 (필수)',
                          thirdPartyAgree,
                          (value) {
                            setState(() {
                              thirdPartyAgree = value;
                              allChecked =
                                  privacyAgree && thirdPartyAgree && above14;
                            });
                          },
                          'https://numaze.co.kr/privacy_others',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 110,
                  ),
                ],
              ),
            ),
            if (isLoading)
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(
                    color: StrokeColors.black,
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ConditionalInkwellButton(
                onTap: () async {
                  if (checkConditions() || isLoading) {
                    return;
                  }
                  final designer = ref.read(selectedDesignerProvider);
                  final selectedDateTime = ref.read(selectedDateTimeProvider);
                  final selectedTreatments =
                      ref.read(selectedTreatmentProvider);

                  analytics.logEvent(name: 'final_reservation_button');
                  try {
                    setState(() {
                      isLoading = true;
                    });
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

                    if (!context.mounted) return;

                    if (widget.images.isNotEmpty) {
                      List<MultipartFile> multipartFiles =
                          widget.images.map((image) {
                        return MultipartFile.fromBytes(
                          image,
                          filename:
                              '${DateTime.now().millisecondsSinceEpoch}.jpeg',
                        );
                      }).toList();
                      ref.read(repositoryProvider).customerRequestImages(
                            appointmentId: resp.data,
                            files: multipartFiles,
                          );
                    }

                    ref
                        .read(selectedDateTimeProvider.notifier)
                        .clearSelections();
                    ref
                        .read(selectedDesignerProvider.notifier)
                        .clearSelection();
                    ref.read(selectedTreatmentProvider.notifier).state = {};

                    context.go(
                        '/s/${widget.shopDomain}/complete?appointmentId=${resp.data}');
                  } on DioException catch (e) {
                    if (e.response?.statusCode == 400) {
                      final error = e.response?.data['error_code'];
                      if (error != null) {
                        ref
                            .read(selectedDateTimeProvider.notifier)
                            .clearSelections();
                        ref
                            .read(selectedDesignerProvider.notifier)
                            .clearSelection();
                        switch (error) {
                          case 'SHOP_NOT_TAKING_RESERVATION':
                            ref.read(selectedTreatmentProvider.notifier).state =
                                {};
                            context
                                .go('/close?shopDomain=${widget.shopDomain}');

                          case 'INVALID_TIME_SLOT':
                            context.go('/fail?shopDomain=${widget.shopDomain}');
                        }
                      }
                    } else {
                      customSnackBar(
                        message: '예약 요청 중 오류가 발생했습니다.',
                        context: context,
                        error: true,
                      );
                    }
                  }
                },
                text: '예약 신청하기',
                condition: checkConditions() || isLoading,
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
        vertical: 10,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 52,
            child: Row(
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
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (content == null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: ContainerColors.mediumGrey,
              ),
              child: Column(
                children: [
                  if (widget.shopMessages.depositTimeLimit > 0)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 60,
                              child: Text(
                                '입금 기한',
                                style: TextDesign.regular14G,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${DataUtils.formatDurationWithZero(
                                  widget.shopMessages.depositTimeLimit,
                                )} 이내',
                                textAlign: TextAlign.right,
                                style: TextDesign.medium14B,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          '예약금',
                          style: TextDesign.regular14G,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.shopMessages.depositAmount,
                          style: TextDesign.medium14B,
                          textAlign: TextAlign.right,
                        ),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: ContainerColors.mediumGrey,
              ),
              child: Text(
                content,
                style: TextDesign.medium14CG,
                textAlign: TextAlign.left,
              ),
            ),
          if (guide != null) guide,
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget customCheckbox({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: value ? CommonIcons.checkIconBlack() : CommonIcons.checkIcon(),
    );
  }

  Widget buildCheckBoxRow(
    String title,
    bool isChecked,
    ValueChanged<bool> onChanged,
    String? hasUri,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        children: [
          customCheck(value: isChecked, onChanged: onChanged),
          const SizedBox(
            width: 11,
          ),
          Expanded(
            child: Text(
              title,
              style: TextDesign.medium14B,
            ),
          ),
          if (hasUri != null)
            GestureDetector(
              onTap: () {
                html.window.open(
                  hasUri,
                  '_blank',
                );
              },
              // child: CommonIcons.arrowRight(),
              child: CommonIcons.lineArrowRight(),
            ),
        ],
      ),
    );
  }

  Widget customCheck({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: value ? CommonIcons.lineCheckBlack() : CommonIcons.lineCheck(),
    );
  }
}
