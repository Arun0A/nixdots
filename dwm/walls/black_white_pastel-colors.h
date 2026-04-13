// color scheme for green_void.png 
static const char col_gray1[]       = "#222222"; /* Mine Shaft */
static const char col_gray2[]       = "#444444"; /* Tundora */ 
static const char col_gray3[]       = "#e9e9e9"; /* Silver */
static const char col_gray4[]       = "#c0c0c0"; /* Gallery */
static const char col_cyan[]        = "#005577"; /* Orient */

static const char col_mingreen[]    = "#9c9c9c"; /* Mineral Green */
static const char col_shark[]       = "#070707"; /* Shark */

static const char *colors[][3]      = {
	/*               fg            bg            border       */
	[SchemeNorm] = { col_gray3,    col_shark, 	 col_shark     },
	[SchemeSel]  = { col_shark,    col_mingreen, col_mingreen  },
	[SchemeHid]  = { col_gray4, col_shark,    col_mingreen  },
};
