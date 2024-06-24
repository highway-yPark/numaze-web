import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common/components/custom_snackbar.dart';
import 'package:numaze_web/common/const/colors.dart';

import 'common/const/text.dart';
import 'model.dart';
import 'provider.dart';
import 'utils.dart';

class TreatmentBox extends ConsumerWidget {
  final int categoryId;
  final String categoryName;
  final String shopDomain;
  final TreatmentModel treatment;

  const TreatmentBox({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.shopDomain,
    required this.treatment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected =
        ref.watch(selectedTreatmentProvider).containsKey(categoryId) &&
            ref
                .watch(selectedTreatmentProvider)[categoryId]!
                .selectedTreatments
                .any((t) => t.treatmentId == treatment.id);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: InkWell(
        onTap: () {
          if (isSelected) {
            // remove treatment from selectedTreatmentProvider, i want to remove the entire category
            ref.read(selectedTreatmentProvider.notifier).update((state) {
              state.remove(categoryId);
              return {...state};
            });
          } else {
            final selectedCategory =
                ref.read(selectedTreatmentProvider.notifier).state;
            if (selectedCategory.containsKey(categoryId) &&
                selectedCategory[categoryId]!.selectedTreatments.isNotEmpty) {
              customSnackBar('카테고리당 하나의 시술담 담을 수 있어요.', context);
              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //     content:
              //         Text('You can only select one treatment per category.')));
            } else {
              context.go('/s/$shopDomain/sisul?treatmentId=${treatment.id}');
            }
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  treatment.thumbnail,
                  width: 115,
                  height: 115,
                ),
                if (isSelected)
                  const Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: BrandColors.orange,
                      size: 24,
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 19,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    treatment.name,
                    style: TextDesign.bold16B,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                    treatment.description,
                    style: TextDesign.regular14G,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  if (treatment.discount > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${treatment.discount}%',
                              style: TextDesign.medium14BO,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${DataUtils.formatKoreanWon(treatment.minPrice)}${treatment.maxPrice != null ? ' ~ ${DataUtils.formatKoreanWon(treatment.maxPrice!)}' : ''}",
                              style: TextDesign.regular12G.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Text(
                          "${DataUtils.formatKoreanWon(treatment.minPrice * (100 - treatment.discount) ~/ 100)}${treatment.maxPrice != null ? ' ~ ${DataUtils.formatKoreanWon(treatment.maxPrice! * (100 - treatment.discount) ~/ 100)}' : ''}",
                          style: TextDesign.bold16B,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  else
                    Text(
                      "${DataUtils.formatKoreanWon(treatment.minPrice)}${treatment.maxPrice != null ? ' ~ ${DataUtils.formatKoreanWon(treatment.maxPrice!)}' : ''}",
                      style: TextDesign.bold16B,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(
                    height: 11,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.lock_clock,
                      ),
                      Text(
                        '소요시간 : ${DataUtils.formatDurationWithZero(treatment.duration)}',
                        style: TextDesign.regular14G,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
