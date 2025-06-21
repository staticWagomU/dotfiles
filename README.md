
## 事前準備

nixを入れる
```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
参照: https://zero-to-nix.com/

## 初回

```shell
nix run home-manager/master -- switch --flake .#MacBookAir

```

## 2回目移行

```shell
home-manager switch --flake .#MacBookAir
```

```
nix flake update
```

