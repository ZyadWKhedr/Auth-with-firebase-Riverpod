import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.example.com/',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  Dio get client => _dio;
}
