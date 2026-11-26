import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/user/data/mock_student_repository.dart';
import 'package:nckh_app/features/user/data/student.dart';

void main() {
  test('Cập nhật hồ sơ sinh viên và trả về dữ liệu mới', () async {
    final repository = MockStudentRepository();
    final student = await repository.get('SV001');

    expect(student, isNotNull);
    final updated = Student(
      id: student!.id,
      fullName: 'Nguyễn Minh Anh mới',
      birthDate: student.birthDate,
      major: 'Khoa học dữ liệu',
      gpa: student.gpa,
      status: student.status,
    );

    await repository.update(updated);

    expect((await repository.get('SV001'))?.fullName, 'Nguyễn Minh Anh mới');
    expect((await repository.get('SV001'))?.major, 'Khoa học dữ liệu');
  });
}
