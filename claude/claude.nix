{ config, pkgs, lib, ... }:

{
  home.file = {
    ".claude/CLAUDE.md".source = ./CLAUDE.md;
    # AI エージェント共有スキル（Claude Code から参照）
    ".claude/skills".source = ./../agents/skills;
    # Claude Code フック: イベントに応じた通知音を再生するスクリプト
    ".claude/hooks/notify.sh" = {
      source = ./hooks/notify.sh;
      executable = true;
    };
  };

  # home-manager switch 時に Claude Code の settings.json を書き込み可能な
  # コピーとして配置する（/config コマンドが書き戻すためシンボリックリンクは不可）
  home.activation.claudeSettings =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      install -Dm644 ${./settings.json} ${config.home.homeDirectory}/.claude/settings.json
    '';
}
