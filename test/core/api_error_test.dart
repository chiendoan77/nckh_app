import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/network/api_error.dart';

void main() {
  test('Ưu tiên thông báo lỗi từ máy chủ', () {
    final request = RequestOptions(path: '/detai');
    final dioError = DioException(
      requestOptions: request,
      response: Response<dynamic>(
        requestOptions: request,
        statusCode: 409,
        data: {'message': 'Sinh viên đã đăng ký đề tài khác.'},
      ),
    );

    final error = ApiError.from(dioError);

    expect(error.status, 409);
    expect(error.message, 'Sinh viên đã đăng ký đề tài khác.');
  });

  test('Dùng thông báo mặc định khi máy chủ không phản hồi', () {
    final error = ApiError.from(
      DioException(requestOptions: RequestOptions(path: '/detai')),
    );

    expect(error.status, 0);
    expect(error.message, 'Không kết nối được máy chủ. Vui lòng thử lại.');
  });
}
