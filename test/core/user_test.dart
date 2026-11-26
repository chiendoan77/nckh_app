import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/auth/user.dart';
import 'package:nckh_app/core/constants/user_role.dart';

void main() {
  test('Đọc thông tin đăng nhập và chức vụ từ JSON', () {
    final user = User.fromJson({
      'name': 'Nguyễn An',
      'role': 'GIANG_VIEN',
      'maGv': 'GV001',
      'chucVu': ['GIANG_VIEN', 'QUAN_LY'],
    });

    expect(user.name, 'Nguyễn An');
    expect(user.role, UserRole.teacher);
    expect(user.teacherId, 'GV001');
    expect(user.positions, [UserRole.teacher, UserRole.manager]);
    expect(user.hasMultiRoles, isTrue);
  });

  test('Dữ liệu tùy chọn bị thiếu được xử lý an toàn', () {
    final user = User.fromJson({'name': null, 'role': null});

    expect(user.name, isEmpty);
    expect(user.role, UserRole.student);
    expect(user.positions, isEmpty);
    expect(user.hasMultiRoles, isFalse);
  });
}
