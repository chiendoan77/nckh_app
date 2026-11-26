import '../../../core/constants/user_role.dart';

class Teacher {
  const Teacher({
    required this.id,
    required this.fullName,
    this.degree = '',
    this.faculty = '',
    this.email = '',
    this.positions = const [],
  });

  final String id;
  final String fullName;
  final String degree;
  final String faculty;
  final String email;
  final List<UserRole> positions;

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    id: json['maGv'] as String? ?? '',
    fullName: json['hoTen'] as String? ?? '',
    degree: json['hocVi'] as String? ?? '',
    faculty: json['khoa'] as String? ?? '',
    email: json['email'] as String? ?? '',
    positions: (json['chucVu'] as List? ?? const [])
        .map((code) => UserRole.fromApi('$code'))
        .toList(),
  );

  Map<String, Object?> toJson() => {
    'maGv': id,
    'hoTen': fullName,
    'hocVi': degree,
    'khoa': faculty,
    'email': email,
    'chucVu': positions.map((role) => role.apiCode).toList(),
  };
}
