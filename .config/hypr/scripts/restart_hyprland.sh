#!/usr/bin/env bash

# Скрипт полного перезапуска Hyprland и связанных служб

echo "🔄 Перезапуск Hyprland и связанных служб..."

# Останавливаем все UI службы (они запустятся автоматически через exec-once в конфиге)
echo "⏹️ Остановка всех UI служб..."
pkill waybar 2>/dev/null || true
pkill swaync 2>/dev/null || true
pkill swww-daemon 2>/dev/null || true
pkill nm-applet 2>/dev/null || true
pkill pavucontrol 2>/dev/null || true
pkill udiskie 2>/dev/null || true
pkill -f "wl-paste" 2>/dev/null || true

# Ждем пока процессы полностью завершатся
sleep 2

# Перезапускаем Hyprland (все службы запустятся автоматически через exec-once)
echo "🔄 Перезапуск Hyprland..."
hyprctl dispatch exit