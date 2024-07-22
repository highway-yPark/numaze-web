import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../common_app_bar.dart';
import '../components/grid_style_item.dart';
import '../cursor_pagination_model.dart';
import '../model/model.dart';
import '../provider/styles_provider.dart';
import '404_page.dart';
import 'style_not_found.dart';

class TreatmentStylesScreen extends ConsumerStatefulWidget {
  final String shopDomain;
  final int treatmentId;
  const TreatmentStylesScreen(
      {super.key, required this.shopDomain, required this.treatmentId});

  @override
  ConsumerState<TreatmentStylesScreen> createState() =>
      _TreatmentStylesScreenState();
}

class _TreatmentStylesScreenState extends ConsumerState<TreatmentStylesScreen> {
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
      ref.read(stylesProvider(widget.treatmentId).notifier).paginate(
            fetchMore: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stylesState = ref.watch(stylesProvider(widget.treatmentId));

    if (stylesState is CursorPaginationError) {
      return const PageNotFound();
    }

    if (stylesState is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final styles = (stylesState as CursorPagination<StyleModel>).data;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                CommonAppBar(
                  title: '스타일',
                  shopDomain: widget.shopDomain,
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

                        return GestureDetector(
                          onTap: () {
                            context.go(
                                '/s/${widget.shopDomain}/sisul?treatmentId=${widget.treatmentId}&treatmentStyleId=${style.styleId}');
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
        ),
      ),
    );
  }
}
