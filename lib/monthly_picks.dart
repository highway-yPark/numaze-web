import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common/const/colors.dart';
import 'package:numaze_web/model/list_model.dart';
import 'package:numaze_web/model/model.dart';
import 'package:numaze_web/provider/provider.dart';
import 'package:numaze_web/provider/treatments_provider.dart';
import 'package:numaze_web/utils.dart';

import 'common/const/text.dart';
import 'components/common_image.dart';
import 'components/custom_snackbar.dart';

class MonthlyPicks extends ConsumerWidget {
  final List<MonthlyPickModel> monthlyPicks;
  final String shopDomain;

  const MonthlyPicks({
    super.key,
    required this.monthlyPicks,
    required this.shopDomain,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final monthlyPicksState = ref.watch(monthlyPickProvider(shopDomain));
    // if (monthlyPicksState is ListLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    //
    // if (monthlyPicksState is ListError) {
    //   return Center(
    //     child: Text(monthlyPicksState.data),
    //   );
    // }
    // final monthlyPicks = monthlyPicksState as ListModel<MonthlyPickModel>;
    final treatmentsState = ref.watch(treatmentProvider(shopDomain));
    if (treatmentsState is ListLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: StrokeColors.black,
        ),
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
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: monthlyPicks.length,
          itemBuilder: (context, index) {
            final monthlyPick = monthlyPicks[index];
            final treatment = treatments.data
                .expand((category) => category.treatments)
                .firstWhere((element) => element.id == monthlyPick.treatmentId);
            return GestureDetector(
              onTap: () {
                final isSelected = ref
                    .watch(selectedTreatmentProvider)
                    .containsKey(monthlyPick.categoryId);
                if (isSelected) {
                  onlyOneSnackBar(context: context);
                } else {
                  context.go(
                      '/s/$shopDomain/sisul?treatmentId=${treatment.id}&monthlyPickId=${monthlyPick.styleId}');
                }
              },
              child: Container(
                width: 135,
                margin: EdgeInsets.only(
                  left: index == 0 ? 16 : 19,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonImage(
                      imageUrl: monthlyPick.thumbnail,
                      width: 135,
                      height: 135,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    Text(
                      '${monthlyPick.categoryName} > ${monthlyPick.treatmentName}',
                      style: TextDesign.regular12B,
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
                              style: TextDesign.bold12BO,
                            ),
                          if (treatment.discount > 0)
                            TextSpan(
                              text:
                                  " ${DataUtils.formatMoney(treatment.minPrice * (100 - treatment.discount) ~/ 100)}${treatment.maxPrice != null ? '~${DataUtils.formatMoney(treatment.maxPrice! * (100 - treatment.discount) ~/ 100)}' : ''}",
                              style: TextDesign.bold12B, // Default text color
                            ),
                          if (treatment.discount == 0)
                            TextSpan(
                              text:
                                  "${DataUtils.formatMoney(treatment.minPrice)}${treatment.maxPrice != null ? '~${DataUtils.formatMoney(treatment.maxPrice!)}' : ''}",
                              style: TextDesign.bold12B, // Default text color
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
