import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../base_response_model.dart';
import '../common/const/data.dart';
import '../dio.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return AuthRepository(
      dio: dio,
      baseUrl: 'http://$ip/api/v1/auth',
    );
  },
);

class AuthRepository {
  final String baseUrl;
  final Dio dio;

  AuthRepository({
    required this.baseUrl,
    required this.dio,
  });

  Future<int> sendVerificationCode({
    required String phoneNumber,
    required bool register,
  }) async {
    try {
      await dio.post(
        '$baseUrl/sms',
        queryParameters: {
          'phone_number': phoneNumber,
          'register': register,
        },
        // include body
      );
      return 200;
    } on DioException catch (e) {
      if (e.response != null) {
        final errorCode = e.response!.data['error_code'];
        switch (errorCode) {
          case 'PHONE_NUMBER_ALREADY_REGISTERED':
            return 400;
        }
        return -1;
      } else {
        return -1;
      }
    } catch (e) {
      return -1;
    }
  }

  Future<int> verifyVerificationCode({
    required String phoneNumber,
    required String code,
  }) async {
    try {
      final resp = await dio.post(
        '$baseUrl/sms/verify',
        queryParameters: {
          'phone_number': phoneNumber,
          'verification_code': code,
        },
        // include body
      );
      final respJson = BaseResponseModel.fromJson(resp.data);
      if (respJson.data == 'Success') {
        return 200;
      } else {
        return 400;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorCode = e.response!.data['error_code'];
        switch (errorCode) {
          case 'INVALID_VERIFICATION_CODE':
            return 400;
          case 'INVALID_REQUEST':
            return 401;
        }
        return -1;
      } else {
        return -1;
      }
    } catch (e) {
      return -1;
    }
  }
}
