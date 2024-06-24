import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:numaze_web/common_app_bar.dart';
import 'package:numaze_web/styles_provider.dart';

import 'cursor_pagination_model.dart';
import 'model.dart';

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

    // final treatmentsState = ref.watch(treatmentProvider(widget.shopDomain));
    //
    // if (treatmentsState is ListLoading) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    // if (treatmentsState is ListError) {
    //   return const Center(
    //     child: Text('에러가 발생했습니다.'),
    //   );
    // }
    // final treatments = (treatmentsState as ListModel<TreatmentCategory>).data;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                const CommonAppBar(
                  title: '스타일',
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
