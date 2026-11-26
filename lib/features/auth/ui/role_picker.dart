import 'package:flutter/material.dart';

import '../../../core/constants/user_role.dart';
import '../../../shared/widgets/app_button.dart';

Future<UserRole?> showRolePicker(BuildContext context) => showDialog<UserRole>(
  context: context,
  builder: (context) => const RolePicker(),
);

class RolePicker extends StatelessWidget {
  const RolePicker({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Chọn chức vụ'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final role in [UserRole.teacher, UserRole.manager])
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              width: 260,
              height: 64,
              child: AppButton(
                label: role.label,
                kind: AppButtonKind.ghost,
                onPressed: () => Navigator.pop(context, role),
              ),
            ),
          ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Hủy'),
      ),
    ],
  );
}
