import 'package:dio/dio.dart';

import '../../../core/auth/session.dart';
import '../../../core/auth/user.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_response.dart';
import 'auth_repository.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._dio);

  final Dio _dio;

  @override
  Future<Session> login({required String username, required String password}) =>
      _guard(() async {
        final response = await _dio.post<dynamic>(
          '/api/v1/auth/login',
          data: {'username': username, 'password': password},
        );
        final data = unwrap(response.data);
        if (data is! Map) {
          throw ApiError(0, 'Phản hồi đăng nhập không hợp lệ.');
        }
        final body = Map<String, dynamic>.from(data);
        final token = body['token'];
        if (token is! String || token.isEmpty) {
          throw ApiError(0, 'Phản hồi đăng nhập không có mã phiên hợp lệ.');
        }
        final user = User.fromJson(body);
        return Session(token: token, user: user, activeRole: user.role);
      });

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ApiError.from(error);
    }
  }
}
