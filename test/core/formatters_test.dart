import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/utils/formatters.dart';

void main() {
  test('Định dạng ngày theo kiểu ngày/tháng/năm', () {
    expect(formatDate(DateTime(2026, 11, 26)), '26/11/2026');
  });
}
