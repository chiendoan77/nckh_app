import 'package:flutter/material.dart';

import '../../../core/constants/user_role.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/dialog_frame.dart';

Future<UserRole?> showRolePicker(BuildContext context) => showDialog<UserRole>(
  context: context,
  builder: (context) => const RolePicker(),
);

class RolePicker extends StatelessWidget {
  const RolePicker({super.key});

  @override
  Widget build(BuildContext context) => DialogFrame(
    title: 'Chọn chức vụ',
    actions: [
      AppButton(
        label: 'Hủy',
        kind: AppButtonKind.ghost,
        onPressed: () => Navigator.pop(context),
      ),
    ],
    child: Column(
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
  );
}
