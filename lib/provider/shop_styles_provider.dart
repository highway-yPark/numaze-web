import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numaze_web/repository.dart';

import '../cursor_pagination_model.dart';
import '../model/model.dart';

final shopStylesProvider = StateNotifierProvider.family<ShopStylesStateNotifier,
    CursorPaginationBase, String>(
  (ref, domain) {
    final repository = ref.watch(repositoryProvider);

    return ShopStylesStateNotifier(repository: repository, shopDomain: domain);
  },
);

class ShopStylesStateNotifier extends StateNotifier<CursorPaginationBase> {
  final Repository repository;
  final String shopDomain;

  ShopStylesStateNotifier({required this.repository, required this.shopDomain})
      : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 21,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;

        if (!pState.meta.has_more) {
          return;
        }
      }

      final isLoadMore = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoadMore || isRefetching || isFetchingMore)) {
        return;
      }

      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      if (fetchMore) {
        final pState = state as CursorPagination<StyleModel>;
        state = CursorPaginationFetchingMore(
          data: pState.data,
          meta: pState.meta,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.styleId,
        );
      } else {
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<StyleModel>;
          state = CursorPaginationRefetching<StyleModel>(
            data: pState.data,
            meta: pState.meta,
          );
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.getShopStyles(
        shopDomain: shopDomain,
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<StyleModel>;

        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e) {
      print("Error fetching data: $e");
      // print(s);
      state = CursorPaginationError(message: 'Failed to fetch data');
    }
  }
}
