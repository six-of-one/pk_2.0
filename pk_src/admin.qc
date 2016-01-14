// Admin.qc - Remote Administration of a Quake Server
//
// Modified 8/14/96
//
// Doug Keegan
// Rip on IRC/NetQuake
// doug.keegan@tamu.edu

// Cataboligne - advanced admin, 4.11.8

/*  new admin features:

password - unlimited digits, stored in admin.cfg, masked entry
access impulse - stored in admin.cfg
time limit - stored in admin.cfg

menu driven - impulse independent - no longer will you have to keep notes or bind tons of keys
controls bots

*/

// time limit on admin password entry
float admin_time;
float A_TIME = 10; // 10 secs for admin password - if this is not set, admin access attempt becomes free invulnerable state!
float A_DELAY = 30; // time until you can do anything after failing the admin entry - no shooting, no admin!

// Level impulses
float   A_PKHUB  = 21;
float   A_PAINKEEP = 20;
float   A_PK0   = 19;
float   A_PK1   = 01;
float   A_PK2   = 02;
float   A_PK3   = 03;
float   A_PK4   = 04;
float   A_PK5   = 05;
float   A_PK6   = 06;
float   A_PK7   = 07;
float   A_PK8   = 08;
float   A_PK9   = 09;
float   A_PK10  = 10;
float   A_PK11  = 11;
float   A_PK12  = 12;
float   A_PK13  = 13;
float   A_PK14  = 14;
float   A_PK15  = 15;
float   A_PK16  = 16;
float   A_PK17  = 17;
float   A_PK18  = 18;

// link codes
float   A_DMT   = 01;
float   A_TEAMT = 02;
float   A_COOPT = 03;
float   A_NOEX  = 04;
float   A_JUMP  = 05;
float   A_RESET = 06;
float   A_START = 07;
float   A_FRAGL = 10;
float   A_TIMEL = 11;
float   A_GRAVU = 12;
float   A_FRICU = 13;
float   A_DMMAP = 22;
float   A_BOTS  = 23;
float   A_PKCON = 24;
float   A_SKICK = 30;
float   A_PKMOD = 60;


// for external modules

void() admin_resettimeout =
{
	if (self.goalentity.classname == "admintimer") // any input to admin menus resets timeout
		self.goalentity.nextthink = time + pk_admintime;
};

// save flags & mode

void() admin_sv_cfg =
{
	local string str;

	str = ftos(pk_flags);
	if (pk_flags != pk_flags_ck)//cvar("saved1"))
		cvar_set("savedgamecfg", str);
	pk_flags_ck = pk_flags;

	if (pk_admintime > 0) admin_resettimeout();
};

/*
==========
TeamToggle
==========
*/
void() TeamToggle =
{
	if (cvar("teamplay") == 1)
	{
		self.wad = "\nTeam play is OFF...";
		localcmd("teamplay 0\n");
	}
	else
	{
		self.wad = "\nTeam play is ON...";
		localcmd("teamplay 1\n");
	}
};

/*
==========
DMToggle
==========
*/
void() DMToggle =
{
	if (cvar("deathmatch") == 1)
	{
		self.wad = "\nDeathmatch mode = 3...\nYou must restart level for new settings...";
	  localcmd("deathmatch 3\n");
	}
	else
	{
		self.wad = "\nDeathmatch mode = 1...\nYou must restart level for new settings...";
		localcmd("deathmatch 1\n");
	}
};

/*
==========
CoopToggle
==========
*/
void() CoopToggle =
{
	if (cvar("coop") == 1)
	{
		self.wad = "\nCoop is OFF...\nYou must restart level for new settings...";
		localcmd("coop 0\n");
		localcmd("deathmatch 1\n");
	}
	else
	{
		self.wad = "\nCoop is ON...\nYou must restart level for new settings...";
		localcmd("deathmatch 0\n");
		localcmd("coop 1\n");
	}
};

/*
==========
JumptoNext
==========
*/
void() JumptoNext =
{
	local entity ot;
	ot = find(world, classname, "trigger_changelevel");
	if (!ot || mapname == "start")
		self.wad = "\nNextLevel is not defined";
	else
	{
		bprint("Admin executed next level command...\n");
		bot_changelevel(); // *bot - reload bots on next level, handle intermission
		changelevel(ot.map);
	}
};

/*
==========
JumptoNext
==========
*/
void() ResetLevel =
{
	bprint("Admin executed reset level command...\n");
	bot_changelevel(); // *bot - reload bots on next level, handle intermission
	changelevel(mapname);
};

/*
==========
ToggleNoExit
==========
*/
void() ToggleNoExit =
{
	if (cvar("noexit") == 1)
	{
		self.wad = "\nNo Exit is OFF...";
		localcmd("noexit 0\n");
	}
	else
	{
		self.wad = "\nNo Exit is ON...";
		if (cvar("fraglimit") <= 0 && cvar("timelimit") <= 0)
			self.wad = "\nNo Exit is ON...\ntimelimit, fraglimit are 0 - recommend you set one these";
		localcmd("noexit 1\n");
	}
};

/*
==========
variable adjuster
==========
*/
void() Admin_varmenu =
{
	if (self.cnt == 0.01)
	{
	self.message =
					 "\b   Administration Menu:    \n"
					 "\b+-------------------------+\n"
						"      adjust variable      \n"
						" +-----------------------+ \n"
						"  increment     decrement  \n"
						"     1:     0.01     :6    \n"
						"     2:     0.1      :5    \n"
						"     3:     1.0      :4    \n"
						"          by value         \n"
						" +-----------------------+ \n"
						"   7: save modification    \n"
						"   8: enter new value      \n"
						"   9: main menu            \n"
						" admin impulse: exit admin \n"
					 "\b+-------------------------+\n"
					 "\b Enter code: ";
	}
//	if (self.cnt == 1)
	else
	{
	self.message =
					 "\b   Administration Menu:    \n"
					 "\b+-------------------------+\n"
						"      adjust variable      \n"
						" +-----------------------+ \n"
						"  increment     decrement  \n"
						"     1:      1       :6    \n"
						"     2:      10      :5    \n"
						"     3:      100     :4    \n"
						"          by value         \n"
						" +-----------------------+ \n"
						"   7: save modification    \n"
						"   8: enter new value      \n"
						"   9: main menu            \n"
						" admin impulse: exit admin \n"
					 "\b+-------------------------+\n"
					 "\b Enter code: ";
	}
	self.wad = "";
	self.admin = self.lip = 19;
};

/*
==========
MapStart
==========
*/
void() MapStart =
{
	bprint("Admin loaded hub / start map...\n");
	bot_changelevel(); // *bot - reload bots on next level, handle intermission
	changelevel("start");
};

/*
==========
MapDM
==========
*/
void() Admin_dmmapmenu =
{
	self.message =
					 "\b  Painkeep DM map Menu:\n"
					 "\b+------------------------+\n"
						"    01:  pk1    11: pk11  \n"
						"    02:  pk2    12: pk12  \n"
						"    03:  pk3    13: pk13  \n"
						"    04:  pk4    14: pk14  \n"
						"    05:  pk5    15: pk15  \n"
						"    06:  pk6    16: pk16  \n"
						"    07:  pk7    17: pk17  \n"
						"    08:  pk8    18: pk18  \n"
						"    09:  pk9    19: pk0   \n"
						"    10:  pk10   21: hub   \n"
						"    20:  painkeep         \n"
						"   666:  main menu        \n"
						"  admin impulse exits     \n"
					 "\b+------------------------+\n"
					 "\b Enter code: ";

	self.wad = "";
	self.admin = 14;
	self.lefty = 0;
};


float() MapDM =
{
	local string mname;

	if (self.lefty == A_PAINKEEP) mname = "painkeep";
	else if (self.lefty == A_PK0) mname = "pk0";
	else if (self.lefty == A_PK1) mname = "pk1";
	else if (self.lefty == A_PK2) mname = "pk2";
	else if (self.lefty == A_PK3) mname = "pk3";
	else if (self.lefty == A_PK4) mname = "pk4";
	else if (self.lefty == A_PK5) mname = "pk5";
	else if (self.lefty == A_PK6) mname = "pk6";
	else if (self.lefty == A_PK7) mname = "pk7";
	else if (self.lefty == A_PK8) mname = "pk8";
	else if (self.lefty == A_PK9) mname = "pk9";
	else if (self.lefty == A_PK10) mname = "pk10";
	else if (self.lefty == A_PK11) mname = "pk11";
	else if (self.lefty == A_PK12) mname = "pk12";
	else if (self.lefty == A_PK13) mname = "pk13";
	else if (self.lefty == A_PK14) mname = "pk14";
	else if (self.lefty == A_PK15) mname = "pk15";
	else if (self.lefty == A_PK16) mname = "pk16";
	else if (self.lefty == A_PK17) mname = "pk17";
	else if (self.lefty == A_PK18) mname = "pk18";
	else if (self.lefty == A_PKHUB) mname = "start";
	else
		return(FALSE);

	bprint("Admin changing map to ");
	bprint(mname);
	bprint("\n");

	bot_changelevel(); // *bot - reload bots on next level, handle intermission
	changelevel(mname);
	return(TRUE);
};

/*
==========
StartKick
==========
*/
float KICKCODE = -94562375;

void() find_Kick =
{
	self.enemy = find(self.enemy, classname, self.target);
	if (!self.enemy) // end of list - 1st switch
	{
		if (self.target == "player") self.target = "jafo";
		else self.target = "player";
		self.enemy = find(world, classname, self.target);
		if (!self.enemy) // 2nd list no good - try looping
		{
			if (self.target == "player") self.target = "jafo";
			else self.target = "player";
			self.enemy = find(world, classname, self.target);
		}
		if (!self.enemy) Admin_mainmenu(); // nothing found for either search ?? - go back
	}
	self.lefty = 0;
};

void() Admin_kickmenu =
{
	self.message =
					 "\b   Administration Menu:    \n"
					 "\b+-------------------------+\n"
						"   1: kick player ->       \n\n";

	self.lefty = 0;
	if (self.impulse == 1)
	{
		if (self.enemy == self)
		self.wad =
				  "\n\n   3: next player          \n"
						"   7: confirm kick         \n"
						"   6: main menu            \n"
						"  admin impulse exits      \n"
					 "\b+-------------------------+\n"
					 "\b      7 to confirm!        \n any other entry cancels  \n\b*** YOU ARE KICKING YOURSELF IF YOU ENTER 7! ***";
		else
		self.wad =
				  "\n\n   3: next player          \n"
						"   7: confirm kick         \n"
						"   6: main menu            \n"
						"  admin impulse exits      \n"
					 "\b+-------------------------+\n"
					 "\b      7 to confirm!        \n any other entry cancels  \n\b*** PLAYER WILL BE KICKED IF YOU ENTER 7! ***";
	self.lefty = KICKCODE;
	}
	else
		self.wad =
				  "\n\n   3: next player          \n"
						"   7: confirm kick         \n"
						"   6: main menu            \n"
						" admin impulse: exit admin \n"
					 "\b+-------------------------+\n"
					 "\b Enter code: ";

	self.admin = 15;
};
/*
==========
Bots
==========
*/

// set skill for bot admin if parm >0 if parm = 0 increment skill by 1, loop after 3

float(float sk) skill_add =
{
	local float skl;
	if (sk) skl = sk;
	else
	{
		skl = cvar("skill");
		skl = skl + 1;
	}
	if (skl > 3) skl = 0;
	localcmd("skill ");
	localcmd(ftos(skl));
	localcmd("\n");
	return(skl);
};

void() Admin_botmenu =
{
	self.message =
				       "\b     Admin Bot Menu:     \n"
				       "\b+--------------------------+\n"
							"    pk*bot       frikbot    \n"
							" 01: add bot   11: add bot  \n"
							" 02: remove 1  12: remove 1 \n"
							" 03: 3 *skill  13: 3 *skill \n"
							" - add 1 bot of each skill  \n"
							" 04: add 4     14: add 4    \n"
							" - add 4 bots - same skill  \n"
							" 05: verbose                \n"
							" 06: update    20: +skill   \n"
							" 07: unrestricted           \n"
							" 08: observer mode          \n"
							" 09: observer time          \n"
							" 666:  main menu            \n"
							" admin impulse: exit admin  \n"
				       "\b+--------------------------+\n"
						 "\b  Enter code: ";

	self.wad = "";
	self.admin = 18;
	self.lefty = 0;
};

/*
==========
Items menu admin
==========
*/
void() Admin_itemmenu =
{
	self.message =
				       "\b     Admin Items Menu:     \n"
				       "\b+--------------------------+\n"
							"  +------- weapons ------+  \n"
							"  01: Double shotgun        \n"
							"  02: Nailgun               \n"
							"  03: Preforator            \n"
							"  04: Grenade launcher      \n"
							"  05: Rocket launcher       \n"
							"  06: Lightning gun         \n"
							"  07: Painkeep items        \n"
							"  +------ artifacts -----+  \n"
							"  10: Quad damage           \n"
							"  11: Invulnerability       \n"
							"  12: Radiation suit        \n"
							"  13: Ring of shadows       \n"
							"  +------- toggles ------+  \n"
							"  20: Only these items      \n"
							"  21: None of these items   \n"
							"  22: Substitute removed    \n"
							"  23: Infinite ammo         \n"
							" 666:  main menu            \n"
							" admin impulse: exit admin  \n"
				       "\b+--------------------------+\n"
						 "\b  Enter code: ";

	self.wad = "";
	self.admin = 26;
	self.lefty = 0;
};

/*
==========
Painkeep impulses
==========
*/
void() Admin_pkmenu =
{
	self.message =
				       "\b    Admin Painkeep Menu:    \n"
				       "\b+--------------------------+\n"
							"  01: SFX toggle            \n"
							"  02: HUB mode toggle       \n"
							"  03: Duty check toggle     \n"
							"  04: settings list         \n"
//							"  05: PK dynamic items      \n"
							"  06: Spike traps           \n"
//							"  07: Extra sound           \n"
							" 666:  main menu            \n"
							" admin impulse: exit admin  \n"
				       "\b+--------------------------+\n"
						 "\b  Enter code: ";

	self.wad = "";
	self.admin = 22;
	self.lefty = 0;
};

/*
==========
AdminCommands
==========
*/
void() Admin_mainmenu =
{
	if (PK) // menu with PK only entries
	{
	self.message =
					 "\b   Administration Menu:    \n"
					 "\b+-------------------------+\n"
						"  01:  toggle deathmatch   \n"
						"  02:  toggle teamplay     \n"
						"  03:  toggle coop         \n"
						"  04:  toggle no exit      \n"
						"  05:  goto next level     \n"
						"  06:  reset level         \n"
						"  07:  hub map load        \n"
						"  10:  server frag limit   \n"
						"  11:  server time limit   \n"
						"  12:  server gravity      \n"
						"  13:  server friction     \n"
						"  22:  map control         \n"
						"  23:  bot control         \n"
						"  24:  painkeep control    \n"
						"  30:  kick players        \n"
						"  60:  PK mode toggle      \n"
						"  ---  PK mode = TRUE      \n"
						"  97:  exit menu only      \n"
						"  98:  observer            \n"
						"  99:  respawn (exits)     \n"
						" admin impulse: exit admin \n"
					 "\b+-------------------------+\n"
					 "\b Enter code: ";
	}
	else
	{
	self.message =
					 "\b   Administration Menu:    \n"
					 "\b+-------------------------+\n"
						"  01:  toggle deathmatch   \n"
						"  02:  toggle teamplay     \n"
						"  03:  toggle coop         \n"
						"  04:  toggle no exit      \n"
						"  05:  goto next level     \n"
						"  06:  reset level         \n"
						"  07:  start map load      \n"
						"  10:  server frag limit   \n"
						"  11:  server time limit   \n"
						"  12:  server gravity      \n"
						"  13:  server friction     \n"
						"  22:  map control         \n"
						"  23:  bot control         \n"
						"  30:  kick players        \n"
						"  60:  PK mode toggle      \n"
						"  ---  PK mode = FALSE     \n"
						"  97:  exit menu only      \n"
						"  98:  observer            \n"
						"  99:  respawn (exits)     \n"
						" admin impulse: exit admin \n"
					 "\b+-------------------------+\n"
					 "\b Enter code: ";
	}

	self.target = self.map = self.wad = "";
	self.admin = 6;
	self.lefty = 0;
};

// setup timer for closing menus

// lt - light up admin if true
// tm - timeout to use

void(float lt, float tm) admin_timer =
{
	if (self.goalentity)
	if (self.goalentity.classname == "admintimer") // 'e says they already got one
		return;
	self.goalentity = spawn();
	if (!self.goalentity) return;
	self.goalentity.classname = "admintimer";
	self.goalentity.owner = self;
	self.goalentity.think = PK_AdminImpulse;
	self.goalentity.nextthink = time + tm;
// if lt is true, this is a beacon light over an admin player
	if (lt)
	{
		self.goalentity.effects = EF_DIMLIGHT;
		setmodel(self.goalentity, "progs/s_light.spr"); // let everyone know this guy is in admin mode
	}
bprint("set admin timer\n");
};

void() AdminCommands =
{
	local float e, f;
	local string str;

	if (self.admin == 1)																// login
	{
		if (self.lefty != pk_admincode)
		{
			self.attack_finished = time + A_DELAY; // penalty - cant use this for invulnerable state
			self.admin = ADMIN_FAILED_LOGIN;
			centerprint3(self, "admin password entry failure, you must wait ",ftos(A_DELAY)," secs!\n");
			return;
		}
		centerprint(self,"Administration privileges enabled, hit \b[ENTER]");
		Admin_mainmenu();
		if (pk_admintime > 0) // admin timeout
		{
			admin_timer(TRUE, pk_admintime);
		}
		return;
	}
	else if (self.admin < 6)															// main menu
	{
		self.admin = 6;
// main menu options
		if (self.lefty == A_FRAGL)
		{
			self.wad = "\nEnter a new frag limit";
			self.lefty = cvar("fraglimit");
			self.admin = 10;
			self.lip = 6;
			self.map = "fraglimit ";
			self.target = "\nfraglimit changed...";
		}
		else
		if (self.lefty == A_TIMEL)
		{
			self.wad = "\nEnter a new time limit";
			self.lefty = cvar("timelimit");
			self.admin = 10;
			self.lip = 6;
			self.map = "timelimit ";
			self.target = "\ntimelimit changed...";
		}
		else
		if (self.lefty == A_GRAVU)
		{
			self.cnt = 1;
			Admin_varmenu();
			self.noise = "sv_gravity ";
			self.wad = "\nadjusting sv_gravity";
			self.lefty = cvar("sv_gravity");
		}
		else
		if (self.lefty == A_FRICU)
		{
			self.cnt = 0.01;
			Admin_varmenu();
			self.noise = "sv_friction ";
			self.wad = "\nadjusting sv_friction";
			self.lefty = cvar("sv_friction");
		}
		else
		if (self.lefty == A_TEAMT) TeamToggle(); else
		if (self.lefty == A_DMT) DMToggle(); else
		if (self.lefty == A_COOPT) CoopToggle(); else
		if (self.lefty == A_JUMP) JumptoNext(); else
		if (self.lefty == A_RESET) ResetLevel(); else
		if (self.lefty == A_NOEX) ToggleNoExit(); else
		if (self.lefty == A_START) MapStart(); else
		if (self.lefty == A_DMMAP) Admin_dmmapmenu(); else
		if (self.lefty == A_BOTS) Admin_botmenu(); else
		if (self.lefty == A_PKCON) Admin_pkmenu(); else
		if (self.lefty == A_PKMOD)
		{
			f = pk_flags & PK_MAP;
			pk_flags = pk_flags - f;
			if (f & PK_ALWAYS)
			{
				f = PK_NEVER;
				PK = 0;
				str = "\nPainkeep mode = never\npainkeep code never enabled\n*map items will not change until reloaded";
			}
			else if (f & PK_NEVER)
			{
				f = 0;
				PK = PK_mapmode(world.model);
				str = "\nPainkeep mode = map\npainkeep code enabled for painkeep maps\n*map items will not change until reloaded";
			}
			else
			{
				f = PK_ALWAYS;
				PK = 1;
				str = "\nPainkeep mode = always\npainkeep code always enabled\n*map items will not change until reloaded";
			}

			pk_flags = pk_flags | f;
			admin_sv_cfg();
			Admin_mainmenu();
			self.wad = str;
		}
		else
		if (self.lefty == A_SKICK)
		{
			self.target = "player";
			self.enemy = world;
			find_Kick();
			if (self.enemy) Admin_kickmenu();
		}
		else if (self.lefty == 97)													// live in game admin - not in menu
		{
			self.admin = LIVE_ADMIN;
			self.wad = self.message = self.map = self.target = "";
			self.enemy = world;
			centerprint(self, "");
			self.takedamage = DAMAGE_AIM;
			self.impulse = 0;
			localcmd("noadmingamma\n"); // set gamma level
			localcmd("noadmin_centertime\n");
			sprint(self,"Entering live game admin mode - timeout is: ");
			if (pk_admintime < 60)
			{
				sprint(self,ftos(pk_admintime));
				sprint(self," seconds\n");
			}
			else
			{
				sprint(self,ftos(floor(pk_admintime / 60)));
				sprint(self," minutes\n");
			}
			sprint(self,"after which admin will turn off.\n");
			sprint(self,"Use admin impulse to return to menu mode.\n");
			return;
		}
		else if (self.lefty == 98)
		{
			observer();
			self.goalentity.effects = 0;
			setmodel(self.goalentity, ""); // no light on admin observer
		}
		else if (self.lefty == 99)													// admin respawn - exits admin mode
		{
			self.impulse = pk_adminimp;
			PK_AdminImpulse();
			centerprint(self, "");
			self.classname = "player";
			setmodel(self, ""); // dont let body que make a copy of a live player
			respawn ();
			return;
		}
		else
			self.lefty = 0;
	}
	else if (self.admin == 9)															// new data value entered
	{
		if (self.map == "observer_time")
		{
			observer_time = self.lefty;
		}
		else
		{
			localcmd(self.map);
			localcmd(ftos(self.lefty));
			localcmd("\n");
		}
		self.admin = self.lip; // admin level we are on
		self.wad = self.target;
		self.target = self.map = "";
		if (self.lip != 19) self.lefty = 0;
	}
	else if (self.admin == 13)														// dm map from painkeep set
	{
		if (self.lefty == 666)
			Admin_mainmenu();
		else
		{
			if (MapDM()) return;
			self.admin = 14;
			self.lefty = 0;
		}
		self.wad = "\nNo map change.";
	}
	else if (self.admin == 15)														// kick players
	{
		if (self.lefty == KICKCODE)
		{
			if (self.impulse == 7)
			{
				localcmd("kick ");
				localcmd(self.enemy.netname);
				localcmd("\n");
				self.enemy = world;
				Admin_kickmenu();
				find_Kick();
			}
			else
			{
				self.impulse = 0;
				Admin_kickmenu();
			}
		}
		else if (self.impulse == 6)
			Admin_mainmenu();
		else if (self.impulse == 1) Admin_kickmenu();
		else if (self.impulse == 3) find_Kick();
	}
	else if (self.admin == 17)														// bots
	{
		self.admin = 18;
		if (self.lefty == 666)
			Admin_mainmenu();
		else if (self.lefty == 1 || self.lefty == 3 || self.lefty == 4)
		{
			self.wad = "\nCould NOT load pk*bot(s) on server.";
			e = NUMBOTS;
			if (self.lefty == 3) f = 1;
			else f = -1;
			AddAnotherBot (f);
			if (e != NUMBOTS) self.wad = "\nLoaded a pk*bot on server.";
			if (self.lefty != 1)
			{
				e = NUMBOTS;
				if (self.lefty == 3) f = f + 1;
				AddAnotherBot (f);
				if (self.lefty == 3) f = f + 1;
				AddAnotherBot (f);
				if (self.lefty != 3) AddAnotherBot (f);
				if (e != NUMBOTS) self.wad = "\nLoaded requested pk*bot(s) on server.";
			}
		}
		else if (self.lefty == 11 || self.lefty == 13 || self.lefty == 14)
		{
			self.wad = "\nCould NOT load frikbot(s) on server.";
			e = bot_count;
			if (self.lefty == 13) f = 1;
			else f = cvar("skill");
			BotConnect(0, 0, f);
			if (e != bot_count) self.wad = "\nLoaded A frikbot on server.";
			if (self.lefty != 11)
			{
				e = bot_count;
				if (self.lefty == 13) f = f + 1;
				BotConnect(0, 0, f);
				if (self.lefty == 13) f = f + 1;
				BotConnect(0, 0, f);
				if (self.lefty != 13) BotConnect(0, 0, f);
				if (e != bot_count) self.wad = "\nLoaded requested frikbot(s) on server.";
			}
		}
		else if (self.lefty == 2)
		{
			e = NUMBOTS;
			removeBot(world);
			if (e != NUMBOTS) self.wad = "\nRemoved a pk*bot from server.";
		}
		else if (self.lefty == 12)
		{
			e = bot_count;
			KickABot();
			if (e != bot_count) self.wad = "\nRemoved a frikbot from server.";
		}
		else if (self.lefty == 5)
		{
			setVerboseMode();
			if (VERBOSEBOT)
				self.wad = "\npk*bots will not be quiet.";
			else
				self.wad = "\ncats got pk*bots tongues.";
		}
		else if (self.lefty == 7)
		{
			if (serverflags & UNRESTRICTED)
			{
				serverflags = (serverflags - UNRESTRICTED);
				self.wad = "\nBot commands restricted to admin.";
			}
			else
			{
				serverflags = (serverflags | UNRESTRICTED);
				self.wad = "\nBot commands NOT restricted on server.\n\banyone can issue bot admin commands!";
			}
		}
		else if (self.lefty == 8)
		{
			if (serverflags & FL_OBSERVER)
			{
				serverflags = (serverflags - FL_OBSERVER);
				self.wad = "\nOnly admins can observe.";
			}
			else
			{
				serverflags = (serverflags | FL_OBSERVER);
				self.wad = "\n\bAll players can observe.";
			}
		}
		if (self.lefty == 9)
		{
			self.wad = "\nEnter an observer time limit in seconds";
			self.lefty = observer_time;
			self.admin = 10;
			self.lip = 18;
			self.map = "observer_time";
			self.target = "\nObserver time limit changed...";
		}
		else if (self.lefty == 20)
		{
			f = skill_add(0);
			if (!f) self.wad = "\nSkill level is 0.";
			else if (f == 1) self.wad = "\nSkill level is 1.";
			else if (f == 2) self.wad = "\nSkill level is 2.";
			else if (f == 3) self.wad = "\nSkill level is 3.";
			else self.wad = "\nSkill level is UNKNOWN!.";
		}
		else
			self.lefty = 0;
	}
	else if (self.admin == 19)														// variable adjust
	{
		self.map = self.noise;
		if (self.impulse == 9)
		{
			self.cnt = 0;
			self.wad = self.noise = "";
			Admin_mainmenu();
			setBotGravity(); // *bots
		}
		else if (self.impulse == 8)
		{
			self.target = self.wad;
			self.wad = "\nEnter a valid value";
			self.admin = 10;
		}
		else if (self.impulse == 1) self.lefty = self.lefty + self.cnt;
		else if (self.impulse == 2) self.lefty = self.lefty + (10 * self.cnt);
		else if (self.impulse == 3) self.lefty = self.lefty + (100 * self.cnt);
		else if (self.impulse == 4) self.lefty = self.lefty - (100 * self.cnt);
		else if (self.impulse == 5) self.lefty = self.lefty - (10 * self.cnt);
		else if (self.impulse == 6) self.lefty = self.lefty - self.cnt;
		else if (self.impulse == 7)
		{
			localcmd(self.map);
			localcmd(ftos(self.lefty));
			localcmd("\n");
		}
	}
	else if (self.admin == 21)														// painkeep specific items
	{
		self.admin = 22;
		if (self.lefty == 666)
			Admin_mainmenu();
		else if (self.lefty == 1)
		{
			if (pk_flags & PK_TP_SPARKSFLASH)
			{
				self.wad = "\nSFX Enabled.";
				pk_flags = pk_flags - PK_TP_SPARKSFLASH;
			}
			else
			{
				self.wad = "\nSFX Disabled.";
				pk_flags = pk_flags | PK_TP_SPARKSFLASH;
			}
		}
		else if (self.lefty == 2)
		{
			if (pk_flags & PK_SF_HUB)
			{
				self.wad = "\nHub mode OFF";
				pk_flags = pk_flags - PK_SF_HUB;
			}
			else
			{
				self.wad = "\nHub mode ON";
				pk_flags = pk_flags | PK_SF_HUB;
			}
		}
		else if (self.lefty == 3)
		{
			if (pk_flags & PK_TP_DUTYON)
			{
				self.wad = "\nDuty Checking OFF";
				pk_flags = pk_flags - PK_TP_DUTYON;
			}
			else
			{
				self.wad = "\nDuty Checking ON";
				pk_flags = pk_flags | PK_TP_DUTYON;
			}
		}
		else if (self.lefty == 4)
		{
			self.wad = "\nSettings printed to console";
			if (pk_flags & PK_TP_DUTYON)
				sprint(self, "Duty Checking On\n");
			else
				sprint(self, "Duty Checking Off\n");

			if (!(pk_flags & PK_TP_SPARKSFLASH))
				sprint(self, "SFX On\n");
			else
				sprint(self, "SFX Off\n");

			if (pk_flags & PK_TP_STATUSON)
				sprint(self, "Status On\n");
			else
				sprint(self, "Status Off\n");	 

			if (pk_flags & PK_TP_USERMAPON)
				sprint(self, "Custom Maps On\n");
			else
				sprint(self, "Custom Maps Off\n");
		}
		else if (self.lefty == 6)
		{
			if (pk_flags & PK_SPIKER)
			{
				self.wad = "\nSpkike traps enabled in PK mode";
				pk_flags = pk_flags - PK_SPIKER;
			}
			else
			{
				self.wad = "\nSpkike traps disabled in PK mode";
				pk_flags = pk_flags | PK_SPIKER;
			}
		}
		else
			self.lefty = 0;

		if (self.lefty) admin_sv_cfg();
	}

	if (self.admin == 15)
		centerprint3(self, self.message, self.enemy.netname, self.wad);
	else	if (self.admin == 19 || self.admin == 10)
	{
		str = ftos(self.lefty);
		centerprint3(self, self.message, str, self.wad);
	}
	else
		centerprint3(self, self.message, "->", self.wad);
};

// clear screen from admin - exit or failed login after wait

void() admin_clear =
{
	localcmd("noadmingamma\n");
	localcmd("noadmin_centertime\n");
	centerprint(self, "");
	self.impulse = self.admin = 0;
	self.takedamage = DAMAGE_AIM;	
	self.wad = self.message = self.map = self.target = "";
	self.enemy = world;
};

/*
============
Admin Impulse code
============
*/

void() PK_SetAdmin =
{
	local entity e;

	e = spawn();
	e.nextthink = time + 0.1;
	e.think = PK_SetAdmin;

	if (self.classname == "admincode") 
	{
		pk_admincode = cvar("saved3");
		if ( ! pk_admincode) pk_admincode = -1;
// access impulse now
		localcmd(ADMINIMPULSE);
		e.classname = "adminimp";
		if (pk_admincode == -1) PK_ADMIN = 0;
	}
	else if (self.classname == "adminimp") 
	{
		pk_adminimp = cvar("saved3");
		if ( ! pk_adminimp) pk_adminimp = 255;
		if (pk_adminimp == -1) PK_ADMIN = 0;
		localcmd(ADMINTIME);
		e.classname = "admintime";
	}
	else if (self.classname == "admintime") 
	{
		pk_admintime = cvar("saved3");
		localcmd("saved3 0\n");
		remove(e);
if (0) {
bprint("admin impulse: ");
bprint(ftos(pk_adminimp));
bprint(", code: ");
bprint(ftos(pk_admincode));
bprint(", timeout: ");
bprint(ftos(pk_admintime));
bprint("\n"); }
	}
	else
		remove(e);

	remove(self);
};

/*
============
User Menu
============
*/
void() User_menu =
{
	string head, ln1, ln2, ln3, ln4, ln5, foot;

	ln1 = ln2 = ln3 = ln4 = ln5 = "";
	if (self.ammo_cells > 1 && self.pk_items & PK_IT_CLIGHT)
		head =
					 "\b   Painkeep User Menu:   \n"
					 "\b+------------------------+\n"
						"  1: Chain Thunderbolt    \n";
	else
		head =
					 "\b   Painkeep User Menu:   \n"
					 "\b+------------------------+\n";

	if (self.pk_gravitywellammo > 0)
		ln1 =
						"  2: Gravity Well         \n";
	if (self.pk_turretammo > 0)
		ln2 =
						"  3: Auto Sentry          \n";
	if (self.pk_items & PK_IT_GRAPGUN)
	{
		ln3 =
						"  4: Harpoon              \n";
		foot = 
						"  5: release harpoon      \n\n"
				"\b*** following are impulse links ***\n\n"

						"  11: close combat wep    \n"
						"  12: prev pk weapon      \n"
						"  13: status display      \n"
						"    any impulse exits     \n"
					 "\b+------------------------+\n"
					 "\b Enter code: ";
	}
	else
	{
	foot = 
				"\b*** following are impulse links ***\n\n"

						"  11: close combat wep    \n"
						"  12: prev pk weapon      \n"
						"  13: status display      \n"
						"    any impulse exits     \n"
					 "\b+------------------------+\n"
					 "\b Enter code: ";
	}
	if (self.pk_items & PK_IT_AIRGUN)
	{
		if (self.pk_beartrapammo > 0)
			ln4 =
						"  6: Air fist             \n"
						"  7: Beartrap             \n";
		else
			ln4 =
						"  6: Air fist             \n";
	}
	else
	{
		if (self.pk_beartrapammo > 0)
			ln4 =
						"  7: Beartrap             \n";
	}
	if (self.pk_canpabammo > 0)
		ln5 =
						"  8: Can o' Pork n' Beans \n"
						"  9: Axe                  \n"
						"  0: Inventory list       \n"
						"  +--------------------+  \n";
	else
		ln5 =
						"  9: Axe                  \n"
						"  0: Inventory list       \n"
						"  +--------------------+  \n";

/*
	old menu - deprecated

	self.message =
					 "\b   Painkeep User Menu:   \n"
					 "\b+------------------------+\n"
						"  1: Chain Thunderbolt    \n"
						"  2: Gravity Well         \n"
						"  3: Auto Sentry          \n"
						"  4: Harpoon              \n"
						"  6: Air fist             \n"
						"  7: Beartrap             \n"
						"  8: Can o' Pork n' Beans \n"
						"  9: Axe                  \n"
						"  0: Inventory list       \n"
						"  +--------------------+  \n"
						"  5: release harpoon      \n\n"
				"\b*** following are impulse links ***\n\n"

						"  11: close combat wep    \n"
						"  12: prev pk weapon      \n"
						"  13: status display      \n"
						"    any impulse exits     \n"
					 "\b+------------------------+\n"
					 "\b Enter code: ";
*/
	self.wad = "";
	centerprint7(self, head, ln1, ln2, ln3, ln4, ln5, foot);
};

// set painkeep item from user menu

void(float pki, float ci) user_menu_pkitem =
{
	if (ci) // ci - set current inventory too
		self.pk_currentInventory = self.pk_currentitem = pki;
	else
		self.pk_currentitem = pki;

	self.weapon = IT_AXE;
	self.forcewchange = TRUE;
	W_SetCurrentAmmo();
};

// fn(PK_AdminImpulse) - main admin input control routine

void() PK_AdminImpulse =
{
	local string as;
	local float f;

	self.attack_finished = time + 0.1; // debounce - dont want this every frame

	if (self.admin == USER_MENU) // process user menu (impulse 39) here
	{
		if (self.message == "")
		{
			localcmd("usergamma\n");
			localcmd("admin_centertime\n");
			admin_timer(FALSE, USER_TIMEOUT);
			self.impulse = 0;
			self.message = "USER_MENU";
		}
		if (self.impulse == 6)
		{
			if (self.pk_items & PK_IT_AIRGUN)
				user_menu_pkitem(PK_IT_AIRGUN, FALSE);
		}
		else if (self.impulse == 4)
		{
			if (self.pk_items & PK_IT_GRAPGUN)
				user_menu_pkitem(PK_IT_GRAPGUN, FALSE);
		}
		else if (self.impulse == 1)
		{
			if (self.ammo_cells > 1 && self.pk_items & PK_IT_CLIGHT)
				user_menu_pkitem(PK_IT_CLIGHT, FALSE);
		}
		else if (self.impulse == 2)
		{
			if (self.pk_gravitywellammo > 0)
				user_menu_pkitem(PK_IT_GRAVITYWELL, TRUE);
		}
		else if (self.impulse == 7)
		{
			if (self.pk_beartrapammo > 0)
				user_menu_pkitem(PK_IT_BEARTRAP, TRUE);
		}
		else if (self.impulse == 3)
		{
			if (self.pk_turretammo > 0)
				user_menu_pkitem(PK_IT_TURRET, TRUE);
		}
		else if (self.impulse == 8)
		{
			if (self.pk_canpabammo > 0)
				user_menu_pkitem(PK_IT_CANPAB, TRUE);
		}
		else if (self.impulse == 9)
		{
			user_menu_pkitem(PK_IT_AXE, TRUE);
		}
		else if (self.impulse == 5)
			grap_releaseHarpoon();
/*		else if (self.impulse == 11)
		{
			self.weapon = W_BestWeapon();
			self.pk_currentitem = W_BestPKWeapon();
			W_SetCurrentAmmo();
		}
		else if (self.impulse == 12)
			if (CanSelect(self.lastweapon, self.pklastweapon))
			{
				self.weapon = self.lastweapon;
				self.pk_currentitem = self.pklastweapon;
				W_SetCurrentAmmo();
			}
*/
		f = self.impulse;
		User_menu();
//		centerprint3(self, self.message, "", "");
		if (self.button0 || self.button1 || self.button2 || self.impulse)
			admin_clear();

// NOTE: if the impulses change - this code must change
		if (f == 11) // admin enter
			self.impulse = 46;
		else if (f == 12) // admin backspace
			self.impulse = 69;
		else if (f == 13)
			self.impulse = 201;
		else if (f == 10) // admin 0
			self.impulse = 38;
		else
			self.impulse = 0;
		return;
	}
	else if (self.impulse == pk_adminimp || self.classname == "admintimer") // toggle admin state on security impulse
	{
		if (self.classname == "admintimer") // entry from a timeout remote
		{
			if (!self.owner || !self.owner.admin) // hrm...
			{
				remove(self);
				return;
			}
			if (self.owner.goalentity != self)
			{
				self.think = SUB_Remove;
				self.nextthink = 0.1;
			}
			self = self.owner;
			self.admin = 7;
		}

		if (self.admin && self.admin < LIVE_ADMIN)
		{
			centerprint(self, "");
			if (self.admin < 0) // escaped login
			{
				self.attack_finished = time + A_TIME; // penalty - cant use this for invulnerable state
				self.admin = ADMIN_FAILED_LOGIN;
				centerprint3(self, "admin login escape, you must wait ",ftos(A_TIME)," secs!\n");
				return;
			}
			else
				self.admin = 0;
			if (self.goalentity.classname == "admintimer")
			{
				remove(self.goalentity);
				self.goalentity = world;
			}
			admin_clear();
			self.attack_finished = time + 0.3; // clear keypress
			return;
		}
		else
		{
			if (self.admin == LIVE_ADMIN)
			{
				self.admin = 6;
				Admin_mainmenu();
			}
			else // login
			{
				self.admin = ADMIN_LOGIN; // enter access code
				admin_time = time + A_TIME; // 10 secs default - NOTE: this is 10 seconds of invulnerability
			}
			self.lefty = 0;
			self.takedamage = DAMAGE_NO;
			localcmd("admingamma\n"); // set gamma level
			localcmd("admin_centertime\n");
		}
	}
// code allows us to act like regular keypad entry, heh heh
	else if (self.impulse && (self.admin < -1 || (self.admin & 3) == 2)) // enter codes for menu or login
	{
//bprint("in numeric: "); // track input
//bprint(ftos(self.admin));
//bprint (" - out = ");
		if (self.impulse == 10) self.impulse = 0; // translate 0
		if (self.impulse < 10) self.lefty = (self.lefty * 10) + self.impulse; // build code
		else if (self.impulse == 12) self.lefty = floor(self.lefty / 10); // backspace
		if (self.impulse == 11 || self.button0) self.admin = fabs(self.admin) - 1; // enter (accept fire button here) - done
//		if (self.impulse == 11 && self.lefty) self.admin = fabs(self.admin) - 1; // enter - done
		else if (self.admin > 0) // code for menu select go back now
		{
			as ="";
			if (self.lefty) as = ftos(self.lefty);
			else if (self.admin < 9) self.wad = "";
			if (self.admin < 9) centerprint3(self, self.message, as, "<");
			else centerprint3(self, self.message, as, self.wad);
//bprint(ftos(self.impulse));
//bprint("\n");
			self.impulse = 0;
			return;
		}
//bprint(ftos(self.impulse));
//bprint("\n");
	}

	if (self.admin > 0)
	{
//bprint("admin: ");
//bprint(ftos(self.admin));
////bprint(ftos(self.impulse));
//bprint("\n");
		AdminCommands();
		self.impulse = 0;
	}
	else if (self.admin < -1) // processing login
	{
		if (admin_time < time) // timed out - force password check
		{
			self.admin = 1;
			AdminCommands();
		}
		else if (self.impulse)
		{
		as = "";
		if (pk_adminpwdmask) // cute password mask
		{
			if			(self.lefty > 9999999999) as	= "***********" ; // alas, my compiler for additive strings, just stop echoing new chars here
			else if (self.lefty > 999999999) as	= "**********" ;
			else if (self.lefty > 99999999) as		= "*********" ;
			else if (self.lefty > 9999999) as		= "********" ;
			else if (self.lefty > 999999) as		= "*******" ;
			else if (self.lefty > 99999) as			= "******" ;
			else if (self.lefty > 9999) as			= "*****" ;
			else if (self.lefty > 999) as			= "****" ;
			else if (self.lefty > 99) as				= "***" ;
			else if (self.lefty > 9) as				= "**" ;
			else if (self.lefty > 0) as				= "*" ;
		}
		else
			if (self.lefty) as = ftos(self.lefty); // NOTE: this option leaves password in clear text
		centerprint3(self, "Enter admin password: ", as, "\n");
		self.impulse = 0;
		}
		else if (!self.lefty)
		{
			as = ftos(floor(admin_time - time));
			centerprint3(self, "Enter admin password - seconds left: ", as, "\n");
		}
	}
};

// fn(admin_postthink) - called from post think, runs admin menus

float() admin_postthink =
{
	pk_adminframe = framecount;
//	if (deathmatch) // admin is debateable in SP, but...
	if (self.attack_finished < time)
	{
		if (self.admin != LIVE_ADMIN && (self.admin < 0 || (self.impulse && self.admin)))
		{
			if (self.admin == ADMIN_FAILED_LOGIN) admin_clear(); // failed login - clear wait msg
			else PK_AdminImpulse();

			if (pk_admintime > 0)
			if (self.admin > 0)
			if (self.goalentity)
			if (self.goalentity.classname == "admintimer") // any input to admin menus resets timeout
				self.goalentity.nextthink = time + pk_admintime;
		}
		else if (self.impulse == pk_adminimp)
			PK_AdminImpulse();
	}
	if (self.admin)
	{
		if (pk_admintime > 0)
		if (self.goalentity)
		if (self.goalentity.classname == "admintimer")
		if (self.goalentity.model != "")
			setorigin(self.goalentity, self.origin + ' 0 0 60'); // track admin players

		if (self.admin != LIVE_ADMIN) return(TRUE);
	}
	return(FALSE);
};
