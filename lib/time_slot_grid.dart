import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numaze_web/common/const/widgets.dart';
import 'package:numaze_web/model/model.dart';
import 'package:numaze_web/provider/time_slots_provider.dart';

import 'common/const/colors.dart';
import 'common/const/text.dart';
import 'components/common_title.dart';
import 'model/list_model.dart';

class TimeSlotGrid extends ConsumerStatefulWidget {
  final String shopDomain;
  final bool selectDesigner;

  const TimeSlotGrid({
    super.key,
    required this.shopDomain,
    required this.selectDesigner,
  });

  @override
  ConsumerState<TimeSlotGrid> createState() => _TimeSlotGridState();
}

class _TimeSlotGridState extends ConsumerState<TimeSlotGrid> {
  int? selectedDesignerId;

  @override
  Widget build(BuildContext context) {
    final timeSlotsState = ref.watch(timeSlotsProvider(widget.shopDomain));
    final selectedDateTime = ref.watch(selectedDateTimeProvider);

    if (timeSlotsState is ListEmpty) {
      return Container(
        height: widget.selectDesigner ? 311 : 221,
      );
    }
    if (timeSlotsState is ListLoading) {
      return Container(
        height: widget.selectDesigner ? 311 : 221,
      );
    }

    if (timeSlotsState is ListError) {
      return const Center(
        child: Text('데이터를 불러오는데 실패했어요.'),
      );
    }

    final occupiedDates =
        (timeSlotsState as ListModel<DesignerAvailableTimeSlots>).data;

    final filteredDesigners = occupiedDates
        .where((designer) =>
            !designer.timeSlots.any((timeSlot) => timeSlot >= 1000))
        .toList();

    if (filteredDesigners.isEmpty) {
      // return const Center(
      //   child: Text('해당 날짜의 예약이 마감되었어요.'),
      // );
      return Container(
        height: widget.selectDesigner ? 311 : 221,
        width: double.infinity,
        color: ContainerColors.mediumGrey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 32,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: StrokeColors.grey,
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Center(
                  child: Text(
                    '예약이 모두 마감 되었어요.',
                    overflow: TextOverflow.ellipsis,
                    style: TextDesign.medium14G,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.selectDesigner && ref.read(selectedDesignerProvider) == null) {
      selectedDesignerId = filteredDesigners.first.designerId;
    }

    List<int> morningSlots;
    List<int> afternoonSlots;

    if (widget.selectDesigner) {
      final selectedDesigner = filteredDesigners.firstWhere(
          (designer) => designer.designerId == selectedDesignerId,
          orElse: () => filteredDesigners.first);

      morningSlots = selectedDesigner.timeSlots
          .where((timeSlot) => timeSlot < 24)
          .toList()
        ..sort();
      afternoonSlots = selectedDesigner.timeSlots
          .where((timeSlot) => timeSlot >= 24 && timeSlot < 1000)
          .toList()
        ..sort();
    } else {
      final allTimeSlots = <int>{};
      for (final designer in filteredDesigners) {
        allTimeSlots.addAll(designer.timeSlots);
      }

      morningSlots = allTimeSlots.where((timeSlot) => timeSlot < 24).toList()
        ..sort();
      afternoonSlots = allTimeSlots
          .where((timeSlot) => timeSlot >= 24 && timeSlot < 1000)
          .toList()
        ..sort();
    }

    return Container(
      width: double.infinity,
      color: ContainerColors.mediumGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          if (widget.selectDesigner) ...[
            Padding(
              padding: CommonWidgets.sixteenTenPadding(),
              child: const CommonTitle(
                title: '디자이너',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filteredDesigners.map((designer) {
                    bool isSelected = selectedDesignerId == designer.designerId;
                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(selectedDateTimeProvider.notifier)
                                .clearTimeSlot();
                            ref
                                .read(selectedDesignerProvider.notifier)
                                .setSelectedDesigner(
                                  designer.designerId,
                                  designer.designerNickname,
                                );
                            setState(() {
                              selectedDesignerId = designer.designerId;
                            });
                          },
                          child: SlotBox(
                            text: designer.designerNickname,
                            isSelected: isSelected,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
          Padding(
            padding: CommonWidgets.sixteenTenPadding(),
            child: const CommonTitle(
              title: '시간',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: SlotRow(
              label: '오전',
              slots: morningSlots,
              selectedDateTime: selectedDateTime,
              selectedDesignerId: selectedDesignerId,
              nickname: selectedDesignerId != null
                  ? filteredDesigners
                      .firstWhere((designer) =>
                          designer.designerId == selectedDesignerId)
                      .designerNickname
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: SlotRow(
              label: '오후',
              slots: afternoonSlots,
              selectedDateTime: selectedDateTime,
              selectedDesignerId: selectedDesignerId,
              nickname: selectedDesignerId != null
                  ? filteredDesigners
                      .firstWhere((designer) =>
                          designer.designerId == selectedDesignerId)
                      .designerNickname
                  : null,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

class SlotRow extends ConsumerWidget {
  final String label;
  final List<int> slots;
  final SelectedDateTime selectedDateTime;
  final int? selectedDesignerId;
  final String? nickname;

  const SlotRow({
    super.key,
    required this.label,
    required this.slots,
    required this.selectedDateTime,
    required this.selectedDesignerId,
    required this.nickname,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Text(
              label,
              style: TextDesign.medium14G,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: slots.isNotEmpty
                  ? slots.map((timeSlot) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(selectedDateTimeProvider.notifier)
                                  .setTimeSlot(timeSlot);
                              if (selectedDesignerId != null) {
                                ref
                                    .read(selectedDesignerProvider.notifier)
                                    .setSelectedDesigner(
                                        selectedDesignerId!, nickname!);
                              }
                            },
                            child: SlotBox(
                              label: label,
                              text: formatTime(timeSlot),
                              isSelected:
                                  selectedDateTime.selectedTimeSlot == timeSlot,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      );
                    }).toList()
                  : [
                      // SizedBox(
                      //   height: 45,
                      //   child: Center(
                      //     child: Text(
                      //       // '예약이 마감되었어요',
                      //       '$label 예약이 모두 마감 되었어요.',
                      //       style: TextDesign.medium14G,
                      //     ),
                      //   ),
                      // ),
                      Container(
                        height: 45,
                        width: width - 16,
                        decoration: BoxDecoration(
                          color: ContainerColors.mediumGrey,
                          border: Border.all(
                            color: StrokeColors.grey,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            '$label 예약이 모두 마감 되었어요.',
                            overflow: TextOverflow.ellipsis,
                            style: TextDesign.medium14G,
                          ),
                        ),
                      ),
                    ],
            ),
          ),
        ],
      );
    });
  }

  static String formatTime(int time) {
    final hour = time ~/ 2 % 12 == 0 ? 12 : time ~/ 2 % 12;
    final minute = time % 2 * 30;
    return '$hour:${minute.toString().padLeft(2, '0')}';
  }
}

class SlotBox extends StatelessWidget {
  final String? label;
  final String text;
  final bool isSelected;

  const SlotBox({
    super.key,
    this.label,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 92,
      padding: const EdgeInsets.symmetric(
        // vertical: 4.5,
        horizontal: 5.0,
      ),
      decoration: BoxDecoration(
        color: isSelected ? ContainerColors.black : ContainerColors.white,
        border: Border.all(
          color: isSelected ? StrokeColors.black : StrokeColors.grey,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Text(
          label != null ? '$label $text' : text,
          overflow: TextOverflow.ellipsis,
          style: isSelected ? TextDesign.medium14W : TextDesign.medium14B,
        ),
      ),
    );
  }
}
