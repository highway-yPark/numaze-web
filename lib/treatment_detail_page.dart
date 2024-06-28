import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common_app_bar.dart';
import 'package:numaze_web/provider.dart';
import 'package:numaze_web/styles_provider.dart';

import 'common/components/custom_snackbar.dart';
import 'common/components/inkwell_button.dart';
import 'common/const/colors.dart';
import 'common/const/text.dart';
import 'cursor_pagination_model.dart';
import 'list_model.dart';
import 'model.dart';
import 'monthly_pick_provider.dart';
import 'shop_styles_provider.dart';
import 'treatments_provider.dart';
import 'utils.dart';

class TreatmentDetailPage extends ConsumerWidget {
  final String shopDomain;
  final int treatmentId;
  final int? monthlyPickId;
  final int? styleId;
  final int? treatmentStyleId;

  const TreatmentDetailPage({
    super.key,
    required this.shopDomain,
    required this.treatmentId,
    this.monthlyPickId,
    this.styleId,
    this.treatmentStyleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final treatment = treatments.data
        .expand((category) => category.treatments)
        .firstWhere((element) => element.id == treatmentId);

    final category = treatments.data
        .firstWhere((element) => element.treatments.contains(treatment));

    final optionsState = ref.watch(optionsProvider(shopDomain));
    if (optionsState is ListLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (optionsState is ListError) {
      return const Center(
        child: Text('에러가 발생했습니다.'),
      );
    }

    final options = (optionsState as ListModel<OptionCategory>).data;

    final relatedOptions = options
        .map((category) => category.copyWith(
              options: category.options
                  .where((option) => treatment.optionIds.contains(option.id))
                  .toList(),
            ))
        .where((category) => category.options.isNotEmpty)
        .toList();

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
    MonthlyPickModel? monthlyPick = monthlyPickId == null
        ? null
        : monthlyPicks.data.firstWhere(
            (element) =>
                element.treatmentId == treatmentId &&
                element.styleId == monthlyPickId,
          );

    final stylesState = ref.watch(shopStylesProvider(shopDomain));

    if (stylesState is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (stylesState is CursorPaginationError) {
      return const Center(
        child: Text('Error occurred.'),
      );
    }

    final styles = styleId != null
        ? (stylesState as CursorPagination<StyleModel>).data
        : [];
    StyleModel? style = styleId == null
        ? null
        : styles.firstWhere((element) => element.styleId == styleId);

    final treatmentStylesState = ref.watch(stylesProvider(treatmentId));

    if (treatmentStylesState is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (treatmentStylesState is CursorPaginationError) {
      return const Center(
        child: Text('Error occurred.'),
      );
    }

    final treatmentStyles =
        (treatmentStylesState as CursorPagination<StyleModel>).data;

    StyleModel? treatmentStyle = treatmentStyleId == null
        ? null
        : treatmentStyles
            .firstWhere((element) => element.styleId == treatmentStyleId);

    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CommonAppBar(
                        title: '',
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              Column(
                                children: [
                                  Image.network(
                                    styleId == null
                                        ? monthlyPickId == null
                                            ? treatmentStyleId == null
                                                ? treatment.thumbnail
                                                : treatmentStyle!.thumbnail
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
                              if (treatment.styleCount > 0)
                                Positioned(
                                  bottom: 0,
                                  right: 27,
                                  child: OverlayImageWithText(
                                    shopDomain: shopDomain,
                                    treatmentId: treatmentId,
                                    styleCount: treatment.styleCount,
                                    thumbnail: treatmentStyles.first.thumbnail,
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
                              style: TextDesign.bold20B,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              treatment.description,
                              style: TextDesign.regular14G,
                            ),
                            const SizedBox(
                              height: 15.0,
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
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${DataUtils.formatKoreanWon(treatment.minPrice)}${treatment.maxPrice != null ? ' ~ ${DataUtils.formatKoreanWon(treatment.maxPrice!)}' : ''}",
                                        style: TextDesign.regular14G.copyWith(
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${DataUtils.formatKoreanWon(treatment.minPrice * (100 - treatment.discount) ~/ 100)}${treatment.maxPrice != null ? ' ~ ${DataUtils.formatKoreanWon(treatment.maxPrice! * (100 - treatment.discount) ~/ 100)}' : ''}",
                                    style: TextDesign.bold20B,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
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
                              height: 15,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.lock_clock,
                                ),
                                Text(
                                  '소요시간 : ${DataUtils.formatDurationWithZero(treatment.duration)}',
                                  style: TextDesign.medium14G,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 114,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 57,
                      width: MediaQuery.sizeOf(context).width,
                      child: BlackInkwellButton(
                        onTap: () {
                          final isSelected = ref
                              .watch(selectedTreatmentProvider)
                              .containsKey(category.id);
                          if (isSelected) {
                            customSnackBar('카테고리당 하나의 시술만 담을 수 있어요.', context);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //         content: Text(
                            //             'You can only select one treatment per category.')));
                            // context.go('/s/$shopDomain');
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
                                        treatmentStyleImage:
                                            treatmentStyleId == null
                                                ? null
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
                                        treatmentStyleImage:
                                            treatmentStyleId == null
                                                ? null
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
                                        .read(
                                            selectedTreatmentProvider.notifier)
                                        .state
                                        .update(
                                          category.id,
                                          (value) => SelectedCategory(
                                            selectedTreatments: [
                                              SelectedTreatment(
                                                treatmentId: treatmentId,
                                                selectedOptions:
                                                    selectedOptions,
                                                styleId: styleId,
                                                monthlyPickId: monthlyPickId,
                                                treatmentStyleId:
                                                    treatmentStyleId,
                                                styleImage: styleId == null
                                                    ? null
                                                    : style!.thumbnail,
                                                monthlyPickImage:
                                                    monthlyPickId == null
                                                        ? null
                                                        : monthlyPick!
                                                            .thumbnail,
                                                treatmentStyleImage:
                                                    treatmentStyleId == null
                                                        ? null
                                                        : treatmentStyle!
                                                            .thumbnail,
                                              )
                                            ],
                                          ),
                                          ifAbsent: () => SelectedCategory(
                                            selectedTreatments: [
                                              SelectedTreatment(
                                                treatmentId: treatmentId,
                                                selectedOptions:
                                                    selectedOptions,
                                                styleId: styleId,
                                                monthlyPickId: monthlyPickId,
                                                treatmentStyleId:
                                                    treatmentStyleId,
                                                styleImage: styleId == null
                                                    ? null
                                                    : style!.thumbnail,
                                                monthlyPickImage:
                                                    monthlyPickId == null
                                                        ? null
                                                        : monthlyPick!
                                                            .thumbnail,
                                                treatmentStyleImage:
                                                    treatmentStyleId == null
                                                        ? null
                                                        : treatmentStyle!
                                                            .thumbnail,
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
                ),
              ],
            ),
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
        context.go('/s/$shopDomain/treatmentStyles?treatmentId=$treatmentId');
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    thumbnail), // Replace with your overlay image URL
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.2),
            child: Text(
              '+$styleCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
    return Container(
      color: ContainerColors.white,
      height: MediaQuery.of(context).size.height * 0.71,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                // shrinkWrap: true,
                children: [
                  ...widget.relatedOptions.map((category) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: (isExpanded[category.name] == true)
                                  ? StrokeColors.black
                                  : StrokeColors.grey,
                              width: 1.0,
                            ),
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
                                  height: 50,
                                  padding: const EdgeInsets.all(15.0),
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
                                            ? category.options
                                                .firstWhere((option) =>
                                                    option.id ==
                                                    selectedOptions[
                                                        category.name])
                                                .name
                                            : category.name,
                                        style: TextDesign.medium14B,
                                      ),
                                      Icon(
                                        isExpanded[category.name] ?? false
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                      ),
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
                        const SizedBox(
                          height: 9,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          if (areAllOptionsSelected() && areAllCategoriesCollapsed()) ...[
            SizedBox(
              height: 57,
              child: BlackInkwellButton(
                onTap: () {
                  widget.onOptionSelected(selectedOptions);
                  Navigator.of(context).pop();
                  context.go('/s/${widget.shopDomain}');
                },
                text: '담기',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
