import '../../../core/constants/topic_status.dart';
import '../../../core/network/api_error.dart';
import '../../topic/data/topic.dart';
import '../../user/data/teacher.dart';
import 'council.dart';
import 'council_repository.dart';

class MockCouncilRepository implements CouncilRepository {
  final List<Council> _councils = [
    Council(
      id: 'HD01',
      name: 'Hội đồng đề cương 1',
      type: CouncilType.outline,
      createdOn: DateTime(2026, 3, 12),
      members: [],
      topicIds: [],
    ),
    Council(
      id: 'HD02',
      name: 'Hội đồng bảo vệ 1',
      type: CouncilType.defense,
      createdOn: DateTime(2026, 4, 2),
      members: [
        CouncilMember(
          teacherId: 'GV002',
          name: 'Lê Thu Hà',
          role: CouncilRole.chair,
        ),
      ],
      topicIds: ['DT01'],
    ),
    Council(
      id: 'HD03',
      name: 'Hội đồng đề cương 2',
      type: CouncilType.outline,
      createdOn: DateTime(2026, 4, 16),
      members: [],
      topicIds: [],
    ),
  ];
  int _nextId = 4;

  @override
  Future<List<Council>> list() async {
    await _delay();
    return List.unmodifiable(_councils);
  }

  @override
  Future<Council?> get(String id) async {
    await _delay();
    for (final council in _councils) {
      if (council.id == id) {
        return council;
      }
    }
    return null;
  }

  @override
  Future<void> create({
    required String name,
    required CouncilType type,
    required DateTime createdOn,
  }) async {
    await _delay();
    _councils.add(
      Council(
        id: 'HD${(_nextId++).toString().padLeft(2, '0')}',
        name: name,
        type: type,
        createdOn: createdOn,
        members: const [],
        topicIds: const [],
      ),
    );
  }

  @override
  Future<void> assignMember(
    String id, {
    required Teacher teacher,
    required CouncilRole role,
  }) async {
    await _delay();
    final index = _indexOf(id);
    final council = _councils[index];
    if (council.members.any((member) => member.teacherId == teacher.id)) {
      throw ApiError(409, 'Giảng viên đã có trong hội đồng.');
    }
    _councils[index] = _copy(
      council,
      members: [
        ...council.members,
        CouncilMember(
          teacherId: teacher.id,
          name: teacher.fullName,
          role: role,
        ),
      ],
    );
  }

  @override
  Future<void> assignTopic(String id, Topic topic) async {
    await _delay();
    if (topic.status != TopicStatus.approved) {
      throw ApiError(409, 'Chỉ được gắn đề tài đã phê duyệt.');
    }
    final index = _indexOf(id);
    final council = _councils[index];
    if (council.topicIds.contains(topic.id)) {
      throw ApiError(409, 'Đề tài đã có trong hội đồng.');
    }
    _councils[index] = _copy(
      council,
      topicIds: [...council.topicIds, topic.id],
    );
  }

  int _indexOf(String id) {
    final index = _councils.indexWhere((council) => council.id == id);
    if (index < 0) {
      throw ApiError(404, 'Không tìm thấy hội đồng.');
    }
    return index;
  }

  Council _copy(
    Council council, {
    List<CouncilMember>? members,
    List<String>? topicIds,
  }) => Council(
    id: council.id,
    name: council.name,
    type: council.type,
    createdOn: council.createdOn,
    members: members ?? council.members,
    topicIds: topicIds ?? council.topicIds,
  );

  Future<void> _delay() =>
      Future<void>.delayed(const Duration(milliseconds: 300));
}
