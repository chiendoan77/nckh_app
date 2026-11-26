import '../../../core/constants/user_role.dart';
import '../../../core/network/api_error.dart';
import 'teacher.dart';
import 'teacher_repository.dart';

class MockTeacherRepository implements TeacherRepository {
  final List<Teacher> _teachers = [..._seedTeachers];

  @override
  Future<List<Teacher>> list() async {
    await _delay();
    return List.unmodifiable(_teachers);
  }

  @override
  Future<Teacher?> get(String id) async {
    await _delay();
    for (final teacher in _teachers) {
      if (teacher.id == id) {
        return teacher;
      }
    }
    return null;
  }

  @override
  Future<void> create(Teacher teacher) async {
    await _delay();
    if (_teachers.any((item) => item.id == teacher.id)) {
      throw ApiError(409, 'Mã giảng viên đã tồn tại.');
    }
    _teachers.add(teacher);
  }

  @override
  Future<void> update(Teacher teacher) async {
    await _delay();
    final index = _teachers.indexWhere((item) => item.id == teacher.id);
    if (index < 0) {
      throw ApiError(404, 'Không tìm thấy giảng viên.');
    }
    _teachers[index] = teacher;
  }

  @override
  Future<void> delete(String id) async {
    await _delay();
    final index = _teachers.indexWhere((teacher) => teacher.id == id);
    if (index < 0) {
      throw ApiError(404, 'Không tìm thấy giảng viên.');
    }
    _teachers.removeAt(index);
  }

  Future<void> _delay() =>
      Future<void>.delayed(const Duration(milliseconds: 300));
}

const _teacherRoles = [UserRole.teacher];
const _managerRoles = [UserRole.teacher, UserRole.manager];

const _seedTeachers = [
  Teacher(
    id: 'GV001',
    fullName: 'Trần Văn Bình',
    degree: 'Tiến sĩ',
    faculty: 'Công nghệ thông tin',
    email: 'binh.tran@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV002',
    fullName: 'Lê Thu Hà',
    degree: 'Tiến sĩ',
    faculty: 'Công nghệ thông tin',
    email: 'ha.le@example.edu.vn',
    positions: _managerRoles,
  ),
  Teacher(
    id: 'GV003',
    fullName: 'Phạm Hữu Phúc',
    degree: 'Phó giáo sư',
    faculty: 'Kỹ thuật',
    email: 'phuc.pham@example.edu.vn',
    positions: _managerRoles,
  ),
  Teacher(
    id: 'GV004',
    fullName: 'Nguyễn Thị Mai',
    degree: 'Tiến sĩ',
    faculty: 'Kinh tế',
    email: 'mai.nguyen@example.edu.vn',
    positions: _managerRoles,
  ),
  Teacher(
    id: 'GV005',
    fullName: 'Đỗ Thanh Tùng',
    degree: 'Thạc sĩ',
    faculty: 'Kỹ thuật',
    email: 'tung.do@example.edu.vn',
    positions: _managerRoles,
  ),
  Teacher(
    id: 'GV006',
    fullName: 'Võ Ngọc Lan',
    degree: 'Tiến sĩ',
    faculty: 'Ngoại ngữ',
    email: 'lan.vo@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV007',
    fullName: 'Bùi Minh Sơn',
    degree: 'Thạc sĩ',
    faculty: 'Công nghệ thông tin',
    email: 'son.bui@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV008',
    fullName: 'Hoàng Đức Long',
    degree: 'Tiến sĩ',
    faculty: 'Kỹ thuật',
    email: 'long.hoang@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV009',
    fullName: 'Đặng Hải Nam',
    degree: 'Thạc sĩ',
    faculty: 'Kinh tế',
    email: 'nam.dang@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV010',
    fullName: 'Nguyễn Thu Hà',
    degree: 'Tiến sĩ',
    faculty: 'Công nghệ thông tin',
    email: 'thuha.nguyen@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV011',
    fullName: 'Lê Hoàng Phúc',
    degree: 'Thạc sĩ',
    faculty: 'Kỹ thuật',
    email: 'phuc.le@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV012',
    fullName: 'Phạm Gia Huy',
    degree: 'Tiến sĩ',
    faculty: 'Công nghệ thông tin',
    email: 'huy.pham@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV013',
    fullName: 'Đỗ Phương Linh',
    degree: 'Thạc sĩ',
    faculty: 'Ngoại ngữ',
    email: 'linh.do@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV014',
    fullName: 'Võ Thanh Tâm',
    degree: 'Tiến sĩ',
    faculty: 'Kinh tế',
    email: 'tam.vo@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV015',
    fullName: 'Nguyễn Thanh Tùng',
    degree: 'Thạc sĩ',
    faculty: 'Kỹ thuật',
    email: 'tung.nguyen@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV016',
    fullName: 'Trần Quốc Bảo',
    degree: 'Tiến sĩ',
    faculty: 'Công nghệ thông tin',
    email: 'bao.tran@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV017',
    fullName: 'Lê Minh Châu',
    degree: 'Thạc sĩ',
    faculty: 'Ngoại ngữ',
    email: 'chau.le@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV018',
    fullName: 'Hoàng Hải Yến',
    degree: 'Tiến sĩ',
    faculty: 'Kinh tế',
    email: 'yen.hoang@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV019',
    fullName: 'Bùi Đức Anh',
    degree: 'Thạc sĩ',
    faculty: 'Kỹ thuật',
    email: 'anh.bui@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV020',
    fullName: 'Nguyễn Hoài An',
    degree: 'Tiến sĩ',
    faculty: 'Công nghệ thông tin',
    email: 'an.nguyen@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV021',
    fullName: 'Trần Thị Hương',
    degree: 'Thạc sĩ',
    faculty: 'Ngoại ngữ',
    email: 'huong.tran@example.edu.vn',
    positions: _teacherRoles,
  ),
  Teacher(
    id: 'GV022',
    fullName: 'Phan Minh Tuấn',
    degree: 'Tiến sĩ',
    faculty: 'Kinh tế',
    email: 'tuan.phan@example.edu.vn',
    positions: _teacherRoles,
  ),
];
