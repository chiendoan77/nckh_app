import 'grade.dart';

abstract class GradeRepository {
  Future<List<Grade>> listForStudent(String studentId);

  Future<Grade?> get(String topicId);

  Future<void> create(Grade grade);

  Future<void> update(String topicId, Grade grade);
}
