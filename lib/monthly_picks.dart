import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/list_model.dart';
import 'package:numaze_web/model.dart';
import 'package:numaze_web/monthly_pick_provider.dart';
import 'package:numaze_web/provider.dart';
import 'package:numaze_web/treatments_provider.dart';
import 'package:numaze_web/utils.dart';

import 'common/components/custom_snackbar.dart';
import 'common/const/text.dart';

class MonthlyPicks extends ConsumerWidget {
  final String shopDomain;

  const MonthlyPicks({
    super.key,
    required this.shopDomain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyPicksState = ref.watch(monthlyPickProvider(shopDomain));
    if (monthlyPicksState is ListLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (monthlyPicksState is ListError) {
      return Center(
        child: Text(monthlyPicksState.data),
      );
    }
    final monthlyPicks = monthlyPicksState as ListModel<MonthlyPickModel>;
    final treatmentsState = ref.watch(treatmentProvider(shopDomain));
    if (treatmentsState is ListLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (treatmentsState is ListError) {
      return const Center(
        child: Text('에러가 발생했습니다.'),
      );
    }
    final treatments = (treatmentsState as ListModel<TreatmentCategory>);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: monthlyPicks.data.length,
          itemBuilder: (context, index) {
            final monthlyPick = monthlyPicks.data[index];
            final treatment = treatments.data
                .expand((category) => category.treatments)
                .firstWhere((element) => element.id == monthlyPick.treatmentId);
            return Padding(
              padding: const EdgeInsets.only(
                right: 19,
              ),
              child: GestureDetector(
                onTap: () {
                  final isSelected = ref
                      .watch(selectedTreatmentProvider)
                      .containsKey(monthlyPick.categoryId);
                  if (isSelected) {
                    customSnackBar('카테고리당 하나의 시술담 담을 수 있어요.', context);
                    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //     content: Text(
                    //         'You can only select one treatment per category.')));
                  } else {
                    context.go(
                        '/s/$shopDomain/sisul?treatmentId=${treatment.id}&monthlyPickId=${monthlyPick.styleId}');
                  }
                },
                child: SizedBox(
                  width: 128,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        monthlyPick.thumbnail,
                        width: 128,
                        height: 128,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Text(
                        '${monthlyPick.categoryName} > ${monthlyPick.treatmentName}',
                        style: TextDesign.regular12G,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            if (treatment.discount > 0)
                              TextSpan(
                                text: "${treatment.discount}%",
                                style: TextDesign
                                    .regular12BO, // Change color for discount percentage
                              ),
                            if (treatment.discount > 0)
                              TextSpan(
                                text:
                                    " ${DataUtils.formatMoney(treatment.minPrice * (100 - treatment.discount) ~/ 100)}${treatment.maxPrice != null ? '~${DataUtils.formatMoney(treatment.maxPrice! * (100 - treatment.discount) ~/ 100)}' : ''}",
                                style:
                                    TextDesign.regular12B, // Default text color
                              ),
                            if (treatment.discount == 0)
                              TextSpan(
                                text:
                                    "${DataUtils.formatMoney(treatment.minPrice)}${treatment.maxPrice != null ? '~${DataUtils.formatMoney(treatment.maxPrice!)}' : ''}",
                                style:
                                    TextDesign.regular12B, // Default text color
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
