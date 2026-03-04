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
  ];

  ################
  # Bash
  ################

  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -la";
      ".." = "cd ..";
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
    '';
  };

  ################
  # Clipboard manager
  ################

  services.copyq = {
    enable = true;
    systemdTarget = "x-session.target";
  };

  ################
  # Home manager
  ################

  programs.home-manager.enable = true;
}
