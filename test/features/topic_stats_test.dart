import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/stats/data/topic_stats.dart';

void main() {
  test('Ánh xạ số liệu thống kê từ phản hồi API', () {
    final stats = TopicStats.fromJson({'huy': 3, 'duyet': 8, 'tre': 2});

    expect(stats.cancelled, 3);
    expect(stats.approved, 8);
    expect(stats.late, 2);
  });

  test('Giá trị thiếu được xem là không có bản ghi', () {
    final stats = TopicStats.fromJson(const {});

    expect(stats.cancelled, 0);
    expect(stats.approved, 0);
    expect(stats.late, 0);
  });
}
