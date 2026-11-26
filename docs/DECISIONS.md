# Nhật ký quyết định

Các quyết định nghiệp vụ đã chốt được ghi tại `AGENTS.md` (D1–D16).

Trong giai đoạn khởi tạo P0 chưa phát sinh quyết định ngoài các nội dung đã chốt.

- P5: Thêm package `archive` để mock xuất workbook `.xlsx` hợp lệ thay vì đổi đuôi cho dữ liệu văn bản.
- P8: Đặt khai báo `Env` trong `core/network` để phần mạng không phụ thuộc ngược vào `app`; giữ `app/env.dart` làm export tương thích.
- UI: Dùng nền #F4F6F8, bề mặt trắng, chữ xanh đen, accent vàng đồng #C08A2E; màu trạng thái và admin được gom trong `AppTokens`.
- UI: BeVietnamPro cho thân chữ, SourceSerif4 cho tiêu đề; chưa có tệp trong `assets/fonts/`, nên cấu hình fallback Roboto và chưa khai báo assets font.
- UI: Dùng `DialogFrame` chung với vạch accent, nền trắng, viền mảnh, góc chéo, bóng nhẹ, thân cuộn và chân hộp chứa nút.
- UI: Thẻ hội đồng dùng vạch xanh đen cho Đề cương và vàng đồng cho Bảo vệ; vạch là dấu hiệu phân loại, không thay đổi trạng thái nghiệp vụ.
- UI-7: Cần thay favicon và biểu tượng web mặc định Flutter khi có tệp biểu tượng chính thức.
