import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'common/const/colors.dart';
import 'common/const/text.dart';
import 'common/const/widgets.dart';
import 'model.dart';
import 'provider.dart';
import 'shop.dart';
import 'treatment_reservation_button.dart';

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
  bool shopDescriptionExpanded = false;
  bool showMoreDescription = false;
  bool additionalInfoExpanded = false;
  bool showMoreAdditionalInfo = false;

  @override
  void initState() {
    super.initState();
  }

  void _checkTextOverflow(
      String text, TextStyle style, Function(bool) callback) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: style,
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 32);
    callback(textPainter.didExceedMaxLines);
  }

  @override
  Widget build(BuildContext context) {
    final shopBasicInfoState =
        ref.watch(shopBasicInfoProvider(widget.shopDomain));
    if (shopBasicInfoState is ShopBasicLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (shopBasicInfoState is ShopBasicError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(shopBasicInfoState.data),
        ),
      );
    }
    final shopData = shopBasicInfoState as ShopBasicInfo;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextOverflow(shopData.description, TextDesign.medium14G,
          (isOverflowing) {
        if (showMoreDescription != isOverflowing) {
          setState(() {
            showMoreDescription = isOverflowing;
          });
        }
      });
      _checkTextOverflow(shopData.additionalMessage, TextDesign.medium14G,
          (isOverflowing) {
        if (showMoreAdditionalInfo != isOverflowing) {
          setState(() {
            showMoreAdditionalInfo = isOverflowing;
          });
        }
      });
    });

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
                      child: ListView(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            shopData.addressDetail,
                                            style: TextDesign.medium14G,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          const SizedBox(height: 10),
                                          Text(
                                            shopData.parkingMessage,
                                            style: TextDesign.medium14G,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '샵 소개',
                                  style: TextDesign.bold16B,
                                ),
                                const SizedBox(height: 10),
                                AnimatedCrossFade(
                                  firstChild: Text(
                                    shopData.description,
                                    style: TextDesign.medium14G,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  secondChild: Text(
                                    shopData.description,
                                    style: TextDesign.medium14G,
                                  ),
                                  crossFadeState: shopDescriptionExpanded
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  duration: const Duration(milliseconds: 200),
                                ),
                                if (showMoreDescription) ...[
                                  const SizedBox(height: 10),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          shopDescriptionExpanded =
                                              !shopDescriptionExpanded;
                                        });
                                      },
                                      child: Icon(
                                        shopDescriptionExpanded
                                            ? CupertinoIcons.chevron_up
                                            : CupertinoIcons.chevron_down,
                                        size: 20,
                                        color: IconColors.grey,
                                      ),
                                    ),
                                  ),
                                ],
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '기타 안내사항',
                                  style: TextDesign.bold16B,
                                ),
                                const SizedBox(height: 10),
                                AnimatedCrossFade(
                                  firstChild: Text(
                                    shopData.additionalMessage,
                                    style: TextDesign.medium14G,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  secondChild: Text(
                                    shopData.additionalMessage,
                                    style: TextDesign.medium14G,
                                  ),
                                  crossFadeState: additionalInfoExpanded
                                      ? CrossFadeState.showSecond
                                      : CrossFadeState.showFirst,
                                  duration: const Duration(milliseconds: 200),
                                ),
                                if (showMoreAdditionalInfo) ...[
                                  const SizedBox(height: 10),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          additionalInfoExpanded =
                                              !additionalInfoExpanded;
                                        });
                                      },
                                      child: Icon(
                                        additionalInfoExpanded
                                            ? CupertinoIcons.chevron_up
                                            : CupertinoIcons.chevron_down,
                                        size: 20,
                                        color: IconColors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 110,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedTreatments.isNotEmpty)
                TreatmentReservationButton(
                  shopDomain: widget.shopDomain,
                  futureReservationDays: shopData.futureReservationDays,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
