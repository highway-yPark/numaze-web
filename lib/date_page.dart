import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:numaze_web/time_slot_grid.dart';

import 'common/const/colors.dart';
import 'common/const/text.dart';
import 'list_model.dart';
import 'model.dart';
import 'occupied_dates_provider.dart';
import 'provider.dart';
import 'time_slots_provider.dart';
import 'utils.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  final String shopDomain;
  const CalendarScreen({
    super.key,
    required this.shopDomain,
  });

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime today = DateTime.now();
  DateTime focusedDate = DateTime.now();
  DateTime? selectedDate;

  TreatmentOptionPair convertToTreatmentOptionPair(
      SelectedTreatment selectedTreatment) {
    return TreatmentOptionPair(
      treatment_id: selectedTreatment.treatmentId,
      option_ids: selectedTreatment.selectedOptions.values.toList(),
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
    final selectedDateTime = ref.watch(selectedDateTimeProvider);
    final selectedDesigner = ref.watch(selectedDesignerProvider);

    final buttonColor = (shopData.selectDesigner &&
                (selectedDesigner == null ||
                    selectedDateTime.selectedTimeSlot == null ||
                    selectedDateTime.selectedDate == null)) ||
            (!shopData.selectDesigner &&
                selectedDateTime.selectedTimeSlot == null)
        ? Colors.grey
        : Colors.black;

    final occupiedDatesState =
        ref.watch(occupiedDatesProvider(widget.shopDomain));

    if (occupiedDatesState is ListEmpty) {
      return Center(
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go Home'),
        ),
      );
    }
    if (occupiedDatesState is ListLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (occupiedDatesState is ListError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(occupiedDatesState.data),
        ),
      );
    }

    final tempOccupiedDates =
        occupiedDatesState as ListModelWithDuration<String>;
    final occupiedDates = tempOccupiedDates.data;
    final duration = tempOccupiedDates.duration;
    final selectedTreatments = ref.watch(selectedTreatmentProvider);

    final DateTime firstDayOfCurrentMonth =
        DateTime(today.year, today.month, 1);
    DateTime lastDayOfReservation =
        today.add(Duration(days: shopData.futureReservationDays));
    DateTime lastAvailableMonth =
        DateTime(lastDayOfReservation.year, lastDayOfReservation.month + 2, 0);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 16.0,
                      ),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${focusedDate.year}년 ${focusedDate.month}월',
                                style: TextDesign.bold26B,
                              ),
                              Row(
                                children: [
                                  if (focusedDate.year > today.year ||
                                      focusedDate.month > today.month)
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          focusedDate = DateTime(
                                            focusedDate.year,
                                            focusedDate.month - 1,
                                          );
                                        });
                                      },
                                      icon:
                                          const Icon(Icons.keyboard_arrow_left),
                                      iconSize: 24,
                                    ),
                                  if (focusedDate
                                          .isBefore(lastAvailableMonth) &&
                                      (focusedDate.year !=
                                              lastAvailableMonth.year ||
                                          focusedDate.month !=
                                              lastAvailableMonth.month))
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          focusedDate = DateTime(
                                            focusedDate.year,
                                            focusedDate.month + 1,
                                          );
                                        });
                                      },
                                      icon: const Icon(
                                          Icons.keyboard_arrow_right),
                                      iconSize: 24,
                                    ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(7, (index) {
                              final day = DateFormat.E('ko_KR')
                                  .format(DateTime.utc(2021, 1, 3)
                                      .add(Duration(days: index)))
                                  .substring(0, 1);
                              return SizedBox(
                                height: 39,
                                child: Center(
                                  child: Text(
                                    day,
                                    style: TextDesign.regular16B,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
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
                      onTap: () {
                        if (buttonColor == Colors.black) {
                          final selectedDateTime =
                              ref.read(selectedDateTimeProvider);
                          print('시간${selectedDateTime.selectedDate}');
                          print('디자이너${selectedDateTime.selectedTimeSlot}');
                          print('디자이너아이디${ref.read(selectedDesignerProvider)}');
                          // Navigate or perform actions
                          ref.read(durationProvider.notifier).state = duration;
                          context.go('/s/${widget.shopDomain}/reservation');
                        }
                      },
                      child: Ink(
                        color: buttonColor,
                        child: Center(
                          child: Text(
                            '예약하기',
                            style: TextDesign.bold16W,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                top: 102, // Adjust to fit below the top bar
                bottom: 57, // Adjust to fit above the bottom bar
                child: SingleChildScrollView(
                  primary: false,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      TableCalendar(
                        availableGestures: AvailableGestures.horizontalSwipe,
                        locale: 'ko_KR',
                        headerVisible: false,
                        rowHeight: 85,
                        sixWeekMonthsEnforced: true,
                        focusedDay: focusedDate,
                        firstDay: firstDayOfCurrentMonth,
                        lastDay: DateTime(
                          lastDayOfReservation.year,
                          lastDayOfReservation.month + 2,
                          0,
                        ),
                        calendarFormat: CalendarFormat.month,
                        enabledDayPredicate: (day) =>
                            !occupiedDates.contains(
                                DateFormat('yyyy-MM-dd').format(day)) &&
                            day.isAfter(
                                today.subtract(const Duration(days: 1))) &&
                            day.isBefore(lastDayOfReservation),
                        selectedDayPredicate: (day) =>
                            isSameDay(selectedDate, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(selectedDate, selectedDay)) {
                            setState(() {
                              selectedDate = selectedDay;
                              if (selectedDay.month != focusedDate.month ||
                                  selectedDay.year != focusedDate.year) {
                                focusedDate = DateTime(
                                    selectedDay.year, selectedDay.month, 1);
                              }
                            });

                            ref
                                .read(timeSlotsProvider(widget.shopDomain)
                                    .notifier)
                                .getAvailableTimeSlots(
                                  date: DataUtils.apiDateFormat(selectedDay),
                                  request: createSelectedTreatmentsRequest(
                                    selectedTreatments,
                                  ),
                                );
                            ref
                                .read(selectedDesignerProvider.notifier)
                                .clearSelection();
                            ref
                                .read(selectedDateTimeProvider.notifier)
                                .clearSelections();
                            ref
                                .read(selectedDateTimeProvider.notifier)
                                .setSelectedDate(
                                    DataUtils.apiDateFormat(selectedDay));
                          }
                        },
                        daysOfWeekVisible: false,
                        onPageChanged: (focusedDay) {
                          setState(() {
                            focusedDate = focusedDay;
                          });
                        },
                        calendarBuilders: CalendarBuilders(
                          outsideBuilder: (context, day, focusedDay) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 45,
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextDesign.regular16B,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            );
                          },
                          defaultBuilder: (context, day, focusedDay) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 45,
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextDesign.regular16B,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            );
                          },
                          todayBuilder: (context, day, focusedDay) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 45,
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextDesign.regular16BO,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                              ],
                            );
                          },
                          selectedBuilder: (context, day, focusedDay) {
                            return Column(
                              children: [
                                Container(
                                  color: ContainerColors.black,
                                  height: 45,
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextDesign.regular16W,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  color: ContainerColors.black,
                                ),
                              ],
                            );
                          },
                          disabledBuilder: (context, day, focusedDay) {
                            final isToday = isSameDay(day, today);
                            return Column(
                              children: [
                                SizedBox(
                                  height: 45,
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: isToday
                                          ? TextDesign.regular16BO
                                          : TextDesign.regular16MG,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: day.isAfter(lastDayOfReservation) ||
                                          occupiedDates.contains(
                                              DateFormat('yyyy-MM-dd')
                                                  .format(day))
                                      ? Center(
                                          child: Text(
                                            day.isAfter(lastDayOfReservation)
                                                ? '오픈전'
                                                : '마감',
                                            style: isToday
                                                ? TextDesign.regular16BO
                                                : TextDesign.regular16MG,
                                          ),
                                        )
                                      : null,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      TimeSlotGrid(
                        shopDomain: widget.shopDomain,
                        selectDesigner: shopData.selectDesigner,
                      ),
                    ],
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
