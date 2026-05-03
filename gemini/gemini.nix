{ config, pkgs, lib, ... }:

{
  home.file = {
    # Gemini CLI の AGENTS.md（読み取り専用で問題ないためシンボリックリンク）
    ".gemini/AGENTS.md".source = ./../agents/AGENTS.md;
    # AI エージェント共有スキル（Claude Code / Gemini CLI 両方から参照）
    ".gemini/skills".source = ./../agents/skills;
  };

  # home-manager switch 時に Gemini CLI の settings.json を書き込み可能な
  # コピーとして配置する（Gemini CLI が認証情報等を書き戻すためシンボリックリンクは不可）
  home.activation.geminiSettings =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      install -Dm644 ${./settings.json} ${config.home.homeDirectory}/.gemini/settings.json
    '';
}
