import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;

import '../../../app/env.dart';
import '../../../core/network/dio_client.dart';
import '../data/api_grade_repository.dart';
import '../data/grade.dart';
import '../data/grade_repository.dart';
import '../data/mock_grade_repository.dart';

final gradeRepositoryProvider = Provider<GradeRepository>(
  (ref) => Env.useMock
      ? MockGradeRepository()
      : ApiGradeRepository(ref.watch(dioProvider)),
);

final gradesProvider = FutureProvider.autoDispose.family<List<Grade>, String>(
  (ref, studentId) =>
      ref.watch(gradeRepositoryProvider).listForStudent(studentId),
);

final gradeProvider = FutureProvider.autoDispose.family<Grade?, String>(
  (ref, topicId) => ref.watch(gradeRepositoryProvider).get(topicId),
);

final gradeSearchProvider = StateProvider.autoDispose<String>((_) => '');

final visibleGradesProvider = Provider.autoDispose
    .family<AsyncValue<List<Grade>>, String>((ref, id) {
      final keyword = ref.watch(gradeSearchProvider).trim().toLowerCase();
      return ref
          .watch(gradesProvider(id))
          .whenData(
            (grades) => grades
                .where(
                  (grade) => grade.topicTitle.toLowerCase().contains(keyword),
                )
                .toList(),
          );
    });
