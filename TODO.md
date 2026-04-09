# todo
- [ ] home.nixにホームディレクトリの名称を書かなくても良いようにしたい

- [ ] 環境変数やaliasはbashrcとは別管理にしたい

- [ ] codex, tmuxのコミットハッシュ固定するようにしたい

- [ ] mozc, japanese設定をnixからできないか

- [ ] caps lock を ctrlに変えるのもnixから実施

- [ ] `/etc/default/keyboard` を system-manager (numtide/system-manager) で Nix 管理する
  - flake input に追加し `environment.etc."default/keyboard"` で XKB 設定を宣言
  - `nix run github:numtide/system-manager -- switch --flake .` で適用、`console-setup` の conffile 競合に注意

- [ ] fish shellの環境整備
  - [x] fish shellをインストール
  - [x] tmux環境のデフォルトシェルをfishにする
  - [x] abbrを設定
  - [ ] color themeを適応する (ohmyfishとか？)

- [ ] AI環境周りを整備
  - [x] Claudeのdenyルール
  - [ ] skills等を整備
  - [x] 完了時のhooks
  - [ ] Claude/Codexの設定をSSOTにする
    - https://i9wa4.github.io/blog/2026-03-15-agent-config-ssot-nix.html

- [ ] weztermに入門したい。tmux使わずにtmuxぽいことできるみたいなので。せっかくRust製のターミナル使っていてもtmuxがボトルネックになって描画が早くなっていないようなところもありそうな。
