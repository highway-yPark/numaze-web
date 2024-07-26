import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/model/list_model.dart';
import 'package:numaze_web/provider/treatments_provider.dart';

import '../common/const/colors.dart';
import '../common_app_bar.dart';
import '../components/grid_style_item.dart';
import '../cursor_pagination_model.dart';
import '../model/model.dart';
import '../provider/scroll_position_provider.dart';
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
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset:
          ref.read(treatmentStylesScrollPositionProvider(widget.treatmentId)),
    );
    _scrollController.addListener(scrollListener);
    _scrollController.addListener(() {
      ref
          .read(treatmentStylesScrollPositionProvider(widget.treatmentId)
              .notifier)
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
      ref.read(stylesProvider(widget.treatmentId).notifier).paginate(
            fetchMore: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final treatmentState = ref.watch(treatmentProvider(widget.shopDomain));
    final stylesState = ref.watch(stylesProvider(widget.treatmentId));

    if (stylesState is CursorPaginationLoading ||
        treatmentState is ListLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: StrokeColors.black,
        ),
      );
    }

    if (stylesState is CursorPaginationError || treatmentState is ListError) {
      return const PageNotFound();
    }

    final styles = (stylesState as CursorPagination<StyleModel>).data;

    final TreatmentModel treatment = (treatmentState as ListModel)
        .data
        .expand((categories) => categories.treatments)
        .firstWhere((treatment) => treatment.id == widget.treatmentId);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                CommonAppBar(
                  // title: '스타일',
                  title: treatment.name,
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
