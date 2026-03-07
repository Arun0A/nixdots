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

      theme = ./grub-themes/OldBIOS;
      splashImage = null;

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
  # Virtualisation
  ################

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  security.polkit.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  ################
  # X11 + DWM
  ################

  services.libinput.enable = true;

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
          # ./dwm/patches/dwm-tab-v2b-20210810-7162335.diff
          ./dwm/patches/dwm-hide_vacant_tags-6.4.diff
        ];
      };
    };
  };

  services.picom = {
    enable = true;
    backend = "xrender";
    vSync = true;
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
      corefonts
      liberation_ttf
      dejavu_fonts
    ];
  };

  ################
  # User
  ################

  users.users.pegion = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "video" "audio" "libvertd" "kvm" ];
    shell = pkgs.zsh;
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
    zsh
    localsend

    slock
    xorg.xinit
    xorg.xrandr
    xorg.xsetroot
    dmenu
    xclip
    picom
    libinput
    gcc
    cmake

    bluez
    blueman

    cloudflare-warp
    evtest

    pulseaudio
    lm_sensors
    pavucontrol

    virt-manager
    qemu
    virt-viewer
    spice
    spice-gtk
    polkit_gnome

  ];

  environment.variables.EDITOR = "vim";
  environment.variables.VISUAL = "vim";

  programs.slock.enable = true;

  programs.zsh.enable = true;

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
