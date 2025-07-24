{ config, lib, pkgs, ... }:
{
  # Отключение IPv6 на уровне ядра
  boot.kernelParams = [ 
    "ipv6.disable=1" 
  ];

  # Отключение IPv6 в networking
  networking = {
    enableIPv6 = false;
  };

  # Дополнительные sysctl настройки для полного отключения
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.disable_ipv6" = 1;
    "net.ipv6.conf.default.disable_ipv6" = 1;
    "net.ipv6.conf.lo.disable_ipv6" = 1;
  };

  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
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
  };
  
  # Home Manager configuration
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.crack = { pkgs, ... }: {
    home.stateVersion = "25.05";
    
    # Пакеты пользователя
    home.packages = with pkgs; [
      # Browsers
      firefox brave google-chrome
      
      # Communication
      telegram-desktop
      
      # Development
      git vim neovim tmux nodejs gcc wget curl unzip vscode ripgrep fd python3
      cmake poetry lazygit bat
      
      # System utilities
      nautilus pavucontrol cliphist udiskie
      blueman bluez-tools proxychains
      
      # Wayland/Hyprland specific
      eww swaynotificationcenter
    ];
    
    # Shell configuration
    programs.bash = {
      enable = true;
      bashrcExtra = ''
        export NPM_CONFIG_PREFIX="$HOME/.npm-global"
        export PATH="$HOME/.npm-global/bin:$PATH"
        
        # Install Claude Code if not present
        if ! command -v claude &> /dev/null; then
          mkdir -p "$HOME/.npm-global"
          npm install -g @anthropic-ai/claude
        fi
      '';
    };
    
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      
      initExtra = ''
        export NPM_CONFIG_PREFIX="$HOME/.npm-global"
        export PATH="$HOME/.npm-global/bin:$PATH"
        
        # Install Claude Code if not present
        if ! command -v claude &> /dev/null; then
          mkdir -p "$HOME/.npm-global"
          npm install -g @anthropic-ai/claude
        fi
      '';
      
      plugins = [
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "v1.1.2";
            sha256 = "Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
          };
        }
      ];
    };
    
    # Git configuration
    programs.git = {
      enable = true;
      userName = "crack";
      userEmail = "crack@example.com"; # замените на свой email
    };
    
    # NPM configuration
    home.file.".npmrc".text = ''
      prefix=''${HOME}/.npm-global
    '';
    
    # Создание директории для npm
    # Создание директории для npm через home.file
    home.file.".npm-global/.keep".text = "";
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
    # Hyprland ecosystem packages
    waybar          # status bar
    wofi           # application launcher
    swww           # wallpaper daemon
    grim           # screenshots
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
    
    # Development tools
    zsh-syntax-highlighting
    zsh-autosuggestions
    fzf
    bar
    eza
    docker
    yazi
    
    # System tools
    iptables       # для управления правилами
    redsocks       # прокси
    libnotify      # для notify-send
    nodePackages.npm
    
    # Hardware specific
    config.hardware.nvidia.package.settings
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