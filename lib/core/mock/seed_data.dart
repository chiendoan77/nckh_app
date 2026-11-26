import '../auth/user.dart';
import '../constants/user_role.dart';

class MockAccount {
  const MockAccount({
    required this.username,
    required this.password,
    required this.token,
    required this.user,
  });

  final String username;
  final String password;
  final String token;
  final User user;
}

const seedAccounts = [
  MockAccount(
    username: 'sv001',
    password: '123456',
    token: 'mock-token-sv001',
    user: User(
      name: 'Nguyễn Minh Anh',
      role: UserRole.student,
      studentId: 'SV001',
    ),
  ),
  MockAccount(
    username: 'gv001',
    password: '123456',
    token: 'mock-token-gv001',
    user: User(
      name: 'Trần Văn Bình',
      role: UserRole.teacher,
      teacherId: 'GV001',
      positions: [UserRole.teacher],
    ),
  ),
  MockAccount(
    username: 'gv002',
    password: '123456',
    token: 'mock-token-gv002',
    user: User(
      name: 'Lê Thu Hà',
      role: UserRole.teacher,
      teacherId: 'GV002',
      positions: [UserRole.teacher, UserRole.manager],
    ),
  ),
  MockAccount(
    username: 'admin',
    password: 'admin123',
    token: 'mock-token-admin',
    user: User(name: 'Quản trị viên', role: UserRole.admin),
  ),
];
