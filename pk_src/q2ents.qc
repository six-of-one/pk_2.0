/* ::-::
 *
 * Cataboligne
 *
 * file: q2ents.qc
 *
 * date: 6/27/10
 *
 * qc - support q2 stuff, converted maps
 *
 */

// q2 values
float Q2_DEF_HBOTTLE			= 2;
float Q2_DEF_HFIRSTAID		= 10;
float Q2_DEF_HMEDKIT			= 25;
float Q2_DEF_HMEGATUBE		= 100;

float Q2_ARM_TFLK				= 0.333;
float Q2_ARM_TCMB				= 0.6;
float Q2_ARM_TBDY				= 0.8;
float Q2_ARM_SHRD				= 2;
float Q2_ARM_FLAK				= 25;
float Q2_ARM_CMBT				= 50;
float Q2_ARM_BODY				= 100;

float Q2_DEF_SHELLS			= 10;		// small box
//float Q2_DEF_SHELLBOX		= 20;		// large box
float Q2_DEF_SHOTG			= 10;		// weapon def
//float Q2_DEF_BULLETS_CLIP	= 10;
float Q2_DEF_BULLETS_BOX	= 50;
float Q2_DEF_CHAING			= 50;
//float Q2_DEF_CELLBOX			= 100;
float Q2_DEF_CELLPAK			= 50;
float Q2_DEF_SLUGS			= 10;
float Q2_DEF_HYBERB			= 100;
float Q2_DEF_BFG				= 40;
float Q2_DEF_ROCKETS_LG		= 5;
float Q2_DEF_HGRN				= 5;
//float Q2_DEF_ROCKETS_SM		= 5;
float Q2_DEF_BLAST			= 5;

float Q2_BARREL_BLAST		= 150;

float Q2_POWER_WAIT		= 30;

void() q2_precache =
{
//	precache_model ("");
//	precache_sound ("");

// items
//	precache_model ("progs/.mdl");
// ammo
//	precache_model ("progs/q2_.mdl");
// weps
	precache_model ("progs/q2_bfg.mdl");
	precache_model ("progs/q2_chain.mdl");
	precache_model ("progs/q2_dblshot.mdl");
	precache_model ("progs/q2_gl.mdl");
	precache_model ("progs/q2_hyperb.mdl");
	precache_model ("progs/q2_mgun.mdl");
	precache_model ("progs/q2_rail.mdl");
	precache_model ("progs/q2_rocketl.mdl");
	precache_model ("progs/q2_shotgun.mdl");
	precache_model ("progs/q2_blaster.mdl");
// view models
	precache_model ("progs/v_q2_bfg.mdl");
	precache_model ("progs/v_q2_blst.mdl");
	precache_model ("progs/v_q2_chg.mdl");
	precache_model ("progs/v_q2_gl.mdl");
	precache_model ("progs/v_q2_hbl.mdl");
	precache_model ("progs/v_q2_mg.mdl");
	precache_model ("progs/v_q2_rail.mdl");
	precache_model ("progs/v_q2_rl.mdl");
	precache_model ("progs/v_q2_shot.mdl");
	precache_model ("progs/v_q2_shot2.mdl");
// viswep
	precache_model ("progs/vw_q2_bfg.mdl");
	precache_model ("progs/vw_q2_chg.mdl");
	precache_model ("progs/vw_q2_dblshot.mdl");
	precache_model ("progs/vw_q2_gl.mdl");
	precache_model ("progs/vw_q2_hbl.mdl");
	precache_model ("progs/vw_q2_mg.mdl");
	precache_model ("progs/vw_q2_rail.mdl");
	precache_model ("progs/vw_q2_rock.mdl");
	precache_model ("progs/vw_q2_shot.mdl");
// ammo
	precache_model ("progs/q2_cellbox.mdl");
	precache_model ("progs/q2_bullets.mdl");
	precache_model ("progs/q2_shells.mdl");
	precache_model ("progs/q2_rockets.mdl");
	precache_model ("progs/q2_slugs.mdl");
	precache_model ("progs/q2_grenades.mdl");
// heal
	precache_model ("progs/q2_heal_stimpak.mdl");
	precache_model ("progs/q2_heal_large.mdl");
	precache_model ("progs/q2_heal_medium.mdl");
	precache_model ("progs/q2_heal_mega.mdl");
//armor
	precache_model ("progs/q2_armorbody.mdl");
	precache_model ("progs/q2_armorcombat.mdl");
	precache_model ("progs/q2_armorjacket.mdl");
	precache_model ("progs/q2_armorshard.mdl");
	precache_model ("progs/q2_armorpower.mdl");
	precache_model ("progs/q2_armorscreen.mdl");
// items
	precache_model ("progs/q2_silencer.mdl");
	precache_model ("progs/q2_adrenaline.mdl");
	precache_model ("progs/q2_envirosuit.mdl");
	precache_model ("progs/q2_quad.mdl");
	precache_model ("progs/q2_inv.mdl");
	precache_model ("progs/q2_bando.mdl");
	precache_model ("progs/q2_pack.mdl");
	precache_model ("progs/q2_breather.mdl");
// keys
	precache_model ("progs/q2_keypyramid.mdl");
	precache_model ("progs/q2_keypower.mdl");
	precache_model ("progs/q2_keypass.mdl");
	precache_model ("progs/q2_keycd.mdl");
	precache_model ("progs/q2_keyspinner.mdl");
	precache_model ("progs/q2_keytarget.mdl");
	precache_model ("progs/q2_keyrb.mdl");
	precache_model ("progs/q2_key_cmd_head.mdl");

	precache_model ("progs/q2_barrel.mdl");

// sounds
	precache_sound ("q2_snd/w_pkup.wav");
	precache_sound ("q2_snd/am_pkup.wav");
	precache_sound ("q2_snd/respawn1.wav");

//	precache_sound ("q2/.wav");
// weps
	precache_sound ("q2_snd/grnf_mx.wav");
	precache_sound ("q2_snd/rktf_mx.wav");

};


void() q2_ammo_bullets =
{
	item_spikes();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_BULLETS;
	self.currentammo = Q2_DEF_BULLETS_BOX;

	self.classname = "ammo_bullets";
	setmodel (self, "progs/q2_bullets.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Box of bullets";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_ammo_rockets =
{
	item_rockets();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_ROCKETS;
	self.currentammo = Q2_DEF_ROCKETS_LG;

	setmodel (self, "progs/q2_rockets.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Box of Rockets";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};


void() q2_ammo_shells =
{
	item_shells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_SHELLS;
	self.currentammo = Q2_DEF_SHELLS;

	setmodel (self, "progs/q2_shells.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Box of Shells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_ammo_cells =
{
	item_cells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_CELLS;
	self.currentammo = Q2_DEF_CELLPAK;

	setmodel (self, "progs/q2_cellbox.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Box of cells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_ammo_slugs =
{
	item_cells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_SLUGS;
	self.currentammo = Q2_DEF_SLUGS;

	setmodel (self, "progs/q2_slugs.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Box of slugs";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_ammo_grenades =
{
	item_rockets();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_GRENADES;
	self.currentammo = Q2_DEF_HGRN;

	setmodel (self, "progs/q2_grenades.mdl");
	self.noise = "q2_snd/am_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Grenades";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

// anything with another genre classname (weapon_bfg - q3) has q2_ prepended

/*QUAKED q2_weapon_bfg (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () q2_weapon_bfg =
{
	weapon_lightning();

	setmodel (self, "progs/q2_bfg.mdl");
	self.weaponmodel = "progs/v_q2_bfg.mdl";
	self.vwepmdl = "progs/vw_q2_bfg.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
//	self.noise3 = "q2_snd/dsrlaunc.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () q2_weapon_railgun =
{
	weapon_lightning();

	setmodel (self, "progs/q2_rail.mdl");
	self.weaponmodel = "progs/v_q2_rail.mdl";
	self.vwepmdl = "progs/vw_q2_rail.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
//	self.noise3 = "q2_snd/dsrlaunc.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () weapon_hyperblaster =
{
	weapon_lightning();

	setmodel (self, "progs/q2_hyperb.mdl");
	self.weaponmodel = "progs/v_q2_hbl.mdl";
	self.vwepmdl = "progs/vw_q2_hbl.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
//	self.noise3 = "q2_snd/dsrlaunc.wav";
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_weapon_rocketlauncher =
{
	q100_weapon_rocketlauncher();

// fn
	self.touch = d_weapon_touch;
	self._attack = W_FireRocket;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = Q2_DEF_BLAST;
	self.items = IT_ROCKET_LAUNCHER;
	self.lip = AMMO_ROCKETS;
	self.attack_finished = 1.25;
	self.dmg = 100;
	self.dodmg = 120; // splash
	self.dmg_save = 1;

// appearances
	setmodel (self, "progs/q2_rocketl.mdl");
	self.weaponmodel = "progs/v_q2_rl.mdl";
	self.vwepmdl = "progs/vw_q2_rock.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/rktf_mx.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () q2_weapon_grenadelauncher =
{
	q100_weapon_grenadelauncher();

// fn
	self.touch = d_weapon_touch;
	self._attack = W_FireGrenade;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = Q2_DEF_BLAST;
	self.items = IT_GRENADE_LAUNCHER;
	self.lip = AMMO_ROCKETS;
	self.attack_finished = 0.9;
	self.dmg = 120;
	self.dodmg = 160; // splash
	self.dmg_save = 1;

// appearances
	setmodel (self, "progs/q2_gl.mdl");
	self.weaponmodel = "progs/v_q2_gl.mdl";
	self.vwepmdl = "progs/vw_q2_gl.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.noise3 = "q2_snd/grnf_mx.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () weapon_chaingun =
{
	weapon_supernailgun();

	setmodel (self, "progs/q2_chain.mdl");
	self.weaponmodel = "progs/v_q2_chg.mdl";
	self.vwepmdl = "progs/vw_q2_chg.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
//	self.noise3 = "q2_snd/dsrlaunc.wav";
	if (self.class_select == "") self.class_select = "q2_item";
};

void () q2_weapon_machinegun =
{
	weapon_nailgun();

	setmodel (self, "progs/q2_mgun.mdl");
	self.weaponmodel = "progs/v_q2_mg.mdl";
	self.vwepmdl = "progs/vw_q2_mg.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
//	self.noise3 = "q2_snd/dsrlaunc.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () q2_weapon_supershotgun =
{
	weapon_supershotgun();

	setmodel (self, "progs/q2_dblshot.mdl");
	self.weaponmodel = "progs/v_q2_shot2.mdl";
	self.vwepmdl = "progs/vw_q2_dblshot.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
//	self.noise3 = "q2_snd/dsrlaunc.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () q2_weapon_shotgun =
{
	weapon_shotgun();

	setmodel (self, "progs/q2_shotgun.mdl");
	self.weaponmodel = "progs/v_q2_shot.mdl";
	self.vwepmdl = "progs/vw_q2_shot.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
//	self.noise3 = "q2_snd/dsrlaunc.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void () q2_weapon_blaster =
{
	weapon_shotgun();

	setmodel (self, "progs/q2_blaster.mdl");
	self.weaponmodel = "progs/v_q2_blst.mdl";
//	self.vwepmdl = "progs/vw_q2_blst.mdl";
	self.noise = "q2_snd/w_pkup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
//	self.noise3 = "q2_snd/dsrlaunc.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};


void() q2_item_health_small =
{
	item_health();
	setmodel(self, "progs/q2_heal_stimpak.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav"; // doom respawn sound
	self.netname = "Stimpack";
	self.healamount = Q2_DEF_HBOTTLE;
	self.healtype = HEAL_BOT;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_health =
{
	item_health();
	setmodel(self, "progs/q2_heal_medium.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "First Aid";
	self.healamount = Q2_DEF_HFIRSTAID;
//	self.healtype = HEAL_NORM;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_health_large =
{
	item_health();
	setmodel(self, "progs/q2_heal_large.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Medkit";
	self.healamount = Q2_DEF_HMEDKIT;
//	self.healtype = HEAL_NORM;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_health_mega =
{
	item_health();
	setmodel(self, "progs/q2_heal_mega.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Medkit";
	self.healamount = Q2_DEF_HMEGATUBE;
//	self.healtype = HEAL_NORM;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_misc_explobox =
{
	self.netname = "Barrel";
	misc_explodbox_set(self, "progs/q2_barrel.mdl", Q2_BARREL_BLAST, 80, MOVETYPE_NONE);
//	self.noise = "doom/dsbarexp.wav";
	self.noise4 = "q2_snd/respawn1.wav";
//	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_armor_body =
{
	item_armorInv();
	setmodel (self, "progs/q2_armorbody.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Body armor";
	self.volume = 200; // max add
	self.state = Q2_ARM_TBDY;
	self.currentammo = Q2_ARM_BODY; // 100 units
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_armor_combat =
{
	item_armor2();
	setmodel (self, "progs/q2_armorcombat.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Combat armor";
	self.volume = 100; // max add
	self.state = Q2_ARM_TCMB;
	self.currentammo = Q2_ARM_CMBT; // 50 units
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_armor_jacket =
{
	item_armor1();
	setmodel (self, "progs/q2_armorjacket.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Jacket armor";
	self.volume = 50; // max add
	self.state = Q2_ARM_TFLK;
	self.currentammo = Q2_ARM_FLAK; // 25 units
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_armor_shard =
{
	item_armor1();
	setmodel (self, "progs/q2_armorshard.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Armor shard";
	self.volume = -1; // max add
	self.state = Q2_ARM_TFLK;
	self.currentammo = Q2_ARM_SHRD; // 2 units
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_power_shield =
{
	item_armor1();
	setmodel (self, "progs/q2_armorpower.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Power shield";
	self.volume = -1;
	self.state = 0;
	self.currentammo = 0;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_power_screen =
{
	item_armor1();
	setmodel (self, "progs/q2_armorscreen.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Power screen";
	self.volume = -1;
	self.state = 0;
	self.currentammo = 0;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_silencer =
{
	weapon_shotgun();
	setmodel (self, "progs/q2_silencer.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Silencer";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};


void() item_invulnerability =
{
	item_artifact_invulnerability();
	self.noise = "doom/dsgetpow.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	setmodel (self, "progs/q2_inv.mdl");
	self.netname = "Invulnerability";
	self.wait = Q2_POWER_WAIT;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_enviro =
{
	item_artifact_envirosuit();
	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/q2_envirosuit.mdl");
	self.delay = POW_TIME;
	self.netname = "Environmental Suit";
	self.wait = D_POWER_WAIT;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() q2_item_quad =
{
	item_artifact_super_damage();
	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/q2_quad.mdl");
	self.delay = POW_TIME;
	self.netname = "Quad Damage";
	self.wait = D_POWER_WAIT;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_adrenaline =
{
	item_health();
	setmodel(self, "progs/q2_adrenaline.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Adrenaline";
	self.healamount = Q2_DEF_HMEGATUBE;
//	self.healtype = HEAL_NORM;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_bandolier =
{
	item_spikes();
	setmodel(self, "progs/q2_bando.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Bandolier";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_pack =
{
	item_spikes();
	setmodel(self, "progs/q2_pack.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Ammo Pack";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() item_breather =
{
	item_spikes();
	setmodel(self, "progs/q2_breather.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Re-breather";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_pyramid =
{
	item_key1();
	setmodel(self, "progs/q2_keypyramid.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Pyramid Key";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_power_cube =
{
	item_key1();
	setmodel(self, "progs/q2_keypower.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Power Cube";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_pass =
{
	item_key1();
	setmodel(self, "progs/q2_keypass.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Pass Key";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_data_cd =
{
	item_key1();
	setmodel(self, "progs/q2_keycd.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Data CD";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_data_spinner =
{
	item_key1();
	setmodel(self, "progs/q2_keyspinner.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Data Spinner";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_airstrike_target =
{
	item_key1();
	setmodel(self, "progs/q2_keytarget.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Airstrike Target";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_blue_key =
{
	item_key1();
	setmodel(self, "progs/q2_keyrb.mdl");
	self.skin = 1;
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Blue Key";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_red_key =
{
	item_key1();
	setmodel(self, "progs/q2_keyrb.mdl");
	self.skin = 0;
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Red Key";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};

void() key_commander_head =
{
	item_key1();
	setmodel(self, "progs/q2_key_cmd_head.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "q2_snd/respawn1.wav";
	self.netname = "Commanders Head";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "q2_item";
};
