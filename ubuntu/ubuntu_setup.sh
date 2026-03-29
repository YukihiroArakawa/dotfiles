#!/bin/bash

# --- 画面解像度の設定 ---
# wmctrl -d の出力から正確な値を設定
SCREEN_WIDTH=1920
SCREEN_HEIGHT=1200 # DG の値
USABLE_HEIGHT=1168 # WA の高さ
USABLE_Y_OFFSET=32 # WA の Y 座標 (パネルなどの分)

sleep 10

# Workspace 1
wmctrl -s 0
ZEN_COMMAND="flatpak run app.zen_browser.zen"
$ZEN_COMMAND &
sleep 3

# Workspace 2
wmctrl -s 1
ALACRITTY_COMMAND="alacritty"
ALACRITTY_WM_CLASS="Alacritty"
$ALACRITTY_COMMAND &
sleep 5
wmctrl -r "$ALACRITTY_WM_CLASS" -b add,maximized_vert,maximized_horz

# 起動後に元の仮想デスクトップに戻る
wmctrl -s 0

# memo: appの起動名称の探し方
#  xprop WM_CLASS
# WM_CLASS(STRING) = "crx_kjfnnfnaaifoiapilkhijdngdcfamdlm", "Brave-browser"
# cat $HOME/.local/share/applications/brave-kjfnnfnaaifoiapilkhijdngdcfamdlm-Default.desktop
#  cat $HOME/.local/share/applications/brave-kjfnnfnaaifoiapilkhijdngdcfamdlm-Default.desktop | grep Exec
# Exec=/opt/brave.com/brave/brave-browser --profile-directory=Default --app-id=kjfnnfnaaifoiapilkhijdngdcfamdlm
