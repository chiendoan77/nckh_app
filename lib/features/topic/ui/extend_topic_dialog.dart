import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_button.dart';
import '../data/topic.dart';

Future<DateTime?> showExtendTopicDialog(BuildContext context, Topic topic) =>
    showDialog<DateTime>(
      context: context,
      builder: (_) => ExtendTopicDialog(topic: topic),
    );

class ExtendTopicDialog extends StatefulWidget {
  const ExtendTopicDialog({super.key, required this.topic});

  final Topic topic;

  @override
  State<ExtendTopicDialog> createState() => _ExtendTopicDialogState();
}

class _ExtendTopicDialogState extends State<ExtendTopicDialog> {
  DateTime? _deadline;

  Future<void> _chooseDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final initialDate = widget.topic.gradingDeadline ?? today;
    final deadline = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(today) ? today : initialDate,
      firstDate: today,
      lastDate: today.add(const Duration(days: 3650)),
      helpText: 'Chọn hạn mới',
      cancelText: 'Đóng',
      confirmText: 'Chọn',
    );
    if (deadline != null && mounted) {
      setState(() => _deadline = deadline);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Gia hạn đề tài'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _deadline == null
              ? 'Chưa chọn hạn mới.'
              : 'Hạn mới: ${formatDate(_deadline!)}',
        ),
        const SizedBox(height: 12),
        AppButton(
          label: 'Chọn ngày',
          kind: AppButtonKind.ghost,
          onPressed: _chooseDate,
        ),
      ],
    ),
    actions: [
      AppButton(
        label: 'Đóng',
        kind: AppButtonKind.ghost,
        onPressed: () => Navigator.pop(context),
      ),
      AppButton(
        label: 'Gia hạn',
        onPressed: _deadline == null
            ? null
            : () => Navigator.pop(context, _deadline),
      ),
    ],
  );
}
