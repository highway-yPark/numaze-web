import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'list_model.dart';
import 'repository.dart';

final monthlyPickProvider =
    StateNotifierProvider.family<MonthlyPickStateNotifier, ListBase, String>(
  (ref, domain) {
    final repository = ref.watch(repositoryProvider);
    return MonthlyPickStateNotifier(
      shopDomain: domain,
      repository: repository,
    );
  },
);

class MonthlyPickStateNotifier extends StateNotifier<ListBase> {
  final String shopDomain;
  final Repository repository;

  MonthlyPickStateNotifier({
    required this.shopDomain,
    required this.repository,
  }) : super(ListLoading()) {
    getShopMonthlyPicks();
  }

  Future<int> getShopMonthlyPicks() async {
    return await handleError(() async {
      final resp = await repository.getShopMonthlyPicks(
        shopDomain: shopDomain,
      );
      // final pState = state as ShopBasicInfo;
      // state = pState.copyWith(takeReservation: takeReservation);
      state = resp;

      return 200;
    });
  }

  Future<int> handleError<T>(Future<int> Function() action) async {
    try {
      return await action();
    } on DioException catch (e) {
      if (e.response != null) {
        // Access the status code from the response
        final statusCode = e.response!.statusCode;
        debugPrint('Error: Status code $statusCode');
        debugPrint('Error response data: ${e.response!.data}');

        switch (statusCode) {
          case 400:
            return 400;
          // case 401:
          //   break;
          // case 500:
          //   // Handle server error
          //   break;
          // // Add more cases as needed
          // default:
          //   // Handle other statuses
          //   break;
        }
        return -1;
      } else {
        // Handle other errors (e.g., network issues)
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
