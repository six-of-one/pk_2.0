/*

adaptive painkeep code main file
(i.e. - adaptive - its easy to add to other mods)

Cataboligne 3.29.8

*/

// precache all PK items here - relocated from world.qc

void() PK_init =
{

	chaos = cvar("chaos"); // glquake mod engine
	DARKPLACES = cvar("pr_checkextension"); // check for dp engine
	
	pk_precache();

	if (!DARKPLACES) // may not use all this - dp auto precaches
	{
	doom_precache();
	q1_precache();
	q2_precache();
	q3_precache();
	chaos_precache();
	}

	viswep_pre();

	qweps = IT_AXE | IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING;
	pkweps = PK_IT_AXE | PK_IT_GRAPGUN | PK_IT_AIRGUN | PK_IT_CLIGHT	| PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_BEARTRAP | PK_IT_CANPAB
							 | PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE; // pk plus weps

	pk_srvcmd_set(); 	// set server controls for qc code

	pk_art_precache(); // Cataboligne 8.12.9 purify - pk artifacts

	PK_ADMIN = 6; // code sets allow admin here - can be disabled by admin menu, 3 is base menu set

	if (Q_100 | Q_99) // Cataboligne - 8.16.9 - quake compatability mode starts here
	{
		if (!Q_99) PK_ADMIN = 0;
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

  if (!Q_100 && !Q_99) // server not cfg for quake compatibility - set pk mode based on map / admin
 {
	if (PK_100) PK = TRUE;
	else if (pk_flags & PK_ALWAYS)
		PK = TRUE;
	else if (pk_flags & PK_NEVER)
		PK = FALSE;
	else
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

	if (!DARKPLACES && !chaos) // admin menu only control
	if (!PK_100 && !Q_100 && !Q_99)
	if (pk_flags & PK_DYNAMIC || DYN_OVR || DYN_FORCE || DYN_ARTFR) // wont see DYN_* stuff here unless it is compiler set
	{
		if (!(pk_flags & PK_DYNAMIC) && !DYN_OVR && !DYN_FORCE) DYN_ARTFR_ONLY = DYN_ARTFR;
		pk_ditems = 0;
		e = spawn();
		if (e)
		{
			e.think = dyn_item;
			e.nextthink = time + DYN_START_TIME; // do this well after items spawn
		}
	}

	pk_livent = 0; // nothing lives yet

// load pk bots w/enh. engine

	if (DARKPLACES || chaos) cvar_set("sv_bot_pkset", "1");

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
	if (time < PIC_TO)
		return(precache_sound__(s));
};

string (string s) precache_model =
{
/// moved here to simplify code (pkitems.qc)

	if (time < PIC_TO) // only do this for map load items
	{
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

			return(precache_model__(s));
	}
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


// fn(pk_liveupd) - these cvar update live during game

float st_pk_sfx;			// state vars - so we know when it changes
float st_pk_hub;
float st_pk_duty;

// fn(pk_bas_flags) - set basic pk flags, handles cvar update, admin cfg
//			reworked from old code to include cvar controls with bit flags and handle changes to both

// bt - bit
// st - state, 1 or 0

void(float bt, float st) pk_bas_flags =
{
	if (bt == PK_DYNAMIC)
	{
		if (st)	pk_flags = pk_flags | PK_DYNAMIC;
		else		pk_flags = pk_flags - (pk_flags & PK_DYNAMIC);
		if (DARKPLACES || chaos) cvar_set("pk_dyn_ovr", ftos(st));
		DYN_OVR = st;
	}

	if (bt == PK_SF_HUB)
	{
		if (st)	pk_flags = pk_flags | PK_SF_HUB;
		else		pk_flags = pk_flags - (pk_flags & PK_SF_HUB);
		if (DARKPLACES || chaos) cvar_set("sv_pk_hub", ftos(st));
		st_pk_hub = st;
	}

	if (bt == PK_TP_SPARKSFLASH)
	{
		if (!st)	pk_flags = pk_flags | PK_TP_SPARKSFLASH;
		else		pk_flags = pk_flags - (pk_flags & PK_TP_SPARKSFLASH);
		if (DARKPLACES || chaos) cvar_set("sv_pk_sfx", ftos(st));
		st_pk_sfx = st;
	}

	if (bt == PK_TP_DUTYON)
	{
		if (st)	pk_flags = pk_flags | PK_TP_DUTYON;
		else		pk_flags = pk_flags - (pk_flags & PK_TP_DUTYON);
		if (DARKPLACES || chaos) cvar_set("sv_pk_duty", ftos(st));
		st_pk_duty = st;
	}
	admin_sv_cfg();
};

// fn(pk_liveupd) - detect live changes to config cvars by server admin - call up code to effect in game
/// genius code

void() pk_liveupd =
{
	local entity e;
	local float f;

// server controls

	Q_100_OBJERR = cvar("sv_q100_objerr");
	PK_100_OBJERR = cvar("sv_pk100_objerr");
	ADMINLOCK = cvar("sv_c_adminlock");
	WARNING = cvar("sv_c_warning");

	if (BOTFREEZE != cvar("sv_c_botfreeze")) bot_froze(world);

// runes
	run_runes();
 
// check for botmatch changes
	if (deathmatch || coop)
	if (cvar("sv_botmatch") != 0) b_launch(0);

// toggle for q1 def item translation
	if (PK_100 || Q_100)
	if (TR_Q1QRY == 0)
	if (TR_Q1DEF != cvar("pk_tr_q1def"))
	{
		TR_Q1DEF = cvar("pk_tr_q1def");
		f = 0;
		if (TR_Q1DEF) f = FL_TR_QUAKE;				/// NOTE: TR_ALL overrides this setting
		master_item_control_loop("wolf_item", f);
		master_item_control_loop("doom_item", f);
		master_item_control_loop("q2_item", f);
		master_item_control_loop("q3_item", f);
	}
	
	if (Q_100)
	{
		Q1_CELLAMMO_MAX = 100;
		XENV = TRUE;
		return;
	}

// cam stuff
	DCAMTO = cvar("sv_cam_timeout");
	DCAMTOACT = cvar("sv_cam_to_action");

// viswep
	VW = cvar("sv_vw");
	VW_ARMOR = cvar("sv_vw_armor");

	XENV = cvar("sv_c_xenv");

	if (Q_99) // TDO: needs some stuff below - like maxs
	{
		item_control_menu();
		return;
	}

// pk basics - if a cvar is changed, update status bit

	if (st_pk_sfx != cvar("sv_pk_sfx")) pk_bas_flags(PK_TP_SPARKSFLASH, cvar("sv_pk_sfx"));
	if (st_pk_hub != cvar("sv_pk_hub")) pk_bas_flags(PK_SF_HUB, cvar("sv_pk_hub"));
	if (st_pk_duty != cvar("sv_pk_duty")) pk_bas_flags(PK_TP_DUTYON, cvar("sv_pk_duty"));

	if (PK_100)
	{
		XENV = TRUE;
		PK_ART = FALSE;
		return;
	}

	NOCIDE = 	cvar("sv_pl_nocide");
	NOENVCIDE = cvar("sv_pl_nolavacide");

	FFW_LIMIT = cvar("sv_pl_ffwlimit");

	// q1 ammo
	Q1_SHELLAMMO_MAX				= cvar("q1_shellammo_max");
	Q1_NAILAMMO_MAX					= cvar("q1_nailammo_max");
	Q1_ROCKETAMMO_MAX				= cvar("q1_rocketammo_max");
	if (Q_100 || Q_99)
		Q1_CELLAMMO_MAX					= cvar("q1_cellammo_max");
	else 
		Q1_CELLAMMO_MAX					= cvar("pk_cellammo_max");

// item ammo levels - NOTE: limit to what can be carried tween levels is fixed! (at 3)
	PK_GRAVITYWELLAMMO_MAX	= cvar("pk_max_gravitywellammo");
	PK_TURRETAMMO_MAX				= cvar("pk_max_turretammo");
	PK_CANPABAMMO_MAX			= cvar("pk_max_canpabammo");
	PK_BEARTRAPAMMO_MAX		= cvar("pk_max_beartrapammo");

	PK_EXPLODEAMMO_MAX			= cvar("pk_max_explodeammo"); // tween level limit ~15 ?
// plus items
	PKPLUS_EGOAMMO_MAX			= cvar("pk_max_egoammo");
	PKPLUS_TOMBAMMO_MAX		= cvar("pk_max_tombammo");
	PKPLUS_ACTORAMMO_MAX	= cvar("pk_max_actorammo");
	PKPLUS_PHONEAMMO_MAX	= cvar("pk_max_phoneammo");

	SV_AMMO_MAX = cvar("sv_c_ammo_max");

	PK_MAX_LIVENT = cvar("pk_max_livent");

	Q2_SILENCE = cvar("q2_silence");

// turrets
	if (PK_TUR_AMMO != cvar("pk_tur_ammo") || 
		PK_TUR_TIME != cvar("pk_tur_time") || 
		PK_TUR_HEAL != cvar("pk_tur_health") || 
		PK_TUR_TARGOWN != cvar("pk_tur_targetown") || 
		PK_TUR_VARIETY != cvar("pk_tur_variety") || 
		PK_TUR_QUADCON != cvar("pk_tur_quadcon")) PK_TUR_SET = FALSE; // reset

// beartrap
	if (PK_BT_TIME != cvar("pk_bt_time") ||
			PK_BT_TIMETOFOLLOW != cvar("pk_bt_follow") ||
			PK_BT_DMG != cvar("pk_bt_dmg")) PK_BT_SET = FALSE;

// gravity

	if (PK_GRV_TIME != cvar("pk_grv_time")) PK_GRV_SET = FALSE;

// tomb
	if (PKPLUS_TOMB_TIME != cvar("pk_tomb_time")) PK_TOMB_SET = FALSE;

// map translations
	check_translate();

// respawn times
	D_POWER_WAIT = 
	Q2_POWER_WAIT = 

	RSP_TIME = cvar("sv_c_rsp_time");
	Q3_POWER_WAIT = 4 * RSP_TIME;

// art power supply times
	D_POWER_TIME = 
	Q2_POWER_TIME = 
	Q3_POWER_TIME = 

	POW_TIME = cvar("sv_c_pow_time");

	EXPLBOX_RESP = cvar("pk_explbox_resp");

// artifacts
	if (PK_ART  != cvar("sv_pk_art"))
	{
		PK_ART  = cvar("sv_pk_art");
		pkplus_item_control_loop();
		if (!PK_ART)
		{
			DYN_ART = FALSE;
			DYN_ARTFR = FALSE;
		}
		else
		{
			DYN_ART = cvar("pk_dyn_art");
			DYN_ARTFR = cvar("pk_dyn_art_force");
		}
	}

// dynamic items
	DYN_OVR = cvar("pk_dyn_ovr");
	DYN_FORCE = FALSE;
	if (!DYN_OVR) DYN_FORCE = cvar("pk_dyn_force");
	DYN_FORCE_CNT = cvar("pk_dyn_force_cnt");
	DYN_ARTFR_ONLY = FALSE; // yes, has to reset every time

	if ((!DYN_OVR && (pk_flags & PK_DYNAMIC)) || (DYN_OVR && !(pk_flags & PK_DYNAMIC))) // got toggled - set pk_flags bit
	{
		pk_bas_flags(PK_DYNAMIC, DYN_OVR);
	}

	if (!PK_ART && ((DYN_ART && (DYN_OVR || DYN_FORCE) ) || DYN_ARTFR))
	{
		if (WARNING)
		{
			bprint("*** Warning - pk_art deactivated and dynamic controls enabled: ");
			if (DYN_ART) bprint("DYN_ART ");
			if (DYN_ARTFR) bprint("DYN_ARTFR ");
			bprint("- ignored, to use these - set: sv_pk_art 1\n");
		}
		DYN_ART = FALSE;
		DYN_ARTFR = FALSE;
	}
	else
	{
		DYN_ART = cvar("pk_dyn_art");
		DYN_ARTFR = cvar("pk_dyn_art_force");
	}

// test it
	if (pk_flags & PK_DYNAMIC || DYN_OVR || DYN_FORCE || DYN_ARTFR)
	{
		if (!DYN_OVR && !DYN_FORCE) DYN_ARTFR_ONLY = DYN_ARTFR;
		if (!find(world,classname,"dyn_spawner"))
		{
			pk_ditems = 0;
			e = spawn();
			if (e)
			{
				e.think = dyn_item;
				e.nextthink = time + DYN_START_TIME; // do this well after items spawn
			}
		}
	}
	else
	{
		e = find(world,classname,"dyn_spawner");
		while (e)
		{
			if (WARNING) bprint("*** Warning - dynamic items deactivated, spawner removed\n");
			e.nextthink = -1;
			remove(e);
			e = find(e,classname,"dyn_spawner");
		}
	}


	if (cvar("pk_mapcode")) // print list of map codes available to console
	{
		local string cl;
		f = 1;
		while (f < 1024)
		{
			cl =  item_by_mcode(f);
			if (cl != "")
			{
				if (f < 10) bprint(" ");
				if (f < 100) bprint(" ");
				if (f < 1000) bprint(" ");
				bprint(ftos(f));
				bprint("  -  (bit: ");
				bit_print(MAXFL, bit_mcode(f, world)); // for use in bit masks
				bprint(")  ");
				bprint(cl);
				bprint("  -  (bv: ");
				bprint(ftos(bit_mcode(f, world)));
				bprint(")\n");
				if (cvar("pk_mapcode") == 2) bprint("\n");			// extra visibility - harder to read on game screen, but great for bash console view
				else if (cvar("pk_mapcode") == 4) bprint("-----------------------------------------------------------------------------\n"); 
			}
			f = f + 1;
		}
		cvar_set("pk_mapcode", "0");
	}

	if (cvar("pk_make")) // create item at random location if map code valid
	{
		fn_make(cvar("pk_make"), v0);
//		cvar_set("saved1", ftos(cvar("saved1") + 1));
		cvar_set("pk_make", "0");
	}

	item_control_menu();
}
// fn(pk_monitor) - some sv_ commands are continuosly monitored
// TDO: chaos mod - chaos effect can turn this off, so chaos can muss vars.

void() pk_monitor =
{
	pk_liveupd();

// place item controls - wait for PIC_TO to do this
// 		not done in live update because we dont want it to fire off right after a map load when things are settling down
	if (!Q_100)
	if (pic_tsk != cvar("pk_place_item"))
	if (!pic_tsk)
		place_item_control_loop();

	self.nextthink = time + 3 + random();
};

void() pk_srvcmd_load =
{
	if (!DARKPLACES && !chaos) return;

	local entity e;

// start the server monitor and loop cycle process after place item control time out (currently 5 secs)
	e = spawn();
	e.think = start_loopcyc;
	e.nextthink = time + PIC_TO + random() * 3;

	e = spawn();
	e.think = pk_monitor;
	e.nextthink = time + PIC_TO;

// set server flag bit stored states

	st_pk_sfx = st_pk_hub = st_pk_duty = 0;
	if (!pk_flags & PK_TP_SPARKSFLASH) st_pk_sfx = 1;
	if (pk_flags & PK_SF_HUB) st_pk_hub = 1;
	if (pk_flags & PK_TP_DUTYON) st_pk_duty = 1;

	if (st_pk_sfx != cvar("sv_pk_sfx")) pk_bas_flags(PK_TP_SPARKSFLASH, st_pk_sfx);
	if (st_pk_hub != cvar("sv_pk_hub")) pk_bas_flags(PK_SF_HUB, st_pk_hub);
	if (st_pk_duty != cvar("sv_pk_duty")) pk_bas_flags(PK_TP_DUTYON, st_pk_duty);

// these all req. map reload for full effectiveness
	PK_100 = cvar("sv_pk100");

// q1
	Q_99 = cvar("sv_q99");
	Q_100 = cvar("sv_q100");
	
	pk_liveupd(); // load live now, set all cfg changed vars
};

void() pk_srvcmd_set =
{
// set mcodes - this means they can change and things like func_make that have fixed map codes might go wrong if the code changes in the future - DOH!
	mcode_load();

// server controls, default on for full feature set
	pk_mapcmd = 1;
	pk_mapcfg = 1;
	pk_srvcfg = 1;

/// this section assigns vars to default values - they will rule any engine not dp registercvar able or not customized as the glquake build we release
//				- it would be trivial to take the custom cvar section from the glquake build and add to _any_ engine...

// pk control
	PK_100 = FALSE; // if true run 100% true to pk v1.11 - i n theory, dev purposes only
	PK_100_OBJERR = FALSE;
	ADMINLOCK = FALSE;
	XENV = FALSE;
	WARNING = FALSE;
	BOTFREEZE = 0;

// q1 control
	Q_99 = FALSE; // quake mode with all env effects / extra weps
	Q_100 = FALSE; // if true run 100% true to quake v106 - i n theory, dev purposes only
	Q_100_OBJERR = FALSE;

// runes
	RUNES = 0;
	RUNE_CNT = 4;
	RUNE_MOVE = 10 + rint(random() * 5);
	RUNE_MASK = 15;
	RUNE_3_ACM = 0.2;
	RUNE_AR1M = 0;
	RUNE_R1SFX = 0;

	RUNE_RANDOM = 0;
	R_EARTH = RUNE_FLG_RS; // allow power mix
	R_BLACK = RUNE_FLG_DM;
	R_HELL = RUNE_FLG_HS;
	R_ELDER = RUNE_FLG_RG;

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
	pic_tsk = 0;

// map translations

	TR_Q1DEF = 1;
	TR_Q1QRY = 1;
	TR_WOLF = 0;
	TR_DOOM = 0;
	TR_QUAKE = 0;
	TR_Q2 = 0;
	TR_Q3 = 0;
	TR_ALL = 0;
	TR_NOT = 2;

	NO_PI = 0;

	DOOM_ALPHA = 0;

// respawn times
	RSP_TIME = 30;
	POW_TIME = 30;

	EXPLBOX_RESP = 1;

// q1 ammo
	Q1_SHELLAMMO_MAX				= 100;
	Q1_NAILAMMO_MAX					= 200;
	Q1_ROCKETAMMO_MAX				= 100;
	Q1_CELLAMMO_MAX					= 200; // pk amount

	PK_BULLETAMMO_MAX				= 200; // TDO: cvar
	PK_SLUGAMMO_MAX					= 50; // TDO: cvar
	PK_GASAMMO_MAX						= 400; // TDO: cvar
	
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

	SV_AMMO_MAX = FALSE;

	PK_MAX_LIVENT = 256; // guessed - need research into where slowdown starts

// weps

	GRENADE_VEL = 600;
	HGREN_VEL = 200;
	PLASMA_VEL = 600;
	LASERCAN_VEL = 1000;
	LASER_VEL = 600;
	ROCKET_FUSE = 5.0;
	WEPHUM = 1;
	Q2_SILENCE = 0.2; // 20% vol default

// pk artifacts
	PK_ART = TRUE; // Cataboligne - 8.12.9 - pk artifacts support

// sscode - so map codes can be entity stored and find(...) string searchable
//			- nifty frikqcc compiler trick here - dont think this works with regular QC compilers

	sid_code = 
						"100":"101":"102":"103":"104":"105":"106":"107":"108":"109":"110":"111":"112":"113":"114":"115":"116":"117":"118":"119":
						"120":"121":"122":"123":"124":"125":"126":"127":"128":"129":"130":"131":"132":"133":"134":"135":"136":"137":"138":"139":
						"140":"141":"142":"143":"144":"145":"146":"147":"148":"149":"150":"151":"152":"153":"154":"155":"156":"157":"158":"159":
						"160":"161":"162":"163":"164":"165":"166":"167":"168":"169":"170":"171":"172":"173":"174":"175":"176":"177":"178":"179":
						"180":"181":"182":"183":"184":"185":"186":"187":"188":"189":"190":"191":"192":"193":"194":"195":"196":"197":"198":"199":
						"200":"201":"202":"203":"204":"205":"206":"207":"208":"209":"210":"211":"212":"213":"214":"215":"216":"217":"218":"219":
						"220":"221":"222":"223":"224":"225":"226":"227":"228":"229":"230":"231":"232":"233":"234":"235":"236":"237":"238":"239":
						"240":"241":"242":"243":"244":"245":"246":"247":"248":"249":"250":"251":"252":"253":"254":"255":"256":"257":"258":"259":
						"260":"261":"262":"263":"264":"265":"266":"267":"268":"269":"270":"271":"272":"273":"274":"275":"276":"277":"278":"279":
						"280":"281":"282":"283":"284":"285":"286":"287":"288":"289":"290":"291":"292":"293":"294":"295":"296":"297":"298":"299":
						"300":"301":"302":"303":"304":"305":"306":"307":"308":"309":"310":"311":"312":"313":"314":"315":"316":"317":"318":"319":
						"320":"321":"322":"323":"324":"325":"326":"327":"328":"329":"330":"331":"332":"333":"334":"335":"336":"337":"338":"339":
						"340":"341":"342":"343":"344":"345":"346":"347":"348":"349":"350":"351":"352":"353":"354":"355":"356":"357":"358":"359":
						"360":"361":"362":"363":"364":"365":"366":"367":"368":"369":"370":"371":"372":"373":"374":"375":"376":"377":"378":"379":
						"380":"381":"382":"383":"384":"385":"386":"387":"388":"389":"390":"391":"392":"393":"394":"395":"396":"397":"398":"399":
						"400":"401":"402":"403":"404":"405":"406":"407":"408":"409":"410":"411":"412":"413":"414":"415":"416":"417":"418":"419":
						"420":"421":"422":"423":"424":"425":"426":"427":"428":"429":"430":"431":"432":"433":"434":"435":"436":"437":"438":"439":
						"440":"441":"442":"443":"444":"445":"446":"447":"448":"449":"450":"451":"452":"453":"454":"455":"456":"457":"458":"459":
						"460":"461":"462":"463":"464":"465":"466":"467":"468":"469":"470":"471":"472":"473":"474":"475":"476":"477":"478":"479":
						"480":"481":"482":"483":"484":"485":"486":"487":"488":"489":"490":"491":"492":"493":"494":"495":"496":"497":"498":"499":
						"500":"501":"502":"503":"504":"505":"506":"507":"508":"509":"510":"511":"512":"513":"514":"515":"516":"517":"518":"519":
						"520":"521":"522":"523":"524":"525":"526":"527":"528":"529":"530":"531":"532":"533":"534":"535":"536":"537":"538":"539":
						"540":"541":"542":"543":"544":"545":"546":"547":"548":"549":"550":"551":"552":"553":"554":"555":"556":"557":"558":"559":
						"560":"561":"562":"563":"564":"565":"566":"567":"568":"569":"570":"571":"572":"573":"574":"575":"576":"577":"578":"579":
						"580":"581":"582":"583":"584":"585":"586":"587":"588":"589":"590":"591":"592":"593":"594":"595":"596":"597":"598":"599":
						"600":"601":"602":"603":"604":"605":"606":"607":"608":"609":"610":"611":"612":"613":"614":"615":"616":"617":"618":"619":
						"620":"621":"622":"623":"624":"625":"626":"627":"628":"629":"630":"631":"632":"633":"634":"635":"636":"637":"638":"639":
						"640":"641":"642":"643":"644":"645":"646":"647":"648":"649":"650":"651":"652":"653":"654":"655":"656":"657":"658":"659":
						"660":"661":"662":"663":"664":"665":"666":"667":"668":"669":"670":"671":"672":"673":"674":"675":"676":"677":"678":"679":
						"680":"681":"682":"683":"684":"685":"686":"687":"688":"689":"690":"691":"692":"693":"694":"695":"696":"697":"698":"699":
						"700":"701":"702":"703":"704":"705":"706":"707":"708":"709":"710":"711":"712":"713":"714":"715":"716":"717":"718":"719":
						"720":"721":"722":"723":"724":"725":"726":"727":"728":"729":"730":"731":"732":"733":"734":"735":"736":"737":"738":"739":
						"740":"741":"742":"743":"744":"745":"746":"747":"748":"749":"750":"751":"752":"753":"754":"755":"756":"757":"758":"759":
						"760":"761":"762":"763":"764":"765":"766":"767":"768":"769":"770":"771":"772":"773":"774":"775":"776":"777":"778":"779":
						"780":"781":"782":"783":"784":"785":"786":"787":"788":"789":"790":"791":"792":"793":"794":"795":"796":"797":"798":"799":
						"800":"801":"802":"803":"804":"805":"806":"807":"808":"809":"810":"811":"812":"813":"814":"815":"816":"817":"818":"819":
						"820":"821":"822":"823":"824":"825":"826":"827":"828":"829":"830":"831":"832":"833":"834":"835":"836":"837":"838":"839":
						"840":"841":"842":"843":"844":"845":"846":"847":"848":"849":"850":"851":"852":"853":"854":"855":"856":"857":"858":"859":
						"860":"861":"862":"863":"864":"865":"866":"867":"868":"869":"870":"871":"872":"873":"874":"875":"876":"877":"878":"879":
						"880":"881":"882":"883":"884":"885":"886":"887":"888":"889":"890":"891":"892":"893":"894":"895":"896":"897":"898":"899":
						"900":"901":"902":"903":"904":"905":"906":"907":"908":"909":"910":"911":"912":"913":"914":"915":"916":"917":"918":"919":
						"920":"921":"922":"923":"924":"925":"926":"927":"928":"929":"930":"931":"932":"933":"934":"935":"936":"937":"938":"939":
						"940":"941":"942":"943":"944":"945":"946":"947":"948":"949":"950":"951":"952":"953":"954":"955":"956":"957":"958":"959":
						"960":"961":"962":"963":"964":"965":"966":"967":"968":"969":"970":"971":"972":"973":"974":"975":"976":"977":"978":"979":
						"980":"981":"982":"983":"984":"985":"986":"987":"988":"989":"990":"991":"992":"993":"994":"995":"996":"997":"998":"999";

// not an enabled / wise engine - we must return now, no live server controls are possible and we are running on defaults

	if (!DARKPLACES && !chaos) return;

// new server controls
// NOTE: chaos eng mod contains all these

	if (DARKPLACES) // reg under darkplaces - chaos engine has pre-reg
	{
// server controls
		registercvar("sv_dmstart", "0");
		registercvar("sv_c_mapcmd", "1");
		registercvar("sv_c_mapcfg", "1");
		registercvar("sv_c_srvcfg", "1");
		registercvar("sv_c_botfreeze", "0"); // for testing
		registercvar("sv_c_warning", "0");
		registercvar("sv_c_adminlock", "0"); // if true, admin menu is locked out
		registercvar("sv_c_xenv", "0"); // if true extra env stuff stops
		registercvar("sv_c_ammo_max", "0"); // if true server values for max ammo override all genre limits
																						  // if false genre limits apply
																						  // if 2 override all limit settings and use server values - this stops rune & pack increases

// pk*bot server control - spawns bots on level changes
		registercvar("sv_bot_pk", "0"); // bot count . skills non team - replaces parm12
		registercvar("sv_bot_pktm", "0"); // bot count . skills - team - replaces parm13
		registercvar("sv_bot_pkset", "0"); // bot stats saved

// rune server
		registercvar("sv_c_rune", "0");
		registercvar("sv_c_rune_cnt", "4");
		registercvar("sv_c_rune_mask", "15");
		registercvar("sv_c_rune_3acm", "0.2");
		registercvar("sv_c_rune_random", "0"); // runes will have random powers
		registercvar("sv_c_rune_set", "0");
		registercvar("sv_c_rune_allowrule1multi", "0"); // if true more than 1 rune can be gotten in rule 1
		registercvar("sv_c_rune_rule1sfx", "1"); // if true and multi 3 & 4 runes in 1 player have side effects

		registercvar("sv_c_rsp_time", "30");
		registercvar("sv_c_pow_time", "30"); // artifact power time

		registercvar("sv_vw", "1");
		registercvar("sv_vw_armor", "0");
// painkeep controls
		registercvar("sv_pk99", "0");
		registercvar("sv_pk100", "0");
		registercvar("sv_pk100_objerr", "0");
		registercvar("sv_pk_art", "1");

		registercvar("sv_pk_sfx", "1");
		registercvar("sv_pk_hub", "1");
		registercvar("sv_pk_duty", "0");

// cam controls
		registercvar("sv_cam_off", "0"); // set to 1 to turn cam off entirely
		registercvar("sv_cam_def", "1"); // set to 0 to default to no cam view
		registercvar("sv_cam_timeout", "0"); // set to # to timeout dead cam in # secs - limit on deadcam state
		registercvar("sv_cam_to_action", "0"); // set to 1 - disconnect, 0 - respawn

		registercvar("botlevel", "0"); // when true, post code will call bot_changelevel so manual change will load pk*bs
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
		registercvar("pk_art_rep", "1"); // replace artifacts w/pk items when off

		registercvar("pk_explbox_resp", "1"); // respawn boom boxes / barrels

// map translations

		registercvar("pk_tr_q1def", "1"); // if q100 or pk100 and no wad == "q1" on map - default to translate
		registercvar("pk_tr_wolf", "0");
		registercvar("pk_tr_doom", "0");
		registercvar("pk_tr_quake", "0");
		registercvar("pk_tr_q2", "0");
		registercvar("pk_tr_q3", "0");
		registercvar("pk_tr_all", "0");
		registercvar("pk_tr_not", "2"); // 0 - leave items with no translation, 1 - remove, 2 - best guess, 3 - randomize
		registercvar("pk_translate", "0");

		registercvar("pk_doom_alpha", "0"); // sort of a translate - use doom alpha / pre-beta models, for use with alpha maps
														// 04 - doom alpha level 0.4
														// 05 - doom alpha level 0.5
														// 06 - doom alpha level pre-beta

// pk items
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
		registercvar("q1_cellammo_max", "100");

		registercvar("pk_cellammo_max", "200");

		registercvar("q2_silence", "0.2");

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
/// loop master - no individual loops will run - possible to swamp loop sets this way
// remove / replace
/// 0 loop id set - ids 1 - 6 all 0, remove these items - 1+ set, change 0 to 1 and loop from there - 0 id never loaded again
/// 0 loop id set to -666 - remove all items id'ed
/// 0 loop id set to -{map code} - xfrm all items id'ed into map code
// plain loop
/// 0 not set, 1 set - 2 - 6 not set, exit / remove - 2+ set, loop starting with id 1

		registercvar("pk_cyc_master", "0"); // if true no individual loops
		registercvar("pk_cyc_halt", "0"); // if true halt all loops, restore original items (0 or 1)
		registercvar("pk_cyc_dyn", "0"); // if true include dynamic items in loop change
		registercvar("pk_place_item", "0"); // place_item will if this is:  1 - not load regular map items, 2 - randomize all items (at time < 5 secs)
		registercvar("pk_place_item_reload", "0"); // reload place_item 2 deal every this cnt + this cnt * random
		registercvar("pk_mapcode", "0"); // if true print mapcode item classname calls to console
		registercvar("pk_make", "0"); // if set to valid map code, create item at player location
		registercvar("pk_runemap", "0"); // if true print rune data to console
		registercvar("pk_tog_mcode", "0"); // if set toggle mcode item bit in item override
		registercvar("pk_tog_itemmenu", "0"); // if set run menu cmd item - includes show menu, 32

// lg loop
		registercvar("pk_cyc_lg_t", "-60"); // time for loop - if (-) neg, 20% val + random() * 80% val
		registercvar("pk_cyc_lg_0", "0");
		registercvar("pk_cyc_lg_1", "0");
		registercvar("pk_cyc_lg_2", "0");
		registercvar("pk_cyc_lg_3", "0");
		registercvar("pk_cyc_lg_4", "0");
		registercvar("pk_cyc_lg_5", "0");
		registercvar("pk_cyc_lg_6", "0");
// rl loop
		registercvar("pk_cyc_rl_t", "-60"); // default = 13 - 60 mins
		registercvar("pk_cyc_rl_0", "0");
		registercvar("pk_cyc_rl_1", "0");
		registercvar("pk_cyc_rl_2", "0");
		registercvar("pk_cyc_rl_3", "0");
		registercvar("pk_cyc_rl_4", "0");
		registercvar("pk_cyc_rl_5", "0");
		registercvar("pk_cyc_rl_6", "0");
// gl loop
		registercvar("pk_cyc_gl_t", "-60");
		registercvar("pk_cyc_gl_0", "0");
		registercvar("pk_cyc_gl_1", "0");
		registercvar("pk_cyc_gl_2", "0");
		registercvar("pk_cyc_gl_3", "0");
		registercvar("pk_cyc_gl_4", "0");
		registercvar("pk_cyc_gl_5", "0");
		registercvar("pk_cyc_gl_6", "0");
// sng loop
		registercvar("pk_cyc_sng_t", "-60");
		registercvar("pk_cyc_sng_0", "0");
		registercvar("pk_cyc_sng_1", "0");
		registercvar("pk_cyc_sng_2", "0");
		registercvar("pk_cyc_sng_3", "0");
		registercvar("pk_cyc_sng_4", "0");
		registercvar("pk_cyc_sng_5", "0");
		registercvar("pk_cyc_sng_6", "0");
// ng loop
		registercvar("pk_cyc_ng_t", "-60");
		registercvar("pk_cyc_ng_0", "0");
		registercvar("pk_cyc_ng_1", "0");
		registercvar("pk_cyc_ng_2", "0");
		registercvar("pk_cyc_ng_3", "0");
		registercvar("pk_cyc_ng_4", "0");
		registercvar("pk_cyc_ng_5", "0");
		registercvar("pk_cyc_ng_6", "0");
// ssg loop
		registercvar("pk_cyc_ssg_t", "-60");
		registercvar("pk_cyc_ssg_0", "0");
		registercvar("pk_cyc_ssg_1", "0");
		registercvar("pk_cyc_ssg_2", "0");
		registercvar("pk_cyc_ssg_3", "0");
		registercvar("pk_cyc_ssg_4", "0");
		registercvar("pk_cyc_ssg_5", "0");
		registercvar("pk_cyc_ssg_6", "0");
// pkw loop - painkeep range weps
		registercvar("pk_cyc_pkw_t", "-60");
		registercvar("pk_cyc_pkw_0", "0");
		registercvar("pk_cyc_pkw_1", "0");
		registercvar("pk_cyc_pkw_2", "0");
		registercvar("pk_cyc_pkw_3", "0");
		registercvar("pk_cyc_pkw_4", "0");
		registercvar("pk_cyc_pkw_5", "0");
		registercvar("pk_cyc_pkw_6", "0");
// pkc loop - painkeep fire & forget
		registercvar("pk_cyc_pkc_t", "-60");
		registercvar("pk_cyc_pkc_0", "0");
		registercvar("pk_cyc_pkc_1", "0");
		registercvar("pk_cyc_pkc_2", "0");
		registercvar("pk_cyc_pkc_3", "0");
		registercvar("pk_cyc_pkc_4", "0");
		registercvar("pk_cyc_pkc_5", "0");
		registercvar("pk_cyc_pkc_6", "0");
// art loop
		registercvar("pk_cyc_art_t", "-60");
		registercvar("pk_cyc_art_0", "0");
		registercvar("pk_cyc_art_1", "0");
		registercvar("pk_cyc_art_2", "0");
		registercvar("pk_cyc_art_3", "0");
		registercvar("pk_cyc_art_4", "0");
		registercvar("pk_cyc_art_5", "0");
		registercvar("pk_cyc_art_6", "0");
// ammo loop
		registercvar("pk_cyc_ammo_t", "-60");
		registercvar("pk_cyc_ammo_0", "0");
		registercvar("pk_cyc_ammo_1", "0");
		registercvar("pk_cyc_ammo_2", "0");
		registercvar("pk_cyc_ammo_3", "0");
		registercvar("pk_cyc_ammo_4", "0");
		registercvar("pk_cyc_ammo_5", "0");
		registercvar("pk_cyc_ammo_6", "0");
// itm loop
		registercvar("pk_cyc_itm_t", "-60");
		registercvar("pk_cyc_itm_0", "0");
		registercvar("pk_cyc_itm_1", "0");
		registercvar("pk_cyc_itm_2", "0");
		registercvar("pk_cyc_itm_3", "0");
		registercvar("pk_cyc_itm_4", "0");
		registercvar("pk_cyc_itm_5", "0");
		registercvar("pk_cyc_itm_6", "0");

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
		ADMINLOCK = cvar("sv_c_adminlock"); // so server admin can lock out remote admins in case of abuse - local console commands will still work

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

	pk_srvcmd_load();
};

// called from many places - handles pk_mode 0 where map sets whether or not we use PK stuff

// really sound(), mod for frikbot code
// called from sound(...) in frikbot/bot.qc

void(entity e, float chan, string samp, float vol, float atten) pk_sound = 
{
	local string psamp;
	local float svol;

	svol = vol;
	psamp = samp; // sample that actually plays

	if (!PK)
	{
		if (samp == "ambience/windfly.wav") psamp = "alt_ambience/windfly.wav";
		if (samp == "items/r_item2.wav") psamp = "alt_sounds/items/r_item2.wav";
		if (samp == "misc/secret.wav") psamp = "alt_sounds/misc/secret.wav";
	}

// TDO: q2 silencer for wep channel stuff
	if (chan == CHAN_WEAPON)
	if (e.silencer_finished)
	if (e.silencer_finished > time)
	{
		svol = vol * Q2_SILENCE;
	}
	else
	{
		e.silencer_finished = 0;
		sprint (e, "Silencer used up\n");
	}

// pk_sound() - fn() here plays actual sound
	frik_sound(e, chan, psamp, svol, atten);
};

void(vector pos, string samp, float vol, float atten) ambientsound =
{
	local string psamp;

	psamp = samp; // sample that actually plays

	if (!PK || Q_100 || Q_99) // not in PK mode, play alternate sounds
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

