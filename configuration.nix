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

  boot.kernelModules = [ "coretemp" ];

  ################
  # Networking
  ################

  networking.hostName = "void";
  networking.networkmanager.enable = true;

  networking.networkmanager.wifi.powersave = false;

  services.cloudflare-warp.enable = true;
  # services.resolved.enable = false;
  # networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

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

    xkb.options = "caps:ctrl_modifier";
    autoRepeatDelay = 350;
    autoRepeatInterval = 35;

    displayManager.startx.enable = true;

    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs {
        src = ./dwm;
        patches = [
          ./dwm/patches/dwm-tab-v2b-20210810-7162335.diff
        ];
      };
    };
  };

  ################
  # Fonts 
  ################
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      freefont_ttf
      source-code-pro
      fira-code
      fira-code-symbols
      ubuntu-classic
    ];
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
    unzip

    xorg.xinit
    xorg.xrandr
    xorg.xsetroot
    dmenu
    xclip
    slock

    bluez
    blueman

    cloudflare-warp
    evtest

    pulseaudio
    lm_sensors
    pavucontrol
  ];

  programs.slock.enable = true;

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

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}
