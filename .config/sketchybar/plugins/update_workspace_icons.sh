#!/bin/bash

# Script to update sketchybar when aerospace workspace changes
# This script is called from aerospace's exec-on-workspace-change

# Trigger the aerospace_workspace_change event in sketchybar
/opt/homebrew/bin/sketchybar --trigger aerospace_workspace_change \
  FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE" \
  PREV_WORKSPACE="$AEROSPACE_PREV_WORKSPACE"

# Optional: Update workspace icons for all workspaces
# This part queries aerospace for window information and updates the icons accordingly

WORKSPACES=("1" "2" "3" "4" "5" "6" "7" "C" "B" "M" "WHO" "AD")

for workspace in "${WORKSPACES[@]}"; do
  # Get apps in this workspace
  apps_output=$(aerospace list-windows --workspace "$workspace" --format "%{app-name}" 2>/dev/null)
  
  # Count unique apps and build icon string
  icon_line=""
  declare -A app_count
  
  if [[ -n "$apps_output" ]]; then
    while IFS= read -r app_name; do
      if [[ -n "$app_name" ]]; then
        ((app_count["$app_name"]++))
      fi
    done <<< "$apps_output"
    
    # You can extend this with your app icons mapping
    for app in "${!app_count[@]}"; do
      case "$app" in
        "Brave Browser") icon_line+="󰖟" ;;
        "Ghostty") icon_line+="" ;;
        "Figma") icon_line+="" ;;
        "Notion") icon_line+="󰈙" ;;
        "Obsidian") icon_line+="󰠮" ;;
        "Slack") icon_line+="󰒱" ;;
        "Discord") icon_line+="󰙯" ;;
        "Adobe Premiere Pro 2024") icon_line+="" ;;
        "Code") icon_line+="󰨞" ;;
        "Terminal") icon_line+="" ;;
        *) icon_line+="󰘔" ;;  # Default icon
      esac
    done
  else
    icon_line=" —"
  fi
  
  # Update sketchybar item for this workspace
  /opt/homebrew/bin/sketchybar --set "space.$workspace" label="$icon_line"
done