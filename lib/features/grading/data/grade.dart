class Grade {
  const Grade({
    required this.topicId,
    required this.topicTitle,
    required this.average,
    required this.reportTerm,
    required this.comment,
    this.scores = const [],
  });

  final String topicId;
  final String topicTitle;
  final double average;
  final String reportTerm;
  final String comment;
  final List<MemberScore> scores;

  factory Grade.fromJson(Map<String, dynamic> json) {
    final averageValue = json['diemTrungBinh'];
    final members = json['thanhVien'];
    return Grade(
      topicId: json['maDeTai'] as String? ?? '',
      topicTitle: json['tenDeTai'] as String? ?? '',
      average: averageValue is num
          ? averageValue.toDouble()
          : averageValue is String
          ? double.tryParse(averageValue) ?? 0
          : 0,
      reportTerm: json['kyBaoCao'] as String? ?? '',
      comment: json['nhanXet'] as String? ?? '',
      scores: members is List
          ? members
                .whereType<Map>()
                .map(
                  (member) =>
                      MemberScore.fromJson(Map<String, dynamic>.from(member)),
                )
                .toList()
          : const [],
    );
  }

  Map<String, Object?> toJson() => {
    'maDeTai': topicId,
    'tenDeTai': topicTitle,
    'diemTrungBinh': average,
    'kyBaoCao': reportTerm,
    'nhanXet': comment,
    'thanhVien': scores.map((score) => score.toJson()).toList(),
  };
}

class MemberScore {
  const MemberScore({
    required this.name,
    required this.studentId,
    required this.score,
  });

  final String name;
  final String studentId;
  final double score;

  factory MemberScore.fromJson(Map<String, dynamic> json) {
    final scoreValue = json['score'];
    return MemberScore(
      name: json['name'] as String? ?? '',
      studentId: json['studentId'] as String? ?? '',
      score: scoreValue is num
          ? scoreValue.toDouble()
          : scoreValue is String
          ? double.tryParse(scoreValue) ?? 0
          : 0,
    );
  }

  Map<String, Object?> toJson() => {
    'name': name,
    'studentId': studentId,
    'score': score,
  };
}
