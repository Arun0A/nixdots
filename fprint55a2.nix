{ config, lib, pkgs, ... }:

{
  services.fprintd.enable = false;

  systemd.services.fprintd.environment.LD_LIBRARY_PATH =
    "/opt/fprint55a2/lib";

  security.pam.services.sudo.fprintAuth = false;

  security.pam.services.slock = {};
  security.pam.services.slock.fprintAuth = false;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("net.reactivated.fprint.device") == 0 &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';
}
