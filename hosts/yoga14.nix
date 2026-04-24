{ ... }:

{
  # Remap the Lenovo "ThinkBook Yoga14 extra buttons" scan codes at the kernel/udev
  # layer so X sees normal function keys and dwm can bind them.
  services.udev.extraHwdb = ''
    evdev:input:b0019v0000p0000e0000-e0,1,4,k89,8A,94,95,BA,CA,CB,D4,E3,F0,F7,F8,16C,1BD,1BE,212,213,214,232,26A,27A,ram4,lsfw
      KEYBOARD_KEY_101=f13
      KEYBOARD_KEY_10e=f14
      KEYBOARD_KEY_10f=delete

    evdev:name:Ideapad extra buttons:dmi:bvn*:bvr*:bd*:svnLENOVO*:pn21DM*:*
      KEYBOARD_KEY_101=f13
      KEYBOARD_KEY_10e=f14
      KEYBOARD_KEY_10f=delete
  '';
}
