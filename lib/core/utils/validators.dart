String? validateRequired(String? value) =>
    value == null || value.trim().isEmpty ? 'Trường này là bắt buộc.' : null;

String? validateScore(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Vui lòng nhập điểm.';
  }
  final score = double.tryParse(value.trim());
  if (score == null || score < 0 || score > 10) {
    return 'Điểm phải từ 0 đến 10.';
  }
  return null;
}
