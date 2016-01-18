/*
		+---------------------------------------+
		|  Doom specific code                   | SEC-HEAD
		+---------------------------------------+
*/
// map item indiv reposition codes

float EF_FULLBRIGHT			= 512;

float HEAL_BOT						= 4; // doom health bottle - ignore normal max, no rot
float HEAL_SOUL					= 5; // doom health: soul, meta spheres - 200 max, no rot

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
	precache_model ("progs/w_pistol.mdl"); // NOTE: this a map item?
	precache_model ("progs/w_mgun.mdl");
	precache_model ("progs/w_chaing.mdl");
	precache_model ("progs/w_mortar.mdl");
	precache_model ("progs/w_flamer.mdl");

	precache_model ("progs/vw_w_knife.mdl"); // NOTE: this a map item?
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
	precache_sound ("wolf/pickup_am.wav");
	precache_sound ("wolf/pickup_gn.wav");
	precache_sound ("wolf/pickup_gdy.wav");
	precache_sound ("wolf/door_opn.wav");
	precache_sound ("wolf/door_cls.wav");


};

//fn(d_thk_reps) - some guns wont appear in map if in correct position - have to load elsewhere and move later

float d_reps_base				= 57005000; // heh heh - DEAD+

void () d_thk_reps =
{
	local entity t;

	t = find (world, targetname, self.owner.target);
	if (t)
	{
		setorigin(self.owner, t.origin);
		self.owner.oldorigin = t.origin;
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


/*
		+---------------------------------------+
		|  Map code - Doom                     | SEC-HEAD
		+---------------------------------------+
*/

void() item_health;
/*
NOTE: this code assumes the translation of doom map entites to quake style definitions in the map file by some device or code...

 uses ypod models for now - may recraft many of these...at least the easy ones

NOTE: there is no entites file for doom in the style of QUAKED
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
};

void() d_item_spiritarmor =
{
	local string mcc;
	mcc = item_by_mcode(MC_ARMOR2);
	item_call(mcc);
	setmodel (self, "progs/spiritarmor.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Spirit armor";
	self.skin = 0;
	self.state = D_ARM_TBLU;
	self.currentammo = ARM_SPIRIT;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

// FIX - different damage handling than q1 armors
void() d_item_armorgreen =
{

	local string mcc;
	mcc = item_by_mcode(MC_ARMOR1);
	item_call(mcc);
	setmodel (self, "progs/d_armor.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Security armor";
	self.state = D_ARM_TGRN;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_item_armorblue =
{

	local string mcc;
	mcc = item_by_mcode(MC_ARMOR2);
	item_call(mcc);
	setmodel (self, "progs/d_armor.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Combat armor";
	self.state = D_ARM_TBLU;
	self.currentammo = D_ARM_BLUE; // 200 units
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_ammo_ammobox =
{
	local string mcc;
	mcc = item_by_mcode(MC_ANAILS_LG);
	item_call(mcc);

	setmodel (self, "progs/d_ammobox.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of bullets";
	self.currentammo = D_DEF_BULLETS_BOX;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_ammo_clip =
{
	local string mcc;
	mcc = item_by_mcode(MC_ANAILS);
	item_call(mcc);
	setmodel (self, "progs/d_clip.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "A clip";
	self.currentammo = D_DEF_BULLETS_CLIP;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_ammo_1rocket =
{
	local string mcc;
	mcc = item_by_mcode(MC_AROCKETS);
	item_call(mcc);
	setmodel (self, "progs/d_1rocket.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "A Rocket";
	self.currentammo = D_DEF_ROCKETS_SM;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_ammo_rockbox =
{
	local string mcc;
	mcc = item_by_mcode(MC_AROCKETS_LG);
	item_call(mcc);
	setmodel (self, "progs/d_rockbox.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of Rockets";
	self.currentammo = D_DEF_ROCKETS_LG;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_ammo_4shell =
{
	local string mcc;
	mcc = item_by_mcode(MC_ASHELLS);
	item_call(mcc);
	setmodel (self, "progs/d_4shell.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "4 shells";
	self.currentammo = D_DEF_SHELLS;
//	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_ammo_shellbox =
{
	local string mcc;
	mcc = item_by_mcode(MC_ASHELLS_LG);
	item_call(mcc);
	setmodel (self, "progs/d_shellbox.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of Shells";
	self.currentammo = D_DEF_SHELLBOX;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_ammo_cellbox =
{
	local string mcc;
	mcc = item_by_mcode(MC_ACELLS);
	item_call(mcc);
	setmodel (self, "progs/d_cellbox.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Box of cells";
	self.currentammo = D_DEF_CELLBOX;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_ammo_cellpack =
{
	local string mcc;
	mcc = item_by_mcode(MC_ACELLS);
	item_call(mcc);
	setmodel (self, "progs/d_cellpack.mdl");
	self.noise = "doom/dsitemup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Cells";
	self.currentammo = D_DEF_CELLPAK;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_barrel =
{
	local float z1;
//	misc_explobox();
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;

	self.origin_z = self.origin_z + 2;
	z1 = self.origin_z;
	droptofloor(0,0); // Cataboligne 9.17.3 - fix compiler warning
	if (z1 - self.origin_z > 250)
	{
		dprint ("Barrel fell out of level at ");
		dprint (vtos (self.origin));
		dprint ("\n");
		if (PK_100 || Q_100)
		{
			remove (self);
			return ;
		}
		else
			dtf_handle();
	}

	setmodel (self, "progs/barrel.mdl");
//	misc_explodbox_set(self, "progs/barrel.mdl", D_BARREL_BLAST + random() * 8, 20 + random() * 15);
	self.noise = "doom/dsbarexp.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.netname = "Barrel";
//	self.currentammo = D_BARREL_BLAST;
//	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_weapon_bfg =
{
	local string mcc;
	mcc = item_by_mcode(MC_THUNDER);
	item_call(mcc);

	self.netname = "BFG 9000";

	setmodel (self, "progs/d_bfg.mdl");
//	self.weaponmodel = "progs/v_d_bfg.mdl";
//	self.vwep = "progs/vw_d_bfg.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.currentammo = D_DEF_BFG;
};

void() d_weapon_rocketlauncher =
{
	local string mcc;
	mcc = item_by_mcode(MC_ROCKETL);
	item_call(mcc);

	setmodel (self, "progs/d_rock.mdl");
	self.weaponmodel = "progs/v_d_rock.mdl";
//	self.vwep = "progs/vw_d_rock.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "doom/dsrlaunc.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.currentammo = D_DEF_BLAST;
//	self._hk_major = W_FireRocket;
};

void() d_weapon_chaingun =
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

	local string mcc;
	mcc = item_by_mcode(MC_SUPER_NAILGUN);
	item_call(mcc);
	self.netname = "Chain Gun";

//TEST
//	setmodel (self, "progs/q2_chg.mdl");
//	self.weaponmodel = "progs/v_q2_chg.mdl";
//	self.vwep = "progs/vw_q2_chg.mdl";
//	self.noise3 = "q2/q2_chg_fire.wav";

	setmodel (self, "progs/d_chaingun.mdl");
	self.weaponmodel = "progs/v_d_chg.mdl";
//	self.vwep = "progs/vw_d_chaing.mdl";
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
};

void() d_weapon_shotgun =
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

	local string mcc;
	mcc = item_by_mcode(MC_SUPER_SHOTGUN);
	item_call(mcc);
	setmodel (self, "progs/d_shotgun.mdl");
	self.weaponmodel = "progs/v_d_shot.mdl";
//	self.vwep = "progs/vw_d_shot.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "doom/dsshotgn.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.currentammo = D_DEF_SHOTG;
	self.effects = self.effects | EF_FULLBRIGHT;
};

void() d_weapon_supershotgun =
{

	local string mcc;
	mcc = item_by_mcode(MC_SUPER_SHOTGUN);
	item_call(mcc);
	self.netname = "Super shotgun";


	setmodel (self, "progs/d_dblshot.mdl");
	self.weaponmodel = "progs/v_d_dblshot.mdl";
// TEST
//	setmodel (self, "progs/g_reggun.mdl");
//	self.weaponmodel = "progs/v_reggun.mdl";
//	self.vwep = "progs/vw_d_dblshot.mdl";
	self.noise = "doom/dswpnup.wav";
	self.noise3 = "doom/dsdshtgn.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.currentammo = D_DEF_SHOTG;
	self.effects = self.effects | EF_FULLBRIGHT;
};


void() d_weapon_plasma =
{

	local string mcc;
	mcc = item_by_mcode(MC_THUNDER);
	item_call(mcc);
	self.netname = "Plasma Gun";

	setmodel (self, "progs/d_plasma.mdl");
	self.weaponmodel = "progs/v_d_plasma.mdl";
//	self.vwep = "progs/vw_d_plasma.mdl";
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
};

void() d_art_megapower =
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
};

void() d_art_invulnerable =
{

	local string mcc;
	mcc = item_by_mcode(MC_PENT);
	item_call(mcc);
	self.noise = "doom/dsgetpow.wav";
	self.noise4 = "doom/dsitembk.wav";
	setmodel (self, "progs/d_spheres.mdl");
	self.skin = 2;
	self.netname = "Invulnerability";
	self.wait = D_POWER_WAIT;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_art_invisible =
{

	local string mcc;
	mcc = item_by_mcode(MC_RING);
	item_call(mcc);
	self.noise = "doom/dsgetpow.wav";
	self.noise4 = "doom/dsitembk.wav";
	setmodel (self, "progs/d_spheres.mdl");
	self.skin = 3;
	self.netname = "Invisibilty";
	self.wait = D_POWER_WAIT;
	self.delay = 30; // usage time
};

void() d_art_radsuit =
{

	local string mcc;
	mcc = item_by_mcode(MC_SUIT);
	item_call(mcc);
	self.noise = "doom/dsitemup.wav"; // radsuit finish sounds, proper op
	setmodel (self, "progs/d_radsuit.mdl");
	self.delay = 30;
	self.netname = "Radiation Suit";
	self.wait = D_POWER_WAIT;
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

// use spawnflags to make one of 6 keys...
void() d_key_redskull =
{
	local string mcc;
	mcc = item_by_mcode(MC_KEY1);
	item_call(mcc);

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_skullkey.mdl");
//	self.skin = 0;
	self.netname = "Red Skull key";
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_key_blueskull =
{
	local string mcc;
	mcc = item_by_mcode(MC_KEY2);
	item_call(mcc);

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_skullkey.mdl");
	self.skin = 1;
	self.netname = "Blue Skull key";
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
};

void() d_key_yellowskull =
{
	local string mcc;
	mcc = item_by_mcode(MC_KEY1);
	item_call(mcc);

	self.noise = "doom/dsitemup.wav";
	setmodel (self, "progs/d_skullkey.mdl");
	self.skin = 2;
	self.netname = "Yellow Skull key";
	self.effects = self.effects | EF_FULLBRIGHT; // FIX - only for testing in darkplaces!
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
	local string mcc;
	mcc = item_by_mcode(MC_NAILGUN);
	item_call(mcc);

	self.netname = "Machine Gun";

	setmodel (self, "progs/w_mgun.mdl");
	self.weaponmodel = "progs/v_w_mgun.mdl";
//	self.vwep = "progs/vw_w_mgun.mdl";
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

};

void() w_weapon_chaingun =
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

	local string mcc;
	mcc = item_by_mcode(MC_SUPER_NAILGUN);
	item_call(mcc);

	self.netname = "Chain Gun";

	setmodel (self, "progs/w_chaing.mdl");
	self.weaponmodel = "progs/v_w_chg.mdl";
//	self.vwep = "progs/vw_w_chaing.mdl";
	self.noise3 = "wolf/w_chg.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.currentammo = D_DEF_CHAING;
	self.effects = self.effects | EF_FULLBRIGHT;
	self.attack_finished = 0.087;
	self.punchangle = ' 0.065 0.065 0'; // bullet spread out
};

void() w_weapon_mortar =
{
	local string mcc;
	mcc = item_by_mcode(MC_ROCKETL);
	item_call(mcc);

	self.netname = "Mortar";
	setmodel (self, "progs/w_mortar.mdl");
	self.weaponmodel = "progs/v_w_mortar.mdl";
//	self.vwep = "progs/vw_w_mortar.mdl";
//	self.noise3 = "wolf/w_mg.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise3 = "doom/dsrlaunc.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
	self.currentammo = 5; // W_DEF_BLAST;
};

void() w_weapon_flamer =
{
	local string mcc;
	mcc = item_by_mcode(MC_GRENADEL);
	item_call(mcc);

	setmodel (self, "progs/w_flamer.mdl");
	self.weaponmodel = "progs/v_w_flamer.mdl";
//	self.vwep = "progs/vw_w_flamer.mdl";
//	self.noise3 = "wolf/w_mg.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise3 = "doom/dsrlaunc.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.effects = self.effects | EF_FULLBRIGHT;
};

void() w_weapon_pistol =
{
	local string mcc;
	mcc = item_by_mcode(MC_NAILGUN);
	item_call(mcc);

	setmodel (self, "progs/w_pistol.mdl");
	self.weaponmodel = "progs/v_w_pistol.mdl";
//	self.vwep = "progs/vw_w_pistol.mdl";
	self.noise3 = "wolf/w_pistol.wav";
	self.noise = "wolf/pickup_gn.wav";
	self.noise4 = "doom/dsitembk.wav";
	self.currentammo = 25;
	self.attack_finished = 0.465; // 2.15 per
	self.effects = self.effects | EF_FULLBRIGHT;
};
