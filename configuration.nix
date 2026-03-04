{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  ################
  # Bootloader
  ################

  boot.loader = {
    timeout = 10;

    efi = {
      efiSysMountPoint = "/boot";
    };

    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      efiInstallAsRemovable = true;

      extraEntries = ''
        menuentry "Reboot" { reboot }
        menuentry "Poweroff" { halt }
      '';
    };
  };

  ################
  # Networking
  ################

  networking.hostName = "void";
  networking.networkmanager.enable = true;

  ################
  # Time
  ################

  time.timeZone = "Asia/Kolkata";
  time.hardwareClockInLocalTime = true;

  ################
  # Bluetooth
  ################

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  ################
  # X11 + DWM
  ################

  services.xserver = {
    enable = true;

    autoRepeatDelay = 200;
    autoRepeatInterval = 35;

    displayManager.startx.enable = true;

    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs {
        src = ./dwm;
      };
    };
  };

  ################
  # User
  ################

  users.users.pegion = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  ################
  # System packages
  ################

  environment.systemPackages = with pkgs; [
    wget
    git
    vim
    fastfetch
    htop

    kitty
    firefox

    xorg.xinit
    xorg.xrandr
    xorg.xsetroot
    dmenu

    yazi

    bluez
    blueman
  ];

  ################
  # Nix settings
  ################

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  ################
  # System version
  ################

  system.stateVersion = "25.11";
}
