import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/grading/data/grade.dart';

void main() {
  test('Phân tích điểm và điểm thành viên từ JSON', () {
    final grade = Grade.fromJson({
      'maDeTai': 'DT08',
      'tenDeTai': 'Trợ lý tra cứu tài liệu',
      'diemTrungBinh': 8.5,
      'kyBaoCao': '2026-1',
      'nhanXet': 'Đạt yêu cầu.',
      'thanhVien': [
        {'name': 'Nguyễn Minh Anh', 'studentId': 'SV001', 'score': 8.5},
      ],
    });

    expect(grade.topicId, 'DT08');
    expect(grade.average, 8.5);
    expect(grade.scores.single.studentId, 'SV001');
    expect(grade.scores.single.score, 8.5);
  });

  test('Giá trị thiếu được xử lý an toàn', () {
    final grade = Grade.fromJson({'thanhVien': null});

    expect(grade.topicId, isEmpty);
    expect(grade.average, 0);
    expect(grade.scores, isEmpty);
  });
}
