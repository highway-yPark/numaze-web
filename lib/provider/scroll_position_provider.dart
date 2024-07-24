import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a StateNotifier to manage the scroll position state
class ShopStylesScrollPositionNotifier extends StateNotifier<double> {
  ShopStylesScrollPositionNotifier() : super(0.0);

  void setScrollPosition(double position) {
    state = position;
  }
}

// Create a provider for the ScrollPositionNotifier
final shopStylesScrollPositionProvider =
    StateNotifierProvider<ShopStylesScrollPositionNotifier, double>((ref) {
  return ShopStylesScrollPositionNotifier();
});

class TreatmentStylesScrollPositionNotifier extends StateNotifier<double> {
  TreatmentStylesScrollPositionNotifier() : super(0.0);

  void setScrollPosition(double position) {
    state = position;
  }
}

final treatmentStylesScrollPositionProvider = StateNotifierProvider.family<
    TreatmentStylesScrollPositionNotifier, double, int>((ref, treatmentId) {
  return TreatmentStylesScrollPositionNotifier();
});
