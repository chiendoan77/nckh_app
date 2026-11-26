import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/form_dialog.dart';
import '../data/topic.dart';
import 'topic_providers.dart';

Future<void> showTopicFormDialog(
  BuildContext context,
  WidgetRef ref, {
  Topic? topic,
}) => showDialog<void>(
  context: context,
  builder: (_) => TopicFormDialog(topic: topic),
);

class TopicFormDialog extends ConsumerStatefulWidget {
  const TopicFormDialog({super.key, this.topic});

  final Topic? topic;

  @override
  ConsumerState<TopicFormDialog> createState() => _TopicFormDialogState();
}

class _TopicFormDialogState extends ConsumerState<TopicFormDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.topic?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.topic?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final repository = ref.read(topicRepositoryProvider);
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    if (widget.topic == null) {
      await repository.create(title: title, description: description);
    } else {
      await repository.update(
        widget.topic!.id,
        title: title,
        description: description,
      );
    }

    if (!mounted) {
      return;
    }
    ref.invalidate(topicsProvider);
    AppToast.success(
      context,
      widget.topic == null
          ? 'Đề xuất đề tài thành công.'
          : 'Cập nhật thành công.',
    );
  }

  @override
  Widget build(BuildContext context) => FormDialog(
    title: widget.topic == null ? 'Đề xuất đề tài' : 'Chỉnh sửa đề tài',
    submitText: widget.topic == null ? 'Gửi đề xuất' : 'Lưu',
    onSubmit: _submit,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Tên đề tài'),
          validator: validateRequired,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: 'Mô tả'),
          minLines: 3,
          maxLines: 6,
          validator: validateRequired,
        ),
      ],
    ),
  );
}
