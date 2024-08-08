import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/model.dart';
import '../repository.dart';

final customerAppointmentProvider = StateNotifierProvider.family<
    CustomerAppointmentStateNotifier, CustomerAppointmentBase, String>(
  (ref, appointmentId) {
    final repository = ref.watch(repositoryProvider);
    return CustomerAppointmentStateNotifier(
        repository: repository, appointmentId: appointmentId);
  },
);

class CustomerAppointmentStateNotifier
    extends StateNotifier<CustomerAppointmentBase> {
  final Repository repository;
  final String appointmentId;

  CustomerAppointmentStateNotifier({
    required this.repository,
    required this.appointmentId,
  }) : super(CustomerAppointmentLoading()) {
    getCustomerAppointment();
  }

  Future<int> getCustomerAppointment() async {
    try {
      final response = await repository.getCustomerAppointment(
        appointmentId: appointmentId,
      );

      state = response;
      return 200;
    } catch (e) {
      state = CustomerAppointmentError(data: e.toString());
      return -1;
    }
  }
}
