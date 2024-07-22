import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/list_model.dart';
import '../model/model.dart';
import '../repository.dart';
import 'treatments_provider.dart';

final occupiedDatesProvider =
    StateNotifierProvider.family<OccupiedDatesStateNotifier, ListBase, String>(
  (ref, domain) {
    final repository = ref.watch(repositoryProvider);
    return OccupiedDatesStateNotifier(
      shopDomain: domain,
      repository: repository,
    );
  },
);

class OccupiedDatesStateNotifier extends BaseStateNotifier {
  final String shopDomain;
  final Repository repository;

  OccupiedDatesStateNotifier({
    required this.shopDomain,
    required this.repository,
  }) : super(ListEmpty());

  Future<int> getOccupiedDates({
    required String startDate,
    required String endDate,
    required SelectedTreatmentsRequest request,
  }) async {
    return await handleError(() async {
      state = ListLoading();
      final resp = await repository.getOccupiedDates(
        shopDomain: shopDomain,
        startDate: startDate,
        endDate: endDate,
        request: request,
      );
      state = resp;
      return 200;
    });
  }
}
