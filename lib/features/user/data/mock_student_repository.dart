import '../../../core/network/api_error.dart';
import 'student.dart';
import 'student_repository.dart';

class MockStudentRepository implements StudentRepository {
  final List<Student> _students = [
    Student(
      id: 'SV001',
      fullName: 'Nguyễn Minh Anh',
      birthDate: DateTime(2003, 5, 14),
      major: 'Công nghệ thông tin',
      gpa: 3.42,
      status: StudentStatus.active,
    ),
  ];

  @override
  Future<List<Student>> list() async {
    await _delay();
    return List.unmodifiable(_students);
  }

  @override
  Future<Student?> get(String id) async {
    await _delay();
    for (final student in _students) {
      if (student.id == id) {
        return student;
      }
    }
    return null;
  }

  @override
  Future<void> create(Student student) async {
    await _delay();
    if (_students.any((item) => item.id == student.id)) {
      throw ApiError(409, 'Mã sinh viên đã tồn tại.');
    }
    _students.add(student);
  }

  @override
  Future<void> update(Student student) async {
    await _delay();
    final index = _students.indexWhere((item) => item.id == student.id);
    if (index < 0) {
      throw ApiError(404, 'Không tìm thấy sinh viên.');
    }
    _students[index] = student;
  }

  @override
  Future<void> delete(String id) async {
    await _delay();
    final index = _students.indexWhere((student) => student.id == id);
    if (index < 0) {
      throw ApiError(404, 'Không tìm thấy sinh viên.');
    }
    _students.removeAt(index);
  }

  Future<void> _delay() =>
      Future<void>.delayed(const Duration(milliseconds: 300));
}
