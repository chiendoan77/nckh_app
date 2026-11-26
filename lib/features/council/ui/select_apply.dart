import 'package:flutter/material.dart';

import '../../../core/network/api_error.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_toast.dart';

class SelectApply<T> extends StatefulWidget {
  const SelectApply({
    super.key,
    required this.label,
    required this.options,
    required this.labelOf,
    required this.onApply,
  });

  final String label;
  final List<T> options;
  final String Function(T) labelOf;
  final Future<void> Function(T) onApply;

  @override
  State<SelectApply<T>> createState() => _SelectApplyState<T>();
}

class _SelectApplyState<T> extends State<SelectApply<T>> {
  T? _selected;
  bool _isApplying = false;

  @override
  void didUpdateWidget(covariant SelectApply<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selected != null && !widget.options.contains(_selected)) {
      _selected = null;
    }
  }

  Future<void> _apply() async {
    final selected = _selected;
    if (selected == null || _isApplying) {
      return;
    }
    setState(() => _isApplying = true);
    try {
      await widget.onApply(selected);
      if (mounted) {
        setState(() => _selected = null);
        AppToast.success(context, 'Cập nhật thành công');
      }
    } on ApiError catch (error) {
      if (mounted) {
        AppToast.error(context, error.message);
      }
    } finally {
      if (mounted) {
        setState(() => _isApplying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(widget.label, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: DropdownButton<T>(
              isExpanded: true,
              value: _selected,
              hint: const Text('Vui lòng chọn'),
              items: widget.options
                  .map(
                    (option) => DropdownMenuItem<T>(
                      value: option,
                      child: Text(
                        widget.labelOf(option),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: _isApplying
                  ? null
                  : (value) => setState(() => _selected = value),
            ),
          ),
          const SizedBox(width: 8),
          AppButton(
            label: 'APPLY',
            onPressed: _selected == null || _isApplying ? null : _apply,
          ),
        ],
      ),
    ],
  );
}
