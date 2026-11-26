import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/constants/topic_status.dart';

void main() {
  test('Ánh xạ mã API về đủ bảy trạng thái đề tài', () {
    expect(
      TopicStatus.values.map((status) => TopicStatus.fromApi(status.apiCode)),
      TopicStatus.values,
    );
  });

  test('Mã trạng thái không xác định mặc định là mới tạo', () {
    expect(TopicStatus.fromApi(null), TopicStatus.draft);
    expect(TopicStatus.fromApi('KHONG_RO'), TopicStatus.draft);
  });

  test('Chỉ trạng thái mới tạo và chờ duyệt được chỉnh sửa', () {
    expect(TopicStatus.values.where((status) => status.canEdit), [
      TopicStatus.draft,
      TopicStatus.pending,
    ]);
  });

  test('Hành động quản lý phụ thuộc trạng thái đề tài', () {
    expect(allowedActions[TopicStatus.pending], [
      TopicAction.approve,
      TopicAction.cancel,
    ]);
    expect(allowedActions[TopicStatus.inProgress], [
      TopicAction.extend,
      TopicAction.cancel,
    ]);
    expect(allowedActions[TopicStatus.completed], isNull);
  });
}
