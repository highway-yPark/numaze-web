import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common/const/icons.dart';
import 'package:numaze_web/view/not_found_page.dart';

import '../common/const/colors.dart';
import '../common/const/text.dart';
import '../common/const/widgets.dart';
import '../model/model.dart';
import '../provider/provider.dart';
import '../treatment_reservation_button.dart';
import 'shop_main_page.dart';

class ShopInfoPage extends ConsumerStatefulWidget {
  final String shopDomain;
  const ShopInfoPage({
    super.key,
    required this.shopDomain,
  });

  @override
  ConsumerState<ShopInfoPage> createState() => _ShopInfoPageState();
}

class _ShopInfoPageState extends ConsumerState<ShopInfoPage> {
  @override
  Widget build(BuildContext context) {
    final shopBasicInfoState =
        ref.watch(shopBasicInfoProvider(widget.shopDomain));
    if (shopBasicInfoState is ShopBasicLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: StrokeColors.black,
        ),
      );
    }
    if (shopBasicInfoState is ShopBasicError) {
      return NotFoundPage(
        shopDomain: widget.shopDomain,
      );
    }
    final shopData = shopBasicInfoState as ShopBasicInfo;

    final selectedTreatments = ref.watch(selectedTreatmentProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    SizedBox(
                      height: 59,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MenuButton(
                                  onTap: () {
                                    context.go('/s/${widget.shopDomain}');
                                  },
                                  title: '시술 메뉴',
                                  isSelected: false,
                                ),
                                MenuButton(
                                  onTap: () {
                                    context.go(
                                        '/s/${widget.shopDomain}/thirdStyles');
                                  },
                                  title: '스타일',
                                  isSelected: false,
                                ),
                                MenuButton(
                                  onTap: () {},
                                  title: '정보',
                                  isSelected: true,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 3,
                            color: ContainerColors.black,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 20,
                                bottom: 30,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '샵 정보',
                                    style: TextDesign.bold16B,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 79,
                                        child: Text(
                                          '주소',
                                          style: TextDesign.regular14G,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              shopData.address,
                                              style: TextDesign.medium14B,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              shopData.addressDetail ?? '',
                                              style: TextDesign.medium14G,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 79,
                                        child: Text(
                                          '주차 안내',
                                          style: TextDesign.regular14G,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              shopData.parkingType,
                                              style: TextDesign.medium14B,
                                            ),
                                            if (shopData.parkingMessage
                                                .trim()
                                                .isNotEmpty)
                                              Column(
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Text(
                                                    shopData.parkingMessage,
                                                    style: TextDesign.medium14G,
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ConstWidgets.greyBox(),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 20,
                                bottom: 10,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '샵 소개',
                                      style: TextDesign.bold16B,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      shopData.description,
                                      style: TextDesign.medium14G,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ConstWidgets.greyBox(),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 20,
                                bottom: 10,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '기타 안내사항',
                                      style: TextDesign.bold16B,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      shopData.additionalMessage,
                                      style: TextDesign.medium14G,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 110,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedTreatments.isEmpty &&
                  !(shopData.takeReservation ^ shopData.approval))
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 95,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 29.5,
                      vertical: 20,
                    ),
                    color: ContainerColors.black,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonIcons.adFree(),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '누메이즈의 ',
                                    style: TextDesign.bold18W,
                                  ),
                                  Text(
                                    '예약 • 관리 서비스,',
                                    style: TextDesign.bold18BO,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    '원장님! 지금 ',
                                    style: TextDesign.bold18W,
                                  ),
                                  Text(
                                    '무료',
                                    style: TextDesign.bold18BO,
                                  ),
                                  Text(
                                    '로 경험해보세요.',
                                    style: TextDesign.bold18W,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (selectedTreatments.isNotEmpty &&
                  !(shopData.takeReservation ^ shopData.approval))
                TreatmentReservationButton(
                  shopDomain: widget.shopDomain,
                  futureReservationDays: shopData.futureReservationDays,
                ),
              if ((shopData.takeReservation ^ shopData.approval))
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 72,
                    color: ContainerColors.ctaGrey,
                    child: Center(
                      child: Text(
                        '지금은 예약을 접수 받을 수 없어요',
                        style: TextDesign.bold20W,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
