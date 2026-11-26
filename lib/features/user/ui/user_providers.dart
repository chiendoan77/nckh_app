import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env.dart';
import '../../../core/network/dio_client.dart';
import '../data/api_student_repository.dart';
import '../data/api_teacher_repository.dart';
import '../data/mock_student_repository.dart';
import '../data/mock_teacher_repository.dart';
import '../data/student.dart';
import '../data/student_repository.dart';
import '../data/teacher.dart';
import '../data/teacher_repository.dart';

final studentRepositoryProvider = Provider<StudentRepository>(
  (ref) => Env.useMock
      ? MockStudentRepository()
      : ApiStudentRepository(ref.watch(dioProvider)),
);

final studentProvider = FutureProvider.autoDispose.family<Student?, String>(
  (ref, id) => ref.watch(studentRepositoryProvider).get(id),
);

final studentsProvider = FutureProvider.autoDispose<List<Student>>(
  (ref) => ref.watch(studentRepositoryProvider).list(),
);

final teacherRepositoryProvider = Provider<TeacherRepository>(
  (ref) => Env.useMock
      ? MockTeacherRepository()
      : ApiTeacherRepository(ref.watch(dioProvider)),
);

final teachersProvider = FutureProvider.autoDispose<List<Teacher>>(
  (ref) => ref.watch(teacherRepositoryProvider).list(),
);
