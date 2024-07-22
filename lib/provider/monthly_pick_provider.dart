import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numaze_web/provider/treatments_provider.dart';

import '../model/list_model.dart';
import '../repository.dart';

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

class MonthlyPickStateNotifier extends BaseStateNotifier {
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
}
