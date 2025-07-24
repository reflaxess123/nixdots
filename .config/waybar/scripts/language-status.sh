#!/usr/bin/env bash

# Получаем активную раскладку для главной клавиатуры (main: yes)
CURRENT_LAYOUT=$(hyprctl devices | grep -B2 -A4 "main: yes" | grep "active keymap:" | sed 's/.*active keymap: //')

# Проверяем текущую активную раскладку
if [[ "$CURRENT_LAYOUT" == *"Russian"* ]]; then
    echo '{"text": "RU", "tooltip": "Russian keyboard layout"}'
elif [[ "$CURRENT_LAYOUT" == *"English"* ]]; then
    echo '{"text": "EN", "tooltip": "English keyboard layout"}'
else
    echo '{"text": "??", "tooltip": "Layout: '"$CURRENT_LAYOUT"'"}'
fi