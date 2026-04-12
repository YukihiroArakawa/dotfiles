# nix
abbr -a hms "nix run home-manager/master -- switch --flake .#york -b backup"

# git
abbr -a glo "git log --oneline"
abbr -a gs "git status"
abbr -a gpoh "git push origin HEAD"
abbr -a gpfoh "git push -f origin HEAD"

# tmux
# 縦分割ペインの幅を均等にする
abbr -a tmux-even "tmux select-layout even-horizontal"

# editor
set -gx EDITOR nvim
set -gx SUDO_EDITOR $EDITOR
alias vim="nvim"

# cargo
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end

# path
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.tiup/bin"

# copyq
set -gx QT_QPA_PLATFORM xcb
abbr -a copyq_killall "killall copyq"
abbr -a copyq_xcb "env QT_QPA_PLATFORM=xcb copyq &"

# clipboard (like pbcopy)
alias pbcopy="xclip -selection clipboard"
alias copyclipboard="xclip -selection clipboard"

# machine-local/private settings (not tracked in this repo)
if test -f "$HOME/.config/fish/config.local.fish"
    source "$HOME/.config/fish/config.local.fish"
end
