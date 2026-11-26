import '../../../core/constants/topic_status.dart';
import '../../user/data/teacher.dart';

class Topic {
  const Topic({
    required this.id,
    required this.title,
    required this.authorName,
    required this.description,
    required this.status,
    this.supervisor,
    this.memberNames = const [],
    this.memberIds = const [],
    this.phase = '',
    this.documents = const [],
    this.isMine = false,
    this.gradingDeadline,
  });

  final String id;
  final String title;
  final String authorName;
  final String description;
  final TopicStatus status;
  final Teacher? supervisor;
  final List<String> memberNames;
  final List<String> memberIds;
  final String phase;
  final List<TopicDocument> documents;
  final bool isMine;
  final DateTime? gradingDeadline;

  factory Topic.fromJson(Map<String, dynamic> json) {
    final supervisor = json['gvhd'];
    final members = json['thanhVien'];
    final documents = json['taiLieu'];
    final memberItems = members is List ? members : const [];
    return Topic(
      id: json['maDeTai'] as String? ?? '',
      title: json['tenDeTai'] as String? ?? '',
      authorName: json['sinhVienTao'] as String? ?? '',
      description: json['moTa'] as String? ?? '',
      status: TopicStatus.fromApi(json['trangThai'] as String?),
      supervisor: supervisor is Map
          ? Teacher.fromJson(Map<String, dynamic>.from(supervisor))
          : null,
      memberNames: memberItems
          .map((member) {
            if (member is String) {
              return member;
            }
            if (member is Map) {
              return member['hoTen'] as String? ?? '';
            }
            return '';
          })
          .where((name) => name.isNotEmpty)
          .toList(),
      memberIds: memberItems
          .whereType<Map>()
          .map((member) => member['maSv'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toList(),
      phase: json['giaiDoan'] as String? ?? '',
      documents: documents is List
          ? documents
                .whereType<Map>()
                .map(
                  (document) => TopicDocument.fromJson(
                    Map<String, dynamic>.from(document),
                  ),
                )
                .toList()
          : const [],
      isMine: json['laCuaToi'] == true,
      gradingDeadline: DateTime.tryParse(json['hanChamDiem'] as String? ?? ''),
    );
  }
}

class TopicDocument {
  const TopicDocument({required this.name, required this.url});

  final String name;
  final String url;

  factory TopicDocument.fromJson(Map<String, dynamic> json) => TopicDocument(
    name: json['name'] as String? ?? '',
    url: json['url'] as String? ?? '',
  );
}
