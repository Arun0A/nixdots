/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */

/* static const char *fonts[]          = { "monospace:size=10" }; */
static const char *fonts[] = {
    "JetBrainsMonoNLNerdFont-Regular:size=10:antialias=true:autohint=true",
    "JetBrainsMonoNLNerdFont-Regular:size=10:antialias=true:autohint=true"
};
/* static const char dmenufont[]       = "monospace:size=10"; */
static const char dmenufont[]       = "JetBrainsMonoNLNerdFont-Regular:size=10";

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
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
static const int refreshrate = 120;  /* refresh rate (per second) for client move/resize */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask // Alt Key
#define SUPKEY Mod4Mask // Win Key
#define TAGKEYS(KEY,TAG) \
	{ SUPKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ SUPKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ SUPKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ SUPKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
// static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_shark, "-nf", col_gray3, "-sb", col_mingreen, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "kitty", NULL };
static const char *brupcmd[]  = { "brightnessctl", "set", "10%+", NULL};
static const char *brdncmd[]  = { "brightnessctl", "set", "10%-", NULL};

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ SUPKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ SUPKEY,                       XK_b,      togglebar,      {0} },
	{ SUPKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ SUPKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ SUPKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ SUPKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ SUPKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ SUPKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ SUPKEY,                       XK_Return, zoom,           {0} },
	{ SUPKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ SUPKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ SUPKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ SUPKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ SUPKEY,                       XK_space,  setlayout,      {0} },
	{ SUPKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ SUPKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ SUPKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ SUPKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ SUPKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ SUPKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ SUPKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	{ SUPKEY|ShiftMask,             XK_l,      spawn,          SHCMD("slock & sleep 0.1 && xset dpms force off") },
	{ 0,			XF86XK_MonBrightnessUp,    spawn,          {.v = brupcmd}},
	{ 0,			XF86XK_MonBrightnessDown,    spawn,          {.v = brdncmd}},
	{ 0, 			XF86XK_AudioLowerVolume,   spawn, 	SHCMD("pamixer -d 5; ~/nix-dots/dwm/vol_update.sh") },
	{ 0, 			XF86XK_AudioRaiseVolume,   spawn, 	SHCMD("pamixer -i 5; ~/nix-dots/dwm/vol_update.sh") },
	{ 0, 			XF86XK_AudioMute,  	 spawn, 	SHCMD("pamixer --toggle-mute; ~/nix-dots/dwm/vol_update.sh" ) },
	{ 0, 			XF86XK_AudioMicMute,  	 spawn, 	SHCMD("pactl set-source-mute @DEFAULT_SOURCE@ toggle; ~/nix-dots/dwm/vol_update.sh" ) },
	{ 0, 			XK_Print,  	 spawn, 	SHCMD("scrot -z -s -f -e 'xclip -selection clipboard -t image/png -i $f' ~/Pictures/screenshots/%Y-%m-%d-%H%M%S.png") },
	TAGKEYS(                        XK_F1,                      0)
	TAGKEYS(                        XK_F2,                      1)
	TAGKEYS(                        XK_F3,                      2)
	TAGKEYS(                        XK_F4,                      3)
	TAGKEYS(                        XK_F5,                      4)
	TAGKEYS(                        XK_F6,                      5)
	TAGKEYS(                        XK_F7,                      6)
	TAGKEYS(                        XK_F8,                      7)
	TAGKEYS(                        XK_F9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         SUPKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         SUPKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         SUPKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            SUPKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            SUPKEY,         Button3,        toggletag,      {0} },
};

