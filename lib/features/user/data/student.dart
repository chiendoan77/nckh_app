enum StudentStatus {
  active('HOAT_DONG', 'Hoạt động'),
  suspended('DINH_CHI', 'Đình chỉ');

  const StudentStatus(this.apiCode, this.label);

  final String apiCode;
  final String label;

  static StudentStatus fromApi(String? code) => values.firstWhere(
    (status) => status.apiCode == code,
    orElse: () => StudentStatus.active,
  );
}

class Student {
  const Student({
    required this.id,
    required this.fullName,
    required this.major,
    required this.gpa,
    required this.status,
    this.birthDate,
  });

  final String id;
  final String fullName;
  final DateTime? birthDate;
  final String major;
  final double gpa;
  final StudentStatus status;

  factory Student.fromJson(Map<String, dynamic> json) {
    final gpaValue = json['gpa'];
    final gpa = gpaValue is num
        ? gpaValue.toDouble()
        : gpaValue is String
        ? double.tryParse(gpaValue) ?? 0
        : 0.0;
    return Student(
      id: json['maSv'] as String? ?? '',
      fullName: json['hoTen'] as String? ?? '',
      birthDate: DateTime.tryParse(json['ngaySinh'] as String? ?? ''),
      major: json['chuyenNganh'] as String? ?? '',
      gpa: gpa,
      status: StudentStatus.fromApi(json['trangThai'] as String?),
    );
  }

  Map<String, Object?> toJson() => {
    'maSv': id,
    'hoTen': fullName,
    'ngaySinh': birthDate?.toIso8601String(),
    'chuyenNganh': major,
    'gpa': gpa,
    'trangThai': status.apiCode,
  };
}
