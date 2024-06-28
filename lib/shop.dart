import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/list_model.dart';
import 'package:numaze_web/treatment_box.dart';
import 'announcements.dart';
import 'common/const/colors.dart';
import 'common/const/text.dart';
import 'common/const/widgets.dart';
import 'monthly_picks.dart';
import 'model.dart';
import 'provider.dart';
import 'treatment_reservation_button.dart';
import 'treatments_provider.dart';

class ShopPage extends ConsumerStatefulWidget {
  final String shopDomain;

  const ShopPage({required this.shopDomain, super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  final ScrollController _scrollController = ScrollController();
  int _selectedCategoryIndex = 0;
  final Map<int, GlobalKey> _categoryKeys = {};

  @override
  void initState() {
    super.initState();

    // Initialize GlobalKeys
    for (int i = 0; i < 10; i++) {
      _categoryKeys[i] = GlobalKey();
    }

    // Add scroll listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollDirection = _scrollController.position.userScrollDirection;
    final viewportHeight = MediaQuery.of(context).size.height;

    for (int i = 0; i < _categoryKeys.length; i++) {
      final key = _categoryKeys[i];
      if (key != null && key.currentContext != null) {
        final RenderBox renderBox =
            key.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);

        // Check if the empty box is in the viewport
        if (position.dy >= 0 && position.dy < viewportHeight) {
          if (scrollDirection == ScrollDirection.reverse) {
            // Scrolling down
            if (_selectedCategoryIndex != i) {
              setState(() {
                _selectedCategoryIndex = i;
              });
            }
          } else if (scrollDirection == ScrollDirection.forward) {
            // Scrolling up
            if (i > 0 && position.dy <= viewportHeight / 2) {
              setState(() {
                _selectedCategoryIndex = i - 1;
              });
            }
          }
          break;
        }
      }
    }
  }

  void _scrollToCategory(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _categoryKeys[index];
      if (key != null && key.currentContext != null) {
        final context = key.currentContext!;
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
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

    final treatmentsState = ref.watch(treatmentProvider(widget.shopDomain));
    // final optionsState = ref.watch(optionsProvider(widget.shopDomain));

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
      body: Center(
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 272.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = MediaQuery.of(context).size.width > 500
                              ? 500.0
                              : MediaQuery.of(context).size.width;
                          final height = width / 2.6 + 72;
                          return Column(
                            children: [
                              SizedBox(
                                height: 72,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    // vertical: 10.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        'assets/images/numaze_logo.png',
                                        height: 29,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          context.go(
                                              '/findReservation?shopDomain=${widget.shopDomain}');
                                        },
                                        child: const Icon(
                                          Icons.search,
                                          size: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (shopData.backgroundImage != null)
                                Flexible(
                                  child: Image.network(
                                    shopData.backgroundImage!,
                                    height: height,
                                    width: width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    // bottom: PreferredSize(
                    //   preferredSize: const Size.fromHeight(0),
                    //   child: Container(),
                    // ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  width: 65,
                                  height: 65,
                                  child: Image.network(
                                    shopData.profileImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shopData.name,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      shopData.englishName,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Text(
                                      shopData.description,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            Chip(
                              label: Text(
                                  '${shopData.shopType} | ${shopData.simpleAddress}'),
                              backgroundColor: Colors.black,
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                            ...shopData.tags.map(
                              (tag) => TagItem(tag: tag),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: SizedBox(
                            height: 109,
                            child: Announcements(
                              shopDomain: widget.shopDomain,
                            ),
                          ),
                        ),
                        ConstWidgets.greyBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            left: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  'Monthly pick art',
                                  style: TextDesign.bold18B,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                height: 176,
                                child: MonthlyPicks(
                                  shopDomain: widget.shopDomain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ConstWidgets.greyBox(),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _CustomHeaderDelegate(
                      minHeight: 59,
                      maxHeight: 59,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                MenuButton(
                                  onTap: () {},
                                  title: '시술 메뉴',
                                  isSelected: true,
                                ),
                                MenuButton(
                                  onTap: () {
                                    context.go(
                                        '/s/${widget.shopDomain}/thirdStyles');
                                  },
                                  title: '스타일',
                                  isSelected: false,
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
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _CustomHeaderDelegate(
                      maxHeight: 65,
                      minHeight: 65,
                      child: Container(
                        color: ContainerColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: treatments.length,
                          itemBuilder: (context, index) {
                            final category = treatments[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategoryIndex = index;
                                });
                                _scrollToCategory(index);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: _selectedCategoryIndex == index
                                      ? ContainerColors.black
                                      : ContainerColors.white,
                                  border: Border.all(
                                    color: _selectedCategoryIndex == index
                                        ? ContainerColors.black
                                        : StrokeColors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  category.name,
                                  style: _selectedCategoryIndex == index
                                      ? TextDesign.medium16W
                                      : TextDesign.regular16G,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        for (int i = 0; i < treatments.length; i++) ...[
                          Column(
                            key: _categoryKeys[i],
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  treatments[i].name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ...treatments[i].treatments.map(
                                    (treatment) => TreatmentBox(
                                      categoryId: treatments[i].id,
                                      categoryName: treatments[i].name,
                                      shopDomain: widget.shopDomain,
                                      treatment: treatment,
                                      // categoriesWithOptions: categoriesWithOptions,
                                    ),
                                  ),
                            ],
                          ),
                          const SizedBox(height: 10), // Add the empty box here
                        ],
                      ],
                    ),
                  ),
                  // i want empty sized box with height 300
                  SliverToBoxAdapter(
                    child: Container(
                      height: 50,
                    ),
                  ),
                  if (selectedTreatments.isEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        height: 95,
                        color: ContainerColors.black,
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
    );
  }
}

class MenuButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool isSelected;

  const MenuButton({
    super.key,
    required this.onTap,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 56,
          color: isSelected ? ContainerColors.black : ContainerColors.white,
          child: Center(
            child: Text(
              title,
              style: isSelected ? TextDesign.bold16W : TextDesign.regular16B,
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _CustomHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class TagItem extends StatelessWidget {
  final String tag;

  const TagItem({
    super.key,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: Colors.grey[800],
        ),
      ),
    );
  }
}
