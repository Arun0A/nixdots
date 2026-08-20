// color scheme for junji-ito-4.jpg
static const char col_gray1[]       = "#d2c2a9"; /* Mine Shaft */
static const char col_gray3[]       = "#a68b6e"; /* Silver */
static const char col_shark[]       = "#000000"; /* Shark */

static const char col_dmenu_nb[] = "#000000"; /* Shark */
static const char col_dmenu_nf[] = "#a68b6e"; /* Silver */
static const char col_dmenu_sb[] = "#d2c2a9"; /* Mineral Green */
static const char col_dmenu_sf[] = "#000000"; /* Shark */

static const char *colors[][3]      = {
    /*               fg            bg            border       */
    [SchemeNorm] = { col_gray1,    col_shark,    col_shark     },
    [SchemeSel]  = { col_shark,    col_gray3,    col_gray1  },
    [SchemeHid]  = { col_gray3,    col_shark,    col_gray3  },
};
