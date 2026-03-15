{ config, pkgs, ... }:
let
  myaliases = {
    ll = "ls -la";

    ".." = "cd ..";
    
    "nrs" = "sudo nixos-rebuild switch --flake /home/pegion/.nixdots/#yoga14";

    "hms" = "home-manager switch --flake /home/pegion/.nixdots";

    "icat" = "kitty +kitten icat";

    "cd" = "z"; 
    "cdi" = "zi";
  };

in
{
  programs.zsh.initContent = ''
    purify-nix-btw() {
      sudo nix-env --delete-generations +2 --profile /nix/var/nix/profiles/system
      home-manager expire-generations -1days
      sudo nix-collect-garbage -d
      sudo nix-store --optimise
    }

    purify-nix-all() {
      sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
      nix-env --delete-generations old
      home-manager expire-generations 0days
      rm -rf ~/.cache/nix
      sudo nix-collect-garbage -d
      sudo nix-store --optimise
    }

    purify-nix-nuclear() {
      sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
      nix-env --delete-generations old
      home-manager expire-generations 0days
      sudo \'rm -rf /nix/var/nix/gcroots/per-user/*\'
      rm -rf ~/.cache/nix ~/.cache/nix/eval-cache
      sudo nix-collect-garbage -d
      sudo nix-store --gc
      sudo nix-store --optimise
    }
  '';

  home.username = "pegion";
  home.homeDirectory = "/home/pegion";

  home.stateVersion = "25.11";

  home.file.".xinitrc".source = ./x/.xinitrc;

  ################
  # Packages
  ################

  home.packages = with pkgs; [
    kitty
    broot
    zoxide
    firefox
    fzf
    ripgrep
    bat
    mpv
    pamixer
    brightnessctl
    redshift
    xev
    blueman
    curl
    feh
    tmux
    scrot
    kdePackages.dolphin
    kdePackages.kio-admin
    vivaldi
    google-chrome
    brave
    zoom-us
    ffmpeg
    qtox
    localsend
    vscode.fhs
    thunderbird
    discord
    sioyek
    qrcp
    yazi
    qimgv
    libreoffice
    appimage-run

    xdotool
    dwmblocks
    touchegg

    nerd-fonts.jetbrains-mono
  ];
  
  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };


  ################
  # dwmblocks
  ################
  home.file.".config/dwmblocks/config.h".source = ./dwmblocks/config.h;
  
  home.file.".config/dwmblocks/scripts/volume".source = ./dwmblocks/scripts/volume;
  home.file.".config/dwmblocks/scripts/volume".executable = true;

  home.file.".config/dwmblocks/scripts/network".source = ./dwmblocks/scripts/network;
  home.file.".config/dwmblocks/scripts/network".executable = true;

  home.file.".config/dwmblocks/scripts/memory".source = ./dwmblocks/scripts/memory;
  home.file.".config/dwmblocks/scripts/memory".executable = true;
  
  home.file.".config/dwmblocks/scripts/cputemp".source = ./dwmblocks/scripts/cputemp;
  home.file.".config/dwmblocks/scripts/cputemp".executable = true;
  
  home.file.".config/dwmblocks/scripts/battery".source = ./dwmblocks/scripts/battery;
  home.file.".config/dwmblocks/scripts/battery".executable = true;
  
  home.file.".config/dwmblocks/scripts/datetime".source = ./dwmblocks/scripts/datetime;
  home.file.".config/dwmblocks/scripts/datetime".executable = true;

  ################
  # Bash
  ################

  programs.bash = {
    enable = true;

    shellAliases = myaliases;
  };

  ################
  # Zsh
  ################

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
    shellAliases = myaliases;
  };

  ################
  # vim 
  ################
  programs.vim = {
    enable = true;
    extraConfig = ''
      set number
      set expandtab
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set clipboard=unnamedplus
      set noerrorbells
      set novisualbell
    '';
  };

  ################
  # neovim 
  ################
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-colorizer-lua
    ];
  };
  home.file.".config/nvim".source = ./nvim;

  ################
  # kitty 
  ################
  programs.kitty = {
    enable = true;
    # extraConfig = ''
    #   confirm_os_window_close 0
    #   map ctrl+backspace send_text all \x17
    #   enable_audio_bell no
    #   scrollback_fill_enlarged_window yes
    # '';
  };
  home.file.".config/kitty".source = ./kitty;
  
  ################
  # tmux 
  ################
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g terminal-overrides ",xterm-kitty:Tc"
      set -g status-bg "#3f5c4c"
      set -g status-fg "#232424"
      set -g mouse on
      set -g default-terminal "tmux-256color"
    '';
  };

  ################
  # picom 
  ################
  home.file.".config/picom/picom.conf".source = ./picom/picom.conf;

  ################
  # broot 
  ################

  programs.broot = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  ################
  # zoxide 
  ################

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  ################
  # Clipboard manager
  ################

  services.copyq = {
    enable = true;
    systemdTarget = "xsession.target";
  };

  ################
  # touchegg 
  ################
  home.file.".config/touchegg/touchegg.conf".source = ./touchegg/touchegg.conf;

  ################
  # Cursor
  ################
  
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 14;

    gtk.enable = true;
    x11.enable = true;
  };

  ################
  # Home manager
  ################

  programs.home-manager.enable = true;
}
