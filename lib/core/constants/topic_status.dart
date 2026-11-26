enum TopicStatus {
  draft('MOI_TAO', 'Mới tạo', canEdit: true),
  pending('CHO_DUYET', 'Chờ duyệt', canEdit: true),
  approved('DA_DUYET', 'Đã duyệt'),
  inProgress('DANG_THUC_HIEN', 'Đang thực hiện'),
  extended('GIA_HAN', 'Gia hạn'),
  completed('HOAN_THANH', 'Hoàn thành', isFinal: true),
  cancelled('DA_HUY', 'Đã hủy', isFinal: true);

  const TopicStatus(
    this.apiCode,
    this.label, {
    this.canEdit = false,
    this.isFinal = false,
  });

  final String apiCode;
  final String label;
  final bool canEdit;
  final bool isFinal;

  static TopicStatus fromApi(String? code) => values.firstWhere(
    (status) => status.apiCode == code,
    orElse: () => TopicStatus.draft,
  );
}

enum TopicAction { approve, cancel, extend }

const allowedActions = <TopicStatus, List<TopicAction>>{
  TopicStatus.pending: [TopicAction.approve, TopicAction.cancel],
  TopicStatus.inProgress: [TopicAction.extend, TopicAction.cancel],
};
