import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/topic_status.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_button.dart';
import '../../topic/data/topic.dart';
import '../../user/data/teacher.dart';
import '../data/council.dart';
import 'council_providers.dart';
import 'select_apply.dart';

Future<void> showCouncilDetailDialog(
  BuildContext context, {
  required Council council,
  required List<Teacher> teachers,
  required List<Topic> topics,
}) => showDialog<void>(
  context: context,
  builder: (_) => _CouncilDetailDialog(
    council: council,
    teachers: teachers,
    topics: topics,
  ),
);

class _CouncilDetailDialog extends ConsumerStatefulWidget {
  const _CouncilDetailDialog({
    required this.council,
    required this.teachers,
    required this.topics,
  });

  final Council council;
  final List<Teacher> teachers;
  final List<Topic> topics;

  @override
  ConsumerState<_CouncilDetailDialog> createState() =>
      _CouncilDetailDialogState();
}

class _CouncilDetailDialogState extends ConsumerState<_CouncilDetailDialog> {
  late Council _council = widget.council;
  CouncilRole _role = CouncilRole.member;

  Future<void> _refresh() async {
    final council = await ref.read(councilRepositoryProvider).get(_council.id);
    if (!mounted) {
      return;
    }
    if (council != null) {
      setState(() => _council = council);
    }
    ref.invalidate(councilsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final availableTeachers = widget.teachers
        .where(
          (teacher) =>
              !_council.members.any((member) => member.teacherId == teacher.id),
        )
        .toList();
    final availableTopics = widget.topics
        .where(
          (topic) =>
              topic.status == TopicStatus.approved &&
              !_council.topicIds.contains(topic.id),
        )
        .toList();

    return AlertDialog(
      title: Text(_council.name),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_council.type.label} · ${_council.createdOn == null ? 'Chưa có ngày lập' : formatDate(_council.createdOn!)}',
              ),
              const SizedBox(height: 20),
              Text('Thành viên', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (_council.members.isEmpty)
                const Text('Chưa có thành viên.')
              else
                ..._council.members.map(
                  (member) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(member.name),
                    subtitle: Text(member.role.label),
                  ),
                ),
              const SizedBox(height: 12),
              DropdownButtonFormField<CouncilRole>(
                initialValue: _role,
                decoration: const InputDecoration(labelText: 'Vai trò'),
                items: CouncilRole.values
                    .map(
                      (role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.label),
                      ),
                    )
                    .toList(),
                onChanged: (role) {
                  if (role != null) {
                    setState(() => _role = role);
                  }
                },
              ),
              SelectApply<Teacher>(
                key: ValueKey('teachers-${_council.members.length}'),
                label: 'Phân công thành viên',
                options: availableTeachers,
                labelOf: (teacher) => '${teacher.id} · ${teacher.fullName}',
                onApply: (teacher) async {
                  await ref
                      .read(councilRepositoryProvider)
                      .assignMember(_council.id, teacher: teacher, role: _role);
                  await _refresh();
                },
              ),
              const Divider(height: 32),
              Text('Đề tài', style: Theme.of(context).textTheme.titleLarge),
              if (_council.topicIds.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('Chưa gắn đề tài.'),
                )
              else
                ..._council.topicIds.map(
                  (id) => ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(_topicTitle(id)),
                    subtitle: Text(id),
                  ),
                ),
              SelectApply<Topic>(
                key: ValueKey('topics-${_council.topicIds.length}'),
                label: 'Gắn đề tài',
                options: availableTopics,
                labelOf: (topic) => '${topic.id} · ${topic.title}',
                onApply: (topic) async {
                  await ref
                      .read(councilRepositoryProvider)
                      .assignTopic(_council.id, topic);
                  await _refresh();
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          label: 'Đóng',
          kind: AppButtonKind.ghost,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  String _topicTitle(String id) {
    for (final topic in widget.topics) {
      if (topic.id == id) {
        return topic.title;
      }
    }
    return id;
  }
}
