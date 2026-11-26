import 'package:dio/dio.dart';

class ApiError implements Exception {
  ApiError(this.status, this.message);

  final int status;
  final String message;

  static const _messages = {
    0: 'Không kết nối được máy chủ. Vui lòng thử lại.',
    400: 'Dữ liệu không hợp lệ.',
    401: 'Phiên đăng nhập đã hết hạn.',
    403: 'Bạn không có quyền thực hiện thao tác này.',
    404: 'Không tìm thấy dữ liệu.',
    409: 'Dữ liệu đã thay đổi hoặc không còn phù hợp. Vui lòng tải lại.',
  };

  factory ApiError.from(DioException error) {
    final status = error.response?.statusCode ?? 0;
    final body = error.response?.data;
    final serverMessage = body is Map && body['message'] is String
        ? body['message'] as String
        : null;
    return ApiError(
      status,
      serverMessage ?? _messages[status] ?? 'Đã xảy ra lỗi. Vui lòng thử lại.',
    );
  }

  @override
  String toString() => message;
}
