/* ::-::
 *
 * Cataboligne
 *
 * file: mcode.qc
 *
 * date: 5/27/10
 *
 * qc - map codes for wep cycling - chaos mod code
 *
 */

///float MIN_ITEM					= 100;
//float MAX_INVITEM			= 255;
//float MAX_OLDQ				= 300;
float MAX_ITEM					= 999;

float ITEM_SET1				= 1023;
float ITEM_SET2				= 1047552; // allows multiplexing of 2 x 1023 bit values in 1 float if needed


// master code list

/// quake 1
// q1 wep ids
float MC_AXE					= 100;
float MC_SHOTGUN				= 101;
float MC_SUPER_SHOTGUN		= 102; // - 101 to get item override menu #
float MC_NAILGUN				= 103;
float MC_SUPER_NAILGUN		= 104;
float MC_GRENADEL	 			= 105;
float MC_ROCKETL				= 106;
float MC_THUNDER				= 107;

// 108 is special - xlates to pkitems on admin item override menu

// special ids
float MC_QUAD					= 109;
float MC_PENT					= 110;
float MC_RING					= 111;
float MC_SUIT					= 112;

// armor ids
float MC_ARMOR1				= 113;
float MC_ARMOR2				= 114;
float MC_ARMOR3				= 115;

// health ids - translate
float MC_HEALTHROT			= 116;
float MC_HEALTH				= 117;
float MC_HEALTHMEGA			= 118;

// key ids
float MC_KEY1					= 119;
float MC_KEY2					= 120;

// ammo ids
float MC_ASHELLS				= 121;
float MC_ASHELLS_LG			= 122;
float MC_ANAILS				= 123;
float MC_ANAILS_LG			= 124;
float MC_AROCKETS				= 125;
float MC_AROCKETS_LG			= 126;
float MC_ACELLS				= 127;
float MC_ACELLS_LG			= 128;

// boom!
float MC_EXPLOD1				= 129;
float MC_EXPLOD2				= 130;

// sigil id - flags
float MC_SIGIL1				= 131;
float MC_SIGIL2				= 132;
float MC_SIGIL4				= 133;
float MC_SIGIL8				= 134;

float MC_Q1						= 135;
float MC_RNDITM				= 32;		// # of q1 items - have to change it items changes
float MC_NR_RNDITM			= 28;		//   no runes

float MC_SIGIL					= 135;

float MC_BACKPACK				= 134;

/// painkeep
// pk wep ids
float MC_EXPSHOTGUN			= 140;
float MC_PULSE_NAILGUN		= 141;
float MC_CHTHUNDR				= 142;
float MC_GRAP					= 143;
float MC_AIRGUN				= 144;

// device ids - carryable stuff? (doesnt use ammo like a range wep)
//float MC_CARRYABLE			= 200;
// pk weps;
float MC_BEARTRAP				= 145;
float MC_GRAVITY				= 146;
float MC_SENTRY				= 147;
float MC_CANOBEANS			= 148;
float MC_AEXPLSH				= 149;
// pk plus
float MC_TOMB					= 150;
float MC_EGO					= 151;
float MC_PHONE					= 152;
float MC_MASK					= 153;

float MC_PK						= 154;
float MC_PK_RNDITM			= 8;		// # of base pk items
float MC_PKP_RNDITM			= 12;		//   + plus items


float MC_T_RNDITM				= 40;		// # of total items
float MC_TRNSUB				= 6;		// # of total items

/// doom

float MC_D_FIST				= 160;
float MC_D_SAW					= 161;
float MC_D_PISTOL				= 162;
float MC_D_SHOTGUN			= 163;
float MC_D_BOOMSTICK			= 164;
float MC_D_CHAINGUN			= 165;
float MC_D_ROCKETL			= 166;
float MC_D_PLASMA	 			= 167;
float MC_D_BFG					= 168;

float MC_D_BERS				= 169;
float MC_D_INVUL				= 170;
float MC_D_INVIS				= 171;
float MC_D_RADSUIT			= 172;
float MC_D_SOULSPH			= 173;
float MC_D_MEGASPH			= 174;

float MC_D_ARM_SPR			= 175;
float MC_D_ARM_GRN			= 176;
float MC_D_ARM_BLU			= 177;

float MC_D_HBOTTLE			= 178;
float MC_D_STIMPAK			= 179;
float MC_D_MEDKIT				= 180;

float MC_D_KEY_RED_SK		= 181;
float MC_D_KEY_BLU_SK		= 182;
float MC_D_KEY_YEL_SK		= 183;
float MC_D_KEY_RED_CR		= 184;
float MC_D_KEY_BLU_CR		= 185;
float MC_D_KEY_YEL_CR		= 186;

float MC_D_ASHELLS			= 187;
float MC_D_ASHELLS_LG		= 188;
float MC_D_ABULLETS			= 189;
float MC_D_ABULLETS_LG		= 190;
float MC_D_AROCKET			= 191;
float MC_D_AROCKETS_LG		= 192;
float MC_D_ACELLS				= 193;
float MC_D_ACELLS_LG			= 194;

float MC_D_PACK				= 195;
float MC_D_NIGHTVS			= 196;
float MC_D_AUTOMAP			= 197;

float MC_D_BARREL				= 198;

/// wolf 3d

float MC_W_PISTOL				= 199;
float MC_W_MACHGUN			= 200;
float MC_W_CHAINGUN			= 201;
float MC_W_MORTAR				= 202;
float MC_W_FLAMER				= 203;

// fn(bit_mcode) - item bit assoc with given mcode

float(float mcv, entity e) bit_mcode =
{
	local float mc;

	mc = mcv;
	if (!mc && e) mc = e.mcode;
	if (!mc) return(0);
	
	if (mc == MC_SUPER_SHOTGUN)										return(IT_SUPER_SHOTGUN);
	if (mc == MC_NAILGUN)												return(IT_NAILGUN);
	if (mc == MC_SUPER_NAILGUN)										return(IT_SUPER_NAILGUN);
	if (mc == MC_GRENADEL)												return(IT_GRENADE_LAUNCHER);
	if (mc == MC_ROCKETL)												return(IT_ROCKET_LAUNCHER);
	if (mc == MC_THUNDER)												return(IT_LIGHTNING);

	if (mc == MC_PENT)													return(IT_INVULNERABILITY);
	if (mc == MC_SUIT)													return(IT_SUIT);
	if (mc == MC_RING)													return(IT_INVISIBILITY);
	if (mc == MC_QUAD)													return(IT_QUAD);

	if (mc == MC_ARMOR1)													return(IT_ARMOR1);
	if (mc == MC_ARMOR2)													return(IT_ARMOR2);
	if (mc == MC_ARMOR3)													return(IT_ARMOR3);

	if (mc == MC_HEALTHROT)												return(0);
	if (mc == MC_HEALTH)													return(0);
	if (mc == MC_HEALTHMEGA)											return(IT_SUPERHEALTH);

	if (mc == MC_KEY1)													return(IT_KEY1);
	if (mc == MC_KEY2)													return(IT_KEY2);
	if (mc == MC_SIGIL1)													return(R_EARTH);
	if (mc == MC_SIGIL2)													return(R_BLACK);
	if (mc == MC_SIGIL4)													return(R_HELL);
	if (mc == MC_SIGIL8)													return(R_ELDER);

	if (mc == MC_ASHELLS)												return(IT_SHELLS);
	if (mc == MC_ANAILS)													return(IT_NAILS);
	if (mc == MC_AROCKETS)												return(IT_ROCKETS);
	if (mc == MC_ACELLS)													return(IT_CELLS);

	if (mc == MC_ASHELLS_LG)											return(IT_SHELLS);
	if (mc == MC_ANAILS_LG)												return(IT_NAILS);
	if (mc == MC_AROCKETS_LG)											return(IT_ROCKETS);
	if (mc == MC_ACELLS_LG)												return(IT_CELLS);

	if (Q_100 || Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
		return(0);
	
// pk item subs by special bits
	if (mc == MC_GRAVITY)												return(PK_IT_GRAVITYWELL);
	if (mc == MC_SENTRY)													return(PK_IT_TURRET);
	if (mc == MC_BEARTRAP)												return(PK_IT_BEARTRAP);
	if (mc == MC_AEXPLSH)												return(0);
	if (mc == MC_CHTHUNDR)												return(PK_IT_CLIGHT);
	if (mc == MC_PULSE_NAILGUN)										return(IT_NAILGUN);
	if (mc == MC_GRAP)													return(PK_IT_GRAPGUN);
	if (mc == MC_AIRGUN)													return(PK_IT_AIRGUN);
	if (mc == MC_CANOBEANS)												return(PK_IT_CANPAB);
	if (mc == MC_EGO)														return(PKPLUS_IT_EGO);
	if (mc == MC_TOMB)													return(PKPLUS_IT_TOMB);
	if (mc == MC_MASK)													return(PKPLUS_IT_ACTOR);
	if (mc == MC_PHONE)													return(PKPLUS_IT_PHONE);

	if (mc == MC_D_SHOTGUN)												return(IT_SHOTGUN);
	if (mc == MC_D_BOOMSTICK)											return(IT_SUPER_SHOTGUN);
	if (mc == MC_D_CHAINGUN)											return(IT_SUPER_NAILGUN);
	if (mc == MC_D_ROCKETL)												return(IT_ROCKET_LAUNCHER);
	if (mc == MC_D_PLASMA)												return(IT_LIGHTNING);
	if (mc == MC_D_BFG)													return(IT_EXTRA_WEAPON);
	if (mc == MC_D_SAW)													return(IT_AXE);
	if (mc == MC_D_PISTOL)												return(IT_NAILGUN);

	if (mc == MC_D_BERS)													return(IT_QUAD);
	if (mc == MC_D_INVUL)												return(IT_INVULNERABILITY);
	if (mc == MC_D_INVIS)												return(IT_INVISIBILITY);
	if (mc == MC_D_RADSUIT)												return(IT_SUIT);

	if (mc == MC_D_ARM_GRN)												return(IT_ARMOR2);
	if (mc == MC_D_ARM_BLU)												return(IT_ARMOR3);

	if (mc == MC_D_SOULSPH)												return(IT_SUPERHEALTH);

	if (mc == MC_D_KEY_RED_SK)											return(IT_KEY2);
	if (mc == MC_D_KEY_BLU_SK)											return(IT_KEY1);
//	if (mc == MC_D_KEY_YEL_SK)											return(IT_KEY3);
	if (mc == MC_D_KEY_RED_CR)											return(IT_KEY2);
	if (mc == MC_D_KEY_BLU_CR)											return(IT_KEY1);
//	if (mc == MC_D_KEY_YEL_CR)											return(IT_KEY3);

	if (mc == MC_D_ASHELLS)												return(IT_SHELLS);
	if (mc == MC_D_ASHELLS_LG)											return(IT_SHELLS);
//	if (mc == MC_D_ABULLETS)											return(IT_BULLETS);
//	if (mc == MC_D_ABULLETS_LG)										return(IT_BULLETS);
	if (mc == MC_D_AROCKET)												return(IT_ROCKETS);
	if (mc == MC_D_AROCKETS_LG)										return(IT_ROCKETS);
	if (mc == MC_D_ACELLS)												return(IT_CELLS);
	if (mc == MC_D_ACELLS_LG)											return(IT_CELLS);

	if (mc == MC_W_PISTOL)												return(IT_SHOTGUN);
	if (mc == MC_W_MACHGUN)												return(IT_NAILGUN);
	if (mc == MC_W_CHAINGUN)											return(IT_SUPER_NAILGUN);
	if (mc == MC_W_MORTAR)												return(IT_ROCKET_LAUNCHER);
	if (mc == MC_W_FLAMER)												return(IT_GRENADE_LAUNCHER);

	return(0);
};

// fn(pk_mcode) - map code for items

// e - ent being tested
// sc - classname to test
// returns map code value

float(string sc, entity e) pk_mcode =
{
//	local float mc;
	local string tsc;

	tsc = sc;
	if (sc == "" && e) tsc = e.classname;
	if (tsc == "") return(0);

	if (tsc == "dyn_item")												return(0);
// q1
	if (e) // qualify ent
	{
	if ((tsc == "item_shells") && (e.spawnflags & 1))			return(MC_ASHELLS_LG);
	if ((tsc == "item_spikes") && (e.spawnflags & 1))			return(MC_ANAILS_LG);
	if ((tsc == "item_rockets") && (e.spawnflags & 1))			return(MC_AROCKETS_LG);
	if ((tsc == "item_cells") && (e.spawnflags & 1))			return(MC_ACELLS_LG);
	if ((tsc == "item_health") && (e.spawnflags & 1))			return(MC_HEALTHROT);
	if ((tsc == "item_health") && (e.spawnflags & 2))			return(MC_HEALTHMEGA);

	if ((tsc == "item_sigil") && (e.spawnflags & R_EARTH))	return(MC_SIGIL1);
	if ((tsc == "item_sigil") && (e.spawnflags & R_BLACK))	return(MC_SIGIL2);
	if ((tsc == "item_sigil") && (e.spawnflags & R_HELL))		return(MC_SIGIL4);
	if ((tsc == "item_sigil") && (e.spawnflags & R_ELDER))	return(MC_SIGIL8);
	}

	if (tsc == "weapon_supershotgun")								return(MC_SUPER_SHOTGUN);
	if (tsc == "weapon_nailgun")										return(MC_NAILGUN);
	if (tsc == "weapon_supernailgun")								return(MC_SUPER_NAILGUN);
	if (tsc == "weapon_grenadelauncher")							return(MC_GRENADEL);
	if (tsc == "weapon_rocketlauncher")								return(MC_ROCKETL);
	if (tsc == "weapon_lightning")									return(MC_THUNDER);
// ammo
	if (tsc == "item_shells")											return(MC_ASHELLS);
	if (tsc == "item_spikes")											return(MC_ANAILS);
	if (tsc == "item_rockets")											return(MC_AROCKETS);
	if (tsc == "item_cells")											return(MC_ACELLS);

	if (tsc == "item_artifact_invulnerability")					return(MC_PENT);
	if (tsc == "item_artifact_super_damage")						return(MC_QUAD);
	if (tsc == "item_artifact_invisibility")						return(MC_RING);
	if (tsc == "item_artifact_envirosuit")							return(MC_SUIT);

	if (tsc == "item_health")											return(MC_HEALTH);
	if (tsc == "item_armor1")											return(MC_ARMOR1);
	if (tsc == "item_armor2")											return(MC_ARMOR2);
	if (tsc == "item_armorInv")										return(MC_ARMOR3);
	if (tsc == "item_key1")												return(MC_KEY1);
	if (tsc == "item_key2")												return(MC_KEY2);
	if (tsc == "item_sigil")											return(MC_SIGIL);
	if (tsc == "misc_explobox")										return(MC_EXPLOD1);
	if (tsc == "misc_explobox2")										return(MC_EXPLOD2);
// pk
	if (tsc == "weapon_airfist")										return(MC_AIRGUN);
	if (tsc == "weapon_chainlg")										return(MC_CHTHUNDR);
	if (tsc == "weapon_grapgun")										return(MC_GRAP);
	if (tsc == "weapon_pulsenail")									return(MC_PULSE_NAILGUN);
	if (tsc == "item_painkeep_gwell")								return(MC_GRAVITY);
	if (tsc == "item_painkeep_turret")								return(MC_SENTRY);
	if (tsc == "item_painkeep_beartrap")							return(MC_BEARTRAP);
	if (tsc == "item_painkeep_expshells")							return(MC_AEXPLSH);
	if (tsc == "item_painkeep_can")									return(MC_CANOBEANS);
	if (tsc == "item_pkplus_ego")										return(MC_EGO);
	if (tsc == "item_pkplus_tomb")									return(MC_TOMB);
	if (tsc == "item_pkplus_actor")									return(MC_MASK);
	if (tsc == "item_pkplus_phone")									return(MC_PHONE);

// doom
	if (tsc == "d_weapon_shotgun")									return(MC_D_SHOTGUN);
	if (tsc == "d_weapon_supershotgun")								return(MC_D_BOOMSTICK);
	if (tsc == "d_weapon_chaingun")									return(MC_D_CHAINGUN);
	if (tsc == "d_weapon_rocketlauncher")							return(MC_D_ROCKETL);
	if (tsc == "d_weapon_plasma")										return(MC_D_PLASMA);
	if (tsc == "d_weapon_bfg")											return(MC_D_BFG);
	if (tsc == "d_weapon_saw")											return(MC_D_SAW);
	if (tsc == "d_weapon_pistol")										return(MC_D_PISTOL);

	if (tsc == "d_art_berserker")										return(MC_D_BERS);
	if (tsc == "d_art_invulnerable")									return(MC_D_INVUL);
	if (tsc == "d_art_invisible")										return(MC_D_INVIS);
	if (tsc == "d_art_radsuit")										return(MC_D_RADSUIT);
	if (tsc == "d_art_soulsphere")									return(MC_D_SOULSPH);
	if (tsc == "d_art_megasphere")									return(MC_D_MEGASPH);

	if (tsc == "d_item_spiritarmor")									return(MC_D_ARM_SPR);
	if (tsc == "d_item_armorgreen")									return(MC_D_ARM_GRN);
	if (tsc == "d_item_armorblue")									return(MC_D_ARM_BLU);

	if (tsc == "d_item_healthbottle")								return(MC_D_HBOTTLE);
	if (tsc == "d_item_healthstimpak")								return(MC_D_STIMPAK);
	if (tsc == "d_item_healthmedkit")								return(MC_D_MEDKIT);

	if (tsc == "d_key_redskull")										return(MC_D_KEY_RED_SK);
	if (tsc == "d_key_blueskull")										return(MC_D_KEY_BLU_SK);
	if (tsc == "d_key_yellowskull")									return(MC_D_KEY_YEL_SK);
	if (tsc == "d_key_bluecard")										return(MC_D_KEY_RED_CR);
	if (tsc == "d_key_redcard")										return(MC_D_KEY_BLU_CR);
	if (tsc == "d_key_yellowcard")									return(MC_D_KEY_YEL_CR);

	if (tsc == "d_ammo_4shell")										return(MC_D_ASHELLS);
	if (tsc == "d_ammo_shellbox")										return(MC_D_ASHELLS_LG);
	if (tsc == "d_ammo_clip")											return(MC_D_ABULLETS);
	if (tsc == "d_ammo_ammobox")										return(MC_D_ABULLETS_LG);
	if (tsc == "d_ammo_1rocket")										return(MC_D_AROCKET);
	if (tsc == "d_ammo_rockbox")										return(MC_D_AROCKETS_LG);
	if (tsc == "d_ammo_cellbox")										return(MC_D_ACELLS);
	if (tsc == "d_ammo_cellpack")										return(MC_D_ACELLS_LG);

	if (tsc == "d_item_pack")											return(MC_D_PACK);
	if (tsc == "d_item_nightvis")										return(MC_D_NIGHTVS);
	if (tsc == "d_item_automap")										return(MC_D_AUTOMAP);

	if (tsc == "d_barrel")												return(MC_D_BARREL);

// wolf
	if (tsc == "w_weapon_pistol")										return(MC_W_PISTOL);
	if (tsc == "w_weapon_machinegun")								return(MC_W_MACHGUN);
	if (tsc == "w_weapon_chaingun")									return(MC_W_CHAINGUN);
	if (tsc == "w_weapon_mortar")										return(MC_W_MORTAR);
	if (tsc == "w_weapon_flamer")										return(MC_W_FLAMER);

// q3 - translates classname for now
//	else if (tsc == "")								return(MC_);

	if (tsc != "dyn_item") // && mc == 0)
	{
		bprint("\b *** item with no map code translation:\n");
		bprint(" -------------->  ");
		bprint(tsc);
		bprint("\n");
	}

	return(0); 

};

// implement for upgrades

void () painkeep_weapon_touch;

/*QUAKED weapon_pulsenail (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_pulsenail =
{
	precache_model ("progs/g_fnail.mdl");
	setmodel (self, "progs/g_fnail.mdl");
	self.weapon = IT_NAILGUN;
	self.netname = "Pulse Rifle";
	self.touch = painkeep_weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
};


// fn(item_by_mcode) - given map code mc, return call string

string (float mc) item_by_mcode =
{
	if (mc == MC_SUPER_SHOTGUN)										return("weapon_supershotgun");
	if (mc == MC_NAILGUN)												return("weapon_nailgun");
	if (mc == MC_SUPER_NAILGUN)										return("weapon_supernailgun");
	if (mc == MC_GRENADEL)												return("weapon_grenadelauncher");
	if (mc == MC_ROCKETL)												return("weapon_rocketlauncher");
	if (mc == MC_THUNDER)												return("weapon_lightning");

	if (mc == MC_PENT)													return("item_artifact_invulnerability");
	if (mc == MC_SUIT)													return("item_artifact_envirosuit");
	if (mc == MC_RING)													return("item_artifact_invisibility");
	if (mc == MC_QUAD)													return("item_artifact_super_damage");

	if (mc == MC_ARMOR1)													return("item_armor1");
	if (mc == MC_ARMOR2)													return("item_armor2");
	if (mc == MC_ARMOR3)													return("item_armorInv");

	if (mc == MC_HEALTHROT)												return("item_health_15");
	if (mc == MC_HEALTH)													return("item_health");
	if (mc == MC_HEALTHMEGA)											return("item_health_mega");

	if (mc == MC_KEY1)													return("item_key1");
	if (mc == MC_KEY2)													return("item_key2");
	if (mc == MC_SIGIL1)													return("item_sigil1");
	if (mc == MC_SIGIL2)													return("item_sigil2");
	if (mc == MC_SIGIL4)													return("item_sigil4");
	if (mc == MC_SIGIL8)													return("item_sigil8");

	if (mc == MC_ASHELLS)												return("item_shells");
	if (mc == MC_ANAILS)													return("item_spikes");
	if (mc == MC_AROCKETS)												return("item_rockets");
	if (mc == MC_ACELLS)													return("item_cells");

	if (mc == MC_ASHELLS_LG)											return("item_shells_lg");
	if (mc == MC_ANAILS_LG)												return("item_spikes_lg");
	if (mc == MC_AROCKETS_LG)											return("item_rockets_lg");
	if (mc == MC_ACELLS_LG)												return("item_cells_lg");

	if (mc == MC_EXPLOD1)												return("misc_explobox");
	if (mc == MC_EXPLOD2)												return("misc_explobox2");

	if (Q_100 || Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
		return("");
	
// pk item subs by special bits
	if (mc == MC_GRAVITY)												return("item_painkeep_gwell");
	if (mc == MC_SENTRY)													return("item_painkeep_turret");
	if (mc == MC_BEARTRAP)												return("item_painkeep_beartrap");
	if (mc == MC_AEXPLSH)												return("item_painkeep_expshells");
	if (mc == MC_CHTHUNDR)												return("weapon_chainlg");
	if (mc == MC_PULSE_NAILGUN)										return("weapon_pulsenail");
	if (mc == MC_GRAP)													return("weapon_grapgun");
	if (mc == MC_AIRGUN)													return("weapon_airfist");
	if (mc == MC_CANOBEANS)												return("item_painkeep_can");

//	if (!PK_ART) return(""); // Cataboligne 8.12.9 purify - pk artifacts
	if (mc == MC_EGO)														return("item_pkplus_ego");
	if (mc == MC_TOMB)													return("item_pkplus_tomb");
	if (mc == MC_MASK)													return("item_pkplus_actor");
	if (mc == MC_PHONE)													return("item_pkplus_phone");

// doom
	if (mc == MC_D_SHOTGUN)												return("d_weapon_shotgun");
	if (mc == MC_D_BOOMSTICK)											return("d_weapon_supershotgun");
	if (mc == MC_D_CHAINGUN)											return("d_weapon_chaingun");
	if (mc == MC_D_ROCKETL)												return("d_weapon_rocketlauncher");
	if (mc == MC_D_PLASMA)												return("d_weapon_plasma");
	if (mc == MC_D_BFG)													return("d_weapon_bfg");
	if (mc == MC_D_SAW)													return("d_weapon_saw");
	if (mc == MC_D_PISTOL)												return("d_weapon_pistol");

	if (mc == MC_D_BERS)													return("d_art_berserker");
	if (mc == MC_D_INVUL)												return("d_art_invulnerable");
	if (mc == MC_D_INVIS)												return("d_art_invisible");
	if (mc == MC_D_RADSUIT)												return("d_art_radsuit");
	if (mc == MC_D_SOULSPH)												return("d_art_soulsphere");
	if (mc == MC_D_MEGASPH)												return("d_art_megasphere");

	if (mc == MC_D_ARM_SPR)												return("d_item_spiritarmor");
	if (mc == MC_D_ARM_GRN)												return("d_item_armorgreen");
	if (mc == MC_D_ARM_BLU)												return("d_item_armorblue");

	if (mc == MC_D_HBOTTLE)												return("d_item_healthbottle");
	if (mc == MC_D_STIMPAK)												return("d_item_healthstimpak");
	if (mc == MC_D_MEDKIT)												return("d_item_healthmedkit");

	if (mc == MC_D_KEY_RED_SK)											return("d_key_redskull");
	if (mc == MC_D_KEY_BLU_SK)											return("d_key_blueskull");
	if (mc == MC_D_KEY_YEL_SK)											return("d_key_yellowskull");
	if (mc == MC_D_KEY_RED_CR)											return("d_key_redcard");
	if (mc == MC_D_KEY_BLU_CR)											return("d_key_bluecard");
	if (mc == MC_D_KEY_YEL_CR)											return("d_key_yellowcard");

	if (mc == MC_D_ASHELLS)												return("d_ammo_4shell");
	if (mc == MC_D_ASHELLS_LG)											return("d_ammo_shellbox");
	if (mc == MC_D_ABULLETS)											return("d_ammo_clip");
	if (mc == MC_D_ABULLETS_LG)										return("d_ammo_ammobox");
	if (mc == MC_D_AROCKET)												return("d_ammo_1rocket");
	if (mc == MC_D_AROCKETS_LG)										return("d_ammo_rockbox");
	if (mc == MC_D_ACELLS)												return("d_ammo_cellbox");
	if (mc == MC_D_ACELLS_LG)											return("d_ammo_cellpack");

	if (mc == MC_D_PACK)													return("d_item_pack");
	if (mc == MC_D_NIGHTVS)												return("d_item_nightvis");
	if (mc == MC_D_AUTOMAP)												return("d_item_automap");

	if (mc == MC_D_BARREL)												return("d_barrel");

// wolf
	if (mc == MC_W_PISTOL)												return("w_weapon_pistol");
	if (mc == MC_W_MACHGUN)												return("w_weapon_machinegun");
	if (mc == MC_W_CHAINGUN)											return("w_weapon_chaingun");
	if (mc == MC_W_MORTAR)												return("w_weapon_mortar");
	if (mc == MC_W_FLAMER)												return("w_weapon_flamer");

//	if (mc == MC_) return("item_");

	return("");
};

// TDO: expand fn - handle chaos items, non respawnables, provide location area

// fn_make - make an item from map code value


void(float mc, vector vo) fn_make =
{
	local string sc;
	local entity e, sv;
	local vector v1;

	sv = self;
	sc = item_by_mcode(mc);

	self = spawn();

 if (sc != "")
 {
	v1 = vo;
  if (vo == v0) // no origin sent, get random one around some other object
  {	  
	e = dyn_rndloc();
	if (!e) e = findradius(world.origin, 256000);
	if (!e) 
	{
		if (WARNING) bprint("*** warning: fn_make could not find a random (or any) location - giving up\n");
		return; // crap - no location
	}
	v1 = e.origin + ' 0 0 16';
	if (e.flags & FL_ITEM) // randomize away from other map items
		v1 = stdv_rndloc(e.origin + ' 0 0 16', 50, 100);
  }

	self.wad = sc;

	setorigin(self, v1);
	item_call(sc);

	self.velocity_z = 300 + 100 * random();
	self.velocity_x = -170 + (random() * 340);
	self.velocity_y = -170 + (random() * 340);

	if (self.map == "rune") self.map = ""; // rune server deal

	bprint("\b*** fn_make item spawned: ");
	bprint(self.wad);
	if (e)
	{
	bprint(" near: ");
	bprint(e.classname);
	}
	else
	bprint(" on the map");
	bprint("\n");

	self = sv;

 }
	else
	{
	bprint("\b *** map code with no item translation:\n");
	bprint(" -------------->  ");
	bprint(ftos(mc));
	bprint("\n");
	}
};

// func_make handles map call - set wait to valid map code

void() func_make =
{
	local float d, f;

	if (self.spawnflags & 1) self.origin = v0;

	d = self.wait;
	f = MC_RNDITM;
	if (RUNES && self.wait == -1) f = MC_NR_RNDITM; // dont rndize runes if server on
	if (self.wait == -1 || self.wait == -2) d = 102 + rint(random() * f);

	f = MC_PK_RNDITM;
	if (PK_ART || self.wait == -4) f = MC_PKP_RNDITM;
	if (self.wait == -3 || self.wait == -4) d = 141 + rint(random() * f);

	f = MC_T_RNDITM;
	if (self.wait == -5)
	{
		d = 102 + rint(random() * f);
		if (self.wait >= MC_Q1) d = d + MC_TRNSUB; // gap q1 to pk
	}

	fn_make(d, self.origin);

	if (self.count > 0)
	{
		if (self.count > 0)
		if (self.delay < 1) self.delay = 30;
	
		if (self.count < 1) self.delay = 0;

		self.count = self.count - 1;
	}

	if (self.delay > 0)
	{
		self.nextthink = time + self.delay;
		self.think = func_make;
	}
};
