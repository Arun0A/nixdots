// color scheme for green_void.png

static const char col_hiddenfg[]    = "#4c3c0b"; /* brown */
static const char col_mingreen[]    = "#7a6702"; /* dark yellow */
static const char col_textfg[]      = "#f3ec36"; /* dark yellow */
static const char col_shark[]       = "#232424"; /* Shark */

static const char col_dmenu_nb[] = "#232424"; /* Shark */
static const char col_dmenu_nf[] = "#090907"; /* Silver */
static const char col_dmenu_sb[] = "#7a6702"; /* Mineral Green */
static const char col_dmenu_sf[] = "#232424"; /* Shark */

static const char *colors[][3]      = {
    /*               fg         bg         border   */
    [SchemeNorm] = { col_textfg, col_shark,        col_shark     },
    [SchemeSel]  = { col_shark, col_mingreen,  col_mingreen  },
    [SchemeHid]  = { col_hiddenfg, col_shark,  col_mingreen  },
};
