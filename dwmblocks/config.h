#ifndef CONFIG_H
#define CONFIG_H

#define DELIMITER " | "
#define MAX_BLOCK_OUTPUT_LENGTH 45
#define CLICKABLE_BLOCKS 1
#define LEADING_DELIMITER 0
#define TRAILING_DELIMITER 0

#define BLOCKS(X) \
    X("", "~/.config/dwmblocks/scripts/volume", 0, 1) \
    X("", "~/.config/dwmblocks/scripts/network", 10, 2) \
    X("", "~/.config/dwmblocks/scripts/memory", 5, 3) \
    X("", "~/.config/dwmblocks/scripts/cputemp", 5, 4) \
    X("", "~/.config/dwmblocks/scripts/battery", 5, 5) \
    X("", "~/.config/dwmblocks/scripts/datetime", 1, 6)
#endif
