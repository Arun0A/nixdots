{ config, pkgs, lib, ... }:

# AmneziaWG tunnel (WARP over DPI-obfuscated WireGuard) for restrictive campus networks.
# Uses the userspace amneziawg-go implementation, so no kernel module is built.
# Tunnel config lives in /etc/amnezia/amneziawg/awg0.conf (created by hand).

{
  # The official warp-cli daemon is blocked on campus and fights over routes/DNS.
  services.cloudflare-warp.enable = lib.mkForce false;

  environment.systemPackages = [
    pkgs.amneziawg-tools
    pkgs.amneziawg-go
  ];

  systemd.services.awg0 = {
    description = "AmneziaWG WARP tunnel (awg0)";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    # not started at boot; run: sudo systemctl start awg0
    path = with pkgs; [
      amneziawg-tools
      amneziawg-go
      iproute2
      nftables
      procps
      coreutils
      gnugrep
      gnused
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.amneziawg-tools}/bin/awg-quick up awg0";
      ExecStop = "${pkgs.amneziawg-tools}/bin/awg-quick down awg0";
    };
  };
}
