import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/constants/topic_status.dart';
import 'package:nckh_app/core/network/api_error.dart';
import 'package:nckh_app/features/topic/data/mock_topic_repository.dart';

void main() {
  test('Có ít nhất ba đề tài hoàn thành để tra cứu điểm', () async {
    final topics = await MockTopicRepository().list();

    expect(
      topics.where((topic) => topic.status == TopicStatus.completed),
      hasLength(greaterThanOrEqualTo(3)),
    );
  });

  test(
    'Đăng ký thành công một lần và lần tiếp theo báo xung đột 409',
    () async {
      final repository = MockTopicRepository();

      await repository.register('DT01');
      await expectLater(
        repository.register('DT02'),
        throwsA(isA<ApiError>().having((error) => error.status, 'status', 409)),
      );
    },
  );

  test('Phê duyệt đề tài đang chờ duyệt', () async {
    final repository = MockTopicRepository();

    await repository.approve('DT03');
    final approved = await repository.list(status: TopicStatus.approved);

    expect(approved.map((topic) => topic.id), contains('DT03'));
  });

  test('Gia hạn đề tài đang thực hiện và lưu hạn chấm mới', () async {
    final repository = MockTopicRepository();
    final deadline = DateTime(2026, 12, 31);

    await repository.extend('DT05', newDeadline: deadline);
    final extended = await repository.list(status: TopicStatus.extended);
    final topic = extended.firstWhere((item) => item.id == 'DT05');

    expect(topic.gradingDeadline, deadline);
  });
}
