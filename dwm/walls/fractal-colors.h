// color scheme for fractal.png 
static const char col_gray1[]       = "#3177ce"; /* Mine Shaft */
static const char col_gray2[]       = "#444444"; /* Tundora */ 
static const char col_gray3[]       = "#3177ce"; /* Silver */
static const char col_gray4[]       = "#664e98"; /* Gallery */
static const char col_cyan[]        = "#005577"; /* Orient */
static const char col_mingreen[]    = "#30cd59"; /* Mineral Green */
static const char col_shark[]       = "#000000"; /* Shark */

static const char *colors[][3]      = {
	/*               fg            bg            border       */
	[SchemeNorm] = { col_gray1,    col_shark, 	 col_shark     },
	[SchemeSel]  = { col_mingreen,    col_shark, col_mingreen  },
	[SchemeHid]  = { col_gray4, col_shark,    col_gray1  },
};
