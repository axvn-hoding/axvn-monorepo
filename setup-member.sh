#!/usr/bin/env bash
# =============================================================================
#  setup-member.sh — AXVN Holding
#  Script thiết lập danh tính Git & SSH Key cho thành viên HĐQT
#  Chạy: bash setup-member.sh
# =============================================================================

set -e

AXVN_ORG="axvn-hoding"
AXVN_REPO_LIST=(
  "axvn-connector-js"
  "axvn-connector-python"
  "axvn-spot-api-docs"
  "axvn-monorepo"
  "axvn-exchange"
  "docs"
  ".github"
)

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║         AXVN Holding — Thiết lập Thành viên HĐQT        ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# --- Bước 1: Nhập thông tin cá nhân ---
read -p "👤 Họ và tên đầy đủ (VD: Hoang Xuan Bien): " MEMBER_NAME
read -p "📧 Email GitHub cá nhân: " MEMBER_EMAIL
read -p "🐙 GitHub username (VD: hoangxuanbien): " MEMBER_GITHUB

echo ""
echo "✅ Thông tin đã nhập:"
echo "   Tên  : $MEMBER_NAME"
echo "   Email: $MEMBER_EMAIL"
echo "   Login: @$MEMBER_GITHUB"
read -p "Xác nhận đúng? [Y/n] " CONFIRM
if [[ "$CONFIRM" =~ ^[Nn]$ ]]; then
  echo "Đã huỷ. Chạy lại script để nhập lại."
  exit 1
fi

# --- Bước 2: Tạo SSH Key (nếu chưa có) ---
SSH_KEY_PATH="$HOME/.ssh/axvn_${MEMBER_GITHUB}_ed25519"

echo ""
echo "🔐 Kiểm tra SSH Key..."

if [ -f "$SSH_KEY_PATH" ]; then
  echo "   ✅ SSH Key đã tồn tại tại: $SSH_KEY_PATH"
else
  echo "   🔑 Tạo SSH Key mới tại: $SSH_KEY_PATH"
  ssh-keygen -t ed25519 -C "$MEMBER_EMAIL" -f "$SSH_KEY_PATH" -N ""
  echo "   ✅ SSH Key đã tạo thành công."
fi

# --- Bước 3: Thêm vào ssh-agent ---
echo ""
echo "⚙️  Thêm key vào ssh-agent..."
eval "$(ssh-agent -s)" > /dev/null 2>&1
ssh-add "$SSH_KEY_PATH" > /dev/null 2>&1
echo "   ✅ Đã thêm vào ssh-agent."

# --- Bước 4: Cấu hình SSH config cho tổ chức ---
SSH_CONFIG="$HOME/.ssh/config"
if ! grep -q "axvn-hoding" "$SSH_CONFIG" 2>/dev/null; then
  echo "" >> "$SSH_CONFIG"
  echo "# AXVN Holding — $MEMBER_NAME" >> "$SSH_CONFIG"
  echo "Host github.com-axvn" >> "$SSH_CONFIG"
  echo "    HostName github.com" >> "$SSH_CONFIG"
  echo "    User git" >> "$SSH_CONFIG"
  echo "    IdentityFile $SSH_KEY_PATH" >> "$SSH_CONFIG"
  echo "   ✅ Đã thêm cấu hình SSH host vào $SSH_CONFIG"
else
  echo "   ✅ Cấu hình SSH cho axvn-hoding đã tồn tại."
fi

# --- Bước 5: Cấu hình Git global để ký commit ---
echo ""
echo "✍️  Cấu hình Git ký số commit bằng SSH Key..."
git config --global user.name "$MEMBER_NAME"
git config --global user.email "$MEMBER_EMAIL"
git config --global gpg.format ssh
git config --global user.signingkey "${SSH_KEY_PATH}.pub"
git config --global commit.gpgsign true
echo "   ✅ Git global đã cấu hình."

# --- Bước 6: Hiển thị public key để đăng ký GitHub ---
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║  📋 SAO CHÉP PUBLIC KEY VÀ ĐĂNG KÝ LÊN GITHUB          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "  👇 Public Key (SSH Ed25519):"
echo "  ─────────────────────────────────────────────────────────"
cat "${SSH_KEY_PATH}.pub"
echo "  ─────────────────────────────────────────────────────────"
echo ""
echo "  📌 Hướng dẫn đăng ký trên GitHub:"
echo "     1. Truy cập: https://github.com/settings/keys"
echo "     2. Nhấn 'New SSH key'"
echo "     3. Title: 'AXVN Holding — $MEMBER_NAME'"
echo "     4. Key type: 'Authentication Key' (và 'Signing Key')"
echo "     5. Dán public key ở trên vào ô Key"
echo "     6. Nhấn 'Add SSH key'"
echo ""

# --- Bước 7: Clone tất cả repositories ---
echo ""
read -p "📥 Clone tất cả repositories của AXVN Holding về máy? [Y/n] " DO_CLONE
if [[ ! "$DO_CLONE" =~ ^[Nn]$ ]]; then
  mkdir -p "$HOME/axvn-hoding"
  cd "$HOME/axvn-hoding"

  for REPO in "${AXVN_REPO_LIST[@]}"; do
    if [ -d "$REPO" ]; then
      echo "   ⏭️  Đã tồn tại, bỏ qua: $REPO"
      continue
    fi
    echo "   📥 Cloning: $REPO ..."
    git clone "git@github.com:${AXVN_ORG}/${REPO}.git" 2>/dev/null \
      && echo "   ✅ OK: $REPO" \
      || echo "   ❌ Thất bại: $REPO (kiểm tra quyền truy cập)"
  done

  echo ""
  echo "   ✅ Repositories đã clone vào: $HOME/axvn-hoding/"

  # Cấu hình git local cho từng repo
  for REPO in "${AXVN_REPO_LIST[@]}"; do
    if [ -d "$HOME/axvn-hoding/$REPO/.git" ]; then
      git -C "$HOME/axvn-hoding/$REPO" config user.name "$MEMBER_NAME"
      git -C "$HOME/axvn-hoding/$REPO" config user.email "$MEMBER_EMAIL"
      git -C "$HOME/axvn-hoding/$REPO" config gpg.format ssh
      git -C "$HOME/axvn-hoding/$REPO" config user.signingkey "${SSH_KEY_PATH}.pub"
      git -C "$HOME/axvn-hoding/$REPO" config commit.gpgsign true
    fi
  done
  echo "   ✅ Đã cấu hình danh tính Git cho tất cả repositories."
fi

# --- Tóm tắt ---
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                  ✅ HOÀN TẤT THIẾT LẬP                  ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""
echo "  Thành viên : $MEMBER_NAME (@$MEMBER_GITHUB)"
echo "  Email      : $MEMBER_EMAIL"
echo "  SSH Key    : $SSH_KEY_PATH"
echo "  Tổ chức    : https://github.com/$AXVN_ORG"
echo ""
echo "  🔑 Nhớ đăng ký SSH Key lên GitHub trước khi push!"
echo "     https://github.com/settings/keys"
echo ""
echo "  📋 Quy trình commit có ký số:"
echo "     git add ."
echo "     git commit -S -m \"feat: <mô tả đóng góp>\""
echo "     git push origin main"
echo ""
