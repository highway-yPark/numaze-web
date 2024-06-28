import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numaze_web/treatments_provider.dart';

import 'list_model.dart';
import 'repository.dart';

final shopAnnouncementsProvider = StateNotifierProvider.family<
    ShopAnnouncementsStateNotifier, ListBase, String>(
  (ref, domain) {
    final repository = ref.watch(repositoryProvider);

    return ShopAnnouncementsStateNotifier(
      shopDomain: domain,
      repository: repository,
    );
  },
);

class ShopAnnouncementsStateNotifier extends BaseStateNotifier {
  final String shopDomain;
  final Repository repository;

  ShopAnnouncementsStateNotifier({
    required this.shopDomain,
    required this.repository,
  }) : super(ListLoading()) {
    getShopAnnouncements();
  }

  Future<int> getShopAnnouncements() async {
    return await handleError(() async {
      final resp = await repository.getShopAnnouncements(
        shopDomain: shopDomain,
      );
      // final pState = state as ShopBasicInfo;
      // state = pState.copyWith(takeReservation: takeReservation);
      state = resp;

      return 200;
    });
  }
}
