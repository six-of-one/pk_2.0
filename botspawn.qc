/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: botspawn.qc
 *
 * date: Fri Apr  4 04:40:02 UTC 2008
 *
 * test 6
 *
 */


void () AddAnotherBot;
void () initBotLevel =
{
	local float num;
	local float offset;
	local float i;
	local entity e;
	local string tmp;
	NOISEQUEUE = noisetarget ();
	num = ((serverflags & BOTS) / 16);
	serverflags = ((serverflags - (serverflags & BOTS)) - INITLEVEL);
	NUMBOTS = 0;
	NUMPATHS = 0;
	NUMPATHERS = 0;
	offset = 1;
	while ( (num > 0) )
	{
		num = (num - 1);
		if ( ((NUMBOTS < 5) && !(serverflags & DEDICATED)) )
		{
			skill = ((0.1 * (parm10 & (offset * 31))) / offset);
		}
		offset = (offset * 32);
		AddAnotherBot ();
	}
	if ( (serverflags & TEAMFLAG) )
	{
		if ( !teamplay )
		{
			serverflags = (serverflags - TEAMFLAG);
			serverflags = (serverflags - (serverflags & TEAMBOTS));
			return ;
		}
	}
	else
	{
		if ( teamplay )
		{
			serverflags = (serverflags + TEAMFLAG);
			serverflags = (serverflags - (serverflags & TEAMBOTS));
			return ;
		}
	}
	if ( !teamplay )
	{
		return ;
	}
	num = ((serverflags & TEAMBOTS) / 256);
	if ( (num == 0) )
	{
		return ;
	}
	e = find (world,classname,"player");
	while ( e )
	{
		i = 0;
		offset = 1;
		while ( (i < num) )
		{
			i = (i + 1);
			if ( ((i < 6) && !(serverflags & DEDICATED)) )
			{
				skill = ((0.1 * (parm11 & (offset * 31))) / offset);
			}
			offset = (offset * 32);
			addTeamBots (e,TRUE);
		}
		e = find (e,classname,"player");
	}
	if ( (serverflags & DEDICATED) )
	{
		serverflags = (serverflags - DEDICATED);
	}
};

void () setBotGravity =
{
	local float newmax;
	local float vel;
	local float sk;
	local string tmp;
	GRAVITY = (cvar ("sv_gravity") * 0.1);
	bprint ("Gravity accel is ");
	tmp = ftos (GRAVITY);
	bprint (tmp);
	bprint ("\n");
	newmax = 0;
	vel = 270;
	MAXJUMP = -1;
	while ( (newmax > MAXJUMP) )
	{
		vel = (vel - GRAVITY);
		MAXJUMP = newmax;
		newmax = (newmax + (vel * 0.1));
	}
	MAXJUMP = (MAXJUMP - 1);
	bprint ("Max jump height is ");
	tmp = ftos (MAXJUMP);
	bprint (tmp);
	bprint ("\n");
	LEVELJUMPTIME = 0;
	vel = 270;
	newmax = 0;
	while ( (newmax > -1) )
	{
		LEVELJUMPTIME = (LEVELJUMPTIME + 0.1);
		vel = (vel - GRAVITY);
		newmax = (newmax + (vel * 0.1));
	}
	LEVELJUMPTIME = (LEVELJUMPTIME - (newmax / vel));
	bprint ("Level jump time is ");
	tmp = ftos (LEVELJUMPTIME);
	bprint (tmp);
	bprint ("\n");
	newmax = 0;
	vel = 200;
	GRENADEMAXHEIGHT = -1;
	while ( (newmax > GRENADEMAXHEIGHT) )
	{
		vel = (vel - GRAVITY);
		GRENADEMAXHEIGHT = newmax;
		newmax = (newmax + (vel * 0.1));
	}
	bprint ("Max grenade height is ");
	tmp = ftos (GRENADEMAXHEIGHT);
	bprint (tmp);
	bprint ("\n");
	INVGRENADELEVELDIST = (((0.1 * 2) * (200 - GRAVITY)) / GRAVITY);
	INVGRENADELEVELDIST = (1/ (INVGRENADELEVELDIST * SEARCH_RADIUS));
	bprint ("inverse grenade level distance is ");
	tmp = ftos (INVGRENADELEVELDIST);
	bprint (tmp);
	bprint ("\n");
	BOTSPEED = (cvar ("sv_maxspeed") / 10);
};

void () PutBotInServer;
float () numplayers;
float (entity e) totalscore;
void () respawnBot =
{
	local string m;
	local float n;
	local float o;
	local entity e;
	CopyToBodyQue (self);
	if ( !teamplay )
	{
		if ( (serverflags & TEAMBOTS) )
		{
			n = (NUMBOTS + numplayers ());
			o = ((serverflags & TEAMBOTS) / 256);
			if ( ((o < n) || (self.team != 99)) )
			{
				self.nextthink = (time + 1);
				if ( (self.team == 99) )
				{
					NUMBOTS = (NUMBOTS - 1);
				}
				remove (self.movetarget);
				remove (self.goalentity);
				self.think = SUB_Remove;
				if ( self.pather )
				{
					NUMPATHERS = (NUMPATHERS - 1);
				}
				if ( (self.team != 99) )
				{
					m = ": I'm going to find a team server.\n";
				}
				else
				{
					if ( (totalscore (self) < 0) )
					{
						m = ": I'm tired of getting fragged.  I'm off\n";
					}
					else
					{
						if ( (totalscore (self) > MUST_HAVE) )
						{
							m = ": I'm going to find some real competition\n";
						}
						else
						{
							m = ": This server's too crowded.  I'm off\n";
						}
					}
				}
				bprint (self.teamname);
				bprint (self.netname);
				bprint (m);
				bprint (self.teamname);
				bprint (self.netname);
				bprint (" left the game with ");
				m = ftos (self.frags);
				bprint (m);
				bprint (" frags\n");
				return ;
			}
		}
	}
	else
	{
		if ( (self.team != 99) )
		{
			e = find (world,classname,"player");
			while ( e )
			{
				if ( (e.team == self.team) )
				{
					PutBotInServer ();
					return ;
				}
				e = find (e,classname,"player");
			}
			bprint (self.teamname);
			bprint (self.netname);
			bprint (": Going off to join my team\n");
			bprint (self.teamname);
			bprint (self.netname);
			bprint (" left the game with ");
			m = ftos (self.frags);
			bprint (m);
			bprint (" frags\n");
			return ;
/*
		}
		else
		{
			if ( (SKINSMODE == 2) )
			{
// CHECK: painkeep damage skins
//				skinChange (self,randombotskin);
			}
*/
		}
	}
	PutBotInServer ();
};

void () bot_pain;
void () BotDie;
void () bot_stand1;
void () bot_walk;
void () bot_run;
void () bot_start;
void () dmbot_melee;
entity () botmovetarget;
void () PutBotInServer =
{
	local entity spwn;
	local vector spot;
	local string tmp;
	local float aimvar;
	self.classname = "dmbot";
	self.health = MUST_HAVE;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.show_hostile = 0;
	self.max_health = MUST_HAVE;
	self.air_finished = (time + 30);
	self.dmg = 1;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;
	self.yaw_speed = (45 + (25 * self.skil));
	self.lefty = STRAFE_DIR;
	if ( (self.goalentity == world) )
	{
		self.goalentity = botmovetarget ();
	}
	self.goalentity.goalentity = world;
	SetNewParms ();
	DecodeLevelParms ();
	W_SetCurrentAmmo ();
	self.search_time = time;
	self.attack_finished = time;
	self.th_pain = bot_pain;
	self.th_die = BotDie;
	self.th_stand = bot_stand1;
	self.th_walk = bot_walk;
	self.th_run = bot_run;
	self.th_melee = dmbot_melee;
	self.th_cache = cacheenemy;
	self.touch = fix_thud;
	self.think = bot_start;
	self.nextthink = (time + 0.1);
	self.enemy = world;
	self.pathtype = NEVERTARGET;
	self.deadflag = DEAD_NO;
	self.pausetime = 0;
	spwn = SelectSpawnPoint ();
	spot = (spwn.origin + '0 0 1');
	self.origin = spot;
	setorigin (self,spot);
	self.angles = spwn.angles;
	self.fixangle = 1;
	setmodel (self,"progs/eyes.mdl");
	modelindex_eyes = self.modelindex;
	setmodel (self,"progs/player.mdl");
	modelindex_player = self.modelindex;
	setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
	if ( (self.movetarget == world) )
	{
		NewCarriedPath ();
	}
	else
	{
		setorigin (self.movetarget,self.origin);
	}
	self.movetarget.movetarget = world;
	clearCache (self);
	if ( self.pather )
	{
		NUMPATHERS = (NUMPATHERS - 1);
		self.pather = 0;
	}
	if ( (NUMPATHERS < MAXPATHERS) )
	{
		self.pather = 1;
		NUMPATHERS = (NUMPATHERS + 1);
	}
	self.view_ofs = '0 0 22';
	makevectors (self.angles);
	spawn_tfog ((self.origin + (v_forward * KINDA_WANT)));
	spawn_tdeath (self.origin,self);
	if ( (BOTSPEED < 32) )
	{
		dprint ("Feeling kind of slow today (SV_MAXSPEED = ");
		tmp = ftos ((BOTSPEED * 10));
		dprint (tmp);
		dprint ("\n");
	}
	aimvar = cvar ("sv_aim");
	if ( (aimvar != 0.930) )
	{
		dprint ("Seems like sv_aim isn't 0.93\n");
	}
};

void () SpawnNewBot =
{
	local string tmp;
// xreaper code - looks good, not qualifying
	if ( intermission_running )
	{
		return ;
	}
	PutBotInServer ();
	bprint (self.teamname);
	bprint (self.netname);
	tmp = ftos (self.skil);
	bprint (" (skill (");
	bprint (tmp);
	bprint (") entered the game.\n");
};

entity () AddBot =
{
	local entity newbot;
	local entity oldself;
	local string mycolor;
	local float plycolor;
	newbot = spawn ();
	oldself = self;
	self = newbot;
	self.think = SpawnNewBot;
	self.nextthink = (time + (12 * random ()));
	self.skil = skill;
	if ( (self.skil < 0) )
	{
		self.skil = 0;
	}
	else
	{
		if ( (self.skil > 3) )
		{
			self.skil = 3;
		}
	}
	initscore ();
	self = oldself;
	return(newbot);
};

float () numplayers =
{
	local entity e;
	local float n;
	n = 0;
	e = find (world,classname,"player");
	while ( e )
	{
		n = (n + 1);
		e = find (e,classname,"player");
	}
	return(n);
};

void () AddAnotherBot =
{
	local entity newbot;
	local entity tmp;
	local float n;
	local string st;
	local float top;
	local float bottom;
	self.impulse = 0;
	if ( !teamplay )
	{
		if ( (serverflags & TEAMBOTS) )
		{
			n = (NUMBOTS + numplayers ());
			if ( ((serverflags & TEAMBOTS) < n) )
			{
				bprint ("Can't add bot - exceeds bound\n");
				return ;
			}
		}
	}
	if ( (fClientNo == 15) )
		return;
  
	newbot = AddBot ();
	newbot.id = FindGood ();
	newbot.colormap = (newbot.id + 1);
	newbot.colormap = 0;
// CHECK: painkeep damageskins
/*
	if ( teamplay )
	{
		skinChange (newbot,randombotskin);
	}
	else
	{
		if ( (SKINSMODE == 1) )
		{
			skinChange (newbot,NUMBOTS);
		}
		else
		{
			if ( (SKINSMODE == 2) )
			{
				st = ftos (((newbot.skil & MOVETYPE_WALK) + 1));
				dprint (st);
				dprint ("= skil skin\n");
				skinChange (newbot,((newbot.skil & MOVETYPE_WALK) + 1));
			}
		}
	}
	newbot.team = 99;
	if ( NAMEBOTS )
	{
		newbot.teamname = self.netname;
	}
	else
	{
		if ( (newbot.skil < 1) )
		{
			newbot.teamname = "[Bot0]";
		}
		else
		{
			if ( (newbot.skil < 2) )
			{
				newbot.teamname = "[Bot1]";
			}
			else
			{
				if ( (newbot.skil < 3) )
				{
					newbot.teamname = "[Bot2]";
				}
				else
				{
					newbot.teamname = "[Bot3]";
				}
			}
		}
	}
 // NOTE: --- disabled team names for now - irritating qbot stuff
*/
	NUMBOTS = (NUMBOTS + 1);
	if ( (NUMBOTS == 1) )
	{
		newbot.nextthink = (time + 0.1);
	}
	if ( (NUMBOTS < 16) )
	{
		serverflags = ((serverflags - (serverflags & BOTS)) + (16* NUMBOTS));
	}
	if ( (NUMBOTS == 1) )
	{
		newbot.netname = "Alpha";
		top = 1;
		bottom = 6;
	}
	else
	{
		if ( (NUMBOTS == 2) )
		{
			newbot.netname = "Gamma";
			top = 2;
			bottom = 13;
		}
		else
		{
			if ( (NUMBOTS == 3) )
			{
				newbot.netname = "Epsilon";
				top = 4;
				bottom = 11;
			}
			else
			{
				if ( (NUMBOTS == 4) )
				{
					newbot.netname = "Delta";
					top = NEVERTARGET;
					bottom = 12;
				}
				else
				{
					if ( (NUMBOTS == 5) )
					{
						newbot.netname = "Zeta";
						top = 12;
						bottom = 13;
					}
					else
					{
						if ( (NUMBOTS == 6) )
						{
							newbot.netname = "Theta";
							top = NAMEBOTS;
							bottom = 4;
						}
						else
						{
							if ( (NUMBOTS == 7) )
							{
								newbot.netname = "Lambda";
								top = 1;
								bottom = NEVERTARGET;
							}
							else
							{
								if ( (NUMBOTS == 8) )
								{
									newbot.netname = "Omicron";
									top = 4;
									bottom = 9;
								}
								else
								{
									if ( (NUMBOTS == 9) )
									{
										newbot.netname = "Xi";
										top = NEVERTARGET;
										bottom = 6;
									}
									else
									{
										if ( (NUMBOTS == 10) )
										{
											newbot.netname = "Rho";
											top = 11;
											bottom = 10;
										}
										else
										{
											if ( (NUMBOTS == 11) )
											{
												newbot.netname = "Sigma";
												top = NAMEBOTS;
												bottom = 13;
											}
											else
											{
												if ( (NUMBOTS == 12) )
												{
													newbot.netname = "Tau";
													top = 13;
													bottom = 11;
												}
												else
												{
													if ( (NUMBOTS == 13) )
													{
														newbot.netname = "Chi";
														top = 12;
														bottom = 11;
													}
													else
													{
														if ( (NUMBOTS == 14) )
														{
															newbot.netname = "Psi";
															top = 9;
															bottom = 13;
														}
														else
														{
															if ( (NUMBOTS == 15) )
															{
																newbot.netname = "Reaper";//Omega";
																top = 10;
																bottom = 9;
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	WriteByte (MSG_ALL,MSG_UPDATENAME);
	WriteByte (MSG_ALL,newbot.id);
	WriteString (MSG_ALL,newbot.netname);
	WriteByte (MSG_ALL,MSG_UPDATECOLORS);
	WriteByte (MSG_ALL,newbot.id);
	WriteByte (MSG_ALL,((top * 16) + bottom));
	WriteByte (MSG_ALL,MSG_UPDATEFRAGS);
	WriteByte (MSG_ALL,newbot.id);
	WriteShort (MSG_ALL,newbot.frags);
};

void (entity ply, float n) addTeamBots =
{
	local entity newbot;
	local entity tmp;
	local float i;
	i = n;
	while ( (i > 0) )
	{
		newbot = AddBot ();
		newbot.colormap = ply.colormap;
		newbot.team = ply.team;
		newbot.teamname = ply.netname;
		skinChange (newbot,ply.skin);
		if ( (newbot.skil < 1) )
		{
			newbot.netname = "[Bot0]";
		}
		else
		{
			if ( (newbot.skil < 2) )
			{
				newbot.netname = "[Bot1]";
			}
			else
			{
				if ( (newbot.skil < 3) )
				{
					newbot.netname = "[Bot2]";
				}
				else
				{
					newbot.netname = "[Bot3]";
				}
			}
		}
		i = (i - 1);
	}
};

void (entity ply, float n) removeTeamBots =
{
	local float i;
	local entity e;
	i = n;
	e = find (world,classname,"dmbot");
	while ( (i > 0) )
	{
		while ( ((e != world) && (e.team != ply.team)) )
		{
			e = find (e,classname,"dmbot");
		}
		if ( !e )
		{
			return ;
		}
		if ( e.pather )
		{
			NUMPATHERS = (NUMPATHERS - 1);
		}
		remove (e.movetarget);
		remove (e.goalentity);
		remove (e);
		i = (i - 1);
	}
};

void () removeAllBots =
{
	local entity e;
	e = find (world,classname,"dmbot");
	while ( e )
	{
		if ( !e )
		{
			return ;
		}
		if ( e.pather )
		{
			NUMPATHERS = (NUMPATHERS - 1);
		}
		remove (e.movetarget);
		remove (e.goalentity);
		remove (e);
		e = find (e,classname,"dmbot");
	}
	NUMBOTS = 0;
	bprint ("All bots removed.\n");
};

void (float n) SetMaxBots =
{
	local float t;
	local string tmp;
	self.impulse = 0;
	if ( (serverflags & TEAMFLAG) )
	{
		bprint ("Entering bounded deathmatch mode\n");
		serverflags = ((serverflags - TEAMFLAG) - (serverflags & TEAMBOTS));
	}
	bprint ("Max bots + players set to ");
	tmp = ftos (n);
	bprint (tmp);
	bprint ("\n");
	serverflags = ((serverflags - (serverflags & TEAMBOTS)) + (n * 256));
	t = numplayers ();
	while ( ((NUMBOTS + t) < n) )
	{
		AddAnotherBot ();
	}
};

void (float n) SetTeamBots =
{
	local float t;
	local entity e;
	local string tmp;
	self.impulse = 0;
	if ( !(serverflags & TEAMFLAG) )
	{
		bprint ("Entering bot team mode\n");
		serverflags = ((serverflags + TEAMFLAG) - (serverflags & TEAMBOTS));
	}
	bprint ("Bots per player team set to ");
	tmp = ftos (n);
	bprint (tmp);
	bprint ("\n");
	t = ((serverflags & TEAMBOTS) / 256);
	serverflags = ((serverflags - (serverflags & TEAMBOTS)) + (n * 256));
	if ( (t < n) )
	{
		e = find (world,classname,"player");
		t = (n - t);
		while ( e )
		{
			addTeamBots (e,t);
			e = find (e,classname,"player");
		}
		return ;
	}
	if ( (t > n) )
	{
		e = find (world,classname,"player");
		while ( e )
		{
			t = (t - n);
			removeTeamBots (e,t);
			e = find (e,classname,"player");
		}
		return ;
	}
};

void () UpdateTeamColors =
{
	local entity e;
	e = find (world,classname,"dmbot");
	while ( e )
	{
		if ( (e.colormap == self.colormap) )
		{
			e.team = self.team;
		}
		e = find (e,classname,"dmbot");
	}
};

