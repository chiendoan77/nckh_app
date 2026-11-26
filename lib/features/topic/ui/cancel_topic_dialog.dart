import 'package:flutter/material.dart';

import '../../../shared/widgets/app_button.dart';

Future<String?> showCancelTopicDialog(BuildContext context) =>
    showDialog<String>(
      context: context,
      builder: (_) => const CancelTopicDialog(),
    );

class CancelTopicDialog extends StatefulWidget {
  const CancelTopicDialog({super.key});

  @override
  State<CancelTopicDialog> createState() => _CancelTopicDialogState();
}

class _CancelTopicDialogState extends State<CancelTopicDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Lý do hủy đề tài'),
    content: Form(
      key: _formKey,
      child: TextFormField(
        controller: _reasonController,
        decoration: const InputDecoration(labelText: 'Lý do'),
        minLines: 2,
        maxLines: 4,
        validator: (value) => value == null || value.trim().isEmpty
            ? 'Vui lòng nhập lý do hủy đề tài.'
            : null,
      ),
    ),
    actions: [
      AppButton(
        label: 'Quay lại',
        kind: AppButtonKind.ghost,
        onPressed: () => Navigator.pop(context),
      ),
      AppButton(
        label: 'Gửi yêu cầu hủy',
        kind: AppButtonKind.danger,
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            Navigator.pop(context, _reasonController.text.trim());
          }
        },
      ),
    ],
  );
}
