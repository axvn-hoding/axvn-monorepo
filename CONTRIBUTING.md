# Hướng dẫn Đóng góp Mã nguồn — AXVN Holding

Cảm ơn bạn đã quan tâm đến việc đóng góp cho hệ sinh thái AXVN. Tài liệu này quy định quy trình bắt buộc dành cho **các thành viên Hội đồng Quản trị và Cổ đông** khi thực hiện commit mã nguồn vào các repository của tổ chức.

---

## ⚠️ Điều kiện Bắt buộc

Chỉ các thành viên sau đây mới có quyền commit trực tiếp lên nhánh `main`:

| Thành viên | Tỷ lệ | Email GitHub |
|---|---|---|
| Nhâm Quốc Huân | 30% | *(email cá nhân đã đăng ký GitHub)* |
| Vũ Hoàng Linh | 20% | *(email cá nhân đã đăng ký GitHub)* |
| Hoàng Xuân Biên | 20% | magnesi24vnd@gmail.com |
| Trần Đức Nhân | 20% | *(email cá nhân đã đăng ký GitHub)* |
| Nguyễn Thị Thu Hương | 10% | *(email cá nhân đã đăng ký GitHub)* |

---

## 🔐 Yêu cầu Ký số Commit (SSH / GPG Key)

Mọi commit phải được ký số bằng **SSH Key hoặc GPG Key cá nhân** đã đăng ký trên tài khoản GitHub. Đây là **bằng chứng pháp lý** về quyền tác giả và đóng góp trí tuệ.

### Cấu hình SSH Key để ký commit

```bash
# Tạo SSH key mới (nếu chưa có)
ssh-keygen -t ed25519 -C "email_cua_ban@domain.com"

# Thêm vào ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Cấu hình Git dùng SSH key để ký commit
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

### Cấu hình GPG Key (tùy chọn thay thế)

```bash
gpg --full-generate-key
git config --global user.signingkey <YOUR_GPG_KEY_ID>
git config --global commit.gpgsign true
```

---

## 📋 Quy trình Đóng góp

### Bước 1: Clone repository và cấu hình danh tính

```bash
git clone git@github.com:axvn-hoding/<ten-repository>.git
cd <ten-repository>

# Cấu hình đúng tên và email cá nhân (phải khớp với hồ sơ GitHub)
git config user.name "Tên Thành Viên"
git config user.email "email_ca_nhan@domain.com"
```

### Bước 2: Tạo nhánh làm việc

```bash
git checkout -b feat/<mo-ta-tinh-nang>
# Ví dụ: git checkout -b feat/vnkr-ui-atomic-components
```

### Bước 3: Commit với ký số

```bash
git add .
git commit -S -m "feat: <Mô tả đóng góp rõ ràng>"
# Cờ -S để ký commit bằng SSH/GPG key
```

### Bước 4: Push và tạo Pull Request

```bash
git push origin feat/<mo-ta-tinh-nang>
```

Sau đó tạo Pull Request trên GitHub và chờ ít nhất **2 thành viên HĐQT** phê duyệt trước khi merge vào `main`.

---

## 📝 Quy chuẩn Commit Message

Sử dụng chuẩn **Conventional Commits**:

| Tiền tố | Ý nghĩa |
|---|---|
| `feat:` | Tính năng mới |
| `fix:` | Sửa lỗi |
| `docs:` | Cập nhật tài liệu |
| `refactor:` | Tái cấu trúc code |
| `chore:` | Công việc bảo trì |
| `security:` | Cập nhật bảo mật |

---

## 🚫 Những điều không được làm

- Không commit trực tiếp lên `main` mà không qua Pull Request (ngoại trừ thành viên có quyền Maintainer).
- Không push code chưa ký số.
- Không thêm thư viện bên thứ ba mà không có sự đồng ý của ít nhất 2 thành viên HĐQT.
- Không tiết lộ bất kỳ thông tin nhạy cảm (API key, secret, private key) trong commit.

---

*© 2025 AXVN Holding. All Rights Reserved.*
