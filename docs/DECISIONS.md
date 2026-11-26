# Nhật ký quyết định

Các quyết định nghiệp vụ đã chốt được ghi tại `AGENTS.md` (D1–D16).

Trong giai đoạn khởi tạo P0 chưa phát sinh quyết định ngoài các nội dung đã chốt.

- P5: Thêm package `archive` để mock xuất workbook `.xlsx` hợp lệ thay vì đổi đuôi cho dữ liệu văn bản.
- P8: Đặt khai báo `Env` trong `core/network` để phần mạng không phụ thuộc ngược vào `app`; giữ `app/env.dart` làm export tương thích.
- UI-1: Chưa có font trong `assets/fonts/`; khai báo BeVietnamPro và SourceSerif4 với fallback Roboto, chưa thêm cấu hình font đến khi có tệp font.
