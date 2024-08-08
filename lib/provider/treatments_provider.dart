import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/list_model.dart';
import '../repository.dart';

final treatmentProvider =
    StateNotifierProvider.family<TreatmentsStateNotifier, ListBase, String>(
  (ref, domain) {
    final repository = ref.watch(repositoryProvider);
    return TreatmentsStateNotifier(
      shopDomain: domain,
      repository: repository,
    );
  },
);

class TreatmentsStateNotifier extends BaseStateNotifier {
  final String shopDomain;
  final Repository repository;

  TreatmentsStateNotifier({
    required this.shopDomain,
    required this.repository,
  }) : super(ListLoading()) {
    getTreatments();
  }

  Future<int> getTreatments() async {
    return await handleError(() async {
      final resp = await repository.getTreatments(
        shopDomain: shopDomain,
      );
      state = resp;
      return 200;
    });
  }
}

final optionsProvider =
    StateNotifierProvider.family<OptionsStateNotifier, ListBase, String>(
  (ref, domain) {
    final repository = ref.watch(repositoryProvider);
    return OptionsStateNotifier(
      shopDomain: domain,
      repository: repository,
    );
  },
);

class OptionsStateNotifier extends BaseStateNotifier {
  final String shopDomain;
  final Repository repository;

  OptionsStateNotifier({
    required this.shopDomain,
    required this.repository,
  }) : super(ListLoading()) {
    getOptions();
  }

  Future<int> getOptions() async {
    return await handleError(() async {
      final resp = await repository.getOptions(
        shopDomain: shopDomain,
      );
      state = resp;
      return 200;
    });
  }
}

// Ensure that T extends ListBase
abstract class BaseStateNotifier<T extends ListBase>
    extends StateNotifier<ListBase> {
  // Pass an initial state to the super constructor
  BaseStateNotifier(T super.initialState);

  Future<int> handleError(Future<int> Function() action) async {
    try {
      return await action();
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        // return statusCode ?? -1;
        if (statusCode != null) {
          return statusCode;
        } else {
          state = ListError(data: e.response!.data.toString());
          return -1;
        }
      } else {
        state = ListError(data: e.toString());
        return -1;
      }
    } catch (e) {
      state = ListError(data: e.toString());
      return -1;
    }
  }
}
