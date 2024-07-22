import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'common/const/colors.dart';
import 'common/const/text.dart';
import 'model/model.dart';
import 'provider/occupied_dates_provider.dart';
import 'provider/provider.dart';
import 'utils.dart';

class TreatmentReservationButton extends ConsumerWidget {
  final String shopDomain;
  final int futureReservationDays;

  const TreatmentReservationButton({
    super.key,
    required this.futureReservationDays,
    required this.shopDomain,
  });

  // Conversion function from SelectedTreatment to TreatmentOptionPair
  TreatmentOptionPair convertToTreatmentOptionPair(
      SelectedTreatment selectedTreatment) {
    return TreatmentOptionPair(
      treatment_id: selectedTreatment.treatmentId,
      option_ids: selectedTreatment.selectedOptions.values.toList(),
    );
  }

// Collect and convert all SelectedTreatment instances
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

// Create the SelectedTreatmentsRequest instance
  SelectedTreatmentsRequest createSelectedTreatmentsRequest(
      Map<int, SelectedCategory> selectedTreatmentProvider) {
    List<TreatmentOptionPair> treatmentOptionPairs =
        collectAndConvert(selectedTreatmentProvider);
    return SelectedTreatmentsRequest(
        treatment_option_pairs: treatmentOptionPairs);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTreatments = ref.watch(selectedTreatmentProvider);
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // for (final entry in selectedTreatments.entries) {
            //   print('Category ID: ${entry.key}');
            //   for (final treatment in entry.value.selectedTreatments) {
            //     print('Treatment ID: ${treatment.treatmentId}');
            //     print('options: ${treatment.selectedOptions}');
            //     print('styleId: ${treatment.styleId}');
            //     print('monthlyPick: ${treatment.monthlyPickId}');
            //     print('treatmentStyleId: ${treatment.treatmentStyleId}');
            //   }
            // }

            final startDate = DateTime.now();
            final endDate =
                DateTime.now().add(Duration(days: futureReservationDays));

            ref
                .read(occupiedDatesProvider(shopDomain).notifier)
                .getOccupiedDates(
                  startDate: DataUtils.apiDateFormat(startDate),
                  endDate: DataUtils.apiDateFormat(endDate),
                  request: createSelectedTreatmentsRequest(selectedTreatments),
                );
            context.go('/s/$shopDomain/calendar');
          },
          child: Ink(
            height: 72,
            color: ContainerColors.black,
            padding: const EdgeInsets.symmetric(
              vertical: 23.5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '예약하기',
                  style: TextDesign.bold20BO,
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: BrandColors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${selectedTreatments.length}',
                    style: TextDesign.bold12W,
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
