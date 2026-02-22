#!/bin/bash

LOG_FILE="/tmp/tmux_setup.debug.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >>"$LOG_FILE"
}

log "----- tmux_setup.sh start (pid=$$) -----"
log "USER=$USER HOME=$HOME SHELL=$SHELL"
log "TERM=${TERM:-<empty>} TMUX=${TMUX:-<empty>}"
log "tty=$(tty 2>&1)"
log "command -v tmux=$(command -v tmux 2>&1)"
log "tmux -V=$(tmux -V 2>&1)"

# セッション名を設定
SESSION_NAME="default"
log "SESSION_NAME=$SESSION_NAME"

# tmuxが起動しているか、指定したセッションが存在するか確認
tmux has-session -t $SESSION_NAME 2>/dev/null
HAS_SESSION_EXIT_CODE=$?
log "has-session exit_code=$HAS_SESSION_EXIT_CODE"

# 存在しない場合は新しいセッションを作成
if [ "$HAS_SESSION_EXIT_CODE" -ne 0 ]; then
  log "session not found; creating new session"
  tmux new-session -d -s $SESSION_NAME -n "Memo"
  tmux split-window -h -p 30 -t "${SESSION_NAME}:0"
  tmux send-keys -t "${SESSION_NAME}:0.0" "vim ~/Workspace/memo/" C-m

  tmux new-window -t $SESSION_NAME -n "Editor"
  tmux send-keys -t "${SESSION_NAME}:1" "cd ~/Workspace/" C-m
  tmux split-window -h -p 50 -t "${SESSION_NAME}:1.1"

  tmux new-window -t $SESSION_NAME -n "Btop"
  tmux send-keys -t "${SESSION_NAME}:2" "btop" C-m

  tmux new-window -t $SESSION_NAME -n "Docker"
  tmux send-keys -t "${SESSION_NAME}:3" "lazydocker" C-m

  tmux new-window -t $SESSION_NAME -n "Dotfiles"
  tmux send-keys -t "${SESSION_NAME}:4" "cd ~/Workspace/dotfiles/ && nvim ." C-m

  tmux new-window -t $SESSION_NAME -n "InterviewPrep"
  tmux send-keys -t "${SESSION_NAME}:5" "cd ~/Workspace/career_info/ && nvim ." C-m

  # 最初に表示するウィンドウを選択
  tmux select-window -t "${SESSION_NAME}:0"
fi

# 作成したセッションにアタッチ
log "attach start"
tmux attach-session -t $SESSION_NAME
ATTACH_EXIT_CODE=$?
log "attach exit_code=$ATTACH_EXIT_CODE"
log "----- tmux_setup.sh end -----"
