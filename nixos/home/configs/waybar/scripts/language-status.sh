#!/usr/bin/env bash

# Получаем все активные раскладки и ищем русскую
RUSSIAN_LAYOUT=$(hyprctl devices | grep "active keymap:" | grep -c "Russian")

# Проверяем, есть ли активная русская раскладка
if [ "$RUSSIAN_LAYOUT" -gt 0 ]; then
    echo '{"text": "RU", "tooltip": "Russian keyboard layout"}'
else
    echo '{"text": "EN", "tooltip": "English keyboard layout"}'
fi