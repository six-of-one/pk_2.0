/* ::-::
 *
 * Cataboligne
 *
 * file: q3items.qc
 *
 * date: 10/16/08
 *
 * qc - support q3 stuff so darkplaces can run q3 maps for painkeep
 *
 */


// q3 values

float Q3_DEFW					= 123;
float Q3_DEFA					= 100;

float Q3_MAX					= 200;

// ammo skins in mdl
float q3_bfg_amsk				= 0;
float q3_rail_amsk			= 1;
float q3_plasma_amsk			= 2;
float q3_lightn_amsk			= 3;
float q3_rocket_amsk			= 4;
float q3_grenade_amsk		= 5;
float q3_shot_amsk			= 6;
float q3_mach_amsk			= 7;

float Q3_BFG_AMMO				= 150;
float Q3_SLUG_AMMO			= 10;
float Q3_CELL_AMMO			= 30;
float Q3_ELEX_AMMO			= 60;
float Q3_ROCK_AMMO			= 5;
float Q3_GREN_AMMO			= 5;
float Q3_SHOT_AMMO			= 10;
float Q3_BULLET_AMMO			= 50;

float Q3_ARM_RED				= 100;
float Q3_ARM_YEL				= 50;
float Q3_ARM_SHARD			= 5;
float Q3_ARM_MAX				= 200;

float Q3_WEP_WAIT				= 5;
float Q3_AMMO_WAIT			= 40;
float Q3_POWER_WAIT			= 120;
float Q3_HEAL_WAIT			= 35;
float Q3_ARM_WAIT				= 25;

/*
float Q3_HEALLG				= 0; // skin ? - not needed for now
float Q3_HEALMD				= 1;
float Q3_HEAL5					= 2;
float Q3_HEALM					= 3;
*/

float Q3_HEALLG_A				= 50;
float Q3_HEALMD_A				= 25;
float Q3_HEAL5_A				= 5;
float Q3_HEALM_A				= 100;

vector Q3_LIFT					= ' 0 0 20'; // q3 models sit too "low" - lift them by this on spawn

string Q3_BOBHOFF				= "cl_itembobheight 0\n"; // q3 item bob height off setting
string Q3_BOBH					= "cl_itembobheight 8\n"; // q3 item bob height default - compile as 0 to disable (server cfg parm?)
string Q3_BOBHALIAS			= "q3bobheight\n"; // q3 item bob height alias to run

float q3_bob_on; // server cfg this to 1 for total disable
// for q3 maps
// = 0, q3 bob is off
// = 1, q3 bob is activated
// = -1 q3 bob is waiting activation by player stuff - items cant stuff

void() q3_precache =
{
//	precache_model ("");
//	precache_sound ("");

// all ammo
	precache_model ("progs/q3_ammobox.mdl");
// weps
	precache_model ("progs/q3_shot.mdl");
	precache_model ("progs/q3_rl.mdl");
	precache_model ("progs/q3_rail.mdl");
	precache_model ("progs/q3_bfg.mdl");
	precache_model ("progs/q3_gl.mdl");
	precache_model ("progs/q3_lg.mdl");
	precache_model ("progs/q3_mgun.mdl");
	precache_model ("progs/q3_gauntlet.mdl");

// 1pv
	precache_model ("progs/v_q3_shot.mdl");
	precache_model ("progs/v_q3_bfg.mdl");
	precache_model ("progs/v_q3_gl.mdl");
//	precache_model ("progs/v_q3_hawk.mdl");
	precache_model ("progs/v_q3_mgun.mdl");
//	precache_model ("progs/v_q3_mini.mdl");
	precache_model ("progs/v_q3_plg.mdl");
	precache_model ("progs/v_q3_rail.mdl");
	precache_model ("progs/v_q3_rl.mdl");
	precache_model ("progs/v_q3_lg.mdl");
// carry
	precache_model ("progs/vw_q3_ssg.mdl");
	precache_model ("progs/vw_q3_bfg.mdl");
	precache_model ("progs/vw_q3_gl.mdl");
	precache_model ("progs/vw_q3_lg.mdl");
	precache_model ("progs/vw_q3_mg.mdl");
	precache_model ("progs/vw_q3_plg.mdl");
	precache_model ("progs/vw_q3_rail.mdl");
	precache_model ("progs/vw_q3_rl.mdl");


// hear it
	precache_sound ("q3_snd/am_pkup.wav");
	precache_sound ("q3_snd/w_pkup.wav");
	precache_sound ("q3_snd/respawn1.wav");
// fire
	precache_sound ("q3_snd/rocklf1a.wav");
	precache_sound ("q3_snd/rocklx1a.wav");
	precache_sound ("q3_snd/grenlf1a.wav");
	precache_sound ("q3_snd/sshotf1b.wav");
	precache_sound ("q3_snd/machgf1b.wav");
	precache_sound ("q3_snd/hyprbf1a.wav");
	precache_sound ("q3_snd/railgf1a.wav");
	precache_sound ("q3_snd/rg_hum.wav");
	precache_sound ("q3_snd/lg_fire.wav");
	precache_sound ("q3_snd/lg_hum.wav");
	precache_sound ("q3_snd/bfg_fire.wav");
	precache_sound ("q3_snd/bfg_hum.wav");
};

// bob em - needs called from client capable of stuff cmd
void() q3_bob_height =
{
	if (q3_bob_on > 0) return;
	if (q3_bob_on == 0) q3_bob_on = -1;
	if (!self.flags & FL_CLIENT) return;

	q3_bob_on = 1;
	stuffcmd(self, Q3_BOBH); // bob q3 items, heh heh
	stuffcmd(self, Q3_BOBHALIAS); // alias override
};

/*
deprecating for full support - need this in translate

q3 support via translation

- precache needed !

SV_SoundIndex("sound/misc/w_pkup.wav"): not precached (fix your code), precaching anyway
SV_SoundIndex("sound/misc/am_pkup.wav"): not precached (fix your code), precaching anyway
SV_SoundIndex("sound/items/respawn1.wav"): not precached (fix your code), precaching anyway
SV_SoundIndex("reggun/fire4.wav"): not precached (fix your code), precaching anyway
SV_SoundIndex("sound/weapons/machinegun/machgf1b.wav"): not precached (fix your code), precaching anyway
SV_SoundIndex("sound/weapons/rocket/rocklf1a.wav"): not precached (fix your code), precaching anyway

*/

float SUSPENDED = 1; // some q3 items "float" in the air - hope this works

// fn(q3_suspend) - make q3 items suspended as per q3 map spawnflag SUSPEND

void() q3_suspend =
{
	self.map = "Q3";
	self.movetype = MOVETYPE_NONE;
};

// some weapons / items are translated into equivs

/*QUAKED weapon_bfg (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () q3_weapon_bfg =
{
	d_weapon_bfg();
	self.netname = "BFG";

	self.touch = d_weapon_touch;
	self._attack = X_Fire3BFG;
	self._fr_attack = player_shot1;

	self.items = IT_LIGHTNING;
	self.currentammo = 200;
	self.lip = AMMO_CELLS;
	self.attack_finished = 0.2;
	self.dmg = 100;
	self.dodmg = 120;
	self.dmg_save = 10;
	self.dmg_take = 1;

	setmodel (self, "progs/q3_bfg.mdl");
	self.weaponmodel = "progs/v_q3_bfg.mdl";
	self.vwepmdl = "progs/vw_q3_bfg.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/bfg_fire.wav";
	self.noise2 = "q3_snd/bfg_hum.wav";
	self.target = "q3_snd/plasmx1a.wav"; // TDO: get right snd
	self.chaosweptime = 0.93;

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() weapon_bfg =
{
	if (world.wad == "")
		q3_weapon_bfg();
	else // if (world.wad == "q2.wad")
		q2_weapon_bfg();
}

/*QUAKED weapon_plasmagun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_plasmagun =
{
	d_weapon_plasma();
	self.netname = "Plasma Gun";

	self.touch = d_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_plasma1;

	self.items = IT_NAILGUN;
	self.currentammo = 50;
	self.lip = AMMO_CELLS;
	self.attack_finished = 0.1; // 10 per
	self.dmg = 20;
	self.dodmg = 15;
	self.dmg_save = 1;
	self.dmg_take = 1;

	setmodel (self, "progs/q3_plg.mdl");
	self.weaponmodel = "progs/v_q3_plg.mdl";
	self.vwepmdl = "progs/vw_q3_plg.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/hyprbf1a.wav";
	self.target = "q3_snd/plasmx1a.wav";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

/*QUAKED weapon_machinegun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

// doing the same way even tho q3 doesnt offer a dbl yet
void() q3_mg_base =
{
// stats
	self.items = IT_SUPER_NAILGUN;
	self.currentammo = 100;
	self.lip = AMMO_BULLETS;
	self.attack_finished = 0.1; // 10 per
	self.dmg = 7;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.punchangle = ' 0.025 0.025 0';

	self.netname = "Machine Gun";

	setmodel (self, "progs/q3_mgun.mdl");
	self.weaponmodel = "progs/v_q3_mgun.mdl";
	self.vwepmdl = "progs/vw_q3_mg.mdl";
};

void() q3_weapon_machinegun =
{
	weapon_nailgun();

	q3_mg_base();
	self.touch = d_weapon_touch;//wchg2_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_mgchg1;

	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/machgf1b.wav";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() weapon_machinegun =
{
	if (world.wad == "")
		q3_weapon_machinegun();
	else // if (world.wad == "q2.wad")
		q2_weapon_machinegun();
}

/*QUAKED weapon_shotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() q3_weapon_shotgun =
{
	q100_weapon_supershotgun();
	self.netname = "Shotgun";

	self.touch = d_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = Q3_SHOT_AMMO;
	self.items = IT_SUPER_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.attack_finished = 1;
	self.dmg = 10;
	self.dmg_save = 2;
	self.dmg_take = 11; // shot cnt
	self.punchangle = ' 0.14 0.08 0'; // bullet spread out -- TDO: get doom value, this is q1

	setmodel (self, "progs/q3_shot.mdl");
	self.weaponmodel = "progs/v_q3_shot.mdl";
	self.vwepmdl = "progs/vw_q3_ssg.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/sshotf1b.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void () weapon_supershotgun =
{
	if (world.wad == "q2.wad")
	{
		q2_weapon_supershotgun();
		return;
	}

	q100_weapon_supershotgun();
};

void() q3_weapon_rocketlauncher =
{
	q100_weapon_rocketlauncher();

// fn
	self.touch = d_weapon_touch;
	self._attack = W_FireRocket;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = 10;
	self.items = IT_ROCKET_LAUNCHER;
	self.lip = AMMO_ROCKETS;
	self.attack_finished = 0.8;
	self.dmg = 100;
	self.dodmg = 120; // splash
	self.dmg_save = 1;

// appearances
	setmodel (self, "progs/q3_rl.mdl");
	self.weaponmodel = "progs/v_q3_rl.mdl";
	self.vwepmdl = "progs/vw_q3_rl.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/rocklf1a.wav";
	self.target = "q3_snd/rocklx1a.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void () weapon_rocketlauncher =
{
	if (world.wad == "q2.wad")
	{
		q2_weapon_rocketlauncher();
		return;
	}
	else if (world.wad == "")
	{
		q3_weapon_rocketlauncher(); 
		return;
	}

	q100_weapon_rocketlauncher();
};

void () q3_weapon_grenadelauncher =
{
	q100_weapon_grenadelauncher();

// fn
	self.touch = d_weapon_touch;
	self._attack = W_FireGrenade;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = 10;
	self.items = IT_GRENADE_LAUNCHER;
	self.lip = AMMO_ROCKETS;
	self.attack_finished = 0.8;
	self.dmg = 100;
	self.dodmg = 150; // splash
	self.dmg_save = 1;

// appearances
	setmodel (self, "progs/q3_gl.mdl");
	self.weaponmodel = "progs/v_q3_gl.mdl";
	self.vwepmdl = "progs/vw_q3_gl.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/grenlf1a.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void () weapon_grenadelauncher =
{
	if (world.wad == "q2.wad")
	{
		q2_weapon_grenadelauncher();
		return;
	}
	else if (world.wad == "")
	{
		q3_weapon_grenadelauncher(); 
		return;
	}

	q100_weapon_grenadelauncher();
};

void () weapon_gauntlet =
{
	weapon_axe();
	self.netname = "Gauntlet";

	self.touch = d_weapon_touch;
//	self._attack = X_FireHitscan;
//	self._fr_attack = player_shot1;

	self.currentammo = 0;
	self.items = IT_NAILGUN; // IT_AXE; // test
	self.lip = 0;
	self.attack_finished = 0.4;
	self.dmg = 50;
	self.dmg_save = 0;
	self.dmg_take = 1; // shot cnt

	setmodel (self, "progs/q3_gauntlet.mdl");
//	self.weaponmodel = "progs/v_q3_.mdl";
//	self.vwepmdl = "progs/vw_q3_.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
//	self.noise3 = "q3_snd/sshotf1b.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};


/*QUAKED weapon_grapplinghook (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_grapplinghook =
{
	weapon_axe();
	self.netname = "Grappling hook";

	self.touch = d_weapon_touch;
//	self._attack = X_FireHitscan;
//	self._fr_attack = player_shot1;

	self.currentammo = 0;
	self.items = IT_NAILGUN; // IT_AXE; // test
	self.lip = 0;
	self.attack_finished = 0.5;
	self.dmg = 5;
	self.dmg_save = 0;
	self.dmg_take = 1; // shot cnt

	setmodel (self, "progs/q3_grapple.mdl");
//	self.weaponmodel = "progs/v_q3_.mdl";
//	self.vwepmdl = "progs/vw_q3_.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
//	self.noise3 = "q3_snd/sshotf1b.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void () q3_weapon_lightning =
{
	q100_weapon_lightning();
	self.netname = "Lightning Gun";

	self.touch = d_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_light1;

	self.currentammo = 100;
	self.items = IT_LIGHTNING;
	self.lip = AMMO_CELLS;
	self.attack_finished = 0.1; // TDO: separate from q1 lg fire
	self.dmg = 8;
	self.dmg_save = 1;
	self.dmg_take = 1; // shot cnt

	setmodel (self, "progs/q3_lg.mdl");
	self.weaponmodel = "progs/v_q3_lg.mdl";
	self.vwepmdl = "progs/vw_q3_lg.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/lg_fire.wav";
//	self.noise2 = "q3_snd/lg_hum.wav"; // ? - could have been 1 lg used to use
	self.chaosweptime = 0.964;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

//weapon_lightning - already exists

void() weapon_lightning =
{
	if (world.wad == "")
	{
		q3_weapon_lightning();
		return;
	}

	q100_weapon_lightning(); 
};

void () q3_weapon_railgun =
{
	q100_weapon_lightning();
	self.netname = "Rail Gun";

	self.touch = d_weapon_touch;
	self._attack = player_rocket1;
	self._fr_attack = X_FireRailgun;

	self.currentammo = Q3_SLUG_AMMO;
	self.items = IT_LIGHTNING;
	self.lip = AMMO_SLUGS;
	self.attack_finished = 1.5;
	self.dmg = 100;
	self.dmg_save = 1;
	self.dmg_take = 1; // shot cnt

	setmodel (self, "progs/q3_rail.mdl");
	self.weaponmodel = "progs/v_q3_rail.mdl";
	self.vwepmdl = "progs/vw_q3_rail.mdl";
	self.noise = "q3_snd/w_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.noise3 = "q3_snd/railgf1a.wav"; // TDO: impact site snd
	self.noise2 = "q3_snd/rg_hum.wav"; // gun hum
	self.chaosweptime = 1.16;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
	if (self.spawnflags & SUSPENDED) q3_suspend();
};

//weapon_railgun

void() weapon_railgun =
{
	if (world.wad == "q2.wad")
	{
		q2_weapon_railgun();
		return;
	}
	else //if (world.wad == "")
	{
		q3_weapon_railgun(); 
		return;
	}
};

void() q3_ammo_bullets =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_spikes();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_BULLETS;
	self.currentammo = Q3_BULLET_AMMO;

	self.classname = "ammo_bullets";
	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_mach_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.netname = "Bullets";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

void() ammo_bullets =
{
	if (world.wad == "")
		q3_ammo_bullets();
	else // if (world.wad == "q2.wad")
		q2_ammo_bullets();
};

void() q3_ammo_grenades =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_spikes();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_ROCKETS;
	self.currentammo = Q3_GREN_AMMO;

	self.classname = "ammo_grenades";
	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_grenade_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.netname = "Grenades";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

void() ammo_grenades =
{
	if (world.wad == "")
		q3_ammo_grenades();
	else // if (world.wad == "q2.wad")
		q2_ammo_grenades();
}

void() ammo_lightning =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_shells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_CELLS;
	self.currentammo = Q3_ELEX_AMMO;

	self.classname = "ammo_lightning";
	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_lightn_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.netname = "Cells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

void() ammo_bfg =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_shells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_CELLS; // FIX
	self.currentammo = Q3_BFG_AMMO;

	self.classname = "ammo_bfg";
	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_bfg_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.netname = "Cells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

// spawnfunc_ - because quake already has variables ammo_* and the function names cannot be used
//  -- darkplaces has a special call mode for map items that appends spawnfunc_ to cover stuff like this

//ammo_shells
//ammo_rockets
//ammo_cells

void() q3_ammo_shells =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_shells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_SHELLS;
	self.currentammo = Q3_SHOT_AMMO;

	self.classname = "ammo_shells";
	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_shot_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.netname = "Shells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

void() spawnfunc_ammo_shells =
{
	if (world.wad == "")
		q3_ammo_shells();
	else // if (world.wad == "q2.wad")
		q2_ammo_shells();
};

void() q3_ammo_rockets =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_shells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_ROCKETS;
	self.currentammo = Q3_ROCK_AMMO;

	self.classname = "ammo_rockets";
	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_rocket_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.netname = "Rockets";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

void() spawnfunc_ammo_rockets =
{
	if (world.wad == "")
		q3_ammo_rockets();
	else // if (world.wad == "q2.wad")
		q2_ammo_rockets();
};

void() q3_ammo_cells =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_shells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_CELLS;
	self.currentammo = Q3_CELL_AMMO;

	self.classname = "ammo_cells";
	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_plasma_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.netname = "Cells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}

void() spawnfunc_ammo_cells =
{
	if (world.wad == "")
		q3_ammo_cells();
	else // if (world.wad == "q2.wad")
		q2_ammo_cells();
};

//ammo_slugs

void() q3_ammo_slugs =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	item_shells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_SLUGS;
	self.currentammo = Q3_SLUG_AMMO;

	self.classname = "ammo_slugs";
	setmodel (self, "progs/q3_ammobox.mdl");
	self.skin = q3_rail_amsk;
	self.noise = "q3_snd/am_pkup.wav";
	self.noise4 = "q3_snd/respawn1.wav";
	self.netname = "Slugs";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q3_item";
}


void() ammo_slugs =
{
	if (world.wad == "")
		q3_ammo_slugs();
	else // if (world.wad == "q2.wad")
		q2_ammo_slugs();
};


void() item_armor_combat =
{
	self.classname = "item_armor2";
	item_armor2();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_armor_body =
{
	self.classname = "item_armorInv";
	item_armorInv();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// heh heh

void() item_armor_shard =
{
	self.classname = "item_painkeep_beartrap";
	item_painkeep_beartrap();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// heh heh

void() item_health_small =
{
	self.classname = "light_painkeep_candle";
	light_painkeep_candle();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// 2 * health

void() item_health_large =
{

	local entity e;

	self.classname = "item_health";
	item_health();
	if (self.spawnflags & SUSPENDED) q3_suspend();

	e = spawn();
	setorigin(e, self.origin);
	e.spawnflags = self.spawnflags;
	self = e;
	item_health();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_health_mega =
{
	self.classname = "item_health";
	self.spawnflags = self.spawnflags | 2;
	item_health();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_quad =
{
	self.classname = "item_artifact_super_damage";
	item_artifact_super_damage();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_regen =
{
	self.classname = "item_artifact_invulnerability";
	item_artifact_invulnerability();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_invis =
{
	self.classname = "item_artifact_invisibility";
	item_artifact_invisibility();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_enviro =
{
	self.classname = "item_artifact_envirosuit";
	item_artifact_envirosuit();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// holdables

void() holdable_medkit =
{
	self.classname = "item_painkeep_can";
	item_painkeep_can();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() holdable_teleporter =
{
	self.classname = "item_pkplus_phone";
	item_pkplus_phone();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// enable other q3 map ents

/*		q3 ---
	QUAKED info_player_intermission (1 0 1) (-16 -16 -16) (16 16 16)
Camera for intermission screen between matches. This also automatically generates the podium for bot arena matches (see Notes). Can be aimed by setting the "angles" key or targeting an pointing to an aiming entity. Use only one per level.
-------- KEYS --------
angles: alternate "pitch, yaw, roll" angles method of aiming intermission camera (default 0 0 0).
target : point this to an info_notnull or target_position entity to set the camera's pointing angles.
-------- NOTES --------
In genuine bot arena matches, the podium for the 1st, 2nd and 3rd place players at the end of the match is generated by this entity. The podium's origin will automatically be located 128 units in the direction of the camera's view and 84 units down from the y height of the view line at that point. It will also always be generated on a level plane regardless of the pointing angle of the camera so if that angle is too steep, part of the podium model might not be visible. Make sure you leave at least 106 units of free space in front of where the camera points to otherwise the podium model won't be visible at all.
*/

void() info_player_intermission =
{

};

/*		q3 ---
	QUAKED target_position (0 .5 0) (-8 -8 -8) (8 8 8)
Aiming target for entities like light, misc_portal_camera and trigger_push (jump pads) in particular.
-------- KEYS --------
targetname : the entity that requires an aiming direction points to this.
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
-------- NOTES --------
To make a jump pad, place this entity at the highest point of the jump and target it with a trigger_push entity.
*/

void() target_position =
{

};


/*		q3 ---
	QUAKED misc_teleporter_dest (1 .5 .25) (-32 -32 -24) (32 32 -16)

Teleport destination location point for trigger_teleporter entities.
-------- KEYS --------
angle : direction in which player will look when teleported.
targetname : make the trigger_teleporter point to this.
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
*/


void() misc_teleporter_dest =
{
// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin = self.origin + '0 0 27';
	if (!self.targetname)
	{
		if (Q_100 && Q_100_OBJERR) objerror ("no targetname");
		bprint("q3 - misc_teleporter_dest missing name! please repair the map...\n");
		self.targetname = ftos(floor(random() * 65535));
	}

};

// altarbetas teleporter for some reason - works in q3

void() target_teleporter =
{
	misc_teleporter_dest();
};

// some q3 triggers may be like this ??

void() misc_teleporter =
{
	trigger_teleport();
};

// fn(q3_play_sound) - play a sound for target_speaker, repeating or by activator
// fn(q3_sound_think) - periodic repeating sound for target speaker

float Q3_LOOPON				= 1;
float Q3_LOOPOFF				= 2;
float Q3_GLOBAL				= 4;
float Q3_ACTIVATOR			= 8;

void() q3_play_sound =
{
	sound (self, CHAN_AUTO, self.noise, 1, self.aflag);
};

void() q3_sound_think =
{
	q3_play_sound();
	self.nextthink = time + self.wait + 5 * random();
};

/*		q3 ---
	QUAKED target_speaker (0 .7 .7) (-8 -8 -8) (8 8 8) LOOPED_ON LOOPED_OFF GLOBAL ACTIVATOR
Sound generating entity that plays .wav files. Normal non-looping sounds play each time the target_speaker is triggered. Looping sounds can be set to play by themselves (no activating trigger) or be toggled on/off by a trigger.
-------- KEYS --------
noise : path/name of .wav file to play (eg. sound/world/growl1.wav - see Notes).
wait : delay in seconds between each time the sound is played ("random" key must be set - see Notes).
random : random time variance in seconds added or subtracted from "wait" delay ("wait" key must be set - see Notes).
targetname : the activating button or trigger points to this.
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
-------- SPAWNFLAGS --------
LOOPED_ON : sound will loop and initially start on in level (will toggle on/off when triggered).
LOOPED_OFF : sound will loop and initially start off in level (will toggle on/off when triggered).
GLOBAL : sound will play full volume throughout the level.
ACTIVATOR : sound will play only for the player that activated the target.
-------- NOTES --------
The path portion value of the "noise" key can be replaced by the implicit folder character "*" for triggered sounds that belong to a particular player model. For example, if you want to create a "bottomless pit" in which the player screams and dies when he falls into, you would place a trigger_multiple over the floor of the pit and target a target_speaker with it. Then, you would set the "noise" key to "*falling1.wav". The * character means the current player model's sound folder. So if your current player model is Visor, * = sound/player/visor, if your current player model is Sarge, * = sound/player/sarge, etc. This cool feature provides an excellent way to create "player-specific" triggered sounds in your levels.

The combination of the "wait" and "random" keys can be used to play non-looping sounds without requiring an activating trigger but both keys must be used together. The value of the "random" key is used to calculate a minimum and a maximum delay. The final time delay will be a random value anywhere between the minimum and maximum values: (min delay = wait - random) (max delay = wait + random).
*/
void() target_speaker =
{
	precache_sound (self.noise);

	self.aflag = ATTN_NORM;
	if (self.spawnflags & Q3_GLOBAL) self.aflag = ATTN_NONE;

	self.use = q3_play_sound;

	if (self.flags & Q3_LOOPON)
	{
		ambientsound (self.origin, self.noise, 0.5, ATTN_STATIC);
//		loop_sound(self, CHAN_WEAPON,self.noise, 1, attn, 8.25, self.origin, 0, LOOPFOREVER); // FIX - want this for loopoff - problem is we need the sound length
	}
//	else if (self.flags & Q3_LOOPOFF) // TDO
//	{
//		ambientsound (self.origin, self.noise, 0.5, ATTN_STATIC);
//		loop_sound(self, CHAN_WEAPON,self.noise, 1, attn, 8.25, self.origin, 0, LOOPFOREVER);
//	}
	else if (self.wait)
	{
		self.think = q3_sound_think;
		self.nextthink = time + self.wait + 2 * crandom();
	}
};

// fn(q3trap_shooter_target) - finds target for q3 trap shooter if it has one, otherwise returns preset .movedir

vector() q3trap_shooter_target =
{
	local entity t;

// no target string
	if (self.target == "") return (self.movedir);

	t = find (world, targetname, self.target);
// target ent not found
	if (!t) return (self.movedir);
// found and targeted
	return (t.origin - self.origin);
};

// fn(q3_spikeshooter_use) - implement q3 shooters setup below

void() q3_spikeshooter_use =
{
	if (self.noise3 == "") self.noise3 = "weapons/spike2.wav";
	if (self.mdl == "") self.mdl = "progs/spike.mdl";
	if (self.delay < 100) self.delay = 500;

	sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
	launch_spike (self.origin, q3trap_shooter_target());
	newmis.velocity = self.movedir * self.delay;
	setmodel (newmis, self.mdl);

	if (self.classname == "shooter_grenade")
	{
		newmis.classname = "grenade";
		newmis.movetype = MOVETYPE_BOUNCE;
		newmis.touch = GrenadeTouch;
		newmis.nextthink = time + 2.5;
		newmis.think = GrenadeExplode;
	}
	else if (self.classname == "shooter_rocket")
	{
		newmis.classname = "rocket";
		newmis.touch = T_MissileTouch;
		newmis.nextthink = time + 5;
		newmis.think = GrenadeExplode;
	}
	else if (self.classname == "shooter_plasma")
	{
		newmis.classname = "plasma";
		newmis.touch = spike_touch;
		newmis.nextthink = time + 5;
		newmis.think = SUB_Remove;
	}
	else
		newmis.touch = superspike_touch;
	
};

// fn(q3trap_shooter) - implement any of the q3 shooter traps

void() spikeshooter_use;

void() q3trap_shooter =
{
	SetMovedir ();
	self.use = q3_spikeshooter_use;

	precache_model ("progs/spike.mdl");
	precache_sound ("weapons/spike2.wav"); // defaults to a nail shooter trap if its buf'd up
};

/*		q3 ---
	QUAKED shooter_grenade (1 0 .5) (-8 -8 -8) (8 8 8)
This will shoot a grenade each time it's triggered. Aiming is done by setting the "angles" key or by targeting an info_notnull or target_position entity.
-------- KEYS --------
angles: this sets the pitch and yaw aiming angles of shooter (default 0 0). The roll angle does not apply.
targetname : activating trigger points to this.
target : this points to a target_position entity for aiming the grenades.
random : random aiming variance in degrees from the straight line to the targeted entity (default 0 - see Notes).
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
-------- NOTES --------
When the random key is set, its value is used to calculate a maximum angle deviation from the normal trajectory formed by a straight line between the shooter and the aiming entity it targets. The final trajectory will be a random value anywhere between no deviation at all (0) to maximum deviation (value of the random key).

Both the setting "angles" key or "targeting a target_position" methods can be used to aim the shooter. However, the target_position method is simpler.*/

// TDO: q3 sounds | models, implement target

void() shooter_grenade =
{
	precache_model ("progs/grenade.mdl");
	precache_sound ("weapons/grenade.wav");
	precache_sound ("weapons/bounce.wav");
	q3trap_shooter();
	self.mdl = "progs/grenade.mdl";
	self.noise2 = "weapons/bounce.wav";
	self.noise3 = "weapons/grenade.wav";
	self.delay = 400;
};

/*QUAKED shooter_plasma (1 0 .5) (-8 -8 -8) (8 8 8)
*/

void() shooter_plasma =
{
	precache_model ("progs/lavaball.mdl"); // fix
	precache_sound ("q3_snd/hyprbf1a.wav");
	precache_sound ("q3_snd/plasmx1a.wav");
	q3trap_shooter();
	self.mdl = "progs/lavaball.mdl";
	self.noise2 = "q3_snd/plasmx1a.wav";
	self.noise3 = "q3_snd/hyprbf1a.wav";
	self.delay = 800;
};

/*QUAKED shooter_rocket (1 0 .5) (-8 -8 -8) (8 8 8)
*/

void() shooter_rocket =
{
	precache_model ("progs/missile.mdl");
	precache_sound ("weapons/sgun1.wav");
	q3trap_shooter();
	self.mdl = "progs/missile.mdl";
	self.noise3 = "weapons/sgun1.wav";
	self.delay = 1000;
};
