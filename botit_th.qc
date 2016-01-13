/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: botit_th.qc
 *
 * date: Fri Apr  4 04:40:02 UTC 2008
 *
 * final qc
 *
 */


float last_time_left;
float randombotskin;
float nearlight;
float () CheckWaterLevel;
float () CheckDropPath;
void () DropBotPath;
void () initscore;
void () endEnemy;
float () BotFoundTarget;
vector () botaim;
void () botImpulseCommand;
void (entity killer, entity killed) countkill;
void (entity ply, float n) removeTeamBots;
void (entity ply, float n) addTeamBots;
void (entity e, float newskin) skinChange;
void () NewCarriedPath;
void (entity a, entity b) addTarget;
void () initBotLevel;
void (entity en2) secondEnemy;
void () bot_toucheditem;
void (entity node, entity targ, float len, entity item) cacheRoute;
void () setBotGravity;
void () bot_touched;
void () enemy_touched;
void (entity bot) bot_triggered;

void (entity noisemaker, entity noiseobject) signalnoise;
float (entity e) hearnoise;
entity () noisetarget;
float (entity targ) Spotvisible;
float (entity targ) Platvisible;
float (vector spot) dropline;
void () secret_touch;

.float(entity e) th_weight;
.float(entity node, float len, entity item) th_cache;
.void() th_update;
.float istrigger;
//.float healtype;
.float playerkills;
.float playerdeaths;
.float botkills;
.float botdeaths;
.float suicides;
.vector lastseenpos;
.float enemyrun;
.float goody_time;
.float strafetime;
.float strafeonly;
.void() strafethink;
.float strafeyaw;
.float strafedist;
.entity movetarget2;
.entity movetarget3;
.entity movetarget4;
.entity movetarget5;
.entity movetarget6;
.entity lastbot;
.float lasttime;
.float pather;
.float pathtype;
.float skil;
.float rocketlen;
.entity rocketcache;
.float lightninglen;
.entity lightningcache;
.float armorlen;
.entity armorcache;
.float pendinglen;
.entity pendingcache;
.float naillen;
.entity nailcache;
.float grenadelen;
.entity grenadecache;
.float poweruplen;
.entity powerupcache;
.float enemylen;
.entity enemycache;
.float endpoint;
.string teamname;

float NORMALSCORE			= 1;
float MYSCORE					= 2;
float DONT_WANT				= 0;
float KINDA_WANT				= 20;
float WANT						= 35;
float MUST_HAVE				= 100;
float SEARCH_RADIUS			= 600;
float LOOPTIME				= 20;
float MAXPATHERS				= 16;
float REGULARTARGET	 		= 0;
float CARRIED					= 1;
float DROPPED					= 2;
float NEVERTARGET			= 3;
float TELEPORT				= 4;
float BOTS						= 240;
float TEAMBOTS				= 3840;
float UNRESTRICTED				= 4096;
float TEAMFLAG				= 16384;
float INITLEVEL				= 32768;
float DEDICATED				= 4194304;
float LOCAL_TIME				= 7;
float CANTURN					= 1;
float NOTURN					= 2;
float STRAFE_DIR				= 16;
float FAR_SEEK				= 32;
float WATERUPDOWN			= 64;
float NODROP					= 128;
float RUNAWAY					= 256;
float GETGOODY				= 512;
float ONTRAIN					= 1024;
float MULTIENEMY				= 2048;

float VERBOSEBOT;
float BOTSPEED;
float NUMBOTS;
float GRAVITY;
float MAXJUMP;
float INVGRENADELEVELDIST;
float GRENADEMAXHEIGHT;
float LEVELJUMPTIME;
float NUMPATHS;
float NUMGIBS;
float NUMPATHERS;
float SKINSMODE;
float RECURSEDEPTH;
vector REBOUNDSPOT;
float REBOUND;
float TELEFRAGFLAG;
entity NOISEQUEUE;
float HELPING;
float NAMEBOTS;


float (entity e) doorweight =
{
	local float weight;
	weight = KINDA_WANT;
	if (e.owner.targetname)
	{
		weight = DONT_WANT;
	}
	else if (e.touch == secret_touch)
	{
		weight = KINDA_WANT;
	}
	else if (e.state == STATE_TOP)
	{
		weight = DONT_WANT;
	}
	else if (e.state == STATE_UP)
	{
		weight = KINDA_WANT;
	}
	if (!Spotvisible (e))
	{
		weight = DONT_WANT;
	}
	return(weight);
};

float (entity e) buttonweight =
{
	local float weight;
	weight = DONT_WANT;
	if (e.state == STATE_BOTTOM)
	if (Spotvisible (e))
	{
		weight = (KINDA_WANT + 1);
	}
	return(weight);
};

float (entity e) platweight =
{
	local float weight;
	weight = KINDA_WANT;
	if (!Platvisible (e))
	if (!Spotvisible (e))
	{
		weight = DONT_WANT;
	}
	return(weight);
};

float (entity e) trigpushweight =
{
	local float weight;
	local vector spot;
	local vector org;
	weight = DONT_WANT;
	org = ((e.absmin + e.absmax) * 0.5);
	org_z = (e.absmin_z + 1);
	spot = org;
	spot_z = self.origin_z;
	traceline (self.origin,spot,TRUE,self);
	if (trace_fraction == 1)
	{
		traceline (spot,org,TRUE,self);
		if (trace_fraction == 1)
		{
			spot_z = dropline (org);
			if (self.absmin_z > spot_z)
			{
				spot_z = self.absmin_z;
			}
			if (org_z < (((self.maxs_z - self.mins_z) + spot_z) + MAXJUMP))
			{
				weight = KINDA_WANT;
			}
		}
	}
	return(weight);
};

float (entity e) triggerweight =
{
	local float weight;
	local float rnd;
	weight = (KINDA_WANT - 2);
	rnd = random ();
	if (rnd < 0.250)
	{
		weight = WANT;
	}
	if (!Spotvisible (e))
	{
		weight = DONT_WANT;
	}
	return(weight);
};

float (entity e) backpackweight =
{
	local float lnd;
	local float weight;
	weight = WANT;
	lnd = pointcontents (e.absmin + '0 0 1');
	if (e.items & (IT_ROCKET_LAUNCHER + IT_LIGHTNING))
	{
		weight = (MUST_HAVE - 1);
	}
	if ((lnd == CONTENT_LAVA) || (lnd == CONTENT_SLIME))
	{
		weight = DONT_WANT;
	}
	return(weight);
};

float (entity e) healthweight =
{
	local float weight;
	weight = WANT;
	if (self.health < 60)
	{
		weight = (MUST_HAVE - 1);
	}
	else if (e.healtype == 2)
	{
		weight = MUST_HAVE;
	}
	else if (self.health > 99)
	{
		weight = DONT_WANT;
	}
	return(weight);
};

float (entity e) nailweight =
{
	local float weight;
	weight = (WANT - 1);
	if (self.ammo_nails > 199)
	{
		weight = DONT_WANT;
	}
	else
	{
		if (self.ammo_nails > 120)
		{
			weight = (KINDA_WANT - 2);
		}
	}
	return(weight);
};

float (entity e) shellweight =
{
	local float weight;
	weight = (WANT - 1);
	if (self.ammo_shells > 99)
	{
		weight = DONT_WANT;
	}
	else
	{
		if (self.ammo_shells > 50)
		{
			weight = (KINDA_WANT - 2);
		}
	}
	return(weight);
};

float (entity e) cellweight =
{
	local float weight;
	weight = WANT;
	if (self.ammo_cells > 99)
	{
		weight = DONT_WANT;
	}
	return(weight);
};

float (entity e) rocketweight =
{
	local float weight;
	weight = WANT;
	if (self.ammo_rockets > 99)
	{
		weight = DONT_WANT;
	}
	return(weight);
};

float (entity e) rlauncherweight =
{
	local float weight;
	weight = (WANT + 2);
	if (!(self.items & IT_ROCKET_LAUNCHER))
	{
		weight = MUST_HAVE;
	}
	return(weight);
};

float (entity e) lightningweight =
{
	local float weight;
	weight = (WANT + 2);
	if (!(self.items & IT_LIGHTNING))
	{
		weight = MUST_HAVE;
	}
	return(weight);
};

float (entity e) glauncherweight =
{
	local float weight;
	weight = (WANT + 1);
	if (!(self.items & IT_GRENADE_LAUNCHER))
	{
		weight = (MUST_HAVE - 1);
	}
	return(weight);
};

float (entity e) nailgunweight =
{
	return(WANT);
};

float (entity e) supernailweight =
{
	local float weight;
	weight = (WANT + 1);
	if (!(self.items & IT_SUPER_NAILGUN))
	{
		weight = (MUST_HAVE - 1);
	}
	return(weight);
};

float (entity e) ssgweight =
{
	return(WANT);
};

float (entity e) armorweight =
{
	local float weight;
	weight = (e.armorvalue - self.armorvalue);
	return(weight);
};

float (entity e) artifactweight =
{
	local float weight;
	weight = (MUST_HAVE + 2);
	if (e.classname == "item_artifact_envirosuit")
	{
		weight = WANT;
	}
	return(weight);
};

float (entity node, float len, entity item) cacherocket =
{
	if (node.rocketlen > 0)
	{
		if (len >= node.rocketlen)
		{
			return (0);
		}
	}
	node.rocketlen = len;
	node.rocketcache = item;
	return (1);
};

float (entity node, float len, entity item) cachelightning =
{
	if (node.lightninglen > 0)
	{
		if (len >= node.lightninglen)
		{
			return (0);
		}
	}
	node.lightninglen = len;
	node.lightningcache = item;
	return (1);
};

float (entity node, float len, entity item) cachearmor =
{
	if (node.armorlen > 0)
	{
		if (len >= node.armorlen)
		{
			return (0);
		}
	}
	node.armorlen = len;
	node.armorcache = item;
	return (1);
};

float (entity node, float len, entity item) cachenail =
{
	if (node.naillen > 0)
	{
		if (len >= node.naillen)
		{
			return (0);
		}
	}
	node.naillen = len;
	node.nailcache = item;
	return (1);
};

float (entity node, float len, entity item) cachegrenade =
{
	if (node.grenadelen > 0)
	{
		if (len >= node.grenadelen)
		{
			return (0);
		}
	}
	node.grenadelen = len;
	node.grenadecache = item;
	return (1);
};

float (entity node, float len, entity item) cachepowerup =
{
	if (node.poweruplen > 0)
	{
		if (len >= node.poweruplen)
		{
			return (0);
		}
	}
	node.poweruplen = len;
	node.powerupcache = item;
	return (1);
};

float (entity node, float len, entity item) cacheenemy =
{
	if (node.enemylen > 0)
	{
		if (len >= node.enemylen)
		{
			return (0);
		}
	}
	node.enemylen = len;
	node.enemycache = item;
	return (1);
};

void () updaterocket =
{
	self.rocketcache = self.pendingcache;
	self.rocketlen = self.pendinglen;
};

void () updatelightning =
{
	self.lightningcache = self.pendingcache;
	self.lightninglen = self.pendinglen;
};

void () updatearmor =
{
	self.armorcache = self.pendingcache;
	self.armorlen = self.pendinglen;
};

void () updatepowerup =
{
	self.powerupcache = self.pendingcache;
	self.poweruplen = self.pendinglen;
};

void () updatenail =
{
	self.nailcache = self.pendingcache;
	self.naillen = self.pendinglen;
};

void () updategrenade =
{
	self.grenadecache = self.pendingcache;
	self.grenadelen = self.pendinglen;
};

float (entity e) dont_weight =
{
	return(DONT_WANT);
};

void () CopyrightNotice =
{
	dprint (" The Quake C modifications included in this archive are Copyright 1996, Steven Polge.");
	dprint ("The original QuakeC source is Copyright 1996, id software.");
	dprint ("All new non-derivitive code (c) 2007 Cataboligne.");
};

void () printIntro =
{
	local float num;
	local float skinno;
	if (teamplay)
	{
		if (parm4 > 511)
		{
			SKINSMODE = ((parm4 & 49152) / 16384);
			skinno = (parm4 & 7680);
			parm4 = (parm4 & 511);
			skinChange (self,skinno);
		}
		num = ((serverflags & TEAMBOTS) / 256);
		if (num > 0)
		{
			addTeamBots (self,num);
		}
		centerprint (self,"Server running team pk*bots v1.1\nand PainKeep v1.1");
	}
	else
	{
		centerprint (self,"Server running pk*bots v1.1\nand PainKeep v1.1");
	}
};

// Cataboligne - xreaper add in code implement
float XRP = 1; // if true xreap code will be used
