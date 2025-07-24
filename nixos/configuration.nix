{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  
  nixpkgs.config.allowUnfree = true;
  
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  
  time.timeZone = "Europe/Moscow";
  
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb.layout = "us,ru";
    xkb.options = "grp:alt_shift_toggle";
  };
  
  services.xserver.deviceSection = ''
    Option "Coolbits" "28"
  '';
  
  # Hyprland configuration
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  
  # Display manager for Hyprland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  
  hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.open = false;
  hardware.bluetooth.enable = true;
  
  # Кастомный сервис redsocks
  systemd.services.redsocks-custom = {
    description = "Custom Redsocks SOCKS5 proxy";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.redsocks}/bin/redsocks -c /etc/redsocks-custom.conf";
      ExecStop = "${pkgs.procps}/bin/pkill -f redsocks";
      Restart = "on-failure";
      RestartSec = 5;
    };
    enable = false; # По умолчанию отключен, включается через скрипт
  };
  
  # Конфигурационный файл для redsocks
  environment.etc."redsocks-custom.conf".text = ''
    base {
      log_debug = off;
      log_info = on;
      log = "stderr";
      daemon = off;
      redirector = iptables;
    }
    
    redsocks {
      local_ip = 127.0.0.1;
      local_port = 12345;
      ip = 78.40.193.120;
      port = 53612;
      type = socks5;
    }
  '';
  
  # Enable iptables service
  networking.firewall.enable = false; # Отключаем firewall для работы с iptables
  networking.nftables.enable = false; # Используем iptables вместо nftables
  
  security.sudo.extraRules = [
    {
      users = [ "crack" ];
      commands = [
        { command = "ALL"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];
  
  users.users.crack = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" "networkmanager" "audio" "video" "input"
      "docker" "lp" "plugdev"
    ];
    packages = with pkgs; [
      # Hyprland ecosystem packages
      waybar          # status bar
      wofi           # application launcher
      dunst          # notifications
      swww           # wallpaper daemon
      grim           # screenshots
      slurp          # screen selection
      wl-clipboard   # clipboard utilities
      
      # Your existing packages
      ghostty firefox brave google-chrome telegram-desktop
      git vim neovim tmux zsh nodejs gcc wget curl unzip vscode ripgrep fd python3
      clang cmake zsh-syntax-highlighting zsh-autosuggestions fzf bar eza docker
      yazi poetry lazygit bat nautilus pavucontrol
      cliphist udiskie eww redsocks bluez
      blueman bluez-tools
      config.hardware.nvidia.package.settings
      proxychains
      nodePackages.npm
    ];
  };
  
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };
  
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  
  environment.systemPackages = with pkgs; [
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
    
    # Network tools
    iptables       # для управления правилами
    redsocks       # прокси
    libnotify      # для notify-send
  ];
  
  # XDG portal for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
  
  # Enable polkit for privilege escalation
  security.polkit.enable = true;
  
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    noto-fonts
    noto-fonts-emoji
    roboto
    roboto-mono
    roboto-serif
  ];
  
  system.stateVersion = "25.05";
}
