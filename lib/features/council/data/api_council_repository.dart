import 'package:dio/dio.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_response.dart';
import '../../topic/data/topic.dart';
import '../../user/data/teacher.dart';
import 'council.dart';
import 'council_repository.dart';

class ApiCouncilRepository implements CouncilRepository {
  ApiCouncilRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Council>> list() => _guard(() async {
    final response = await _dio.get<dynamic>('/api/v1/hoi-dong');
    return unwrapList(response.data).map(Council.fromJson).toList();
  });

  @override
  Future<Council?> get(String id) async {
    final councils = await list();
    for (final council in councils) {
      if (council.id == id) {
        return council;
      }
    }
    return null;
  }

  @override
  Future<void> create({
    required String name,
    required CouncilType type,
    required DateTime createdOn,
  }) => _guard(() async {
    await _dio.post<void>(
      '/api/v1/hoi-dong',
      data: {
        'ten': name,
        'loai': type.apiCode,
        'ngayLap': createdOn.toIso8601String(),
      },
    );
  });

  @override
  Future<void> assignMember(
    String id, {
    required Teacher teacher,
    required CouncilRole role,
  }) => _guard(() async {
    await _dio.post<void>(
      '/api/v1/hoi-dong/${Uri.encodeComponent(id)}/phan-cong',
      data: {'maGv': teacher.id, 'vaiTro': role.apiCode},
    );
  });

  @override
  Future<void> assignTopic(String id, Topic topic) => _guard(() async {
    await _dio.post<void>(
      '/api/v1/hoi-dong/${Uri.encodeComponent(id)}/gan-de-tai',
      data: {'maDeTai': topic.id},
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
