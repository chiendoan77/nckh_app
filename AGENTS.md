# AGENTS.md — Hướng dẫn xây dựng Frontend Flutter: Hệ thống quản lý đề tài NCKH

> **Dành cho AI coding agent (Codex).** Đặt file này ở thư mục gốc project Flutter với tên `AGENTS.md`.
> Đọc **toàn bộ** file trước khi viết code. Làm **tuần tự theo Giai đoạn (§13)**. Không hỏi lại những gì đã chốt ở §4.

---

## 0. Cách làm việc (bắt buộc)

1. Làm đúng thứ tự P0 → P8. **Không sang giai đoạn sau** khi giai đoạn hiện tại chưa đạt mục "Done khi".
2. Cuối **mỗi giai đoạn** chạy: `dart format .` → `flutter analyze` (**0 issue**) → `flutter test` (pass).
3. Spec mơ hồ → áp dụng §4. Nếu §4 cũng không có → chọn phương án đơn giản nhất, ghi 1 dòng vào `docs/DECISIONS.md`, **không dừng lại hỏi**.
4. Chỉ thêm package có trong §5. Cần package khác → ghi lý do trong `docs/DECISIONS.md`.
5. Không đổi cấu trúc thư mục ở §6 và **không đổi tên** đã quy định ở §3 nếu không có lý do bắt buộc.
6. Commit nhỏ, mỗi giai đoạn ≥ 1 commit, message dạng `P2: auth + router + shell`.

---

## 1. Bối cảnh

Frontend Flutter (**Web/Desktop ưu tiên**, co giãn được xuống mobile) cho hệ thống quản lý đề tài nghiên cứu khoa học trường ĐH Quy Nhơn. Backend là 9 microservice (Spring Boot) sau **API Gateway `http://localhost:8080`**, xác thực **JWT Bearer (HS256, 1 giờ)**, REST + JSON.

**4 vai trò:** Sinh viên (student), Giảng viên (teacher), Quản lý (manager), Admin (admin). Một giảng viên có thể kiêm Quản lý và chọn chức vụ khi đăng nhập.

**Phạm vi giai đoạn này:** cấu trúc + code hiển thị chạy được. **Chưa** tinh chỉnh màu/hiệu ứng (dùng giá trị tạm trong `app_tokens.dart`).

---

## 2. Quy tắc cứng (MUST / MUST NOT)

**MUST**
- Mọi chữ hiển thị cho người dùng bằng **tiếng Việt có dấu**.
- Mọi màu/cỡ chữ/bo góc lấy từ `AppTokens` hoặc `Theme.of(context)`.
- Mọi lời gọi mạng nằm trong repository bản `Api…` (qua `Dio` từ `dioProvider`).
- Mọi repository có **interface + bản `Api` + bản `Mock`**; provider chọn theo `Env.useMock` (§10).
- Mọi màn tải dữ liệu xử lý đủ 3 trạng thái `loading / error (có nút Thử lại) / empty`.
- Mọi thao tác ghi: **toast thành công** hoặc **toast lỗi** (thông điệp từ `ApiError`).
- Mọi nút **HỦY / XÓA** dùng `AppButton(kind: AppButtonKind.danger)` (luôn đỏ) và đi qua `ConfirmDialog`.
- Sau `await`, kiểm tra `context.mounted` trước khi dùng `context`.
- Dùng `const` constructor, `GridView/ListView.builder`, `autoDispose` cho provider theo màn.

**MUST NOT**
- Không viết `dio.get/post` trong widget/page.
- Không hard-code màu ngoài `app_tokens.dart` (trừ `Colors.white`/`transparent`).
- Không vi phạm quy tắc phụ thuộc ở §6.
- Không dùng `setState` cho dữ liệu từ server (dùng Riverpod); `setState` chỉ cho UI cục bộ (tab, trang hiện tại).
- Không dùng `dynamic` tràn lan; model có kiểu rõ ràng.
- Không đặt tên vi phạm §3.

---

## 3. Quy ước đặt tên (đọc kỹ — áp dụng cho MỌI file mới)

**Mục tiêu: đọc tên là hiểu, không cần mở file; nhưng không dài dòng.**

### 3.1 Giới hạn độ dài

| Loại | Tối đa | Ví dụ đúng |
|---|---|---|
| Thư mục, file | **≤ 3 từ** | `topic_card.dart`, `council_form_dialog.dart` |
| Class / enum | **≤ 4 từ** | `TopicRepository`, `MockTopicRepository` |
| Biến, hàm, tham số | **≤ 3 từ** (~22 ký tự) | `visibleTopics`, `gradingDeadline` |

Tên dài hơn mức trên = đặt sai chỗ. Chuyển ngữ cảnh lên **thư mục/class cha** thay vì nhồi vào tên (xem 3.4).

### 3.2 Bảng quy tắc theo loại

| Loại | Quy tắc | Ví dụ |
|---|---|---|
| Thư mục | `snake_case`, danh từ **số ít**, 1–2 từ | `topic/`, `council/`, `core/` |
| File | `snake_case` = tên class chính | `TopicCard` → `topic_card.dart` |
| Class | `PascalCase`, danh từ | `Topic`, `CouncilMember` |
| Page | `<Chủ đề><Mục đích>Page` | `TopicRegisterPage`, `StudentManagePage` |
| Dialog (widget) | `<Chủ đề><Loại>Dialog`; hàm mở: `show<Tên>` | `TopicFormDialog` / `showTopicFormDialog()` |
| Enum value | `lowerCamelCase`, nghĩa nghiệp vụ | `TopicStatus.pending` |
| Biến, hàm | `lowerCamelCase`; hàm bắt đầu bằng **động từ** | `topic`, `approveTopic()` |
| Danh sách | **Số nhiều**; phần tử đơn: số ít | `topics` / `topic` |
| Boolean | tiền tố `is / has / can` | `isMine`, `canEdit`, `hasMultiRoles` |
| Provider | `<danh từ>Provider` | `topicsProvider`, `sessionProvider` |
| Callback | `on<Hành động>` | `onView`, `onEdit`, `onApply` |
| Hằng số | `lowerCamelCase` (Dart style) | `pageSize`, `allowedActions` |
| Repository (hàm) | CRUD: `list, get, create, update, delete`; nghiệp vụ: `register, approve, cancel, extend` | `topicRepository.approve(id)` |
| Repository (class) | interface `XRepository`; bản thật `ApiXRepository`; bản giả `MockXRepository` | file: `topic_repository.dart`, `api_topic_repository.dart`, `mock_topic_repository.dart` |
| Test | `<tên file được test>_test.dart` | `paging_test.dart` |

### 3.3 Từ vựng chuẩn (Việt → định danh) — **luôn dùng đúng một từ, không dùng đồng nghĩa**

| Tiếng Việt | Định danh | | Tiếng Việt | Định danh |
|---|---|---|---|---|
| Đề tài | `topic` | | Chuyên ngành | `major` |
| Sinh viên | `student` | | Học vị | `degree` |
| Giảng viên | `teacher` | | Khoa | `faculty` |
| Quản lý | `manager` | | Hồ sơ | `profile` |
| Hội đồng | `council` | | Thống kê | `stats` |
| Thành viên | `member` | | Chức vụ | `position` |
| Điểm / Điểm TB | `score` / `average` | | Giai đoạn | `phase` |
| Nhận xét | `comment` | | Tài liệu | `document` |
| Kỳ báo cáo | `reportTerm` | | Hạn chấm điểm | `gradingDeadline` |
| Phê duyệt | `approve` | | Gia hạn | `extend` |
| Hủy | `cancel` | | Đăng ký | `register` |
| Chờ duyệt | `pending` | | Đình chỉ / Hoạt động | `suspended` / `active` |

Không dùng: `project`, `thesis`, `lecturer`, `pupil`… thay cho từ trong bảng.

### 3.4 Viết tắt

**Cho phép:** `id`, `url`, `api`, `ui`, `gpa`.
**Cấm:** `sv`, `gv`, `ql`, `mgr`, `btn`, `ctrl`, `cfg`, `tmp`, `data1`, `val`, `obj`…

### 3.5 Xấu → Tốt

| ❌ Xấu | ✅ Tốt | Lý do |
|---|---|---|
| `features/student_management_feature/` | `features/admin/` | Quá dài, thừa chữ |
| `svDangKy`, `gvCongViec` | `studentTopics`, `teacherActive` | Viết tắt + trộn Việt/Anh |
| `topicDetailInformationDialogWidget` | `TopicDetailDialog` | Thừa `Information`, `Widget` |
| `maDeTai`, `tenDeTai` (trong Dart) | `id`, `title` | Tên backend chỉ nằm trong `fromJson` |
| `getAllTopicsFromServerList()` | `list()` | Ngữ cảnh đã có ở `TopicRepository` |
| `isTopicEditableByCurrentStudent` | `canEdit` | Đặt trên `Topic`, ngữ cảnh đã rõ |
| `topicListFilteredBySearchProvider` | `visibleTopicsProvider` | Mô tả kết quả, không mô tả cách làm |
| `btnApprove`, `tmpList` | `approveButton`, `topics` | Không viết tắt |
| `profile/` + `student/profile_panel.dart` | `user/ui/profile_panel.dart` | 1 khái niệm — 1 chỗ |

### 3.6 Nguyên tắc đặt tên field model

Model dùng **tên Anh, ngắn, theo từ vựng 3.3**. Khóa JSON của backend chỉ xuất hiện trong `fromJson` (§4-D2, §10.3). Ví dụ `Topic.title` ← JSON `tenDeTai`.

---

## 4. Quyết định đã chốt (không hỏi lại)

| # | Vấn đề | Quyết định |
|---|---|---|
| D1 | JSON bọc `{success, message, data}` | Giả định có bọc. `unwrap()` (`core/network/api_response.dart`) xử lý **cả** trường hợp không bọc (không có key `data` → dùng cả body). |
| D2 | Khóa JSON backend | Giả định camelCase theo khóa nghiệp vụ (`maDeTai`, `tenDeTai`…). **Chỉ parse trong `fromJson`** theo bảng §10.3 → đổi khóa chỉ sửa 1 chỗ. |
| D3 | Login trả về | `{token, role, name, maSv?, maGv?, chucVu: ["GIANG_VIEN","QUAN_LY"]}`. Thiếu `chucVu` → chỉ có vai trò `role`. |
| D4 | Giảng viên kiêm Quản lý | `role == GIANG_VIEN` và `chucVu` chứa `QUAN_LY` → sau login hiện bước chọn chức vụ. Lưu vào `Session.activeRole`; router kiểm quyền theo `activeRole`. |
| D5 | SV "tạo" vs "đăng ký" đề tài | Có **cả hai**: nút "Đề xuất đề tài" → `POST /detai`; nút "Đăng ký" trong dialog chi tiết → `POST /detai/dang-ky`. |
| D6 | Đề tài PRIVATE | Ẩn khỏi bảng chung nếu `status == pending && !isMine`. Đề tài của mình đang `pending`: nhãn **PRIVATE** + nút **Chỉnh sửa**. Lọc phía client trong `visibleTopicsProvider`. |
| D7 | Số SV đình chỉ/hoạt động | Tính từ `GET /sinhvien` ở client. |
| D8 | Phân trang | **Client-side**, 20 bản ghi/trang (`pageSize` trong `core/utils/paging.dart`). 21 bản ghi → 2 trang. |
| D9 | CRUD giảng viên (Admin) | Backend chỉ có `GET /giangvien`. Repository vẫn khai báo `create/update/delete` gọi `POST/PUT/DELETE /giangvien[/{id}]`; bản Mock chạy đầy đủ. |
| D10 | Thống kê | `GET /thong-ke/detai` giả định trả `{huy, duyet, tre}` → `TopicStats{cancelled, approved, late}`. |
| D11 | Xuất Excel | `GET /thong-ke/xuat?dinhDang=excel`, `responseType: bytes`, lưu bằng `file_saver`. |
| D12 | Lưu phiên | v1: trong bộ nhớ (reload = đăng nhập lại). Lưu bền vững: tùy chọn ở P8. |
| D13 | Hồ sơ SV chỉnh sửa | Dialog chỉ có **Họ tên** và **Chuyên ngành**. |
| D14 | Gia hạn | Dialog chọn ngày hạn mới (`showDatePicker`) → `POST /detai/{id}/gia-han` body `{denNgay: ISO8601}`. |
| D15 | Hạn chấm điểm | `Topic.gradingDeadline` (nullable). Null → "Chưa có hạn". |
| D16 | Ngôn ngữ đặt tên | Định danh Dart **tiếng Anh** theo §3; UI text tiếng Việt; URL route tiếng Anh (`/student/topics`). |

---

## 5. Thiết lập

```bash
flutter create --platforms=web,windows --org vn.edu.qnu nckh_app
cd nckh_app
flutter pub add flutter_riverpod go_router dio intl fl_chart file_picker file_saver url_launcher shared_preferences
flutter pub add --dev flutter_lints mocktail
```
- Chạy mock: `flutter run -d chrome --dart-define=USE_MOCK=true`
- Chạy thật: `flutter run -d chrome --dart-define=USE_MOCK=false --dart-define=API_BASE_URL=http://localhost:8080`
- Flutter Web gọi API khác origin → Gateway phải bật CORS (ghi chú trong README, ngoài phạm vi frontend).

---

## 6. Cấu trúc thư mục

```
lib/
├─ main.dart
├─ app/
│  ├─ app.dart                 # MaterialApp.router, theme theo activeRole
│  ├─ env.dart                 # apiBaseUrl, useMock
│  ├─ router/
│  │  ├─ app_router.dart       # routerProvider + redirect
│  │  ├─ paths.dart            # class Paths
│  │  └─ role_access.dart      # roleForPath(), homeOf()
│  └─ theme/
│     ├─ app_tokens.dart       # ★ MÀU – CỠ CHỮ – BO GÓC
│     └─ app_theme.dart
├─ core/                       # hạ tầng, không nghiệp vụ
│  ├─ auth/        user.dart  session.dart
│  ├─ network/     dio_client.dart  api_error.dart  api_response.dart
│  ├─ constants/   user_role.dart  topic_status.dart
│  ├─ mock/        seed_data.dart
│  └─ utils/       formatters.dart  validators.dart  paging.dart
├─ shared/                     # dùng chung, không nghiệp vụ riêng
│  ├─ layout/      app_shell.dart  sidebar.dart  top_bar.dart  nav_items.dart
│  └─ widgets/
│     ├─ app_card.dart  card_grid.dart  app_button.dart  status_badge.dart
│     ├─ hexagon_logo.dart  user_avatar.dart  search_field.dart
│     ├─ form_dialog.dart  confirm_dialog.dart  side_panel.dart
│     ├─ pager_bar.dart  list_row.dart  select_apply.dart  pie_chart_box.dart
│     └─ app_toast.dart  state_views.dart
└─ features/
   │ ── DOMAIN (dữ liệu + UI dùng lại được) ──
   ├─ auth/
   │  ├─ data/  auth_repository.dart  api_auth_repository.dart  mock_auth_repository.dart
   │  └─ ui/    login_page.dart  role_picker.dart
   ├─ topic/
   │  ├─ data/  topic.dart  topic_repository.dart  api_topic_repository.dart  mock_topic_repository.dart
   │  └─ ui/    topic_providers.dart  topic_card.dart  topic_detail_dialog.dart
   │            topic_form_dialog.dart  extend_topic_dialog.dart
   ├─ grading/
   │  ├─ data/  grade.dart  grade_repository.dart  api_grade_repository.dart  mock_grade_repository.dart
   │  └─ ui/    grade_providers.dart  grade_detail_dialog.dart  grade_form_dialog.dart
   ├─ council/
   │  ├─ data/  council.dart  council_repository.dart  api_council_repository.dart  mock_council_repository.dart
   │  └─ ui/    council_providers.dart  council_card.dart  council_form_dialog.dart  council_detail_dialog.dart
   ├─ stats/
   │  ├─ data/  topic_stats.dart  stats_repository.dart  api_stats_repository.dart  mock_stats_repository.dart
   │  └─ ui/    stats_providers.dart
   ├─ user/                    # sinh viên + giảng viên + hồ sơ
   │  ├─ data/  student.dart  teacher.dart  student_repository.dart  teacher_repository.dart
   │  │         api_student_repository.dart  api_teacher_repository.dart
   │  │         mock_student_repository.dart  mock_teacher_repository.dart
   │  └─ ui/    user_providers.dart  profile_panel.dart  student_form_dialog.dart  teacher_form_dialog.dart
   ├─ common/                  intro_page.dart  loading_page.dart  error_page.dart
   │
   │ ── MÀN HÌNH THEO VAI TRÒ (chỉ chứa *_page.dart; chỉ router import) ──
   ├─ student/   topic_register_page.dart  grade_lookup_page.dart
   ├─ teacher/   active_topics_page.dart   completed_topics_page.dart
   ├─ manager/   topic_review_page.dart    council_page.dart   stats_page.dart
   └─ admin/     student_manage_page.dart  teacher_manage_page.dart

test/   core/(paging_test, topic_status_test, api_error_test)  app/(router_redirect_test)
        features/(visible_topics_test, mock_repositories_test)
docs/DECISIONS.md
```

### Quy tắc phụ thuộc (không đảo chiều)
```
student/ teacher/ manager/ admin/   ──►  domain features (data + ui)  ──►  shared  ──►  core
app/router  ──►  mọi page, shared/layout, core/auth
```
- Thư mục vai trò (`student/ teacher/ manager/ admin/`) là **lớp trên cùng**: chỉ `app/router` import chúng; domain features **không** import chúng.
- Domain feature **không import `ui/` của domain khác**; cần dữ liệu của nhau thì chỉ import `data/` (model/repository).
- `core/` không import `app/`, `shared/`, `features/`. `shared/` không import `features/`.

---

## 7. Tham chiếu nghiệp vụ

### 7.1 Vai trò — `core/constants/user_role.dart`
`UserRole { student('SINH_VIEN','Sinh viên'), teacher('GIANG_VIEN','Giảng viên'), manager('QUAN_LY','Quản lý'), admin('ADMIN','Admin') }` — có `apiCode`, `label`, `fromApi()`.

### 7.2 Trạng thái đề tài — `core/constants/topic_status.dart`

| Giá trị enum | `apiCode` | Nhãn | `canEdit` | `isFinal` |
|---|---|---|---|---|
| `draft` | `MOI_TAO` | Mới tạo | ✓ | – |
| `pending` | `CHO_DUYET` | Chờ duyệt | ✓ | – |
| `approved` | `DA_DUYET` | Đã duyệt | – | – |
| `inProgress` | `DANG_THUC_HIEN` | Đang thực hiện | – | – |
| `extended` | `GIA_HAN` | Gia hạn | – | – |
| `completed` | `HOAN_THANH` | Hoàn thành | – | ✓ |
| `cancelled` | `DA_HUY` | Đã hủy | – | ✓ |

Hành động Quản lý (`enum TopicAction { approve, cancel, extend }`), hằng số `allowedActions` — UI **chỉ đọc** bảng này:
`pending` → {approve, cancel} · `inProgress` → {extend, cancel} · còn lại → chỉ xem.

### 7.3 Route & quyền

| Path (hằng số `Paths.`) | Page | Vai trò |
|---|---|---|
| `/intro` `intro`, `/login` `login` | IntroPage, LoginPage | công khai |
| `/student/topics` `studentTopics` | TopicRegisterPage | student |
| `/student/grades` `studentGrades` | GradeLookupPage | student |
| `/teacher/active` `teacherActive` | ActiveTopicsPage | teacher |
| `/teacher/completed` `teacherCompleted` | CompletedTopicsPage | teacher |
| `/manager/topics` `managerTopics` | TopicReviewPage | manager |
| `/manager/councils` `managerCouncils` | CouncilPage | manager |
| `/manager/stats` `managerStats` | StatsPage | manager |
| `/admin/students` `adminStudents` | StudentManagePage | admin |
| `/admin/teachers` `adminTeachers` | TeacherManagePage | admin |
| `/403` `forbidden` | ErrorPage.forbidden | tất cả |

Redirect (đặt đúng trong `app_router.dart`):
1. Chưa đăng nhập & không ở `/intro`,`/login` → `/login`.
2. Đã đăng nhập & ở `/intro`,`/login` → `homeOf(activeRole)`.
3. Path có tiền tố `/student/`,`/teacher/`,`/manager/`,`/admin/` mà khác `activeRole` → `/403`.
4. Path không tồn tại → `ErrorPage.notFound`.

### 7.4 Menu sidebar

| Vai trò | Tiêu đề cạnh LOGO | Mục | Cuối |
|---|---|---|---|
| student | `NCKH` (tên web) | Đăng ký đề tài · Tra cứu điểm | Đăng xuất |
| teacher | `Giảng viên` | Công việc · Hoàn thành | Đăng xuất |
| manager | `Quản lý` | Danh sách đề tài · Hội đồng chấm · Thống kê | Đăng xuất |
| admin | `Admin` | Sinh viên · Giảng viên | Đăng xuất |

TopBar: trái **"Trường Đại học Quy Nhơn"**; phải: chuông 🔔 (chỉ icon) · tên user · **avatar tròn** (bấm → `SidePanel` hồ sơ; chỉ student có dữ liệu hồ sơ đầy đủ và nút sửa, vai trò khác chỉ hiện tên + vai trò).

---

## 8. Quy tắc hình ảnh (bắt buộc)

| Spec | Hiện thực |
|---|---|
| student/teacher/manager: nền trắng, sidebar xanh đen, chữ tương phản | `AppTheme.of(role)` mặc định |
| admin: nền cam nhạt, chữ đen | `AppTheme.of(UserRole.admin)` |
| HỦY/XÓA luôn đỏ | `AppButton(kind: danger)` → `AppTokens.danger` |
| LOGO lục giác | `HexagonLogo` (CustomPainter 6 đỉnh) |
| Avatar luôn tròn | `UserAvatar` = `CircleAvatar` |
| Body 16–18 · Input ≥16 · H1 32–40 · H2 24–28 · H3 18–20 · Caption 12–14 · line-height 1.4–1.6 | `AppTokens.textTheme` |
| Đoạn văn dài 50–75 ký tự/dòng (~600–700px) | `ConstrainedBox(maxWidth: AppTokens.readableWidth)` |
| Card **chỉ bo trái-trên & phải-dưới**, viền mảnh, không bóng nặng, vạch màu mỏng theo trạng thái, chân thẻ phân tách, chữ gọn thẳng hàng, không icon gradient | `AppCard` |
| Thẻ đề tài = 1/4 chiều ngang desktop | `CardGrid`: ≥1100px → 4 cột · ≥760 → 2 · còn lại 1 |
| Hồ sơ = sidebar phải 1/3 màn | `SidePanel` rộng `screenWidth / 3` (tối thiểu 360) |

---

## 9. Hợp đồng widget dùng chung (`shared/widgets`)

| Widget | Tham số chính | Ghi chú |
|---|---|---|
| `AppCard` | `child, footer?, statusColor?, onTap?` | Đặt trong ô có chiều cao xác định (CardGrid); dùng trong ListView thì bọc `SizedBox(height: …)` |
| `CardGrid<T>` | `items, itemBuilder, aspect=1.25` | Lưới responsive 4/2/1 |
| `AppButton` | `label, onPressed, kind` (`primary/ghost/danger`) | |
| `StatusBadge` | `TopicStatus` | Nhãn + màu |
| `SearchField` | `hint, onChanged` | |
| `FormDialog` | `title, child, onSubmit, submitText='Lưu'` | Có "Hủy bỏ"; `Form` validate trước `onSubmit`; `onSubmit` ném `ApiError` → toast lỗi, **không đóng** dialog |
| `showConfirmDialog` | `(context, message, {danger=false}) → Future<bool>` | |
| `showSidePanel` | `(context, child)` | Trượt từ phải, nền mờ, nút ✕ |
| `PagerBar` | `total, page, onChanged` | Dùng `pageSize`; ẩn khi `total <= pageSize` |
| `ListRow` | `cells, onView?, onEdit?, onDelete?` | Nút Xóa màu đỏ |
| `SelectApply<T>` | `label, options, labelOf, onApply` | Dropdown + nút **APPLY**; chỉ gọi `onApply` khi đã chọn |
| `PieChartBox` | `List<PieSlice(label, value, color)>` | `fl_chart` + chú thích |
| `AppToast` | `success(ctx, msg)`, `error(ctx, msg)` | |
| `LoadingView / EmptyView / ErrorView` | `ErrorView(message, onRetry)` | |

---

## 10. Dữ liệu

### 10.1 Mẫu repository (áp dụng cho **mọi** repository)

```dart
// features/topic/data/topic_repository.dart
abstract class TopicRepository {
  Future<List<Topic>> list({TopicStatus? status});                                  // GET  /detai
  Future<void> create({required String title, required String description});        // POST /detai
  Future<void> update(String id, {required String title, required String description}); // PUT /detai/{id}
  Future<void> register(String topicId);                                            // POST /detai/dang-ky
  Future<void> approve(String id);                                                  // POST /detai/{id}/duyet
  Future<void> cancel(String id, {required String reason});                         // POST /detai/{id}/huy
  Future<void> extend(String id, {required DateTime newDeadline});                  // POST /detai/{id}/gia-han
}

final topicRepositoryProvider = Provider<TopicRepository>((ref) =>
    Env.useMock ? MockTopicRepository() : ApiTopicRepository(ref.watch(dioProvider)));
```
- `ApiTopicRepository`: Dio + hàm riêng `_guard()` bắt `DioException` → ném `ApiError`.
- `MockTopicRepository`: giữ state trong bộ nhớ (đăng ký xong danh sách đổi thật), `await Future.delayed(300ms)`, **mô phỏng lỗi nghiệp vụ** (SV đã có đề tài khác → `ApiError(409, …)`). Dữ liệu từ `core/mock/seed_data.dart`.

### 10.2 Endpoint sử dụng (tiền tố `/api/v1`)

| Nhóm | Endpoint | Dùng ở |
|---|---|---|
| Auth | `POST /auth/login` | LoginPage |
| Sinh viên | `GET /sinhvien` · `GET /sinhvien/{id}` · `POST /sinhvien` · `PUT /sinhvien/{id}` · `DELETE /sinhvien/{id}` | Admin, hồ sơ |
| Giảng viên | `GET /giangvien` (+ D9) | Admin, hội đồng |
| Đề tài | `GET /detai` · `POST /detai` · `PUT /detai/{id}` · `POST /detai/dang-ky` · `POST /detai/{id}/duyet\|huy\|gia-han` | student, teacher, manager |
| Hội đồng | `GET /hoi-dong` · `POST /hoi-dong` · `POST /hoi-dong/{id}/phan-cong` · `POST /hoi-dong/{id}/gan-de-tai` | manager |
| Điểm | `GET /diem?maDeTai=` · `GET /diem/sinh-vien/{id}` · `POST /diem` · `PUT /diem/{id}` | student, teacher |
| Thống kê | `GET /thong-ke/detai` · `GET /thong-ke/xuat?dinhDang=excel` | manager |
| Tài liệu | `GET /tai-lieu?maDeTai=` | teacher (link tải) |

Mã HTTP: 200/201 OK · 400 dữ liệu sai · 401 hết phiên (interceptor tự logout) · 403 không quyền · 404 · 409 xung đột trạng thái/trùng.

### 10.3 Model (tên field Anh) và khóa JSON backend

| Model (file) | Field Dart ← khóa JSON |
|---|---|
| `User` (`core/auth/user.dart`) | `name ← name` · `role ← role` · `studentId ← maSv` · `teacherId ← maGv` · `positions ← chucVu` · getter `hasMultiRoles` |
| `Topic` | `id ← maDeTai` · `title ← tenDeTai` · `authorName ← sinhVienTao` · `description ← moTa` · `status ← trangThai` · `supervisor ← gvhd` (Teacher?) · `memberNames ← thanhVien` · `phase ← giaiDoan` · `documents ← taiLieu` (`TopicDocument{name,url}`) · `isMine ← laCuaToi` · `gradingDeadline ← hanChamDiem` |
| `Teacher` | `id ← maGv` · `fullName ← hoTen` · `degree ← hocVi` · `faculty ← khoa` · `email ← email` · `positions ← chucVu` |
| `Student` | `id ← maSv` · `fullName ← hoTen` · `birthDate ← ngaySinh` · `major ← chuyenNganh` · `gpa ← gpa` · `status ← trangThai` (`StudentStatus.active/suspended`) |
| `Grade` | `topicId ← maDeTai` · `topicTitle ← tenDeTai` · `average ← diemTrungBinh` · `reportTerm ← kyBaoCao` · `comment ← nhanXet` · `scores ← thanhVien` (`MemberScore{name, studentId, score}`) |
| `Council` | `id ← maHoiDong` · `name ← ten` · `type ← loai` (`CouncilType.outline/defense`) · `createdOn ← ngayLap` · `members ← thanhVien` (`CouncilMember{teacherId, name, role}`, `CouncilRole.chair/secretary/member/reviewer`) · `topicIds ← deTai` |
| `TopicStats` | `cancelled ← huy` · `approved ← duyet` · `late ← tre` |

Mọi `fromJson` an toàn với `null`. Ví dụ:
```dart
factory Topic.fromJson(Map<String, dynamic> json) => Topic(
      id: json['maDeTai'] as String? ?? '',
      title: json['tenDeTai'] as String? ?? '',
      authorName: json['sinhVienTao'] as String? ?? '',
      description: json['moTa'] as String? ?? '',
      status: TopicStatus.fromApi(json['trangThai'] as String?),
      supervisor: json['gvhd'] == null ? null : Teacher.fromJson(json['gvhd']),
      isMine: json['laCuaToi'] == true,
      gradingDeadline: DateTime.tryParse(json['hanChamDiem'] as String? ?? ''),
      // memberNames, phase, documents: tương tự
    );
```

### 10.4 Seed & tài khoản mock (`core/mock/seed_data.dart`)

| Tài khoản | Mật khẩu | Kết quả |
|---|---|---|
| `sv001` | `123456` | student (có đề tài `pending` của mình) |
| `gv001` | `123456` | teacher thuần |
| `gv002` | `123456` | teacher + chức vụ manager → hiện RolePicker |
| `admin` | `admin123` | admin |

Seed tối thiểu: **25 sinh viên** (trộn active/suspended) · **22 giảng viên** (4 người có chức vụ manager) · **12 đề tài** phủ **đủ 7 trạng thái**, ≥1 đề tài `isMine` ở `pending` · **3 hội đồng** · điểm cho ≥3 đề tài `completed` · stats `{cancelled: 3, approved: 8, late: 2}`. Sai tài khoản → `ApiError(401, 'Sai tên đăng nhập hoặc mật khẩu')`.

---

## 11. Đặc tả màn hình (kèm tiêu chí chấp nhận **[A]**, kiểm tra được khi chạy `USE_MOCK=true`)

### 11.1 Chung

**LoginPage `/login`** — tên đăng nhập, mật khẩu, nút Đăng nhập, logo lục giác. Gọi `authRepository.login`. Nếu `user.hasMultiRoles` → `RolePicker` (2 thẻ lớn "Giảng viên" / "Quản lý").
- [A] Sai mật khẩu → toast lỗi, ở lại trang. [A] `gv002` thấy RolePicker; `sv001`/`admin` vào thẳng trang chủ vai trò.

**IntroPage `/intro`** — giới thiệu ngắn + nút Đăng nhập. **LoadingPage** — logo + spinner. **ErrorPage** — biến thể `forbidden` (403) / `notFound` (404) + nút "Về trang chủ".

### 11.2 Sinh viên

**TopicRegisterPage `/student/topics`**
```
[ 🔍 Tìm đề tài… ]                                [ + Đề xuất đề tài ]
┌thẻ┐ ┌thẻ┐ ┌thẻ┐ ┌thẻ┐    ← 4 thẻ / hàng (≥1100px)
```
- `TopicCard` chỉ hiện **thông tin public**: tên · "Tạo bởi: …" · nội dung nghiên cứu (cắt 4 dòng) · nút **Xem chi tiết**.
- `TopicDetailDialog`: tên · SV tạo · GV hướng dẫn (**học vị + họ tên + email**) · mô tả · nút **Đăng ký**.
- Đề tài `isMine` & `pending`: nhãn **PRIVATE** + nút **Chỉnh sửa** (mở `TopicFormDialog(topic: t)`: tên, mô tả). Nút "Đề xuất" mở `TopicFormDialog()` (tạo mới).
- [A] Tìm kiếm lọc theo tên. [A] Đề tài `pending` của người khác **không** xuất hiện. [A] Đăng ký thành công → toast + tải lại; SV đã có đề tài → toast lỗi 409. [A] Nút Chỉnh sửa **chỉ** hiện khi `isMine && status == pending`.

**GradeLookupPage `/student/grades`** — `SearchField` + `CardGrid` đề tài **đã chấm**; điểm trung bình **nổi bật ở phía đối diện tên đề tài** (cỡ lớn, đậm). Bấm thẻ → `GradeDetailDialog`: thành viên + điểm từng người · nhận xét · kỳ báo cáo.
- [A] Tìm kiếm hoạt động. [A] Dialog đủ 3 nhóm thông tin.

**Hồ sơ (`ProfilePanel` trong `SidePanel`)** — bấm avatar: MSV · Họ tên · Ngày sinh · Chuyên ngành · GPA + nút **Chỉnh sửa** → `FormDialog` **chỉ** Họ tên, Chuyên ngành (D13).
- [A] Panel ~1/3 chiều ngang bên phải; lưu xong panel cập nhật.

### 11.3 Giảng viên

**ActiveTopicsPage `/teacher/active`** — `CardGrid` đề tài đang hướng dẫn (`TopicCard`, không nút sửa). Bấm → dialog: tên · tên GV · SV tham gia · giai đoạn · tài liệu (link mở bằng `url_launcher`).
**CompletedTopicsPage `/teacher/completed`** — thẻ đề tài đã xong + dòng **"Hạn chấm: dd/MM/yyyy"** (D15). Bấm thẻ → `GradeFormDialog`: điểm (0–10, validate), nhận xét (bắt buộc) → `POST /diem`.
- [A] Điểm ngoài 0–10 → lỗi ngay trên form. [A] Lưu thành công → toast + đóng dialog.

### 11.4 Quản lý

**TopicReviewPage `/manager/topics`** — như màn SV nhưng hiện **toàn bộ** đề tài (không áp D6). Nút trong dialog theo `allowedActions[status]`:
- **PHÊ DUYỆT** → `approve`. **HỦY ĐỀ TÀI** (đỏ) → hỏi **lý do bắt buộc** + `ConfirmDialog` → `cancel`. **GIA HẠN** → `ExtendTopicDialog` (D14).
- [A] `pending` có Phê duyệt + Hủy; `inProgress` có Gia hạn + Hủy; `completed`/`cancelled` không có nút hành động. [A] Hủy không nhập lý do → không gửi được.

**CouncilPage `/manager/councils`** — nút **+ Thêm nhóm** (góc phải) → `CouncilFormDialog` (tên, loại Đề cương/Bảo vệ, ngày lập). Danh sách `CouncilCard`: tên · ngày thành lập · tên thành viên. Bấm card → `CouncilDetailDialog`:
- `SelectApply` chọn **giảng viên** (+ chọn vai trò) → **APPLY** → `phan-cong`.
- `SelectApply` chọn **đề tài** (chỉ `approved`) → **APPLY** → `gan-de-tai`.
- [A] Sau APPLY thành viên/đề tài hiện ngay trong dialog. [A] Giảng viên đã trong hội đồng không xuất hiện lại trong danh sách chọn.

**StatsPage `/manager/stats`** — `PieChartBox` 3 phần **HỦY – DUYỆT – TRỄ** + nút **Xuất EXCEL** (D11).
- [A] Biểu đồ khớp số liệu. [A] Bấm Xuất EXCEL → mock tạo file `.xlsx` mẫu; thật tải về.

### 11.5 Admin (theme cam nhạt)

**StudentManagePage `/admin/students`**
```
[Tổng: N] [HOẠT ĐỘNG: n] [ĐÌNH CHỈ: n]                [ + Thêm sinh viên ]
Mã SV │ Họ tên │ Chuyên ngành │ GPA │ Trạng thái │ [Xem][Sửa][Xóa-đỏ]   (20 dòng)
                                      ◀ 1  2 ▶
```
- `StudentFormDialog` (Sửa): MSV (**khóa**) · Họ tên · Chuyên ngành · GPA (**khóa**) · Trạng thái (`ĐÌNH CHỈ`/`HOẠT ĐỘNG`). Thêm: nhập đủ. Xem: chỉ đọc. Xóa → `ConfirmDialog(danger)`.
- [A] 25 bản ghi → trang 1 có **20**, trang 2 có **5**. [A] Ba số tổng/hoạt động/đình chỉ đúng và cập nhật sau khi sửa trạng thái.

**TeacherManagePage `/admin/teachers`** — nút **+ Thêm giảng viên** (góc phải). **2 tab full màn**: `Giảng viên` | `Quản lý` (lọc theo `positions`; người có cả hai xuất hiện ở cả hai tab). Mỗi tab: 20 dòng/trang (Mã GV · Học vị · Khoa · Email · [Xem][Sửa][Xóa]).
- `TeacherFormDialog` (Sửa): Mã GV (**khóa**) · Họ tên · Khoa · Học vị · **Chức vụ** = 2 checkbox `QUẢN LÝ`, `GIẢNG VIÊN` (**bắt buộc ≥ 1**).
- [A] Đổi tab giữ bố cục full màn. [A] Bỏ chọn cả hai chức vụ → không lưu, báo lỗi.

---

## 12. Code mẫu tham chiếu (giữ nguyên hành vi; được tinh chỉnh cú pháp)

### 12.1 `app/env.dart`
```dart
class Env {
  static const apiBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8080');
  static const useMock = bool.fromEnvironment('USE_MOCK', defaultValue: true);
}
```

### 12.2 `core/utils/paging.dart`
```dart
const pageSize = 20;

/// Trả về các phần tử của trang [page] (đếm từ 1).
List<T> pageOf<T>(List<T> items, int page) =>
    items.skip((page - 1) * pageSize).take(pageSize).toList();
```

### 12.3 `core/constants/user_role.dart` + `topic_status.dart`
```dart
enum UserRole {
  student('SINH_VIEN', 'Sinh viên'),
  teacher('GIANG_VIEN', 'Giảng viên'),
  manager('QUAN_LY', 'Quản lý'),
  admin('ADMIN', 'Admin');

  const UserRole(this.apiCode, this.label);
  final String apiCode;
  final String label;

  static UserRole fromApi(String? code) =>
      values.firstWhere((r) => r.apiCode == code, orElse: () => student);
}

enum TopicStatus {
  draft('MOI_TAO', 'Mới tạo', canEdit: true),
  pending('CHO_DUYET', 'Chờ duyệt', canEdit: true),
  approved('DA_DUYET', 'Đã duyệt'),
  inProgress('DANG_THUC_HIEN', 'Đang thực hiện'),
  extended('GIA_HAN', 'Gia hạn'),
  completed('HOAN_THANH', 'Hoàn thành', isFinal: true),
  cancelled('DA_HUY', 'Đã hủy', isFinal: true);

  const TopicStatus(this.apiCode, this.label, {this.canEdit = false, this.isFinal = false});
  final String apiCode;
  final String label;
  final bool canEdit;
  final bool isFinal;

  static TopicStatus fromApi(String? code) =>
      values.firstWhere((s) => s.apiCode == code, orElse: () => draft);
}

enum TopicAction { approve, cancel, extend }

const allowedActions = <TopicStatus, List<TopicAction>>{
  TopicStatus.pending: [TopicAction.approve, TopicAction.cancel],
  TopicStatus.inProgress: [TopicAction.extend, TopicAction.cancel],
};
```

### 12.4 `app/theme/app_tokens.dart`
```dart
import 'package:flutter/material.dart';
import '../../core/constants/topic_status.dart';

class AppTokens {
  // ---- MÀU (giá trị tạm — chỉ sửa ở đây khi chỉnh giao diện) ----
  static const bg = Color(0xFFFFFFFF);
  static const text = Color(0xFF111111);
  static const sidebar = Color(0xFF0F2A3D);        // xanh đen
  static const sidebarText = Color(0xFFFFFFFF);
  static const border = Color(0xFFD0D5DD);
  static const danger = Color(0xFFD92D20);         // HỦY / XÓA: luôn đỏ
  static const adminBg = Color(0xFFFFE8CC);        // cam nhạt
  static const adminSidebar = Color(0xFFFFD8A8);
  static const adminText = Color(0xFF000000);

  static Color statusColor(TopicStatus s) => switch (s) {
        TopicStatus.pending => const Color(0xFFF79009),
        TopicStatus.approved => const Color(0xFF12B76A),
        TopicStatus.inProgress => const Color(0xFF2E90FA),
        TopicStatus.extended => const Color(0xFF7A5AF8),
        TopicStatus.completed => const Color(0xFF0F2A3D),
        TopicStatus.cancelled => danger,
        TopicStatus.draft => border,
      };

  // ---- HÌNH KHỐI ----
  static const cardRadius = Radius.circular(12);
  static const readableWidth = 650.0;
  static const sidebarWidth = 260.0;

  // ---- CHỮ theo spec ----
  static const fontFamily = 'Roboto';              // hỗ trợ tiếng Việt
  static const textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 36, height: 1.4, fontWeight: FontWeight.w700), // H1
    headlineMedium: TextStyle(fontSize: 26, height: 1.4, fontWeight: FontWeight.w600), // H2
    titleLarge: TextStyle(fontSize: 19, height: 1.4, fontWeight: FontWeight.w600),     // H3
    bodyLarge: TextStyle(fontSize: 17, height: 1.5),                                   // Body
    bodyMedium: TextStyle(fontSize: 16, height: 1.5),
    bodySmall: TextStyle(fontSize: 13, height: 1.4),                                   // Caption
  );
}
```

### 12.5 `app/theme/app_theme.dart`
```dart
import 'package:flutter/material.dart';
import '../../core/constants/user_role.dart';
import 'app_tokens.dart';

class AppTheme {
  static ThemeData of(UserRole? role) => role == UserRole.admin
      ? _build(AppTokens.adminBg, AppTokens.adminText)
      : _build(AppTokens.bg, AppTokens.text);

  static ThemeData _build(Color background, Color foreground) => ThemeData(
        useMaterial3: true,
        fontFamily: AppTokens.fontFamily,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(
            seedColor: AppTokens.sidebar, surface: background, onSurface: foreground),
        textTheme: AppTokens.textTheme.apply(bodyColor: foreground, displayColor: foreground),
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
        dividerTheme: const DividerThemeData(color: AppTokens.border, thickness: 1),
      );
}
```

### 12.6 `shared/widgets/app_card.dart`
```dart
import 'package:flutter/material.dart';
import '../../app/theme/app_tokens.dart';

/// Thẻ theo spec: chỉ bo trái-trên & phải-dưới, viền mảnh, không bóng,
/// vạch màu mỏng bên trái, chân thẻ có đường phân tách.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.footer, this.statusColor, this.onTap});
  final Widget child;
  final Widget? footer;
  final Color? statusColor;
  final VoidCallback? onTap;

  static const _radius = BorderRadius.only(
    topLeft: AppTokens.cardRadius,
    bottomRight: AppTokens.cardRadius,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTokens.border),
        borderRadius: _radius,
      ),
      child: ClipRRect(
        borderRadius: _radius,
        child: Stack(children: [
          Positioned.fill(
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Padding(padding: const EdgeInsets.all(16), child: child)),
                  if (footer != null) ...[
                    const Divider(height: 1),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: footer),
                  ],
                ]),
              ),
            ),
          ),
          Positioned(
              left: 0, top: 0, bottom: 0, width: 4,
              child: ColoredBox(color: statusColor ?? Colors.transparent)),
        ]),
      ),
    );
  }
}
```

### 12.7 `shared/widgets/card_grid.dart`
```dart
import 'package:flutter/material.dart';

class CardGrid<T> extends StatelessWidget {
  const CardGrid({super.key, required this.items, required this.itemBuilder, this.aspect = 1.25});
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final double aspect;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1100 ? 4 : constraints.maxWidth >= 760 ? 2 : 1;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: aspect),
          itemCount: items.length,
          itemBuilder: (context, index) => itemBuilder(context, items[index]),
        );
      });
}
```

### 12.8 `core/network/api_error.dart` + `api_response.dart`
```dart
import 'package:dio/dio.dart';

class ApiError implements Exception {
  ApiError(this.status, this.message);
  final int status;
  final String message;

  static const _messages = {
    0: 'Không kết nối được máy chủ. Vui lòng thử lại.',
    400: 'Dữ liệu không hợp lệ.',
    401: 'Phiên đăng nhập đã hết hạn.',
    403: 'Bạn không có quyền thực hiện thao tác này.',
    404: 'Không tìm thấy dữ liệu.',
    409: 'Dữ liệu đã thay đổi hoặc không còn phù hợp. Vui lòng tải lại.',
  };

  factory ApiError.from(DioException error) {
    final status = error.response?.statusCode ?? 0;
    final body = error.response?.data;
    final serverMessage = body is Map ? body['message'] as String? : null;
    return ApiError(status, serverMessage ?? _messages[status] ?? 'Đã xảy ra lỗi. Vui lòng thử lại.');
  }

  @override
  String toString() => message;
}

// api_response.dart — D1: chấp nhận cả có bọc và không bọc
dynamic unwrap(dynamic body) => body is Map && body.containsKey('data') ? body['data'] : body;

List<Map<String, dynamic>> unwrapList(dynamic body) =>
    (unwrap(body) as List? ?? const []).cast<Map<String, dynamic>>();
```

### 12.9 `core/network/dio_client.dart`
```dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/env.dart';
import '../auth/session.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: Env.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));
  dio.interceptors.add(AuthInterceptor(ref));
  return dio;
});

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.ref);
  final Ref ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = ref.read(sessionProvider)?.token;
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    if (error.response?.statusCode == 401) ref.read(sessionProvider.notifier).logout();
    handler.next(error);
  }
}
```
> `core/network` import `core/auth` (cùng tầng `core`) — hợp lệ.

### 12.10 `core/auth/user.dart` + `session.dart`
```dart
// user.dart
import '../constants/user_role.dart';

class User {
  const User({required this.name, required this.role, this.studentId, this.teacherId, this.positions = const []});
  final String name;
  final UserRole role;
  final String? studentId, teacherId;
  final List<UserRole> positions;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'] as String? ?? '',
        role: UserRole.fromApi(json['role'] as String?),
        studentId: json['maSv'] as String?,
        teacherId: json['maGv'] as String?,
        positions: (json['chucVu'] as List? ?? const [])
            .map((code) => UserRole.fromApi('$code'))
            .toList(),
      );

  /// Giảng viên kiêm quản lý → phải chọn chức vụ khi đăng nhập.
  bool get hasMultiRoles => role == UserRole.teacher && positions.contains(UserRole.manager);
}

// session.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/user_role.dart';
import 'user.dart';

class Session {
  const Session({required this.token, required this.user, required this.activeRole});
  final String token;
  final User user;
  final UserRole activeRole;
  Session withRole(UserRole role) => Session(token: token, user: user, activeRole: role);
}

class SessionNotifier extends Notifier<Session?> {
  @override
  Session? build() => null;
  void login(String token, User user, UserRole role) =>
      state = Session(token: token, user: user, activeRole: role);
  void switchRole(UserRole role) => state = state?.withRole(role);
  void logout() => state = null;
}

final sessionProvider = NotifierProvider<SessionNotifier, Session?>(SessionNotifier.new);
```

### 12.11 `app/router/*`
```dart
// paths.dart
class Paths {
  static const intro = '/intro', login = '/login', forbidden = '/403';
  static const studentTopics = '/student/topics', studentGrades = '/student/grades';
  static const teacherActive = '/teacher/active', teacherCompleted = '/teacher/completed';
  static const managerTopics = '/manager/topics',
      managerCouncils = '/manager/councils',
      managerStats = '/manager/stats';
  static const adminStudents = '/admin/students', adminTeachers = '/admin/teachers';
}

// role_access.dart
UserRole? roleForPath(String location) {
  if (location.startsWith('/student/')) return UserRole.student;
  if (location.startsWith('/teacher/')) return UserRole.teacher;
  if (location.startsWith('/manager/')) return UserRole.manager;
  if (location.startsWith('/admin/')) return UserRole.admin;
  return null;
}

String homeOf(UserRole role) => switch (role) {
      UserRole.student => Paths.studentTopics,
      UserRole.teacher => Paths.teacherActive,
      UserRole.manager => Paths.managerTopics,
      UserRole.admin => Paths.adminStudents,
    };

// app_router.dart
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(sessionProvider, (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Paths.intro,
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final location = state.matchedLocation;
      final isPublic = location == Paths.intro || location == Paths.login;
      if (session == null) return isPublic ? null : Paths.login;
      if (isPublic) return homeOf(session.activeRole);
      final required = roleForPath(location);
      if (required != null && required != session.activeRole) return Paths.forbidden;
      return null;
    },
    routes: [
      GoRoute(path: Paths.intro, builder: (_, __) => const IntroPage()),
      GoRoute(path: Paths.login, builder: (_, __) => const LoginPage()),
      GoRoute(path: Paths.forbidden, builder: (_, __) => const ErrorPage.forbidden()),
      ShellRoute(
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(path: Paths.studentTopics, builder: (_, __) => const TopicRegisterPage()),
          GoRoute(path: Paths.studentGrades, builder: (_, __) => const GradeLookupPage()),
          // … đăng ký đủ các route ở §7.3
        ],
      ),
    ],
    errorBuilder: (_, __) => const ErrorPage.notFound(),
  );
});
```

### 12.12 `shared/layout/nav_items.dart`
```dart
class NavItem {
  const NavItem(this.label, this.path, this.icon);
  final String label, path;
  final IconData icon;
}

const navItemsByRole = <UserRole, List<NavItem>>{
  UserRole.student: [
    NavItem('Đăng ký đề tài', Paths.studentTopics, Icons.app_registration),
    NavItem('Tra cứu điểm', Paths.studentGrades, Icons.grade),
  ],
  UserRole.teacher: [
    NavItem('Công việc', Paths.teacherActive, Icons.work_outline),
    NavItem('Hoàn thành', Paths.teacherCompleted, Icons.task_alt),
  ],
  UserRole.manager: [
    NavItem('Danh sách đề tài', Paths.managerTopics, Icons.list_alt),
    NavItem('Hội đồng chấm', Paths.managerCouncils, Icons.groups),
    NavItem('Thống kê', Paths.managerStats, Icons.pie_chart_outline),
  ],
  UserRole.admin: [
    NavItem('Sinh viên', Paths.adminStudents, Icons.school),
    NavItem('Giảng viên', Paths.adminTeachers, Icons.person_pin),
  ],
};
```
> `shared/layout` import `app/router/paths.dart` (hằng số đường dẫn) — ngoại lệ được phép duy nhất của `shared` đối với `app`.

### 12.13 `shared/layout/app_shell.dart` + `top_bar.dart`
```dart
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    if (session == null) return const SizedBox.shrink();          // đang redirect
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final sidebar = Sidebar(role: session.activeRole);

    return Scaffold(
      drawer: isWide ? null : Drawer(child: sidebar),
      body: Row(children: [
        if (isWide) SizedBox(width: AppTokens.sidebarWidth, child: sidebar),
        Expanded(
          child: Column(children: [
            TopBar(session: session, showMenu: !isWide),
            const Divider(height: 1),
            Expanded(child: child),
          ]),
        ),
      ]),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.session, required this.showMenu});
  final Session session;
  final bool showMenu;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            if (showMenu)
              Builder(                                              // context nằm dưới Scaffold
                  builder: (inner) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(inner).openDrawer())),
            Text('Trường Đại học Quy Nhơn', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
            const SizedBox(width: 8),
            Text(session.user.name),
            const SizedBox(width: 8),
            InkWell(
              customBorder: const CircleBorder(),
              onTap: () => showSidePanel(context, ProfilePanel(session: session)),
              child: UserAvatar(name: session.user.name),
            ),
          ]),
        ),
      );
}
```
`Sidebar` (`sidebar.dart`): nền `AppTokens.sidebar` (admin: `adminSidebar`), `HexagonLogo` + tiêu đề (§7.4), danh sách `navItemsByRole[role]`, mục đang chọn tô nền khác (so `GoRouterState.of(context).matchedLocation`), nút **Đăng xuất** dưới cùng → `sessionProvider.notifier.logout()`.

### 12.14 `features/topic/ui/topic_detail_dialog.dart`
```dart
class DialogButton {
  const DialogButton(this.label, this.onPressed, {this.kind = AppButtonKind.primary});
  final String label;
  final VoidCallback onPressed;
  final AppButtonKind kind;
}

Future<void> showTopicDetailDialog(BuildContext context, Topic topic,
        {List<DialogButton> buttons = const []}) =>
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(topic.title),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppTokens.readableWidth),
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Sinh viên tạo: ${topic.authorName}'),
              if (topic.supervisor != null)
                Text('Giảng viên: ${topic.supervisor!.degree} ${topic.supervisor!.fullName}'
                    ' — ${topic.supervisor!.email}'),
              const SizedBox(height: 12),
              Text(topic.description),
            ]),
          ),
        ),
        actions: [
          AppButton('Đóng', kind: AppButtonKind.ghost, onPressed: () => Navigator.pop(dialogContext)),
          for (final button in buttons)
            AppButton(button.label, kind: button.kind, onPressed: () {
              Navigator.pop(dialogContext);   // đóng dialog trước, rồi chạy hành động
              button.onPressed();
            }),
        ],
      ),
    );
```

### 12.15 `features/topic/ui/topic_providers.dart`
```dart
final topicsProvider = FutureProvider.autoDispose<List<Topic>>(
    (ref) => ref.watch(topicRepositoryProvider).list());

final topicSearchProvider = StateProvider.autoDispose<String>((_) => '');

/// D6: ẩn đề tài chờ duyệt của người khác; lọc theo ô tìm kiếm.
final visibleTopicsProvider = Provider.autoDispose<AsyncValue<List<Topic>>>((ref) {
  final keyword = ref.watch(topicSearchProvider).toLowerCase();
  return ref.watch(topicsProvider).whenData((topics) => topics
      .where((topic) => topic.status != TopicStatus.pending || topic.isMine)
      .where((topic) => topic.title.toLowerCase().contains(keyword))
      .toList());
});
```

### 12.16 `features/student/topic_register_page.dart`
```dart
class TopicRegisterPage extends ConsumerWidget {
  const TopicRegisterPage({super.key});

  Future<void> _register(BuildContext context, WidgetRef ref, Topic topic) async {
    try {
      await ref.read(topicRepositoryProvider).register(topic.id);
      ref.invalidate(topicsProvider);
      if (context.mounted) AppToast.success(context, 'Đăng ký thành công');
    } on ApiError catch (error) {
      if (context.mounted) AppToast.error(context, error.message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(visibleTopicsProvider);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Expanded(
              child: SearchField(
                  hint: 'Tìm đề tài…',
                  onChanged: (value) => ref.read(topicSearchProvider.notifier).state = value)),
          const SizedBox(width: 12),
          AppButton('+ Đề xuất đề tài', onPressed: () => showTopicFormDialog(context, ref)),
        ]),
      ),
      Expanded(
        child: topics.when(
          loading: () => const LoadingView(),
          error: (error, _) =>
              ErrorView(message: '$error', onRetry: () => ref.invalidate(topicsProvider)),
          data: (items) => items.isEmpty
              ? const EmptyView('Chưa có đề tài.')
              : CardGrid<Topic>(
                  items: items,
                  itemBuilder: (_, topic) => TopicCard(
                    topic: topic,
                    onView: () => showTopicDetailDialog(context, topic, buttons: [
                      DialogButton('Đăng ký', () => _register(context, ref, topic)),
                    ]),
                    onEdit: topic.isMine
                        ? () => showTopicFormDialog(context, ref, topic: topic)
                        : null,
                  ),
                ),
        ),
      ),
    ]);
  }
}
```
`TopicCard` hiện nút Chỉnh sửa + nhãn PRIVATE khi `onEdit != null && topic.status == TopicStatus.pending`.

### 12.17 Xuất Excel — `api_stats_repository.dart`
```dart
@override
Future<void> exportExcel() => _guard(() async {
      final response = await _dio.get<List<int>>('/api/v1/thong-ke/xuat',
          queryParameters: {'dinhDang': 'excel'},
          options: Options(responseType: ResponseType.bytes));
      await FileSaver.instance.saveFile(
          name: 'bao-cao-de-tai',
          bytes: Uint8List.fromList(response.data!),
          ext: 'xlsx',
          mimeType: MimeType.microsoftExcel);
    });
```

---

## 13. Kế hoạch triển khai (tuần tự)

### P0 — Khởi tạo
Tạo project, cài package (§5), `analysis_options.yaml` với `flutter_lints`, tạo cây thư mục rỗng (§6), `docs/DECISIONS.md`, `README.md` (cách chạy mock/thật).
**Done khi:** `flutter run -d chrome` chạy được; `flutter analyze` sạch.

### P1 — Nền tảng
`Env`, `AppTokens`, `AppTheme`, `UserRole`, `TopicStatus`, `ApiError`, `api_response`, `dioProvider`, `User`/`Session`, `paging`, `formatters`, `validators`. Widget nền: `AppCard`, `CardGrid`, `AppButton`, `HexagonLogo`, `UserAvatar`, `StatusBadge`, `AppToast`, `state_views`, `SearchField`.
**Done khi:** có 1 màn demo tạm hiển thị thẻ đủ 7 trạng thái (đúng bo 2 góc, vạch màu), 3 loại nút, logo, avatar; test `paging`, `topic_status`, `api_error` pass.

### P2 — Đăng nhập, router, khung
`seed_data.dart`, `auth` (repository 3 bản, `LoginPage`, `RolePicker`), `common` (3 page), router (`paths`, `role_access`, `app_router`), `shared/layout`, 9 page vai trò là **placeholder** (chỉ hiện tên trang).
**Done khi:** [A] 4 tài khoản mock đúng luồng §11.1 · menu đúng vai trò · admin nền cam nhạt · gõ tay URL sai vai trò → 403 · đăng xuất về `/login` · `router_redirect_test` pass (4 quy tắc §7.3).

### P3 — Đề tài + Sinh viên
`topic` (model, repository 3 bản, providers, `TopicCard`, `TopicDetailDialog`, `TopicFormDialog`), `FormDialog`, `ConfirmDialog`, `TopicRegisterPage`.
**Done khi:** toàn bộ [A] của `TopicRegisterPage` đạt; `visible_topics_test` (lọc PRIVATE + tìm kiếm) pass.

### P4 — Hồ sơ + Tra cứu điểm
`user` (Student model + repository 3 bản, `ProfilePanel`), `SidePanel`, `grading` (model, repository 3 bản, `GradeDetailDialog`), `GradeLookupPage`.
**Done khi:** [A] của `GradeLookupPage` và Hồ sơ đạt.

### P5 — Quản lý
`TopicReviewPage` + `ExtendTopicDialog`, `council` (model, repository, card, 2 dialog), `SelectApply`, `stats` + `PieChartBox`, `CouncilPage`, `StatsPage`.
**Done khi:** toàn bộ [A] §11.4 đạt.

### P6 — Giảng viên
`ActiveTopicsPage`, `CompletedTopicsPage`, `GradeFormDialog`.
**Done khi:** [A] §11.3 đạt; chấm điểm mock xong thì SV liên quan thấy điểm ở Tra cứu điểm.

### P7 — Admin
Teacher model + repository 3 bản, `ListRow`, `PagerBar`, `StudentManagePage`, `TeacherManagePage`, `StudentFormDialog`, `TeacherFormDialog`.
**Done khi:** toàn bộ [A] §11.5 đạt (25 SV → 20 + 5).

### P8 — Hoàn thiện
Rà checklist §14; quét lại tên theo §3 (`grep` các viết tắt cấm: `sv`, `gv`, `ql`, `btn`, `tmp`); sửa hard-code màu; thêm `mock_repositories_test` (đăng ký 409, phân trang 25 bản ghi, hủy cần lý do). *(Tùy chọn)* lưu phiên bằng `shared_preferences` (D12).
**Done khi:** `dart format` / `flutter analyze` / `flutter test` sạch; `flutter build web` thành công.

---

## 14. Checklist nghiệm thu (Definition of Done)

**Giao diện theo spec**
- [ ] student/teacher/manager: nền trắng + sidebar xanh đen + chữ tương phản; admin: nền cam nhạt chữ đen
- [ ] HỦY/XÓA luôn đỏ + luôn qua ConfirmDialog · LOGO lục giác · avatar tròn
- [ ] Card: **chỉ bo 2 góc (trái-trên, phải-dưới)**, viền mảnh, không bóng nặng, vạch trạng thái mỏng, chân thẻ phân tách, không icon gradient
- [ ] Cỡ chữ đúng §8; đoạn văn dài ≤ ~650px
- [ ] Lưới đề tài 4 cột (≥1100px) · hồ sơ là SidePanel ~1/3 màn phải
- [ ] ≥900px sidebar cố định; <900px Drawer, không overflow

**Chức năng**
- [ ] 4 vai trò + RolePicker cho giảng viên kiêm quản lý
- [ ] Mọi [A] ở §11 đạt khi chạy `USE_MOCK=true`
- [ ] Phân quyền route đúng §7.3 (kể cả gõ tay URL)
- [ ] Mọi thao tác ghi có toast thành/bại; mọi màn có loading/error/empty
- [ ] Admin: 21+ bản ghi có phân trang 20/trang

**Chất lượng**
- [ ] Không có `dio.*` trong widget/page · không hard-code màu · đúng quy tắc phụ thuộc §6
- [ ] **Đúng quy ước đặt tên §3** (không viết tắt cấm, không vượt giới hạn độ dài, field model tiếng Anh, khóa JSON chỉ ở `fromJson`)
- [ ] `dart format`, `flutter analyze` (0 issue), `flutter test` (pass), `flutter build web` OK
- [ ] `docs/DECISIONS.md` ghi mọi quyết định ngoài §4

---

## 15. Ngoài phạm vi (KHÔNG làm ở giai đoạn này)

Màu sắc/hiệu ứng/animation cầu kỳ · chuông thông báo có logic (`/thong-bao`) · upload tài liệu (`/tai-lieu/upload`) · đổi/quên mật khẩu · đăng ký tài khoản · quản lý Khoa/Lớp · đa ngôn ngữ · dark mode · lưu phiên bền vững (trừ tùy chọn P8).
