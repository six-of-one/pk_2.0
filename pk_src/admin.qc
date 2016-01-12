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
float   A_GRAVU = 20;
float   A_GRAVD = 136;
float   A_FRICU = 21;
float   A_DMMAP = 22;
float   A_BOTS  = 23;
float   A_PKCON = 24;
float   A_FRICD = 138;
float   A_SKICK = 30;
float   A_PKMOD = 60;


// save flags & mode

void() admin_sv_cfg =
{
	local string str;

	str = ftos(pk_flags);
	if (pk_flags != pk_flags_ck)//cvar("saved1"))
		cvar_set("saved1", str);
	pk_flags_ck = pk_flags;

	str = ftos(pk_mode);
	if (pk_mode != pk_mode_ck) //cvar("saved2"))
		cvar_set("saved2", str);
	pk_mode_ck = pk_mode;
};

/*
==========
TeamToggle
==========
*/
void() TeamToggle =
{
//	bprint("Teamplay is now ");
	if (cvar("teamplay") == 1)
	{
//		bprint("OFF\n");
		self.wad = "\nTeam play is OFF...";
		localcmd("teamplay 0\n");
	}
	else
	{
//		bprint("ON\n");
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
//	bprint("Deathmatch is now ");
	if (cvar("deathmatch") == 1)
	{
	  // PAINKEEP_START changed from dm2 to dm3
//	  bprint(" 3\n");
		self.wad = "\nDeathmatch mode = 3...\nYou must restart level for new settings...";
	  localcmd("deathmatch 3\n");
	  // PAINKEEP_END
	}
	else
	{
//		bprint(" 1\n");
		self.wad = "\nDeathmatch mode = 1...\nYou must restart level for new settings...";
		localcmd("deathmatch 1\n");
	}
//	bprint("You must restart level for new settings...\n");
//	changelevel(mapname);
};

/*
==========
CoopToggle
==========
*/
void() CoopToggle =
{
//	bprint("Coop is now ");
	if (cvar("coop") == 1)
	{
		self.wad = "\nCoop is OFF...\nYou must restart level for new settings...";
//		bprint(" 0\n");
		localcmd("coop 0\n");
		localcmd("deathmatch 1\n");
	}
	else
	{
		self.wad = "\nCoop is ON...\nYou must restart level for new settings...";
//		bprint(" 1\n");
		localcmd("deathmatch 0\n");
		localcmd("coop 1\n");
	}
//	bprint("You must restart level for new settings...\n");
//	changelevel(mapname);
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
//		sprint(self,"NextLevel is not defined");
	else
	{
		bprint("Admin executed next level command...\n");
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
	changelevel(mapname);
};

/*
==========
ToggleNoExit
==========
*/
void() ToggleNoExit =
{
//	bprint("NoExit is now ");
	if (cvar("noexit") == 1)
	{
//		bprint("OFF\n");
		self.wad = "\nNo Exit is OFF...";
		localcmd("noexit 0\n");
	}
	else
	{
//		bprint("ON\n");
		self.wad = "\nNo Exit is ON...";
		if (cvar("fraglimit") <= 0 && cvar("timelimit") <= 0)
			self.wad = "\nNo Exit is ON...\ntimelimit, fraglimit are 0 - recommend you set one these";
		localcmd("noexit 1\n");
	}
};

/*
==========
GravToggle
==========
*/
void() GravToggle =
{
	local string st;
	local float  pad;

	pad = cvar("sv_gravity");
	if (((pad > 0)&&(self.impulse == A_GRAVD)) || ((pad < 3000)&&(self.impulse == A_GRAVU)))
	{
		if (self.impulse == A_GRAVD)
			pad = pad - 100;
		else
			pad = pad + 100;
		st = ftos(pad);
		bprint("Gravity is now ");
		bprint(st);
		bprint("\n");
		localcmd("sv_gravity ");
		localcmd(st);
		localcmd("\n");
	 }
	 else
	 {
		if (self.impulse == A_GRAVD)
			sprint(self,"Gravity is at minimum (0)\n");
		else
			sprint(self,"Gravity is at a maximum (3000)\n");
	 }
};

/*
==========
FricToggle
==========
*/
void() FricToggle =
{
	local string st;
	local float  pad;

	pad = cvar("sv_friction");
	if (((pad > 0)&&(self.impulse == A_FRICD)) || ((pad < 10)&&(self.impulse == A_FRICU)))
	{
		if (self.impulse == A_FRICD)
			pad = pad - 0.5;
		else
			pad = pad + 0.5;
		st = ftos(pad);
		bprint("Friction is now ");
		bprint(st);
		bprint("\n");
		localcmd("sv_friction ");
		localcmd(st);
		localcmd("\n");
	 }
	 else
	 {
		if (self.impulse == A_FRICD)
			sprint(self,"Friction is at minimum (0)\n");
		else
			sprint(self,"Friction is at a maximum (10)\n");
	 }
};

/*
==========
MapStart
==========
*/
void() MapStart =
{
	bprint("Admin loaded hub / start map...\n");
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
// PAINKEEP_START Redone for pk
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

  changelevel(mname);
  return(TRUE);
};
// PAINKEEP_END

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
		if (self.target == "player") self.target = "peeper";
		else self.target = "player";
		self.enemy = find(world, classname, self.target);
		if (!self.enemy) // 2nd list no good - try looping
		{
			if (self.target == "player") self.target = "peeper";
			else self.target = "player";
			self.enemy = find(world, classname, self.target);
		}
		if (!self.enemy) Admin_mainmenu(); // nothing found for either search ?? - go back
	}
	self.lefty = 0;
};

void() Admin_kickmenu =
{
	self.message = "\b   Administration Menu:   \n"
						"\b+------------------------+\n"
						"   1: kick player ->      \n \n";

	self.lefty = 0;
	if (self.impulse == 1)
	{
		if (self.enemy == self)
		self.wad =
				  "\n\n   3: next player         \n"
						"   7: confirm kick        \n"
						"   6: main menu           \n"
						"  admin impulse exits     \n"
						"\b+------------------------+\n"
						"\b      7 to confirm!       \n any other entry cancels  \n\b*** YOU ARE KICKING YOURSELF IF YOU ENTER 7! ***";
		else
		self.wad =
				  "\n\n   3: next player         \n"
						"   7: confirm kick        \n"
						"   6: main menu           \n"
						"  admin impulse exits     \n"
						"\b+------------------------+\n"
						"\b      7 to confirm!       \n any other entry cancels  \n\b*** PLAYER WILL BE KICKED IF YOU ENTER 7! ***";
	self.lefty = KICKCODE;
	}
	else
		self.wad =
				  "\n\n   3: next player         \n"
						"   7: confirm kick        \n"
						"   6: main menu           \n"
						"  admin impulse exits     \n"
						"\b+------------------------+\n"
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
							" 03: add 4     13: add 4    \n"
							" 04: 3 *skill  14: 3 *skill \n"
							" - add 1 bot of each skill  \n"
							" 05: verbose                \n"
							" 06: update    20: +skill   \n"
							" 07: restrict               \n"
							" 08: superrestrict          \n"
							" 09: observer mode          \n"
							" 10: observer time          \n"
							" 666:  main menu            \n"
							"  admin impulse exits       \n"
				       "\b+--------------------------+\n"
						 "\b  Enter code: ";

	self.wad = "";
	self.admin = 18;
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
							"  admin impulse exits       \n"
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
	self.message = "\b   Administration Menu:   \n"
						"\b+------------------------+\n"
						"  01:  toggle deathmatch  \n"
						"  02:  toggle teamplay    \n"
						"  03:  toggle coop        \n"
						"  04:  toggle no exit     \n"
						"  05:  goto next level    \n"
						"  06:  reset level        \n"
						"  07:  hub map load       \n"
						"  10:  frag limit         \n"
						"  11:  time limit         \n"
						"  20:  gravity control    \n"
						"  21:  friction control   \n"
						"  22:  map control        \n"
						"  23:  bot control        \n"
						"  24:  painkeep control   \n"
						"  30:  kick players       \n"
						"  60:  PK mode toggle     \n"
						"  ---  PK mode = TRUE     \n"
						"  admin impulse exits     \n"
						"\b+------------------------+\n"
						"\b Enter code: ";
	}
	else
	{
	self.message = "\b   Administration Menu:   \n"
						"\b+------------------------+\n"
						"  01:  toggle deathmatch  \n"
						"  02:  toggle teamplay    \n"
						"  03:  toggle coop        \n"
						"  04:  toggle no exit     \n"
						"  05:  goto next level    \n"
						"  06:  reset level        \n"
						"  07:  start map load     \n"
						"  10:  frag limit         \n"
						"  11:  time limit         \n"
						"  20:  gravity control    \n"
						"  21:  friction control   \n"
						"  23:  bot control        \n"
						"  30:  kick players       \n"
						"  60:  PK mode toggle     \n"
						"  ---  PK mode = FALSE    \n"
						"  admin impulse exits     \n"
						"\b+------------------------+\n"
						"\b Enter code: ";
	}

	self.target = self.map = self.wad = "";
	self.admin = 6;
	self.lefty = 0;
};

void() AdminCommands =
{
	local float f;
	local string str;

	if (self.admin == 1) // login
	{
		if (self.lefty != pk_admincode)
		{
			self.attack_finished = time + A_DELAY; // penalty - cant use this for invulnerable state
			self.admin = ADMIN_FAILED_LOGIN;
			localcmd("noadmin_centertime\n");
			centerprint3(self, "admin password entry failure, you must wait ",ftos(A_DELAY)," secs!\n");
			return;
		}
		centerprint(self,"Administration privileges enabled, hit \b[ENTER]");
		Admin_mainmenu();
		return;
	}
	else if (self.admin < 6) // main menu
	{
		self.admin = 6;
// main menu options
		if (self.lefty == A_FRAGL)
		{
			self.wad = "\nEnter a new frag limit";
			self.lefty = cvar("fraglimit");
			self.admin = 10;
			self.map = "fraglimit ";
			self.target = "\nfraglimit changed...";
//		self.indata = 1;
//		sprint(self,"Fraglimit?\n");
		}
		else
		if (self.lefty == A_TIMEL)
		{
			self.wad = "\nEnter a new time limit";
			self.lefty = cvar("timelimit");
			self.admin = 10;
			self.map = "timelimit ";
			self.target = "\ntimelimit changed...";
//		self.indata = 1;
//		sprint(self,"Fraglimit?\n");
		}
		else
		if (self.lefty == A_TEAMT) TeamToggle(); else
		if (self.lefty == A_DMT) DMToggle(); else
		if (self.lefty == A_COOPT) CoopToggle(); else
		if (self.lefty == A_JUMP) JumptoNext(); else
		if (self.lefty == A_RESET) ResetLevel(); else
		if (self.lefty == A_NOEX) ToggleNoExit(); else
		if ((self.lefty == A_GRAVU) || (self.lefty == A_GRAVD)) GravToggle(); else
		if ((self.lefty == A_FRICU) || (self.lefty == A_FRICD)) FricToggle(); else
		if (self.lefty == A_START) MapStart(); else
		if (self.lefty == A_DMMAP) Admin_dmmapmenu(); else
		if (self.lefty == A_BOTS) Admin_botmenu(); else
		if (self.lefty == A_PKCON) Admin_pkmenu(); else
		if (self.lefty == A_PKMOD)
		{
			f = pk_mode & 3;
			pk_mode = pk_mode - f;
			f = f + 1;
			if (f == 3)
			{
				f = 0;
				PK = PK_mapmode(world.model);
				str = "\nPainkeep mode = map\npainkeep code enabled for painkeep maps\nmap items will not change until reloaded";
			}
			else if (f == 1)
			{
				PK = 1;
				str = "\nPainkeep mode = always\npainkeep code always enabled\nmap items will not change until reloaded";
			}
			else
			{
				PK = 0;
				str = "\nPainkeep mode = never\npainkeep code never enabled\nmap items will not change until reloaded";
			}

			pk_mode = pk_mode | f;
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
		else
			self.lefty = 0;
	}
	else if (self.admin == 9) // new server value
	{
		if (self.map == "observer_time")
		{
			observer_time = self.lefty;
			self.admin = 18;
		}
		else
		{
			localcmd(self.map);
			localcmd(ftos(self.lefty));
			localcmd("\n");
			self.admin = 6;
		}
		self.wad = self.target;
		self.target = self.map = "";
		self.lefty = 0;
	}
	else if (self.admin == 13) // dm map from painkeep set
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
	else if (self.admin == 15) // kick players
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
	else if (self.admin == 17) // bots
	{
		self.admin = 18;
		if (self.lefty == 666)
			Admin_mainmenu();
		else if (self.lefty == 1 || self.lefty == 3 || self.lefty == 4)
		{
			f = cvar("skill");
			AddAnotherBot ();
			self.wad = "\nLoaded a pk*bot on server.";
			if (self.lefty != 1)
			{
				if (self.lefty == 4)
				{
					if (!f) skill_add(0);
					skill_add(0);
				}
				AddAnotherBot ();
				if (self.lefty == 4) skill_add(0);
				AddAnotherBot ();
				if (self.lefty == 4) skill_add(f);
				else
					AddAnotherBot ();
				self.wad = "\nLoaded requested pk*bot(s) on server.";
			}
		}
		else if (self.lefty == 11 || self.lefty == 13 || self.lefty == 14)
		{
			if (self.lefty == 14) f = 1;
			else f = cvar("skill");
			BotConnect(0, 0, f);
			self.wad = "\nLoaded A frikbot on server.";
			if (self.lefty != 11)
			{
				if (self.lefty == 14) f = f + 1;
				BotConnect(0, 0, f);
				if (self.lefty == 14) f = f + 1;
				BotConnect(0, 0, f);
				if (self.lefty != 14) BotConnect(0, 0, f);
				self.wad = "\nLoaded requested frikbot(s) on server.";
			}
		}
		else if (self.lefty == 2)
		{
			removeBot(world);
			self.wad = "\nRemoved a pk*bot from server.";
		}
		else if (self.lefty == 12)
		{
			KickABot();
			self.wad = "\nRemoved a frikbot from server.";
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
			if (serverflags & RESTRICT)
			{
				serverflags = (serverflags - RESTRICT);
				self.wad = "\nBot restriction removed from server.";
			}
			else
			{
				serverflags = (serverflags | RESTRICT);
				self.wad = "\nBot commands restricted on server.";
			}
		}
		else if (self.lefty == 8)
		{
			if (serverflags & SUPERRESTRICT)
			{
				serverflags = (serverflags - SUPERRESTRICT);
				self.wad = "\nSuper restriction removed from server.";
			}
			else
			{
				serverflags = (serverflags | SUPERRESTRICT);
				self.wad = "\nBots super restricted on server.";
			}
		}
		else if (self.lefty == 9)
		{
			if (serverflags & FL_OBSERVER)
			{
				serverflags = (serverflags - FL_OBSERVER);
				self.wad = "\nAll players can observe.";
			}
			else
			{
				serverflags = (serverflags | FL_OBSERVER);
				self.wad = "\nOnly admins can observe.";
			}
		}
		if (self.lefty == 10)
		{
			self.wad = "\nEnter an observer time limit in seconds";
			self.lefty = observer_time;
			self.admin = 10;
			self.map = "observer_time";
			self.target = "\nObserver time limit changed...";
//		self.indata = 1;
//		sprint(self,"Fraglimit?\n");
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
	else if (self.admin == 21) // painkeep specific items
	{
		self.admin = 22;
		if (self.lefty == 666)
			Admin_mainmenu();
		else if (self.lefty == 1)
		{
			if ((pk_flags & PK_TP_SPARKSFLASH))
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
			if (serverflags & PK_SF_HUB)
			{
				self.wad = "\nHub mode OFF";
				serverflags = serverflags - PK_SF_HUB;
			}
			else
			{
				self.wad = "\nHub mode ON";
				serverflags = serverflags | PK_SF_HUB;
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
			f = pk_mode & PK_SPIKER;
			pk_mode = pk_mode - f;
			f = (f + PK_SPIKER) & PK_SPIKER;
			pk_mode = pk_mode | f;
			if (f)
				self.wad = "\nSpkike traps disabled in PK mode";
			else
				self.wad = "\nSpkike traps enabled in PK mode";
		}
		else
			self.lefty = 0;

		if (self.lefty) admin_sv_cfg();
	}

	if (self.admin == 15)
		centerprint3(self, self.message, self.enemy.netname, self.wad);
	else
		centerprint3(self, self.message, "->", self.wad);
};

// clear screen from failed login after wait

void() admin_clear_failed =
{
	localcmd("noadmingamma\n");
	centerprint(self, "");
	self.admin = 0;
	self.takedamage = DAMAGE_AIM;	
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
		localcmd ("setadminimpulse\n");
		e.classname = "adminimp";
		if (pk_admincode == -1) PK_ADMIN = 0;
	}
	else if (self.classname == "adminimp") 
	{
		pk_adminimp = cvar("saved3");
		if ( ! pk_adminimp) pk_adminimp = 255;
		if (pk_adminimp == -1) PK_ADMIN = 0;
		localcmd("saved3 0\n");
		remove(e);
if (1) {
bprint("admin impulse: ");
bprint(ftos(pk_adminimp));
bprint(", code: ");
bprint(ftos(pk_admincode));
bprint("<\n"); }
	}
	else
		remove(e);

	remove(self);
};

void() PK_AdminImpulse =
{
	local string as;

	self.attack_finished = time + 0.2; // debounce - dont want this every frame

	if (self.impulse == pk_adminimp) // toggle admin state on impulse
	{
		if (self.admin)
		{
			self.wad = self.message = self.map = self.target = "";
			self.enemy = world;
			self.admin = 0;
			centerprint(self, "");
			self.takedamage = DAMAGE_AIM;
			self.impulse = 0;
			localcmd("noadmingamma\n"); // set gamma level
			localcmd("noadmin_centertime\n");
		}
		else
		{
			self.admin = -2; // enter access code
			self.lefty = 0;
			self.takedamage = DAMAGE_NO;
			localcmd("admingamma\n"); // set gamma level
			localcmd("admin_centertime\n");
			admin_time = time + A_TIME; // 10 secs default - NOTE: this is 10 seconds of invulnerability
//			centerprint(self, "Enter admin password: \n");
		}
	}
	else if (self.impulse && (self.admin < 0 || (self.admin & 3) == 2)) // enter codes for menu or login
	{
bprint("in numeric entry admin: ");
bprint(ftos(self.admin));
bprint (" - out = ");
		if (self.impulse == 10) self.impulse = 0; // translate 0
		if (self.impulse < 10) self.lefty = (self.lefty * 10) + self.impulse; // build code
		else if (self.impulse == 12) self.lefty = floor(self.lefty / 10); // backspace
		if (self.impulse == 11) self.admin = fabs(self.admin) - 1; // enter - done
//		if (self.impulse == 11 && self.lefty) self.admin = fabs(self.admin) - 1; // enter - done
		else if (self.admin > 0) // code for menu select go back now
		{
			as ="";
			if (self.lefty) as = ftos(self.lefty);
			else if (self.admin < 9) self.wad = "";
			if (self.admin < 9) centerprint3(self, self.message, as, "<");
			else centerprint3(self, self.message, as, self.wad);
bprint(ftos(self.impulse));
bprint("\n");
			self.impulse = 0;
			return;
		}
bprint(ftos(self.impulse));
bprint("\n");
	}

	if (self.admin > 0)
	{
bprint("admin: ");
bprint(ftos(self.admin));
//bprint(ftos(self.impulse));
bprint("\n");
		AdminCommands();
		self.impulse = 0;
	}
	else if (self.admin < 0)
	{
		if (admin_time < time) // timed out
		{
			self.admin = 1;
			AdminCommands();
		}
		else if (self.impulse)
		{
		as = "";
		if (pk_adminpwdmask)
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
			if (self.lefty) as = ftos(self.lefty);
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
