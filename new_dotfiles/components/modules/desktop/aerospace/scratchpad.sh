#!/usr/bin/env bash

# Default values
FILTER_TYPE=""
FILTER_VALUE=""

# Function to handle argument parsing
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --command)
      FILTER_TYPE="WindowTitle"
      FILTER_VALUE="$2"
      shift 2
      ;;
    --app-name)
      FILTER_TYPE="AppName"
      FILTER_VALUE="$2"
      shift 2
      ;;
    *)
      echo "Usage: $0 --window-title <title> | --app-name <app_name>"
      exit 1
      ;;
  esac
done

# Ensure both FILTER_TYPE and FILTER_VALUE are set
if [[ -z "$FILTER_TYPE" || -z "$FILTER_VALUE" ]]; then
  echo "Both --window-title or --app-name and their respective values are required."
  exit 1
fi

focus_app() {
  current_workspace=$(aerospace list-workspaces --focused)

  if [ "$FILTER_TYPE" == "AppName" ]; then
    app_window_id=$(aerospace list-windows --all --format "%{window-id}%{right-padding} | %{app-name}" | grep "$FILTER_VALUE" | cut -d' ' -f1 | sed '1p;d')
  else
    app_window_id=$(aerospace list-windows --all --format "%{window-id}%{right-padding} | %{window-title}" | grep "$FILTER_VALUE" | cut -d' ' -f1 | sed '1p;d')
  fi

  aerospace move-node-to-workspace $current_workspace --window-id $app_window_id 
  aerospace focus --window-id $app_window_id 
  aerospace fullscreen on --window-id $app_window_id 
  aerospace move-mouse window-lazy-center
}

app_closed() {
  if [ "$FILTER_TYPE" == "AppName" ]; then
    if [ "$(aerospace list-windows --all --format '%{app-name}' | grep "$FILTER_VALUE")" == "" ]; then
      true
    else
      false
    fi
  else
    if [ "$(aerospace list-windows --all --format '%{window-title}' | grep "$FILTER_VALUE")" == "" ]; then
      true
    else
      false
    fi
  fi
}

app_focused() {
  if [ "$FILTER_TYPE" == "AppName" ]; then
    if [ "$(aerospace list-windows --focused --format "%{app-name}")" == "$FILTER_VALUE" ]; then
      true
    else
      false
    fi
  else
    if [ "$(aerospace list-windows --focused --format "%{window-title}")" == "$FILTER_VALUE" ]; then
      true
    else
      false
    fi
  fi
}

unfocus_app() {
  aerospace fullscreen off
  aerospace move-node-to-workspace scratchpad
}

if app_closed; then
  # If the app is closed, open it based on the filtering type
  if [ "$FILTER_TYPE" == "AppName" ]; then
    open -a "$FILTER_VALUE"
  else
    wezterm -e "$FILTER_VALUE" &
  fi
  sleep 1
  focus_app
else
  if app_focused; then
    unfocus_app
  else
    focus_app
  fi
fi
