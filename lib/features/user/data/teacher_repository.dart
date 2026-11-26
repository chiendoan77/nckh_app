import 'teacher.dart';

abstract class TeacherRepository {
  Future<List<Teacher>> list();

  Future<Teacher?> get(String id);

  Future<void> create(Teacher teacher);

  Future<void> update(Teacher teacher);

  Future<void> delete(String id);
}
