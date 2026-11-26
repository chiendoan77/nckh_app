import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/constants/topic_status.dart';
import 'package:nckh_app/features/topic/data/topic.dart';

void main() {
  test('Đọc đủ trường đề tài và giảng viên hướng dẫn từ JSON', () {
    final topic = Topic.fromJson({
      'maDeTai': 'DT01',
      'tenDeTai': 'Nhận dạng tiếng Việt',
      'sinhVienTao': 'Nguyễn An',
      'moTa': 'Xây dựng mô hình nhận dạng.',
      'trangThai': 'CHO_DUYET',
      'gvhd': {
        'maGv': 'GV01',
        'hoTen': 'Trần Bình',
        'hocVi': 'Tiến sĩ',
        'khoa': 'Công nghệ thông tin',
        'email': 'binh@example.edu.vn',
      },
      'thanhVien': ['Nguyễn An', 'Lê Hà'],
      'giaiDoan': 'Đề cương',
      'taiLieu': [
        {'name': 'Đề cương', 'url': 'https://example.edu.vn/file.pdf'},
      ],
      'laCuaToi': true,
      'hanChamDiem': '2026-12-01T00:00:00.000',
    });

    expect(topic.id, 'DT01');
    expect(topic.title, 'Nhận dạng tiếng Việt');
    expect(topic.status, TopicStatus.pending);
    expect(topic.supervisor?.degree, 'Tiến sĩ');
    expect(topic.memberNames, ['Nguyễn An', 'Lê Hà']);
    expect(topic.documents.single.name, 'Đề cương');
    expect(topic.isMine, isTrue);
    expect(topic.gradingDeadline, DateTime(2026, 12, 1));
  });

  test('Trường JSON bị thiếu được xử lý an toàn', () {
    final topic = Topic.fromJson({});

    expect(topic.id, isEmpty);
    expect(topic.title, isEmpty);
    expect(topic.status, TopicStatus.draft);
    expect(topic.supervisor, isNull);
    expect(topic.memberNames, isEmpty);
    expect(topic.documents, isEmpty);
    expect(topic.gradingDeadline, isNull);
  });

  test('Đọc mã và tên sinh viên tham gia từ JSON hội viên dạng đối tượng', () {
    final topic = Topic.fromJson({
      'thanhVien': [
        {'maSv': 'SV001', 'hoTen': 'Nguyễn Minh Anh'},
      ],
    });

    expect(topic.memberNames, ['Nguyễn Minh Anh']);
    expect(topic.memberIds, ['SV001']);
  });
}
