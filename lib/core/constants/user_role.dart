enum UserRole {
  student('SINH_VIEN', 'Sinh viên'),
  teacher('GIANG_VIEN', 'Giảng viên'),
  manager('QUAN_LY', 'Quản lý'),
  admin('ADMIN', 'Admin');

  const UserRole(this.apiCode, this.label);

  final String apiCode;
  final String label;

  static UserRole fromApi(String? code) => values.firstWhere(
    (role) => role.apiCode == code,
    orElse: () => UserRole.student,
  );
}
