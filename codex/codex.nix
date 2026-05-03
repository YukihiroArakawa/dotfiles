{ config, pkgs, lib, ... }:

let
  # AI エージェント共有スキルのソースディレクトリ
  skillsDir = ./../agents/skills;
  # skillsDir 配下のサブディレクトリ名（= スキル名）一覧
  skillNames = builtins.attrNames (builtins.readDir skillsDir);
  # スキルを ~/.codex/skills/<name> として個別にリンク配置するための home.file エントリ
  # 背景: ~/.codex/skills/ は codex 組み込みの .system/ ディレクトリを持つため、
  # ディレクトリ丸ごとのシンボリックリンクにすると .system/ が隠れてしまう。
  # スキル単位でリンクすることで .system/ を温存する。
  codexSkillFiles = builtins.listToAttrs (map (name: {
    name = ".codex/skills/${name}";
    value = { source = skillsDir + "/${name}"; };
  }) skillNames);

  # codex 実行ポリシー（コマンド単位の allow/prompt/forbidden）の Starlark ルール群
  # 構文: https://developers.openai.com/codex/rules
  rulesDir = ./rules;
  # rulesDir 配下のファイル名一覧
  ruleNames = builtins.attrNames (builtins.readDir rulesDir);
  # ルールを ~/.codex/rules/<name> として個別にリンク配置するための home.file エントリ
  # 背景: ~/.codex/rules/default.rules は codex がデフォルト生成するファイルで
  # nix 管理外としたいため、ディレクトリ丸ごとではなく個別ファイルでリンクする。
  codexRuleFiles = builtins.listToAttrs (map (name: {
    name = ".codex/rules/${name}";
    value = { source = rulesDir + "/${name}"; };
  }) ruleNames);
in
{
  home.file = codexSkillFiles // codexRuleFiles // {
    # codex のグローバル AGENTS.md（読み取り専用で問題ないためシンボリックリンク）
    ".codex/AGENTS.md".source = ./../agents/AGENTS.md;
    ".codex/hooks.json".source = ./hooks.json;
    # Codex hooks から利用する通知スクリプト
    ".codex/hooks/notify.sh" = {
      source = ./../scripts/notify.sh;
      executable = true;
    };
  };
}
