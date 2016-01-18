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
	precache_sound ("alt_ambience/hum1.wav");
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
		// new modes
	precache_model ("progs/laser.mdl");
	precache_sound ("enforcer/enfire.wav");
 
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
	precache_model ("progs/beargib1.mdl");
	precache_model ("progs/beargib2.mdl");
	precache_model ("progs/beargib3.mdl");
	precache_model ("progs/beargib4.mdl");

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

// admin
	precache_model ("progs/s_light.spr");	// light up admin
	precache_model ("progs/hub_port.mdl"); // custom hub levels
	precache_model ("progs/shambler.mdl"); // custom hub levels

	precache_model ("progs/null.mdl"); // Cataboligne 8.8.9 purify - chase cam

// relocated (pkitems.qc) for dynamic items
	precache_model ("progs/tpower.mdl");
	precache_model ("progs/beans.mdl");
	precache_model ("progs/bearpick.mdl");
	precache_model ("maps/b_eshel0.bsp");
	precache_model ("progs/g_airgun2.mdl");
	precache_model ("progs/g_clight.mdl");
	precache_model ("progs/g_harp.mdl");

// relocated (pkpitems.qc) for dynamic items
	precache_model ("progs/ego.mdl");
	precache_model ("progs/tomb.mdl");
	precache_model ("progs/actor.mdl");
	precache_model ("progs/phone.mdl");

// relocated (items.qc) for dynamic items
// heal
	precache_model ("maps/b_bh10.bsp");
	precache_sound ("items/r_item1.wav");
	precache_model ("maps/b_bh100.bsp");
	precache_sound ("items/r_item2.wav");
	precache_model ("maps/b_bh25.bsp");
	precache_sound ("items/health1.wav");
// armor
	precache_model ("progs/armor.mdl");
// weps
	precache_model ("progs/g_shot.mdl");
	precache_model ("progs/g_nail.mdl");
	precache_model ("progs/g_nail2.mdl");
	precache_model ("progs/g_rock.mdl");
	precache_model ("progs/g_rock2.mdl");
	precache_model ("progs/g_light.mdl");
// ammo
	precache_model ("maps/b_shell1.bsp");
	precache_model ("maps/b_shell0.bsp");
	precache_model ("maps/b_nail1.bsp");
	precache_model ("maps/b_nail0.bsp");
	precache_model ("maps/b_rock1.bsp");
	precache_model ("maps/b_rock0.bsp");
	precache_model ("maps/b_batt1.bsp");
	precache_model ("maps/b_batt0.bsp");
// keys
	precache_sound ("misc/medkey.wav");
	precache_sound ("misc/runekey.wav");
	precache_sound ("misc/basekey.wav");
	precache_model ("progs/w_s_key.mdl");
	precache_model ("progs/m_s_key.mdl");
	precache_model ("progs/b_s_key.mdl");
	precache_model ("progs/w_g_key.mdl");
	precache_model ("progs/m_g_key.mdl");
	precache_model ("progs/b_g_key.mdl");
// sigil
	precache_sound ("misc/runekey.wav");
	precache_model ("progs/end1.mdl");
	precache_model ("progs/end2.mdl");
	precache_model ("progs/end3.mdl");
	precache_model ("progs/end4.mdl");
// artifacts
	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	precache_model ("progs/suit.mdl");
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	precache_model ("progs/invisibl.mdl");
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");

// visible weapon support - bit masks for inventory

	precache_model ("progs/v2_nail.mdl");
	precache_model ("progs/v2_nail2.mdl");
	precache_model ("progs/v2_rock.mdl");
	precache_model ("progs/v2_rock2.mdl");
	precache_model ("progs/v2_pulsenail.mdl");
	precache_model ("progs/v2_harp.mdl");

	viswep_pre();

	chaos = cvar("chaos"); // glquake mod engine
	DARKPLACES = cvar("pr_checkextension"); // check for dp engine
	
	qweps = IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING;
	pkweps = PK_IT_AXE | PK_IT_GRAPGUN | PK_IT_AIRGUN | PK_IT_CLIGHT	| PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_BEARTRAP | PK_IT_CANPAB
							 | PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE; // pk plus weps

	pk_srvcmd_set(); 	// set server controls for qc code

	PK_ART = PK_ART_DEF & !PK_100; // Cataboligne - 8.12.9 - pk artifacts support init - FIX - needs to read admin var
	if (PK_ART) pk_art_precache(); // Cataboligne 8.12.9 purify - pk artifacts

	PK_ADMIN = 6; // code sets allow admin here - can be disabled by admin menu, 3 is base menu set

	if (Q_100 | Q_99) // Cataboligne - 8.16.9 - quake compatability mode starts here
	{
		if (!Q_99) PK_ADMIN = 0;
//		else Q_100 = 0; // these are exclusive - constant right now
		PK_ART = PK_100 = 0;
	}

	local entity e;

	if (PK_ADMIN)
	{
// access code first
		e = spawn();
		e.nextthink = time + 0.5; // cat: 8.8.9 - had to increment, wasnt getting code
		e.think = PK_SetAdmin;
		e.classname = "admincode";

		localcmd(ADMINCODE);
		pk_admincode = pk_adminimp = -1;
		pk_adminpwdmask = TRUE;
	}

  if (!PK_100 && !Q_100)
 {
	pk_itemovr = pk_itemovr_ck = cvar("saved3"); // admin override of map items

// causes item overrides to happen on map load

	if (pk_itemovr & CON_RUN) // change some items - admin override
	{
		e = spawn();
		if (e)
		{
			e.think = item_loop;
			e.nextthink = time + 2; // do this well after items spawn
		}
	}
 }

// set PK mode based on engine var | saved*

	pk_flags = pk_flags_ck = cvar("savedgamecfg");
	pk_map = PK_mapmode(world.model);

// single player hack - if hub flag is set and we forced dynamic items level exit returns to hub
	if (!deathmatch && (pk_flags & PK_SF_HUB)) pk_flags = pk_flags - PK_SF_HUB;
 
// got mode, set PK master switch
	PK = FALSE;

  if (!Q_100 && !Q_99) // Cataboligne - 8.16.9 - quake compatability mode
 {
	if (PK_100) PK = TRUE;
	else if (pk_flags & PK_ALWAYS)
		PK = TRUE;
	else if (pk_flags & PK_NEVER)
		PK = FALSE;
	else // if (!pk_flags & PK_MAP)
	{
		PK = PK_mapmode(world.model);
	}

	if (!PK_100) custom_hub_loaded = pk_flags & PK_HUB2; // see if we came from a custom hub
	if (world.model == "maps/start.bsp" && world.message == "HUB")
	{
		pk_flags = pk_flags - (pk_flags & PK_HUB2);
		custom_hub_loaded = FALSE;
		localcmd("alias hubmap \"bf\"\n"); // always deactivate
	}
	admin_sv_cfg();
 }

// setup dynamic items

	if (PK || Q_99 || DYN_FORCE || DYN_ARTFR)
	if (!PK_100 && !Q_100)
	if (pk_flags & PK_DYNAMIC || DYN_OVR || DYN_FORCE || DYN_ARTFR)
	{
		if (!(pk_flags & PK_DYNAMIC) && !DYN_OVR && !DYN_FORCE) DYN_ARTFR_ONLY = DYN_ARTFR;
//		if (DYN_FORCE || DYN_ARTFR) PK = TRUE;
		pk_ditems = 0;
		e = spawn();
		if (e)
		{
			e.think = dyn_item;
			e.nextthink = time + DYN_START_TIME; // do this well after items spawn
		}
	}

	pk_livent = 0; // nothing lives yet

// extra sounds by...are apparently not supplied, except gib_?.wav

	pk_xsound = (pk_flags & PK_XSOUND);
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

// fn (precache_sound) -- dynamic item takeovers - because some engines cannot precache after map load
// fn(precache_model)

string (string s) precache_sound =
{
	if (time < DYN_START_TIME)
		return(precache_sound__(s));
};

string (string s) precache_model =
{
/// moved here to simplify code (pkitems.qc)

	if (s == "progs/g_airgun.mdl" || s == "progs/g_airgun2.mdl" || s == "progs/g_clight.mdl" || s == "progs/g_harp.mdl" || s == "progs/tpower.mdl" || s == "progs/beans.mdl" || s == "progs/bearpick.mdl" || s == "maps/b_eshel0.bsp" )
	{
		if (!(pk_flags & PK_MAP) && !PK) pk_map = PK = TRUE; // *pk - in map mode, set PK for painkeep mode
		pk_ditems = pk_ditems + 1;
	}

	if (s == "progs/ego.mdl" || s == "progs/tomb.mdl" || s == "progs/actor.mdl" || s == "progs/phone.mdl") // pkpitems.qc
	{
		if (!(pk_flags & PK_MAP) && !PK) pk_map = PK = TRUE; // *pk - in map mode, set PK for painkeep mode
		pk_ditems = pk_ditems + 1;
	}

	if (time < DYN_START_TIME)
		return(precache_model__(s));
}; 

// set mode based on map name

float(string mp) PK_mapmode =
{
	local float md;

	md = FALSE;

	if (mp == "maps/start.bsp" && world.message == "hub") md = TRUE; // NOTE: relies on loaded map
	else if (mp == "maps/pk0.bsp") md = TRUE;
	else if (mp == "maps/pk1.bsp") md = TRUE;
	else if (mp == "maps/pk2.bsp") md = TRUE;
	else if (mp == "maps/pk3.bsp") md = TRUE;
	else if (mp == "maps/pk4.bsp") md = TRUE;
	else if (mp == "maps/pk5.bsp") md = TRUE;
	else if (mp == "maps/pk6.bsp") md = TRUE;
	else if (mp == "maps/pk7.bsp") md = TRUE;
	else if (mp == "maps/pk8.bsp") md = TRUE;
	else if (mp == "maps/pk9.bsp") md = TRUE;
	else if (mp == "maps/pk10.bsp") md = TRUE;
	else if (mp == "maps/pk11.bsp") md = TRUE;
	else if (mp == "maps/pk12.bsp") md = TRUE;
	else if (mp == "maps/pk13.bsp") md = TRUE;
	else if (mp == "maps/pk14.bsp") md = TRUE;
	else if (mp == "maps/pk15.bsp") md = TRUE;
	else if (mp == "maps/pk16.bsp") md = TRUE;
	else if (mp == "maps/pk17.bsp") md = TRUE;
	else if (mp == "maps/pk18.bsp") md = TRUE;
	else if (mp == "maps/painkeep.bsp") md = TRUE;
	else if (PK_ADHUB)	// add on maps from painkeep updates
	{
		if (mp == "maps/hub2.bsp") md = TRUE;
		else if (mp == "maps/hub3.bsp") md = TRUE; // renamed for 1.2 code to work with main hub (start.bsp)
		else if (mp == "maps/painkeep2.bsp") md = TRUE;
		else if (mp == "maps/pkts00.bsp") md = TRUE;
		else if (mp == "maps/pkts01.bsp") md = TRUE;
		else if (mp == "maps/pkts02.bsp") md = TRUE;
		else if (mp == "maps/pkts03.bsp") md = TRUE;
		else if (mp == "maps/pkts04.bsp") md = TRUE;
		else if (mp == "maps/pkts05.bsp") md = TRUE;
		else if (mp == "maps/pkts06.bsp") md = TRUE;
		else if (mp == "maps/pkts07.bsp") md = TRUE;
		else if (mp == "maps/pkts08.bsp") md = TRUE;
		else if (mp == "maps/pkts09.bsp") md = TRUE;
		else if (mp == "maps/pkts10.bsp") md = TRUE;
		else if (mp == "maps/pkts11.bsp") md = TRUE;
		else if (mp == "maps/pkts12.bsp") md = TRUE;
		else if (mp == "maps/pkts13.bsp") md = TRUE;
		else if (mp == "maps/pkts14.bsp") md = TRUE;
	//	else if (mp == "maps/pkts15.bsp") md = TRUE;
		else if (mp == "maps/pkn1.bsp") md = TRUE;
		else if (mp == "maps/pkn2.bsp") md = TRUE;
		else if (mp == "maps/pkn3.bsp") md = TRUE;
		else if (mp == "maps/pkn4.bsp") md = TRUE;
		else if (mp == "maps/pkn5.bsp") md = TRUE;
		else if (mp == "maps/pkn6.bsp") md = TRUE;
		else if (mp == "maps/pkn7.bsp") md = TRUE;
		else if (mp == "maps/pkn8.bsp") md = TRUE;
		else if (mp == "maps/pkn9.bsp") md = TRUE;
		else if (mp == "maps/pkn10.bsp") md = TRUE;
		else if (mp == "maps/pkn11.bsp") md = TRUE;
		else if (mp == "maps/pkn12.bsp") md = TRUE;
		else if (mp == "maps/pkn13.bsp") md = TRUE;
		else if (mp == "maps/pkn14.bsp") md = TRUE;
		else if (mp == "maps/pkn15.bsp") md = TRUE;
		else if (mp == "maps/pkn16.bsp") md = TRUE;
		else if (mp == "maps/pkn17.bsp") md = TRUE;
		else if (mp == "maps/pkn18.bsp") md = TRUE;
		else if (mp == "maps/pkn19.bsp") md = TRUE;
		else if (mp == "maps/pkn20.bsp") md = TRUE;
	}
	return(md);
};

// fn(q_startmap) - set q1 startmap name in single player

void() q_startmap =
{
	if (self.map == "start") // trying to load start.bsp - fix/hack
	{
		if (world.model == "maps/e1m7.bsp" && world.message == "The House of Chthon") // qualify these - some custom load could have renamed maps to q1 names
		{
			self.map = "qstart";
		}
		else if (world.model == "maps/e2m6.bsp" && world.message == "the Dismal Oubliette")
		{
			self.map = "qstart";
		}
		else if (world.model == "maps/e3m6.bsp" && world.message == "Chambers of Torment")
		{
			self.map = "qstart";
		}
		else if (world.model == "maps/e4m7.bsp" && world.message == "Azure Agony")
		{
			self.map = "qstart";
		}
		else if (world.model == "maps/end.bsp" && world.message == "Shub-Niggurath's Pit")
		{
			self.map = "qstart";
		}
	}
};

// fn(pk_srvcmd_set) - setup new server control vars & load from cfg or alias
// fn(pk_srvcmd_load) - load new server control vars
// fn(botmatch) - load bots for bot match

// NOTE - only works under darkplaces for now

void() botmatch =
{
	local float f, t, b;

	cvar_set("saved1", "0"); // clear possible impulse entry

	if (bot_count > 0 || NUMBOTS > 0)
	{
		bprint("Bots already running - botmatch exiting\n");
		remove(self);
		return;
	}		

	bprint("Botmatch turned on, loading ");
	bprint(ftos(self.cnt));
	bprint(" bots!\n");

	b = NUMBOTS;
	
	t = self.cnt / 2;

 if (deathmatch) // pk*bots only in dm
 {
	while (t > 0.33 && self.cnt > 0)
	{
		f = rint(random() * 3.3);
		AddAnotherBot (f);
		self.cnt = self.cnt - 1;
		t = t - 1;
	}

	if (b != NUMBOTS)
	{
		bprint("---> loaded ");
		bprint(ftos(NUMBOTS));
		bprint(" pk*bots\n");
	}
	else
	{
		bprint("---> Error: bots not loaded, exiting - make sure this is a multiplayer server\n");
		remove(self);
		return;
	}
 }

	b = bot_count;

	if (self.cnt < 1)
	{
		remove(self);
		return;
	}

	while (self.cnt > 0)
	{
		f = rint(random() * 3.3);
		BotConnect(0, 0, f);
		self.cnt = self.cnt - 1;
	}

	if (b != bot_count)
	{
		bprint("---> loaded ");
		bprint(ftos(bot_count));
		bprint(" frikbots\n");
	}
	else
	{
		bprint("---> Error: bots not loaded, exiting - make sure this is a multiplayer server\n");
	}
	remove(self);
};

// fn (b_launch) - launch botspawn call

// b - true if done by impulse

void(float b) b_launch =
{
	local entity e;
	local float bcnt;

	if (DARKPLACES || chaos)
	{
		bcnt = cvar("sv_botmatch");
		cvar_set("sv_botmatch", "0");
	}

	if (b) bcnt = b;

	if (bot_count > 0 || NUMBOTS > 0) return; // have bots, go back

	e = spawn();
	if (e)
	{
		e.think = botmatch;
		e.nextthink = time + 3 + 4 * random(); // make em wait a few secs, build suspense
		e.cnt = bcnt;
		if (e.cnt == 1) e.cnt = 6; // default load = 6 bots
		if (e.cnt < 0) e.cnt = 0 - e.cnt; // -{number} runs {number} bots
		if (coop && fabs(e.cnt) > 3) e.cnt = 3;
	}
};

void() pk_srvcmd_load =
{
	if (!DARKPLACES && !chaos) return;

	VW = cvar("sv_vw");
	VW_ARMOR = cvar("sv_vw_armor");
	PK_99 = cvar("sv_pk99");
	PK_100 = cvar("sv_pk100");
	PK_ART_DEF  = cvar("sv_pk_art");
	PK_100_OBJERR = cvar("sv_pk100_objerr");

// respawn times
	RSP_TIME = cvar("pk_rsp_time");

// q1 ammo
	Q1_SHELLAMMO_MAX				= cvar("q1_shellammo_max");
	Q1_NAILAMMO_MAX					= cvar("q1_nailammo_max");
	Q1_ROCKETAMMO_MAX				= cvar("q1_rocketammo_max");
	Q1_CELLAMMO_MAX					= cvar("q1_cellammo_max");

// item ammo levels
	PK_GRAVITYWELLAMMO_MAX	= cvar("pk_max_gravitywellammo");
	PK_TURRETAMMO_MAX				= cvar("pk_max_turretammo");
	PK_CANPABAMMO_MAX			= cvar("pk_max_canpabammo");
	PK_BEARTRAPAMMO_MAX		= cvar("pk_max_beartrapammo");

	PK_EXPLODEAMMO_MAX			= cvar("pk_max_explodeammo");
// plus items
	PKPLUS_EGOAMMO_MAX			= cvar("pk_max_egoammo");
	PKPLUS_TOMBAMMO_MAX		= cvar("pk_max_tombammo");
	PKPLUS_ACTORAMMO_MAX	= cvar("pk_max_actorammo");
	PKPLUS_PHONEAMMO_MAX	= cvar("pk_max_phoneammo");

	PK_MAX_LIVENT = cvar("pk_max_livent");

// q1
	Q_99 = cvar("sv_q99");
	Q_100 = cvar("sv_q100");
	Q_100_OBJERR = cvar("sv_q100_objerr");
// dynamic items
	DYN_OVR = cvar("pk_dyn_ovr");
	DYN_ART = cvar("pk_dyn_art");
	if (!DYN_OVR && !(pk_flags & PK_DYNAMIC)) DYN_FORCE = cvar("pk_dyn_force");
	DYN_ARTFR = cvar("pk_dyn_art_force");
	DYN_FORCE_CNT = cvar("pk_dyn_force_cnt");
// cam stuff
	DCAMTO = cvar("sv_cam_timeout");
	DCAMTOACT = cvar("sv_cam_to_action");
	FFW_LIMIT = cvar("sv_pl_ffwlimit");

	NOCIDE = 	cvar("sv_pl_nocide");
	NOENVCIDE = cvar("sv_pl_nolavacide");

// check for botmatch changes
	if (deathmatch || coop)
	if (cvar("sv_botmatch") != 0) b_launch(0);
};

void() pk_srvcmd_set =
{
// server controls, default on for full feature set
	pk_mapcmd = 1;
	pk_mapcfg = 1;
	pk_srvcfg = 1;

// pk control
	PK_99 = FALSE;
	PK_100 = FALSE; // if true run 100% true to pk v1.11
	PK_100_OBJERR = FALSE;

// q1 control
	Q_99 = FALSE;
	Q_100 = FALSE;
	Q_100_OBJERR = FALSE;

// cam controls
	DCAMTO = 0; // FIX - final release should have 2 mins & respawn
	DCAMTOACT = 0;
	FFW_LIMIT = 0;

	NOCIDE = 0;
	NOENVCIDE = 0;

// vw controls
	VW_ARMOR = FALSE; /// has issues - can be turned on with sv_vw_armor 1 // TRUE; // should only ever be 1 or 0 - used in conditionals
	VW = TRUE;

// dynamic item defaults
	DYN_OVR = FALSE;
	DYN_ART = TRUE;
	DYN_FORCE = FALSE;
	DYN_ARTFR = FALSE;
	DYN_FORCE_CNT = 6;
	PK_DYNTO = 120;

// respawn times
	RSP_TIME = 60;

// q1 ammo
	Q1_SHELLAMMO_MAX				= 100;
	Q1_NAILAMMO_MAX					= 200;
	Q1_ROCKETAMMO_MAX				= 100;
	Q1_CELLAMMO_MAX					= 200; // pk amount

// item ammo levels
	PK_GRAVITYWELLAMMO_MAX	= 1;
	PK_TURRETAMMO_MAX				= 3;
	PK_CANPABAMMO_MAX			= 1;
	PK_BEARTRAPAMMO_MAX		= 3;

	PK_EXPLODEAMMO_MAX	= 10;
// plus items
	PKPLUS_EGOAMMO_MAX			= 2;
	PKPLUS_TOMBAMMO_MAX		= 3;
	PKPLUS_ACTORAMMO_MAX	= 1;
	PKPLUS_PHONEAMMO_MAX	= 1;

	PK_MAX_LIVENT = 256; // guessed - need research into where slowdown starts

// user artifacts
	PK_ART_DEF  = TRUE;

	if (!DARKPLACES && !chaos) return;

// new server controls
// NOTE: chaos eng mod will have to make all these

	if (DARKPLACES) // reg under darkplaces - chaos engine has pre-reg
	{
// server controls
		registercvar("sv_dmstart", "0");
		registercvar("sv_c_mapcmd", "1");
		registercvar("sv_c_mapcfg", "1");
		registercvar("sv_c_srvcfg", "1");

		registercvar("sv_vw", "1");
		registercvar("sv_vw_armor", "0");
// painkeep controls
		registercvar("sv_pk99", "0");
		registercvar("sv_pk100", "0");
		registercvar("sv_pk100_objerr", "0");
		registercvar("sv_pk_art", "1");
// cam controls
		registercvar("sv_cam_off", "0"); // set to 1 to turn cam off entirely
		registercvar("sv_cam_def", "1"); // set to 0 to default to no cam view
		registercvar("sv_cam_timeout", "0"); // set to # to timeout dead cam in # secs - limit on deadcam state
		registercvar("sv_cam_to_action", "0"); // set to 1 - disconnect, 0 - respawn

		registercvar("sv_botmatch", "0"); // load bots without admin
		registercvar("sv_pl_ffwlimit", "0"); // limits how long a dead player can collect frags for fire & forget weapons
		registercvar("sv_pl_nocide", "0"); // dont count suicides as -1 frag
		registercvar("sv_pl_nolavacide", "0"); // dont count lava /env suicides as -1 frag

// dynamic item controls
		registercvar("pk_dyn_ovr", "0"); // if set over-ride bit in control flag - gets set by menu command
		registercvar("pk_dyn_art", "1"); // add artifacts to dyn items
		registercvar("pk_dyn_force", "0"); // force dynamic items on any map - must set PK true, has no effect if dyn already on
		registercvar("pk_dyn_art_force", "0"); // force artifacts on map if no dynamic spawner, if spawner exists this is the same as pk_dyn_art
		registercvar("pk_dyn_force_cnt", "6"); // max force cnt - because forcing can exceed load max for dyn items
		registercvar("pk_dyn_func_stop", "0"); // stop func_dynitem operation
// pk items
		registercvar("pk_rsp_time", "60");
		registercvar("pk_bt_time", "90"); // time for beartraps to live
		registercvar("pk_bt_follow", "15"); // time for beartraps to hold on & bite
		registercvar("pk_bt_dmg", "2"); // beartrap damage per bite

		registercvar("pk_grv_time", "3.2"); // time for gravity to pull

		registercvar("pk_tur_ammo","40");
		registercvar("pk_tur_time","20");
		registercvar("pk_tur_health","300");
		registercvar("pk_tur_targetown","3");
		registercvar("pk_tur_variety","1"); // 1 - orange kryptonite nails, 2 - lasers, 4 - pulse nails, 8 - lightning, 16 - rockets, 32 - railgun
		registercvar("pk_tur_quadcon", "0"); // if true allows quad player to take ownership of turrets in death rad
// q1 ammos
		registercvar("q1_shellammo_max", "100"); // caution - level transiton limits in parm{*} for all of these
		registercvar("q1_nailammo_max", "200");
		registercvar("q1_rocketammo_max", "100");
		registercvar("q1_cellammo_max", "200");

// item ammo levels
		registercvar("pk_max_gravitywellammo", "1");
		registercvar("pk_max_turretammo", "3");
		registercvar("pk_max_canpabammo", "1");
		registercvar("pk_max_beartrapammo", "3");
		registercvar("pk_max_explodeammo", "10");
//  plus items
		registercvar("pk_max_egoammo", "2");
		registercvar("pk_max_tombammo", "3");
		registercvar("pk_max_actorammo", "1");
		registercvar("pk_max_phoneammo", "1");

		registercvar("pk_tomb_time", "90"); // time for beartraps to live

// total live ents per server
		registercvar("pk_max_livent", "256");

// map item upgrade loops
// rl loop
		registercvar("pk_rl_t", "-60"); // time for loop
		registercvar("pk_rl_0", "0");
		registercvar("pk_rl_1", "0");
		registercvar("pk_rl_2", "0");
		registercvar("pk_rl_3", "0");
		registercvar("pk_rl_4", "0");
		registercvar("pk_rl_5", "0");
		registercvar("pk_rl_6", "0");
// tl loop
		registercvar("pk_gl_t", "-60"); // time for loop
		registercvar("pk_gl_0", "0");
		registercvar("pk_gl_1", "0");
		registercvar("pk_gl_2", "0");
		registercvar("pk_gl_3", "0");
		registercvar("pk_gl_4", "0");
		registercvar("pk_gl_5", "0");
		registercvar("pk_gl_6", "0");

// q1
		registercvar("sv_q99", "0");
		registercvar("sv_q100", "0");
		registercvar("sv_q100_objerr", "0");
		registercvar("sv_qstart", "0"); // allow single player cfg to load start map once per dp server run
		registercvar("pk_sp_bt_noplayer", "0"); // single player - if true beartraps wont target players


// new client controls
		registercvar("cl_cam_off", "0"); // set to 1 to turn cam off entirely
		registercvar("cl_cam_def", "1"); // set to 0 to default to no cam view
	}
/*
		if (pk_srvcmd)
		{
			localcmd("d");
			localcmd(ADMINSRVCMD);
			localcmd(mapname);
			localcmd(ADMINSRVCMD);
		}
*/

// server controls - override immediately
		pk_mapcmd = cvar("sv_c_mapcmd");
		pk_mapcfg = cvar("sv_c_mapcfg");
		pk_srvcfg = cvar("sv_c_srvcfg");

// NOTE: chaos eng doesnt need to store defaults this way - they will save in config.cfg

		if (!deathmatch)
		{
			if (!cvar("sv_qstart"))
			{
				localcmd("exec ");
				localcmd("sp_server.cfg\n");
			}
		}
		else
		if (pk_srvcfg)
		{
			if (!cvar("sv_dmstart"))
			{
				localcmd("exec ");
				localcmd("d_server.cfg\n");
			}
			localcmd("exec ");
			localcmd(mapname);
			localcmd("_server.cfg\n");
		}

	pk_srvcmd_load ();
};

// called from many places - handles pk_mode 0 where map sets whether or not we use PK stuff

// really sound(), mod for frikbot code
void(entity e, float chan, string samp, float vol, float atten) pk_sound = 
{
	local string psamp;

	psamp = samp; // sample that actually plays

	if (!PK)
	{
		if (samp == "ambience/windfly.wav") psamp = "alt_ambience/windfly.wav";
		if (samp == "items/r_item2.wav") psamp = "alt_sounds/items/r_item2.wav";
		if (samp == "misc/secret.wav") psamp = "alt_sounds/misc/secret.wav";
	}

// pk_sound() - fn() here plays actual sound
	frik_sound(e, chan, psamp, vol, atten);
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
		if (psamp != samp) precache_sound(psamp);
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

// special parms - for respawn

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

	cam_parms(2);
};

// called from SetChangeParms - saves off pk parms for level change

void() PK_ChangeParms =
{
	parm10 = PK_IT_AXE | self.pk_items;
// recode so *bot can have vars for skill level save - provide max inventory of 15 for mod expansion, current max is 3 on most except for explode ammo

	parm11 = self.pk_explode_ammo + ((self.pk_turretammo & 3) * 16) + ((self.pk_canpabammo & 3) * 64) + ((self.pk_beartrapammo & 3) * 256) + ((self.pk_gravitywellammo & 3) * 1024);

	if (PK_ART) pk_art_parms(0); // Cataboligne 8.12.9 purify - pk artifacts
	// do hub message.
	parm16 = self.msgcount | 256; // | (self.pk_items & PK_IT_EXTRADISP);
};

// called from SetNewParms - clears pk parms

void() PK_SetNewParms =
{
//	parm10 = PK_IT_AXE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_CANPAB | PK_IT_BEARTRAP; // deprecated - not really used
//	parm11 = parm12 = parm13 = parm14 = parm15 = 0; // chasecam change
		parm10 = parm11 = 0;
// do hub message.
	parm16 = 256;

	if (pk_flags & PK_TP_STATUSON)
	{
		parm16 = parm16 | PK_IT_EXTRADISP;
	}
};

// called from DecodeLevelParms - restores pk parms on new level

void() PK_DecodeLevelParms = 
{
	self.pk_items = parm10 | (parm16 & PK_IT_EXTRADISP); // fix PK mode false map to PK mode true map
	self.pk_explode_ammo = parm11 & 15;
	self.pk_turretammo = floor(parm11 / 16) & 3;
	self.pk_canpabammo = floor(parm11 / 64) & 3;
	self.pk_beartrapammo = floor(parm11 / 256) & 3;
	self.pk_gravitywellammo = floor(parm11 / 1024) & 3;

	self.msgcount = (parm16 & 255);

	if (PK_ART) pk_art_parms(1); // Cataboligne 8.12.9 purify - pk artifacts
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

// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
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
			error ("PutClientInServer: no info_player_start on level");
		else
			return(spot);
	}
 }
 
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
	}
};

// called from PutClientInServer

void() PK_CIS =
{
// previously in CIS
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

	if (!PK) return;

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
	if (! (self.flags & FL_WATERJUMP))
		self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;

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

//		if (!Q_100 && !PK_100)
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

// teleporters can force a non-moving pause time
	if (time < self.pausetime)
		self.velocity = '0 0 0';

// PAINKEEP_START
	if (time > self.attack_finished)
	if (self.currentammo == 0)
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
		// PAINKEEP SPLASH Check for entities splashing
		CheckWaterLevels();

		updateStatusDisplay();
	}
	else if (time > self.pk_dutychecking)
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

		if (PK_ART)
		{
			if (!pk_art_checkpwr()) // Cataboligne 8.12.9 purify - pk artifacts
				CheckPowerups ();
		}
		else
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

		if (PK_ART)
		{
			if (!pk_art_checkpwr()) // Cataboligne 8.12.9 purify - pk artifacts
				CheckPowerups ();
		}
		else
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

// fn(frag_minus) - return frag to subtract

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

		if (PK_ART) if (pk_art_obit(targ, inflictor, attacker)) return; // Cataboligne 8.12.9 purify - pk artifacts

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
