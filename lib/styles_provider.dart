import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numaze_web/repository.dart';

import 'cursor_pagination_model.dart';
import 'model.dart';

final stylesProvider = StateNotifierProvider.family<StylesStateNotifier,
    CursorPaginationBase, int>(
  (ref, treatmentId) {
    final repository = ref.watch(treatmentRepositoryProvider);
    return StylesStateNotifier(
      repository: repository,
      treatmentId: treatmentId,
    );
  },
);

class StylesStateNotifier extends StateNotifier<CursorPaginationBase> {
  final TreatmentRepository repository;
  final int treatmentId;

  StylesStateNotifier({
    required this.repository,
    required this.treatmentId,
  }) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // 3) CursorPaginationError - 데이터를 가져오는 중 에러가 발생한 상태
      // 4) CursorPaginationRefetching - 첫번째부터 다시 데이터를 가져오는 중
      // 5) CursorPaginationFetchingMore - 추가 데이터를 가져오는 중

      // 바로 반환하는 상황
      // 1) hasMore = false (더이상 데이터가 없음)
      // 2) 로딩중 - fetchMore = true (이미 로딩중인 상태)
      //    예외 - fetchMore가 아닐때 - 새로고침 의도가 있일수 있다

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

      // Use lastKeyword for paginationParams
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount, // Use lastKeyword if fetching more
      );

      print(paginationParams.toJson());

      if (fetchMore) {
        final pState = state as CursorPagination<StyleModel>;
        // print(pState.data.length);
        state = CursorPaginationFetchingMore(
          data: pState.data,
          meta: pState.meta,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.styleId,
        );
        print('this is last id: ${pState.data.last.styleId}');
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

      final resp = await repository.paginate(
        treatmentId: treatmentId,
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<StyleModel>;

        // // Combine the messages from previous state and response
        // List<CustomerModel> combinedMessages = [
        //   ...pState.message,
        //   ...resp.message,
        // ];
        //
        // // Remove duplicates - keeping the instance from `resp.message`
        // // Assuming each message has a unique 'uuid' property to identify duplicates
        // final ids = resp.message.map((e) => e.uuid).toSet();
        // combinedMessages.retainWhere((element) => ids.remove(element.uuid));
        //
        // state = resp.copyWith(
        //   message: combinedMessages,
        // );
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e, s) {
      print(e);
      print(s);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다');
    }
  }
}
