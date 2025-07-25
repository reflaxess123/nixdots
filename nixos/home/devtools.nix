{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Development tools
    git vim neovim tmux nodejs gcc wget curl unzip vscode ripgrep fd python3
    cmake poetry lazygit bat
    
    # Development tools
    zsh-syntax-highlighting
    zsh-autosuggestions
    fzf
    bar
    eza
    docker
    yazi
  ];
}
