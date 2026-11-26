import '../constants/user_role.dart';

class User {
  const User({
    required this.name,
    required this.role,
    this.studentId,
    this.teacherId,
    this.positions = const [],
  });

  final String name;
  final UserRole role;
  final String? studentId;
  final String? teacherId;
  final List<UserRole> positions;

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'] as String? ?? '',
    role: UserRole.fromApi(json['role'] as String?),
    studentId: json['maSv'] as String?,
    teacherId: json['maGv'] as String?,
    positions: (json['chucVu'] as List? ?? const [])
        .map((code) => UserRole.fromApi('$code'))
        .toList(),
  );

  bool get hasMultiRoles =>
      role == UserRole.teacher && positions.contains(UserRole.manager);
}
