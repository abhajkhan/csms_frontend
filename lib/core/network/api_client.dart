import 'package:dio/dio.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) => _dio.get<T>(path, queryParameters: queryParameters);

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) => _dio.post<T>(path, data: data, queryParameters: queryParameters);

  Future<Response<T>> put<T>(String path, {Object? data}) =>
      _dio.put<T>(path, data: data);

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) => _dio.patch<T>(path, data: data, queryParameters: queryParameters);

  Future<Response<T>> delete<T>(String path, {Object? data}) =>
      _dio.delete<T>(path, data: data);
}
