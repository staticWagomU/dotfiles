# dotfiles

輪ごむのお部屋 - Nix flake based dotfiles

## 事前準備

Nixを入れる
```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
参照: https://zero-to-nix.com/

## macOS (nix-darwin + home-manager)

nix-darwinを使用してシステム全体を宣言的に管理します。

### 初回セットアップ

```shell
sudo nix run nix-darwin -- switch --flake .#MacBookAir
```

### 2回目以降

```shell
sudo darwin-rebuild switch --flake .#MacBookAir
```

### 含まれる設定

- **Tailscale**: サービス自動起動 + GUI (Homebrew cask経由)
- **macOSシステム設定**: Dock, Finder, キーリピートなど
- **Touch ID for sudo**: 有効化
- **Homebrew統合**: caskの宣言的管理

## Linux (home-manager standalone)

```shell
# 初回
nix run home-manager/master -- switch --flake .#WSL

# 2回目以降
home-manager switch --flake .#WSL
```

## 利用可能な設定

| 名前 | システム | 説明 |
|------|----------|------|
| `MacBookAir` | aarch64-darwin | nix-darwin + home-manager |
| `MacBookPro` | aarch64-darwin | nix-darwin + home-manager |
| `WSL` | x86_64-linux | home-manager standalone |
| `ThinkpadT14Gen3` | x86_64-linux | home-manager standalone |
| `NucBox3` | x86_64-linux | home-manager standalone |

## flake更新

```shell
nix flake update
```
