import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/env.dart';
import '../../../core/network/dio_client.dart';
import '../data/api_student_repository.dart';
import '../data/mock_student_repository.dart';
import '../data/student.dart';
import '../data/student_repository.dart';

final studentRepositoryProvider = Provider<StudentRepository>(
  (ref) => Env.useMock
      ? MockStudentRepository()
      : ApiStudentRepository(ref.watch(dioProvider)),
);

final studentProvider = FutureProvider.autoDispose.family<Student?, String>(
  (ref, id) => ref.watch(studentRepositoryProvider).get(id),
);
