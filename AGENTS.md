# Repository Guidelines
## Language

日本語で回答する

## Project Structure & Module Organization
- `flake.nix` がこのドットファイルの入り口で、Home Manager プロファイルやパッケージ構成をまとめている。
- `home-manager/home.nix` に共通の `home.packages` や `programs.*` などの設定を置き、個別ファイル（`alacritty/`、`nvim/`、`tmux/`、`bashrc/`、`ubuntu/`、`nix/`）を `home.file` でインポートする。
- ホスト固有の補正は共有モジュール内に直書きせず、関数化して呼び出し側が `user`/`homeDirectory` を渡すようにする。

## Build, Test, and Development Commands
- `nix flake check` で flake 出力と Home Manager の activation package を検証。`flake.nix` やモジュールを変えたら必ず実行する。
- `home-manager switch --flake .#york`（`york` を該当ユーザー名に置き換え）で設定をビルド・適用。
- `home-manager build --flake .#york` は実際に切り替えずにビルドだけ確認したいときに使う。
- `nix flake update` を実行後は `flake.lock` の変更を確認・コミットする。

## Coding Style & Naming Conventions
- `nix` ファイルは 2 スペースインデント、属性の整列を心掛け、複雑な論理にはごく短いコメントを添える。
- シェルスクリプトや設定スニペットは既存ファイル（`bashrc/`、`ubuntu/`）の書き方に倣い、`shellcheck` でチェックする。
- ファイル名はツール名に合わせた `nvim/init.vim` などの命名で、`home.file` から参照しやすいよう大文字・空白を避ける。

## Testing Guidelines
- 現状のテストは `nix flake check` のみ。それだけでフレーク全体をビルドするため、プッシュ前に必ず再実行する。
- 必要があれば `flake.nix` に `nixosTests.<name>` を追加し、`<feature>-test.nix` の名前でファイルを作成する。

## Commit & Pull Request Guidelines
- 既存の履歴に合わせて `fix: ...` / `add: ...` / `chore: ...` などの Conventional Commit 形式を踏襲する。
- PR には変更点、理由、検証手順（使うコマンド、関係ファイルなど）を記載し、`flake.lock` が更新された場合はそれも明記する。
- 関連 issue があればリンクし、視覚的な変更がない repo のためスクリーンショットは不要。
