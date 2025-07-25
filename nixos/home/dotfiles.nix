{ config, pkgs, ... }:

{
  # Configuration files
  home.file = {
    # Hyprland configuration
    ".config/hypr" = {
      source = ./configs/hypr;
      recursive = true;
    };
    
    # Waybar configuration
    ".config/waybar" = {
      source = ./configs/waybar;
      recursive = true;
    };
    
    # Wofi configuration
    ".config/wofi" = {
      source = ./configs/wofi;
      recursive = true;
    };
    
    # SwayNC configuration
    ".config/swaync" = {
      source = ./configs/swaync;
      recursive = true;
    };
    
    # Ghostty configuration
    ".config/ghostty" = {
      source = ./configs/ghostty;
      recursive = true;
    };
    
    # GPU fan control script
    "gpu-fan-control.sh" = {
      source = ./scripts/gpu-fan-control.sh;
      executable = true;
    };
    
    # Screenshot script
    "screenshot.sh" = {
      source = ./scripts/screenshot.sh;
      executable = true;
    };
  };
}
