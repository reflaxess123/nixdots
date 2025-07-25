{ config, pkgs, ... }:

{
  imports = [
    ./programs.nix
    ./gui.nix
    ./dotfiles.nix
    ./devtools.nix
  ];

  home.stateVersion = "25.05";

  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    # cursorTheme is managed by home.pointerCursor now
  };

  # Cursor theme configuration
  home.pointerCursor = {
    package = pkgs.apple-cursor;
    name = "macOS"; # Let's stick with this name for now
    size = 24;
  };

  # Desktop environment settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
      cursor-theme = "macOS"; # And here
      icon-theme = "Adwaita";
    };
  };

  # Environment variables for consistent theming
  home.sessionVariables = {
    GTK_THEME = "Adwaita-dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    QT_QPA_PLATFORMTHEME = "gtk3";
    XCURSOR_THEME = "macOS"; # And here
    XCURSOR_SIZE = "24";
    # Force applications to respect GTK theme
    GTK2_RC_FILES = "/home/crack/.gtkrc-2.0";
    # Chrome/Chromium theming
    CHROME_EXECUTABLE = "google-chrome-stable --force-dark-mode --enable-features=WebUIDarkMode";
  };
}
