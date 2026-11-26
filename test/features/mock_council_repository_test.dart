import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/constants/topic_status.dart';
import 'package:nckh_app/core/network/api_error.dart';
import 'package:nckh_app/features/council/data/council.dart';
import 'package:nckh_app/features/council/data/mock_council_repository.dart';
import 'package:nckh_app/features/topic/data/topic.dart';
import 'package:nckh_app/features/user/data/teacher.dart';

void main() {
  test('Thêm thành viên và không cho phân công trùng giảng viên', () async {
    final repository = MockCouncilRepository();
    const teacher = Teacher(id: 'GV010', fullName: 'Nguyễn Thu Hà');

    await repository.assignMember(
      'HD01',
      teacher: teacher,
      role: CouncilRole.member,
    );
    final council = await repository.get('HD01');

    expect(council?.members.single.teacherId, 'GV010');
    await expectLater(
      repository.assignMember(
        'HD01',
        teacher: teacher,
        role: CouncilRole.member,
      ),
      throwsA(isA<ApiError>().having((error) => error.status, 'status', 409)),
    );
  });

  test('Chỉ gắn đề tài đã được phê duyệt', () async {
    final repository = MockCouncilRepository();
    const approvedTopic = Topic(
      id: 'DT99',
      title: 'Đề tài đã duyệt',
      authorName: 'Sinh viên',
      description: '',
      status: TopicStatus.approved,
    );
    const pendingTopic = Topic(
      id: 'DT03',
      title: 'Đề tài chờ duyệt',
      authorName: 'Sinh viên',
      description: '',
      status: TopicStatus.pending,
    );

    await repository.assignTopic('HD01', approvedTopic);
    expect((await repository.get('HD01'))?.topicIds, contains('DT99'));
    await expectLater(
      repository.assignTopic('HD01', pendingTopic),
      throwsA(isA<ApiError>().having((error) => error.status, 'status', 409)),
    );
  });
}
