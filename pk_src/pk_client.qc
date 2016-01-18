/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: pk_client.qc
 *
 * date: Mon Jun 21 UTC 2010
 *
 * final qc
 *
 */

// special parms - for respawn

void() q100_SetChangeParms;
void() q100_SetNewParms;
void() q100_DecodeLevelParms;
float	modelindex_eyes, modelindex_player;
void () q100_ClientKill;
void () set_suicide_frame;
void () respawn;
void() q100_PutClientInServer;
void() player_stand1;
void() player_pain;
void() PlayerDie;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;
void () q100_ClientConnect;
void () q100_ClientDisconnect;
void () ExitIntermission;
void () IntermissionThink;
void () q100_CheckPowerups;


void() SetNewParms_PK =
{
	parm1 = IT_SHOTGUN | IT_AXE;
	parm2 = 100;
	parm4 = 25;
	parm3 = parm5 = parm6 = parm7 = parm9 = 0;
	parm8 = 1;
	parm16 = MOTDTIME + 1;

	parm10 = parm11 = 0;
	if(self.pk_items & PK_IT_EXTRADISP)
	{
		parm16 = parm16 | PK_IT_EXTRADISP;
	}

// Cataboligne 2.18.11 - set defaults code
	parm6 = -6;

	cam_parms(2);
};

// called from SetChangeParms - saves off pk parms for level change

void() SetChangeParms =
{
	if (find(world,classname,"pk*bot")) bot_changeParms();

	if (Q_100)
	{
		q100_SetChangeParms();
		return;
	}
// Cataboligne 9.11.3 purify - chase cam
	cam_parms(0);

	if (self.health <= 0 || self.classname == OBSERVER) // Cataboligne - 5.3.10 - fix level change issue when in dead observer or admin observer
	{
		SetNewParms_PK();
		parm16 = parm16 | 256; // Cataboligne - 8.22.9 - pk orig oper
		return ;
	}
// remove items
	self.items = self.items - (self.items & (IT_KEY1 | IT_KEY2 | IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD));

// cap super health
	if (self.health > 100)
		self.health = 100;
	if (self.health < 50)
		self.health = 50;
	parm1 = self.items;
	parm2 = self.health;
	parm3 = self.armorvalue;
	if (self.ammo_shells < 25)
		parm4 = 25;
	else
		parm4 = self.ammo_shells;
	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
	parm8 = self.weapon;
	parm9 = self.armortype * 100;
	parm10 = parm11 = parm15 = parm16 = 0;

	parm10 = PK_IT_AXE | self.pk_items;
// recode so *bot can have vars for skill level save - provide max inventory of 15 for mod expansion, current max is 3 on most except for explode ammo

	parm11 = self.pk_explode_ammo + ((self.pk_turretammo & 3) * 16) + ((self.pk_canpabammo & 3) * 64) + ((self.pk_beartrapammo & 3) * 256) + ((self.pk_gravitywellammo & 3) * 1024)

// Cataboligne 8.12.9 purify - pk artifacts
	 + ((self.pkplus_egoammo & 3) * 4096) + ((self.pkplus_tombammo & 3) * 16384) + ((self.pkplus_actorammo & 3) * 65536) + ((self.pkplus_phoneammo & 3) * 262144);
// end pk_art

	// do hub message.
	parm16 = self.msgcount | 256; // | (self.pk_items & PK_IT_EXTRADISP);
};

// called from SetNewParms - clears pk parms

void() SetNewParms =
{
	if (Q_100)
	{
		q100_SetNewParms();
		return;
	}

	parm1 = IT_SHOTGUN | IT_AXE;
	parm2 = 100;
	parm3 = 0;
	parm4 = 25;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = 1;
	parm9 = 0;
//	parm10 = PK_IT_AXE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_CANPAB | PK_IT_BEARTRAP; // deprecated - not really used
//	parm11 = parm12 = parm13 = parm14 = parm15 = 0; // chasecam change
		parm10 = parm11 = 0;
// do hub message.
	parm16 = 256;

	if (pk_flags & PK_TP_STATUSON)
	{
		parm16 = parm16 | PK_IT_EXTRADISP;
	}

// Cataboligne 2.18.11 - set defaults code
	parm6 = -6;

// Cataboligne 9.11.3 purify - chase cam
	cam_parms(2);
};

// called from DecodeLevelParms - restores pk parms on new level


void() DecodeLevelParms = 
{
	if (Q_100)
	{
		q100_DecodeLevelParms();
		return;
	}

	if (serverflags)
	{
		if (world.model == "maps/start.bsp" && !inHubMap) // Cataboligne - 5.19.10 - q1 SP hack for using forced dyn items
			SetNewParms ();   // take away all stuff on starting new episode
		if (world.model == "maps/qstart.bsp") SetNewParms();
	}
//	bot_skinDecode();

	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	if (parm6 > 0) self.ammo_rockets = parm6;
	else self.ammo_rockets = 0;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	self.armortype = parm9 * 0.01;

	self.pk_items = parm10 | (parm16 & PK_IT_EXTRADISP); // fix PK mode false map to PK mode true map
	self.pk_explode_ammo = parm11 & 15;
	self.pk_turretammo = floor(parm11 / 16) & 3;
	self.pk_canpabammo = floor(parm11 / 64) & 3;
	self.pk_beartrapammo = floor(parm11 / 256) & 3;
	self.pk_gravitywellammo = floor(parm11 / 1024) & 3;

// Cataboligne 8.12.9 purify - pk artifacts
	self.pkplus_egoammo = floor(parm11 / 4096) & 3;
	self.pkplus_tombammo = floor(parm11 / 16384) & 3;
	self.pkplus_actorammo = floor(parm11 / 65536) & 3;
	self.pkplus_phoneammo = floor(parm11 / 262144) & 3;
// end pk_art

	self.msgcount = (parm16 & 255);

	if (parm6 == -6) set_defaults(self);

// Cataboligne 9.11.3 purify - chase cam
	cam_parms(1);
};

void() PK_GotoNextMap =
{
	if (!Q_100 && !Q_99 && !PK_ADMINMAP)
	if (pk_flags & PK_TP_USERMAPON) // *pk - user supplied map loop deal
	{
		if (!execed)
		{
			execed = 1;
			localcmd ("pknextmap\n");
		}
		return;
	}

	if(!PK_100 && !PK_ADMINMAP) 
	{
		if (check_custom_hub()) // *pk --- Cataboligne - 8.16.9 - do custom hub load from any exit here
			return;
	}
};

/*
============
ClientKill

Player entered the suicide command
============
*/

void () ClientKill =
{
	if (Q_100)
	{
		q100_ClientKill();
		return;
	}
	bprint (self.netname);
	bprint (" suicides\n");
	set_suicide_frame();
	self.modelindex = modelindex_player;
	if (!NOCIDE)
	self.frags = self.frags - 2 * frag_minus(self);	// extra penalty
	respawn ();
};

// called from PutClientInServer

void(entity spot) ClearSpawnPoint =
{
	local	entity thing;

	if (deathmatch < 2)
		return;

	thing = findradius(spot.origin, 80);
	while(thing)
	{
	 if (thing.solid == SOLID_TRIGGER && thing.takedamage == DAMAGE_NO &&
	 			thing.classname != "trigger_teleport")
	 {
	 	// crash point!!!
		// make it respawn...
		thing.solid = SOLID_NOT;
		 thing.model = string_null;
		thing.nextthink = time + 10;
		 thing.think = SUB_regen;
	 }
	 else if (thing.think == SUB_regen)
	 {
		thing.nextthink = thing.nextthink + 10;
	 }

	 thing = thing.chain;
	}
};

// called from PutClientInServer

// notes: does not include info_player_start - regular q1 dm spawn select does
//			 if in single player & PK mode set for pk items, spawn is random.

// fixing these if not in PK_100

// IDEA: if no spawns, use whatever is available - ammo, teleports, etc. - dont give away goodies

entity() PK_SelectSpawnPoint =
{
	local	entity spot, newspot, thing;
	local	float	numspots, totalspots;
	local	float	rnum, pcount;
	local	float	rs;
	local entity spots;

	numspots = 0;
	totalspots = 0;

// testinfo_player_start is only found in regioned levels - NOTE: if this ever spawns, this is DUMB code for dm
	spot = find (world, classname, "testplayerstart");
	if (PK_100 || (!deathmatch && !coop) || cvar("saved1") == 666) // if a developer wanted this in dm | coop they need to set saved1
	if (spot)
		return spot;

// choose a info_player_deathmatch point

// not PK_100 - support single player & coop - hey this is a request

 if (!PK_100)
 {
	if (coop)
	{
		lastspawn = find (lastspawn,classname,"info_player_coop");
		if (lastspawn == world)
			lastspawn = find (lastspawn,classname,"info_player_start");
		if (lastspawn != world)
			return lastspawn;
	}
	else if (!deathmatch)
	{
		if (serverflags & 15)
		{	// return with a rune to start
			spot = find (world,classname,"info_player_start2");
			if (spot)
				return spot;
		}

		spot = find (world,classname,"info_player_start");
		if (!spot)
		{
			if (PK_100 && PK_100_OBJERR)
				error ("PutClientInServer: no info_player_start on level");
			else
				bprint ("*** Warning: PutClientInServer: no info_player_start on level - looking for dm start");
		}
		else
			return(spot);
	}
 }
 
// ok, find all spots that don't have players nearby

	spots = world;
	spot = find (world, classname, "info_player_deathmatch");
// IDEA: if there are no dm spawns, and dm is set & !PK_100, make some (cvar control?)
	while (spot)
	{
		totalspots = totalspots + 1;

		thing=findradius(spot.origin, 256);
		pcount=0;
		while (thing)
		{
			if (thing.classname == "player" || thing.classname == "pk*bot") // NOTE: could be reason for bot spawn frag bork - didnt see pk*bot
				pcount=pcount + 1;
			thing=thing.chain;
		}
		if (pcount == 0) {
			spot.goalentity = spots;
			spots = spot;
			numspots = numspots + 1;
		}

		// Get the next spot in the chain
		spot = find (spot, classname, "info_player_deathmatch");
	}
	totalspots=totalspots - 1;
	if (!numspots)
	{
		// ack, they are all full, just pick one at random
//		bprint (PRINT_HIGH, "Ackk! All spots are full. Selecting random spawn spot\n");
		totalspots = rint((random() * totalspots));
		spot = find (world, classname, "info_player_deathmatch");
		while (totalspots > 0) {
			totalspots = totalspots - 1;
			spot = find (spot, classname, "info_player_deathmatch");
		}
		return spot;
	}

// We now have the number of spots available on the map in numspots

	// Generate a random number between 1 and numspots

	numspots = numspots - 1;

	numspots = rint((random() * numspots) );

	spot = spots;
	while (numspots > 0) {
		spot = spot.goalentity;
		numspots = numspots - 1;
	}
	return spot;

};

// config players for admin on spawn & map for players if cfg avail

// code sets admin kby config & tries to run map commands - {mapname}.cfg file and any alias {mapname}_mapcmd

void() pk_plcfg =
{
	if (self.ishuman)
	{
		pk_admincfg(self);
		if (pk_mapcmd) // alias cmd
		{
			stuffcmd(self, mapname);
			stuffcmd(self, ADMINMAPCMD);
		}
		if (pk_mapcfg) // cfg file cmd
		{
			stuffcmd(self, "exec ");
			stuffcmd(self, mapname);
			stuffcmd(self, ".cfg\n");
		}
// q3 map cfg
		if (DARKPLACES)
		{
			stuffcmd(self, Q3_BOBHOFF);
//			if (!pk_map) // not a pk map (some hubX maps have no .wad!)
//			if (world.wad == "") // q3 map? - then set bob
			if (!Q_100 && !PK_100)
			if (MAP_MODE == "Q3")
				q3_bob_height();
		}
	}
};

// called from PutClientInServer

//void() PK_CIS =
void() PutClientInServer =
{
	local entity spot;

	set_initBotLevel(); // *bot

	self.admin = 0;
	self.rune_flag = 0;

	if (Q_100 || Q_99)
	{
		if (Q_99)
		{
			AddToSplashBig(self);
			Chase_cam_level_start(); // Cataboligne 8.9.9 purify - chase cam
		}
		q100_PutClientInServer(); // always encoding now
		return;
	}

	spot = PK_SelectSpawnPoint (); // *pk - get a spawn point, pk style 
	ClearSpawnPoint(spot); // *pk

	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.effects = 0;
	self.invincible_time = 0;

	DecodeLevelParms ();

	W_SetCurrentAmmo ();

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;

	self.deadflag = DEAD_NO;
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;

//	spot = SelectSpawnPoint ();

	self.origin = spot.origin + '0 0 1';
	self.angles = spot.angles;
	self.fixangle = TRUE;		// turn this way immediately

// oh, this is a hack!
	setmodel (self,"progs/eyes.mdl");
	modelindex_eyes = self.modelindex;

	setmodel (self,"progs/player.mdl");
	modelindex_player = self.modelindex;

	setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);

	self.view_ofs = ' 0 0 22';

	player_stand1 ();

	if (deathmatch || coop)
	{
		makevectors (self.angles);
		spawn_tfog (self.origin + v_forward*20);
	}

	spawn_tdeath (self.origin,self);


	pk_plcfg();
	self.pk_items = self.pk_items | PK_IT_AXE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_CANPAB | PK_IT_BEARTRAP
																	| PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE; // Cataboligne 8.12.9 purify - pk artifacts

	grap_releaseHarpoon();
	self.pk_currentInventory = self.pk_currentitem = PK_IT_AXE;
	self.beartrap_time = 0;
	self.bt_immune_time = time + BT_BUFFER;
	self.voteIntermission = 0;

	self.skin = 0;

	self.grap_owner = world;

	self.bolt_target = world;
	self.bolt_targetNext = world;
	self.bolt_targetTimeout = 0;
	self.bolt_targetNextTimeout = 0;
	if (self.bolt_targetTimeoutEntity)
	{
		remove(self.bolt_targetTimeoutEntity);
	}
	self.bolt_targetTimeoutEntity = world;
	self.bolt_conduitTimeout = 0;
	self.bolt_changeModelTimeout = 0;
	if (self.bolt_lightningFire)
	{
		remove(self.bolt_lightningFire);
	}
	self.bolt_lightningFire = world;

// PK - not a disconnected player entity
	self.disconnectPlayer = 0;
// end CIS stuff

// set wep cycle vars
	self.lastweapon = self.weapon;
	self.prevweapon = self.weapon;
	self.pklastweapon = self.pk_currentitem;
	self.pkprevweapon = self.pk_currentitem;

	stuffcmd(self, CL_BOBSET); // restore bobing - may have come from a hub vote

	self.pkplus_actortype = 0; // Cataboligne 8.12.9 purify - pk artifacts

//	self.alpha = 0.5; // testing

//	if (!PK) return;

	if (inHubMap)
	{ // give the respawn guy a fighting chance...
		self.items = self.items | IT_INVULNERABILITY;
		self.invincible_time = 1;
		self.invincible_finished = time + 15;

		// PAINKEEP timeout for the hub "how to vote" message.
		if (parm16 & 256)
		{
			self.hubstartupmessage = time + 15;
		}
	}

	// PAINKEEP SPLASH Make this entity splash
	AddToSplashBig(self);
	
	ominous_hum("", 1); // clear any stray hum

	// PAINKEEP Fix the velocity on respawn bug
	self.velocity = '0 0 0';

	Chase_cam_level_start(); // Cataboligne 8.9.9 purify - chase cam
};

/*
cant find the sound files

// called from playerjump - commented out, not really called
// NOTE: recoded to override the default jump sound to minimize changes

void() pk_jump_sound =
{
	local float rs;
	rs = rint((random() * 4) + 1);

	if (rs == 1)
		sound (self, CHAN_BODY, "player/jump_1.wav", 1, ATTN_NORM);
	else if (rs == 2)
		sound (self, CHAN_BODY, "player/jump_2.wav", 1, ATTN_NORM);
	else if (rs == 3)
		sound (self, CHAN_BODY, "player/jump_3.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_BODY, "player/jump_4.wav", 1, ATTN_NORM);
};

// called from water_move - same deal

void() pk_gasp_sound =
{
	if (self.air_finished < time)
	{
	 	local float rs;

		rs = rint((random() * 2) + 1);

		if (rs == 1)
			sound (self, CHAN_BODY, "player/gasp_2.wav", 1, ATTN_NORM);
		else if (rs == 2)
			sound (self, CHAN_BODY, "player/gasp_3.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_BODY, "player/gasp_4.wav", 1, ATTN_NORM);
	}
	else if (self.air_finished < time + 9)
	{
			if (random() < 0.5)
				sound (self, CHAN_VOICE, "player/gasp_1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_VOICE, "player/gasp_5.wav", 1, ATTN_NORM);
	}
}
*/
/*
================
CheckPowerups

Check for turning off powerups
================
*/

void () CheckPowerups =
{
	if (Q_100)
	{
		q100_CheckPowerups();
		return;
	}

	if (self.classname == OBSERVER) // Cataboligne 8.9.9 purify - chase cam (dead) & observer - clear all effects
	{
		self.super_damage_finished = self.invisible_finished = self.invincible_finished = self.radsuit_finished = 0;
		self.super_time = self.invisible_time = self.invincible_time = self.rad_time = 0;
		self.items = self.items - (self.items & (IT_QUAD | IT_SUIT | IT_INVISIBILITY | IT_INVULNERABILITY));
		self.effects = 0;
		return;
	}						// NOTE: great place for some interesting chaos effects

	if (self.health <= 0)
		return;

	if (self.ishuman)
	if (self.x_items & X_PWR_ARMOR_ON || self.x_items & X_PWR_SCREEN_ON)
	{
		if ((time & 3) == 3 || (time & 3) == 2)
		{
			if (self.armorvalue <1) self.armorsave = -1;
			if (!self.armorsave) self.armorsave = self.armorvalue;
			self.armorvalue = self.ammo_cells;
		}
		else
		if (self.armorsave)
		{
			if (self.armorsave < 1) self.armorvalue = 0;
			else self.armorvalue = self.armorsave;
			self.armorsave = 0;
		}
	}
	else
	if (self.armorsave)
	{
		if (self.armorsave < 1) self.armorvalue = 0;
		else self.armorvalue = self.armorsave;
		self.armorsave = 0;
	}

// invisibility
	if (self.invisible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.invisible_finished < time + 3)
		{
			if (self.invisible_time == 1)
			{
				sprint (self, "Ring of Shadows magic is fading\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}

			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invisible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVISIBILITY;
			self.invisible_finished = 0;
			self.invisible_time = 0;
		}

	// use the eyes
		self.frame = 0;
		self.modelindex = modelindex_eyes;
	}
	else
		self.modelindex = modelindex_player;	// don't use eyes

	// invincibility
	if (self.invincible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				if  (self.pkplus_actortype == PKPLUS_ACTORPENT) // pk art code here
					sprint (self,"Get ready to leave the RED stage - Good Performance!\n");
				else
					sprint (self, "Protection is almost burned out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}

			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invincible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
			if (self.pkplus_actortype == PKPLUS_ACTORPENT) // pk art code here
			{
				self.pkplus_actortype = 0;
				pk_setDamageSkin(self); // remove the pent costume
			}
		}
		if (self.invincible_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}

// super damage
	if (self.super_damage_finished)
	{
// sound and screen flash when items starts to run out

		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				if (self.pkplus_actortype == PKPLUS_ACTORQUAD) // pk art code here
					sprint (self,"The BLUE Curtain is dropping - You really frightened them!\n");
				else
					sprint (self, "Quad Damage is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}

			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{	// just stopped
			self.items = self.items - IT_QUAD;
			self.super_damage_finished = 0;
			self.super_time = 0;
			if (self.pkplus_actortype == PKPLUS_ACTORQUAD)
				self.pkplus_actortype = 0;
		}
		if (self.super_damage_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
	}


// suit
	if (self.radsuit_finished)
	{
		self.air_finished = time + 12;		// don't drown

// sound and screen flash when items starts to run out
		if (self.radsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				sprint (self, "Air supply in Biosuit expiring\n");
				stuffcmd (self, "bf\n");
				if (self.noise3 != "")
					sound (self, CHAN_AUTO, self.noise3, 1, ATTN_NORM);
				else
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}

			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.radsuit_finished < time)
		{	// just stopped
			self.items = self.items - (self.items & IT_SUIT);
			self.rad_time = 0;
			self.radsuit_finished = 0;
		}
	}

	if (self.wetsuit_finished) // hip wetsuit (not in yet), q2 rebreather
	{
		self.air_finished = time + 12;		// don't drown

		if (self.wetsuit_finished < time + 3)
		{
			if (self.rad_time == 1)
			{
				if (!self.items & IT_SUIT)
				{
					sprint (self, "Air supply in Re-breather expiring\n"); // IDEA: item stored messages
					sound (self, CHAN_AUTO, "q2_snd/airout.wav", 1, ATTN_NORM);
				}
				else
				{
				sprint (self, "Air supply in Enviro suit expiring\n");
//				sound (self, CHAN_AUTO, self.noise3, 1, ATTN_NORM);
				sound (self, CHAN_AUTO, "q3_snd/airout.wav", 1, ATTN_NORM); // IDEA: make item store .noise3 work
				}

				stuffcmd (self, "bf\n");
				self.rad_time = time + 1;
			}

			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.wetsuit_finished < time)
		{	// just stopped
			self.items = self.items - (self.items & IT_SUIT); // re-breather does not set suit flag
			self.rad_time = 0;
			self.wetsuit_finished = 0;
		}
	}

};


//void() pk_pre_think =

void () PlayerPreThink =
{
	if (FRIKBOT)
	if (BotPreFrame ())
		return ;

	if (Q_100)
	{
		q100_PlayerPreThink();
		return;
	}

	if (intermission_running)
	{
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

	makevectors (self.v_angle);		// is this still used

// removed from WaterMove, it has to be done every frame.
	if (! (self.flags & FL_WATERJUMP))
		self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;

	if (cc_frame != framecount) // Cataboligne - 6.10.10 - making this a frame check - only way splashes will look "right"
// PAINKEEP SPLASH Check for entities splashing
		CheckWaterLevels();

	if (self.pk_dutychecking == 0)
	{
		CheckRules ();
		WaterMove ();

	 if (self.waterlevel == 2)
		CheckWaterJump ();

//		if (!Q_100 && !PK_100)
		if (self.waterlevel)
		if (! self.flags & FL_WATERJUMP)
		if (self.cam_x & CHSCAM_ON)
		{
			cam_waterjump();  // Cataboligne 8.22.9 purify - chase cam
		}

	}
	else if (time > self.pk_dutychecking)
	{
		CheckRules ();
		WaterMove ();

	if (self.waterlevel == 2)
		CheckWaterJump ();

		if (self.waterlevel)
		if (! self.flags & FL_WATERJUMP)
		if (self.cam_x & CHSCAM_ON)
		{
			cam_waterjump();  // Cataboligne 8.22.9 purify - chase cam
		}

	}

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}

	if (self.deadflag == DEAD_DYING)
		return;	// dying, so do nothing

	if (self.button2)
	{
		PlayerJump ();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

// NOTE: morph flyers, jetpack
	if (self.rune_flag & RUNE_FLG_FLY) flyer_move(); // Cataboligne - 7.26.10 - flyer mouse-fly right code from chaos mod flight

// teleporters can force a non-moving pause time
	if (time < self.pausetime)
		self.velocity = '0 0 0';

// PAINKEEP_START
	if (time > self.attack_finished)
//	if (self.currentammo == 0)
	if (!HasAmmo(self.weapon, self.pk_currentitem))
	if (!ammo_con(self.weapon, self, "wpck"))
	if (self.weapon != IT_AXE || self.pk_currentitem != PK_IT_AXE)
	{
		self.weapon = W_BestWeapon ();
		self.pk_currentitem = W_BestPKWeapon ();
		W_SetCurrentAmmo ();
	}

// GRAPPLING
	grap_maintainHarpoon();
	self.oldorigin = self.origin;

	if (self.pk_dutychecking == 0)
	{
		updateStatusDisplay();
	}
	else if (time > self.pk_dutychecking)
	{
		updateStatusDisplay();
	}
};

float vw_bot_frame; // handle pk*bots

//void() pk_post_think =
void () PlayerPostThink =
{
	if (vw_bot_frame != framecount)  // run these things once this frame
	{
		viswep_pkbot();
		if (find(world, classname, LOOPSOUND)) loop_play(); // play on looped sounds
	}

	if (FRIKBOT)
	if (BotPostFrame ())
		return ;

	if (find(world,classname,"pk*bot"))
  {
		if ((self.view_ofs != '0 0 0') && !self.deadflag)
		if (CheckDropPath ()) // *bot
		{
			DropBotPath ();
		}

		if (DARKPLACES || chaos)
		if (cvar("botlevel")) // hack so alias can load new map & keep pk*bots - set by console command aliases for map & changelevel - bmap & blvl
		{
			bot_changelevel(); // map change MUST happen - this clears bots from map!
	//		bot_changeParms(); // save bots for change
			cvar_set("botlevel", "0");
		}
  }

	viswep_post(); // Cataboligne - 9.26.9 - viswep code link - always have to run this for 1 player + pk*bots deal

	if ((PK_ADMIN && !ADMINLOCK) || (self.admin == USER_MENU && self.view_ofs != '0 0 0')) // *pk - run admin for both modes - any deactivation will 0 this || make sure user menu always works
	if (self.admin || (self.impulse == pk_adminimp))
	if (pk_adminframe != framecount)
	if (admin_postthink()) return;

	if (chaos)
		if (!(self.cam_x & CHSCAM_ON))  // Cataboligne - 5.14.10 - cam purify - custom engine dont display vw_ for 1pv
			{
//			if (!(self.flags & FL_NDISMDL)) bprint("switching to not display vwep\n");
			self.flags = self.flags | FL_NDISMDL; // old self.flags method, replacing with:
			}
		else
			{
//			if (self.flags & FL_NDISMDL) bprint("switching to display vwep\n");
			self.flags = self.flags - (self.flags & FL_NDISMDL);
			}

// runes - these qaulify the below 2 tests in the call!
	if (self.rune_flag & RUNE_FLG_RG) rune_regen();

	if (Q_100 || Q_99) // CHECK: q99-ness effect hereish
	{
		q100_PlayerPostThink();
		return;
	}


	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale


	if (self.deadflag)
	// BOLT_START
	{
		if (self.deadflag == DEAD_DYING && self.bolt_conduitTimeout > time) // it's the conduit time for this player...
		{
			// make sure the player think is set correctly
			self.think = player_conduitJerk;
		}
		return;	 // dying, so do nothing
	}


// do weapon stuff

	if (!XENV)
	if (WEPHUM)
	if (self.eweapon)
	if (self.eweapon.fly_sound != HUMLOCAL)
	if (self.eweapon.noise2 != "")
	if (self.chaosweptime < time)
//		if (self.eweapon.weapon != MC_AIRGUN)
		ominous_hum(self.eweapon.noise2, self.eweapon.chaosweptime);

	if (self.ammo_rockets < self.ammo_hgrenade) self.ammo_hgrenade = self.ammo_rockets; // NOTE: while rockets & grenades are the same ammo q1 style

	if (time < self.attack_finished)
		return;

	if (self.attack_finished < time) W_WeaponFrame ();

	if (self.classname != OBSERVER) // Cataboligne - 8.16.9 - dont need this for observers
// check to see if player landed and play landing sound
	if ((self.jump_flag < -300) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_BODY, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -650)
		{
			T_Damage (self, world, world, 5);
			//sound (self, CHAN_VOICE, "player/fall_2.wav", 1, ATTN_NORM);
			sound (self, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
			self.deathtype = "falling";
		}
		else
			sound (self, CHAN_VOICE, "player/land.wav", 1, ATTN_NORM);
			//sound (self, CHAN_VOICE, "player/fall_1.wav", 1, ATTN_NORM);

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

	// If it's air blast time, blow entity's
	if (self.AIRG_BlastTimeout > time)
	{
		horn_airblast(FALSE);
	}

// PK_DUTYCHECKING_START
	if (self.pk_dutychecking == 0)
	{
		bolt_checkTargets();

		CheckPowerups ();

		if (self.copb_timeout)
		{
			if (self.copb_timeout >= time)
			{
				copb_checkFart();
			}
			else
			{
				self.copb_timeout = 0;
			}
		}

		if (pk_flags & PK_TP_DUTYON)
		{
			self.pk_dutychecking = time + 0.5;
		}
	}
	else if (time > self.pk_dutychecking)
	{
		bolt_checkTargets();

		CheckPowerups ();

		if (self.copb_timeout)
		{
			if (self.copb_timeout >= time)
			{
				copb_checkFart();
			}
			else
			{
				self.copb_timeout = 0;
			}
		}

		if (pk_flags & PK_TP_DUTYON)
		{
			self.pk_dutychecking = time + 0.5;
		}
		else
		{
			self.pk_dutychecking = 0;
		}
	}
	else
	{
		if (!(pk_flags & PK_TP_DUTYON))
		{
			self.pk_dutychecking = 0;
		}
	}
};

// called from client connect

//void() pk_clientconnect =
void () ClientConnect =
{
	local float v;

	if (FRIKBOT) ClientInRankings (); // sets .ishuman for humans
	bot_con(TRUE); // *bot - doesnt depend on active bots, must always happen
	if (Q_100 || Q_99)
	{
		q100_ClientConnect();
		return;
	}


	v = random() * 6;
	bprint (self.netname);
	if (v < 1)
	{
		bprint(" joined the carnage\n");
	}
	else if (v < 2)
	{
		bprint(" joined the fragging\n");
	}
	else if (v < 3)
	{
		bprint(" dropped in for tea\n");
	}
	else if (v < 4)
	{
		bprint(" entered the fragfest\n");
	}
	else if (v < 5)
	{
		bprint(" came to die\n");
	}
	else
	{
		bprint(" entered the game\n");
	}

// a client connecting during an intermission can cause problems
	if (intermission_running)
		ExitIntermission ();
// MOTD_START
//	self.msgcount = 1;
};

// called from client disconnect

//void() pk_clientdisconnect =
void () ClientDisconnect =
{
	if (FRIKBOT) ClientDisconnected ();
	bot_con(FALSE); // *bot

	if (gameover)
		return;
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving

	if (!Q_100 && !Q_99)
	{
// PK - set flag so that we know that it's a disconnected entity.
		self.disconnectPlayer = 1;

		grap_releaseHarpoon();
		self.beartrap_time = 0;
		self.voteIntermission = 0;

		self.grap_owner = world;

		self.bolt_target = world;
		self.bolt_targetNext = world;
		self.bolt_targetTimeout = 0;
		self.bolt_targetNextTimeout = 0;
		if (self.bolt_targetTimeoutEntity)
		{
			remove(self.bolt_targetTimeoutEntity);
		}
		self.bolt_targetTimeoutEntity = world;
		self.bolt_conduitTimeout = 0;
		self.bolt_changeModelTimeout = 0;
		if (self.bolt_lightningFire)
		{
			remove(self.bolt_lightningFire);
		}
		self.bolt_lightningFire = world;

		admin_sv_cfg();

		bprint (self.teamname);
	}
// normal disc
	q100_ClientDisconnect();
};

// fn(frag_plus) - return frag to add if frags should be counted after death & ffw limit set

// test entity e

float(entity e) frag_plus =
{
	if (FFW_LIMIT > 0)
	if (e.deadflag)
	if (e.search_time < time)
		return(0);

	return(1); // chaos mod vector!
};

// fn(frag_minus) - return frag to *** subtract ***

// test entity e

float(entity e) frag_minus =
{
	return(1); // chaos mod vector!
};

// fn(no*cide) - dont count some suicide frags

// frag already removed - so we add it back in - chaos mod vectors

// no suicide frags at all
void(entity e) nocide =
{
	if (NOCIDE) e.frags = e.frags + 1;
};

// no environment suicide frags
void(entity e) noenvcide =
{
	if (!NOCIDE && NOENVCIDE) e.frags = e.frags + 1;
};

// called from killed - updated client obit for pk items

void(entity targ, entity inflictor, entity attacker) PK_ClientObituary =
{
	local	float rnum;
	local	string deathstring, deathstring2;
	rnum = random();

	if (targ.classname == "player")
	{
		if (attacker.classname == "teledeath")
		{
			bprint (targ.netname);
			bprint (" was telefragged by ");
			bprint (attacker.owner.netname);
			bprint ("\n");

			attacker.owner.frags = attacker.owner.frags + frag_plus(attacker.owner);
			return;
		}

		if (attacker.classname == "teledeath2")
		{
			bprint ("Satan's power deflects ");
			bprint (targ.netname);
			bprint ("'s telefrag\n");

			targ.frags = targ.frags - frag_minus(targ);
			return;
		}

// Cataboligne 8.12.9 purify - pk artifacts
		if (inflictor.classname == "ego")
		{
			rnum = random ();
			bprint (targ.netname);
			if (inflictor.owner == targ)
			{
				targ.frags = (targ.frags - frag_minus(targ));
				nocide(targ);
				if (rnum < 0.250)
					bprint (" had a mental breakdown!\n");
				else if (rnum < 0.5)
					bprint (" let his EGO get out of control!\n");
				else if (rnum < 0.750)
					bprint ("'s own EGO was self destructive!\n");
				else
					bprint ("'s EGO sometimes has a mind of its own!\n");
				return;
			}
			attacker.frags = (attacker.frags + frag_plus(attacker));
			if (rnum < 0.250)
				bprint (" was impressed by the power of ");
			else if (rnum < 0.5)
				bprint (" was counseled by ");
			else if (rnum < 0.750)
				bprint (" was overpowered by ");
			else
				bprint (" was manipulated by ");
			bprint (attacker.netname);
			bprint ("'s EGO\n");
			return;
		}
		if (inflictor.classname == "corpse")
		{
			rnum = random ();
			bprint (targ.netname);
			if (inflictor.owner == targ)
			{
				targ.frags = (targ.frags - frag_minus(targ));
				nocide(targ);
				if (rnum < 0.250)
					bprint (" was caught robbing the family grave!\n");
				else if (rnum < 0.5)
						bprint (" could not get away from a relative's corpse\n");
				else if (rnum < 0.750)
					bprint (" should not have gone for the family's jewelry\n");
				else
					bprint (" was brought down by an old friend\n");
				return;
			}
			attacker.frags = (attacker.frags + frag_plus(attacker));
			if (rnum < 0.250)
				bprint (" was dragged down by an old friend in ");
			else if (rnum < 0.5)
				bprint (" was laid to rest by ");
			else if (rnum < 0.750)
				bprint (", poor kid, got tuckered out dragging someone in ");
			else
				bprint (" should not have defiled ");
			bprint (attacker.netname);
			bprint ("'s Tomb\n");
			return;
		}
// end pk_art

		if (attacker.classname == "player" ||  attacker.classname == OBSERVER) // Cataboligne 9.23.9 - attacker could have died & become observer
		{
			if (targ == attacker)
			{
				// killed self
				attacker.frags = attacker.frags - frag_minus(attacker);
				nocide(targ);
				bprint (targ.netname);

				if ((inflictor.weapon == IT_LIGHTNING) || ((inflictor.weapon == IT_AXE) && (targ.pk_currentitem == PK_IT_CLIGHT)) && attacker.waterlevel > 1)
				{
					bprint (" discharges into the water.\n");
					return;
				}

				if (inflictor.weapon == IT_AXE && inflictor.pk_currentitem == PK_IT_GRAVITYWELL)
				{
					bprint (" visits another dimension\n");
					return;
				}

				if (inflictor.weapon == IT_AXE && inflictor.pk_currentitem == PK_IT_BEARTRAP)
				{
					bprint (" forget about his beartrap\n");
					return;
				}

				if (inflictor.weapon == IT_GRENADE_LAUNCHER)
					bprint (" tries to put the pin back in\n");
				else
					bprint (" becomes bored with life\n");
				return;
			}
			else if ((teamplay == 2) && (targ.team > 0)&&(targ.team == attacker.team))
			{
				if (rnum < 0.25)
					deathstring = " mows down a teammate\n";
				else if (rnum < 0.50)
					deathstring = " checks his glasses\n";
				else if (rnum < 0.75)
					deathstring = " gets a frag for the other team\n";
				else
					deathstring = " loses another friend\n";
				bprint (attacker.netname);
				bprint (deathstring);
				attacker.frags = attacker.frags - frag_minus(attacker);
				return;
			}
			else
			{
				attacker.frags = attacker.frags + frag_plus(attacker);

				// For the correct death messages
				//rnum = attacker.weapon;
				rnum = inflictor.weapon;

				if (rnum == IT_AXE)
				{
// PAINKEEP_START
					if (inflictor.pk_currentitem == PK_IT_AXE)
					{
						deathstring = " was ax-murdered by ";
						deathstring2 = "\n";
					}
					else if (inflictor.pk_currentitem == PK_IT_AIRGUN)
					{
// AIRG_WEAPON_START

// Death messages for the AirFist.

						if (targ.health < -40)
						{
							deathstring = " was gibbed by ";
						deathstring2 = "'s wind!\n" ;
						}
						else
						{
							bprint (attacker.netname);
							bprint (" blows ");
							bprint (targ.netname);
							bprint ("\n");
							return;
						}
					}
// AIRG_WEAPON_END
// GRAPPLING_START
					else if (inflictor.pk_currentitem == PK_IT_GRAPGUN)
					{
						deathstring = " got ";
						deathstring2 = "'s point\n";
					}
// GRAPPLING_END
					else if (inflictor.pk_currentitem == PK_IT_BEARTRAP)
					{
						deathstring = " was clamped by ";
						deathstring2 = "\n";
					}
					else if (inflictor.pk_currentitem == PK_IT_GRAVITYWELL)
					{
						deathstring = " fountains in front of ";
						deathstring2 = "\n";
					}
// BOLT_START
					else if (inflictor.pk_currentitem == PK_IT_CLIGHT)
					{
						if (attacker.waterlevel > 1)
						{
							deathstring = " accepts ";
							deathstring2 = "'s discharge\n";
						}
						else
						{
							bprint (attacker.netname);
							bprint (" short-circuits ");
							bprint (targ.netname);
							bprint ("\n");
							return;
						}
					}
// BOLT_END
// PAINKEEP_END
				}
				if (rnum == IT_SHOTGUN)
				{
// EXPLODESHELLS_START
					if (inflictor.classname == "ExplodeShellsAttack")
					{
						bprint (attacker.netname);
						bprint (" turns ");
						bprint (targ.netname);
						bprint (" into pulpy red chunks\n");
						return;
					}
					else
					{
						deathstring = " chewed on ";
						deathstring2 = "'s boomstick\n";
					}
// EXPLODESHELLS_END
				}
				if (rnum == IT_SUPER_SHOTGUN)
				{
// EXPLODESHELLS_START
					if (inflictor.classname == "ExplodeShellsAttack")
					{
						bprint (attacker.netname);
						bprint (" turns ");
						bprint (targ.netname);
						bprint (" into a fine red mist\n");
						return;
					}
					else
					{
						deathstring = " ate 2 loads of ";
						deathstring2 = "'s buckshot\n";
			 		}
// EXPLODESHELLS_END
				}
				if (rnum == IT_NAILGUN)
				{
// PULSE_GUN_START
					deathstring = " was nailed by ";
					deathstring2 = "\n";
// PULSE_GUN_END
				}
				if (rnum == IT_SUPER_NAILGUN)
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
				}
				if (rnum == IT_GRENADE_LAUNCHER)
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s grenade\n";
					}
				}
				if (rnum == IT_ROCKET_LAUNCHER)
				{
					deathstring = " rides ";
					deathstring2 = "'s rocket\n";
					if (targ.health < -40)
					{
						deathstring = " was gibbed by ";
						deathstring2 = "'s rocket\n" ;
					}
				}
				if (rnum == IT_LIGHTNING)
				{
					deathstring = " accepts ";
					if (attacker.waterlevel > 1)
						deathstring2 = "'s discharge\n";
					else
						deathstring2 = "'s shaft\n";
				}
				bprint (targ.netname);
				bprint (deathstring);
				bprint (attacker.netname);
				bprint (deathstring2);
			}
			return;
		}
		else if (attacker.classname == "CDM" || attacker.class_select == "CDM") // Cataboligne - 2.20.11 - customized death messages
		{
			if (attacker.noise1) bprint(attacker.noise1); // pre strings
			if (attacker.deadflag & 1) bprint(targ.netname); // use targ name
			if (attacker.netname) bprint(attacker.netname); // main message
			if (attacker.noise) bprint(attacker.noise); // other strings
			bprint("\n");
			if (attacker.frags) targ.frags = targ.frags - (attacker.frags * frag_minus(targ)); 
			if (attacker.deadflag & 2) noenvcide(targ);
			return;
		}
// TURRET_START
	 else if (attacker.classname == "turret" || attacker.classname == "turret_gib")
	 {
			bprint(targ.netname);

	 	// check if killed the droper of the turret.
		if (attacker.owner == targ) {
				// killed self
				targ.frags = targ.frags - frag_minus(targ);
				bprint(" forgot to hide from his own AutoSentry!\n");
			return;
		}

		// increase frags & print message.
		attacker.owner.frags = attacker.owner.frags + frag_plus(attacker.owner);

		bprint(" was ventilated by ");
		bprint(attacker.owner.netname);
		bprint("'s AutoSentry\n");
		return;
	 }
// TURRET_END
		else
		{
			targ.frags = targ.frags - frag_minus(targ);
			nocide(targ);

			bprint (targ.netname);

			// killed by a montser?
			if (attacker.flags & FL_MONSTER)
			{
				if (attacker.classname == "monster_army")
					bprint (" was shot by a Grunt\n");
				if (attacker.classname == "monster_demon1")
					bprint (" was eviscerated by a Fiend\n");
				if (attacker.classname == "monster_dog")
					bprint (" was mauled by a Rottweiler\n");
				if (attacker.classname == "monster_dragon")
					bprint (" was fried by a Dragon\n");
				if (attacker.classname == "monster_enforcer")
					bprint (" was blasted by an Enforcer\n");
				if (attacker.classname == "monster_fish")
					bprint (" was fed to the Rotfish\n");
				if (attacker.classname == "monster_hell_knight")
					bprint (" was slain by a Death Knight\n");
				if (attacker.classname == "monster_knight")
					bprint (" was slashed by a Knight\n");
				if (attacker.classname == "monster_ogre")
					bprint (" was destroyed by an Ogre\n");
				if (attacker.classname == "monster_oldone")
					bprint (" became one with Shub-Niggurath\n");
				if (attacker.classname == "monster_shalrath")
					bprint (" was exploded by a Vore\n");
				if (attacker.classname == "monster_shambler")
					bprint (" was smashed by a Shambler\n");
				if (attacker.classname == "monster_tarbaby")
					bprint (" was slimed by a Spawn\n");
				if (attacker.classname == "monster_vomit")
					bprint (" was vomited on by a Vomitus\n");
				if (attacker.classname == "monster_wizard")
					bprint (" was scragged by a Scrag\n");
				if (attacker.classname == "monster_zombie")
					bprint (" joins the Zombies\n");

				return;
			}

			// tricks and traps
			if (attacker.classname == "explo_box")
			{
				bprint (" blew up\n");
				return;
			}
			if (attacker.solid == SOLID_BSP && attacker != world)
			{
				bprint (" was squished\n");
				noenvcide(targ);
				return;
			}
			if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
			{
				bprint (" was spiked\n");
				return;
			}
			if (attacker.classname == "fireball")
			{
				bprint (" ate a lavaball\n");
				noenvcide(targ);
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint (" tried to leave\n");
				return;
			}

			// in-water deaths
			rnum = targ.watertype;
			if (rnum == -3)
			{
				if (random() < 0.5)
					bprint (" sleeps with the fishes\n");
				else
					bprint (" sucks it down\n");
				noenvcide(targ);
				return;
			}
			else if (rnum == -4)
			{
				if (random() < 0.5)
					bprint (" gulped a load of slime\n");
				else
					bprint (" can't exist on slime alone\n");
				noenvcide(targ);
				return;
			}
			else if (rnum == -5)
			{
				noenvcide(targ);
				if (targ.health < -15)
				{
					bprint (" burst into flames\n");
					return;
				}
				if (random() < 0.5)
					bprint (" turned into hot slag\n");
				else
					bprint (" visits the Volcano God\n");
				return;
			}

			// fell to their death?
			if (targ.deathtype == "falling")
			{
				targ.deathtype = "";
				bprint (" fell to his death\n");
				noenvcide(targ);
				return;
			}

			// its worse than that - he's dead Jim
			bprint (" died\n");
		}
	}
};
