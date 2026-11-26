import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nckh_app/features/stats/data/sample_workbook.dart';

void main() {
  test('Tạo workbook XLSX có tiêu đề và số liệu mẫu', () {
    final workbook = ZipDecoder().decodeBytes(createSampleWorkbook());
    final worksheet = workbook.findFile('xl/worksheets/sheet1.xml');

    expect(worksheet, isNotNull);
    final content = utf8.decode(worksheet!.content as List<int>);
    expect(content, contains('Hủy'));
    expect(content, contains('Duyệt'));
    expect(content, contains('Trễ'));
    expect(content, contains('<v>8</v>'));
  });
}
