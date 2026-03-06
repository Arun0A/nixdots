{ config, pkgs, ... }:

{
  home.username = "pegion";
  home.homeDirectory = "/home/pegion";

  home.stateVersion = "25.11";

  ################
  # Packages
  ################

  home.packages = with pkgs; [
    kitty
    yazi
    firefox
    neovim
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
    vivaldi
    google-chrome

    fusuma
    xdotool

    nerd-fonts.jetbrains-mono
  ];
  
  fonts.fontconfig.enable = true;

  ################
  # Bash
  ################

  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -la";
      ".." = "cd ..";
      "nrs" = "sudo nixos-rebuild switch --flake /home/pegion/nix-dots/#yoga14";
      "hms" = "home-manager switch --flake /home/pegion/nix-dots";
      "purify-nix-btw" = "sudo nix-env --delete-generations +2 --profile /nix/var/nix/profiles/system && home-manager expire-generations \"-1 days\" && sudo nix-collect-garbage -d && sudo nix-store --optimise";
      "purify-nix-all" = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system && home-manager expire-generations \"-0 days\" && sudo nix-collect-garbage -d && sudo nix-store --optimise";
    };
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
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set -g status-bg "#3f5c4c"
      set -g status-fg "#232424"
      set -g mouse on
    '';
  };

  ################
  # Clipboard manager
  ################

  services.copyq = {
    enable = true;
    systemdTarget = "xsession.target";
  };

  ################
  # fusuma
  ################
  services.fusuma = {
    enable = true;
    settings = {
      device = {
        name = "ELAN06FA";
      };
      gesture = {
        pinch = {
          "in" = {
            command = "xdotool key ctrl+equal";
          };
          "out" = {
            command = "xdotool key ctrl+minus";
          };
        };
      };
    };
  };

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
  nixpkgs.config.allowUnfree = true;
}
