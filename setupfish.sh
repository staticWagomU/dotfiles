#!/bin/bash

# Nixで入れたfishをdefault shellに設定するスクリプト
# 使用方法: ./set-nix-fish-as-default.sh

set -e # エラー時に終了

# 色付きメッセージ用の関数
print_info() {
  echo -e "\033[34m[INFO]\033[0m $1"
}

print_success() {
  echo -e "\033[32m[SUCCESS]\033[0m $1"
}

print_error() {
  echo -e "\033[31m[ERROR]\033[0m $1"
}

print_warning() {
  echo -e "\033[33m[WARNING]\033[0m $1"
}

# OS検出
detect_os() {
  if [[ $OSTYPE == "darwin"* ]]; then
    echo "macos"
  elif [[ $OSTYPE == "linux-gnu"* ]]; then
    echo "linux"
  else
    echo "unknown"
  fi
}

# Nixで入れたfishのパスを検索
find_nix_fish() {
  local fish_paths=(
    "$HOME/.nix-profile/bin/fish"
    "/nix/var/nix/profiles/default/bin/fish"
    "/run/current-system/sw/bin/fish"
  )

  for path in "${fish_paths[@]}"; do
    if [[ -x $path ]]; then
      echo "$path"
      return 0
    fi
  done

  # Nixストア内を検索
  local nix_store_fish
  nix_store_fish=$(find /nix/store -name "fish" -type f -executable 2>/dev/null | grep -E "fish-[0-9]" | head -1)
  if [[ -n $nix_store_fish && -x $nix_store_fish ]]; then
    echo "$nix_store_fish"
    return 0
  fi

  return 1
}

# /etc/shellsにfishを追加
add_to_shells() {
  local fish_path="$1"
  local os="$2"

  if ! grep -q "^$fish_path$" /etc/shells 2>/dev/null; then
    print_info "/etc/shellsに$fish_pathを追加しています..."

    if [[ $os == "macos" ]]; then
      # macOSの場合
      echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    else
      # Linuxの場合
      echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    fi

    print_success "/etc/shellsに追加完了"
  else
    print_info "$fish_pathは既に/etc/shellsに登録済みです"
  fi
}

# default shellを変更
change_default_shell() {
  local fish_path="$1"
  local current_shell
  current_shell=$(getent passwd "$USER" | cut -d: -f7 2>/dev/null || dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')

  if [[ $current_shell == "$fish_path" ]]; then
    print_info "既にdefault shellは$fish_pathに設定されています"
    return 0
  fi

  print_info "Default shellを$fish_pathに変更しています..."

  if chsh -s "$fish_path"; then
    print_success "Default shellの変更完了"
    print_info "変更を反映するには新しいターミナルセッションを開始してください"
  else
    print_error "Default shellの変更に失敗しました"
    return 1
  fi
}

# fishの設定確認
verify_fish() {
  local fish_path="$1"

  print_info "Fishの動作確認中..."

  if "$fish_path" --version &>/dev/null; then
    local fish_version
    fish_version=$("$fish_path" --version)
    print_success "Fish動作確認OK: $fish_version"
  else
    print_error "Fishが正常に動作しません"
    return 1
  fi
}

# メイン処理
main() {
  print_info "Nixで入れたfishをdefault shellに設定します"

  # OS検出
  local os
  os=$(detect_os)
  print_info "検出OS: $os"

  # Nixで入れたfishを検索
  local fish_path
  if fish_path=$(find_nix_fish); then
    print_success "Nixのfishを発見: $fish_path"
  else
    print_error "Nixで入れたfishが見つかりません"
    print_info "以下の方法でfishをインストールしてください:"
    echo "  nix-env -iA nixpkgs.fish"
    echo "  または"
    echo "  nix profile install nixpkgs#fish"
    exit 1
  fi

  # fishの動作確認
  verify_fish "$fish_path" || exit 1

  # /etc/shellsに追加
  add_to_shells "$fish_path" "$os" || exit 1

  # default shellを変更
  change_default_shell "$fish_path" || exit 1

  print_success "セットアップ完了！"
  print_info "現在のshell: $SHELL"
  print_info "新しいターミナルを開いてfishが起動することを確認してください"
}

# スクリプト実行
main "$@"
