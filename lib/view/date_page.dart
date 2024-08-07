import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:numaze_web/common/const/icons.dart';
import 'package:numaze_web/time_slot_grid.dart';
import 'package:numaze_web/view/404_page.dart';
import 'package:numaze_web/view/empty_treatment_page.dart';
import 'package:numaze_web/view/not_found_page.dart';
import 'package:table_calendar/table_calendar.dart';

import '../common/const/colors.dart';
import '../common/const/text.dart';
import '../components/inkwell_button.dart';
import '../main.dart';
import '../model/list_model.dart';
import '../model/model.dart';
import '../provider/occupied_dates_provider.dart';
import '../provider/provider.dart';
import '../provider/time_slots_provider.dart';
import '../utils.dart';

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
  // i want to with 00:00:00
  DateTime now = DateTime.now();
  late DateTime today;

  late DateTime focusedDate;
  DateTime? selectedDate;
  late ScrollController _scrollController;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    today = DateTime(now.year, now.month, now.day);
    focusedDate = today;
  }

  void scrollToBottomOfWidget() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      return const PageNotFound();
    }

    final shopData = shopBasicInfoState as ShopBasicInfo;
    final selectedDateTime = ref.watch(selectedDateTimeProvider);
    final selectedDesigner = ref.watch(selectedDesignerProvider);
    final timeSlotsState = ref.watch(timeSlotsProvider(widget.shopDomain));

    final buttonColor = (shopData.selectDesigner &&
                (selectedDesigner == null ||
                    selectedDateTime.selectedTimeSlot == null ||
                    selectedDateTime.selectedDate == null ||
                    timeSlotsState is ListEmpty)) ||
            (!shopData.selectDesigner &&
                    selectedDateTime.selectedTimeSlot == null ||
                timeSlotsState is ListEmpty)
        ? Colors.grey
        : Colors.black;

    final occupiedDatesState =
        ref.watch(occupiedDatesProvider(widget.shopDomain));

    if (occupiedDatesState is ListEmpty) {
      return EmptyTreatmentPage(
        shopDomain: widget.shopDomain,
      );
    }
    if (occupiedDatesState is ListLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: StrokeColors.black,
        ),
      );
    }

    if (occupiedDatesState is ListError || timeSlotsState is ListError) {
      return NotFoundPage(
        shopDomain: widget.shopDomain,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16.5,
                        ),
                        child: Row(
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
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        focusedDate = DateTime(
                                          focusedDate.year,
                                          focusedDate.month - 1,
                                        );
                                      });
                                    },
                                    child: CommonIcons.calendarLeftArrow(),
                                  )
                                else
                                  const SizedBox(
                                    width: 24,
                                  ),
                                const SizedBox(
                                  width: 19,
                                ),
                                if (focusedDate.isBefore(lastAvailableMonth) &&
                                    (focusedDate.year !=
                                            lastAvailableMonth.year ||
                                        focusedDate.month !=
                                            lastAvailableMonth.month))
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        focusedDate = DateTime(
                                          focusedDate.year,
                                          focusedDate.month + 1,
                                        );
                                      });
                                    },
                                    child: CommonIcons.calendarRightArrow(),
                                  )
                                else
                                  const SizedBox(
                                    width: 24,
                                  ),
                              ],
                            ),
                          ],
                        ),
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
                                style: TextDesign.semiBold16B,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ConditionalInkwellButton(
                  onTap: () {
                    if (buttonColor == Colors.black) {
                      analytics.logEvent(
                          name: 'calendar_page_reservation_button');
                      ref.read(durationProvider.notifier).state = duration;
                      selectedDate = null;
                      context.go('/s/${widget.shopDomain}/reservation');
                    }
                  },
                  text: '다음',
                  condition: buttonColor == Colors.grey,
                ),
              ),
              Positioned.fill(
                top: 102, // Adjust to fit below the top bar
                bottom: 72, // Adjust to fit above the bottom bar
                child: SingleChildScrollView(
                  controller: _scrollController,
                  primary: false,
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        child: TableCalendar(
                          availableGestures: AvailableGestures.horizontalSwipe,
                          locale: 'ko_KR',
                          headerVisible: false,
                          rowHeight: 70,
                          focusedDay: focusedDate,
                          firstDay: firstDayOfCurrentMonth,
                          lastDay: DateTime(
                            lastDayOfReservation.year,
                            lastDayOfReservation.month + 2,
                            0,
                          ),
                          calendarFormat: CalendarFormat.month,
                          enabledDayPredicate: (day) {
                            final dayKst = day.add(const Duration(hours: 9));
                            return !occupiedDates.contains(
                                    DateFormat('yyyy-MM-dd').format(dayKst)) &&
                                dayKst.isAfter(today) &&
                                dayKst.isBefore(lastDayOfReservation);
                          },
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

                              // scroll to the bottom of the widget
                            }
                            scrollToBottomOfWidget();
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
                                    height: 40,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${day.day}',
                                          style: TextDesign.medium16B,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              );
                            },
                            defaultBuilder: (context, day, focusedDay) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${day.day}',
                                          style: TextDesign.medium16B,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              );
                            },
                            todayBuilder: (context, day, focusedDay) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${day.day}',
                                          style: TextDesign.medium16B,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              );
                            },
                            selectedBuilder: (context, day, focusedDay) {
                              bool isToday = isSameDay(day, today);
                              return Column(
                                children: [
                                  Container(
                                    color: ContainerColors.black,
                                    height: 40,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${day.day}',
                                          style: isToday
                                              ? TextDesign.medium16BO
                                              : TextDesign.medium16W,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 30,
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
                                    height: 40,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${day.day}',
                                          style: isToday
                                              ? TextDesign.medium16BO
                                              : TextDesign.medium16MG,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: day.isAfter(lastDayOfReservation) ||
                                            occupiedDates.contains(
                                                DateFormat('yyyy-MM-dd')
                                                    .format(day))
                                        ? Column(
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                day.isAfter(
                                                        lastDayOfReservation)
                                                    ? '오픈전'
                                                    : '마감',
                                                style: isToday
                                                    ? TextDesign.medium12BO
                                                    : TextDesign.medium12MG,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )
                                        : null,
                                  ),
                                ],
                              );
                            },
                          ),
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
