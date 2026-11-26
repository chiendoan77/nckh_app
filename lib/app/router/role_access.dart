import '../../core/constants/user_role.dart';
import 'paths.dart';

UserRole? roleForPath(String location) {
  if (location.startsWith('/student/')) {
    return UserRole.student;
  }
  if (location.startsWith('/teacher/')) {
    return UserRole.teacher;
  }
  if (location.startsWith('/manager/')) {
    return UserRole.manager;
  }
  if (location.startsWith('/admin/')) {
    return UserRole.admin;
  }
  return null;
}

String homeOf(UserRole role) => switch (role) {
  UserRole.student => Paths.studentTopics,
  UserRole.teacher => Paths.teacherActive,
  UserRole.manager => Paths.managerTopics,
  UserRole.admin => Paths.adminStudents,
};
