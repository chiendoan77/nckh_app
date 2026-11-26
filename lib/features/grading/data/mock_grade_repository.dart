import '../../../core/network/api_error.dart';
import 'grade.dart';
import 'grade_repository.dart';

class MockGradeRepository implements GradeRepository {
  final List<Grade> _grades = [
    const Grade(
      topicId: 'DT08',
      topicTitle: 'Trợ lý tra cứu tài liệu',
      average: 8.5,
      reportTerm: '2025–2026',
      comment: 'Sản phẩm đáp ứng mục tiêu nghiên cứu.',
      scores: [
        MemberScore(name: 'Nguyễn Minh Anh', studentId: 'SV001', score: 8.5),
        MemberScore(name: 'Lê Thu Hà', studentId: 'SV002', score: 8),
      ],
    ),
    const Grade(
      topicId: 'DT09',
      topicTitle: 'Phân loại rác thải tại nguồn',
      average: 9,
      reportTerm: '2025–2026',
      comment: 'Kết quả triển khai tốt.',
      scores: [
        MemberScore(name: 'Nguyễn Minh Anh', studentId: 'SV001', score: 9),
      ],
    ),
    const Grade(
      topicId: 'DT12',
      topicTitle: 'Ứng dụng robot hướng dẫn tham quan',
      average: 7.5,
      reportTerm: '2024–2025',
      comment: 'Cần hoàn thiện thêm phần đánh giá.',
      scores: [
        MemberScore(name: 'Nguyễn Minh Anh', studentId: 'SV001', score: 7.5),
      ],
    ),
  ];

  @override
  Future<List<Grade>> listForStudent(String studentId) async {
    await _delay();
    return _grades
        .where(
          (grade) => grade.scores.any((score) => score.studentId == studentId),
        )
        .toList();
  }

  @override
  Future<Grade?> get(String topicId) async {
    await _delay();
    for (final grade in _grades) {
      if (grade.topicId == topicId) {
        return grade;
      }
    }
    return null;
  }

  @override
  Future<void> create(Grade grade) async {
    await _delay();
    if (_grades.any((item) => item.topicId == grade.topicId)) {
      throw ApiError(409, 'Đề tài đã có điểm.');
    }
    _grades.add(grade);
  }

  @override
  Future<void> update(String topicId, Grade grade) async {
    await _delay();
    final index = _grades.indexWhere((item) => item.topicId == topicId);
    if (index < 0) {
      throw ApiError(404, 'Không tìm thấy bảng điểm.');
    }
    _grades[index] = grade;
  }

  Future<void> _delay() =>
      Future<void>.delayed(const Duration(milliseconds: 300));
}
