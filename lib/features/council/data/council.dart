enum CouncilType {
  outline('DE_CUONG', 'Đề cương'),
  defense('BAO_VE', 'Bảo vệ');

  const CouncilType(this.apiCode, this.label);

  final String apiCode;
  final String label;

  static CouncilType fromApi(String? code) => values.firstWhere(
    (type) => type.apiCode == code,
    orElse: () => CouncilType.outline,
  );
}

enum CouncilRole {
  chair('CHU_TICH', 'Chủ tịch'),
  secretary('THU_KY', 'Thư ký'),
  member('THANH_VIEN', 'Thành viên'),
  reviewer('PHAN_BIEN', 'Phản biện');

  const CouncilRole(this.apiCode, this.label);

  final String apiCode;
  final String label;

  static CouncilRole fromApi(String? code) => values.firstWhere(
    (role) => role.apiCode == code,
    orElse: () => CouncilRole.member,
  );
}

class Council {
  const Council({
    required this.id,
    required this.name,
    required this.type,
    required this.members,
    required this.topicIds,
    this.createdOn,
  });

  final String id;
  final String name;
  final CouncilType type;
  final DateTime? createdOn;
  final List<CouncilMember> members;
  final List<String> topicIds;

  factory Council.fromJson(Map<String, dynamic> json) {
    final members = json['thanhVien'];
    final topics = json['deTai'];
    return Council(
      id: json['maHoiDong'] as String? ?? '',
      name: json['ten'] as String? ?? '',
      type: CouncilType.fromApi(json['loai'] as String?),
      createdOn: DateTime.tryParse(json['ngayLap'] as String? ?? ''),
      members: members is List
          ? members
                .whereType<Map>()
                .map(
                  (member) =>
                      CouncilMember.fromJson(Map<String, dynamic>.from(member)),
                )
                .toList()
          : const [],
      topicIds: topics is List
          ? topics
                .map((topic) {
                  if (topic is String) {
                    return topic;
                  }
                  if (topic is Map) {
                    return topic['maDeTai'];
                  }
                  return null;
                })
                .whereType<String>()
                .toList()
          : const [],
    );
  }

  Map<String, Object?> toJson() => {
    'maHoiDong': id,
    'ten': name,
    'loai': type.apiCode,
    'ngayLap': createdOn?.toIso8601String(),
    'thanhVien': members.map((member) => member.toJson()).toList(),
    'deTai': topicIds,
  };
}

class CouncilMember {
  const CouncilMember({
    required this.teacherId,
    required this.name,
    required this.role,
  });

  final String teacherId;
  final String name;
  final CouncilRole role;

  factory CouncilMember.fromJson(Map<String, dynamic> json) => CouncilMember(
    teacherId: json['maGv'] as String? ?? '',
    name: json['hoTen'] as String? ?? '',
    role: CouncilRole.fromApi(json['vaiTro'] as String?),
  );

  Map<String, Object?> toJson() => {
    'maGv': teacherId,
    'hoTen': name,
    'vaiTro': role.apiCode,
  };
}
