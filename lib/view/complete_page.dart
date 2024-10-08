import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common/const/icons.dart';

import '../common/const/colors.dart';
import '../common/const/text.dart';
import '../common/const/widgets.dart';
import '../components/inkwell_button.dart';
import '../components/progress_indicator.dart';
import '../components/text_with_number.dart';
import '../model/model.dart';
import '../provider/provider.dart';
import '../utils.dart';
import 'customer_appointment_page.dart';

class CompletePage extends ConsumerStatefulWidget {
  final String shopDomain;
  final String appointmentId;
  const CompletePage({
    super.key,
    required this.shopDomain,
    required this.appointmentId,
  });

  @override
  ConsumerState<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends ConsumerState<CompletePage> {
  @override
  Widget build(BuildContext context) {
    final shopMessagesState = ref.watch(shopMessageProvider(widget.shopDomain));

    if (shopMessagesState is ShopMessageLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: StrokeColors.black,
          ),
        ),
      );
    }

    if (shopMessagesState is ShopMessageError) {
      context.go('/s/${widget.shopDomain}');
      // Navigator.popUntil(context, (route) => route.isFirst);
    }

    final shopMessages = shopMessagesState as ShopMessageInfo;
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Stack(
              children: [
                Container(
                  color: ContainerColors.white,
                  child: ListView(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                StatusColumn(
                                  icon: CommonIcons.complete(),
                                  title: '예약 신청 완료',
                                  currentStep: 0,
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
                                      if (shopMessages.hasDeposit)
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
                                                        style: TextDesign
                                                            .medium14CG),
                                                    TextSpan(
                                                      text: '예약금',
                                                      style:
                                                          TextDesign.bold14CG,
                                                    ),
                                                    TextSpan(
                                                      text: '을 입금해주세요',
                                                      style:
                                                          TextDesign.medium14CG,
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
                                                      style:
                                                          TextDesign.medium14CG,
                                                    ),
                                                    TextSpan(
                                                      text: '예금주명',
                                                      style:
                                                          TextDesign.bold14CG,
                                                    ),
                                                    TextSpan(
                                                      text: '을 일치시켜주세요',
                                                      style:
                                                          TextDesign.medium14CG,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              number: '03',
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextWithNumber(
                                              text: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: '입금 후 ',
                                                      style:
                                                          TextDesign.medium14CG,
                                                    ),
                                                    TextSpan(
                                                      text: '예약 확인 요청 링크',
                                                      style:
                                                          TextDesign.bold14CG,
                                                    ),
                                                    TextSpan(
                                                      text: '를 반드시 눌러주세요',
                                                      style:
                                                          TextDesign.medium14CG,
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
                                if (shopMessages.hasDeposit)
                                  SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '※ 예약금을 입금한 후 확인 링크를 클릭해야 예약이 확정됩니다.',
                                          style: TextDesign.medium14BO,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: GestureDetector(
                              onTap: () {
                                context.go('/s/${widget.shopDomain}');
                                // Navigator.popUntil(
                                //     context, (route) => route.isFirst);
                              },
                              child: CommonIcons.home(),
                            ),
                          ),
                        ],
                      ),
                      if (shopMessages.hasDeposit) ConstWidgets.greyBox(),
                      if (shopMessages.hasDeposit)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 60,
                                    child: Text(
                                      '계좌 번호',
                                      style: TextDesign.regular14G,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ClipBoardCopy(
                                        text: shopMessages.bankAccount,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        shopMessages.bankAccount,
                                        style: TextDesign.medium14B,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              if (shopMessages.depositTimeLimit > 0)
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                              shopMessages.depositTimeLimit,
                                            )} 이내',
                                            style: TextDesign.medium14B,
                                            textAlign: TextAlign.end,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      shopMessages.depositAmount,
                                      style: TextDesign.medium14B,
                                      textAlign: TextAlign.end,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  '※ 회원권 고객님의 경우 예약금 입금 없이 정액권에서 차감됩니다.',
                                  style: TextDesign.medium14BO,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 114,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BlackInkwellButton(
                    onTap: () {
                      context.go(
                          '/appointment/${widget.appointmentId}?shopDomain=${widget.shopDomain}');
                    },
                    text: '나의 예약 확인하기',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
