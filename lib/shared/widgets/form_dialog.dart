import 'package:flutter/material.dart';

import '../../core/network/api_error.dart';
import 'app_button.dart';
import 'app_toast.dart';

class FormDialog extends StatefulWidget {
  const FormDialog({
    super.key,
    required this.title,
    required this.child,
    required this.onSubmit,
    this.submitText = 'Lưu',
  });

  final String title;
  final Widget child;
  final Future<void> Function() onSubmit;
  final String submitText;

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await widget.onSubmit();
      if (mounted) {
        Navigator.pop(context);
      }
    } on ApiError catch (error) {
      if (mounted) {
        AppToast.error(context, error.message);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SingleChildScrollView(
      child: Form(key: _formKey, child: widget.child),
    ),
    actions: [
      AppButton(
        label: 'Hủy bỏ',
        kind: AppButtonKind.ghost,
        onPressed: _isSubmitting ? null : () => Navigator.pop(context),
      ),
      AppButton(
        label: widget.submitText,
        onPressed: _isSubmitting ? null : _submit,
      ),
    ],
  );
}
