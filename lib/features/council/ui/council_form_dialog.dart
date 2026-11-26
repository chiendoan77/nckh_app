import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/form_dialog.dart';
import '../data/council.dart';

Future<void> showCouncilFormDialog(
  BuildContext context, {
  required Future<void> Function(
    String name,
    CouncilType type,
    DateTime createdOn,
  )
  onSubmit,
}) => showDialog<void>(
  context: context,
  builder: (_) => _CouncilFormDialog(onSubmit: onSubmit),
);

class _CouncilFormDialog extends StatefulWidget {
  const _CouncilFormDialog({required this.onSubmit});

  final Future<void> Function(String, CouncilType, DateTime) onSubmit;

  @override
  State<_CouncilFormDialog> createState() => _CouncilFormDialogState();
}

class _CouncilFormDialogState extends State<_CouncilFormDialog> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  CouncilType _type = CouncilType.outline;
  DateTime _createdOn = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController.text = formatDate(_createdOn);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _createdOn,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && mounted) {
      setState(() {
        _createdOn = date;
        _dateController.text = formatDate(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) => FormDialog(
    title: 'Thêm hội đồng',
    submitText: 'Tạo hội đồng',
    onSubmit: () =>
        widget.onSubmit(_nameController.text.trim(), _type, _createdOn),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final nameField = TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Tên hội đồng'),
          validator: (value) => value == null || value.trim().isEmpty
              ? 'Vui lòng nhập tên hội đồng.'
              : null,
        );
        final typeField = DropdownButtonFormField<CouncilType>(
          initialValue: _type,
          decoration: const InputDecoration(labelText: 'Loại hội đồng'),
          items: CouncilType.values
              .map(
                (type) =>
                    DropdownMenuItem(value: type, child: Text(type.label)),
              )
              .toList(),
          onChanged: (type) {
            if (type != null) {
              setState(() => _type = type);
            }
          },
        );
        final dateField = TextFormField(
          readOnly: true,
          controller: _dateController,
          decoration: const InputDecoration(
            labelText: 'Ngày lập',
            suffixIcon: Icon(Icons.calendar_today),
          ),
          onTap: _chooseDate,
        );
        final shortFields = constraints.maxWidth >= 480
            ? Row(
                children: [
                  Expanded(child: typeField),
                  const SizedBox(width: 16),
                  Expanded(child: dateField),
                ],
              )
            : Column(
                children: [typeField, const SizedBox(height: 16), dateField],
              );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [nameField, const SizedBox(height: 16), shortFields],
        );
      },
    ),
  );
}
