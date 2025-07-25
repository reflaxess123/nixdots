#!/usr/bin/env bash

# Файл для хранения состояния
STATE_FILE="/tmp/redsocks_toggle_state"

start_redsocks() {
    # Очищаем предыдущие правила
    sudo /run/current-system/sw/bin/iptables -t nat -F REDSOCKS 2>/dev/null || true
    sudo /run/current-system/sw/bin/iptables -t nat -D OUTPUT -p tcp -m owner ! --uid-owner 0 -j REDSOCKS 2>/dev/null || true
    sudo /run/current-system/sw/bin/iptables -t nat -X REDSOCKS 2>/dev/null || true
    
    # Останавливаем предыдущие процессы redsocks
    sudo pkill redsocks 2>/dev/null || true
    
    # Запускаем redsocks
    sudo /run/current-system/sw/bin/redsocks -c /etc/redsocks.conf &
    sleep 1
    
    # Создаем цепочку REDSOCKS
    sudo /run/current-system/sw/bin/iptables -t nat -N REDSOCKS 2>/dev/null
    sudo /run/current-system/sw/bin/iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
    sudo /run/current-system/sw/bin/iptables -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN
    sudo /run/current-system/sw/bin/iptables -t nat -A REDSOCKS -d 10.0.0.0/8 -j RETURN
    sudo /run/current-system/sw/bin/iptables -t nat -A REDSOCKS -d 172.16.0.0/12 -j RETURN
    sudo /run/current-system/sw/bin/iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345
    sudo /run/current-system/sw/bin/iptables -t nat -A OUTPUT -p tcp -m owner ! --uid-owner 0 -j REDSOCKS
    
    echo 1 > "$STATE_FILE"
    # notify-send "🧦 Прокси включен"
}

stop_redsocks() {
    # Удаляем правила
    sudo /run/current-system/sw/bin/iptables -t nat -F REDSOCKS 2>/dev/null || true
    sudo /run/current-system/sw/bin/iptables -t nat -D OUTPUT -p tcp -m owner ! --uid-owner 0 -j REDSOCKS 2>/dev/null || true
    sudo /run/current-system/sw/bin/iptables -t nat -X REDSOCKS 2>/dev/null || true
    
    # Останавливаем процесс redsocks
    sudo pkill redsocks 2>/dev/null || true
    
    echo 0 > "$STATE_FILE"
    # notify-send "🧦 Прокси отключен"
}

# Проверяем состояние
if [[ -f "$STATE_FILE" && $(cat "$STATE_FILE") == "1" ]]; then
    stop_redsocks
else
    start_redsocks
fi

# Обновляем waybar
pkill -SIGRTMIN+8 waybar 2>/dev/null || true 
