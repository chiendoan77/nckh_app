import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_saver/file_saver.dart';

import '../../../core/network/api_error.dart';
import '../../../core/network/api_response.dart';
import 'stats_repository.dart';
import 'topic_stats.dart';

class ApiStatsRepository implements StatsRepository {
  ApiStatsRepository(this._dio);

  final Dio _dio;

  @override
  Future<TopicStats> getTopicStats() => _guard(() async {
    final response = await _dio.get<dynamic>('/api/v1/thong-ke/detai');
    final data = unwrap(response.data);
    if (data is! Map) {
      throw ApiError(0, 'Dữ liệu thống kê không hợp lệ.');
    }
    return TopicStats.fromJson(Map<String, dynamic>.from(data));
  });

  @override
  Future<void> exportExcel() => _guard(() async {
    final response = await _dio.get<List<int>>(
      '/api/v1/thong-ke/xuat',
      queryParameters: {'dinhDang': 'excel'},
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw ApiError(0, 'Tệp Excel tải về không có dữ liệu.');
    }
    await FileSaver.instance.saveFile(
      name: 'bao-cao-de-tai',
      bytes: Uint8List.fromList(bytes),
      fileExtension: 'xlsx',
      mimeType: MimeType.microsoftExcel,
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
