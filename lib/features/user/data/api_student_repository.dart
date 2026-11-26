import 'package:dio/dio.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_response.dart';
import 'student.dart';
import 'student_repository.dart';

class ApiStudentRepository implements StudentRepository {
  ApiStudentRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Student>> list() => _guard(() async {
    final response = await _dio.get<dynamic>('/api/v1/sinhvien');
    return unwrapList(response.data).map(Student.fromJson).toList();
  });

  @override
  Future<Student?> get(String id) => _guard(() async {
    final response = await _dio.get<dynamic>(
      '/api/v1/sinhvien/${Uri.encodeComponent(id)}',
    );
    final data = unwrap(response.data);
    return data is Map
        ? Student.fromJson(Map<String, dynamic>.from(data))
        : null;
  });

  @override
  Future<void> create(Student student) => _guard(() async {
    await _dio.post<void>('/api/v1/sinhvien', data: student.toJson());
  });

  @override
  Future<void> update(Student student) => _guard(() async {
    await _dio.put<void>(
      '/api/v1/sinhvien/${Uri.encodeComponent(student.id)}',
      data: student.toJson(),
    );
  });

  @override
  Future<void> delete(String id) => _guard(() async {
    await _dio.delete<void>('/api/v1/sinhvien/${Uri.encodeComponent(id)}');
  });

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ApiError.from(error);
    }
  }
}
