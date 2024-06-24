import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'list_model.dart';
import 'repository.dart';

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
        debugPrint('Error: Status code $statusCode');
        debugPrint('Error response data: ${e.response!.data}');
        return statusCode ?? -1;
      } else {
        debugPrint('Error: ${e.message}');
        return -1;
      }
    } catch (e, stackTrace) {
      debugPrint('Exception: $e');
      debugPrint('Stack trace: $stackTrace');
      return -1;
    }
  }
}
