static const Block blocks[] = {
  /* icon  command                                   interval  signal */
  { "",    "$HOME/.config/dwmblocks/scripts/volume",  0,        1 },
  { "",    "$HOME/.config/dwmblocks/scripts/network", 10,       2 },
  { "",    "$HOME/.config/dwmblocks/scripts/memory",  5,        3 },
  { "",    "$HOME/.config/dwmblocks/scripts/cputemp", 5,        4 },
  { "",    "sh -x $HOME/.config/dwmblocks/scripts/battery", 5,        5 },
  { "",    "$HOME/.config/dwmblocks/scripts/datetime",1,        6 },
};

static char delim[] = " | ";
