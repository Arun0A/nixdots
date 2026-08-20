// color scheme for junji-ito-2.jpg
static const char col_gray1[]       = "#eddfc4"; /* Mine Shaft */
static const char col_gray3[]       = "#242a40"; /* Silver */
static const char col_gray4[]       = "#49515c"; /* Gallery */
static const char col_mingreen[]    = "#fff9dc"; /* Mineral Green */
static const char col_shark[]       = "#010217"; /* Shark */

static const char col_dmenu_nb[] = "#010217"; /* Shark */
static const char col_dmenu_nf[] = "#eddfc4"; /* Silver */
static const char col_dmenu_sb[] = "#fff9dc"; /* Mineral Green */
static const char col_dmenu_sf[] = "#010217"; /* Shark */

static const char *colors[][3]      = {
    /*               fg            bg            border       */
    [SchemeNorm] = { col_gray1,    col_shark,    col_shark     },
    [SchemeSel]  = { col_mingreen,    col_gray3,    col_gray1  },
    [SchemeHid]  = { col_gray4,    col_shark,    col_gray3  },
};
