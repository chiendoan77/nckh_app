import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_toast.dart';
import '../data/topic.dart';

Future<void> showTeacherDialog(
  BuildContext context,
  Topic topic,
) => showDialog<void>(
  context: context,
  builder: (dialogContext) => AlertDialog(
    title: Text(topic.title),
    content: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppTokens.readableWidth),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Giảng viên: ${topic.supervisor?.fullName ?? 'Chưa phân công'}',
            ),
            const SizedBox(height: 12),
            Text(
              'Sinh viên tham gia',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (topic.memberNames.isEmpty)
              const Text('Chưa có sinh viên tham gia.')
            else
              for (final name in topic.memberNames) Text(name),
            const SizedBox(height: 12),
            Text(
              'Giai đoạn: ${topic.phase.isEmpty ? 'Chưa cập nhật' : topic.phase}',
            ),
            const SizedBox(height: 12),
            Text('Tài liệu', style: Theme.of(context).textTheme.titleLarge),
            if (topic.documents.isEmpty)
              const Text('Chưa có tài liệu.')
            else
              for (final document in topic.documents)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(document.name),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () => _openDocument(dialogContext, document),
                ),
          ],
        ),
      ),
    ),
    actions: [
      AppButton(
        label: 'Đóng',
        kind: AppButtonKind.ghost,
        onPressed: () => Navigator.pop(dialogContext),
      ),
    ],
  ),
);

Future<void> _openDocument(BuildContext context, TopicDocument document) async {
  final opened = await launchUrl(
    Uri.parse(document.url),
    mode: LaunchMode.externalApplication,
  );
  if (context.mounted && !opened) {
    AppToast.error(context, 'Không mở được tài liệu.');
  }
}
