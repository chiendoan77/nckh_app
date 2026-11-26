import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/network/api_response.dart';

void main() {
  test('Lấy dữ liệu bên trong response được bọc', () {
    expect(
      unwrap({
        'success': true,
        'data': {'id': 'DT01'},
      }),
      {'id': 'DT01'},
    );
  });

  test('Giữ nguyên response không có trường data', () {
    expect(unwrap({'id': 'DT01'}), {'id': 'DT01'});
  });

  test('Chuyển danh sách response thành danh sách map', () {
    expect(
      unwrapList({
        'data': [
          {'id': 'DT01'},
        ],
      }),
      [
        {'id': 'DT01'},
      ],
    );
  });
}
