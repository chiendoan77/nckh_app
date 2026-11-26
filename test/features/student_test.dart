import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/user/data/student.dart';

void main() {
  test('Phân tích hồ sơ sinh viên và giá trị mặc định an toàn', () {
    final student = Student.fromJson({
      'maSv': 'SV001',
      'hoTen': 'Nguyễn Minh Anh',
      'ngaySinh': null,
      'chuyenNganh': 'Công nghệ thông tin',
      'gpa': 3.2,
      'trangThai': 'HOAT_DONG',
    });

    expect(student.id, 'SV001');
    expect(student.fullName, 'Nguyễn Minh Anh');
    expect(student.birthDate, isNull);
    expect(student.gpa, 3.2);
    expect(student.status, StudentStatus.active);
  });

  test('Giữ trạng thái đình chỉ khi đọc dữ liệu máy chủ', () {
    final student = Student.fromJson({
      'maSv': 'SV002',
      'hoTen': 'Trần Quốc Bảo',
      'trangThai': 'DINH_CHI',
    });

    expect(student.status, StudentStatus.suspended);
    expect(student.major, isEmpty);
    expect(student.gpa, 0);
  });
}
