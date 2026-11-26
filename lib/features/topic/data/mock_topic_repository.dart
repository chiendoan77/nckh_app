import '../../../core/constants/topic_status.dart';
import '../../../core/network/api_error.dart';
import 'topic.dart';
import 'topic_repository.dart';

class MockTopicRepository implements TopicRepository {
  final List<Topic> _topics = _seedTopics();
  bool _hasRegistered = false;
  int _nextId = 13;

  @override
  Future<List<Topic>> list({TopicStatus? status}) async {
    await _delay();
    return _topics
        .where((topic) => status == null || topic.status == status)
        .toList();
  }

  @override
  Future<void> create({
    required String title,
    required String description,
  }) async {
    await _delay();
    _topics.add(
      Topic(
        id: 'DT${_nextId++}',
        title: title,
        authorName: 'Sinh viên hiện tại',
        description: description,
        status: TopicStatus.pending,
        isMine: true,
      ),
    );
  }

  @override
  Future<void> update(
    String id, {
    required String title,
    required String description,
  }) async {
    await _delay();
    final index = _indexOf(id);
    final topic = _topics[index];
    if (!topic.isMine || topic.status != TopicStatus.pending) {
      throw ApiError(403, 'Bạn không thể chỉnh sửa đề tài này.');
    }
    _topics[index] = _copy(topic, title: title, description: description);
  }

  @override
  Future<void> register(String topicId) async {
    await _delay();
    final index = _indexOf(topicId);
    if (_hasRegistered) {
      throw ApiError(409, 'Sinh viên đã đăng ký đề tài khác.');
    }
    final topic = _topics[index];
    if (topic.status != TopicStatus.approved) {
      throw ApiError(409, 'Đề tài hiện không thể đăng ký.');
    }
    _hasRegistered = true;
    _topics[index] = _copy(
      topic,
      isMine: true,
      memberNames: [...topic.memberNames, 'Nguyễn Minh Anh'],
    );
  }

  @override
  Future<void> approve(String id) async {
    await _delay();
    final index = _indexOf(id);
    final topic = _topics[index];
    if (topic.status != TopicStatus.pending) {
      throw ApiError(409, 'Đề tài không còn ở trạng thái chờ duyệt.');
    }
    _topics[index] = _copy(topic, status: TopicStatus.approved);
  }

  @override
  Future<void> cancel(String id, {required String reason}) async {
    await _delay();
    if (reason.trim().isEmpty) {
      throw ApiError(400, 'Vui lòng nhập lý do hủy đề tài.');
    }
    final index = _indexOf(id);
    _topics[index] = _copy(_topics[index], status: TopicStatus.cancelled);
  }

  @override
  Future<void> extend(String id, {required DateTime newDeadline}) async {
    await _delay();
    final index = _indexOf(id);
    final topic = _topics[index];
    if (topic.status != TopicStatus.inProgress) {
      throw ApiError(409, 'Chỉ có thể gia hạn đề tài đang thực hiện.');
    }
    _topics[index] = _copy(
      topic,
      status: TopicStatus.extended,
      gradingDeadline: newDeadline,
    );
  }

  int _indexOf(String id) {
    final index = _topics.indexWhere((topic) => topic.id == id);
    if (index < 0) {
      throw ApiError(404, 'Không tìm thấy đề tài.');
    }
    return index;
  }

  Topic _copy(
    Topic topic, {
    String? title,
    String? description,
    TopicStatus? status,
    List<String>? memberNames,
    bool? isMine,
    DateTime? gradingDeadline,
  }) => Topic(
    id: topic.id,
    title: title ?? topic.title,
    authorName: topic.authorName,
    description: description ?? topic.description,
    status: status ?? topic.status,
    supervisor: topic.supervisor,
    memberNames: memberNames ?? topic.memberNames,
    phase: topic.phase,
    documents: topic.documents,
    isMine: isMine ?? topic.isMine,
    gradingDeadline: gradingDeadline ?? topic.gradingDeadline,
  );

  Future<void> _delay() =>
      Future<void>.delayed(const Duration(milliseconds: 300));
}

List<Topic> _seedTopics() => [
  const Topic(
    id: 'DT01',
    title: 'Ứng dụng robot hỗ trợ phòng thí nghiệm',
    authorName: 'Nguyễn Minh Anh',
    description: 'Nghiên cứu robot hỗ trợ vận chuyển thiết bị.',
    status: TopicStatus.approved,
    isMine: false,
  ),
  const Topic(
    id: 'DT02',
    title: 'Phân tích dữ liệu môi trường',
    authorName: 'Trần Quốc Bảo',
    description: 'Phân tích dữ liệu chất lượng không khí.',
    status: TopicStatus.approved,
  ),
  const Topic(
    id: 'DT03',
    title: 'Ứng dụng học máy trong giáo dục',
    authorName: 'Lê Thu Hà',
    description: 'Phân tích dữ liệu học tập của sinh viên.',
    status: TopicStatus.pending,
  ),
  const Topic(
    id: 'DT04',
    title: 'Hệ thống theo dõi năng lượng',
    authorName: 'Nguyễn Minh Anh',
    description: 'Đề xuất mô hình theo dõi mức tiêu thụ năng lượng.',
    status: TopicStatus.pending,
    isMine: true,
  ),
  const Topic(
    id: 'DT05',
    title: 'Nền tảng thư viện số',
    authorName: 'Phạm Gia Huy',
    description: 'Xây dựng nền tảng tra cứu tài liệu nghiên cứu.',
    status: TopicStatus.inProgress,
  ),
  const Topic(
    id: 'DT06',
    title: 'Nhận dạng biển báo giao thông',
    authorName: 'Đặng Hải Nam',
    description: 'Ứng dụng thị giác máy tính nhận dạng biển báo.',
    status: TopicStatus.inProgress,
  ),
  const Topic(
    id: 'DT07',
    title: 'Mô hình nông nghiệp thông minh',
    authorName: 'Võ Ngọc Mai',
    description: 'Giám sát độ ẩm bằng cảm biến.',
    status: TopicStatus.extended,
  ),
  const Topic(
    id: 'DT08',
    title: 'Trợ lý tra cứu tài liệu',
    authorName: 'Bùi Minh Châu',
    description: 'Tìm kiếm tài liệu học thuật tiếng Việt.',
    status: TopicStatus.completed,
  ),
  const Topic(
    id: 'DT09',
    title: 'Phân loại rác thải tại nguồn',
    authorName: 'Hoàng Đức Long',
    description: 'Nghiên cứu phương pháp phân loại rác thải.',
    status: TopicStatus.completed,
  ),
  const Topic(
    id: 'DT10',
    title: 'Mạng cảm biến ven biển',
    authorName: 'Lê Hoàng Phúc',
    description: 'Theo dõi các chỉ số môi trường ven biển.',
    status: TopicStatus.cancelled,
  ),
  const Topic(
    id: 'DT11',
    title: 'Số hóa hiện vật địa phương',
    authorName: 'Nguyễn Thanh Tùng',
    description: 'Xây dựng bộ dữ liệu hiện vật địa phương.',
    status: TopicStatus.draft,
  ),
  const Topic(
    id: 'DT12',
    title: 'Ứng dụng robot hướng dẫn tham quan',
    authorName: 'Đỗ Phương Linh',
    description: 'Nghiên cứu robot hướng dẫn trong bảo tàng.',
    status: TopicStatus.completed,
  ),
];
