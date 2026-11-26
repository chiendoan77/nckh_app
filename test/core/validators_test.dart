import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/core/utils/validators.dart';

void main() {
  test('Bắt buộc nhập giá trị không rỗng', () {
    expect(validateRequired('  '), isNotNull);
    expect(validateRequired('Nguyễn An'), isNull);
  });

  test('Chỉ chấp nhận điểm từ 0 đến 10', () {
    expect(validateScore('-0.1'), isNotNull);
    expect(validateScore('10.1'), isNotNull);
    expect(validateScore('không phải điểm'), isNotNull);
    expect(validateScore('8.5'), isNull);
  });
}
