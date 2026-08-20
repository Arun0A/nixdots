// color scheme for rain_world.png
static const char col_gray4[]       = "#829c84"; /* Gallery */
static const char col_mingreen[]    = "#cc784e"; /* Mineral Green */
static const char col_shark[]       = "#2d0723"; /* Shark */

static const char col_dmenu_nb[] = "#2d0723"; /* Shark */
static const char col_dmenu_nf[] = "#d99f7e"; /* Silver */
static const char col_dmenu_sb[] = "#cc784e"; /* Mineral Green */
static const char col_dmenu_sf[] = "#2d0723"; /* Shark */

static const char *colors[][3]      = {
    /*               fg            bg            border       */
    [SchemeNorm] = { col_mingreen,    col_shark,     col_shark     },
    [SchemeSel]  = { col_shark,    col_mingreen, col_mingreen  },
    [SchemeHid]  = { col_gray4, col_shark,    col_mingreen  },
};
