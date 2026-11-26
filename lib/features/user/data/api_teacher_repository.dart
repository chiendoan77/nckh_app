import 'package:dio/dio.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_response.dart';
import 'teacher.dart';
import 'teacher_repository.dart';

class ApiTeacherRepository implements TeacherRepository {
  ApiTeacherRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Teacher>> list() => _guard(() async {
    final response = await _dio.get<dynamic>('/api/v1/giangvien');
    return unwrapList(response.data).map(Teacher.fromJson).toList();
  });

  @override
  Future<Teacher?> get(String id) async {
    final teachers = await list();
    for (final teacher in teachers) {
      if (teacher.id == id) {
        return teacher;
      }
    }
    return null;
  }

  @override
  Future<void> create(Teacher teacher) => _guard(() async {
    await _dio.post<void>('/api/v1/giangvien', data: teacher.toJson());
  });

  @override
  Future<void> update(Teacher teacher) => _guard(() async {
    await _dio.put<void>(
      '/api/v1/giangvien/${Uri.encodeComponent(teacher.id)}',
      data: teacher.toJson(),
    );
  });

  @override
  Future<void> delete(String id) => _guard(() async {
    await _dio.delete<void>('/api/v1/giangvien/${Uri.encodeComponent(id)}');
  });

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ApiError.from(error);
    }
  }
}
