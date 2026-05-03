#!/usr/bin/env bash
# Claude Code のフックで呼ばれる通知音スクリプト
# 第1引数で音声ファイルを指定可能（デフォルト: complete.oga）
# paplay (PulseAudio) でバックグラウンド再生する

SOUND_FILE="${1:-/usr/share/sounds/freedesktop/stereo/complete.oga}"

if [ -f "$SOUND_FILE" ]; then
  paplay "$SOUND_FILE" &
fi
