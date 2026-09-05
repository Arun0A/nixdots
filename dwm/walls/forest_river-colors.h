// color scheme for forest_river.jpg
static const char col_gray3[]       = "#babbb4"; 
static const char col_gray4[]       = "#8b99a1"; 
static const char col_mingreen[]    = "#2c3838"; 
static const char col_shark[]       = "#140f13"; 

static const char col_dmenu_nb[] = "#140f13"; 
static const char col_dmenu_nf[] = "#8b99a1"; 
static const char col_dmenu_sb[] = "#2c3838"; 
static const char col_dmenu_sf[] = "#babbb4"; 

static const char *colors[][3]      = {
    /*               fg         bg            border       */
    [SchemeNorm] = { col_gray3, col_shark,    col_shark    },
    [SchemeSel]  = { col_gray3, col_mingreen, col_mingreen },
    [SchemeHid]  = { col_gray4, col_shark,    col_mingreen },
};
