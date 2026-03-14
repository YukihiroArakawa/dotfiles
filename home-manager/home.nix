{ config, pkgs, ... }:

{
  # ------------------------------
  # User metadata
  # ------------------------------
  # Home Manager が管理するユーザー名
  home.username = "york";
  # 上記ユーザーの HOME ディレクトリ
  home.homeDirectory = "/home/york";
  # Home Manager の state バージョン（初回導入時の値を維持）
  home.stateVersion = "25.05";

  # ------------------------------
  # Home Manager self management
  # ------------------------------
  # Home Manager 自体をこの設定で管理
  programs.home-manager.enable = true;

  # ------------------------------
  # Fish shell
  # ------------------------------
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ./../fish/config.fish;
  };

  # ------------------------------
  # Packages
  # ------------------------------
  # このユーザー環境に追加するパッケージ一覧
  # flake.nix 側でも home.packages を追加しているため、最終的にはマージされる
  home.packages = [
    pkgs.tmux
    # pdfのページ追加・削除・入れ替えツール
    pkgs.pdfarranger
  ];

  # ------------------------------
  # Dotfiles under ~/.config (XDG_CONFIG_HOME)
  # ------------------------------
  # XDG 機能を有効化（通常 ~/.config を基準に扱う）
  xdg.enable = true;
  # xdg.configFile."<relative path>".source = <path>;
  # => ~/.config/<relative path> に source の内容をリンク配置
  xdg.configFile."tmux/tmux.conf".source = ./../tmux/tmux.conf;
  xdg.configFile."tmux/tmux_setup.sh".source = ./../tmux/tmux_setup.sh;
  xdg.configFile."nvim".source = ./../nvim;
  xdg.configFile."autostart/ubuntu-setup.desktop".source = ./../ubuntu/ubuntu-setup.desktop;
  xdg.configFile."ubuntu/ubuntu_setup.sh".source = ./../ubuntu/ubuntu_setup.sh;
  # 詰まってそうなので一旦コメントアウト
  xdg.configFile."nix/nix.conf".source = ./../nix/nix.conf;

  # ------------------------------
  # Dotfiles under $HOME (arbitrary paths)
  # ------------------------------
  # home.file."<path from HOME>".source = <path>;
  # => ~/<path from HOME> に source の内容をリンク配置
  home.file = {
    ".bashrc".source = ./../bashrc/bashrc;
    ".local/share/omakub/defaults/alacritty.toml".source = ./../alacritty/alacritty.toml;
  };

  # ------------------------------
  # Session environment variables
  # ------------------------------
  # ログインシェル等で有効にする環境変数
  home.sessionVariables = {
  };
}
