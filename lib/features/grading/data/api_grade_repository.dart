import 'package:dio/dio.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_response.dart';
import 'grade.dart';
import 'grade_repository.dart';

class ApiGradeRepository implements GradeRepository {
  ApiGradeRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Grade>> listForStudent(String studentId) => _guard(() async {
    final response = await _dio.get<dynamic>(
      '/api/v1/diem/sinh-vien/${Uri.encodeComponent(studentId)}',
    );
    return unwrapList(response.data).map(Grade.fromJson).toList();
  });

  @override
  Future<Grade?> get(String topicId) => _guard(() async {
    final response = await _dio.get<dynamic>(
      '/api/v1/diem',
      queryParameters: {'maDeTai': topicId},
    );
    final data = unwrap(response.data);
    return data is Map ? Grade.fromJson(Map<String, dynamic>.from(data)) : null;
  });

  @override
  Future<void> create(Grade grade) => _guard(() async {
    await _dio.post<void>('/api/v1/diem', data: grade.toJson());
  });

  @override
  Future<void> update(String topicId, Grade grade) => _guard(() async {
    await _dio.put<void>(
      '/api/v1/diem/${Uri.encodeComponent(topicId)}',
      data: grade.toJson(),
    );
  });

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ApiError.from(error);
    }
  }
}
