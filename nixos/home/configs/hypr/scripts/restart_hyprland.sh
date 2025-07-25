#!/usr/bin/env bash

# Скрипт перезапуска UI служб (БЕЗ выхода из Hyprland)

echo "🔄 Перезапуск UI служб..."

# Останавливаем все UI службы
echo "⏹️ Остановка служб..."
pkill waybar 2>/dev/null || true
pkill swaync 2>/dev/null || true
pkill swww-daemon 2>/dev/null || true
pkill nm-applet 2>/dev/null || true
pkill pavucontrol 2>/dev/null || true
pkill udiskie 2>/dev/null || true
pkill -f "wl-paste" 2>/dev/null || true

# Ждем завершения процессов
sleep 2

# Запускаем службы вручную
echo "🚀 Запуск служб..."
swaync &
swww-daemon &
waybar &
nm-applet &
udiskie --tray &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# Устанавливаем курсор
hyprctl setcursor macOS 24

echo "✅ UI службы перезапущены"