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

// info string set by server
	localcmd("alias version \"echo quake-c: painkeep 2.2.1 (release)\"\n");
	localcmd("alias website \"echo http://www.moddb.com/mods/painkeep-source-update/\"\n");

	qweps = IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING;
	pkweps = PK_IT_AXE | PK_IT_GRAPGUN | PK_IT_AIRGUN | PK_IT_CLIGHT	| PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_BEARTRAP | PK_IT_CANPAB
							 | PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE; // pk plus weps

	VW_ARMOR = FALSE; /// has issues - can be turned on with sv_vw_armor 1 // TRUE; // should only ever be 1 or 0 - used in conditionals
	VW = TRUE;

// testing

//	Q_99 = TRUE;
//	Q_100 = TRUE;
//	PK_99 = TRUE;

// PK_100 - fix - needs to be admin toggle

	PK_100 = FALSE; // if true run 100% true to pk v1.11

	pk_srvcmd_set(); // get this here

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

// load pk bots w/enh. engine

	if (DARKPLACES || chaos)
	{
		cvar_set("sv_bot_pkset", "1");
		localcmd("unalias blvl bmap\n"); // unalias - not needed
	}

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

	if (s == "progs/g_airgun2.mdl" || s == "progs/g_clight.mdl" || s == "progs/g_harp.mdl" || s == "progs/tpower.mdl" || s == "progs/beans.mdl" || s == "progs/bearpick.mdl" || s == "maps/b_eshel0.bsp" )
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
	if (mp == "maps/start.bsp" && world.message == "hub") return(TRUE); // NOTE: relies on loaded map
	if (mp == "maps/pk0.bsp") return(TRUE);
	if (mp == "maps/pk1.bsp") return(TRUE);
	if (mp == "maps/pk2.bsp") return(TRUE);
	if (mp == "maps/pk3.bsp") return(TRUE);
	if (mp == "maps/pk4.bsp") return(TRUE);
	if (mp == "maps/pk5.bsp") return(TRUE);
	if (mp == "maps/pk6.bsp") return(TRUE);
	if (mp == "maps/pk7.bsp") return(TRUE);
	if (mp == "maps/pk8.bsp") return(TRUE);
	if (mp == "maps/pk9.bsp") return(TRUE);
	if (mp == "maps/pk10.bsp") return(TRUE);
	if (mp == "maps/pk11.bsp") return(TRUE);
	if (mp == "maps/pk12.bsp") return(TRUE);
	if (mp == "maps/pk13.bsp") return(TRUE);
	if (mp == "maps/pk14.bsp") return(TRUE);
	if (mp == "maps/pk15.bsp") return(TRUE);
	if (mp == "maps/pk16.bsp") return(TRUE);
	if (mp == "maps/pk17.bsp") return(TRUE);
	if (mp == "maps/pk18.bsp") return(TRUE);
	if (mp == "maps/painkeep.bsp") return(TRUE);
	if (PK_ADHUB)	// add on maps from painkeep updates
	{
		if (mp == "maps/hub2.bsp") return(TRUE);
		if (mp == "maps/hub3.bsp") return(TRUE); // renamed for 1.2 code to work with main hub (start.bsp)

		if (mp == "maps/pkn1.bsp") return(TRUE);
		if (mp == "maps/pkn2.bsp") return(TRUE);
		if (mp == "maps/pkn3.bsp") return(TRUE);
		if (mp == "maps/pkn4.bsp") return(TRUE);
		if (mp == "maps/pkn5.bsp") return(TRUE);
		if (mp == "maps/pkn6.bsp") return(TRUE);
		if (mp == "maps/pkn7.bsp") return(TRUE);
		if (mp == "maps/pkn8.bsp") return(TRUE);
		if (mp == "maps/pkn9.bsp") return(TRUE);
		if (mp == "maps/pkn10.bsp") return(TRUE);
		if (mp == "maps/pkn11.bsp") return(TRUE);
		if (mp == "maps/pkn12.bsp") return(TRUE);
		if (mp == "maps/pkn13.bsp") return(TRUE);
		if (mp == "maps/pkn14.bsp") return(TRUE);
		if (mp == "maps/pkn15.bsp") return(TRUE);
		if (mp == "maps/pkn16.bsp") return(TRUE);
		if (mp == "maps/pkn17.bsp") return(TRUE);
		if (mp == "maps/pkn18.bsp") return(TRUE);
		if (mp == "maps/pkn19.bsp") return(TRUE);
		if (mp == "maps/pkn20.bsp") return(TRUE);
		if (mp == "maps/pkts00.bsp") return(TRUE);
		if (mp == "maps/pkts01.bsp") return(TRUE);
		if (mp == "maps/pkts02.bsp") return(TRUE);
		if (mp == "maps/pkts03.bsp") return(TRUE);
		if (mp == "maps/pkts04.bsp") return(TRUE);
		if (mp == "maps/pkts05.bsp") return(TRUE);
		if (mp == "maps/pkts06.bsp") return(TRUE);
		if (mp == "maps/pkts07.bsp") return(TRUE);
		if (mp == "maps/pkts08.bsp") return(TRUE);
		if (mp == "maps/pkts09.bsp") return(TRUE);
		if (mp == "maps/pkts10.bsp") return(TRUE);
		if (mp == "maps/pkts11.bsp") return(TRUE);
		if (mp == "maps/pkts12.bsp") return(TRUE);
		if (mp == "maps/pkts13.bsp") return(TRUE);
		if (mp == "maps/pkts14.bsp") return(TRUE);
		if (mp == "maps/painkeep2.bsp") return(TRUE);

		if (mp == "maps/air2.bsp") return(TRUE);
		if (mp == "maps/air3.bsp") return(TRUE);
		if (mp == "maps/anomie.bsp") return(TRUE);
		if (mp == "maps/arena.bsp") return(TRUE);
		if (mp == "maps/bastion.bsp") return(TRUE);
		if (mp == "maps/blood2.bsp") return(TRUE);
		if (mp == "maps/blood3.bsp") return(TRUE);
		if (mp == "maps/campers-cove.bsp") return(TRUE);
		if (mp == "maps/castle2.bsp") return(TRUE);
		if (mp == "maps/chv_hub.bsp") return(TRUE);
		if (mp == "maps/city.bsp") return(TRUE);
		if (mp == "maps/court.bsp") return(TRUE);
		if (mp == "maps/crater.bsp") return(TRUE);
		if (mp == "maps/crater2.bsp") return(TRUE);
		if (mp == "maps/doom1_e1.bsp") return(TRUE);
		if (mp == "maps/egyptra.bsp") return(TRUE);
		if (mp == "maps/egyptra2.bsp") return(TRUE);
		if (mp == "maps/egyptra3.bsp") return(TRUE);
		if (mp == "maps/factory.bsp") return(TRUE);
		if (mp == "maps/factory2.bsp") return(TRUE);
		if (mp == "maps/factory3.bsp") return(TRUE);
		if (mp == "maps/fragtown.bsp") return(TRUE);
		if (mp == "maps/garden.bsp") return(TRUE);
		if (mp == "maps/giza2.bsp") return(TRUE);
		if (mp == "maps/haunted.bsp") return(TRUE);
		if (mp == "maps/platinum.bsp") return(TRUE);
		if (mp == "maps/platinum2.bsp") return(TRUE);
		if (mp == "maps/platinum3.bsp") return(TRUE);
		if (mp == "maps/q1edgepk.bsp") return(TRUE);
		if (mp == "maps/spine2.bsp") return(TRUE);
		if (mp == "maps/summerpk.bsp") return(TRUE);
		if (mp == "maps/toxic.bsp") return(TRUE);
		if (mp == "maps/toxic2.bsp") return(TRUE);
		if (mp == "maps/well.bsp") return(TRUE);
	}
	return(FALSE);
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
	PK_100 = cvar("sv_pk100");
	PK_ART_DEF  = cvar("sv_pk_art");
	PK_100_OBJERR = cvar("sv_pk100_objerr");
// q1
	Q_100 = cvar("sv_q100");
	Q_100_OBJERR = cvar("sv_q100_objerr");
// dynamic items
	DYN_OVR = cvar("pk_dyn_ovr");
	DYN_ART = cvar("pk_dyn_art");
	if (!DYN_OVR && !(pk_flags & PK_DYNAMIC)) DYN_FORCE = cvar("pk_dyn_force");
	DYN_ARTFR = cvar("pk_dyn_art_force");
	DYN_FORCE_CNT = cvar("pk_dyn_force_cnt");

// check for botmatch changes
	if (deathmatch || coop)
	if (cvar("sv_botmatch") != 0) b_launch(0);
};

void() pk_srvcmd_set =
{
	PK_ART_DEF  = TRUE;
// dynamic defaults
	DYN_OVR = FALSE;
	DYN_ART = TRUE;
	DYN_FORCE = FALSE;
	DYN_ARTFR = FALSE;
	DYN_FORCE_CNT = 6;

	PK_100_OBJERR = FALSE;

	Q_100 = FALSE;
	Q_100_OBJERR = FALSE;
	
	if (!DARKPLACES && !chaos) return;

// new server controls
// NOTE: chaos eng mod will have to make all these

	if (DARKPLACES) // reg under darkplaces - chaos engine has pre-reg
	{
		registercvar("sv_vw", "1");
		registercvar("sv_vw_armor", "0");
		registercvar("sv_pk100", "0");
		registercvar("sv_pk100_objerr", "0");
		registercvar("sv_pk_art", "1");
		registercvar("sv_cam_off", "0"); // set to 1 to turn cam off entirely
		registercvar("sv_cam_def", "1"); // set to 0 to default to no cam view
		registercvar("sv_botmatch", "0"); // load bots without admin
		registercvar("botlevel", "0"); // when true, post code will call bot_changelevel so manual change will load pk*bs

// pk*bot server control - spawns bots on level changes
		registercvar("sv_bot_pk", "0"); // bot count . skills non team - replaces parm12
		registercvar("sv_bot_pktm", "0"); // bot count . skills - team - replaces parm13
		registercvar("sv_bot_pkset", "0"); // bot stats saved


// dynamic item controls
		registercvar("pk_dyn_ovr", "0"); // if set over-ride bit in control flag - gets set by menu command
		registercvar("pk_dyn_art", "1"); // add artifacts to dyn items
		registercvar("pk_dyn_force", "0"); // force dynamic items on any map - must set PK true, has no effect if dyn already on
		registercvar("pk_dyn_art_force", "0"); // force artifacts on map if no dynamic spawner, if spawner exists this is the same as pk_dyn_art
		registercvar("pk_dyn_force_cnt", "6"); // max force cnt - because forcing can exceed load max for dyn items
// q1
		registercvar("sv_q100", "0");
		registercvar("sv_q100_objerr", "0");
		registercvar("sv_qstart", "0"); // allow single player cfg to load start map once per dp server run
		registercvar("pk_sp_bt_noplayer", "0"); // single player - if true beartraps wont target players
		registercvar("pk_bt_time", "90"); // time for beartraps to live


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
			localcmd("exec ");
			localcmd("d_server.cfg\n");
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

