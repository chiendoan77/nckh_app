# Hệ thống quản lý đề tài nghiên cứu khoa học

Frontend Flutter ưu tiên Web/Desktop cho Trường Đại học Quy Nhơn.

## Yêu cầu

- Flutter SDK hỗ trợ nền tảng Web và Windows.
- Chrome để chạy bản Web.

## Chạy với dữ liệu giả lập

```powershell
flutter run -d chrome --dart-define=USE_MOCK=true
```

## Chạy với API

```powershell
flutter run -d chrome --dart-define=USE_MOCK=false --dart-define=API_BASE_URL=http://localhost:8080
```

Khi chạy Flutter Web khác origin với API Gateway, Gateway cần bật CORS cho origin của ứng dụng.

## Kiểm tra chất lượng

```powershell
dart format .
flutter analyze
flutter test
```
