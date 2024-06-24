import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'common/const/colors.dart';
import 'cursor_pagination_model.dart';
import 'list_model.dart';
import 'model.dart';
import 'provider.dart';
import 'shop.dart';
import 'shop_styles_provider.dart';
import 'treatment_reservation_button.dart';
import 'treatments_provider.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollListener);
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

    final styles = (stylesState as CursorPagination<StyleModel>).data;

    if (styles.isEmpty) {
      return const Center(
        child: Text('No styles found.'),
      );
    }

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

    final treatmentsState = ref.watch(treatmentProvider(widget.shopDomain));

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
                      height: 59,
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
                                    context.go('/s/${widget.shopDomain}/info');
                                  },
                                  title: '정보',
                                  isSelected: false,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 3,
                            color: ContainerColors.black,
                          ),
                        ],
                      ),
                    ),
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
                              .firstWhere(
                                  (element) => element.id == style.treatmentId);
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
                                  '/s/${widget.shopDomain}/sisul?treatmentId=${treatment.id}&styleId=${style.styleId}');
                            },
                            child: GridItem(
                              style: style,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedTreatments.isNotEmpty)
                TreatmentReservationButton(
                  shopDomain: widget.shopDomain,
                  futureReservationDays: shopData.futureReservationDays,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItem extends StatelessWidget {
  final StyleModel style;

  const GridItem({
    super.key,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          style.thumbnail,
          width: (MediaQuery.sizeOf(context).width - 6) / 3,
          height: (MediaQuery.sizeOf(context).width - 6) / 3,
        ),
      ],
    );
  }
}
