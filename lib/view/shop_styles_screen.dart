import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/view/style_not_found.dart';

import '../common/const/colors.dart';
import '../common/const/text.dart';
import '../components/grid_style_item.dart';
import '../cursor_pagination_model.dart';
import '../model/list_model.dart';
import '../model/model.dart';
import '../provider/provider.dart';
import '../provider/scroll_position_provider.dart';
import '../provider/shop_styles_provider.dart';
import '../provider/treatments_provider.dart';
import '../treatment_reservation_button.dart';
import '404_page.dart';
import 'shop_main_page.dart';

class ShopStylesScreen extends ConsumerStatefulWidget {
  final String shopDomain;
  const ShopStylesScreen({
    super.key,
    required this.shopDomain,
  });

  @override
  ConsumerState<ShopStylesScreen> createState() => _ShopStylesScreenState();
}

class _ShopStylesScreenState extends ConsumerState<ShopStylesScreen> {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: ref.read(shopStylesScrollPositionProvider),
    );
    _scrollController.addListener(scrollListener);
    _scrollController.addListener(() {
      ref
          .read(shopStylesScrollPositionProvider.notifier)
          .setScrollPosition(_scrollController.position.pixels);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (_scrollController.offset >
        _scrollController.position.maxScrollExtent - 300) {
      ref.read(shopStylesProvider(widget.shopDomain).notifier).paginate(
            fetchMore: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: make a provider to watch treatments and get its first category to send a query parameter when getting styles
    final stylesState = ref.watch(shopStylesProvider(widget.shopDomain));
    final shopBasicInfoState =
        ref.watch(shopBasicInfoProvider(widget.shopDomain));
    final treatmentsState = ref.watch(treatmentProvider(widget.shopDomain));

    if (stylesState is CursorPaginationError ||
        shopBasicInfoState is ShopBasicError ||
        treatmentsState is ListError) {
      return const PageNotFound();
    }

    if (stylesState is CursorPaginationLoading ||
        shopBasicInfoState is ShopBasicLoading ||
        treatmentsState is ListLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: StrokeColors.black,
        ),
      );
    }

    final styles = (stylesState as CursorPagination<StyleModel>).data;

    // if (styles.isEmpty) {
    //   return const StyleNotFound();
    // }

    final shopData = shopBasicInfoState as ShopBasicInfo;
    final treatments = (treatmentsState as ListModel<TreatmentCategory>).data;
    final selectedTreatments = ref.watch(selectedTreatmentProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    SizedBox(
                      height: 58,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MenuButton(
                                  onTap: () {
                                    context.go('/s/${widget.shopDomain}');
                                  },
                                  title: '시술 메뉴',
                                  isSelected: false,
                                ),
                                MenuButton(
                                  onTap: () {},
                                  title: '스타일',
                                  isSelected: true,
                                ),
                                MenuButton(
                                  onTap: () {
                                    analytics.logEvent(
                                        name: 'shop_info_button');
                                    context.go('/s/${widget.shopDomain}/info');
                                  },
                                  title: '정보',
                                  isSelected: false,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 4,
                            color: ContainerColors.black,
                          ),
                        ],
                      ),
                    ),
                    if (styles.isEmpty)
                      const Expanded(
                        child: StyleNotFound(),
                      )
                    else
                      Expanded(
                        child: GridView.builder(
                          controller: _scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Number of columns
                            crossAxisSpacing: 3.0,
                            mainAxisSpacing: 3.0,
                          ),
                          itemCount: styles.length,
                          itemBuilder: (context, index) {
                            final style = styles[index];
                            final treatment = treatments
                                .expand((category) => category.treatments)
                                .firstWhere((element) =>
                                    element.id == style.treatmentId);
                            return GestureDetector(
                              onTap: () {
                                // final isSelected = ref
                                //     .watch(selectedTreatmentProvider)
                                //     .containsKey(style.categoryId);
                                // if (isSelected) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //       const SnackBar(
                                //           content: Text(
                                //               'You can only select one treatment per category.')));
                                // } else {
                                //   context.go(
                                //       '/s/${widget.shopDomain}/sisul?treatmentId=${treatment.id}&styleId=${style.styleId}');
                                // }
                                context.go(
                                    '/s/${widget.shopDomain}/treatment?treatmentId=${treatment.id}&styleId=${style.styleId}');
                              },
                              child: GridItem(
                                style: style,
                              ),
                            );
                          },
                        ),
                      ),
                    if ((selectedTreatments.isNotEmpty &&
                            !(shopData.takeReservation ^ shopData.approval)) ||
                        ((shopData.takeReservation ^ shopData.approval)))
                      const SizedBox(
                        height: 72,
                      ),
                  ],
                ),
              ),
              if (selectedTreatments.isNotEmpty &&
                  !(shopData.takeReservation ^ shopData.approval))
                TreatmentReservationButton(
                  shopDomain: widget.shopDomain,
                  futureReservationDays: shopData.futureReservationDays,
                ),
              if ((shopData.takeReservation ^ shopData.approval))
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 72,
                    color: ContainerColors.ctaGrey,
                    child: Center(
                      child: Text(
                        '지금은 예약을 접수 받을 수 없어요',
                        style: TextDesign.bold18W,
                      ),
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
