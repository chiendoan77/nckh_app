import 'student.dart';

abstract class StudentRepository {
  Future<List<Student>> list();

  Future<Student?> get(String id);

  Future<void> create(Student student);

  Future<void> update(Student student);

  Future<void> delete(String id);
}
