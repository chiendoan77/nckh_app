class TopicStats {
  const TopicStats({
    required this.cancelled,
    required this.approved,
    required this.late,
  });

  final int cancelled;
  final int approved;
  final int late;

  factory TopicStats.fromJson(Map<String, dynamic> json) => TopicStats(
    cancelled: _readCount(json['huy']),
    approved: _readCount(json['duyet']),
    late: _readCount(json['tre']),
  );
}

int _readCount(Object? value) => switch (value) {
  int count when count >= 0 => count,
  num count when count >= 0 => count.toInt(),
  String count => int.tryParse(count) ?? 0,
  _ => 0,
};
