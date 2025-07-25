{ config, pkgs, ... }:

{
  # GUI application packages
  home.packages = with pkgs; [
    # Browsers
    firefox brave google-chrome
    
    # Communication
    telegram-desktop
    
    # System utilities
    nautilus pavucontrol cliphist udiskie
    blueman bluez-tools proxychains
    
    # Wayland/Hyprland specific
    eww swaynotificationcenter
    
    # Hyprland ecosystem packages
    waybar          # status bar
    wofi           # application launcher
    swww           # wallpaper daemon
    grim           # screenshots
    hyprshot       # screenshot tool
    slurp          # screen selection
    wl-clipboard   # clipboard utilities
    
    # Additional Hyprland utilities
    hyprpaper      # wallpaper utility
    hypridle       # idle daemon
    hyprlock       # screen locker
    hyprpicker     # color picker
    
    # Basic Wayland tools
    xwayland
    qt5.qtwayland
    qt6.qtwayland
    
    # File manager with Wayland support
    xfce.thunar    # lightweight file manager
    
    # Terminal emulator optimized for Wayland
    kitty
    alacritty
    ghostty
    
    # Qt theming
    qt5.qtbase qt6.qtbase
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    
    # Cursor themes
    bibata-cursors
    apple-cursor
  ];
}
