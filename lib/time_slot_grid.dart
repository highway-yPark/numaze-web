import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numaze_web/model.dart';
import 'package:numaze_web/time_slots_provider.dart';

import 'common/const/colors.dart';
import 'common/const/text.dart';
import 'list_model.dart';

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
  void initState() {
    super.initState();
    selectedDesignerId = ref.read(selectedDesignerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final timeSlotsState = ref.watch(timeSlotsProvider(widget.shopDomain));
    final selectedDateTime = ref.watch(selectedDateTimeProvider);

    if (timeSlotsState is ListEmpty) {
      return Container();
    }
    if (timeSlotsState is ListLoading) {
      return Container(
        height: 400,
      );
    }

    if (timeSlotsState is ListError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(timeSlotsState.data),
        ),
      );
    }

    final occupiedDates =
        (timeSlotsState as ListModel<DesignerAvailableTimeSlots>).data;

    final filteredDesigners = occupiedDates
        .where((designer) =>
            !designer.timeSlots.any((timeSlot) => timeSlot >= 1000))
        .toList();

    if (filteredDesigners.isEmpty) {
      return const Center(
        child: Text('해당 날짜의 예약이 마감되었어요.'),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      width: double.infinity,
      color: ContainerColors.mediumGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.selectDesigner) ...[
            Text('디자이너', style: TextDesign.bold18B),
            const SizedBox(height: 10),
            SingleChildScrollView(
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
                          ref.read(selectedDesignerProvider.notifier).state =
                              designer.designerId;
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
            const SizedBox(height: 10),
          ],
          Text('시간', style: TextDesign.bold18B),
          const SizedBox(height: 10),
          SlotRow(
            label: '오전',
            slots: morningSlots,
            selectedDateTime: selectedDateTime,
            selectedDesignerId: selectedDesignerId,
          ),
          const SizedBox(height: 10),
          SlotRow(
            label: '오후',
            slots: afternoonSlots,
            selectedDateTime: selectedDateTime,
            selectedDesignerId: selectedDesignerId,
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

  const SlotRow({
    super.key,
    required this.label,
    required this.slots,
    required this.selectedDateTime,
    required this.selectedDesignerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextDesign.medium14G),
        const SizedBox(height: 5),
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
                                  .state = selectedDesignerId;
                            }
                          },
                          child: SlotBox(
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
                    SizedBox(
                      height: 45,
                      child: Center(
                        child: Text(
                          '예약이 마감되었어요',
                          style: TextDesign.medium14G,
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      ],
    );
  }

  static String formatTime(int time) {
    final hour = time ~/ 2 % 12 == 0 ? 12 : time ~/ 2 % 12;
    final minute = time % 2 * 30;
    return '$hour:${minute.toString().padLeft(2, '0')}';
  }
}

class SlotBox extends StatelessWidget {
  final String text;
  final bool isSelected;
  const SlotBox({
    super.key,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 92,
      padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 15.0),
      decoration: BoxDecoration(
        color: isSelected ? ContainerColors.black : ContainerColors.white,
        border: Border.all(
          color: isSelected ? StrokeColors.black : StrokeColors.grey,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Text(
          text,
          style: isSelected ? TextDesign.medium14W : TextDesign.medium14B,
        ),
      ),
    );
  }
}
