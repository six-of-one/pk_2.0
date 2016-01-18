/*
		+---------------------------------------+
		|  Doom specific code                   | SEC-HEAD
		+---------------------------------------+
*/
// map item indiv reposition codes

float HEAL_BOT					= 4; // doom health bottle - ignore normal max, no rot
float HEAL_SOUL				= 5; // doom health: soul, mega spheres - 200 max, no rot

float ARM_SPIRIT				= 1; // doom spirit armor

// doom values
float D_DEF_HBOTTLE			= 1;
float D_DEF_HSTIMPAK			= 10;
float D_DEF_HMEDKIT			= 25;
float D_DEF_SOULSPH			= 100;
float D_SOUL_MAX				= 200; // soul, mega max health

float D_ARM_TGRN				= 0.333;
float D_ARM_TBLU				= 0.5;
float D_ARM_BLUE				= 200;

float D_DEF_SHELLS			= 4;		// small box
float D_DEF_SHELLBOX			= 20;		// large box
float D_DEF_SHOTG				= 8;		// weapon def
float D_DEF_BULLETS_CLIP	= 10;
float D_DEF_BULLETS_BOX		= 50;
float D_DEF_CHAING			= 20;
float D_DEF_CELLBOX			= 100;
float D_DEF_CELLPAK			= 20;
float D_DEF_PLASMAG			= 40;
float D_DEF_BFG				= 40;
float D_DEF_ROCKETS_LG		= 5;
float D_DEF_ROCKETS_SM		= 1;
float D_DEF_BLAST				= 2;

float D_BARREL_BLAST			= 128;

float D_POWER_WAIT			= 60; // seconds major doom powers need to respawn

float d_reps_base				= 57005000; // heh heh - DEAD+
void() d_rep_set;
float() mega_touch;
void() d_weapon_touch;

void() doom_precache =
{
//	precache_model ("");
//	precache_sound ("");

// items
	precache_model ("progs/barrel.mdl");
	precache_model ("progs/heal_bottle.mdl");
	precache_model ("progs/heal_medkit.mdl");
	precache_model ("progs/heal_stimpak.mdl");
	precache_model ("progs/spiritarmor.mdl");
	precache_model ("progs/d_spheres.mdl");
	precache_model ("progs/d_radsuit.mdl");
	precache_model ("progs/d_skullkey.mdl");
	precache_model ("progs/d_cardkey.mdl");
	precache_model ("progs/d_armor.mdl");
// ammo
	precache_model ("progs/d_4shell.mdl");
	precache_model ("progs/d_ammobox.mdl");
	precache_model ("progs/d_clip.mdl");
	precache_model ("progs/d_rockbox.mdl");
	precache_model ("progs/d_1rocket.mdl");
	precache_model ("progs/d_shellbox.mdl");
	precache_model ("progs/d_cellbox.mdl");
	precache_model ("progs/d_cellpack.mdl");
// doom weps
	precache_model ("progs/d_pistol.mdl");
	precache_model ("progs/d_bfg.mdl");
	precache_model ("progs/d_rock.mdl");
	precache_model ("progs/d_plasma.mdl");
	precache_model ("progs/d_chaingun.mdl");
	precache_model ("progs/d_shotgun.mdl");
	precache_model ("progs/d_dblshot.mdl");
// view models
	precache_model ("progs/v_d_pistol.mdl");
	precache_model ("progs/v_d_shot.mdl");
	precache_model ("progs/v_d_dblshot.mdl");
	precache_model ("progs/v_d_chg.mdl");
	precache_model ("progs/v_d_plasma.mdl");
	precache_model ("progs/v_d_rock.mdl");
// viswep
	precache_model ("progs/vw_d_saw.mdl");
	precache_model ("progs/vw_d_pistol.mdl");
	precache_model ("progs/vw_d_shot.mdl");
	precache_model ("progs/vw_d_dblshot.mdl");
	precache_model ("progs/vw_d_chaing.mdl");
	precache_model ("progs/vw_d_rock.mdl");
	precache_model ("progs/vw_d_plasma.mdl");
	precache_model ("progs/vw_d_bfg.mdl");
// wolfenstien
	precache_model ("progs/w_armor.mdl");
	precache_model ("progs/w_knife.mdl"); // NOTE: this a map item
	precache_model ("progs/w_pistol.mdl"); // NOTE: this a map item
	precache_model ("progs/w_mgun.mdl");
	precache_model ("progs/w_chaing.mdl");
	precache_model ("progs/w_mortar.mdl");
	precache_model ("progs/w_flamer.mdl");

	precache_model ("progs/vw_w_knife.mdl"); // NOTE: this a map item
	precache_model ("progs/vw_w_pistol.mdl");
	precache_model ("progs/vw_w_mgun.mdl");
	precache_model ("progs/vw_w_chaing.mdl");
	precache_model ("progs/vw_w_mortar.mdl");
	precache_model ("progs/vw_w_flamer.mdl");

//	precache_model ("progs/v_w_knife.mdl");
	precache_model ("progs/v_w_pistol.mdl");
	precache_model ("progs/v_w_mgun.mdl");
	precache_model ("progs/v_w_chg.mdl");
	precache_model ("progs/v_w_mortar.mdl");
	precache_model ("progs/v_w_flamer.mdl");

// sounds
	precache_sound ("doom/dsbarexp.wav");
	precache_sound ("doom/dsitemup.wav");
	precache_sound ("doom/dsitembk.wav");
	precache_sound ("doom/dswpnup.wav");
	precache_sound ("doom/dsgetpow.wav");
	precache_sound ("doom/dsdorcls.wav");
	precache_sound ("doom/dsdoropn.wav");
	precache_sound ("doom/dsbdcls.wav");
	precache_sound ("doom/dsbdopn.wav");
	precache_sound ("doom/dspstart.wav");
	precache_sound ("doom/dspstop.wav");
	precache_sound ("doom/gibs.wav");
// weps
	precache_sound ("doom/dsrlaunc.wav");
	precache_sound ("doom/dspistol.wav");
	precache_sound ("doom/dsshotgn.wav");
	precache_sound ("doom/dsdshtgn.wav");
	precache_sound ("doom/dsplasma.wav");
	precache_sound ("doom/dsfirxpl.wav");
//	precache_sound ("doom/d_f_chg.wav");
// wolf
	precache_sound ("wolf/w_knife.wav");
	precache_sound ("wolf/w_pistol.wav");
	precache_sound ("wolf/w_mg.wav");
	precache_sound ("wolf/w_chg.wav");
	precache_sound ("wolf/w_mortar.wav");
	precache_sound ("wolf/pickup_am.wav");
	precache_sound ("wolf/pickup_gn.wav");
	precache_sound ("wolf/pickup_gdy.wav");
	precache_sound ("wolf/door_opn.wav");
	precache_sound ("wolf/door_cls.wav");


};

/*
		+---------------------------------------+
		|  Map code - Doom                     | SEC-HEAD
		+---------------------------------------+
*/

void() item_health;
/*
NOTE: this code assumes the translation of doom map entites to quake style definitions in the map file by some device or code...

 uses ypod models for now - may recraft many of these...at least the easy ones

*/


void() d_item_healthbottle =
{
	item_health();
	setmodel(self, "progs/heal_bottle.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav"; // doom respawn sound
	self.netname = "Health potion";
	self.healamount = D_DEF_HBOTTLE;
	self.healtype = HEAL_BOT;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	self.alpha = 0.8;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_healthmedkit =
{
	item_health();
	setmodel(self, "progs/heal_medkit.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Health Medikit";
	self.healamount = D_DEF_HMEDKIT;
//	self.healtype = HEAL_NORM;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_healthstimpak =
{
	item_health();
	setmodel(self, "progs/heal_stimpak.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Health Stimpak";
	self.healamount = D_DEF_HSTIMPAK;
//	self.healtype = HEAL_NORM;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_spiritarmor =
{
	item_armor2();
	setmodel (self, "progs/spiritarmor.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Spirit armor";
	self.skin = 0;
	self.state = D_ARM_TBLU;
	self.currentammo = ARM_SPIRIT;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

// FIX - different damage handling than q1 armors
void() d_item_armorgreen =
{
	item_armor1();
	setmodel (self, "progs/d_armor.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Security armor";
	self.state = D_ARM_TGRN;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_armorblue =
{
	item_armor2();
	setmodel (self, "progs/d_armor.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Combat armor";
	self.state = D_ARM_TBLU;
	self.currentammo = D_ARM_BLUE; // 200 units
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_ammobox =
{
	item_spikes();

	setmodel (self, "progs/d_ammobox.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of bullets";
	self.currentammo = D_DEF_BULLETS_BOX;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_clip =
{
	item_spikes();
	setmodel (self, "progs/d_clip.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "A clip";
	self.currentammo = D_DEF_BULLETS_CLIP;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_1rocket =
{
	item_rockets();
	setmodel (self, "progs/d_1rocket.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Rocket";
	self.currentammo = D_DEF_ROCKETS_SM;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_rockbox =
{
	item_rockets();
	setmodel (self, "progs/d_rockbox.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of Rockets";
	self.currentammo = D_DEF_ROCKETS_LG;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_4shell =
{
	item_shells();
	setmodel (self, "progs/d_4shell.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "4 shells";
	self.currentammo = D_DEF_SHELLS;
//	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_shellbox =
{
	item_shells();
	setmodel (self, "progs/d_shellbox.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of Shells";
	self.currentammo = D_DEF_SHELLBOX;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_cellbox =
{
	item_cells();
	setmodel (self, "progs/d_cellbox.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of cells";
	self.currentammo = D_DEF_CELLBOX;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_cellpack =
{
	item_cells();
	setmodel (self, "progs/d_cellpack.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Cells";
	self.currentammo = D_DEF_CELLPAK;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_barrel =
{
	self.noise = "doom/dsbarexp.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Barrel";
	misc_explodbox_set(self, "progs/barrel.mdl", D_BARREL_BLAST + random() * 8, 20, MOVETYPE_NONE);
	self.health = 20 + random() * 15; // heh heh
//	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_bfg =
{
	weapon_lightning();
	self.netname = "BFG 9000";

	setmodel (self, "progs/d_bfg.mdl");
//	self.weaponmodel = "progs/v_d_bfg.mdl";
	self.vwepmdl = "progs/vw_d_bfg.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.currentammo = D_DEF_BFG;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_rocketlauncher =
{
	weapon_rocketlauncher();

// fn
	self.touch = d_weapon_touch;
	self._attack = W_FireRocket;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = D_DEF_BLAST;
	self.items = IT_ROCKET_LAUNCHER;
	self.weaponframe = AMMO_ROCKETS;
	self.attack_finished = 0.6;
	self.dmg = 120;
	self.dmg_save = 1;

// appearances
	setmodel (self, "progs/d_rock.mdl");
	self.weaponmodel = "progs/v_d_rock.mdl";
	self.vwepmdl = "progs/vw_d_rock.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "doom/dsrlaunc.wav";
	self.noise4 = "doom/dsitembk.wav";
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_chaingun =
{
	d_rep_set();
	weapon_supernailgun();
	self.netname = "Chain Gun";

//TEST
//	setmodel (self, "progs/q2_chg.mdl");
//	self.weaponmodel = "progs/v_q2_chg.mdl";
	self.vwepmdl = "progs/vw_q2_chg.mdl";
//	self.noise3 = "q2/q2_chg_fire.wav";

	setmodel (self, "progs/d_chaingun.mdl");
	self.weaponmodel = "progs/v_d_chg.mdl";
	self.vwepmdl = "progs/vw_d_chaing.mdl";
	self.noise3 = "doom/d_f_chg.wav";
	self.noise3 = "doom/dspistol.wav";
	self.noise = "doom/dswpnup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.currentammo = D_DEF_CHAING;
	self.effects = self.effects | EF_FULLBRIGHT;
//	self._attack = player_dchg1;
	self.attack_finished = 0.11;
	self.punchangle = ' 0.065 0.065 0'; // bullet spread out
//	self.mask_x = CB_HUMAN | CB_GREMLIN | CB_SPEC;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_pistol =
{
//	d_rep_set();
	weapon_nailgun();
	self.netname = "Pistol";

	setmodel (self, "progs/d_pistol.mdl");
	self.weaponmodel = "progs/v_d_pistol.mdl";
	self.vwepmdl = "progs/vw_d_pistol.mdl";
	self.noise3 = "doom/dspistol.wav";
	self.noise = "doom/dswpnup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.currentammo = 25;
	self.effects = self.effects | EF_FULLBRIGHT;
//	self._attack = player_dchg1;
	self.attack_finished = 0.4;
	self.punchangle = ' 0.01 0.01 0'; // bullet spread out
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_saw =
{
//	d_rep_set();
	weapon_nailgun();
	self.netname = "Chainsaw";

	setmodel (self, "progs/d_chainsaw.mdl");
	self.weaponmodel = "progs/v_d_saw.mdl";
	self.vwepmdl = "progs/vw_d_saw.mdl";
//	self.noise3 = "doom/dssaw.wav";
	self.noise = "doom/dswpnup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.currentammo = 1;
	self.effects = self.effects | EF_FULLBRIGHT;
//	self._attack = player_dchg1;
	self.attack_finished = 0.25;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_shotgun =
{
	d_rep_set();
	weapon_shotgun();

	self.touch = d_weapon_touch;
	self._attack = W_FireShotgun;
	self._fr_attack = player_shot1;

	self.currentammo = D_DEF_SHOTG;
	self.items = IT_SHOTGUN;
	self.weaponframe = AMMO_SHELLS;
	self.attack_finished = 1;
	self.dmg = 10;
	self.dmg_save = 1;
	self.punchangle = ' 0.04 0.04 0'; // bullet spread out -- TDO: get doom value, this is q1

	setmodel (self, "progs/d_shotgun.mdl");
	self.weaponmodel = "progs/v_d_shot.mdl";
	self.vwepmdl = "progs/vw_d_shot.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "doom/dsshotgn.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_supershotgun =
{
	weapon_supershotgun();
	self.netname = "Super shotgun";

	self.touch = d_weapon_touch;
	self._attack = W_FireSuperShotgun;
	self._fr_attack = player_shot1;

	self.currentammo = D_DEF_SHOTG;
	self.items = IT_SUPER_SHOTGUN;
	self.weaponframe = AMMO_SHELLS;
	self.attack_finished = 1.6667;
	self.dmg = 10;
	self.dmg_save = 2;
	self.punchangle = ' 0.14 0.08 0'; // bullet spread out -- TDO: get doom value, this is q1

	setmodel (self, "progs/d_dblshot.mdl");
	self.weaponmodel = "progs/v_d_dblshot.mdl";
	self.vwepmdl = "progs/vw_d_dblshot.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "doom/dsdshtgn.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};


void() d_weapon_plasma =
{
	weapon_lightning();
	self.netname = "Plasma Gun";

	setmodel (self, "progs/d_plasma.mdl");
	self.weaponmodel = "progs/v_d_plasma.mdl";
	self.vwepmdl = "progs/vw_d_plasma.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "doom/dsplasma.wav";
	self.noise4 = "doom/dsitembk.wav";

	self.aflag = 5;
	self.attack_finished = 0.083;
//	self._attack = player_dplasma1;
//	self._hk_major = SUB_Null;
//	self.pull = W_gPull;
//	self.th_walk = SUB_Null;
//	self.dmg_save = 1;
//	self.deathtype = " was melted by ";
//	self.deathtype2 = "'s plasma\n";
//	self.upgrade_mc = MC_BOMB;
//	self.mode_x = IV_POSITRON;

	self.currentammo = D_DEF_PLASMAG;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

// FIX - need correct sphere sounds

void() d_art_soulsphere =
{
	item_health();
	setmodel(self, "progs/d_spheres.mdl");
	self.noise = "doom/dsgetpow.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Soul Sphere";
	self.healamount = D_DEF_SOULSPH;
	self.healtype = HEAL_SOUL;
	self.wait = D_POWER_WAIT;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_art_megasphere =
{
// armor
	d_item_armorblue();
	setmodel(self, "progs/d_spheres.mdl");
	self.skin = 1;
	self.noise = "doom/dsgetpow.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Mega Sphere";
	self.touch = mega_touch;
// heal
	self.healamount = D_DEF_SOULSPH;
	self.healtype = HEAL_SOUL;
	self.wait = D_POWER_WAIT;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_art_invulnerable =
{
	item_artifact_invulnerability();
	self.noise = "doom/dsgetpow.wav";
	self.noise4 = "doom/dsitembk.wav";
	setmodel (self, "progs/d_spheres.mdl");
	self.skin = 2;
	self.netname = "Invulnerability";
	self.wait = D_POWER_WAIT;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_art_invisible =
{
	item_artifact_invisibility();
	self.noise = "doom/dsgetpow.wav";
	self.noise4 = "doom/dsitembk.wav";
	setmodel (self, "progs/d_spheres.mdl");
	self.skin = 3;
	self.netname = "Invisibilty";
	self.wait = D_POWER_WAIT;
	self.delay = POW_TIME; // usage time
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_art_radsuit =
{
	item_artifact_envirosuit();
	self.noise = "doom/dsitemup.wav"; // radsuit finish sounds, proper op
	setmodel (self, "progs/d_radsuit.mdl");
	self.delay = POW_TIME;
	self.netname = "Radiation Suit";
	self.wait = D_POWER_WAIT;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

// use spawnflags to make one of 6 keys...
void() d_key_redskull =
{
	item_key1();

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_skullkey.mdl");
//	self.skin = 0;
	self.netname = "Red Skull key";
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_blueskull =
{
	item_key2();

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_skullkey.mdl");
	self.skin = 1;
	self.netname = "Blue Skull key";
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_yellowskull =
{
	item_key2();

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_skullkey.mdl");
	self.skin = 2;
	self.netname = "Yellow Skull key";
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_redcard =
{
	item_key1();

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_cardkey.mdl");
//	self.skin = 0;
	self.netname = "Red card key";
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_bluecard =
{
	item_key2();

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_cardkey.mdl");
	self.skin = 1;
	self.netname = "Blue card key";
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_yellowcard =
{
	item_key2();

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_cardkey.mdl");
	self.skin = 2;
	self.netname = "Yellow card key";
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
	if (self.class_select == "") self.class_select = "doom_item";
};

/*
		+---------------------------------------+
		|  Map code - Wolfenstien               | SEC-HEAD
		+---------------------------------------+
*/

/*
NOTE: this code assumes the translation of wolf map entites to quake style definitions in the map file by some device or code...

NOTE: there is no entites file for wolf in the style of QUAKED
*/

void() w_weapon_machinegun =
{
	weapon_nailgun();

	self.netname = "Machine Gun";

	setmodel (self, "progs/w_mgun.mdl");
	self.weaponmodel = "progs/v_w_mgun.mdl";
	self.vwepmdl = "progs/vw_w_mgun.mdl";
	self.noise3 = "wolf/w_mg.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.currentammo = D_DEF_CHAING; // FIX FIX
	self.effects = self.effects | EF_FULLBRIGHT;
	self.attack_finished = 0.16667;
	self.punchangle = ' 0.02 0.02 0'; // bullet spread out
//	self._attack = player_dchg1;
//	self._hk_major = SUB_Null;
//	self.mode_x = IV_NAILGUN;
//	self.mask_x = CB_HUMAN | CB_GREMLIN | CB_SPEC;

	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_weapon_chaingun =
{
	d_rep_set();
	weapon_nailgun();

	self.netname = "Chain Gun";

	setmodel (self, "progs/w_chaing.mdl");
	self.weaponmodel = "progs/v_w_chg.mdl";
	self.vwepmdl = "progs/vw_w_chaing.mdl";
	self.noise3 = "wolf/w_chg.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.currentammo = D_DEF_CHAING;
	self.effects = self.effects | EF_FULLBRIGHT;
	self.attack_finished = 0.087;
	self.punchangle = ' 0.065 0.065 0'; // bullet spread out
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_fire_motar =
{
	W_FireGrenade();

	newmis.touch = T_MissileTouch;
	newmis.velocity = newmis.velocity * 1.8;
};

void() w_weapon_mortar =
{
	weapon_rocketlauncher();

// fn
	self.touch = d_weapon_touch;
	self._attack = w_fire_motar;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = 5; // W_DEF_BLAST;
	self.items = IT_ROCKET_LAUNCHER;
	self.weaponframe = AMMO_ROCKETS;
	self.attack_finished = 0.8;
	self.dmg = 120;
	self.dmg_save = 1;
// appearances
	self.netname = "Mortar";
	setmodel (self, "progs/w_mortar.mdl");
	self.weaponmodel = "progs/v_w_mortar.mdl";
	self.vwepmdl = "progs/vw_w_mortar.mdl";
	self.noise = "wolf/pickup_gn.wav";
	self.noise3 = "wolf/w_mortar.wav";
	self.noise4 = "doom/dsitembk.wav";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_weapon_flamer =
{
	weapon_grenadelauncher();

	self.netname = "Flame Thrower";
	setmodel (self, "progs/w_flamer.mdl");
	self.weaponmodel = "progs/v_w_flamer.mdl";
	self.vwepmdl = "progs/vw_w_flamer.mdl";
//	self.noise3 = "wolf/w_mg.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise3 = "doom/dsrlaunc.wav";
	self.noise4 = "doom/dsitembk.wav";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_weapon_pistol =
{
	weapon_nailgun();

	self.currentammo = 25;
	self.attack_finished = 0.465; // 2.15 per

	self.netname = "Luger Pistol";
	setmodel (self, "progs/w_pistol.mdl");
	self.weaponmodel = "progs/v_w_pistol.mdl";
	self.vwepmdl = "progs/vw_w_pistol.mdl";
	self.noise3 = "wolf/w_pistol.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise4 = "doom/dsitembk.wav";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_weapon_knife =
{
	weapon_axe();

	self.attack_finished = 0.465; // 2.15 per

	self.netname = "Knife";
	setmodel (self, "progs/w_knife.mdl");
	self.weaponmodel = ""; //progs/v_w_knife.mdl";
	self.vwepmdl = "progs/vw_w_knife.mdl";
	self.noise = "wolf/pickup_gn.wav";
	self.noise3 = "wolf/w_knife.wav";
	self.noise4 = "doom/dsitembk.wav";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

// code to run doom ents


//fn(d_thk_reps) - some guns wont appear in map if in correct position - have to load elsewhere and move later

void () d_thk_reps =
{
	local entity t;

	t = find (world, targetname, self.owner.target);
	if (t)
	{
		setorigin(self.owner, t.origin);
		self.owner.oldorigin = t.origin;
		self.owner.ip_orgOrigin = t.origin;
	}
	remove(self);
};

void() d_rep_set =
{
	if (self.delay == d_reps_base)
	{
		local entity e;
		e = spawn();
		e.think = d_thk_reps;
		e.nextthink = time + 2;
		e.classname = "d_reps";
		e.owner = self;
	}
};

float() mega_touch =
{
//	health_touch();
//	armor_touch();

	local float arm, hl;
	arm = hl = 1;

// supply armor
	if (other.armorvalue < self.currentammo)
	{
			arm = 0; // got armor portion of mega sphere
			other.armortype = self.state;
			other.armorvalue = self.currentammo;
			other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + self.items;
		
	}

// supply health
	if (T_Heal(other, self.healamount, 1))
	{
		if (self.healtype == HEAL_SOUL)
		if (other.health >= D_SOUL_MAX) // * other.health_modifier)
			other.health = D_SOUL_MAX; // * other.health_modifier;
	hl = 0;
	}

	return(arm & hl);
};

void() d_weapon_touch =
{
	local	float best, new, oldw, camc;
	local	entity e;
	local float leave;

	if (other.classname != "player") // *bot
	{
		grap_checkIfGrap();
		return ;
	}

// if the player was using his best weapon, change up to the new one if better
	e = self;
	self = other;
	best = W_BestWeapon ();
	self = e;

	if (deathmatch == 2 || deathmatch == 3 || coop)
		leave = 1;
	else
		leave = 0;

// IDEA - always leave for another rl type
	if (leave && (other.items & self.items))	return ;
	new = self.items;

	if (self.classname == "d_weapon_rocketlauncher" || self.classname == "w_weapon_mortar")
	{
	other.ammo_rockets = other.ammo_rockets + self.currentammo; // TDO: ammo type fn
	camc = other.ammo_rockets;
	}
	else if (self.classname == "d_weapon_shotgun" || self.classname == "d_weapon_supershotgun")
	{
	other.ammo_shells = other.ammo_shells + self.currentammo; // TDO: ammo type fn
	camc = other.ammo_shells;
	}
	else
	{
		if (PK_100 && PK_100_OBJERR) objerror("d_weapon_touch: unknown classname");
		else
		{
			if (WARNING)
			{
			bprint("\n*** warning:\nd_weapon_touch: unknown classname (");
			bprint(self.classname);
			bprint(") - ignoring\n\n");
			}
			self.touch = SUB_Null;
			return;
		}
	}

	if (!vchk(new, 0, other.vwepent))
	{
		e = vload(other, new);
		e.eweapon = e;
		e._attack = self._attack;
		e._fr_attack = self._fr_attack;
//		e.touch = self.touch;

		e.weapon = e.items = self.items;
		e.currentammo = self.currentammo;
		e.weaponframe = self.weaponframe;
		e.attack_finished = self.attack_finished;
		e.dmg = self.dmg;
		e.dmg_save = self.dmg_save;
		e.aflag = camc;

		e.netname = self.netname;
//		e.mdl = self.mdl; - invisible
		setmodel (e, self.vwepmdl);
		e.mdl = e.model;
		e.weaponmodel = self.weaponmodel;
		e.noise3 = self.noise3;
		e.noise = self.noise;
		e.noise4 = self.noise4;
	}

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");
// weapon touch sound
	if (self.noise != "")
		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	else
		sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

	bound_other_ammo ();

	oldw = other.items;
	other.items = other.items | new;

	e = self;
	self = other;

	if (!Q_100)
		PK_Deathmatch_Weapon (new, 0); // *pk - new wep switch rule for higher risk weps
	else
	if (!deathmatch)
		self.weapon = new;
	else
		Deathmatch_Weapon (oldw, new);

	W_SetCurrentAmmo ();

	self = e;

	if (leave)
		return;

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
		self.nextthink = time + RSP_TIME;
	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

void() e_weap_Attack =
{
	local entity e;

	e = self.eweapon;

	if (rune_haste(e.attack_finished / 2))
		self.attack_finished = time + e.attack_finished;

	if (e._attack != SUB_Null) e._attack();
	if (e._fr_attack != SUB_Null) e._fr_attack();
	if (e.noise3 != "")
		sound (self, CHAN_WEAPON, e.noise3, 1, ATTN_NORM);
	e.aflag = self.currentammo;

	cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view
};

