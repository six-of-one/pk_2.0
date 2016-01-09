/*

adaptive painkeep code main file
(i.e. - adaptive - its easy to add to other mods)

Cataboligne 3.29.8

*/

// precache all PK items here - relocated from world.qc

void() PK_precache =
{
// old ambient sounds for pk_mode not set to PK

	precache_sound ("alt_ambience/windfly.wav");
	precache_sound ("alt_sounds/items/r_item2.wav");
	precache_sound ("alt_sounds/misc/secret.wav");

// New teleport sounds
	precache_sound ("misc/teleport/tele_1.wav");
	precache_sound ("misc/teleport/tele_2.wav");
	precache_sound ("misc/teleport/tele_3.wav");
	precache_sound ("misc/teleport/tele_4.wav");
	precache_sound ("misc/teleport/tele_1a.wav");
	precache_sound ("misc/teleport/tele_2a.wav");
	precache_sound ("misc/teleport/tele_3a.wav");
	precache_sound ("misc/teleport/tele_4a.wav");

// SPLASH
	precache_model ("progs/s_splash.spr");
	precache_model ("progs/s_splava.spr");


// extra gibs ...
	precache_model ("progs/g_arm.mdl");
	precache_model ("progs/g_boot.mdl");
	precache_model ("progs/g_eye.mdl");
	precache_model ("progs/g_fore.mdl");
	precache_model ("progs/g_leg.mdl");

// Gib1 alternative
	precache_model ("progs/qtgib1.mdl");

// Gib2 alternatives
	precache_model ("progs/qtgib2.mdl");

// h_player alternative
	precache_model ("progs/qtgib3.mdl");

// Painkeep item pickup sound
	precache_sound("misc/pickup/tone2.wav");

// view models
	precache_model ("progs/v_bear.mdl");
	precache_model ("progs/v_turret.mdl");
	precache_model ("progs/v_harp.mdl");
	precache_model ("progs/v_cube.mdl");
	precache_model ("progs/v_beans.mdl");

// files used in the AirFist.
	precache_model ("progs/v_airgun.mdl");	// Player view of airgun
	precache_model ("progs/s_ablast.spr");	// Air Gun Fire sprite

// weapon precache


	// TURRET_START
	precache_model ("progs/nail.mdl");
	precache_model ("progs/turgib1.mdl");
	precache_model ("progs/turgib2.mdl");
	precache_model ("progs/turgib3.mdl");
	precache_model ("progs/turstand.mdl");
	precache_model ("progs/turtop.mdl");
	precache_sound ("weapons/sentry/turrt_3.wav");
	precache_sound ("weapons/sentry/turcl_2b.wav");

	// GRAVITY Moved to here so the cheat command would work correctly
	precache_model ("progs/cubsmall.mdl");
	precache_model ("progs/cube.mdl");
	precache_model ("progs/cubel.mdl");
	precache_sound ("misc/grav/grav_new.wav");
	precache_sound ("items/protect.wav");

	// AIRG_MAIN_START
	// prechache the AirFist fire sounds.
	precache_sound ("weapons/airfist/agfire.wav");		// Air gunfire
	precache_sound ("weapons/airfist/agfail.wav");		// Air gunfailed fire
	precache_sound ("weapons/airfist/agwater.wav");	 // Air gun	under water shot
	precache_sound ("weapons/airfist/agwfail.wav");	 // Air gun fail water shot

	// GRAPPLING_START
	precache_sound ("weapons/grapple/graph_2b.wav");	// Hit solid
	precache_sound ("weapons/grapple/grapf_1.wav");	 // Hit fresh
	precache_sound ("weapons/grapple/grapl_2.wav");	 // Launch
	precache_sound ("weapons/grapple/grapr_2.wav");	 // Rope going out
	precache_sound ("weapons/grapple/graps_2.wav");	 // Rope coming back
	precache_model ("progs/harpoon.mdl");
	precache_model ("progs/harprope.mdl");
	precache_model ("progs/harpcoil.mdl");
	precache_model ("progs/g_harp.mdl");
	precache_model ("progs/v_harp.mdl");
	precache_sound ("misc/null.wav");

	// BOLT_START
	precache_model ("progs/v_cl_off.mdl");
	precache_model ("progs/v_cl_on.mdl");
	precache_sound ("weapons/clight/clight_1.wav");
	precache_model ("progs/fryguy.mdl");

	precache_model ("progs/v_fnail.mdl");

	// COPB_START
	precache_sound ("weapons/copb/copb_1.wav");	// Fart sounds...
	precache_sound ("weapons/copb/copb_2.wav");
	precache_sound ("weapons/copb/copb_3.wav");
	precache_sound ("weapons/copb/copb_4.wav");
	precache_sound ("weapons/copb/copb_5.wav");

// PULSE_GUN_START
	precache_model ("progs/g_fnail.mdl");
	precache_model ("progs/pnail.mdl");
	precache_model ("progs/v_fnail.mdl");
	precache_sound ("weapons/pulse/pulse_1.wav");
	precache_sound ("weapons/pulse/ric_1.wav");
	precache_sound ("weapons/pulse/ric_2.wav");
	precache_sound ("weapons/pulse/ric_3.wav");

	// BEARTRAP
	precache_sound ("weapons/btrap/btrap_1.wav");
	precache_sound ("weapons/btrap/bdrop_1.wav");
	precache_sound ("weapons/btrap/btrap_3.wav");
	precache_model ("progs/beartrap.mdl");
	precache_model ("progs/bearbld.mdl");
	precache_model2 ("progs/beargib1.mdl");
	precache_model2 ("progs/beargib2.mdl");
	precache_model2 ("progs/beargib3.mdl");
	precache_model2 ("progs/beargib4.mdl");

// EXPLODESHELLS_START
	precache_model ("progs/v_eshot.mdl");
	precache_model ("progs/v_eshot2.mdl");
	precache_sound ("weapons/explode/expfire1.wav");
	precache_sound ("weapons/explode/expfire2.wav");
	precache_model ("progs/x_explo1.spr");
	precache_model ("progs/x_explo2.spr");

// for the Hub map pop respawn
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");

// extra player sounds
	precache_sound ("player/gib_1.wav");
	precache_sound ("player/gib_2.wav");
	precache_sound ("player/gib_3.wav");

// set PK mode based on engine var | temp2

	if (!chaos) chaos = cvar("chaos");
	if (chaos == DARKPLACES_ENGINE)
	{
		registercvar("sv_pk_mode", "0");
		pk_mode = cvar("sv_pk_mode");
	}
	else
	{
		pk_mode = cvar("temp2") & 3;
	}

// got mode, set PK master switch
	PK = FALSE;
	if (pk_mode & PK_ALWAYS)
		PK = TRUE;
	else if (pk_mode & PK_NEVER)
		PK = FALSE;
	else // if (pk_mode == PK_MAP)
	{
		if (world.model == "maps/start.bsp" && world.message == "hub") PK = TRUE;
		else if (world.model == "maps/pk0.bsp") PK = TRUE;
		else if (world.model == "maps/pk1.bsp") PK = TRUE;
		else if (world.model == "maps/pk2.bsp") PK = TRUE;
		else if (world.model == "maps/pk3.bsp") PK = TRUE;
		else if (world.model == "maps/pk4.bsp") PK = TRUE;
		else if (world.model == "maps/pk5.bsp") PK = TRUE;
		else if (world.model == "maps/pk6.bsp") PK = TRUE;
		else if (world.model == "maps/pk7.bsp") PK = TRUE;
		else if (world.model == "maps/pk8.bsp") PK = TRUE;
		else if (world.model == "maps/pk9.bsp") PK = TRUE;
		else if (world.model == "maps/pk10.bsp") PK = TRUE;
		else if (world.model == "maps/pk11.bsp") PK = TRUE;
		else if (world.model == "maps/pk12.bsp") PK = TRUE;
		else if (world.model == "maps/pk13.bsp") PK = TRUE;
		else if (world.model == "maps/pk14.bsp") PK = TRUE;
		else if (world.model == "maps/pk15.bsp") PK = TRUE;
		else if (world.model == "maps/pk16.bsp") PK = TRUE;
		else if (world.model == "maps/pk17.bsp") PK = TRUE;
		else if (world.model == "maps/pk18.bsp") PK = TRUE;
		else if (world.model == "maps/painkeep.bsp") PK = TRUE;
		else PK = FALSE; // can still be set by map items
	}

// extra sounds by...are apparently not supplied, except gib_?.wav

	pk_xsound = (pk_mode & PK_XSOUND);
	/*
// extra player pain sounds
	if (pk_xsound)
	{
	precache_sound ("player/pain_1.wav");
	precache_sound ("player/pain_2.wav");
	precache_sound ("player/pain_3.wav");
	precache_sound ("player/pain_4.wav");
	precache_sound ("player/pain_5.wav");
	precache_sound ("player/pain_6.wav");
	precache_sound ("player/pain_7.wav");

// extra player death sounds
	precache_sound ("player/death_1.wav");
	precache_sound ("player/death_2.wav");
	precache_sound ("player/death_3.wav");
	precache_sound ("player/death_4.wav");
	precache_sound ("player/death_5.wav");
	precache_sound ("player/death_6.wav");
	precache_sound ("player/death_7.wav");
	precache_sound ("player/death_8.wav");
	precache_sound ("player/death_9.wav");
	precache_sound ("player/death_10.wav");
	precache_sound ("player/death_11.wav");


// misc sounds that mark has replaced.

	precache_sound ("player/suck_1.wav");
	precache_sound ("player/suck_2.wav");
	precache_sound ("player/suck_3.wav");
	precache_sound ("player/suck_4.wav");
	precache_sound ("player/suck_5.wav");
	precache_sound ("player/suck_6.wav");
	precache_sound ("player/suck_7.wav");
	precache_sound ("player/suck_8.wav");

	precache_sound ("player/burn_1.wav");
	precache_sound ("player/burn_2.wav");
	precache_sound ("player/burn_3.wav");
	precache_sound ("player/burn_4.wav");
	precache_sound ("player/burn_5.wav");

 	precache_sound ("player/drown_1.wav");
 	precache_sound ("player/drown_2.wav");
 	precache_sound ("player/drown_3.wav");
 	precache_sound ("player/drown_4.wav");


 	precache_sound ("player/jump_1.wav");
 	precache_sound ("player/jump_2.wav");
 	precache_sound ("player/jump_3.wav");
 	precache_sound ("player/jump_4.wav");


 	precache_sound ("player/gasp_1.wav");
 	precache_sound ("player/gasp_2.wav");
 	precache_sound ("player/gasp_3.wav");
 	precache_sound ("player/gasp_4.wav");
 	precache_sound ("player/gasp_5.wav");


 	precache_sound ("player/fall_1.wav");
 	precache_sound ("player/fall_2.wav");
	}
	*/
};

// called from many places - handles pk_mode 0 where map sets whether or not we use PK stuff

void(entity e, float chan, string samp, float vol, float atten) sound = 
{
	local string psamp;

	psamp = samp; // sample that actually plays

	if (!PK)
	{
		if (samp == "ambience/windfly.wav") psamp = "alt_ambience/windfly.wav";
		if (samp == "items/r_item2.wav") psamp = "alt_sounds/items/r_item2.wav";
		if (samp == "misc/secret.wav") psamp = "alt_sounds/misc/secret.wav";
	}

	pk_sound(e, chan, psamp, vol, atten);
};

void(vector pos, string samp, float vol, float atten) ambientsound =
{
	local string psamp;

	psamp = samp; // sample that actually plays

	if (!PK) // not in PK mode, play alternate sounds
	{
		if (samp == "ambience/fl_hum1.wav") psamp = "alt_ambience/fl_hum1.wav";
		else if (samp == "ambience/buzz1.wav") psamp = "alt_ambience/buzz1.wav";
//		else if (samp == "ambience/fire1.wav") psamp = "alt_ambience/fire1.wav";
		else if (samp == "ambience/suck1.wav") psamp = "alt_ambience/suck1.wav";
		else if (samp == "ambience/drone6.wav") psamp = "alt_ambience/drone6.wav";
		else if (samp == "ambience/buzz1.wav") psamp = "alt_ambience/buzz1.wav";
		else if (samp == "ambience/drip1.wav") psamp = "alt_ambience/drip1.wav";
		else if (samp == "ambience/comp1.wav") psamp = "alt_ambience/comp1.wav";
//		else if (samp == "ambience/thunder1.wav") psamp = "alt_ambience/thunder1.wav";
		else if (samp == "ambience/fl_hum1.wav") psamp = "alt_ambience/fl_hum1.wav";
		else if (samp == "ambience/swamp1.wav") psamp = "alt_ambience/swamp1.wav";
		else if (samp == "ambience/swamp2.wav") psamp = "alt_ambience/swamp2.wav";
		else if (samp == "ambience/hum1.wav") psamp = "alt_ambience/hum1.wav";
		else if (psamp != samp) precache_sound(psamp);
	}
		pk_ambientsound(pos, psamp, vol, atten);
};

// called from below
void() get_teleport_sounds =
{
	local	float v;

		v = random() * 4;
	if (v < 1)
	{
		normalsound = "misc/teleport/tele_1.wav";
		reversesound = "misc/teleport/tele_1a.wav";
	}
	else if (v < 2)
	{
		normalsound = "misc/teleport/tele_2.wav";
		reversesound = "misc/teleport/tele_2a.wav";
	}
	else if (v < 3)
	{
		normalsound = "misc/teleport/tele_3a.wav";
		reversesound = "misc/teleport/tele_3a.wav";
	}
		else
	{
		normalsound = "misc/teleport/tele_4.wav";
		reversesound = "misc/teleport/tele_4a.wav";
	}
};

// called from below

void() play_teleport2 =
{
	get_teleport_sounds();
	SOUND_GOT = TRUE;

	sound (self, CHAN_VOICE, reversesound, 1, ATTN_NORM);
	remove (self);
};

// called from teleport touch

void(vector org) spawn_tfog2 =
{
	local entity e;
	e = spawn ();
	e.origin = org;
	e.nextthink = time + 0.2;
	e.think = play_teleport2;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};

// called from SetChangeParms - saves off pk parms for level change

void() PK_ChangeParms =
{
	parm10 = self.pk_items;
	parm11 = self.pk_gravitywellammo;
	parm12 = self.pk_turretammo;
	parm13 = self.pk_canpabammo;
	parm14 = self.pk_beartrapammo;
	parm15 = self.pk_explode_ammo;
	// do hub message.
	parm16 = self.msgcount | 256;
};

// called from SetNewParms - clears pk parms

void() PK_SetNewParms =
{
	parm10 = PK_IT_AXE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_CANPAB | PK_IT_BEARTRAP;
	parm11 = 0;
	parm12 = 0;
	parm13 = 0;
	parm14 = 0;
	parm15 = 0;
// do hub message.
	parm16 = 256;

	if((cvar("temp1") & PK_TP_STATUSON))
	{
		parm10 = parm10 | PK_IT_EXTRADISP;
	}
};

// called from DecodeLevelParms - restores pk parms on new level

void() PK_DecodeLevelParms = 
{
	self.pk_items = parm10;
	self.pk_gravitywellammo = parm11;
	self.pk_turretammo = parm12;
	self.pk_canpabammo = parm13;
	self.pk_beartrapammo = parm14;
	self.pk_explode_ammo = parm15;
	self.msgcount = (parm16 & 255);
};

void() SetNewPKParms =
{
	parm1 = IT_SHOTGUN | IT_AXE;
	parm2 = 100;
	parm3 = 0;
	parm4 = 25;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = 1;
	parm9 = 0;
	parm10 = PK_IT_AXE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_CANPAB | PK_IT_BEARTRAP;
	parm11 = 0;
	parm12 = 0;
	parm13 = 0;
	parm14 = 0;
	parm15 = 0;
	parm16 = MOTDTIME + 1;

	if(self.pk_items & PK_IT_EXTRADISP)
	{
		parm10 = parm10 | PK_IT_EXTRADISP;
	}
};

// called from PutClientInServer

void(entity spot) ClearSpawnPoint =
{
	local	entity thing;

	if(deathmatch < 2)
		return;

	thing = findradius(spot.origin, 80);
	while(thing)
	{
	 if(thing.solid == SOLID_TRIGGER && thing.takedamage == DAMAGE_NO &&
	 			thing.classname != "trigger_teleport")
	 {
	 	// crash point!!!
		// make it respawn...
		thing.solid = SOLID_NOT;
		 thing.model = string_null;
		thing.nextthink = time + 10;
		 thing.think = SUB_regen;
	 }
	 else if(thing.think == SUB_regen)
	 {
		thing.nextthink = thing.nextthink + 10;
	 }

	 thing = thing.chain;
	}
};

// called from PutClientInServer

entity() PK_SelectSpawnPoint =
{
	local	entity spot, newspot, thing;
	local	float	numspots, totalspots;
	local	float	rnum, pcount;
	local	float	rs;
	local entity spots;

	numspots = 0;
	totalspots = 0;

// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;

// choose a info_player_deathmatch point

// ok, find all spots that don't have players nearby

	spots = world;
	spot = find (world, classname, "info_player_deathmatch");
	while (spot)
	{
		totalspots = totalspots + 1;

		thing=findradius(spot.origin, 256);
		pcount=0;
		while (thing)
		{
			if (thing.classname == "player")
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
	if (!numspots) {
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

	numspots = rint((random() * numspots ) );

	spot = spots;
	while (numspots > 0) {
		spot = spot.goalentity;
		numspots = numspots - 1;
	}
	return spot;

};

// called from PutClientInServer

void() PK_CIS =
{
// previously in CIS
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
	if(self.bolt_targetTimeoutEntity)
	{
		remove(self.bolt_targetTimeoutEntity);
	}
	self.bolt_targetTimeoutEntity = world;
	self.bolt_conduitTimeout = 0;
	self.bolt_changeModelTimeout = 0;
	if(self.bolt_lightningFire)
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

	if(inHubMap)
	{ // give the respawn guy a fighting chance...
		self.items = self.items | IT_INVULNERABILITY;
		self.invincible_time = 1;
		self.invincible_finished = time + 15;

		// PAINKEEP timeout for the hub "how to vote" message.
		if(parm16 & 256)
		{
			self.hubstartupmessage = time + 15;
		}
	}

	// PAINKEEP SPLASH Make this entity splash
	AddToSplashBig(self);

	// PAINKEEP Fix the velocity on respawn bug
	self.velocity = '0 0 0';

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
// called from playerprethink - diverts

void() pk_pre_think =
{
// PK_DUTYCHECKING_START
	// removed from WaterMove, it has to be done every frame.
	if (! (self.flags & FL_WATERJUMP) )
		self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;

	if(self.pk_dutychecking == 0)
	{
		CheckRules ();
		WaterMove ();

	 if (self.waterlevel == 2)
		CheckWaterJump ();
	}
	else if(time > self.pk_dutychecking)
	{
		CheckRules ();
		WaterMove ();

	 if (self.waterlevel == 2)
		CheckWaterJump ();
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

// teleporters can force a non-moving pause time
	if (time < self.pausetime)
		self.velocity = '0 0 0';

// PAINKEEP_START
	if(time > self.attack_finished)
	if(self.currentammo == 0)
	if(self.weapon != IT_AXE || self.pk_currentitem != PK_IT_AXE)
	{
		self.weapon = W_BestWeapon ();
		self.pk_currentitem = W_BestPKWeapon ();
		W_SetCurrentAmmo ();
	}

// GRAPPLING
	grap_maintainHarpoon();
	self.oldorigin = self.origin;

	if(self.pk_dutychecking == 0)
	{
		// PAINKEEP SPLASH Check for entities splashing
		CheckWaterLevels();

		updateStatusDisplay();
	}
	else if(time > self.pk_dutychecking)
	{
		// PAINKEEP SPLASH Check for entities splashing
		CheckWaterLevels();

		updateStatusDisplay();
	}
};

// called from playerpostthink - diverts

void() pk_post_think =
{
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

	PK_WeaponFrame ();

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
	if(self.AIRG_BlastTimeout > time)
	{
		horn_airblast(FALSE);
	}

// PK_DUTYCHECKING_START
	if(self.pk_dutychecking == 0)
	{
	 bolt_checkTargets();

		CheckPowerups ();
		if(self.copb_timeout)
		{
			if(self.copb_timeout >= time)
			{
				copb_checkFart();
			}
			else
			{
				self.copb_timeout = 0;
			}
		}

		if((cvar("temp1") & PK_TP_DUTYON))
		{
			self.pk_dutychecking = time + 0.5;
		}
	}
	else if(time > self.pk_dutychecking)
	{
		bolt_checkTargets();

		CheckPowerups ();
		if(self.copb_timeout)
		{
			if(self.copb_timeout >= time)
			{
				copb_checkFart();
			}
			else
			{
				self.copb_timeout = 0;
			}
		}

		if((cvar("temp1") & PK_TP_DUTYON))
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
		if(!(cvar("temp1") & PK_TP_DUTYON))
		{
			self.pk_dutychecking = 0;
		}
	}
};

// called from client connect

void() pk_clientconnect =
{
	local float v;
	v = random() * 6;

//	bprint(self.netname); // already printed this
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

// MOTD_START
//	self.msgcount = 1;
};

// called from client disconnect

void() pk_clientdisconnect =
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
	if(self.bolt_targetTimeoutEntity)
	{
		remove(self.bolt_targetTimeoutEntity);
	}
	self.bolt_targetTimeoutEntity = world;
	self.bolt_conduitTimeout = 0;
	self.bolt_changeModelTimeout = 0;
	if(self.bolt_lightningFire)
	{
		remove(self.bolt_lightningFire);
	}
	self.bolt_lightningFire = world;
};

// called from killed - updated client obit

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

			attacker.owner.frags = attacker.owner.frags + 1;
			return;
		}

		if (attacker.classname == "teledeath2")
		{
			bprint ("Satan's power deflects ");
			bprint (targ.netname);
			bprint ("'s telefrag\n");

			targ.frags = targ.frags - 1;
			return;
		}

		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{
				// killed self
				attacker.frags = attacker.frags - 1;
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
			else if ( (teamplay == 2) && (targ.team > 0)&&(targ.team == attacker.team) )
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
				attacker.frags = attacker.frags - 1;
				return;
			}
			else
			{
				attacker.frags = attacker.frags + 1;

				// For the correct death messages
				//rnum = attacker.weapon;
				rnum = inflictor.weapon;

				if (rnum == IT_AXE)
				{
// PAINKEEP_START
					if(inflictor.pk_currentitem == PK_IT_AXE)
					{
						deathstring = " was ax-murdered by ";
						deathstring2 = "\n";
					}
					else if(inflictor.pk_currentitem == PK_IT_AIRGUN)
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
					else if(inflictor.pk_currentitem == PK_IT_GRAPGUN)
					{
						deathstring = " got ";
						deathstring2 = "'s point\n";
					}
// GRAPPLING_END
					else if(inflictor.pk_currentitem == PK_IT_BEARTRAP)
					{
						deathstring = " was clamped by ";
						deathstring2 = "\n";
					}
					else if(inflictor.pk_currentitem == PK_IT_GRAVITYWELL)
					{
						deathstring = " fountains in front of ";
						deathstring2 = "\n";
					}
// BOLT_START
					else if(inflictor.pk_currentitem == PK_IT_CLIGHT)
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
					if(inflictor.classname == "ExplodeShellsAttack")
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
					if(inflictor.classname == "ExplodeShellsAttack")
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
// TURRET_START
	 else if(attacker.classname == "turret" || attacker.classname == "turret_gib")
	 {
			bprint(targ.netname);

	 	// check if killed the droper of the turret.
		if(attacker.owner == targ) {
				// killed self
				targ.frags = targ.frags - 1;
				bprint(" forgot to hide from his own AutoSentry!\n");
			return;
		}

		// increase frags & print message.
		attacker.owner.frags = attacker.owner.frags + 1;
			bprint(" was ventilated by ");
		bprint(attacker.owner.netname);
			bprint("'s AutoSentry\n");
		return;
	 }
// TURRET_END
		else
		{
			targ.frags = targ.frags - 1;
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
				return;
			}
			else if (rnum == -4)
			{
				if (random() < 0.5)
					bprint (" gulped a load of slime\n");
				else
					bprint (" can't exist on slime alone\n");
				return;
			}
			else if (rnum == -5)
			{
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
				return;
			}

			// hell if I know; he's just dead!!!
			bprint (" died\n");
		}
	}
};