import 'package:dio/dio.dart';

import '../../../core/constants/topic_status.dart';
import '../../../core/network/api_error.dart';
import '../../../core/network/api_response.dart';
import 'topic.dart';
import 'topic_repository.dart';

class ApiTopicRepository implements TopicRepository {
  ApiTopicRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Topic>> list({TopicStatus? status}) => _guard(() async {
    final response = await _dio.get<dynamic>(
      '/api/v1/detai',
      queryParameters: status == null ? null : {'trangThai': status.apiCode},
    );
    return unwrapList(response.data).map(Topic.fromJson).toList();
  });

  @override
  Future<void> create({required String title, required String description}) =>
      _guard(() async {
        await _dio.post<void>(
          '/api/v1/detai',
          data: {'tenDeTai': title, 'moTa': description},
        );
      });

  @override
  Future<void> update(
    String id, {
    required String title,
    required String description,
  }) => _guard(() async {
    await _dio.put<void>(
      '/api/v1/detai/${Uri.encodeComponent(id)}',
      data: {'tenDeTai': title, 'moTa': description},
    );
  });

  @override
  Future<void> register(String topicId) => _guard(() async {
    await _dio.post<void>('/api/v1/detai/dang-ky', data: {'maDeTai': topicId});
  });

  @override
  Future<void> approve(String id) => _guard(() async {
    await _dio.post<void>('/api/v1/detai/${Uri.encodeComponent(id)}/duyet');
  });

  @override
  Future<void> cancel(String id, {required String reason}) => _guard(() async {
    await _dio.post<void>(
      '/api/v1/detai/${Uri.encodeComponent(id)}/huy',
      data: {'lyDo': reason},
    );
  });

  @override
  Future<void> extend(String id, {required DateTime newDeadline}) =>
      _guard(() async {
        await _dio.post<void>(
          '/api/v1/detai/${Uri.encodeComponent(id)}/gia-han',
          data: {'denNgay': newDeadline.toIso8601String()},
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
