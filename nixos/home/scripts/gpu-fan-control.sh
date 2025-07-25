#!/usr/bin/env bash

# GPU Fan Control Script for Wayland/Hyprland
# Set NVIDIA GPU fans to 62% speed

# Try to find the X display
for display in :0 :1 :2; do
    if xdpyinfo -display "$display" &>/dev/null; then
        export DISPLAY="$display"
        echo "Found X display: $display"
        break
    fi
done

if [ -z "$DISPLAY" ]; then
    echo "No X display found. Trying to start with :0"
    export DISPLAY=:0
fi

# Allow root access to X server
xhost +SI:localuser:root &>/dev/null

# Function to run nvidia-settings with proper environment
run_nvidia_settings() {
    sudo -E DISPLAY="$DISPLAY" XAUTHORITY="$XAUTHORITY" nvidia-settings "$@"
}

echo "Current fan control state: $(run_nvidia_settings -q "[gpu:0]/GPUFanControlState" -t 2>/dev/null || echo "unknown")"

# Enable manual fan control
echo "Enabling manual fan control..."
if run_nvidia_settings -a "[gpu:0]/GPUFanControlState=1" 2>/dev/null; then
    echo "Manual fan control enabled successfully"
else
    echo "Failed to enable manual fan control"
    exit 1
fi

# Wait a moment for the setting to take effect
sleep 1

# Set fan speeds to 62%
echo "Setting fan 0 to 62%..."
if run_nvidia_settings -a "[fan:0]/GPUTargetFanSpeed=62" 2>/dev/null; then
    echo "Fan 0 set to 62%"
else
    echo "Failed to set fan 0 speed"
fi

echo "Setting fan 1 to 62%..."
if run_nvidia_settings -a "[fan:1]/GPUTargetFanSpeed=62" 2>/dev/null; then
    echo "Fan 1 set to 62%"
else
    echo "Failed to set fan 1 speed"
fi

# Wait a bit more for settings to apply
sleep 2

# Try to force the fan speed again if it's not at 62%
current_speed_0=$(run_nvidia_settings -q "[fan:0]/GPUCurrentFanSpeed" -t 2>/dev/null)
current_speed_1=$(run_nvidia_settings -q "[fan:1]/GPUCurrentFanSpeed" -t 2>/dev/null)

if [ "$current_speed_0" != "62" ]; then
    echo "Re-applying fan 0 speed..."
    run_nvidia_settings -a "[fan:0]/GPUTargetFanSpeed=62" &>/dev/null
fi

if [ "$current_speed_1" != "62" ]; then
    echo "Re-applying fan 1 speed..."
    run_nvidia_settings -a "[fan:1]/GPUTargetFanSpeed=62" &>/dev/null
fi

# Final verification
echo ""
echo "=== Final Status ==="
echo "GPU Temperature: $(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)°C"
echo "Fan Control State: $(run_nvidia_settings -q "[gpu:0]/GPUFanControlState" -t 2>/dev/null)"
echo "Target Fan 0 Speed: $(run_nvidia_settings -q "[fan:0]/GPUTargetFanSpeed" -t 2>/dev/null)%"
echo "Target Fan 1 Speed: $(run_nvidia_settings -q "[fan:1]/GPUTargetFanSpeed" -t 2>/dev/null)%"
echo "Current Fan 0 Speed: $(run_nvidia_settings -q "[fan:0]/GPUCurrentFanSpeed" -t 2>/dev/null)%"
echo "Current Fan 1 Speed: $(run_nvidia_settings -q "[fan:1]/GPUCurrentFanSpeed" -t 2>/dev/null)%"
echo "nvidia-smi fan speed: $(nvidia-smi --query-gpu=fan.speed --format=csv,noheader)"

echo ""
echo "GPU fans configuration completed"