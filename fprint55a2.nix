{ config, lib, pkgs, ... }:

{
  services.fprintd.enable = true;

  systemd.services.fprintd.environment.LD_LIBRARY_PATH =
    "/opt/fprint55a2/lib";

  security.pam.services.sudo.fprintAuth = true;

  security.pam.services.slock = {};
  security.pam.services.slock.fprintAuth = true;
}
