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

//float MIN_ITEM					= 100;
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
float MC_RNDITM				= 32;		// # of q1 items - have to change as items changes
float MC_NR_RNDITM			= 28;		//   no runes

float MC_SIGIL					= 135;

float MC_BACKPACK				= 135;

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
float MC_TRNSUB				= 6;		// skip from q1 - pk

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

float MC_D_RNDITM				= 38;		// # of total items

/// wolf 3d

float MC_W_KNIFE				= 199;
float MC_W_PISTOL				= 200;
float MC_W_MACHGUN			= 201;
float MC_W_CHAINGUN			= 202;
float MC_W_MORTAR				= 203;
float MC_W_FLAMER				= 204;
float MC_W_CLIP				= 205;
float MC_W_KEY_G				= 206;
float MC_W_KEY_B				= 207;
float MC_W_BARREL				= 208;

float MC_W_RNDITM				= 9;		// # of total items

// fn(bit_mcode) - item bit assoc with given mcode

float(float mcv, entity e) bit_mcode =
{
	local float mc;

	mc = mcv;
	if (!mc && e) mc = e.mcode;
	if (!mc) return(0);
	
	if (mc == MC_AXE)														return(IT_AXE);
	if (mc == MC_SHOTGUN)												return(IT_SHOTGUN);
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

	if (mc == MC_W_KNIFE)												return(IT_AXE);
	if (mc == MC_W_PISTOL)												return(IT_SHOTGUN);
	if (mc == MC_W_MACHGUN)												return(IT_NAILGUN);
	if (mc == MC_W_CHAINGUN)											return(IT_SUPER_NAILGUN);
	if (mc == MC_W_MORTAR)												return(IT_ROCKET_LAUNCHER);
	if (mc == MC_W_FLAMER)												return(IT_GRENADE_LAUNCHER);
//	if (mc == MC_W_CLIP)													return(IT_BULLETS);

	if (mc == MC_W_KEY_G)												return(IT_KEY1);
	if (mc == MC_W_KEY_B)												return(IT_KEY2);
	if (mc == MC_W_BARREL)												return(0);

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
		if (tsc == "item_keyX")
		{
			if (e.items == IT_KEY1)											return(MC_KEY1);
			if (e.items == IT_KEY2)											return(MC_KEY2);
		}
		if (tsc == "w_key")
		{
			if (e.spawnflags & 1)											return(MC_W_KEY_G);
			if (e.spawnflags & 2)											return(MC_W_KEY_B);
		}
	}

	if (tsc == "weapon_axe")											return(MC_AXE);
	if (tsc == "weapon_shotgun")										return(MC_SHOTGUN);
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
	if (tsc == "w_weapon_knife")										return(MC_W_KNIFE);
	if (tsc == "w_weapon_pistol")										return(MC_W_PISTOL);
	if (tsc == "w_weapon_machinegun")								return(MC_W_MACHGUN);
	if (tsc == "w_weapon_chaingun")									return(MC_W_CHAINGUN);
	if (tsc == "w_weapon_mortar")										return(MC_W_MORTAR);
	if (tsc == "w_weapon_flamer")										return(MC_W_FLAMER);
	if (tsc == "w_ammo_clip")											return(MC_W_CLIP);
	if (tsc == "w_key_g")												return(MC_W_KEY_G);
	if (tsc == "w_key_b")												return(MC_W_KEY_B);
	if (tsc == "w_barrel")												return(MC_W_BARREL);


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


// fn(item_by_mcode) - given map code mc, return call string

string (float mc) item_by_mcode =
{
	if (mc == MC_AXE)														return("weapon_axe");
	if (mc == MC_SHOTGUN)												return("weapon_shotgun");
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
	if (mc == MC_W_KNIFE)												return("w_weapon_knife");
	if (mc == MC_W_PISTOL)												return("w_weapon_pistol");
	if (mc == MC_W_MACHGUN)												return("w_weapon_machinegun");
	if (mc == MC_W_CHAINGUN)											return("w_weapon_chaingun");
	if (mc == MC_W_MORTAR)												return("w_weapon_mortar");
	if (mc == MC_W_FLAMER)												return("w_weapon_flamer");

	if (mc == MC_W_CLIP)													return("w_ammo_clip");
	if (mc == MC_W_KEY_G)												return("w_key_g");
	if (mc == MC_W_KEY_B)												return("w_key_b");
	if (mc == MC_W_BARREL)												return("w_barrel");


//	if (mc == MC_) return("item_");

	return("");
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

// axe attack - assumes player frames

void() fire_axe =
{
	local float r;

	sound (self, CHAN_WEAPON, self.noise1, 1, ATTN_NORM);
	r = random();
	if (r < 0.25)
	  player_axe1 ();
	else if (r<0.5)
	  player_axeb1 ();
	else if (r<0.75)
	  player_axec1 ();
	else
	  player_axed1 ();
};

/*QUAKED weapon_axe (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_axe =
{
	self.touch = weapon_touch;
	self._attack = SUB_Null;
	self._fr_attack = fire_axe;

	self.currentammo = 0;
	self.items = IT_AXE;
	self.weaponframe = AMMO_NONE;
	self.attack_finished = 0.5;
	self.dmg_save = 0;

	self.netname = "War Axe";
	precache_model ("progs/g_axe.mdl");
	precache_model ("progs/v_axe.mdl");
	precache_model ("progs/vw_axe.mdl");
	setmodel (self,"progs/g_axe.mdl");
	self.weaponmodel = "progs/v_axe.mdl";
	self.vwepmdl = "progs/vw_axe.mdl";
	self.noise1 = "weapons/ax1.wav"; // missed
	self.noise3 = "player/axhit2.wav"; // hit wall &| solid
//	self.noise4 = "zombie/z_hit.wav"; // hit flesh

	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
};

/*QUAKED weapon_shotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () q100_weapon_shotgun =
{
	self.touch = weapon_touch;
	self._attack = W_FireShotgun;
	self._fr_attack = player_shot1;

	self.currentammo = 25;
	self.items = IT_SHOTGUN;
	self.weaponframe = AMMO_SHELLS;
	self.attack_finished = 0.5;
	self.dmg_save = 1;

	self.netname = "Shotgun";
	precache_model ("progs/shotgun.mdl");
	precache_model ("progs/v2_shot.mdl");
	precache_model ("progs/vw_shot.mdl");
	setmodel (self, "progs/shotgun.mdl");
	self.weaponmodel = "progs/v2_shot.mdl";
	self.vwepmdl = "progs/vw_shot.mdl";
//	self.noise1 = "weapons/ax1.wav"; // missed
	self.noise3 = "weapons/guncock.wav"; 

	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
};

void () weapon_shotgun =
{
	if (world.wad == "q2.wad")
	{
		q2_weapon_shotgun();
		return;
	}
	else if (world.wad == "")
	{
		q3_weapon_shotgun(); 
		return;
	}

	q100_weapon_shotgun();
};

// all quake 1 key load outs

/*QUAKED item_keyX (0 .5 .8) (-16 -16 -24) (16 16 32)

Any key on any map!

cnt - key code

GOLD key = 20
SILVER key = 10

		+

0: medieval
1: metal
2: base
*/

void (float ksv) item_keyX =
{
	float ks;

	ks = ksv;
	if (self.cnt) ks = self.cnt;

	if (ks == 10)
	{
		setmodel (self,"progs/w_s_key.mdl");
		self.netname = "silver key";
		self.items = IT_KEY1;
	}
	else if (ks == 11)
	{
		setmodel (self,"progs/m_s_key.mdl");
		self.netname = "silver runekey";
		self.items = IT_KEY1;
	}
	else if (ks == 12)
	{
		setmodel (self,"progs/b_s_key.mdl");
		self.netname = "silver keycard";
		self.items = IT_KEY1;
	}
	else if (ks == 20)
	{
		setmodel (self,"progs/w_g_key.mdl");
		self.netname = "gold key";
		self.items = IT_KEY2;
	}
	else if (ks == 21)
	{
		setmodel (self,"progs/m_g_key.mdl");
		self.netname = "gold runekey";
		self.items = IT_KEY2;
	}
	else if (ks == 22)
	{
		setmodel (self,"progs/b_g_key.mdl");
		self.netname = "gold keycard";
		self.items = IT_KEY2;
	}
	else
	{
		setmodel (self,"progs/w_s_key.mdl");
		self.netname = "silver key";
		self.items = IT_KEY1;
	}
	if (ks == 10 || ks == 20)
	{
		self.noise = "misc/medkey.wav";
	}
	else if (ks == 11 || ks == 21)
	{
		self.noise = "misc/runekey.wav";
	}
	else if (ks == 12 || ks == 22)
	{
		self.noise = "misc/basekey.wav";
	}
	else
	{
		self.noise = "misc/medkey.wav";
	}
	self.touch = key_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
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

	if (Q_100 || PK_100)
	{
		remove(self);
		return;
	}

	if (self.spawnflags & 1) self.origin = v0;

	d = self.wait;
	f = MC_RNDITM;
	if (RUNES && self.wait == -1) f = MC_NR_RNDITM; // dont rndize runes if server on
	if (self.wait == -1 || self.wait == -2) d = 102 + rint(random() * f);

	if (!Q_99)
	{
		f = MC_PK_RNDITM;
		if (PK_ART || self.wait == -4) f = MC_PKP_RNDITM;
		if (self.wait == -3 || self.wait == -4) d = 141 + rint(random() * f);
	}

	f = MC_T_RNDITM;
	if (self.wait == -5)
	{
		if (Q_99) f = MC_NR_RNDITM;
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


// mcode for barrels

void(entity e, string md, float dm, float hl, float mt) misc_explodbox_set;


// fn(barrel_regen) - heh heh, respawn exploding boxes

void() barrel_regen =
{
	SUB_regen();
	if (self.model == "progs/barrel.mdl")
		d_barrel();
	else
		misc_explodbox_set(self, self.mdl, self.currentammo, self.armorvalue, self.movetype);
};


void() barrel_explode =
{
	local entity boombox, e;
	local vector flg;
	local float bdmg;
	local string bsnd;

	self.mdl = self.model;
	self.solid = SOLID_NOT;
//	if (self.classname == "chaos_item" && random() > CI_EXPLBOX_RES)
//		self.think = SUB_Remove;
//	else
	if (EXPLBOX_RESP)
	{
		self.nextthink = time + RSP_TIME;
		self.think = barrel_regen;
	}
	else
		SUB_Remove();

	boombox = spawn();
	boombox.origin = self.origin;
	
	self.model = string_null;
	bdmg = self.currentammo;
	bsnd = self.noise;
	self.takedamage = DAMAGE_NO;

	self = boombox;
	e = world;
	if (self.classname == "chaos_item") e = self.owner;

	self.takedamage = DAMAGE_NO;
	self.classname = "explo_box";

	sound (self, CHAN_VOICE, bsnd, 1, ATTN_NORM);
	particle (self.origin, '0 0 0', 75, 255);
	self.origin_z = self.origin_z + 32;
//	Explode(0, bdmg, e, 0, 0, BecomeExplosion);
	T_RadiusDamage (self,self,bdmg,world);
	BecomeExplosion ();
};



// Chaos code
// fn(misc_explobox_set) - set data for explode box...dang, can we get a doom barrel? - enhanced for chaos items as noted below
// e - entity to set, create if null
// md - string for model 					def: "maps/b_exbox2.bsp" (yes this could be _anything_)
// dm - damage for explosion				def: 100
// hl - health of box						def: 20
// mt - move type

void(entity e, string md, float dm, float hl, float mt) misc_explodbox_set =
{
	local float	oldz;

//	map_precache();
	precache_model ("maps/b_explob.bsp");
	precache_model ("maps/b_exbox2.bsp");
	precache_sound ("weapons/r_exp3.wav");

//	if (e == world) e = spawn();
	if (e == world) return;

//	e.class_select = "class_explosive";
	e.solid = SOLID_BBOX;
	e.movetype = mt; // FIX - this would be why an explodbox cant be picked up

	if (md != "")
	{
		setmodel (e, md);
		e.mdl = md;
	}
	else
	{
		setmodel (e, "maps/b_exbox2.bsp");
		e.mdl = "maps/b_exbox2.bsp";
	}

	if (hl > 0)
		e.health = hl;
	else
		e.health = 20;
	e.armorvalue = e.health; // for respawns

	if (dm > 0)
		e.currentammo = dm;
	else
		e.currentammo = 100;

	e.th_die = barrel_explode;
	e.takedamage = DAMAGE_AIM;
	e.noise = "weapons/r_exp3.wav";

//	if (map_load_flg | FL_MAPITEM) // loading on map
//	{
	e.origin_z = e.origin_z + 2;
	oldz = e.origin_z;
	droptofloor(0,0); // Cataboligne 9.17.3 - fixed this compiler warning
	if (oldz - e.origin_z > 250)
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
//	map_load_flg = map_load_flg - (map_load_flg | FL_MAPITEM);
//	}
	pic_test();

	if (!PK_100 && !Q_100)
	if (self.wad == "q1")
		master_item_control(self, 0);
};


/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)
TESTING THING
*/

void () misc_explobox =
{
	local float oldz;

	if (Q_100)
	{
		q100_misc_explobox();
		return;
	}

	misc_explodbox_set(self, "maps/b_explob.bsp", 160, 20, MOVETYPE_NONE);
};

/*QUAKED misc_explobox2 (0 .5 .8) (0 0 0) (32 32 64)
Smaller exploding box, REGISTERED ONLY
*/

void () misc_explobox2 =
{
	local float oldz;

	if (Q_100)
	{
		q100_misc_explobox2();
		return;
	}

	misc_explodbox_set(self, "maps/b_exbox2.bsp", 160, 20, MOVETYPE_NONE);
};
