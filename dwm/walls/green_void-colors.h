// color scheme for green_void.png 
static const char col_gray1[]       = "#222222"; /* Mine Shaft */
static const char col_gray2[]       = "#444444"; /* Tundora */ 
static const char col_gray3[]       = "#bbbbbb"; /* Silver */
static const char col_gray4[]       = "#eeeeee"; /* Gallery */
static const char col_cyan[]        = "#005577"; /* Orient */

static const char col_mingreen[]    = "#3f5c4c"; /* Mineral Green */
static const char col_shark[]       = "#232424"; /* Shark */

static const char *colors[][3]      = {
	/*               fg         bg         border   */
/*
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
*/
	[SchemeNorm] = { col_gray3, col_shark, 	   col_shark     },
	[SchemeSel]  = { col_gray4, col_mingreen,  col_mingreen  },
	[SchemeHid]  = { col_mingreen, col_shark,  col_mingreen  },
};
