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

// should be RSP_TIME
float D_POWER_WAIT			= 30; // seconds major doom powers need to respawn

float DOOM_SHOT_DMG			= -1666666; // tell code to calculate doom bullet damage - d3 * 5 per shot
float DOOM_ROCK_DMG			= -1666667; // tell code to calculate doom rocket damage - 

float W_DEF_BULLETS_CLIP	= 8;


void() doom_precache =
{
//	precache_model ("");
//	precache_sound ("");

// items
	precache_model ("progs/barrel.mdl");
	precache_model ("progs/barrel2.mdl");
	precache_model ("progs/heal_bottle.mdl");
	precache_model ("progs/heal_medkit.mdl");
	precache_model ("progs/heal_stimpak.mdl");
	precache_model ("progs/spiritarmor.mdl");
	precache_model ("progs/d_spheres.mdl");
	precache_model ("progs/d_berzerk.mdl");
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
	precache_model ("progs/d_pack.mdl");
// doom weps
	precache_model ("progs/d_saw.mdl");
	precache_model ("progs/d_pistol.mdl");
	precache_model ("progs/d_bfg.mdl");
	precache_model ("progs/d_rock.mdl");
	precache_model ("progs/d_plasma.mdl");
	precache_model ("progs/d_chaingun.mdl");
	precache_model ("progs/d_shotgun.mdl");
	precache_model ("progs/d_dblshot.mdl");
// shots
	precache_model ("progs/d_plasma_sht.mdl");

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
	precache_model ("progs/w_knife.mdl");
	precache_model ("progs/w_pistol.mdl");
	precache_model ("progs/w_mgun.mdl");
	precache_model ("progs/w_chaing.mdl");
	precache_model ("progs/w_mortar.mdl");
	precache_model ("progs/w_flamer.mdl");
	precache_model ("progs/w_clip.mdl");
	precache_model ("progs/w_key.mdl");

	precache_model ("progs/vw_w_knife.mdl");
	precache_model ("progs/vw_w_pistol.mdl");
	precache_model ("progs/vw_w_mgun.mdl");
	precache_model ("progs/vw_w_chaing.mdl");
	precache_model ("progs/vw_w_2chaing.mdl");
	precache_model ("progs/vw_w_mortar.mdl");
	precache_model ("progs/vw_w_flamer.mdl");

//	precache_model ("progs/v_w_knife.mdl");
	precache_model ("progs/v_w_pistol.mdl");
	precache_model ("progs/v_w_mgun.mdl");
	precache_model ("progs/v_w_chg.mdl");
	precache_model ("progs/v_w_2chg.mdl");
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
	self.effects = self.effects | EF_FULLBRIGHT;
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
	self.effects = self.effects | EF_FULLBRIGHT;
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
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_spiritarmor =
{
	item_armor2();
	setmodel (self, "progs/spiritarmor.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Spirit armor";
//	self.skin = 0;
	self.state = D_ARM_TBLU;
	self.currentammo = ARM_SPIRIT;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

// FIX - different damage handling than q1 armors
void() d_item_armorgreen =
{
	item_armor1();
	setmodel (self, "progs/d_armor.mdl");
	self.skin = 0;
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Security armor";
	self.state = D_ARM_TGRN;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_armorblue =
{
	item_armor2();
	setmodel (self, "progs/d_armor.mdl");
	self.skin = 1;
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Combat armor";
	self.state = D_ARM_TBLU;
	self.currentammo = D_ARM_BLUE; // 200 units
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_ammobox =
{
	item_spikes();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_BULLETS;
	self.currentammo = D_DEF_BULLETS_BOX;

	setmodel (self, "progs/d_ammobox.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of bullets";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_clip =
{
	item_spikes();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_BULLETS;
	self.currentammo = D_DEF_BULLETS_CLIP;

	setmodel (self, "progs/d_clip.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "A clip";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_1rocket =
{
	item_rockets();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_ROCKETS;
	self.currentammo = D_DEF_ROCKETS_SM;

	setmodel (self, "progs/d_1rocket.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Rocket";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_rockbox =
{
	item_rockets();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_ROCKETS;
	self.currentammo = D_DEF_ROCKETS_LG;

	setmodel (self, "progs/d_rockbox.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of Rockets";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_4shell =
{
	item_shells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_SHELLS;
	self.currentammo = D_DEF_SHELLS;

	setmodel (self, "progs/d_4shell.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "4 shells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_shellbox =
{
	item_shells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_SHELLS;
	self.currentammo = D_DEF_SHELLBOX;

	setmodel (self, "progs/d_shellbox.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of Shells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_cellbox =
{
	item_cells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_CELLS;
	self.currentammo = D_DEF_CELLBOX;

	setmodel (self, "progs/d_cellbox.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of cells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_ammo_cellpack =
{
	item_cells();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_CELLS;
	self.currentammo = D_DEF_CELLPAK;

	setmodel (self, "progs/d_cellpack.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Cells";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_barrel =
{
	self.netname = "Barrel";
	misc_explodbox_set(self, "progs/barrel.mdl", D_BARREL_BLAST + random() * 8, 20, MOVETYPE_NONE);
	self.health = 20 + random() * 16; // heh heh
	self.noise = "doom/dsbarexp.wav";
	self.noise4 = "doom/dsitembk.wav";
//	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_bfg =
{
	q100_weapon_lightning();
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
	q100_weapon_rocketlauncher();

// fn
	self.touch = d_weapon_touch;
	self._attack = W_FireRocket;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = D_DEF_BLAST;
	self.items = IT_ROCKET_LAUNCHER;
	self.lip = AMMO_ROCKETS;
	self.attack_finished = 0.6;
	self.dmg = DOOM_ROCK_DMG;
	self.dodmg = 128; // splash
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

	self.touch = d_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_mgchg1;

// stats
	self.items = IT_SUPER_NAILGUN;
	self.currentammo = D_DEF_CHAING;
	self.lip = AMMO_BULLETS;
	self.attack_finished = 0.11;
	self.dmg = DOOM_SHOT_DMG;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.punchangle = ' 0.065 0.065 0';

	setmodel (self, "progs/d_chaingun.mdl");
	self.weaponmodel = "progs/v_d_chg.mdl";
	self.vwepmdl = "progs/vw_d_chaing.mdl";
	self.noise3 = "doom/d_f_chg.wav";
	self.noise3 = "doom/dspistol.wav";
	self.noise = "doom/dswpnup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_pistol =
{
//	d_rep_set();
	weapon_nailgun();
	self.netname = "Pistol";

	self.touch = d_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1; // FIX - special framing

// stats
	self.currentammo = 25;
	self.items = IT_NAILGUN; // IT_AXE; // testing
	self.lip = AMMO_BULLETS;
	self.attack_finished = 0.4;
	self.dmg = DOOM_SHOT_DMG;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.punchangle = ' 0.01 0.01 0';

	setmodel (self, "progs/d_pistol.mdl");
	self.weaponmodel = "progs/v_d_pistol.mdl";
	self.vwepmdl = "progs/vw_d_pistol.mdl";
	self.noise3 = "doom/dspistol.wav";
	self.noise = "doom/dswpnup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_weapon_saw =
{
//	d_rep_set();
	weapon_nailgun();
	self.netname = "Chainsaw";

	setmodel (self, "progs/d_saw.mdl");
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
	q100_weapon_shotgun();

	self.touch = d_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = D_DEF_SHOTG;
	self.items = IT_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.attack_finished = 1;
	self.dmg = DOOM_SHOT_DMG;
	self.dmg_take = 7; // shot cnt
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
	q100_weapon_supershotgun();
	self.netname = "Super shotgun";

	self.touch = d_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1;

	self.currentammo = D_DEF_SHOTG;
	self.items = IT_SUPER_SHOTGUN;
	self.lip = AMMO_SHELLS;
	self.attack_finished = 1.6667;
	self.dmg = DOOM_SHOT_DMG;
	self.dmg_save = 2;
	self.dmg_take = 21; // shot cnt
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
	q100_weapon_lightning();
	self.netname = "Plasma Gun";

	self.touch = d_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_plasma1;

	self.currentammo = D_DEF_PLASMAG;
	self.items = IT_LIGHTNING;
	self.lip = AMMO_CELLS;
	self.attack_finished = 0.083;
	self.dmg = DOOM_SHOT_DMG;
	self.dmg_save = 1;
	self.dmg_take = 1; // shot cnt

	setmodel (self, "progs/d_plasma.mdl");
	self.weaponmodel = "progs/v_d_plasma.mdl";
	self.vwepmdl = "progs/vw_d_plasma.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "doom/dsplasma.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.target = "doom/dsfirxpl.wav";

	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_item_pack =
{
	item_shells();
	setmodel(self, "progs/d_pack.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Ammo Pack";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_art_berserker =
{
	item_health();
	setmodel(self, "progs/d_berzerk.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Berserker";
	self.healamount = 100;
//	self.healtype = HEAL_NORM;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

// FIX - need correct sphere sounds

void() d_art_soulsphere =
{
	item_health();
	setmodel(self, "progs/d_spheres.mdl");
	self.skin = 0;
	self.noise = "doom/dsgetpow.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Soul Sphere";
	self.healamount = D_DEF_SOULSPH;
	self.healtype = HEAL_SOUL;
	self.wait = D_POWER_WAIT;
	self.effects = self.effects | EF_FULLBRIGHT;
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
	self.effects = self.effects | EF_FULLBRIGHT;
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
	self.effects = self.effects | EF_FULLBRIGHT;
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
	self.effects = self.effects | EF_FULLBRIGHT;
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
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

// use spawnflags to make one of 6 keys...
void() d_key_redskull =
{
	item_key1();

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_skullkey.mdl");
	self.skin = 0;
	self.netname = "Red Skull key";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_blueskull =
{
	item_key2();

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_skullkey.mdl");
	self.skin = 1;
	self.netname = "Blue Skull key";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_yellowskull =
{
	item_key2();

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_skullkey.mdl");
	self.skin = 2;
	self.netname = "Yellow Skull key";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_redcard =
{
	item_key1();

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_cardkey.mdl");
	self.skin = 0;
	self.netname = "Red card key";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_bluecard =
{
	item_key2();

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_cardkey.mdl");
	self.skin = 1;
	self.netname = "Blue card key";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "doom_item";
};

void() d_key_yellowcard =
{
	item_key2();

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_cardkey.mdl");
	self.skin = 2;
	self.netname = "Yellow card key";
	self.effects = self.effects | EF_FULLBRIGHT;
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

	self.touch = d_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_mgchg1;

// stats
	self.currentammo = 6;
	self.items = IT_NAILGUN;
	self.lip = AMMO_BULLETS;
	self.attack_finished = 0.16667; // 6 per
	self.dmg = 10;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.punchangle = ' 0.02 0.02 0';

	self.netname = "Machine Gun";

	setmodel (self, "progs/w_mgun.mdl");
	self.weaponmodel = "progs/v_w_mgun.mdl";
	self.vwepmdl = "progs/vw_w_mgun.mdl";
	self.noise3 = "wolf/w_mg.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_chg_base =
{
// stats
	self.items = IT_SUPER_NAILGUN;
	self.currentammo = 6;
	self.lip = AMMO_BULLETS;
	self.attack_finished = 0.087; // 11.5 per
	self.dmg = 10;
	self.dmg_save = 1;
	self.dmg_take = 2;
	self.punchangle = ' 0.05 0.05 0';

	self.netname = "Chain Gun";

	setmodel (self, "progs/w_chaing.mdl");
	self.weaponmodel = "progs/v_w_chg.mdl";
	self.vwepmdl = "progs/vw_w_chaing.mdl";
};

void() w_weapon_chaingun =
{
	d_rep_set();
	weapon_nailgun();

	w_chg_base();
	self.touch = wchg2_weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = player_mgchg1;

	self.noise3 = "wolf/w_chg.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
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
	q100_weapon_rocketlauncher();

// fn
	self.touch = d_weapon_touch;
	self._attack = w_fire_motar;
	self._fr_attack = player_rocket1;
// stats
	self.currentammo = 5; // W_DEF_BLAST;
	self.items = IT_ROCKET_LAUNCHER;
	self.lip = AMMO_ROCKETS;
	self.attack_finished = 0.8;
	self.dmg = 120;
	self.dodmg = 120;
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
	q100_weapon_grenadelauncher();

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

	self.touch = d_weapon_touch;
	self._attack = X_FireHitscan;
	self._fr_attack = player_shot1; // FIX - special framing

// stats
	self.currentammo = 6;
	self.items = IT_SHOTGUN; // IT_AXE; // testing
	self.lip = AMMO_BULLETS;
	self.attack_finished = 0.465; // 2.15 per
	self.dmg = 10;
	self.dmg_save = 1;
	self.dmg_take = 1;
	self.punchangle = ' 0.01 0.01 0';

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

void() w_ammo_clip =
{
	item_spikes();
	self.touch = pk_ammo_touch;

	self.lip = AMMO_BULLETS;
	self.currentammo = W_DEF_BULLETS_CLIP;

	setmodel (self, "progs/w_clip.mdl");
	self.noise = "wolf/pickup_am.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Clip";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_art_facesphere =
{
	item_health();
	setmodel(self, "progs/d_spheres.mdl");
	self.skin = 4;
	self.noise = "wolf/pickup_gdy.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Face Sphere";
	self.healamount = 100;
	self.healtype = HEAL_SOUL;
	self.wait = D_POWER_WAIT;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_key =
{
	if (self.spawnflags & 1)
		item_key2();
	else //if (self.spawnflags & 2)
		item_key1();

	self.noise = "wolf/pickup_gdy.wav";
	setmodel (self, "progs/w_key.mdl");

	self.netname = "Blue key";
	if (self.spawnflags & 1) self.netname = "Gold key";
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
};

void() w_key_g =
{
	self.spawnflags = 1;
	self.skin = 1;
	w_key();
};

void() w_key_b =
{
	self.spawnflags = 2;
	self.skin = 2;
	w_key();
};

void() w_barl_solid =
{
	self.owner.solid = SOLID_BBOX;
	self.owner.pk_touch = SUB_Null;
	remove(self);
};

void() w_barrel =
{
	local entity e;
	e = spawn();
	if (e)
	{
		e.owner = self;
		e.think = w_barl_solid;
		e.nextthink = time  + 1;
	}
	self.netname = "Barrel";
	setmodel (self, "progs/barrel2.mdl");
	self.frame = 1;
	self.effects = self.effects | EF_FULLBRIGHT;
	if (self.class_select == "") self.class_select = "wolf_item";
//	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
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

	if (self.classname == "q2_weapon_rocketlauncher" || self.classname == "q3_weapon_rocketlauncher" ||
		self.classname == "q3_weapon_grenadelauncher" || self.classname == "q2_weapon_grenadelauncher" ||
		self.classname == "weapon_grenadelauncher" || self.classname == "weapon_rocketlauncher" ||
		self.classname == "d_weapon_rocketlauncher" || self.classname == "w_weapon_mortar")
	{
	other.ammo_rockets = other.ammo_rockets + self.currentammo; // TDO: ammo type fn
	camc = other.ammo_rockets;
	}
	else if (self.classname == "d_weapon_shotgun" || self.classname == "d_weapon_supershotgun" ||
		self.classname == "q2_weapon_shotgun" || self.classname == "q2_weapon_supershotgun" ||
		self.classname == "weapon_shotgun" || self.classname == "weapon_supershotgun" ||
		self.classname == "q3_weapon_shotgun")
	{
	other.ammo_shells = other.ammo_shells + self.currentammo;
	camc = other.ammo_shells;
	}
	else if (self.classname == "d_weapon_pistol" || self.classname == "d_weapon_chaingun"
					|| self.classname == "q3_weapon_machinegun"
					|| self.classname == "w_weapon_machinegun"
					|| self.classname == "w_weapon_chaingun"
					|| self.classname == "w_weapon_pistol")
	{
	other.ammo_bullet = other.ammo_bullet + self.currentammo;
	camc = other.ammo_bullet;
	}
	else if (self.classname == "d_weapon_plasma" ||
		self.classname == "q3_weapon_lightning" || self.classname == "weapon_lightning" ||
		self.classname == "q3_weapon_bfg" ||
		self.classname == "weapon_plasmagun")
	{
	other.ammo_cells = other.ammo_cells + self.currentammo;
	camc = other.ammo_cells;
	}
	else if (self.classname == "q2_weapon_railgun" ||
		self.classname == "q3_weapon_railgun" ||
		self.classname == "weapon_railgun")
	{
	other.ammo_slug = other.ammo_slug + self.currentammo;
	camc = other.ammo_slug;
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

	if (!vchk(new, 0, other.vwepent) || new == IT_SHOTGUN)
	{
		e = vload(other, new);
		e.eweapon = e;
		e._attack = self._attack;
		e._fr_attack = self._fr_attack;
//		e.touch = self.touch;

		e.weapon = e.items = self.items;
		e.currentammo = self.currentammo;
		e.lip = self.lip;
		e.attack_finished = self.attack_finished;
		e.dmg = self.dmg;
		e.dodmg = self.dodmg;
		e.dmg_save = self.dmg_save;
		e.dmg_take = self.dmg_take;
		e.punchangle = self.punchangle;
		e.aflag = camc;

		e.netname = self.netname;
//		e.mdl = self.mdl; - invisible
		setmodel (e, self.vwepmdl);
		e.mdl = e.model;
		e.weaponmodel = self.weaponmodel;
		e.chaosweptime = self.chaosweptime;
		e.noise = self.noise;
		e.noise2 = self.noise2;
		e.noise3 = self.noise3;
		e.noise4 = self.noise4;
		e.target = self.target;
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

void() wchg2_weapon_touch =
{
	local entity e;

	e = vchk(self.items, 0, other.vwepent);
	if (e)
	if (e.eweapon)
	{
		if (! (other.items & IT_LIGHTNING))
		if (e.eweapon.mdl == "progs/vw_w_chaing.mdl") // IDEA: do for other akimbos
		{
			self.items = IT_LIGHTNING;
			self.dmg_save = 2;
			self.dmg_take = 4;
			self.punchangle = ' 0.07 0.07 0';

			self.netname = "Dual Chain Gun";

			self.weaponmodel = "progs/v_w_2chg.mdl";
			self.vwepmdl = "progs/vw_w_2chaing.mdl";

			d_weapon_touch();
			w_chg_base();
			self.model = string_null;
			return;
		}
	}

	d_weapon_touch();
};

