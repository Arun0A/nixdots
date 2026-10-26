// color scheme for lain_prophecy.jpg
static const char col_selfg[]    = "#7e8655";
static const char col_hidfg[]    = "#3c3f45";
static const char col_norfg[]    = "#404886";
static const char col_bg[]       = "#020202";

static const char col_dmenu_nb[] = "#020202";
static const char col_dmenu_nf[] = "#404886";
static const char col_dmenu_sb[] = "#020202";
static const char col_dmenu_sf[] = "#7e8655";

static const char *colors[][3]      = {
    /*               fg            bg         border     */
    [SchemeNorm] = { col_norfg,    col_bg,    col_bg   },
    [SchemeSel]  = { col_selfg,    col_bg,    col_norfg   },
    [SchemeHid]  = { col_hidfg,    col_bg,    col_norfg   },
};
