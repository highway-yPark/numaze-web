import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common/const/icons.dart';
import 'package:numaze_web/provider/customer_appointment_provider.dart';

import '../common/const/colors.dart';
import '../common/const/text.dart';
import '../common/const/widgets.dart';
import '../common/js_function.dart';
import '../components/common_image.dart';
import '../components/common_title.dart';
import '../components/custom_snackbar.dart';
import '../components/progress_indicator.dart';
import '../model/model.dart';
import '../provider/provider.dart';
import '../utils.dart';
import '404_page.dart';
import 'reservation_details_screen.dart';

class CustomerAppointmentPage extends ConsumerStatefulWidget {
  final String shopDomain;
  final String appointmentId;
  const CustomerAppointmentPage({
    super.key,
    required this.shopDomain,
    required this.appointmentId,
  });

  @override
  ConsumerState<CustomerAppointmentPage> createState() =>
      _CustomerAppointmentPageState();
}

class _CustomerAppointmentPageState
    extends ConsumerState<CustomerAppointmentPage> {
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

  Widget _treatmentInfo(List<TreatmentHistoryResponse> treatmentHistories) {
    return Column(
      children: [
        for (var treatment in treatmentHistories)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, left: 16, right: 16),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: CommonWidgets.greyBorder(ContainerColors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        DataUtils.getTreatmentText(treatment.treatmentType),
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
                        imageUrl: treatment.thumbnail,
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
                              '${treatment.treatmentCategoryName} > ${treatment.treatmentName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextDesign.bold14B,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (treatment.options != null)
                              for (var option in treatment.options!)
                                Column(
                                  children: [
                                    Text(
                                      '${option.optionCategoryName} : ${option.optionName}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextDesign.regular12MDG,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                            Text(
                              '소요시간 : ${DataUtils.formatDuration(sumOfEachTreatmentOptionDuration(treatment))}',
                              style: TextDesign.regular12MDG,
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
                                  "${DataUtils.formatKoreanWon(treatment.treatmentMinPrice * (100 - treatment.discount) ~/ 100)}${treatment.treatmentMaxPrice != null ? ' ~ ${DataUtils.formatKoreanWon(treatment.treatmentMaxPrice! * (100 - treatment.discount) ~/ 100)}' : ''}",
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
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final shopBasicInfoState =
        ref.watch(shopBasicInfoProvider(widget.shopDomain));
    final shopMessagesState = ref.watch(shopMessageProvider(widget.shopDomain));
    final customerAppointmentState =
        ref.watch(customerAppointmentProvider(widget.appointmentId));

    if (shopBasicInfoState is ShopBasicError ||
        shopMessagesState is ShopMessageError ||
        customerAppointmentState is CustomerAppointmentError) {
      return const PageNotFound();
    }

    if (shopBasicInfoState is ShopBasicLoading ||
        shopMessagesState is ShopMessageLoading ||
        customerAppointmentState is CustomerAppointmentLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: StrokeColors.black,
        ),
      );
    }

    final shopData = shopBasicInfoState as ShopBasicInfo;

    final shopMessages = shopMessagesState as ShopMessageInfo;

    final customerAppointment =
        customerAppointmentState as CustomerAppointmentResponse;

    String getStatus(String status) {
      switch (status) {
        case 'visited':
          return '방문';
        case 'absent':
          return '노쇼';
        case 'cancelled':
          return '예약 취소';
        default:
          return '예약 대기';
      }
    }

    Widget getStatusIcon(String status) {
      switch (status) {
        case 'visited':
          return CommonIcons.visited();
        case 'absent':
          return CommonIcons.absent();
        case 'cancelled':
          return CommonIcons.cancel();
        default:
          return CommonIcons.complete();
      }
    }

    final status = customerAppointment.status == null
        ? customerAppointment.confirmed
            ? '예약 확정'
            : '예약 대기'
        : getStatus(customerAppointment.status!);

    final statusIcon = customerAppointment.status == null
        ? customerAppointment.confirmed
            ? CommonIcons.confirmed()
            : CommonIcons.complete()
        : getStatusIcon(customerAppointment.status!);

    changeTitle(shopData.name);

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
                          Align(
                            alignment: Alignment.topCenter,
                            child: StatusColumn(
                              icon: statusIcon,
                              title: status,
                              message: customerAppointment.status == null &&
                                      customerAppointment.confirmed == false
                                  ? '반드시 하단의 안내 사항을 모두 읽어주세요'
                                  : null,
                              currentStep: customerAppointment.status == null
                                  ? customerAppointment.confirmed
                                      ? 1
                                      : 0
                                  : 2,
                              noIndicator: status == '예약 취소' || status == '노쇼'
                                  ? true
                                  : false,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: GestureDetector(
                              onTap: () {
                                context.go('/s/${widget.shopDomain}');
                              },
                              child: CommonIcons.home(),
                            ),
                          ),
                        ],
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          children: [
                            TextWithTitle(
                              title: '이름',
                              text: customerAppointment.customerName,
                            ),
                            TextWithTitle(
                              title: '전화번호',
                              text: customerAppointment.customerPhoneNumber,
                            ),
                            TextWithTitle(
                              title: '회원권 잔액',
                              text: DataUtils.formatKoreanWonWithSymbol(
                                customerAppointment.customerMembershipAmount,
                              ),
                            ),
                            if (customerAppointment.membershipExpirationDate !=
                                null)
                              TextWithTitle(
                                title: '회원권 만료일',
                                text: DataUtils.formatDate(
                                  customerAppointment.membershipExpirationDate!,
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
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
                              title: '예약한 시술',
                            ),
                          ),
                          _treatmentInfo(
                            customerAppointment.treatmentOptionHistory,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      ConstWidgets.greyBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: CommonWidgets.sixteenTenPadding(),
                        child: const CommonTitle(
                          title: '예약 일정',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          children: [
                            TextWithTitle(
                              title: '날짜',
                              text: DataUtils.formatDateWithDay(
                                customerAppointment.appointmentDate,
                              ),
                            ),
                            TextWithTitle(
                              title: '시간',
                              text: DataUtils.convertTime(
                                customerAppointment.startTime,
                                customerAppointment.duration,
                              ),
                            ),
                            if (shopData.selectDesigner)
                              TextWithTitle(
                                title: '디자이너',
                                text: customerAppointment.designerName ?? '미정',
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      ConstWidgets.greyBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: CommonWidgets.sixteenTenPadding(),
                        child: const CommonTitle(
                          title: '요청 사항',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (customerAppointment.customerImages != null)
                              SizedBox(
                                height: 82,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: customerAppointment
                                      .customerImages!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        right: 10,
                                      ),
                                      child: CommonImage(
                                        imageUrl: customerAppointment
                                            .customerImages![index],
                                        width: 82,
                                        height: 82,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              customerAppointment.customerRequest == null ||
                                      customerAppointment
                                          .customerRequest!.isEmpty
                                  ? '없음'
                                  : customerAppointment.customerRequest!,
                              style: TextDesign.medium14B,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      if (shopMessages.hasDeposit &&
                          customerAppointment.status == null &&
                          customerAppointment.confirmed == false)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstWidgets.greyBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: CommonWidgets.sixteenTenPadding(),
                              child: const CommonTitle(
                                title: '예약금 규정',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: ContainerColors.mediumGrey,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (shopMessages.memberReceiveDeposit ||
                                            !customerAppointment.membership)
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ClipBoardCopy(
                                                    text: shopMessages
                                                        .bankAccount,
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
                                        if (shopMessages.depositTimeLimit > 0 &&
                                            (shopMessages
                                                    .memberReceiveDeposit ||
                                                !customerAppointment
                                                    .membership))
                                          Column(
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: 60,
                                                    child: Text(
                                                      '입금 기한',
                                                      style:
                                                          TextDesign.regular14G,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${DataUtils.formatDurationWithZero(
                                                        shopMessages
                                                            .depositTimeLimit,
                                                      )} 이내',
                                                      style:
                                                          TextDesign.medium14B,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                        if (shopMessages.memberReceiveDeposit ||
                                            !customerAppointment.membership)
                                          GestureDetector(
                                            onTap: () {
                                              // context.go(
                                              //     '/appointment/${customerAppointment.base64Uuid}/payment');
                                              context.go(
                                                  '/payment?appointmentId=${customerAppointment.base64Uuid}');
                                            },
                                            child: Text(
                                              // 'https://numaze.kr/appointment/${customerAppointment.base64Uuid}/payment',
                                              '예약금 입금 확인 요청하기',
                                              style: TextDesign.medium14BO
                                                  .copyWith(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor:
                                                    BrandColors.pink,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (shopMessages.memberReceiveDeposit ||
                                      !customerAppointment.membership)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '※ 예약자명과 예금주명을 반드시 통일해주세요.',
                                          style: TextDesign.regular12BO,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '※ 예약금을 위 계좌로 입금한 뒤, 반드시 예약 확인 요청 링크를 클릭해야 예약이 확정됩니다.',
                                          style: TextDesign.regular12BO,
                                        ),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '※ 회원권 고객님의 경우 예약금 입금 없이 정액권에서 차감됩니다.',
                                          style: TextDesign.medium14BO,
                                        ),
                                      ],
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ConstWidgets.greyBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: CommonWidgets.sixteenTenPadding(),
                        child: const CommonTitle(
                          title: '예약 변경 및 취소 규정',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '예약 변경 및 취소는 카카오톡 채널을 통해 부탁드립니다',
                              style: TextDesign.medium14G,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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
                                shopMessages.reservationMessage,
                                style: TextDesign.medium14CG,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text(
                                  '※ 예약 변경 및 취소 문의 : ',
                                  style: TextDesign.regular12BO,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    html.window.open(
                                      'https://pf.kakao.com/${shopData.kakaotalkLink}',
                                      '_blank',
                                    );
                                  },
                                  child: Text(
                                    'https://pf.kakao.com/${shopData.kakaotalkLink}',
                                    style: TextDesign.regular12B.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      if (customerAppointment.status == null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstWidgets.greyBox(),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: CommonWidgets.sixteenTenPadding(),
                              child: const CommonTitle(
                                title: '기타 안내사항',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '예약금 입금 후 예약 확정까지는 일정 시간이 소요되며, 예약은 샵의 사정으로 인해 취소될 수 있습니다.',
                                    style: TextDesign.medium14G,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
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
                                      shopMessages.additionalMessage,
                                      style: TextDesign.medium14CG,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  // Text(
                                  //   '※ 확정까지는 일정 시간이 소요되며, 샵의 사정으로 예약이 취소될 수 있습니다.',
                                  //   style: TextDesign.medium14BO,
                                  // ),
                                  // const SizedBox(
                                  //   height: 20,
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ConstWidgets.greyBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: TextWithTitle(
                            //         title: '예약 번호',
                            //         text: customerAppointment.base64Uuid,
                            //       ),
                            //     ),
                            //     // const SizedBox(
                            //     //   width: 5,
                            //     // ),
                            //     // ClipBoardCopy(
                            //     //   text: customerAppointment.base64Uuid,
                            //     // ),
                            //   ],
                            // ),
                            SizedBox(
                              height: 40,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '예약번호',
                                      style: TextDesign.regular14G,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      ClipBoardCopy(
                                        text: customerAppointment.base64Uuid,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        customerAppointment.base64Uuid,
                                        style: TextDesign.medium14B,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TextWithTitle(
                              title: '예약 신청 일시',
                              text: customerAppointment.createdAt.replaceAll(
                                '-',
                                '.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class ClipBoardCopy extends StatelessWidget {
  final String text;
  const ClipBoardCopy({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(
          ClipboardData(
            text: text,
          ),
        );
        copySnackBar(context: context);
      },
      child: Builder(
        builder: (context) => CommonIcons.clipboard(),
      ),
    );
  }
}
