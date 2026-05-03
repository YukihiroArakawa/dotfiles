{
  # ------------------------------
  # Flake metadata
  # ------------------------------
  # この flake の説明文
  description = "dotfiles (home-manager + latest codex/claude-code)";

  # ------------------------------
  # Input dependencies
  # ------------------------------
  # この flake が参照する外部リポジトリ（バージョン源）
  inputs = {
    # パッケージセット（unstable チャンネル）
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager 本体
    home-manager.url = "github:nix-community/home-manager";
    # Home Manager が使う nixpkgs を上の nixpkgs に揃える
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # codex CLI パッケージを提供する flake
    codex-nix.url = "github:sadjow/codex-nix";
    # Claude Code CLI パッケージを提供する flake
    claude-code-nix.url = "github:sadjow/claude-code-nix";
    # LLM エージェント群を提供する flake（毎日自動更新）
    # ここでは gemini-cli のみ使用
    llm-agents-nix.url = "github:numtide/llm-agents.nix";

    # Google Workspace CLI (`gws`) を提供する flake
    googleworkspace-cli.url = "github:googleworkspace/cli";
    # 上流 flake が参照する nixpkgs をこの flake に揃える
    googleworkspace-cli.inputs.nixpkgs.follows = "nixpkgs";
  };

  # ------------------------------
  # Flake outputs
  # ------------------------------
  # inputs を受け取り、実際に使う成果物（ここでは homeConfigurations）を定義
  outputs = { nixpkgs, home-manager, codex-nix, claude-code-nix, llm-agents-nix, googleworkspace-cli, ... }:
    let
      # 対象アーキテクチャ
      system = "x86_64-linux";
      # 上記 system 用の pkgs を生成
      pkgs = import nixpkgs { inherit system; };
    in {
      # ------------------------------
      # Home Manager configuration
      # ------------------------------
      # `home-manager switch --flake .#york` で参照される設定
      homeConfigurations.york = home-manager.lib.homeManagerConfiguration {
        # 全 modules で利用する pkgs
        inherit pkgs;
        # 設定モジュール群（マージして最終設定になる）
        modules = [
          # メインの home.nix
          ./home-manager/home.nix
          # 追加モジュール: codex パッケージを home.packages に注入
          ({ ... }: {
            home.packages = [
              codex-nix.packages.${system}.default
              claude-code-nix.packages.${system}.default
              llm-agents-nix.packages.${system}.gemini-cli
              googleworkspace-cli.packages.${system}.default
            ];
          })
        ];
      };
    };
}
