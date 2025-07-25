{ config, pkgs, ... }:

{
  # Shell configuration
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export NPM_CONFIG_PREFIX="$HOME/.npm-global"
      export PATH="$HOME/.npm-global/bin:$PATH"
    '';
  };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "z" "docker" "history" ];
    };
    
    initExtra = ''
      # Basic exports
      export PATH="/sbin:$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
      export NPM_CONFIG_PREFIX="$HOME/.npm-global"
      export EDITOR='nvim'
      export VISUAL='nvim'
      
      # Tool replacements
      alias cat='bat'
      alias ls='eza --icons --group-directories-first'
      alias l='eza --icons --group-directories-first'
      
      # Basic functions
      c() { clear }
      f() { fd . | fzf }
      fa() { fd . --no-ignore --hidden | fzf }
      v() { nvim $(fd . | fzf) }
      va() { nvim $(fd . --no-ignore --hidden | fzf) }
      yy() { yazi }
      cdf() { cd $(fd --type d | fzf) }
      cdfa() { cd $(fd --type d --no-ignore --hidden | fzf) }
      cdh() { cd $HOME }
      hh() { fc -ln 1 | fzf --tac | sh }
      
      # FZF integration
      pf() { ps -ef | fzf }
      rgp() { rg --line-number . | fzf --delimiter ':' --preview 'bat --color=always --highlight-line {2} {1}' }
      gfzf() { git log --oneline | fzf }
      gbf() { git checkout $(git branch | fzf | sed 's/^[ *]*//') }
      ef() { env | fzf }
      myip() { curl ipinfo.io }
      
      # Git aliases
      alias gs='git status'
      gadd() { git add "$@" }
      gcom() { git commit -m "$@" }
      alias gp='git push'
      alias gl='git pull'
      alias gd='git diff'
      
      # NPM
      ni() { npm install "$@" }
      nid() { npm install --save-dev "$@" }
      nr() { npm run "$@" }
      alias nrs='npm run start'
      alias nrd='npm run dev'
      alias nrb='npm run build'
      
      # NIXOS
      nconfig() { sudo nvim /etc/nixos/configuration.nix }
      nrebuild() { sudo nixos-rebuild switch }
      
      # Poetry
      alias pl='poetry lock'
      alias pi='poetry install'
      pr() { poetry run "$@" }
      alias pm='poetry run python main.py'
      
      # Clipboard
      alias clip='wl-paste'
      copy() { echo "$@" | wl-copy }
      
      # Navigation
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      ~() { cd $HOME }
      
      # Tmux
      ta() { tmux attach -t "$@" }
      
      # Cleanup
      clean-node() { rm -rf node_modules }
      clean-logs() { rm -f *.log }
      clean-temp() { rm -rf /tmp/* }
      
      # History with fzf insertion
      hhf() { 
        local cmd=$(fc -ln 1 | fzf --tac --no-sort)
        [[ -n "$cmd" ]] && print -z "$cmd"
      }
      
      # Chrome with proper theming
      chrome-dark() { google-chrome-stable --force-dark-mode --enable-features=WebUIDarkMode "$@" }
      chrome-light() { google-chrome-stable --force-light-mode "$@" }
      
      # Key bindings
      bindkey -s '^e' 'nvim .\n'
      bindkey -s '^g' 'lazygit\n'
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
    userEmail = "crack@example.com";
  };
  
  # NPM configuration
  home.file.".npmrc".text = ''
    prefix=''${HOME}/.npm-global
  '';
  
  # Create npm directory
  home.file.".npm-global/.keep".text = "";
}
