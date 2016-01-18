/* ::-::
 *
 * Cataboligne
 *
 * file: pk_itm_translate.qc
 *
 * date: 6/17/10
 *
 * qc - support painkeep 2.0 map item translation
 *
 */

// started map pk100

// TDO: finish translate codes
// TDO: restore wad == "q1" item with doom item deactivate / pk_100 mode on (if ever allowed in map)

// need to hide something from players & item controls

void(entity e) hide_item =
{
	setmodel (e,"");
	e.th_stand = e.touch;
	e.touch = SUB_Null;
	e.path = e.map;
	if (e.map == "pic_item") e.map = "repic"; // hide from pic, allow restore
};

string(entity e, float TR) map_trans =
{
	local float dr, wr, qr, q2r, q3r;
	local string mc, mcd, mcw, mcq, mcq2, mcq3, mcg;

	if (TR == FL_TR_RANDIN || TR_NOT == FL_NOTRN_RNDIN)
	{
		wr = MC_W_KNIFE + floor(random() * (MC_W_RNDITM));
		dr = MC_D_SAW + floor(random() * (MC_D_RNDITM - 1));
		qr = MC_AXE + floor(random() * (MC_RNDITM + 2));
		if (RUNES) qr = MC_AXE + floor(random() * (MC_NR_RNDITM));

		q2r = MC_Q2_BLASTER + rint(random() * MC_Q2_RNDITM);
		q3r = MC_Q3_GAUNTLET + rint(random() * MC_Q3_RNDITM);

		mcd = item_by_mcode(dr);
		mcw = item_by_mcode(wr);
		mcq = item_by_mcode(qr);
		mcq2 = item_by_mcode(q2r);
		mcq3 = item_by_mcode(q3r);

// rnd in genre if either flag set
		if (e.scode >= MC_W_KNIFE && e.scode <= MC_W_BARREL) mcg = mcw;
		else if (e.scode >= MC_D_SAW && e.scode <= MC_D_BARREL) mcg = mcd;
		else if (e.scode >= MC_AXE && e.scode <= MC_SIGIL8) mcg = mcq;
		else if (e.scode >= MC_Q2_BLASTER && e.scode <= MC_Q2_BARREL) mcg = mcq2;
		else if (e.scode >= MC_Q3_GAUNTLET && e.scode <= MC_Q3_HOLDTELE) mcg = mcq3;
	}
	else if (TR == FL_TR_RANDOM || TR_NOT == FL_NOTRN_RNDANY)
	{
		qr = MC_AXE + floor(random() * (MC_TOT));
		mcg = item_by_mcode(qr);
		if (TR == FL_TR_RANDOM)
		if (!RUNES || e.map != "rune") // ignore runes if server on
			return(mcg);
		mcd = mcw = mcq = mcq2 = mcq3 = mcg;
		}


	if (TR == FL_TR_RESTORE)
	{
		mc = item_by_mcode(e.scode);
		if (mc != "")
			return(mc);
		else
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG) return("");
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcg);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
	}

/// multi genre!
	if (e.scode == MC_D_BFG || e.scode == MC_CHTHUNDR || e.scode == MC_Q2_BFG || e.scode == MC_Q3_BFG)
	{
		if (TR == FL_TR_WOLF)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.25)
					return("w_weapon_chaingun"); // most powerful wolf wep is prob dual chg
				else if (random() > 0.5)
					return("w_weapon_flamer");
				else
					return("w_weapon_motar");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_weapon_bfg");
		if (TR == FL_TR_QUAKE) return("weapon_chainlg"); // IDEA: poss. dynamo?
		if (TR == FL_TR_Q2) return("q2_weapon_bfg");
		if (TR == FL_TR_Q3) return("q3_weapon_bfg");
		if (TR == FL_TR_RANDIN) return(mcd);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ROCKETL || e.scode == MC_W_MORTAR || e.scode == MC_ROCKETL || e.scode == MC_Q2_ROCKETL || e.scode == MC_Q3_ROCKETL)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_mortar");
		if (TR == FL_TR_DOOM) return("d_weapon_rocketlauncher");
		if (TR == FL_TR_QUAKE) return("weapon_rocketlauncher");
		if (TR == FL_TR_Q2) return("q2_weapon_rocketlauncher");
		if (TR == FL_TR_Q3) return("q3_weapon_rocketlauncher");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_GRENADEL || e.scode == MC_Q2_GRENADEL || e.scode == MC_Q3_GRENADEL)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_mortar");
		if (TR == FL_TR_DOOM) return("d_weapon_rocketlauncher");
		if (TR == FL_TR_QUAKE) return("weapon_grenadelauncher");
		if (TR == FL_TR_Q2) return("q2_weapon_grenadelauncher");
		if (TR == FL_TR_Q3) return("q3_weapon_grenadelauncher");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_PLASMA || e.scode == MC_W_FLAMER || e.scode == MC_THUNDER || e.scode == MC_Q2_HYPBLASTER || e.scode == MC_Q3_PLASMA)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_flamer");
		if (TR == FL_TR_DOOM) return("d_weapon_plasma");
		if (TR == FL_TR_QUAKE) return("weapon_lightning");
		if (TR == FL_TR_Q2) return("weapon_hyperblaster");
		if (TR == FL_TR_Q3) return("weapon_plasmagun");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_CHAINGUN || e.scode == MC_W_CHAINGUN || e.scode == MC_SUPER_NAILGUN || e.scode == MC_Q2_CHAINGUN || e.scode == MC_Q3_MACHINEGUN)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_chaingun");
		if (TR == FL_TR_DOOM) return("d_weapon_chaingun");
		if (TR == FL_TR_QUAKE) return("weapon_supernailgun");
		if (TR == FL_TR_Q2) return("q2_weapon_chaingun"); // NOTE: has unique name
		if (TR == FL_TR_Q3) return("q3_weapon_machinegun");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_BOOMSTICK || e.scode == MC_SUPER_SHOTGUN || e.scode == MC_Q2_DBLSHOTGUN || e.scode == MC_Q3_SHOTGUN)
	{
		if (TR == FL_TR_WOLF)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.25)
					return("w_weapon_machinegun");
				else if (random() > 0.25)
					return("w_weapon_pistol");
				else
					return("w_weapon_chaingun");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_weapon_supershotgun");
		if (TR == FL_TR_QUAKE) return("weapon_supershotgun");
		if (TR == FL_TR_Q2) return("q2_weapon_supershotgun");
		if (TR == FL_TR_Q3) return("q3_weapon_shotgun");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_SHOTGUN || e.scode == MC_SHOTGUN || e.scode == MC_Q2_SHOTGUN || e.scode == MC_Q3_SHOTGUN)
	{
		if (TR == FL_TR_WOLF)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.20)
					return("w_weapon_machinegun");
				else if (random() > 0.25)
					return("w_weapon_pistol");
				else
					return("w_weapon_chaingun");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_weapon_shotgun");
		if (TR == FL_TR_QUAKE) return("weapon_shotgun");
		if (TR == FL_TR_Q2) return("q2_weapon_shotgun");
		if (TR == FL_TR_Q3) return("q3_weapon_shotgun"); // IDEA: need bg code here?
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_W_MACHGUN || e.scode == MC_NAILGUN)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_machinegun");
		if (TR == FL_TR_DOOM) return("d_weapon_supershotgun");
		if (TR == FL_TR_QUAKE) return("weapon_nailgun");
		if (TR == FL_TR_Q2) return("q2_weapon_machinegun");
		if (TR == FL_TR_Q3) return("q3_weapon_machinegun"); // IDEA: need bg code here?
		if (TR == FL_TR_RANDIN) return(mcw);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_W_PISTOL || e.scode == MC_D_PISTOL || e.scode == MC_SHOTGUN || e.scode == MC_Q2_BLASTER)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_pistol");
		if (TR == FL_TR_DOOM) return("d_weapon_pistol");
		if (TR == FL_TR_QUAKE) return("weapon_shotgun");
		if (TR == FL_TR_Q2) return("q2_blaster");
		if (TR == FL_TR_Q3) return("weapon_gauntlet");
		if (TR == FL_TR_RANDIN) return(mcw);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_SAW || e.scode == MC_W_KNIFE || e.scode == MC_AXE || e.scode == MC_Q3_GAUNTLET)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_knife");
		if (TR == FL_TR_DOOM) return("d_weapon_saw");
		if (TR == FL_TR_QUAKE) return("weapon_axe");
		if (TR == FL_TR_Q2) return("q2_weapon_blaster");
		if (TR == FL_TR_Q3) return("weapon_gauntlet");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ASHELLS || e.scode == MC_ASHELLS || e.scode == MC_Q2_ASHELLS || e.scode == MC_Q3_ASHELLS)
	{
		if (TR == FL_TR_WOLF) return("w_clip"); // IDEA: need bg code here?
		if (TR == FL_TR_DOOM) return("d_ammo_4shell");
		if (TR == FL_TR_QUAKE) return("item_shells");
		if (TR == FL_TR_Q2) return("q2_ammo_shells");
		if (TR == FL_TR_Q3) return("q3_ammo_shells");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ASHELLS_LG || e.scode == MC_ASHELLS_LG)
	{
		if (TR == FL_TR_WOLF) return("w_clip");
		if (TR == FL_TR_DOOM) return("d_ammo_shellbox");
		if (TR == FL_TR_QUAKE) return("item_shells_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_shells");
		if (TR == FL_TR_Q3) return("q3_ammo_shells");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ACELLS || e.scode == MC_ACELLS)
	{
		if (TR == FL_TR_WOLF) return("w_ammo_gas");
		if (TR == FL_TR_DOOM) return("d_ammo_cellpack");
		if (TR == FL_TR_QUAKE) return("item_cells");
		if (TR == FL_TR_Q2) return("q2_ammo_cells");
		if (TR == FL_TR_Q3) return("q3_ammo_cells");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ACELLS_LG || e.scode == MC_ACELLS_LG || e.scode == MC_W_GAS)
	{
		if (TR == FL_TR_WOLF) return("w_ammo_gas");
		if (TR == FL_TR_DOOM) return("d_ammo_cellbox");
		if (TR == FL_TR_QUAKE) return("item_cells_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_cells");
		if (TR == FL_TR_Q3) return("q3_ammo_cells");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_AROCKET || e.scode == MC_AROCKETS || e.scode == MC_Q2_AROCKETS || e.scode == MC_Q3_AROCKETS)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_mortar");
		if (TR == FL_TR_DOOM) return("d_ammo_1rocket");
		if (TR == FL_TR_QUAKE) return("item_rockets");
		if (TR == FL_TR_Q2) return("q2_ammo_rockets");
		if (TR == FL_TR_Q3) return("q3_ammo_rockets");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_AROCKETS_LG || e.scode == MC_AROCKETS_LG)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_mortar");
		if (TR == FL_TR_DOOM) return("d_ammo_rockbox");
		if (TR == FL_TR_QUAKE) return("item_rockets_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_rockets");
		if (TR == FL_TR_Q3) return("q3_ammo_rockets");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ABULLETS || e.scode == MC_ANAILS)
	{
		if (TR == FL_TR_WOLF) return("w_clip");
		if (TR == FL_TR_DOOM) return("d_ammo_clip");
		if (TR == FL_TR_QUAKE) return("item_spikes");
		if (TR == FL_TR_Q2) return("q2_ammo_bullets");
		if (TR == FL_TR_Q3) return("q3_ammo_bullets");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ABULLETS_LG || e.scode == MC_ANAILS_LG || e.scode == MC_Q2_ABULLETS || e.scode == MC_Q3_ABULLETS)
	{
		if (TR == FL_TR_WOLF) return("w_clip");
		if (TR == FL_TR_DOOM) return("d_ammo_ammobox");
		if (TR == FL_TR_QUAKE) return("item_spikes_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_bullets");
		if (TR == FL_TR_Q3) return("q3_ammo_bullets");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_SOULSPH || e.scode == MC_HEALTHMEGA || e.scode == MC_Q2_MEGA || e.scode == MC_Q3_MEGA)
	{
		if (TR == FL_TR_WOLF) return("w_face_sphere");
		if (TR == FL_TR_DOOM) return("d_art_soulsphere");
		if (TR == FL_TR_QUAKE) return("item_health_mega");
		if (TR == FL_TR_Q2) return("q2_item_health_mega");
		if (TR == FL_TR_Q3) return("q3_item_health_mega");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_W_HEALTH || e.scode == MC_D_MEDKIT || e.scode == MC_HEALTH || e.scode == MC_Q2_MEDKIT || e.scode == MC_Q3_HLARGE)
	{
		if (TR == FL_TR_WOLF) return("w_heal_medkit");
		if (TR == FL_TR_DOOM) return("d_item_healthmedkit");
		if (TR == FL_TR_QUAKE) return("item_health");
		if (TR == FL_TR_Q2) return("q2_item_health_large");
		if (TR == FL_TR_Q3) return("q3_item_health_large");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_STIMPAK || e.scode == MC_HEALTHROT || e.scode == MC_Q2_FIRSTAID || e.scode == MC_Q3_HEALTH)
	{
		if (TR == FL_TR_WOLF) return("");
		if (TR == FL_TR_DOOM) return("d_item_healthstimpak");
		if (TR == FL_TR_QUAKE) return("item_health_15");
		if (TR == FL_TR_Q2) return("q2_item_health_large");
		if (TR == FL_TR_Q3) return("q3_item_health_large");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_HBOTTLE || e.scode == MC_Q2_STIMPAK || e.scode == MC_Q3_HSMALL)
	{
		if (TR == FL_TR_WOLF) return(""); // TDO: blood (gibs) - dog food
		if (TR == FL_TR_DOOM) return("d_item_healthbottle");
		if (TR == FL_TR_QUAKE) return("");
		if (TR == FL_TR_Q2) return("q2_item_health_small");
		if (TR == FL_TR_Q3) return("q3_item_health_small");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ARM_SPR || e.scode == MC_Q2_ARM_SHARD || e.scode == MC_Q3_ARM_SHARD)
	{
		if (TR == FL_TR_WOLF)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return("");
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_item_spiritarmor");
		if (TR == FL_TR_QUAKE)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return("");
			return("");
		}
		if (TR == FL_TR_Q2) return("q2_item_armor_shard");
		if (TR == FL_TR_Q3) return("q3_item_armor_shard");
		if (TR == FL_TR_RANDIN) return(mcd);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ARM_BLU || e.scode == MC_ARMOR3 || e.scode == MC_Q2_ARM_BODY || e.scode == MC_Q3_ARM_BODY)
	{
		if (TR == FL_TR_WOLF)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return("");
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_item_armorblue");
		if (TR == FL_TR_QUAKE) return("item_armorInv");
		if (TR == FL_TR_Q2) return("q2_item_armor_body");
		if (TR == FL_TR_Q3) return("q3_item_armor_body");
		if (TR == FL_TR_RANDIN) return(mcd);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ARM_GRN || e.scode == MC_ARMOR1 || e.scode == MC_Q2_ARM_COMBAT || e.scode == MC_Q3_ARM_COMBAT)
	{
		if (TR == FL_TR_WOLF)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return("");
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_item_armorgreen");
		if (TR == FL_TR_QUAKE) return("item_armor2");
		if (TR == FL_TR_Q2) return("q2_item_armor_combat");
		if (TR == FL_TR_Q3) return("q3_item_armor_combat");
		if (TR == FL_TR_RANDIN) return(mcd);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_BERS || e.scode == MC_QUAD || e.scode == MC_Q2_QUAD || e.scode == MC_Q3_QUAD)
	{
		if (TR == FL_TR_WOLF)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("w_art_facesphere");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return("");
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_art_berserker");
		if (TR == FL_TR_QUAKE) return("item_artifact_super_damage");
		if (TR == FL_TR_Q2) return("q2_item_quad");
		if (TR == FL_TR_Q3) return("q3_item_quad");
		if (TR == FL_TR_RANDIN) return(mcd);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_INVUL || e.scode == MC_PENT || e.scode == MC_Q2_INVUL)
	{
		if (TR == FL_TR_WOLF)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("w_art_facesphere");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return("");
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_art_invulnerable");
		if (TR == FL_TR_QUAKE) return("item_artifact_invulnerability");
		if (TR == FL_TR_Q2) return("item_invulnerability");
		if (TR == FL_TR_Q3)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.4)
					return("item_regen");
				else
					return("q3_item_enviro");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq3);
			else if (TR_NOT == FL_NOTRN_RNDANY) return("");
			return("");
		}
		if (TR == FL_TR_RANDIN) return(mcd);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_INVIS || e.scode == MC_RING|| e.scode == MC_Q2_SILENCE || e.scode == MC_Q3_INVIS)
	{
		if (TR == FL_TR_WOLF)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("w_item_pack");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return("");
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_art_invisible");
		if (TR == FL_TR_QUAKE) return("item_artifact_invisibility");
		if (TR == FL_TR_Q2) return("item_silencer");
		if (TR == FL_TR_Q3) return("item_invis");
		if (TR == FL_TR_RANDIN) return(mcd);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_RADSUIT || e.scode == MC_SUIT || e.scode == MC_Q2_ENVIRO || e.scode == MC_Q3_ENVIRO)
	{
		if (TR == FL_TR_WOLF)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("w_item_pack");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return("");
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_art_radsuit");
		if (TR == FL_TR_QUAKE) return("item_artifact_envirosuit");
		if (TR == FL_TR_Q2) return("q2_item_enviro");
		if (TR == FL_TR_Q3) return("q3_item_enviro");
		if (TR == FL_TR_RANDIN) return(mcd);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
/// doom
/// wolf
/// q2
/// q3
	else if (e.scode == MC_Q3_ALIGNTNING)
	{
		if (TR == FL_TR_WOLF) return("w_ammo_gas");
		if (TR == FL_TR_DOOM) return("d_ammo_cellbox");
		if (TR == FL_TR_QUAKE) return("item_cells_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_cells");
		if (TR == FL_TR_Q3) return("ammo_lightning");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_Q3_ABFG)
	{
		if (TR == FL_TR_WOLF) return("w_ammo_gas");
		if (TR == FL_TR_DOOM) return("d_ammo_cellbox");
		if (TR == FL_TR_QUAKE) return("item_cells_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_cells");
		if (TR == FL_TR_Q3) return("ammo_bfg");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	return("");
};

void(entity e, float trvs) item_translate =
{
	local string mcc;
	local entity f;
	local float k;

	k = trvs;
	if (TR_ALL > 0) k = TR_ALL;
	mcc = map_trans(e, k);

	if (WARNING)
	{
		bprint("*** Translate - ");
		bprint(e.classname);
		bprint(" a: ");
		bprint(e.class_select);
		bprint(" x via: ");
		bprint(ftos(k));
		bprint(" to: ");
		if (mcc != "") bprint(mcc);
		else bprint("NOT TRANSLATING");
	}

	if (mcc == "RMV") // no translation - removed
	{
		hide_item (e);
		if (WARNING) bprint(" - Hidden!");
	}
	else if (mcc != "")
	{
		NO_PI = 3.1415; // no place item - no mcode set, no subcontrols
		if(e.map == "repic") e.map = "pic_item";
		item_call_save(e, mcc);
	}
	if (WARNING) bprint("\n");
};

void(entity e, float trv) master_item_control =
{
	if (e.classname == "func_make") return; // override
	if (cvar("pk_place_item") == 1) return;

	if (!PK_100 && !Q_100) // turned back on - come here from loop
	{
		if (e.wad == "q1")
		{
			hide_item (e);
			return;
		}
		else if (trv)
		{
			item_translate(e, trv);
			return;
		}
		setmodel (e,e.mdl);
		e.touch = painkeep_touch;
		if (e.th_stand != SUB_Null) e.pk_touch = e.th_stand;
		e.th_stand = SUB_Null;
		e.map = e.path;
		if(e.map == "repic") e.map = "pic_item";
		return;
	}

	if (trv)
	{
		if(e.map == "repic") e.map = "pic_item";
		item_translate(e, trv);
	}
	else
	{
		if (e.classname == "dyn_item") // NOTE: should never happen, pk100 has no dyn (unless func_dyn)
		{
			if (WARNING)
			{
				bprint("*** Warning - dynamic items: pk_100 and dynamic made a ");
				bprint(e.class_select);
				bprint(" - hiding\n");
			}
		}
		hide_item (e);
	}
};

// allow live translate of doom items - later
// twiddled after map load

void(string tri, float trv) master_item_control_loop =
{
	local entity e, sv;
	local string sr;


	sr = tri;
	e = find(world,class_select,sr);
	while (e)
	{
		master_item_control(e, trv);
		e = find(e,class_select,sr);
//		if (!e)
//		{
//		if (sr == "doom") sr = "wolf";
//		e = find(e,class_select,sr);
//		}
	}
};


void() set_translate =
{
	TR_WOLF = fabs(cvar("pk_tr_wolf" ));
	TR_DOOM = fabs(cvar("pk_tr_doom" ));
	TR_QUAKE = fabs(cvar("pk_tr_quake" ));
	TR_Q2 = fabs(cvar("pk_tr_q2" ));
	TR_Q3 = fabs(cvar("pk_tr_q3" ));
	TR_ALL = fabs(cvar("pk_tr_all" ));
};

string(float tr) tran_str =
{
	if (tr == FL_TR_WOLF) return("Wolfenstien");
	else if (tr == FL_TR_DOOM) return("DooM");
	else if (tr == FL_TR_QUAKE) return("Quake");
	else if (tr == FL_TR_Q2) return("Quake 2");
	else if (tr == FL_TR_Q3) return("Quake 3");
	else if (tr == FL_TR_RESTORE) return("Restoring");
	else if (tr == FL_TR_RANDIN) return("Random genre");
	else if (tr == FL_TR_RANDOM) return("any Random item");
//	if (tr == FL_TR_REMOVE) 
		return("null - removing");
};

// map translations

void() check_translate =
{
	TR_NOT = cvar("pk_tr_not");

	if (cvar("pk_place_item") != 1)
	{
		if (TR_ALL != cvar("pk_tr_all" ))
		{
			if (!TR_ALL) TR_ALL = FL_TR_RESTORE; // turned off & we need restore controls

			if (WARNING)
			{
			bprint("*** Translate: ALL to ");
			bprint(tran_str(TR_ALL));
			bprint("\n\n");
			}
		}

		if (TR_WOLF != cvar("pk_tr_wolf" ) || TR_ALL)
		{
			TR_WOLF = fabs(cvar("pk_tr_wolf" ));
			if (!TR_WOLF) TR_WOLF = FL_TR_RESTORE; // turned off & we need restore controls

			if (WARNING)
			{
			bprint("*** Translate: Wolf to ");
			bprint(tran_str(TR_WOLF));
			bprint("\n");
			}

			master_item_control_loop("wolf_item", TR_WOLF);
		}

		if (TR_DOOM != cvar("pk_tr_doom" ) || TR_ALL)
		{
			TR_DOOM = fabs(cvar("pk_tr_doom" ));
			if (!TR_DOOM) TR_DOOM = FL_TR_RESTORE; // turned off & we need restore controls

			if (WARNING)
			{
			bprint("*** Translate: DooM to ");
			bprint(tran_str(TR_DOOM));
			bprint("\n");
			}

			master_item_control_loop("doom_item", TR_DOOM);
		}

		if (TR_QUAKE != cvar("pk_tr_quake" ) || TR_ALL)
		{
			TR_QUAKE = fabs(cvar("pk_tr_quake" ));
			if (!TR_QUAKE) TR_QUAKE = FL_TR_RESTORE; // turned off & we need restore controls

			if (WARNING)
			{
			bprint("*** Translate: Quake to ");
			bprint(tran_str(TR_QUAKE));
			bprint("\n");
			}

			master_item_control_loop("quake_item", TR_QUAKE);
		}

		if (TR_Q2 != cvar("pk_tr_q2" ) || TR_ALL)
		{
			TR_Q2 = fabs(cvar("pk_tr_q2" ));
			if (!TR_Q2) TR_Q2 = FL_TR_RESTORE; // turned off & we need restore controls

			if (WARNING)
			{
			bprint("*** Translate: Quake 2 to ");
			bprint(tran_str(TR_Q2));
			bprint("\n");
			}

			master_item_control_loop("q2_item", TR_Q2);
		}

		if (TR_Q3 != cvar("pk_tr_q3" ) || TR_ALL)
		{
			TR_Q3 = fabs(cvar("pk_tr_q2" ));
			if (!TR_Q3) TR_Q3 = FL_TR_RESTORE; // turned off & we need restore controls

			if (WARNING)
			{
			bprint("*** Translate: Quake 3 to ");
			bprint(tran_str(TR_Q3));
			bprint("\n");
			}

			master_item_control_loop("q3_item", TR_Q3);
		}
		set_translate();
	}

	if (cvar("pk_translate"))
	{
		bprint("\nMap translation bits\n{\n");
		bprint(ftos(FL_TR_WOLF));
		bprint("  - translate item to Wolf\n");
		bprint(ftos(FL_TR_DOOM));
		bprint("  - translate item to Doom\n");
		bprint(ftos(FL_TR_QUAKE));
		bprint("  - translate item to Quake\n");
		bprint(ftos(FL_TR_Q2));
		bprint("  - translate item to Quake 2\n");
		bprint(ftos(FL_TR_Q3));
		bprint("  - translate item to Quake 3\n");
		bprint(ftos(FL_TR_RANDIN));
		bprint("  - randomize these items in genre\n");
		bprint(ftos(FL_TR_RANDOM));
		bprint("  - randomize these items totally\n");
		bprint(ftos(FL_TR_REMOVE));
		bprint("  - remove these items\n");
		bprint(ftos(-1));
		bprint("  - internal restore - not selectable\n");
		bprint("}\n\n");

		bprint("Map translation vars\n{\n");
		bprint("var: pk_tr_all = ");
		bprint(ftos(TR_ALL));
		bprint(" - overrides all other settings\n");
		bprint("var: pk_tr_wolf = ");
		bprint(ftos(TR_WOLF));
		bprint("\n");
		bprint("var: pk_tr_doom = ");
		bprint(ftos(TR_DOOM));
		bprint("\n");
		bprint("var: pk_tr_quake = ");
		bprint(ftos(TR_QUAKE));
		bprint("\n");
		bprint("var: pk_tr_q2 = ");
		bprint(ftos(TR_Q2));
		bprint("\n");
		bprint("var: pk_tr_q3 = ");
		bprint(ftos(TR_Q3));
		bprint("\n");
		bprint("var: pk_tr_not = ");
		bprint(ftos(TR_NOT));
		bprint(" - action for items with no direct translation:\n                0 = no change, 1 = remove, 2 = best guess, 3 = randomize in genre, 4 = randomize to any \n");
		bprint("var: pk_tr_q1def = ");
		bprint(ftos(TR_Q1DEF));
		bprint(" - pk_100 or q_100 and no alt q1 items on non quake map - 0 = remove, 1 = translate to quake\n");
		bprint("}\n\n");

		if (TR_ALL || TR_Q3 || TR_Q2 || TR_QUAKE || TR_DOOM || TR_WOLF)
		{
			if (TR_ALL)
			{
				bprint("ALL: translating every item to: ");
				if (TR_ALL == FL_TR_WOLF) bprint("Wolfenstien\n");
				if (TR_ALL == FL_TR_DOOM) bprint("Doom\n");
				if (TR_ALL == FL_TR_QUAKE) bprint("Quake\n");
				if (TR_ALL == FL_TR_Q2) bprint("Quake 2\n");
				if (TR_ALL == FL_TR_Q3) bprint("Quake 3\n");
				if (TR_ALL == FL_TR_RANDIN) bprint("in genre random item!\n");
				if (TR_ALL == FL_TR_RANDOM) bprint("any random item!\n");
				if (TR_ALL == FL_TR_REMOVE) bprint("Nothing! - all items are removed, uh have fun!\n");
				if (TR_Q3 || TR_Q2 || TR_QUAKE || TR_DOOM || TR_WOLF)
					bprint("\n *** Warning: all other translations are overridden by ALL\n\n");
			}
			if (TR_WOLF)
			{
				if (TR_ALL) bprint("ALL overrides - ");
				bprint("Translating wolf items to: ");
				if (TR_WOLF == FL_TR_WOLF) bprint("Wolfenstien - DOH!\n");
				if (TR_WOLF == FL_TR_DOOM) bprint("Doom\n");
				if (TR_WOLF == FL_TR_QUAKE) bprint("Quake\n");
				if (TR_WOLF == FL_TR_Q2) bprint("Quake 2\n");
				if (TR_WOLF == FL_TR_Q3) bprint("Quake 3\n");
				if (TR_WOLF == FL_TR_RANDIN) bprint("Random Wolfenstien\n");
				if (TR_WOLF == FL_TR_RANDOM) bprint("any random item\n");
				if (TR_WOLF == FL_TR_REMOVE) bprint("Nothing! - all wolf items are removed!\n");
			}
			if (TR_DOOM)
			{
				if (TR_ALL) bprint("ALL overrides - ");
				bprint("Translating doom items to: ");
				if (TR_DOOM == FL_TR_WOLF) bprint("Wolfenstien\n");
				if (TR_DOOM == FL_TR_DOOM) bprint("Doom - DOH!\n");
				if (TR_DOOM == FL_TR_QUAKE) bprint("Quake\n");
				if (TR_DOOM == FL_TR_Q2) bprint("Quake 2\n");
				if (TR_DOOM == FL_TR_Q3) bprint("Quake 3\n");
				if (TR_DOOM == FL_TR_RANDIN) bprint("Random Doom\n");
				if (TR_DOOM == FL_TR_RANDOM) bprint("any random item\n");
				if (TR_DOOM == FL_TR_REMOVE) bprint("Nothing! - all doom items are removed!\n");
			}
			if (TR_QUAKE)
			{
				if (TR_ALL) bprint("ALL overrides - ");
				bprint("Translating quake items to: ");
				if (TR_QUAKE == FL_TR_WOLF) bprint("Wolfenstien\n");
				if (TR_QUAKE == FL_TR_DOOM) bprint("Doom\n");
				if (TR_QUAKE == FL_TR_QUAKE) bprint("Quake - DOH!\n");
				if (TR_QUAKE == FL_TR_Q2) bprint("Quake 2\n");
				if (TR_QUAKE == FL_TR_Q3) bprint("Quake 3\n");
				if (TR_QUAKE == FL_TR_RANDIN) bprint("Random Quake\n");
				if (TR_QUAKE == FL_TR_RANDOM) bprint("any random item\n");
				if (TR_QUAKE == FL_TR_REMOVE) bprint("Nothing! - all quake items are removed!\n");
			}
			if (TR_Q2)
			{
				if (TR_ALL) bprint("ALL overrides - ");
				bprint("Translating quake 2 items to: ");
				if (TR_Q2 == FL_TR_WOLF) bprint("Wolfenstien\n");
				if (TR_Q2 == FL_TR_DOOM) bprint("Doom\n");
				if (TR_Q2 == FL_TR_QUAKE) bprint("Quake\n");
				if (TR_Q2 == FL_TR_Q2) bprint("Quake 2 - DOH!\n");
				if (TR_Q2 == FL_TR_Q3) bprint("Quake 3\n");
				if (TR_Q2 == FL_TR_RANDIN) bprint("Random Quake 2\n");
				if (TR_Q2 == FL_TR_RANDOM) bprint("any random item\n");
				if (TR_Q2 == FL_TR_REMOVE) bprint("Nothing! - all quake 2 items are removed!\n");
			}
			if (TR_Q3)
			{
				if (TR_ALL) bprint("ALL overrides - ");
				bprint("Translating quake 3 items to: ");
				if (TR_Q3 == FL_TR_WOLF) bprint("Wolfenstien\n");
				if (TR_Q3 == FL_TR_DOOM) bprint("Doom\n");
				if (TR_Q3 == FL_TR_QUAKE) bprint("Quake\n");
				if (TR_Q3 == FL_TR_Q2) bprint("Quake 2\n");
				if (TR_Q3 == FL_TR_Q3) bprint("Quake 3 - DOH!\n");
				if (TR_Q3 == FL_TR_RANDIN) bprint("Random Quake 3\n");
				if (TR_Q3 == FL_TR_RANDOM) bprint("any random item\n");
				if (TR_Q3 == FL_TR_REMOVE) bprint("Nothing! - all quake 3 items are removed!\n");
			}
			if (TR_WOLF == FL_TR_WOLF ||
				TR_DOOM == FL_TR_DOOM ||
				TR_QUAKE == FL_TR_QUAKE ||
				TR_Q2 == FL_TR_Q2 ||
				TR_Q3 == FL_TR_Q3
				)	bprint(" *** Warning: Translatng one or more sets to themselves - this is feeble and pointless.\n");

			if (RUNES) bprint(" *** Warning: Translate will not affect or create runes.\n");
			if (cvar("pk_place_item") == 1) bprint(" *** Warning: Items removed Translate has no effect.\n");
		}
		else
			bprint("No translations set\n");
	bprint("\n");
	}

	cvar_set("pk_translate", "0");

};

/*
q3 wep					pk wep
------------------------------------------
bfg						chain_lg
plasma					chain_lg
machinegun				supernailgun / nailgun
shotgun					supershotgun
grapplinghook			harpoon
railgun					gravity well / turret
lighting					lighting
------------------------------------------
slugs						explodeshells
grenades					rockets
lightning				cells
bfg						cells
------------------------------------------
armor shard				beartrap
item_armor_combat		item_armor2
item_armor_body		item_armorInv
------------------------------------------
item health sm			candle
item_health_large		item_health
item_health_mega		item_health
------------------------------------------
item_quad				item_artifact_super_damage
item_regen				item_artifact_invulnerability
item_invis				item_artifact_invisibility
item_enviro				item_artifact_envirosuit
------------------------------------------
holdable_medkit		item_painkeep_can
holdable_teleporter	item_pkplus_phone
*/