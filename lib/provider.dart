
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model.dart';
import 'repository.dart';

// final appointmentDetailProvider =
//     Provider.family<CalendarAppointmentModel?, int>((ref, id) {
//   final state = ref.watch(appointmentProvider);
//   if (state is! ListModel) {
//     return null;
//   }
//
//   return state.data.firstWhereOrNull((element) => element.id == id);
// });

final shopBasicInfoProvider = StateNotifierProvider.family<
    ShopBasicInfoStateNotifier, ShopBasicBase, String>(
  (ref, domain) {
    final repository = ref.watch(repositoryProvider);
    // Extract the shopId if the state is UserModel
    return ShopBasicInfoStateNotifier(
      repository: repository,
      shopDomain: domain,
      //uuid: uuid,
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
    print('hello');
    getShopInfo();
  }

  // Future<int> deleteBackgroundImage() async {
  //   return await handleError(() async {
  //     // await repository.deleteBackgroundImage(
  //     //   shop_id: shopId,
  //     // );
  //
  //     final pState = state as ShopBasicInfo;
  //     state = pState.copyWith(backgroundImage: null);
  //
  //     return 200;
  //   });
  // }

  Future<void> getShopInfo() async {
    try {
      final response = await repository.getShopBasicInfo(
        shopDomain: shopDomain,
      );
      print(response);
      state = response;
      // return response;
      // if (response.data.isEmpty) {
      //   // Handle empty state
      //   state = ListEmpty();
      // } else {
      //   // Update the state with the fetched appointments
      //
      // }
    } catch (e, stackTrace) {
      // Log the error and stack trace for better debugging
      print('Error fetching appointments: $e');
      print(stackTrace);
    }
  }
  //
  // Future<int> updateShopBasicInfo({
  //   required String englishName,
  //   required String description,
  //   required String simpleAddress,
  //   required String addressDetail,
  //   required List<int> tags,
  //   required bool deleteBackground,
  //   File? profileImage,
  //   File? backgroundImage,
  // }) async {
  //   return await handleError(() async {
  //     final tagsJson = jsonEncode(tags); // Serialize to JSON
  //
  //     final resp = await repository.updateShopBasicInfo(
  //       shop_id: shopId,
  //       englishName: englishName,
  //       description: description,
  //       simpleAddress: simpleAddress,
  //       addressDetail: addressDetail,
  //       tags: tagsJson,
  //       profileImage: profileImage,
  //       backgroundImage: backgroundImage,
  //       deleteBackground: deleteBackground,
  //     );
  //     state = resp;
  //     // final currentState = state as ListModel;
  //     // final appointments = currentState.data;
  //     // final index =
  //     //     appointments.indexWhere((element) => element.id == appointmentId);
  //     // if (index != -1) {
  //     //   appointments[index] = resp;
  //     //   state =
  //     //       currentState.copyWith(data: appointments); // Appointment not found
  //     // }
  //
  //     return 200;
  //   });
  // }
  //
  // Future<int> updateTakeReservation(bool takeReservation) async {
  //   return await handleError(() async {
  //     await repository.updateTakeReservation(
  //       shop_id: shopId,
  //       takeReservation: takeReservation,
  //     );
  //     final pState = state as ShopBasicInfo;
  //     state = pState.copyWith(takeReservation: takeReservation);
  //
  //     return 200;
  //   });
  // }

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

//
// final selectedTreatmentProvider =
//     StateProvider<SelectedTreatment?>((ref) => null);
final selectedTreatmentProvider =
    StateProvider<Map<int, SelectedCategory>>((ref) => {});
