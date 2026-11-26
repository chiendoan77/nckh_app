import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/constants/topic_status.dart';
import 'package:nckh_app/features/topic/data/topic.dart';
import 'package:nckh_app/features/topic/ui/topic_card.dart';

void main() {
  testWidgets(
    'Hiện nhãn riêng tư và nút chỉnh sửa cho đề tài chờ duyệt của mình',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 360,
              height: 320,
              child: TopicCard(
                topic: _topic(status: TopicStatus.pending, isMine: true),
                onView: () {},
                onEdit: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('PRIVATE'), findsOneWidget);
      expect(find.text('Chỉnh sửa'), findsOneWidget);
    },
  );

  testWidgets('Không cho chỉnh sửa đề tài không phải của mình', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 360,
            height: 320,
            child: TopicCard(
              topic: _topic(status: TopicStatus.pending, isMine: false),
              onView: () {},
              onEdit: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('PRIVATE'), findsNothing);
    expect(find.text('Chỉnh sửa'), findsNothing);
  });
}

Topic _topic({required TopicStatus status, required bool isMine}) => Topic(
  id: 'DT01',
  title: 'Đề tài thử nghiệm',
  authorName: 'Sinh viên',
  description: 'Mô tả đề tài',
  status: status,
  isMine: isMine,
);
