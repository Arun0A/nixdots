// color scheme for green_void.png
static const char col_gray3[]       = "#e9e9e9"; /* Silver */
static const char col_gray4[]       = "#c0c0c0"; /* Gallery */
static const char col_mingreen[]    = "#9c9c9c"; /* Mineral Green */
static const char col_shark[]       = "#070707"; /* Shark */

static const char col_dmenu_nb[] = "#070707"; /* Shark */
static const char col_dmenu_nf[] = "#e9e9e9"; /* Silver */
static const char col_dmenu_sb[] = "#9c9c9c"; /* Mineral Green */
static const char col_dmenu_sf[] = "#070707"; /* Shark */

static const char *colors[][3]      = {
    /*               fg            bg            border       */
    [SchemeNorm] = { col_gray3,    col_shark,    col_shark     },
    [SchemeSel]  = { col_shark,    col_mingreen, col_mingreen  },
    [SchemeHid]  = { col_gray4, col_shark,    col_mingreen  },
};
