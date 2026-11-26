import '../../../core/constants/topic_status.dart';
import 'topic.dart';

abstract class TopicRepository {
  Future<List<Topic>> list({TopicStatus? status});
  Future<void> create({required String title, required String description});
  Future<void> update(
    String id, {
    required String title,
    required String description,
  });
  Future<void> register(String topicId);
  Future<void> approve(String id);
  Future<void> cancel(String id, {required String reason});
  Future<void> extend(String id, {required DateTime newDeadline});
}
