import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/model.dart';
import '../repository.dart';

final shopMessageProvider = StateNotifierProvider.family<
    ShopMessageStateNotifier, ShopMessageBase, String>(
  (ref, domain) {
    final repository = ref.watch(repositoryProvider);
    return ShopMessageStateNotifier(
      repository: repository,
      shopDomain: domain,
    );
  },
);

class ShopMessageStateNotifier extends StateNotifier<ShopMessageBase> {
  final Repository repository;
  final String shopDomain;

  ShopMessageStateNotifier({
    required this.repository,
    required this.shopDomain,
  }) : super(ShopMessageLoading()) {
    getShopMessageInfo();
  }

  Future<void> getShopMessageInfo() async {
    try {
      final response = await repository.getShopMessageInfo(
        shopDomain: shopDomain,
      );
      state = response;
    } catch (e) {
      state = ShopMessageError(
        data: e.toString(),
      );
    }
  }
}

final shopBasicInfoProvider = StateNotifierProvider.family<
    ShopBasicInfoStateNotifier, ShopBasicBase, String>(
  (ref, domain) {
    final repository = ref.watch(repositoryProvider);
    return ShopBasicInfoStateNotifier(
      repository: repository,
      shopDomain: domain,
    );
  },
);

class ShopBasicInfoStateNotifier extends StateNotifier<ShopBasicBase> {
  final Repository repository;
  final String shopDomain;

  ShopBasicInfoStateNotifier({
    required this.repository,
    required this.shopDomain,
  }) : super(ShopBasicLoading()) {
    getShopInfo();
  }

  Future<void> getShopInfo() async {
    try {
      final response = await repository.getShopBasicInfo(
        shopDomain: shopDomain,
      );
      state = response;
    } catch (e) {
      state = ShopBasicError(
        data: e.toString(),
      );
    }
  }
}

final selectedTreatmentProvider =
    StateProvider<Map<int, SelectedCategory>>((ref) => {});

final durationProvider = StateProvider<int>((ref) => 0);
