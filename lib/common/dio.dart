import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  dio.interceptors.add(
    CustomInterceptor(
      ref: ref,
    ),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final Ref ref;

  CustomInterceptor({
    required this.ref,
  });

  // 1 요창 보낼때
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // print('[REQ] [${options.method}] ${options.uri}');

    return super.onRequest(options, handler);
  }

  // 2 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // print(
    //     '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');
    // print(' this is the dio resp: ${response.data}');
    return super.onResponse(response, handler);
  }

  // 3 에러가 났을때
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    return super.onError(err, handler);
  }
}
