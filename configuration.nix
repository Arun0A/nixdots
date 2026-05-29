{ config, pkgs, inputs, lib, nixpkgs-unstable, ... }:

let
  pkgsUnstable = nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  services.logind.settings.Login.HandlePowerKey = "suspend";

  # tty greeting
  services.getty.greetingLine = "";
  # help line
  environment.etc."issue".text = ''<< If you are reading this, it is probably not your device. Return it to the OWNER : Arun Bhattacharya (arun0a_in@hotmail.com) >>
\d | \t | \l

  '';


  ################
  # Bootloader
  ################

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [
    "quiet"
    "loglevel=0"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
    "v4l2loopback.devices=2"
    "v4l2loopback.video_nr=1,2"
    "v4l2loopback.card_label=DroidCam,OBSCam"
    "v4l2loopback.exclusive_caps=1"
  ];
  boot.consoleLogLevel = lib.mkForce 0;
  boot.initrd.verbose = true;

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=2 video_nr=1,2 \
      card_label="DroidCam","OBSCam" \
      exclusive_caps=1
  '';

  boot.loader = {
    timeout = 10;

    systemd-boot.enable = false;

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

  boot.kernelModules = [ "coretemp" "v4l2loopback" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  ################
  # Networking
  ################

  networking.hostName = "void";
  networking.networkmanager.enable = true;

  networking.networkmanager.wifi.powersave = false;

  services.cloudflare-warp.enable = true;
  services.resolved.enable = true;
  networking.nameservers = [ "100.100.100.100" "1.1.1.1" "1.0.0.1" ];
  networking.search = [ "feist-arctic.ts.net" ];

  services.tailscale.enable = true;
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" "virbr0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    allowedTCPPorts = [ 8443 ];
  };

  # 2. Force tailscaled to use nftables (Critical for clean nftables-only systems)
  # This avoids the "iptables-compat" translation layer issues.
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  # 3. Optimization: Prevent systemd from waiting for network online
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  ################
  # fmd-server
  ################
  environment.etc."fmd-server/config.yml".text = ''
    DatabaseDir: "/var/lib/fmd-server/db"

    PortSecure: 8443
    PortInsecure: -1

    ServerCrt: "/var/lib/fmd-server/certs/void.feist-arctic.ts.net.crt"
    ServerKey: "/var/lib/fmd-server/certs/void.feist-arctic.ts.net.key"
  '';
  systemd.services.fmd-server = {
    description = "Find My Device Server";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgsUnstable.fmd-server}/bin/fmd-server serve -c /etc/fmd-server/config.yml";
      Restart = "always";
      StateDirectory = "fmd-server";
    };
  };

  ################
  # Battery
  ################
  # Disable if devices take long to unsuspend (keyboard, mouse, etc)
  powerManagement.powertop.enable = true;
  services = {
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        STOP_CHARGE_THRESH_BAT1 = 95;
      };
    };
  };

  ################
  # Pipewire
  ################

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    wireplumber.enable = true;
  };

  security.rtkit.enable = true;

  ################
  # Time
  ################

  time.timeZone = "Asia/Kolkata";
  time.hardwareClockInLocalTime = false;

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
  services.touchegg.enable = true;

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
          # ./dwm/patches/dwm-hide_vacant_tags-6.4.diff
          # ./dwm/patches/dwm-movestack-20211115-a786211.diff # applied manually
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
    extraGroups = [ "wheel" "input" "video" "audio" "libvertd" "kvm" "dialout" ];
    shell = pkgs.zsh;
  };

  ################
  # System packages
  ################

  environment.systemPackages = with pkgs; [
    pkgs.home-manager

	nixd

    wget
    git
    vim
    fastfetch
    htop
    unzip
    p7zip
    zsh
    udisks2

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
    python314

    bluez
    blueman
    logiops
    obs-studio
    droidcam

    cloudflare-warp
    evtest

    pulseaudio
    lm_sensors
    pavucontrol
    v4l-utils
    pipewire

    virt-manager
    qemu
    virt-viewer
    spice
    spice-gtk
    polkit_gnome

    wineWowPackages.stable
    winetricks
    mangohud
    protonup-qt
    lutris
    bottles

  ];

  environment.variables.EDITOR = "vim";
  environment.variables.VISUAL = "vim";

  programs.slock.enable = true;

  programs.zsh.enable = true;

  services.udisks2.enable = true;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
    ];
  };

  ################
  # logiops
  ################
  # Create systemd service
  systemd.services.logiops = {
    description = "Logitech Configuration Daemon";
    wantedBy = [ "graphical.target" ];
    startLimitIntervalSec = 0;
    after = [ "graphical.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.logiops}/bin/logid";
      User = "root";
    };
  };

  # Add a `udev` rule to restart `logiops` when the mouse is connected
  # https://github.com/PixlOne/logiops/issues/239#issuecomment-1044122412
  services.udev.extraRules = ''
    ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{manufacturer}=="Logitech", ATTRS{model_name}=="MX Anywhere 3S", RUN{program}="${pkgs.systemd}/bin/systemctl --no-block try-restart logiops.service"
  '';

  # Configuration for logiops
  environment.etc."logid.cfg".text = ''
    devices: ({
      name: "MX Anywhere 3S";

      smartshift: {
        on: true;
        threshold: 255;
      };

      hiresscroll: {
        hires: true;
        invert: false;
        target: false;
        multiplier: 1.5;
      };

      dpi: 1200;

      buttons: (

        {
          cid: 0x53; # BTN_SIDE (side_back)
          action = {
            type: "Keypress";
            keys: ["KEY_LEFTMETA"];
          };
        },

        {
          cid: 0x56; # BTN_EXTRA (side_front)
          action = {
            type: "Keypress";
            keys: ["KEY_SYSRQ"];
          };
        },

        {
          cid: 0xc4; # BTN_TOP (top_button)
          action = {
            type: "Keypress";
            keys: ["KEY_DELETE"];
          };
        }

        # {
        #   cid: 0xd7;
        #   action = {
        #     type: "Keypress";
        #     keys: [""];
        #   };
        # },

        # {
        #   cid: 0x52; # BTN_MIDDLE
        #   action = {
        #     type: "Keypress";
        #     keys: [""];
        #   };
        # }

      );
    });
  '';

  ################
  # Nix settings
  ################

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # For LSP
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  ################
  # Gaming
  ################

  hardware.graphics.enable = true;

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  ################
  # System version
  ################

  nixpkgs.config.allowUnfree = true;
  
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
      # X11
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
      xorg.libXinerama
      xorg.libXrender
      xorg.libXext
      xorg.libXfixes
      # graphics
      libGL
      mesa
      # audio
      alsa-lib
      libpulseaudio
      # common runtime junk many apps expect
      stdenv.cc.cc
      zlib
      openssl
      curl
      glib
      gtk3
      freetype
      fontconfig
      # optional but often useful
      SDL2
      vulkan-loader
    ];

    system.stateVersion = "25.11";
}
