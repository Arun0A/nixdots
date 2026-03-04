{ config, pkgs, ... }:

{
  home.username = "pegion";
  home.homeDirectory = "/home/pegion";

  home.stateVersion = "25.11";

  ################
  # Packages
  ################

  home.packages = with pkgs; [
    hello
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
