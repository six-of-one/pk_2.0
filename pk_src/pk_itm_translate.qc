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


// TDO: finish translate codes
// TDO: restore wad == "q1" item with doom item deactivate / pk_100 mode on (if ever allowed in map)

void() tr_set_touch =
{
	self.enemy.pk_touch = self.pk_touch; // think just to set this for *100 stuff
//	self.enemy.touch = self.touch;
	remove(self);
};

// fn(hide_item) - hide something from players & item controls

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
	local void() sv;

	if (TR == FL_TR_RANDIN || TR_NOT == FL_NOTRN_RNDIN)
	{
		wr = MC_W_KNIFE + floor(random() * (MC_W_RNDITM));
		dr = MC_D_SAW + floor(random() * (MC_D_RNDITM - 1));
		if (Q_100 || PK_100) // translating items when these are set
		{
			qr = MC_SUPER_SHOTGUN + floor(random() * (MC_RNDITM));
			if (RUNES) qr = MC_SUPER_SHOTGUN + floor(random() * (MC_NR_RNDITM)) - 2;
		}
		else
		{
			qr = MC_AXE + floor(random() * (MC_RNDITM + 2));
			if (RUNES) qr = MC_AXE + floor(random() * (MC_NR_RNDITM));
		}

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
	else if (e.scode == MC_Q2_RAILGUN || e.scode == MC_Q3_RAILGUN)
	{
		if (TR == FL_TR_WOLF)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG) // IDEA: sniper rifle, cmod has code, & vw exists
			{
				if (random() > 0.25)
					return("w_weapon_chaingun"); // most powerful wolf wep is prob dual chg
				else if (random() > 0.8)
					return("w_weapon_flamer");
				else
					return("w_weapon_motar");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("d_weapon_rocketlauncher");
				else if (random() > 0.5)
					return("d_weapon_plasma");
				else
					return("d_weapon_bfg");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcd);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("weapon_rocketlauncher");
				else if (random() > 0.5)
					return("weapon_lightning");
				else
					return("weapon_chainlg");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q2) return("q2_weapon_railgun");
		if (TR == FL_TR_Q3) return("q3_weapon_railgun");
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
		if (TR == FL_TR_Q2) return("weapon_chaingun");
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
		if (TR == FL_TR_QUAKE)
		{
			if (Q_100 || PK_100)
			{
				if (random() < 0.1) return("weapon_grenadelauncher");
				return("weapon_supershotgun");
			}
			else return("weapon_shotgun");
		}
		if (TR == FL_TR_Q2) return("q2_weapon_shotgun");
		if (TR == FL_TR_Q3) return("q3_weapon_shotgun"); // IDEA: need bg code here?
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_PISTOL || e.scode == MC_SHOTGUN || e.scode == MC_Q2_BLASTER) // will not happen on a normal translated map - no map items normally exist for these
	{
		if (TR == FL_TR_WOLF) return("w_weapon_pistol");
		if (TR == FL_TR_DOOM) return("d_weapon_pistol");
		if (TR == FL_TR_QUAKE)
		{
			if (Q_100 || PK_100)
			{
				if (random() < 0.75) return("weapon_nailgun");
				return("weapon_supershotgun");
			}
			else return("weapon_shotgun");
		}
		if (TR == FL_TR_Q2) return("q2_blaster");
		if (TR == FL_TR_Q3) return("weapon_gauntlet");
		if (TR == FL_TR_RANDIN) return(mcw);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_SAW || e.scode == MC_W_KNIFE || e.scode == MC_AXE || e.scode == MC_Q3_GAUNTLET) // another not too likely - saw is the only regular map item
	{
		if (TR == FL_TR_WOLF) return("w_weapon_knife");
		if (TR == FL_TR_DOOM) return("d_weapon_saw");
		if (TR == FL_TR_QUAKE)
		{
			if (Q_100 || PK_100)
			{
				if (random() < 0.05) return("weapon_lightning");
				return("weapon_supershotgun");
			}
			else return("weapon_axe");
		}
		if (TR == FL_TR_Q2) return("q2_weapon_blaster");
		if (TR == FL_TR_Q3) return("weapon_gauntlet");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_D_ASHELLS || e.scode == MC_ASHELLS || e.scode == MC_Q2_ASHELLS || e.scode == MC_Q3_ASHELLS)
	{
		if (TR == FL_TR_WOLF) return("w_ammo_clip"); // IDEA: need bg code here?
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
		if (TR == FL_TR_WOLF) return("w_ammo_clip");
		if (TR == FL_TR_DOOM) return("d_ammo_shellbox");
		if (TR == FL_TR_QUAKE) return("item_shells_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_shells");
		if (TR == FL_TR_Q3) return("q3_ammo_shells");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ACELLS_LG || e.scode == MC_ACELLS_LG || e.scode == MC_W_GAS || e.scode == MC_Q2_ACELLS || e.scode == MC_Q3_ACELLS)
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
	else if (e.scode == MC_D_AROCKET || e.scode == MC_AROCKETS || e.scode == MC_Q2_AROCKETS || e.scode == MC_Q3_AROCKETS)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_mortar"); // TDO: mortar ammo
		if (TR == FL_TR_DOOM)
		{
			if (e.scode == MC_D_AROCKET) return("d_ammo_1rocket");
			else return("d_ammo_rockbox");
		}
		if (TR == FL_TR_QUAKE) return("item_rockets");
		if (TR == FL_TR_Q2) return("q2_ammo_rockets");
		if (TR == FL_TR_Q3) return("q3_ammo_rockets");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_AROCKETS_LG || e.scode == MC_AROCKETS_LG)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_mortar"); // IDEA: new ammo
		if (TR == FL_TR_DOOM) return("d_ammo_rockbox");
		if (TR == FL_TR_QUAKE) return("item_rockets_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_rockets");
		if (TR == FL_TR_Q3) return("q3_ammo_rockets");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_Q2_AGRENADES || e.scode == MC_Q3_AGRENADES)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_mortar"); // IDEA: new ammo
		if (TR == FL_TR_DOOM) return("d_ammo_rockbox");
		if (TR == FL_TR_QUAKE) return("item_rockets");
		if (TR == FL_TR_Q2) return("q2_ammo_grenades");
		if (TR == FL_TR_Q3) return("q3_ammo_grenades");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_W_CLIP || e.scode == MC_D_ABULLETS || e.scode == MC_ANAILS)
	{
		if (TR == FL_TR_WOLF) return("w_ammo_clip");
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
		if (TR == FL_TR_WOLF) return("w_ammo_clip");
		if (TR == FL_TR_DOOM) return("d_ammo_ammobox");
		if (TR == FL_TR_QUAKE) return("item_spikes_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_bullets");
		if (TR == FL_TR_Q3) return("q3_ammo_bullets");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_Q2_ASLUGS || e.scode == MC_Q3_ASLUGS)
	{
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.25)
					return("w_ammo_clip");
				else if (random() > 0.8)
					return("w_ammo_gas");
				else
					return("w_weapon_motar");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("d_ammo_rockbox");
				else
					return("d_ammo_cellbox");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcd);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("item_rockets");
				else
					return("item_cells");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q2) return("q2_ammo_slugs");
		if (TR == FL_TR_Q3) return("q3_ammo_slugs");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_W_PACK || e.scode == MC_D_PACK || e.scode == MC_Q2_PACK)
	{
		if (TR == FL_TR_WOLF)	return("w_item_pack");
		if (TR == FL_TR_DOOM)	return("d_item_pack");
		if (TR == FL_TR_QUAKE)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("fn_backpack");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q2) return("item_pack");
		if (TR == FL_TR_Q3)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("item_flight");
				else
					return("holdable_medkit");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq3);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_W_FACESPHERE || e.scode == MC_D_SOULSPH || e.scode == MC_HEALTHMEGA || e.scode == MC_Q2_MEGA || e.scode == MC_Q3_MEGA)
	{
		if (TR == FL_TR_WOLF) return("w_art_facesphere");
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
		if (TR == FL_TR_WOLF) return("w_heal_medkit"); // TDO: plate of food
		if (TR == FL_TR_DOOM) return("d_item_healthstimpak");
		if (TR == FL_TR_QUAKE) return("item_health_15");
		if (TR == FL_TR_Q2) return("q2_item_health");
		if (TR == FL_TR_Q3) return("q3_item_health");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_HBOTTLE || e.scode == MC_Q2_STIMPAK || e.scode == MC_Q3_HSMALL)
	{
		if (TR == FL_TR_WOLF) return(""); // TDO: blood (gibs) - dog food
		if (TR == FL_TR_DOOM) return("d_item_healthbottle");
		if (TR == FL_TR_QUAKE)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG || Q_100 || PK_100)
			{
				if (random() < 0.2) return("item_health_15");
				if (Q_100) return("RMV");
				if (PK_100)
				{
					e.enemy = spawn();
					e.enemy.enemy = e;
					e.enemy.think = tr_set_touch;
					e.enemy.nextthink = time + 0.1;
					e.enemy.pk_touch = painkeep_weapon_touch;
					if (random() < 0.5) return("weapon_grapgun");
					if (random() < 0.3) return("weapon_airfist");
					if (random() < 0.1) return("weapon_chainlg");
					e.enemy.pk_touch = painkeep_touch;
					if (random() < 0.2) return("item_painkeep_turret");
					return("RMV");
				}
				if (TR_Q1DEF) // if true and not *100 - try this
				{
					e.touch = painkeep_touch;
					sv = e.pk_touch;
					if (PK_ART && random() < 0.25)
					{
						e.pk_touch = pkplus_touch;
						if (random() < 0.5) return("item_pkplus_tomb");
						if (random() < 0.3) return("item_pkplus_ego");
					}
					e.pk_touch = painkeep_weapon_touch;
					if (random() < 0.5) return("weapon_grapgun");
					if (random() < 0.3) return("weapon_airfist");
					if (random() < 0.1) return("weapon_chainlg");
					e.pk_touch = painkeep_touch;
					if (random() < 0.2) return("item_painkeep_turret");
					e.pk_touch = sv;
					return("RMV");
				}
				return("");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
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
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_item_spiritarmor");
		if (TR == FL_TR_QUAKE)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG || Q_100 || PK_100)
			{
				if (Q_100) return("RMV");
				if (PK_100)
				{
					e.enemy = spawn();
					e.enemy.enemy = e;
					e.enemy.think = tr_set_touch;
					e.enemy.nextthink = time + 0.1;
					e.enemy.pk_touch = painkeep_touch;
					if (random() < 0.5) return("item_painkeep_beartrap");
					if (random() < 0.3) return("item_painkeep_turret");
					if (random() < 0.1) return("item_painkeep_gwell");
					e.enemy.pk_touch = ammo_touch;
					if (random() < 0.2) return("item_painkeep_expshells");
					return("RMV");
				}
				if (TR_Q1DEF) // if true and not *100 - try this
				{
					e.touch = painkeep_touch;
					sv = e.pk_touch;
					if (PK_ART && random() < 0.25)
					{
						e.touch = pkplus_touch;
						if (random() < 0.5) return("item_pkplus_tomb");
						if (random() < 0.3) return("item_pkplus_ego");
						if (random() < 0.2) return("item_pkplus_phone");
						if (random() < 0.1) return("item_pkplus_actor");
					}
					e.pk_touch = painkeep_touch;
					if (random() < 0.5) return("item_painkeep_beartrap");
					if (random() < 0.3) return("item_painkeep_turret");
					if (random() < 0.1) return("item_painkeep_gwell");
					e.pk_touch = ammo_touch;
					if (random() < 0.2) return("item_painkeep_expshells");
					e.pk_touch = sv;
					return("RMV");
				}
				return("");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
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
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
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
	else if (e.scode == MC_D_ARM_GRN || e.scode == MC_ARMOR2 || e.scode == MC_Q2_ARM_COMBAT || e.scode == MC_Q3_ARM_COMBAT)
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
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
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
	else if (e.scode == MC_Q2_ARM_JAK || e.scode == MC_ARMOR1)
	{
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("RMV");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_item_armorgreen");
		if (TR == FL_TR_QUAKE) return("item_armor1");
		if (TR == FL_TR_Q2) return("item_armor_jacket");
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
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
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
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
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
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
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
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
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
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
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

	else if (e.scode == MC_W_BARREL || e.scode == MC_D_BARREL || e.scode == MC_Q2_BARREL || self.scode == MC_EXPLOD1 || self.scode == MC_EXPLOD1)
	{
		if (TR == FL_TR_WOLF)
		{
			setmodel(e, "progs/barrel2.mdl");
			e.mdl = e.model;
			e.frame = 1;
			e.skin = 0;
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			setmodel(e, "progs/barrel.mdl");
			e.mdl = e.model;
			e.noise = "doom/dsbarexp.wav";
			e.frame = 0;
			e.skin = 0;
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
			if (random() > 0.33)
				setmodel(e, "maps/b_explob.bsp");
			else
				setmodel(e, "maps/b_exbox2.bsp");
			e.noise = "weapons/r_exp3.wav";
			e.mdl = e.model;
			e.frame = 0;
			e.skin = 0;
			return("");
		}
		if (TR == FL_TR_Q2)
		{
			setmodel(e, "progs/q2_barrel.mdl");
			e.mdl = e.model;
			e.frame = 0;
			e.skin = 0;
			return("");
		}
		if (TR == FL_TR_Q3)
		{
			local float r;
			r = rint(3 * random());
			if (r == 1)
			{
				setmodel (e, "progs/q3_ammobox.mdl");
				e.frame = 0;
				e.skin = q3_bfg_amsk;
			}
			else if (r == 2)
			{
				setmodel (e, "progs/q3_arm.mdl");
				e.frame = 0;
				e.skin = 1;
			}
			else if (r == 3)
			{
				setmodel(e, "progs/q3_health.mdl");
				e.frame = 1;
				e.skin = Q3_HEALM;
			}
			else //if (r == 0)
			{
				setmodel(e, "progs/q3_art.mdl");
				e.frame = q3_regn_fsk;
				e.skin = q3_regn_fsk;
			}
			e.mdl = e.model;
			return("");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_W_KEY_G || e.scode == MC_D_KEY_RED_SK || e.scode == MC_KEY2_0 || e.scode == MC_Q2_KEY_RED)
	{
		if (TR == FL_TR_WOLF) return("w_key_g");
		if (TR == FL_TR_DOOM) return("d_key_redskull");
		if (TR == FL_TR_QUAKE) return("item_key2_0");
		if (TR == FL_TR_Q2) return("key_red_key");
		if (TR == FL_TR_Q3) return("RMV");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_W_KEY_B || e.scode == MC_D_KEY_BLU_SK || e.scode == MC_KEY1_0 || e.scode == MC_Q2_KEY_BLU)
	{
		if (TR == FL_TR_WOLF) return("w_key_b");
		if (TR == FL_TR_DOOM) return("d_key_blueskull");
		if (TR == FL_TR_QUAKE) return("item_key1_0");
		if (TR == FL_TR_Q2) return("key_blue_key");
		if (TR == FL_TR_Q3) return("RMV");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_KEY_RED_CR || e.scode == MC_KEY2_2 || e.scode == MC_Q2_KEY_PYRAMID)
	{
		if (TR == FL_TR_WOLF) return("w_key_g");
		if (TR == FL_TR_DOOM) return("d_key_redcard");
		if (TR == FL_TR_QUAKE) return("item_key2_2");
		if (TR == FL_TR_Q2) return("key_pyramid");
		if (TR == FL_TR_Q3) return("RMV");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_KEY_BLU_CR || e.scode == MC_KEY1_2 || e.scode == MC_Q2_KEY_POWER)
	{
		if (TR == FL_TR_WOLF) return("w_key_b");
		if (TR == FL_TR_DOOM) return("d_key_bluecard");
		if (TR == FL_TR_QUAKE) return("item_key1_2");
		if (TR == FL_TR_Q2) return("key_power_cube");
		if (TR == FL_TR_Q3) return("RMV");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_KEY_YEL_SK || e.scode == MC_KEY2_1 || e.scode == MC_Q2_KEY_CD)
	{
		if (TR == FL_TR_WOLF) return("w_key_g");
		if (TR == FL_TR_DOOM) return("d_key_yellowskull");
		if (TR == FL_TR_QUAKE) return("item_key2_1");
		if (TR == FL_TR_Q2) return("key_data_cd");
		if (TR == FL_TR_Q3) return("RMV");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_KEY_YEL_CR || e.scode == MC_KEY1_1 || e.scode == MC_Q2_KEY_SPINNER)
	{
		if (TR == FL_TR_WOLF) return("w_key_b");
		if (TR == FL_TR_DOOM) return("d_key_yellowcard");
		if (TR == FL_TR_QUAKE) return("item_key1_1");
		if (TR == FL_TR_Q2) return("key_data_spinner");
		if (TR == FL_TR_Q3) return("RMV");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

/// wolf
	else if (e.scode == MC_W_MACHGUN)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_machinegun");
		if (TR == FL_TR_DOOM) return("d_weapon_supershotgun");
		if (TR == FL_TR_QUAKE) return("weapon_nailgun");
		if (TR == FL_TR_Q2) return("q2_weapon_machinegun");
		if (TR == FL_TR_Q3)
		{
			if (random() > 0.4)
				return("q3_weapon_lightning");
			else
				return("q3_weapon_bfg");
		}
		if (TR == FL_TR_RANDIN) return(mcw);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_W_PISTOL) // like the nailgun, has a few slots to fill in trans
	{
		if (TR == FL_TR_WOLF) return("w_weapon_pistol");
		if (TR == FL_TR_DOOM)
		{
			if (random() > 0.4)
				return("d_weapon_pistol");
			else
				return("d_weapon_bfg");
		}
		if (TR == FL_TR_QUAKE) return("weapon_shotgun");
		if (TR == FL_TR_Q2) return("q2_weapon_supershotgun");
		if (TR == FL_TR_Q3) return("q3_weapon_railgun");
		if (TR == FL_TR_RANDIN) return(mcw);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
/// doom
	else if (e.scode == MC_D_MEGASPH)
	{
		if (TR == FL_TR_WOLF)
		{
//			if (!TR_NOT) return("");
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.7)
					return("w_art_facesphere");
				else
					return("w_barrel");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM) return("d_art_megasphere");
		if (TR == FL_TR_QUAKE) return("item_artifact_invulnerability");
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("item_health_mega");
				else
					return("item_armorInv");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q2) return("item_invulnerability");
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("q2_item_health_mega");
				else
					return("q2_item_armor_body");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq2);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q3)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("item_regen");
				else
					return("q3_item_health_mega");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq3);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_RANDIN) return(mcq3);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_D_NIGHTVS)
	{
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("w_item_pack");
				else
					return("w_barrel");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)	return("d_item_nightvis");
		if (TR == FL_TR_QUAKE)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("item_painkeep_turret");
				else
				if (random() > 0.5)
					return("misc_explobox");
				else
					return("item_painkeep_expshells");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q2)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("q2_misc_explobox");
				else
					return("item_adrenaline");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq2);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q3)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("holdable_teleporter");
				else
					return("holdable_medkit");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq3);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_D_AUTOMAP)
	{
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("w_heal_medkit");
				else
					return("w_barrel");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)	return("d_item_automap");
		if (TR == FL_TR_QUAKE)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("item_painkeep_turret");
				else
				if (random() > 0.5)
					return("misc_explobox2");
				else
					return("item_pkplus_tomb");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q2)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("q2_misc_explobox");
				else
					return("item_power_shield");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq2);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q3)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("holdable_teleporter");
				else
					return("holdable_medkit");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq3);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
/// quake

	else if (e.scode == MC_NAILGUN) // this ones a little odd because some other weps fit that slot better in trans
	{
		if (TR == FL_TR_WOLF) return("w_weapon_machinegun");
		if (TR == FL_TR_DOOM) return("d_weapon_bfg");
		if (TR == FL_TR_QUAKE) return("weapon_nailgun");
		if (TR == FL_TR_Q2) return("q2_weapon_machinegun");
		if (TR == FL_TR_Q3) return("q3_weapon_railgun");
		if (TR == FL_TR_RANDIN) return(mcw);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_KEY2)
	{
		if (TR == FL_TR_WOLF) return("w_key_g");
		if (TR == FL_TR_DOOM) return("d_key_redskull");
		if (TR == FL_TR_QUAKE) return("item_key2");
		if (TR == FL_TR_Q2) return("key_red_key");
		if (TR == FL_TR_Q3) return("RMV");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_KEY1)
	{
		if (TR == FL_TR_WOLF) return("w_key_b");
		if (TR == FL_TR_DOOM) return("d_key_blueskull");
		if (TR == FL_TR_QUAKE) return("item_key1");
		if (TR == FL_TR_Q2) return("key_blue_key");
		if (TR == FL_TR_Q3) return("RMV");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_EXPLOD1)
	{
		if (TR == FL_TR_WOLF)
		{
			setmodel(e, "progs/barrel2.mdl");
			e.frame = 1;
			e.skin = 0;
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			setmodel(e, "progs/barrel.mdl");
			e.frame = 0;
			e.skin = 0;
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
			setmodel(e, "maps/b_explob.bsp");
			e.frame = 0;
			e.skin = 0;
			return("");
		}
		if (TR == FL_TR_Q2)
		{
			setmodel(e, "progs/q2_barrel.mdl");
			e.frame = 0;
			e.skin = 0;
			return("");
		}
		if (TR == FL_TR_Q3)
		{
			r = rint(3 * random());
			if (r == 1)
			{
			setmodel (e, "progs/q3_ammobox.mdl");
			e.frame = 0;
			e.skin = q3_bfg_amsk;
			}
			else if (r == 2)
			{
			setmodel (e, "progs/q3_arm.mdl");
			e.frame = 0;
			e.skin = 1;
			}
			else if (r == 3)
			{
			setmodel(e, "progs/q3_health.mdl");
			e.frame = 1;
			e.skin = Q3_HEALM;
			}
			else //if (r == 0)
			{
			setmodel(e, "progs/q3_art.mdl");
			e.frame = q3_regn_fsk;
			e.skin = q3_regn_fsk;
			}
			return("");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_EXPLOD2)
	{
		if (TR == FL_TR_WOLF)
		{
			setmodel(e, "progs/barrel2.mdl");
			e.frame = 1;
			e.skin = 0;
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			setmodel(e, "progs/barrel.mdl");
			e.frame = 0;
			e.skin = 0;
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
			setmodel(e, "maps/b_exbox2.bsp");
			e.frame = 0;
			e.skin = 0;
			return("");
		}
		if (TR == FL_TR_Q2)
		{
			setmodel(e, "progs/q2_barrel.mdl");
			e.frame = 0;
			e.skin = 0;
			return("");
		}
		if (TR == FL_TR_Q3)
		{
			r = rint(3 * random());
			if (r == 1)
			{
			setmodel (e, "progs/q3_ammobox.mdl");
			e.frame = 0;
			e.skin = q3_bfg_amsk;
			}
			else if (r == 2)
			{
			setmodel (e, "progs/q3_arm.mdl");
			e.frame = 0;
			e.skin = 1;
			}
			else if (r == 3)
			{
			setmodel(e, "progs/q3_health.mdl");
			e.frame = 1;
			e.skin = Q3_HEALM;
			}
			else //if (r == 0)
			{
			setmodel(e, "progs/q3_art.mdl");
			e.frame = q3_regn_fsk;
			e.skin = q3_regn_fsk;
			}
			return("");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

/// q2
	else if (e.scode == MC_Q2_MACHINEGUN) // here because wolf mg has to be a burger king
	{
		if (TR == FL_TR_WOLF) return("w_weapon_machinegun");
		if (TR == FL_TR_DOOM) return("d_weapon_supershotgun");
		if (TR == FL_TR_QUAKE) return("weapon_nailgun");
		if (TR == FL_TR_Q2) return("q2_weapon_machinegun");
		if (TR == FL_TR_Q3) return("q3_weapon_machinegun");
		if (TR == FL_TR_RANDIN) return(mcw);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_Q2_BANDOLIER)
	{
		if (TR == FL_TR_WOLF)	return("w_item_pack");
		if (TR == FL_TR_DOOM)	return("d_item_pack");
		if (TR == FL_TR_QUAKE)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("fn_backpack");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q2) return("item_bandolier");
		if (TR == FL_TR_Q3)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.75)
					return("item_flight");
				else if (random() > 0.5)
					return("holdable_medkit");
				else
					return("holdable_teleporter");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq3);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_Q2_ARM_PSHIELD)
	{
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("RMV");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.8)
					return("d_item_armorgreen");
				else
					return("d_art_megasphere");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcd);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.8)
					return("item_armor2");
				else
				if (random() > 0.8)
					return("item_armorInv");
				else
					return("item_artifact_invulnerability");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q2) return("item_power_shield");
		if (TR == FL_TR_Q3)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.8)
					return("q3_item_armor_body");
				else if (random() > 0.5)
					return("holdable_teleporter");
				else
					return("item_regen");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq3);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_Q2_ARM_PSCREEN)
	{
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("RMV");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.8)
					return("d_item_armorgreen");
				else
					return("d_art_soulsphere");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcd);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.8)
					return("item_armor1");
				else
					return("item_armor2");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q2) return("item_power_shield");
		if (TR == FL_TR_Q3)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.8)
					return("q3_item_armor_combat");
				else
					return("holdable_medkit");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq3);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_Q2_ADRENALINE)
	{
		if (TR == FL_TR_WOLF) return("w_art_facesphere");
		if (TR == FL_TR_DOOM) return("d_art_soulsphere");
		if (TR == FL_TR_QUAKE) return("item_health_mega");
		if (TR == FL_TR_Q2) return("item_adrenaline");
		if (TR == FL_TR_Q3) return("q3_item_health_mega");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_Q2_BREATHER)
	{
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("w_heal_medkit");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("d_item_nightvis");
				else
					return("d_item_automap");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcd);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("fn_backpack");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q2) return("item_breather");
		if (TR == FL_TR_Q3)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("holdable_medkit");
				else
					return("holdable_teleporter");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq3);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_Q2_KEY_CHEAD)
	{
		if (TR == FL_TR_WOLF) return("w_key_g");
		if (TR == FL_TR_DOOM) return("d_key_redskull");
		if (TR == FL_TR_QUAKE) return("item_key2_0");
		if (TR == FL_TR_Q2) return("key_commander_head");
		if (TR == FL_TR_Q3) return("RMV");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_Q2_KEY_PASS)
	{
		if (TR == FL_TR_WOLF) return("w_key_b");
		if (TR == FL_TR_DOOM) return("d_key_blueskull");
		if (TR == FL_TR_QUAKE) return("item_key1_0");
		if (TR == FL_TR_Q2) return("key_pass");
		if (TR == FL_TR_Q3) return("RMV");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_Q2_KEY_ATARGET)
	{
		if (TR == FL_TR_WOLF) return("w_key_g");
		if (TR == FL_TR_DOOM) return("d_key_redcard");
		if (TR == FL_TR_QUAKE) return("item_key2_2");
		if (TR == FL_TR_Q2) return("key_airstrike_target");
		if (TR == FL_TR_Q3) return("RMV");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

/// q3
	else if (e.scode == MC_Q3_LIGHTNING)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_flamer");
		if (TR == FL_TR_DOOM) return("d_weapon_plasma");
		if (TR == FL_TR_QUAKE) return("weapon_lightning");
		if (TR == FL_TR_Q2) return("weapon_hyperblaster");
		if (TR == FL_TR_Q3) return("q3_weapon_lightning");
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
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
	
	else if (e.scode == MC_Q3_GRAPPLE)
	{
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.45)
					return("w_weapon_machinegun");
				else
					return("w_barrel");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("d_weapon_saw");
				else if (random() > 0.33)
					return("d_weapon_supershotgun");
				else
					return("d_item_nightvis");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcd);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
			return("weapon_grapgun");
		}
		if (TR == FL_TR_Q2) // TDO: q2 grapple hook
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.25)
					return("q2_weapon_machinegun");
				else if (random() > 0.75)
					return("q2_weapon_railgun");
				else
					return("weapon_hyperblaster");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq2);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q3)
		{
			return("weapon_grapplinghook");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_Q3_REGEN)
	{
		e.rune_flag = e.spawnflags;
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.6)
					return("w_art_facesphere");
				else
					return("w_item_pack");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("d_weapon_saw");
				else if (random() > 0.5)
					return("d_item_pack");
				else
					return("d_art_invulnerable");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcd);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
//			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
//			else if (TR_NOT == FL_NOTRN_BG) // NOTE: maybe check rune server and do something else if no runes?
//			{
					e.spawnflags = RUNE_FLG_RG;
					return("item_sigil");
//			}
//			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
//			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
//			return("");
		}
		if (TR == FL_TR_Q2)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("item_adrenaline");
				else if (random() > 0.5)
					return("item_power_shield");
				else
					return("item_invulnerability");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq2);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q3)
		{
			e.spawnflags = e.rune_flag;
			return("item_regen");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_Q3_HASTE)
	{
		e.rune_flag = e.spawnflags;
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.6)
					return("w_art_facesphere");
				else
					return("w_item_pack");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("d_weapon_saw");
				else if (random() > 0.5)
					return("d_item_pack");
				else
					return("d_art_megasphere");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcd);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
//			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
//			else if (TR_NOT == FL_NOTRN_BG) // NOTE: maybe check rune server and do something else if no runes?
//			{
					e.spawnflags = RUNE_FLG_HS;
					return("item_sigil");
//			}
//			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
//			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
//			return("");
		}
		if (TR == FL_TR_Q2)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("item_adrenaline");
				else if (random() > 0.5)
					return("item_power_shield");
				else
					return("item_pack");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq2);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q3)
		{
			e.spawnflags = e.rune_flag;
			return("item_haste");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_Q3_FLIGHT)
	{
		e.rune_flag = e.spawnflags;
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.6)
					return("w_art_facesphere");
				else
					return("w_item_pack");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("d_weapon_saw");
				else if (random() > 0.5)
					return("d_item_pack");
				else
					return("d_art_soulsphere");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcd);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
//					e.spawnflags = RUNE_FLG_HS; // no flight rune yet
				if (random() > 0.5)
					return("fn_backpack");
				else
					return("item_painkeep_gwell");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q2)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				if (random() > 0.5)
					return("item_adrenaline");
				else if (random() > 0.5)
					return("q2_item_armor_body");
				else
					return("q2_item_health_mega");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq2);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q3)
		{
			e.spawnflags = e.rune_flag;
			return("item_flight");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_Q3_HOLDMEDKIT)
	{
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("w_art_facesphere");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq3);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
					return("d_art_soulsphere");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcd);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
			return("item_painkeep_can");
		}
		if (TR == FL_TR_Q2)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("item_adrenaline");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq2);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q3)
		{
			return("holdable_medkit");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

	else if (e.scode == MC_Q3_HOLDTELE)
	{
		if (TR == FL_TR_WOLF)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("w_barrel");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcw);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_DOOM)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
					return("d_item_nightvis");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcd);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_QUAKE)
		{
			return("item_pkplus_phone");
		}
		if (TR == FL_TR_Q2)
		{
			if (TR_NOT == FL_NOTRN_RMV) return("RMV");
			else if (TR_NOT == FL_NOTRN_BG)
			{
				return("item_bandolier");
			}
			else if (TR_NOT == FL_NOTRN_RNDIN) return(mcq2);
			else if (TR_NOT == FL_NOTRN_RNDANY) return(mcg);
			return("");
		}
		if (TR == FL_TR_Q3)
		{
			return("holdable_teleporter");
		}
		if (TR == FL_TR_RANDIN) return(mcg);
		if (TR == FL_TR_RANDOM) return(mcg);
		if (TR >= FL_TR_REMOVE) return("RMV");
	}

/// hipnotic - for now just removes in case of *100
	else if (e.scode == MC_HIP_MJOLNIR)
	{
		if (Q_100 || PK_100)
		{
			return("RMV");
		}
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_HIP_LASERCAN)
	{
		if (Q_100 || PK_100)
		{
			return("RMV");
		}
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_HIP_PROXGUN)
	{
		if (Q_100 || PK_100)
		{
			return("RMV");
		}
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_HIP_WETSUIT)
	{
		if (Q_100 || PK_100)
		{
			return("RMV");
		}
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_HIP_EMPSH)
	{
		if (Q_100 || PK_100)
		{
			return("RMV");
		}
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_HIP_CORNUCOPIA)
	{
		if (Q_100 || PK_100)
		{
			return("RMV");
		}
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_REGGUN)
	{
		if (Q_100 || PK_100)
		{
			return("RMV");
		}
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_C_FLAMER)
	{
		if (Q_100 || PK_100)
		{
			return("RMV");
		}
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_C_AGAS)
	{
		if (Q_100 || PK_100)
		{
			return("RMV");
		}
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_C_AGAS_LG)
	{
		if (Q_100 || PK_100)
		{
			return("RMV");
		}
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
		e.mcode = pk_mcode("", e);
		e.sscode = sid_code[(int)(e.mcode - 100) * %4]; // just for doom_alpha code
	}
	if (WARNING) bprint("\n");
};

void(entity e, float trv) master_item_control =
{
	if (e.classname == "func_make") return; // override

	if (!PK_100 && !Q_100) // turned back on - come here from loop
	{
		if (cvar("pk_place_item") == 1) return;
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

// allow live translate of any items
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
	if (tr == FL_TR_DOOM) return("DooM");
	if (tr == FL_TR_QUAKE) return("Quake");
	if (tr == FL_TR_Q2) return("Quake 2");
	if (tr == FL_TR_Q3) return("Quake 3");
	if (tr == FL_TR_RESTORE) return("Restoring");
	if (tr == FL_TR_RANDIN) return("Random genre");
	if (tr == FL_TR_RANDOM) return("any Random item");
	if (tr == FL_TR_REMOVE) return("code = removing");
	return("null - removing");
};

// run map translations

void() check_translate =
{
		if (DOOM_ALPHA != cvar("pk_doom_alpha"))
		{
			local float f;
			local entity e;
			DOOM_ALPHA = cvar("pk_doom_alpha"); // set doom alpha level - intended to be loaded by server cfg
			f = MC_D_SAW;
			while (f < MC_DOOM)
			{
				e = find(world,sscode,ftos(f));
				while (e)
				{
					doom_alpha_tran(e, 0);
					e = find(e,sscode,ftos(f));
				}
				f = f + 1;
			}
		}

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
			TR_Q3 = fabs(cvar("pk_tr_q3" ));
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
old translate chart used for permanent code xlates

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


// doom alpha translates

// mc is set by map spawn fn
// final release is always default

void(entity e, float mc) doom_alpha_tran =
{
/// arts
	if (e.mcode == MC_D_INVUL || mc == MC_D_INVUL)
	{
		if (DOOM_ALPHA == 0.4 || DOOM_ALPHA == 0.5)
		{
// 0.4, 0.5
		setmodel (e, "progs/d_bottle.mdl");
		if (mc)
			e.frame = 3; // map load needs diff position
		else
		e.frame = 4;
		e.skin = 2;
		}
		else if (DOOM_ALPHA == 0.6)
		{
// pre-beta
		setmodel (e, "progs/d_bottle.mdl");
		if (mc)
			e.frame = 2; // map load needs diff position
		else
		e.frame = 1;
		e.skin = 1;
		}
		else // if (!DOOM_ALPHA) // default here
		{
// release
			setmodel (e, "progs/d_spheres.mdl");
			e.frame = 0;
			e.skin = 2;
		}
		return;
	}
	if (e.mcode == MC_D_INVIS || mc == MC_D_INVIS)
	{
		if (DOOM_ALPHA == 0.4 || DOOM_ALPHA == 0.5) // 0.4, 0.5
		{
		setmodel (e, "progs/d_bottle.mdl");
		if (mc)
			e.frame = 3; // map load needs diff position
		else
		e.frame = 4;
		e.skin = 3;
		}
		else if (DOOM_ALPHA == 0.6) // pre-beta
		{
		setmodel (e, "progs/d_spheres.mdl");
		e.frame = 1;
		e.skin = 5;
		}
		else
		{
		setmodel (e, "progs/d_spheres.mdl");
		e.frame = 0;
		e.skin = 3;
		}
		return;
	}
	if (e.mcode == MC_D_BERS || mc == MC_D_BERS)
	{
		if (DOOM_ALPHA == 0.4 || DOOM_ALPHA == 0.5) // 0.4, 0.5
		{
		setmodel (e, "progs/d_bottle.mdl");
		e.frame = 3;
		e.skin = 5;
		}
		else
		{
		setmodel(e, "progs/d_berzerk.mdl");
		e.frame = 0;
		e.skin = 0;
		}
		return;
	}
	if (e.mcode == MC_D_SOULSPH || mc == MC_D_SOULSPH)
	{
		if (DOOM_ALPHA == 0.4 || DOOM_ALPHA == 0.5) // 0.4, 0.5
		{
		setmodel (e, "progs/d_bottle.mdl");
		if (mc)
			e.frame = 3; // map load needs diff position
		else
		e.frame = 4;
		e.skin = 7;
		}
		else
		{
		setmodel(e, "progs/d_spheres.mdl");
		e.frame = 0;
		e.skin = 0;
		}
		return;
	}
	if (e.mcode == MC_D_MEGASPH || mc == MC_D_MEGASPH)
	{
		if (DOOM_ALPHA == 0.4 || DOOM_ALPHA == 0.5) // 0.4, 0.5
		{
		setmodel (e, "progs/d_bottle.mdl");
		if (mc)
			e.frame = 3; // map load needs diff position
		else
		e.frame = 4;
		e.skin = 8;
		}
		else
		{
		setmodel(e, "progs/d_spheres.mdl");
		e.frame = 0;
		e.skin = 1;
		}
		return;
	}
/// heal
	if (e.mcode == MC_D_MEDKIT || mc == MC_D_MEDKIT)
	{
		if (DOOM_ALPHA == 0.4) // 0.4
		{
		setmodel(e, "progs/barrel2.mdl");
		e.frame = 3;
		e.skin = 3;
		}
		else if (DOOM_ALPHA == 0.5) // 0.5
		{
		setmodel(e, "progs/heal_medkit.mdl");
		e.frame = 2;
		e.skin = 2;
		}
		else
		{
		setmodel(e, "progs/heal_medkit.mdl");
		e.frame = 0;
		e.skin = 0;
		}
		return;
	}
	if (e.mcode == MC_D_STIMPAK || mc == MC_D_STIMPAK)
	{
		if (DOOM_ALPHA == 0.4) // 0.4
		{
		setmodel(e, "progs/d_stimpack04.mdl");
		e.frame = 0;
		e.skin = 0;
		}
		else if (DOOM_ALPHA == 0.5) // 0.5
		{
		setmodel(e, "progs/heal_medkit.mdl");
		e.frame = 1;
		e.skin = 1;
		}
		else
		{
		setmodel(e, "progs/heal_medkit.mdl");
		e.frame = 3;
		e.skin = 3;
		}
		return;
	}
	if (e.mcode == MC_D_HBOTTLE || mc == MC_D_HBOTTLE)
	{
/*		if (DOOM_ALPHA == 0.6) // pre-beta
		{
		setmodel (e, "progs/d_.mdl");
		e.frame = 1;
		}
		else // release
		{
*/
		setmodel(e, "progs/d_bottle.mdl");
		e.frame = 0;
		e.skin = 0;
//		}
		return;
	}
/// armor
	if (e.mcode == MC_D_ARM_SPR || mc == MC_D_ARM_SPR)
	{
		if (DOOM_ALPHA == 0.4 || DOOM_ALPHA == 0.5 || DOOM_ALPHA == 0.6) // 0.4, 0.5, pb
		{
		setmodel (e, "progs/d_cellbox.mdl");
		e.frame = 1;
		e.skin = 1;
		}
		else
		{
		setmodel (e, "progs/spiritarmor.mdl");
		e.frame = 0;
		e.skin = 0;
		}
		return;
	}
	if (e.mcode == MC_D_ARM_BLU || mc == MC_D_ARM_BLU)
	{
		if (DOOM_ALPHA == 0.4 || DOOM_ALPHA == 0.5) // 0.4, 0.5
		{
		setmodel (e, "progs/d_armor.mdl");
		e.frame = 1;
		e.skin = 0;
		}
		else
		{
		setmodel (e, "progs/d_armor.mdl");
		e.frame = 0;
		e.skin = 1;
		}
		return;
	}
/// ammo
	if (e.mcode == MC_D_ACELLS || mc == MC_D_ACELLS)
	{
/* for neg or special xlate - not a cell pack

	if (DOOM_ALPHA == 0.4) // shield generator
		{
		setmodel (e, "progs/d_cellpack.mdl");
		e.frame = 1;
		e.skin = 1;
		}
		*/

	if (DOOM_ALPHA == 0.4 || DOOM_ALPHA == 0.5) // 0.4, 0.5
		{
		setmodel (e, "progs/d_cellbox.mdl");
		e.frame = 0;
		e.skin = 2;
		}
	else if (DOOM_ALPHA == 0.6) // pre-beta
		{
		setmodel (e, "progs/d_cellbox.mdl");
		e.frame = 0;
		e.skin = 3;
		}
	else // release
		{
			setmodel (e, "progs/d_cellpack.mdl");
			e.frame = 0;
			e.skin = 0;
		}
		return;
	}
	if (e.mcode == MC_D_ABULLETS_LG || mc == MC_D_ABULLETS_LG)
	{
/*		if (DOOM_ALPHA == 0.6) // pre-beta
		{
		setmodel (e, "progs/d_.mdl");
		e.frame = 1;
		}
		else // release
		{
*/
		setmodel (e, "progs/d_ammobox.mdl");
		e.frame = 0;
//		}
		return;
	}
	if (e.mcode == MC_D_ABULLETS || mc == MC_D_ABULLETS)
	{
/*		if (DOOM_ALPHA == 0.4)
		{
		setmodel (e, "progs/d_.mdl");
		e.frame = 1;
		}
		else // release
		{
*/
		setmodel (e, "progs/d_clip.mdl");
		e.frame = 0;
//		}
		return;
	}
	if (e.mcode == MC_D_AROCKET || mc == MC_D_AROCKET)
	{
/*		if (DOOM_ALPHA == 0.6) // pre-beta
		{
		setmodel (e, "progs/d_.mdl");
		e.frame = 1;
		}
		else // release
		{
*/
		setmodel (e, "progs/d_1rocket.mdl");
		e.frame = 0;
//		}
		return;
	}
	if (e.mcode == MC_D_AROCKETS_LG || mc == MC_D_AROCKETS_LG)
	{
/*		if (DOOM_ALPHA == 0.6) // pre-beta
		{
		setmodel (e, "progs/d_.mdl");
		e.frame = 1;
		}
		else // release
		{
*/
		setmodel (e, "progs/d_rockbox.mdl");
		e.frame = 0;
//		}
		return;
	}
	if (e.mcode == MC_D_ASHELLS || mc == MC_D_ASHELLS)
	{
		if (DOOM_ALPHA == 0.6) // pre-beta
		{
		setmodel (e, "progs/d_shellbox.mdl");
		e.frame = 2;
		}
		else // release
		{
		setmodel (e, "progs/d_4shell.mdl");
		e.frame = 0;
		}
		return;
	}
	if (e.mcode == MC_D_ASHELLS_LG || mc == MC_D_ASHELLS_LG)
	{
		setmodel (e, "progs/d_shellbox.mdl");
		if (DOOM_ALPHA == 0.6) // pre-beta
		{
		e.frame = 1;
		}
		else // release
		{
		e.frame = 0;
		}
		return;
	}
/// keys
	if (e.mcode == MC_D_KEY_RED_CR || mc == MC_D_KEY_RED_CR)
	{
		if (DOOM_ALPHA == 0.4 || DOOM_ALPHA == 0.5) // 0.4, 0.5
		{
		setmodel (e, "progs/d_cardkey.mdl");
		e.frame = 1;
		e.skin = 3;
		}
		else
		{
		setmodel (e, "progs/d_cardkey.mdl");
		e.frame = 0;
		e.skin = 0;
		}
		return;
	}
	if (e.mcode == MC_D_KEY_BLU_CR || mc == MC_D_KEY_BLU_CR)
	{
		if (DOOM_ALPHA == 0.4 || DOOM_ALPHA == 0.5) // 0.4, 0.5
		{
		setmodel (e, "progs/d_cardkey.mdl");
		e.frame = 1;
		e.skin = 4;
		}
		else
		{
		setmodel (e, "progs/d_cardkey.mdl");
		e.frame = 0;
		e.skin = 1;
		}
		return;
	}
	if (e.mcode == MC_D_KEY_YEL_CR || mc == MC_D_KEY_YEL_CR)
	{
		if (DOOM_ALPHA == 0.4 || DOOM_ALPHA == 0.5) // 0.4, 0.5
		{
		setmodel (e, "progs/d_cardkey.mdl");
		e.frame = 1;
		e.skin = 5;
		}
		else
		{
		setmodel (e, "progs/d_cardkey.mdl");
		e.frame = 0;
		e.skin = 2;
		}
		return;
	}
/// stuff
	if (e.mcode == MC_D_NIGHTVS || mc == MC_D_NIGHTVS)
	{
/*		if (DOOM_ALPHA == 0.6) // pre-beta
		{
		setmodel (e, "progs/d_.mdl");
		e.frame = 1;
		}
		else // release
		{
*/
		setmodel(e, "progs/d_vis.mdl");
		e.frame = 0;
		e.skin = 0;
//		}
		return;
	}
	
};
