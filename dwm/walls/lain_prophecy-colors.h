// color scheme for lain_prophecy.jpg
static const char col_selfg[]    = "#fefbd8"; /* Silver */
static const char col_hidfg[]    = "#914f3e"; /* Gallery */
static const char col_norfg[]    = "#914f3e"; /* Mineral Green */
static const char col_bg[]       = "#020202"; /* Shark */

static const char col_dmenu_nb[] = "#020202"; /* Shark */
static const char col_dmenu_nf[] = "#914f3e"; /* Shark */
static const char col_dmenu_sb[] = "#020202"; /* Mineral Green */
static const char col_dmenu_sf[] = "#fefbd8"; /* Silver */

static const char *colors[][3]      = {
    /*               fg            bg         border     */
    [SchemeNorm] = { col_norfg,    col_bg,    col_bg   },
    [SchemeSel]  = { col_selfg,    col_bg,    col_hidfg   },
    [SchemeHid]  = { col_hidfg,    col_bg,    col_hidfg   },
};
