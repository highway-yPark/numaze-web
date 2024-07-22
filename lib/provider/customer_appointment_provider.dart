import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/model.dart';
import '../repository.dart';

final customerAppointmentProvider = StateNotifierProvider.family<
    CustomerAppointmentStateNotifier, CustomerAppointmentBase, String>(
  (ref, appointmentId) {
    final repository = ref.watch(repositoryProvider);
    return CustomerAppointmentStateNotifier(
      repository: repository,
      appointmentId: appointmentId,
      //uuid: uuid,
    );
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
    return await handleError(() async {
      final response = await repository.getCustomerAppointment(
        appointmentId: appointmentId,
      );
      // final pState = state as ShopBasicInfo;
      // state = pState.copyWith(takeReservation: takeReservation);
      state = response;

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
        return -1;
      }
    } catch (e, stackTrace) {
      return -1;
    }
  }
}
