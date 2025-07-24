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
    layout = "us,ru";
    xkbOptions = "grp:alt_shift_toggle";
  };

  # Plasma 6
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.open = false;

  hardware.bluetooth.enable = true;

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
      # kdePackages.kate # если нужен kate, раскомментируй
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
    ghostty firefox brave google-chrome telegram-desktop
    git vim neovim tmux zsh nodejs gcc wget curl unzip vscode ripgrep fd python3
    clang cmake zsh-syntax-highlighting zsh-autosuggestions fzf bar eza docker
    yazi poetry wl-clipboard lazygit bat nautilus pavucontrol
    cliphist udiskie eww redsocks bluez
    blueman bluez-tools  
  ];

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
