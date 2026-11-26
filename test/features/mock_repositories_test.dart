import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/network/api_error.dart';
import 'package:nckh_app/core/utils/paging.dart';
import 'package:nckh_app/features/topic/data/mock_topic_repository.dart';
import 'package:nckh_app/features/user/data/mock_student_repository.dart';

void main() {
  test('Báo xung đột 409 khi sinh viên đăng ký đề tài thứ hai', () async {
    final repository = MockTopicRepository();

    await repository.register('DT01');
    await expectLater(
      repository.register('DT02'),
      throwsA(isA<ApiError>().having((error) => error.status, 'status', 409)),
    );
  });

  test('Phân trang 25 sinh viên thành 20 và 5 bản ghi', () async {
    final students = await MockStudentRepository().list();

    expect(pageOf(students, 1), hasLength(20));
    expect(pageOf(students, 2), hasLength(5));
  });

  test('Không hủy đề tài khi thiếu lý do', () async {
    final repository = MockTopicRepository();

    await expectLater(
      repository.cancel('DT03', reason: '  '),
      throwsA(isA<ApiError>().having((error) => error.status, 'status', 400)),
    );
  });
}
