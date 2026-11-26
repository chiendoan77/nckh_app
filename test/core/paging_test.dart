import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/utils/paging.dart';

void main() {
  test('Trang vượt quá số dữ liệu trả về danh sách rỗng', () {
    expect(pageOf([1, 2, 3], 2), isEmpty);
  });
}
