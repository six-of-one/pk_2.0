// Admin.qc - Remote Administration of a Quake Server
//
// Modified 8/14/96
//
// Doug Keegan
// Rip on IRC/NetQuake
// doug.keegan@tamu.edu


// impulse constants. Change the A_CODEx constants to your 'secret' admin code

// PAINKEEP_START Renumber the impulses, remove the default codes, and change the level options
// -1 for any of these codes means they are disabled
float   A_CODE1 = -1;
float   A_CODE2 = -1;
float   A_CODE3 = -1;
// Level impulses
float   A_PAINKEEP = 100;
float   A_PK0   = 101;
float   A_PK1   = 102;
float   A_PK2   = 103;
float   A_PK3   = 104;
float   A_PK4   = 105;
float   A_PK5   = 106;
float   A_PK6   = 107;
float   A_PK7   = 108;
float   A_PK8   = 109;
float   A_PK9   = 110;
float   A_PK10  = 111;
float   A_PK11  = 112;
float   A_PK12  = 113;
// End of level impulses
float   A_TEAMT = 130;
float   A_DMT   = 131;
float   A_COOPT = 132;
float   A_JUMP  = 133;
float   A_NOEX  = 134;
float   A_GRAVU = 135;
float   A_GRAVD = 136;
float   A_FRICU = 137;
float   A_FRICD = 138;
float   A_START = 139;
float   A_SKICK = 140;
float   A_YES   = 141;
float   A_NO    = 142;
float   A_FRAGL = 143;
float   A_TIMEL = 144;
float   A_MENU  = 145;
// PAINKEEP_END

/*
============
ShowMenu
============
*/
void() ShowMenu =
{
        local string st;
        sprint(self,"\n\n");

        st = ftos(A_TEAMT);
        sprint(self,"Teamplay   ");
        if (A_TEAMT < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"  ");

        st = ftos(A_DMT);
        sprint(self,"Deathmatch ");
        if (A_DMT < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"\n");

        st = ftos(A_COOPT);
        sprint(self,"Coop       ");
        if (A_COOPT < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"  ");

        st = ftos(A_NOEX);
        sprint(self,"Noexit     ");
        if (A_NOEX < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"\n");

        st = ftos(A_JUMP);
        sprint(self,"Nextlevel  ");
        if (A_JUMP < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"  ");

        st = ftos(A_START);
        sprint(self,"Map start  ");
        if (A_START < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"\n");

        st = ftos(A_FRAGL);
        sprint(self,"Fraglimit  ");
        if (A_FRAGL < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"  ");

        st = ftos(A_TIMEL);
        sprint(self,"Timelimit  ");
        if (A_TIMEL < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"\n");

        st = ftos(A_GRAVU);
        sprint(self,"Gravity up ");
        if (A_GRAVU < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"  ");

        st = ftos(A_GRAVD);
        sprint(self,"Gravity dn ");
        if (A_GRAVD < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"\n");

        st = ftos(A_FRICU);
        sprint(self,"Frictn up  ");
        if (A_FRICU < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"  ");

        st = ftos(A_FRICD);
        sprint(self,"Frictn dn  ");
        if (A_FRICD < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"\n");


        st = ftos(A_SKICK);
        sprint(self,"Start kick ");
        if (A_SKICK < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"  ");

        // PAINKEEP_START
        st = ftos(A_PAINKEEP);
        sprint(self,"Map painkeep-pk12  ");
        if (A_PAINKEEP < 100) sprint(self," ");
        sprint(self,st);
        st = ftos (A_PK12);
        sprint(self," - ");
        sprint(self,st);
        // PAINKEEP_END

        sprint(self,"\n");

        st = ftos(A_YES);
        sprint(self,"Answer yes ");
        if (A_YES < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"  ");

        st = ftos(A_NO);
        sprint(self,"Answer no  ");
        if (A_NO < 100) sprint(self," ");
        sprint(self,st);

        sprint(self,"\n\n");

};

/*
============
CheckAdmin
============
*/
void() CheckAdmin =
{
        if (self.impulse == A_CODE1)
        {
                self.admin = 1;
        }
        else
        if ((self.impulse == A_CODE2) && (self.admin == 1))
        {
                self.admin = 2;
        }
        else
        if ((self.impulse == A_CODE3) && (self.admin == 2))
        {
                self.admin = 3;
                sprint(self,"\nAdministration privileges enabled\n");
                sprint(self,"Impulse 145 for menu of commands\n");      // PAINKEEP: Impulse has changed
                self.impulse = 0;																				// PAINKEEP: So the impulse won't be processed
        }
        else
        if (self.admin != 3) self.admin = 0;
};

/*
==========
TeamToggle
==========
*/
void() TeamToggle =
{
        bprint("Teamplay is now ");
        if (cvar("teamplay") == 1)
        {
                bprint("OFF\n");
                localcmd("teamplay 0\n");
        }
        else
        {
                bprint("ON\n");
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
        bprint("Deathmatch is now ");
        if (cvar("deathmatch") == 1)
        {
          // PAINKEEP_START changed from dm2 to dm3
          bprint(" 3\n");
          localcmd("deathmatch 3\n");
          // PAINKEEP_END
        }
        else
        {
                bprint(" 1\n");
                localcmd("deathmatch 1\n");
        }
        bprint("Restarting level with new settings...\n");
        changelevel(mapname);
};

/*
==========
CoopToggle
==========
*/
void() CoopToggle =
{
        bprint("Coop is now ");
        if (cvar("coop") == 1)
        {
                bprint(" 0\n");
                localcmd("coop 0\n");
                localcmd("deathmatch 1\n");
        }
        else
        {
                bprint(" 1\n");
                localcmd("deathmatch 0\n");
                localcmd("coop 1\n");
        }
        bprint("Restarting level with new settings...\n");
        changelevel(mapname);
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
                sprint(self,"NextLevel is not defined");
        else
        {
                bprint("Game moved to next level...\n");
                changelevel(ot.map);
        }
};

/*
==========
ToggleNoExit
==========
*/
void() ToggleNoExit =
{
        bprint("NoExit is now ");
        if (cvar("noexit") == 1)
        {
                bprint("OFF\n");
                localcmd("noexit 0\n");
        }
        else
        {
                bprint("ON\n");
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
        bprint("Game moved to start...\n");
        changelevel("start");
};

/*
==========
MapDM
==========
*/
// PAINKEEP_START Redone for pk
void() MapDM =
{
  local string mname;

  if (self.impulse == A_PAINKEEP) mname = "painkeep";
  else if (self.impulse == A_PK0) mname = "pk0";
  else if (self.impulse == A_PK1) mname = "pk1";
  else if (self.impulse == A_PK2) mname = "pk2";
  else if (self.impulse == A_PK3) mname = "pk3";
  else if (self.impulse == A_PK4) mname = "pk4";
  else if (self.impulse == A_PK5) mname = "pk5";
  else if (self.impulse == A_PK6) mname = "pk6";
  else if (self.impulse == A_PK7) mname = "pk7";
  else if (self.impulse == A_PK8) mname = "pk8";
  else if (self.impulse == A_PK9) mname = "pk9";
  else if (self.impulse == A_PK10) mname = "pk10";
  else if (self.impulse == A_PK11) mname = "pk11";
  else if (self.impulse == A_PK12) mname = "pk12";
  else
    return;

  bprint("Changing map to ");
  bprint(mname);
  bprint("\n");

  changelevel(mname);
};
// PAINKEEP_END

/*
==========
StartKick
==========
*/
void() StartKick =
{
        self.kick = 3;
        self.kicker = find(world, classname, "player");
        sprint(self,"Kick ");
        sprint(self,self.kicker.netname);
        sprint(self,"?\n");
};

/*
==========
DoKick
==========
*/
void() DoKick =
{
        localcmd("kick ");
        localcmd(self.kicker.netname);
        localcmd("\n");
        self.kick = 0;
};

/*
==========
NextKick
==========
*/
void() NextKick =
{
        self.kicker = find(self.kicker, classname, "player");
        if (self.kicker != world)
        {
                sprint(self,"Kick ");
                sprint(self,self.kicker.netname);
                sprint(self,"?\n");
        }
        else
        {
                sprint(self,"End of player list\n");
                self.kick = 0;
        }
};

/*
==========
ChangeTimeL
==========
*/
void() ChangeTimeL =
{
        local string str;
        localcmd("timelimit ");
        str = ftos(self.impulse);
        localcmd(str);
        localcmd("\n");
        bprint("Timelimit changed to ");
        bprint(str);
        bprint("\n");
        self.impulse = 0;
};

/*
==========
ChangeFragL
==========
*/
void() ChangeFragL =
{
        local string str;
        localcmd("fraglimit ");
        str = ftos(self.impulse);
        localcmd(str);
        localcmd("\n");
        bprint("Fraglimit changed to ");
        bprint(str);
        bprint("\n");
        self.impulse = 0;
};

/*
==========
AdminCommands
==========
*/
void() AdminCommands =
{
        if (self.indata > 0)        // PAINKEEP: No need to check for impulse 0 here, this isn't called in that case
        {
                if (self.indata == 1) ChangeFragL();
                if (self.indata == 2) ChangeTimeL();
                self.indata = 0;
        }

        if (self.impulse == A_FRAGL)
        {
                self.indata = 1;
                sprint(self,"Fraglimit?\n");
        }
        else
        if (self.impulse == A_TIMEL)
        {
                self.indata = 2;
                sprint(self,"Timelimit?\n");
        }
        else

        if (self.impulse == A_TEAMT) TeamToggle(); else
        if (self.impulse == A_DMT) DMToggle(); else
        if (self.impulse == A_COOPT) CoopToggle(); else
        if (self.impulse == A_JUMP) JumptoNext(); else
        if (self.impulse == A_NOEX) ToggleNoExit(); else
        if ((self.impulse == A_GRAVU) || (self.impulse == A_GRAVD)) GravToggle(); else
        if ((self.impulse == A_FRICU) || (self.impulse == A_FRICD)) FricToggle(); else
        if (self.impulse == A_START) MapStart(); else
        if ((self.impulse >= A_PAINKEEP)&&(self.impulse <= A_PK12)) MapDM(); else   // PAINKEEP
        if (self.impulse == A_SKICK) StartKick(); else
        if (self.impulse == A_YES) DoKick(); else
        if (self.impulse == A_NO) NextKick(); else
        if (self.impulse == A_MENU) ShowMenu();

};


