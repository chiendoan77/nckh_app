import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/council/data/council.dart';

void main() {
  test('Phân tích thông tin hội đồng và thành viên an toàn', () {
    final council = Council.fromJson({
      'maHoiDong': 'HD01',
      'ten': 'Hội đồng đề cương 1',
      'loai': 'DE_CUONG',
      'ngayLap': '2026-03-12',
      'thanhVien': [
        {'maGv': 'GV001', 'hoTen': 'Trần Văn Bình', 'vaiTro': 'CHU_TICH'},
      ],
      'deTai': ['DT01'],
    });

    expect(council.id, 'HD01');
    expect(council.type, CouncilType.outline);
    expect(council.members.single.teacherId, 'GV001');
    expect(council.members.single.role, CouncilRole.chair);
    expect(council.topicIds, ['DT01']);
  });

  test('Dữ liệu thiếu không làm hỏng hội đồng', () {
    final council = Council.fromJson({});

    expect(council.id, isEmpty);
    expect(council.createdOn, isNull);
    expect(council.members, isEmpty);
    expect(council.topicIds, isEmpty);
  });
}
