import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/grading/data/mock_grade_repository.dart';

void main() {
  test('Trả điểm của sinh viên theo các đề tài đã chấm', () async {
    final repository = MockGradeRepository();

    final grades = await repository.listForStudent('SV001');

    expect(grades, hasLength(3));
    expect(
      grades.every(
        (grade) => grade.scores.any((score) => score.studentId == 'SV001'),
      ),
      isTrue,
    );
  });
}
