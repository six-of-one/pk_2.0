// Admin.qc - Remote Administration of a Quake Server
//
// Modified 8/14/96
//
// Doug Keegan
// Rip on IRC/NetQuake
// doug.keegan@tamu.edu


// impulse constants. Change the A_CODEx constants to your 'secret' admin code

// Renumber the impulses, remove the default codes, and change the level options
// -1 for any of these codes means they are disabled
//float   A_CODE1 = 2;
//float   A_CODE2 = 4;
//float   A_CODE3 = 2;
//float   A_CODE4 = 6;
//float   A_CODE5 = 7;
// Cataboligne - time limit on admin password entry
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
// End of level impulses
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
float   A_FRICD = 138;
float   A_SKICK = 30;
//float   A_YES   = 141;
//float   A_NO    = 142;



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

	self.admin = 17;
};

/*
==========
AdminCommands
==========
*/
void() Admin_mainmenu =
{
	self.message = "\b   Administration Menu:   \n"
						"\b+------------------------+\n"
						"  01:  toggle deathmatch  \n"
						"  02:  toggle teamplay    \n"
						"  03:  toggle coop        \n"
						"  04:  toggle no exit     \n"
						"  05:  goto next level    \n"
						"  06:  reset level        \n"
						"  07:  hub level / start  \n"
						"  10:  frag limit         \n"
						"  11:  time limit         \n"
						"  20:  gravity control    \n"
						"  21:  friction control   \n"
						"  22:  map control        \n"
						"  23:  bot control        \n"
						"  30:  kick players       \n"
						"  admin impulse exits     \n"
						"\b+------------------------+\n"
						"\b Enter code: ";

	self.target = self.map = self.wad = "";
	self.admin = 6;
	self.lefty = 0;
};

void() AdminCommands =
{
	if (self.admin == 1)
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
	else if (self.admin < 6) self.admin = 6;
	else if (self.admin == 9) // new server value
	{
		localcmd(self.map);
		localcmd(ftos(self.lefty));
		localcmd("\n");
		self.wad = self.target;
		self.admin = 6;
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
		}
		self.wad = "\nNo map change.";
	}
	else if (self.admin == 17) // kick players
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
		else self.lefty = 0;
	}
/*
	if (self.indata > 0)	// PAINKEEP: No need to check for impulse 0 here, this isn't called in that case
	{
		if (self.indata == 1) ChangeFragL();
		if (self.indata == 2) ChangeTimeL();
		self.indata = 0;
	}
*/
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
	if (self.lefty == A_SKICK)
	{
		self.target = "player";
		self.enemy = world;
		find_Kick();
		if (self.enemy) Admin_kickmenu();
	}


	//else
//	if (self.impulse == A_YES) DoKick(); else
//	if (self.impulse == A_NO) NextKick(); //else
//	if (self.impulse == A_MENU) ShowMenu();
//	self.lefty = 0;
	if (self.admin == 17)
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
	if (admin_time > time) return;
	else if (pk_admincode == SETCODE) 
	{
		pk_admincode = cvar("saved3");
		if ( ! pk_admincode) pk_admincode = -1;
// access impulse now
		localcmd ("setadminimpulse\n");
		pk_adminimp = SETCODE;
		self.impulse = self.admin = 0;
		if (pk_admincode == -1) PK_ADMIN = 0;
	}
	else if (pk_adminimp == SETCODE) 
	{
		pk_adminimp = cvar("saved3");
		if ( ! pk_adminimp) pk_adminimp = 255;
		localcmd ("saved3 0\n");
		self.admin = 0;
		if (pk_adminimp == -1) PK_ADMIN = 0;
if (1) {
bprint("admin impulse: ");
bprint(ftos(pk_adminimp));
bprint(", code: ");
bprint(ftos(pk_admincode));
bprint("\n"); }

	}
	admin_time = time + 0.1;
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
