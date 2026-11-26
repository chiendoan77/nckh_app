import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/constants/topic_status.dart';
import 'package:nckh_app/features/grading/data/mock_grade_repository.dart';
import 'package:nckh_app/features/grading/ui/grade_form_dialog.dart';
import 'package:nckh_app/features/grading/ui/grade_providers.dart';
import 'package:nckh_app/features/topic/data/topic.dart';

void main() {
  const topic = Topic(
    id: 'DT13',
    title: 'Nghiên cứu ứng dụng cảm biến',
    authorName: 'Nguyễn Minh Anh',
    description: 'Đánh giá cảm biến môi trường.',
    status: TopicStatus.completed,
    memberNames: ['Nguyễn Minh Anh'],
    memberIds: ['SV001'],
  );

  testWidgets('Lưu điểm cho phép sinh viên tra cứu kết quả mới', (
    tester,
  ) async {
    final repository = MockGradeRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [gradeRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showGradeFormDialog(context, topic),
                child: const Text('Mở form'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Mở form'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('grade-score')), '8.5');
    await tester.enterText(
      find.byKey(const Key('grade-comment')),
      'Kết quả nghiên cứu tốt.',
    );
    await tester.tap(find.text('Lưu'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    final gradesFuture = repository.listForStudent('SV001');
    await tester.pump(const Duration(milliseconds: 300));
    final studentGrades = await gradesFuture;
    final grade = studentGrades.firstWhere((item) => item.topicId == 'DT13');
    expect(grade.average, 8.5);
    expect(grade.comment, 'Kết quả nghiên cứu tốt.');
  });

  testWidgets('Điểm ngoài khoảng 0 đến 10 không được lưu', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          gradeRepositoryProvider.overrideWithValue(MockGradeRepository()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showGradeFormDialog(context, topic),
                child: const Text('Mở form'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Mở form'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('grade-score')), '11');
    await tester.enterText(
      find.byKey(const Key('grade-comment')),
      'Điểm ngoài khoảng.',
    );
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();

    expect(find.text('Điểm phải từ 0 đến 10.'), findsOneWidget);
    expect(find.text('Chấm điểm đề tài'), findsOneWidget);
    expect(find.byKey(const Key('grade-score')), findsOneWidget);
  });
}
