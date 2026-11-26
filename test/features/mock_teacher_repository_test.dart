import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/constants/user_role.dart';
import 'package:nckh_app/features/user/data/mock_teacher_repository.dart';

void main() {
  test('Có 22 giảng viên, trong đó bốn người kiêm quản lý', () async {
    final teachers = await MockTeacherRepository().list();

    expect(teachers, hasLength(22));
    expect(
      teachers.where((teacher) => teacher.positions.contains(UserRole.manager)),
      hasLength(4),
    );
  });
}
