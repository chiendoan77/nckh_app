import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/utils/paging.dart';

void main() {
  test('Lấy đúng 20 phần tử ở trang đầu', () {
    final items = List<int>.generate(25, (index) => index + 1);

    expect(pageOf(items, 1), List<int>.generate(20, (index) => index + 1));
  });

  test('Lấy 5 phần tử còn lại ở trang thứ hai', () {
    final items = List<int>.generate(25, (index) => index + 1);

    expect(pageOf(items, 2), [21, 22, 23, 24, 25]);
  });

  test('Trang vượt quá số dữ liệu trả về danh sách rỗng', () {
    expect(pageOf([1, 2, 3], 2), isEmpty);
  });
}
