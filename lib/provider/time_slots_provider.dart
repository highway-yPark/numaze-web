import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numaze_web/provider/treatments_provider.dart';

import '../model/list_model.dart';
import '../model/model.dart';
import '../repository.dart';

final timeSlotsProvider =
    StateNotifierProvider.family<TimeSlotsStateNotifier, ListBase, String>(
  (ref, domain) {
    final repository = ref.watch(repositoryProvider);
    return TimeSlotsStateNotifier(
      shopDomain: domain,
      repository: repository,
    );
  },
);

class TimeSlotsStateNotifier extends BaseStateNotifier {
  final String shopDomain;
  final Repository repository;

  TimeSlotsStateNotifier({
    required this.shopDomain,
    required this.repository,
  }) : super(ListEmpty());

  Future<int> getAvailableTimeSlots({
    required String date,
    required SelectedTreatmentsRequest request,
  }) async {
    return await handleError(() async {
      state = ListLoading();
      final resp = await repository.getAvailableTimeSlots(
        shopDomain: shopDomain,
        date: date,
        request: request,
      );
      state = resp;
      return 200;
    });
  }

  void clearTimeSlots() {
    state = ListEmpty();
  }
}

// final selectedDesignerProvider = StateProvider<int?>((ref) {
//   return null;
// });

final selectedDesignerProvider =
    StateNotifierProvider<SelectedDesignerNotifier, SelectedDesigner?>(
        (ref) => SelectedDesignerNotifier());

class SelectedDesignerNotifier extends StateNotifier<SelectedDesigner?> {
  SelectedDesignerNotifier() : super(null);

  void setSelectedDesigner(int designerId, String nickname) {
    state = SelectedDesigner(
      designerId: designerId,
      designerNickname: nickname,
    );
  }

  void clearSelection() {
    state = null;
  }
}

final selectedDateTimeProvider =
    StateNotifierProvider<SelectedDateTimeNotifier, SelectedDateTime>(
  (ref) => SelectedDateTimeNotifier(),
);

class SelectedDateTimeNotifier extends StateNotifier<SelectedDateTime> {
  SelectedDateTimeNotifier() : super(SelectedDateTime());

  void setSelectedDate(String date) {
    state = state.copyWith(selectedDate: date);
  }

  void setTimeSlot(int timeSlot) {
    state = state.copyWith(selectedTimeSlot: timeSlot);
  }

  void clearTimeSlot() {
    state = SelectedDateTime(
      selectedDate: state.selectedDate,
    );
  }

  void clearSelections() {
    state = SelectedDateTime(
      selectedDate: null,
      selectedTimeSlot: null,
    );
  }

  SelectedDateTime getSelectedDateTime() {
    return state;
  }
}
