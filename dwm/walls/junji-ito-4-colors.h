// color scheme for fractal.png 
static const char col_gray1[]       = "#d2c2a9"; /* Mine Shaft */
static const char col_gray2[]       = "#4f331b"; /* Tundora */ 
static const char col_gray3[]       = "#a68b6e"; /* Silver */
static const char col_gray4[]       = "#664e98"; /* Gallery */
static const char col_cyan[]        = "#005577"; /* Orient */
static const char col_mingreen[]    = "#30cd59"; /* Mineral Green */
static const char col_shark[]       = "#000000"; /* Shark */

static const char *colors[][3]      = {
	/*               fg            bg            border       */
	[SchemeNorm] = { col_gray1,    col_shark, 	 col_shark     },
	[SchemeSel]  = { col_shark,    col_gray3,    col_gray1  },
	[SchemeHid]  = { col_gray3,    col_shark,    col_gray3  },
};
