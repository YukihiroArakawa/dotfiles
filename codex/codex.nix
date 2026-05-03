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
in
{
  home.file = codexSkillFiles // {
    # codex のグローバル AGENTS.md（読み取り専用で問題ないためシンボリックリンク）
    ".codex/AGENTS.md".source = ./../agents/AGENTS.md;
  };
}
