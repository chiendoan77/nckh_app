import '../../topic/data/topic.dart';
import '../../user/data/teacher.dart';
import 'council.dart';

abstract class CouncilRepository {
  Future<List<Council>> list();

  Future<Council?> get(String id);

  Future<void> create({
    required String name,
    required CouncilType type,
    required DateTime createdOn,
  });

  Future<void> assignMember(
    String id, {
    required Teacher teacher,
    required CouncilRole role,
  });

  Future<void> assignTopic(String id, Topic topic);
}
