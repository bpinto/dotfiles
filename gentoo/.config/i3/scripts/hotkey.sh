#!/usr/bin/env bash

get_id() {
  local id=$(xprop -root _NET_ACTIVE_WINDOW)
  echo ${id##* }
}

get_name() {
  local id=$(get_id)
  local name=$(xprop -id $id | grep 'WM_CLASS(STRING)')
  local name=${name#*\"}
  echo ${name}
}

is_running() {
  echo $(get_name) | grep $1
}

main() {
  local hotkey=$1
  local alt=Mod1
  local cmd=Mod4
  local ctrl=Control

  case $hotkey in
    $alt+Return)
      if is_running termite; then
        xdotool key --clearmodifiers --delay 0 --window 0 "Ctrl+Shift+t"
      else
        exec termite
      fi
      ;;
  esac
}

main $1
