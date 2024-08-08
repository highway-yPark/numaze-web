import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common/const/icons.dart';
import 'package:numaze_web/common/const/widgets.dart';
import 'package:numaze_web/provider/provider.dart';
import 'package:numaze_web/provider/styles_provider.dart';
import 'package:numaze_web/view/404_page.dart';

import '../common/const/colors.dart';
import '../common/const/text.dart';
import '../components/common_image.dart';
import '../components/custom_snackbar.dart';
import '../components/inkwell_button.dart';
import '../cursor_pagination_model.dart';
import '../main.dart';
import '../model/list_model.dart';
import '../model/model.dart';
import '../provider/monthly_pick_provider.dart';
import '../provider/shop_styles_provider.dart';
import '../provider/treatments_provider.dart';
import '../utils.dart';
import 'empty_treatment_page.dart';

class TreatmentDetailPage extends ConsumerWidget {
  final String shopDomain;
  final int treatmentId;
  final int? monthlyPickId;
  final int? styleId;
  final int? treatmentStyleId;
  // final int? currentIndex;

  const TreatmentDetailPage({
    super.key,
    required this.shopDomain,
    required this.treatmentId,
    this.monthlyPickId,
    this.styleId,
    this.treatmentStyleId,
    // this.currentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treatmentsState = ref.watch(treatmentProvider(shopDomain));
    final optionsState = ref.watch(optionsProvider(shopDomain));
    final monthlyPicksState = ref.watch(monthlyPickProvider(shopDomain));
    final stylesState = ref.watch(shopStylesProvider(shopDomain));
    final treatmentStylesState = ref.watch(stylesProvider(treatmentId));

    if (treatmentsState is ListError ||
        optionsState is ListError ||
        monthlyPicksState is ListError ||
        stylesState is CursorPaginationError ||
        treatmentStylesState is CursorPaginationError) {
      return const PageNotFound();
    }

    if (treatmentsState is ListLoading ||
        optionsState is ListLoading ||
        monthlyPicksState is ListLoading ||
        stylesState is CursorPaginationLoading ||
        treatmentStylesState is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: StrokeColors.black,
        ),
      );
    }

    final treatments = (treatmentsState as ListModel<TreatmentCategory>);
    final treatment = treatments.data
        .expand((category) => category.treatments)
        .firstWhere((element) => element.id == treatmentId);

    final category = treatments.data
        .firstWhere((element) => element.treatments.contains(treatment));

    final options = (optionsState as ListModel<OptionCategory>).data;

    final relatedOptions = options
        .map((category) => category.copyWith(
              options: category.options
                  .where((option) => treatment.optionIds.contains(option.id))
                  .toList(),
            ))
        .where((category) => category.options.isNotEmpty)
        .toList();

    final monthlyPicks = monthlyPicksState as ListModel<MonthlyPickModel>;
    MonthlyPickModel? monthlyPick = monthlyPickId == null
        ? null
        : monthlyPicks.data.firstWhere(
            (element) =>
                element.treatmentId == treatmentId &&
                element.styleId == monthlyPickId,
          );

    final styles = styleId != null
        ? (stylesState as CursorPagination<StyleModel>).data
        : [];

    StyleModel? style = styleId == null
        ? null
        : styles.firstWhereOrNull((element) => element.styleId == styleId);

    final treatmentStyles =
        (treatmentStylesState as CursorPagination<StyleModel>);

    StyleModel? treatmentStyle = treatmentStyleId == null
        ? null
        : treatmentStyles.data
            .firstWhereOrNull((element) => element.styleId == treatmentStyleId);

    if (style == null &&
        treatmentStyle == null &&
        (styleId != null || treatmentStyleId != null)) {
      return EmptyTreatmentPage(
        shopDomain: shopDomain,
      );
    }

    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    CommonImage(
                                      imageUrl: styleId == null
                                          ? monthlyPickId == null
                                              ? treatmentStyleId == null
                                                  ? treatment.thumbnail
                                                  : treatmentStyle!.thumbnail
                                              // : treatmentStyles
                                              //     .data[currentIndex!]
                                              //     .thumbnail
                                              : monthlyPick!.thumbnail
                                          : style!.thumbnail,
                                      width: constraints.maxWidth,
                                      height: constraints.maxWidth,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      height: 23.5,
                                      color: ContainerColors.white,
                                    )
                                  ],
                                ),
                                //     if (treatmentStyleId != null &&
                                //         currentIndex! > 0)
                                //       Align(
                                //         alignment: Alignment.centerLeft,
                                //         child: Container(
                                //           color: Colors.pink,
                                //           child: IconButton(
                                //             onPressed: () {
                                //               // i want to change the image shown in above CommonImage widget with the previous style image
                                //               if (currentIndex! > 0) {
                                //                 setState(() {
                                //                   currentIndex = currentIndex! - 1;
                                //                   treatmentStyleId = treatmentStyles
                                //                       .data[currentIndex!].styleId;
                                //                 });
                                //               }
                                //
                                //               // context.go(
                                //               //     '/s/$shopDomain/styleFullScreen?styleId=${treatmentStyle!.styleId}');
                                //             },
                                //             icon: Icon(
                                //               Icons.arrow_back_ios,
                                //               color: ContainerColors.black,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     if (treatmentStyleId != null &&
                                //         currentIndex! <
                                //             treatmentStyles.meta.total - 1)
                                //       Align(
                                //         alignment: Alignment.centerRight,
                                //         child: Container(
                                //           color: Colors.pink,
                                //           child: IconButton(
                                //             onPressed: () {
                                //               // i want to change the image shown in above CommonImage widget with the next style image
                                //               if (currentIndex! <=
                                //                   treatmentStyles.meta.total - 2) {
                                //                 ref
                                //                     .read(stylesProvider(
                                //                             widget.treatmentId)
                                //                         .notifier)
                                //                     .paginate(
                                //                       fetchMore: true,
                                //                     );
                                //               }
                                //               if (currentIndex! <
                                //                   treatmentStyles.meta.total - 1) {
                                //                 setState(() {
                                //                   currentIndex = currentIndex! + 1;
                                //                   treatmentStyleId = treatmentStyles
                                //                       .data[currentIndex!].styleId;
                                //                 });
                                //               }
                                //
                                //               // context.go(
                                //               //     '/s/$shopDomain/styleFullScreen?styleId=${treatmentStyle!.styleId}');
                                //             },
                                //             icon: Icon(
                                //               Icons.arrow_forward_ios,
                                //               color: ContainerColors.black,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                              ],
                            ),
                            if (treatment.styleCount > 0)
                              Positioned(
                                bottom: 4,
                                right: 13,
                                child: Container(
                                  width: 37,
                                  height: 37,
                                  decoration: BoxDecoration(
                                    color: ContainerColors.sBGrey,
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ContainerColors.black
                                            .withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 10,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (treatment.styleCount > 0)
                              Positioned(
                                bottom: 2,
                                right: 20,
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: ContainerColors.ctaGrey,
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ContainerColors.black
                                            .withOpacity(0.1),
                                        spreadRadius: 0,
                                        blurRadius: 10,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (treatment.styleCount > 0)
                              Positioned(
                                bottom: 0,
                                right: 27,
                                child: OverlayImageWithText(
                                  shopDomain: shopDomain,
                                  treatmentId: treatmentId,
                                  styleCount: treatment.styleCount,
                                  thumbnail:
                                      treatmentStyles.data.first.thumbnail,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${category.name} > ${treatment.name}',
                            style: TextDesign.bold18B,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            treatment.description,
                            style: TextDesign.regular14G,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          if (treatment.discount > 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${treatment.discount}%',
                                      style: TextDesign.bold14BO,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      "${DataUtils.formatKoreanWon(treatment.minPrice)}${treatment.maxPrice != null ? ' ~ ${DataUtils.formatKoreanWon(treatment.maxPrice!)}' : ''}",
                                      style: TextDesign.regular14G.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                Text(
                                  "${DataUtils.formatKoreanWon(treatment.minPrice * (100 - treatment.discount) ~/ 100)}${treatment.maxPrice != null ? ' ~ ${DataUtils.formatKoreanWon(treatment.maxPrice! * (100 - treatment.discount) ~/ 100)}' : ''}",
                                  style: TextDesign.bold20B,
                                ),
                              ],
                            )
                          else
                            Text(
                              "${DataUtils.formatKoreanWon(treatment.minPrice)}${treatment.maxPrice != null ? ' ~ ${DataUtils.formatKoreanWon(treatment.maxPrice!)}' : ''}",
                              style: TextDesign.bold20B,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              CommonIcons.clock(),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                '소요시간 ${DataUtils.formatDurationWithZero(treatment.duration)}',
                                style: TextDesign.medium14G,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 110,
                    ),
                  ],
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: BlackInkwellButton(
                    onTap: () {
                      final isSelected = ref
                          .watch(selectedTreatmentProvider)
                          .containsKey(category.id);
                      if (isSelected) {
                        onlyOneSnackBar(
                          context: context,
                          message: category.name,
                        );
                        return;
                      }
                      if (relatedOptions.isEmpty) {
                        ref
                            .read(selectedTreatmentProvider.notifier)
                            .state
                            .update(
                              category.id,
                              (value) => SelectedCategory(
                                selectedTreatments: [
                                  SelectedTreatment(
                                    treatmentId: treatmentId,
                                    selectedOptions: {},
                                    styleId: styleId,
                                    monthlyPickId: monthlyPickId,
                                    treatmentStyleId: treatmentStyleId,
                                    styleImage: styleId == null
                                        ? null
                                        : style!.thumbnail,
                                    monthlyPickImage: monthlyPickId == null
                                        ? null
                                        : monthlyPick!.thumbnail,
                                    treatmentStyleImage: treatmentStyleId ==
                                            null
                                        ? null
                                        // : treatmentStyles
                                        //     .data[currentIndex!].thumbnail,
                                        : treatmentStyle!.thumbnail,
                                  )
                                ],
                              ),
                              ifAbsent: () => SelectedCategory(
                                selectedTreatments: [
                                  SelectedTreatment(
                                    treatmentId: treatmentId,
                                    selectedOptions: {},
                                    styleId: styleId,
                                    monthlyPickId: monthlyPickId,
                                    treatmentStyleId: treatmentStyleId,
                                    styleImage: styleId == null
                                        ? null
                                        : style!.thumbnail,
                                    monthlyPickImage: monthlyPickId == null
                                        ? null
                                        : monthlyPick!.thumbnail,
                                    treatmentStyleImage: treatmentStyleId ==
                                            null
                                        ? null
                                        // : treatmentStyles
                                        //     .data[currentIndex!].thumbnail,
                                        : treatmentStyle!.thumbnail,
                                  )
                                ],
                              ),
                            );
                        Navigator.of(context).pop();
                        context.go('/s/$shopDomain');
                      } else {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return OptionsBottomSheet(
                              relatedOptions: relatedOptions,
                              shopDomain: shopDomain,
                              onOptionSelected: (selectedOptions) {
                                ref
                                    .read(selectedTreatmentProvider.notifier)
                                    .state
                                    .update(
                                      category.id,
                                      (value) => SelectedCategory(
                                        selectedTreatments: [
                                          SelectedTreatment(
                                            treatmentId: treatmentId,
                                            selectedOptions: selectedOptions,
                                            styleId: styleId,
                                            monthlyPickId: monthlyPickId,
                                            treatmentStyleId: treatmentStyleId,
                                            styleImage: styleId == null
                                                ? null
                                                : style!.thumbnail,
                                            monthlyPickImage:
                                                monthlyPickId == null
                                                    ? null
                                                    : monthlyPick!.thumbnail,
                                            treatmentStyleImage:
                                                treatmentStyleId == null
                                                    ? null
                                                    // : treatmentStyles
                                                    //     .data[currentIndex!]
                                                    //     .thumbnail,
                                                    : treatmentStyle!.thumbnail,
                                          )
                                        ],
                                      ),
                                      ifAbsent: () => SelectedCategory(
                                        selectedTreatments: [
                                          SelectedTreatment(
                                            treatmentId: treatmentId,
                                            selectedOptions: selectedOptions,
                                            styleId: styleId,
                                            monthlyPickId: monthlyPickId,
                                            treatmentStyleId: treatmentStyleId,
                                            styleImage: styleId == null
                                                ? null
                                                : style!.thumbnail,
                                            monthlyPickImage:
                                                monthlyPickId == null
                                                    ? null
                                                    : monthlyPick!.thumbnail,
                                            treatmentStyleImage:
                                                treatmentStyleId == null
                                                    ? null
                                                    // : treatmentStyles
                                                    //     .data[currentIndex!]
                                                    //     .thumbnail,
                                                    : treatmentStyle!.thumbnail,
                                          )
                                        ],
                                      ),
                                    );
                              },
                            );
                          },
                        );
                      }

                      // if (!context.mounted) return;
                    },
                    text: relatedOptions.isEmpty ? '담기' : '옵션 선택하기',
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 14,
                child: GestureDetector(
                  onTap: () {
                    context.go('/s/$shopDomain');
                  },
                  child: CommonIcons.treatmentHome(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OverlayImageWithText extends StatelessWidget {
  final String shopDomain;
  final int treatmentId;
  final int styleCount;
  final String thumbnail;
  const OverlayImageWithText({
    super.key,
    required this.shopDomain,
    required this.treatmentId,
    required this.styleCount,
    required this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        analytics.logEvent(name: 'treatment_style_button');
        context.go('/s/$shopDomain/treatmentStyles?treatmentId=$treatmentId');
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 47,
            height: 47,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  thumbnail,
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Container(
            width: 47,
            height: 47,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ContainerColors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              styleCount < 1000 ? '+$styleCount' : '+999',
              style: TextDesign.bold14W,
            ),
          ),
        ],
      ),
    );
  }
}

class OptionsBottomSheet extends StatefulWidget {
  final String shopDomain;
  final List<OptionCategory> relatedOptions;
  final Function(Map<String, int>) onOptionSelected;

  const OptionsBottomSheet({
    super.key,
    required this.shopDomain,
    required this.relatedOptions,
    required this.onOptionSelected,
  });

  @override
  State<OptionsBottomSheet> createState() => _OptionsBottomSheetState();
}

class _OptionsBottomSheetState extends State<OptionsBottomSheet> {
  Map<String, int> selectedOptions = {};
  Map<String, bool> isExpanded = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.relatedOptions.length; i++) {
      isExpanded[widget.relatedOptions[i].name] = i == 0;
    }
  }

  void handleOptionSelected(String categoryName, int optionId) {
    setState(() {
      selectedOptions[categoryName] = optionId;
      isExpanded[categoryName] = false;
      openNextCategory(categoryName);
    });
  }

  void openNextCategory(String categoryName) {
    final currentIndex = widget.relatedOptions
        .indexWhere((category) => category.name == categoryName);
    if (currentIndex < widget.relatedOptions.length - 1) {
      final nextCategory = widget.relatedOptions[currentIndex + 1];
      setState(() {
        isExpanded.updateAll((key, value) => false);
        isExpanded[nextCategory.name] = true;
      });
    }
  }

  void handleCategoryTap(String categoryName, bool expanded) {
    setState(() {
      isExpanded.updateAll((key, value) => false);
      isExpanded[categoryName] = expanded;
    });
  }

  bool areAllOptionsSelected() {
    return selectedOptions.length == widget.relatedOptions.length;
  }

  bool areAllCategoriesCollapsed() {
    return isExpanded.values.every((element) => !element);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        maxWidth: 500,
      ),
      child: Container(
        color: ContainerColors.white,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 4,
              width: 68,
              decoration: BoxDecoration(
                color: ContainerColors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(
              height: 23,
            ),
            Expanded(
              child: ListView(
                children: [
                  ...widget.relatedOptions.map((category) {
                    return Padding(
                      padding: CommonWidgets.sixteenTenPadding(),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            // color: (isExpanded[category.name] == true)
                            //     ? StrokeColors.black
                            //     : StrokeColors.grey,
                            color: StrokeColors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                handleCategoryTap(category.name,
                                    !(isExpanded[category.name] ?? false));
                              },
                              child: Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: StrokeColors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedOptions[category.name] != null
                                          ? '${category.name} : ${category.options.firstWhere((option) => option.id == selectedOptions[category.name]).name} (+${DataUtils.formatDurationWithZero(category.options.firstWhere((option) => option.id == selectedOptions[category.name]).duration)})'
                                          : category.name,
                                      style: TextDesign.medium14B,
                                    ),
                                    CommonIcons.arrowDown(),
                                  ],
                                ),
                              ),
                            ),
                            if (isExpanded[category.name] ?? false)
                              ...category.options.map((option) {
                                return InkWell(
                                  onTap: () {
                                    handleOptionSelected(
                                        category.name, option.id);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: StrokeColors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${option.name} (+${DataUtils.formatDurationWithZero(option.duration)})',
                                          style: TextDesign.medium14B,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          option.description,
                                          style: TextDesign.medium12G,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            if (areAllOptionsSelected() && areAllCategoriesCollapsed()) ...[
              BlackInkwellButton(
                onTap: () {
                  widget.onOptionSelected(selectedOptions);
                  Navigator.of(context).pop();
                  context.go('/s/${widget.shopDomain}');
                  // Navigator.popUntil(context, (route) => route.isFirst);
                },
                text: '담기',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
