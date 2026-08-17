# Chính sách Bảo mật — AXVN Holding

## Phạm vi Bảo vệ

Tài liệu này áp dụng cho toàn bộ mã nguồn, tài sản kỹ thuật số và thông tin nhạy cảm thuộc các repository trong tổ chức **AXVN Holding** trên GitHub.

---

## 🔒 Nguyên tắc Bảo mật Cốt lõi

1. **Không bao giờ commit thông tin nhạy cảm** — API keys, private keys, mật khẩu, secret tokens tuyệt đối không được đưa vào mã nguồn. Sử dụng biến môi trường (`.env`) và đảm bảo `.env` đã có trong `.gitignore`.

2. **Ký số tất cả các commit** — Mọi commit phải được ký số bằng SSH Key hoặc GPG Key cá nhân để đảm bảo tính xác thực và không thể chối bỏ (non-repudiation).

3. **Kiểm soát quyền truy cập** — Chỉ thành viên Hội đồng Quản trị được cấp quyền `Maintainer` hoặc `Admin`. Cộng tác viên bên ngoài chỉ được cấp quyền `Write` vào các nhánh riêng biệt.

4. **Bảo vệ nhánh `main`** — Nhánh `main` phải được bảo vệ bằng Branch Protection Rules: yêu cầu Pull Request, ít nhất 2 reviewer phê duyệt, và bắt buộc kiểm tra CI/CD vượt qua.

---

## 🚨 Báo cáo Lỗ hổng Bảo mật

Nếu bạn phát hiện lỗ hổng bảo mật trong bất kỳ repository nào của AXVN Holding:

**KHÔNG tạo GitHub Issue công khai.**

Vui lòng báo cáo **riêng tư** qua:
- **Email bảo mật:** security@axvn.network
- **Tiêu đề email:** `[SECURITY] <tên repository> - <mô tả ngắn>`

Chúng tôi cam kết phản hồi trong vòng **48 giờ** và sẽ phối hợp để vá lỗi trước khi công bố.

---

## 🛡️ Phạm vi Bug Bounty (Nội bộ)

| Mức độ | Phần thưởng |
|---|---|
| Critical (RCE, SQLi, Private Key leak) | Được xem xét cấp thêm cổ phần |
| High (Authentication bypass, Data breach) | Khen thưởng bằng token VNKR |
| Medium (XSS, CSRF, Logic flaw) | Ghi nhận chính thức trong CODEOWNERS |
| Low (Misconfiguration, Info disclosure) | Ghi nhận trong CHANGELOG |

---

## 📋 Danh sách Kiểm tra Bảo mật Trước khi Push

```bash
# Kiểm tra không có secret trong code
git diff --cached | grep -i -E "(password|secret|api_key|private_key|token)" && echo "⚠️ CẢNH BÁO: Phát hiện thông tin nhạy cảm!" || echo "✅ OK"

# Đảm bảo commit được ký số
git log --show-signature -1
```

---

## 🔑 Quản lý Khóa SSH/GPG

- **Không bao giờ** chia sẻ private key với bất kỳ ai, kể cả thành viên HĐQT khác.
- Thay thế key ngay lập tức nếu nghi ngờ bị lộ — liên hệ `security@axvn.network`.
- Mỗi thiết bị nên có một SSH key riêng biệt.
- Thiết lập passphrase cho tất cả SSH keys.

---

*© 2025 AXVN Holding. All Rights Reserved.*
