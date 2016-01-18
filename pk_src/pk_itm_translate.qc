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

// TDO: restore wad == "q1" item with doom item deactivate / pk_100 mode on (if ever allowed in map)
// IDEA: move code to dyn & handle all translateable map items

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
	local float dr, wr;
	local string mc;

	dr = MC_D_SAW + floor(random() * (MC_D_RNDITM - 1));
	wr = MC_W_KNIFE + floor(random() * (MC_W_RNDITM));

	if (TR == FL_TR_RESTORE)
	{
		mc = item_by_mcode(self.scode);
		if (mc != "")
			return(mc);
		else
		{
			if (!TR_NOT) return(self.classname);
			else if (TR_NOT == FL_NOTRN_RMV) return("RMV");
		}
	}

	if (e.scode == MC_D_BFG)
	{
		if (TR == FL_TR_WOLF)
		{
			if (random() > 0.25)
				return("w_weapon_chaingun"); // most powerful wolf wep is prob dual chg
			else if (random() > 0.5)
				return("w_weapon_flamer");
			else
				return("w_weapon_motar");
		}
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_weapon_bfg");
		if (TR == FL_TR_QUAKE) return("weapon_chainlg");
		if (TR == FL_TR_Q2) return("q2_weapon_bfg");
		if (TR == FL_TR_Q3) return("q3_weapon_bfg");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	if (e.scode == MC_D_PLASMA)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_flamer");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_weapon_plasma");
		if (TR == FL_TR_QUAKE) return("weapon_lightning");
		if (TR == FL_TR_Q2) return("weapon_hyperblaster");
		if (TR == FL_TR_Q3) return("weapon_plasmagun");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	if (e.scode == MC_D_ROCKETL)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_mortar");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_weapon_rocketlauncher");
		if (TR == FL_TR_QUAKE) return("weapon_rocketlauncher");
		if (TR == FL_TR_Q2) return("q2_weapon_rocketlauncher");
		if (TR == FL_TR_Q3) return("q3_weapon_rocketlauncher");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_CHAINGUN)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_chaingun");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_weapon_chaingun");
		if (TR == FL_TR_QUAKE) return("weapon_supernailgun");
		if (TR == FL_TR_Q2) return("q2_weapon_chaingun");
		if (TR == FL_TR_Q3) return("q3_weapon_machinegun");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_BOOMSTICK)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_machinegun");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_weapon_supershotgun");
		if (TR == FL_TR_QUAKE) return("weapon_supershotgun");
		if (TR == FL_TR_Q2) return("q2_weapon_supershotgun");
		if (TR == FL_TR_Q3) return("q3_weapon_shotgun");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_SHOTGUN)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_machinegun");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_weapon_shotgun");
		if (TR == FL_TR_QUAKE) return("weapon_shotgun");
		if (TR == FL_TR_Q2) return("q2_weapon_shotgun");
		if (TR == FL_TR_Q3) return("q3_weapon_shotgun");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_SAW)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_knife");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_weapon_saw");
		if (TR == FL_TR_QUAKE) return("weapon_axe");
		if (TR == FL_TR_Q2) return("q2_weapon_blaster"); // TDO: map item
		if (TR == FL_TR_Q3) return("weapon_gauntlet");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_BERS)
	{
		if (TR == FL_TR_WOLF) return("RMV"); // IDEA: just leave on map, or designate a wolf item as quad?
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_art_berserker");
		if (TR == FL_TR_QUAKE) return("item_artifact_super_damage");
		if (TR == FL_TR_Q2) return("q2_item_quad");
		if (TR == FL_TR_Q3) return("q3_item_quad");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_INVUL)
	{
		if (TR == FL_TR_WOLF) return("RMV"); // IDEA: just leave on map, or designate a wolf item as inv?
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_art_invulnerable");
		if (TR == FL_TR_QUAKE) return("item_artifact_invulnerability");
		if (TR == FL_TR_Q2) return("item_invulnerability");
		if (TR == FL_TR_Q3)
		{
			if (random() > 0.4)
				return("item_regen");
			else
				return("q3_item_enviro");
		}
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_INVIS)
	{
		if (TR == FL_TR_WOLF) return("RMV");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_art_invisible");
		if (TR == FL_TR_QUAKE) return("item_artifact_invisibility");
		if (TR == FL_TR_Q2) return("item_silencer");
		if (TR == FL_TR_Q3) return("item_invis");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_RADSUIT)
	{
		if (TR == FL_TR_WOLF) return("RMV");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_art_radsuit");
		if (TR == FL_TR_QUAKE) return("item_artifact_envirosuit");
		if (TR == FL_TR_Q2) return("q2_item_enviro");
		if (TR == FL_TR_Q3) return("q3_item_enviro");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_SOULSPH)
	{
		if (TR == FL_TR_WOLF) return("w_face_sphere");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_art_soulsphere");
		if (TR == FL_TR_QUAKE) return("item_health_mega");
		if (TR == FL_TR_Q2) return("q2_item_health_mega");
		if (TR == FL_TR_Q3) return("q3_item_health_mega");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ARM_BLU)
	{
		if (TR == FL_TR_WOLF) return("RMV");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_item_armorblue");
		if (TR == FL_TR_QUAKE) return("item_armorInv");
		if (TR == FL_TR_Q2) return("q2_item_armor_body");
		if (TR == FL_TR_Q3) return("q3_item_armor_body");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ARM_GRN)
	{
		if (TR == FL_TR_WOLF) return("RMV");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_item_armorgreen");
		if (TR == FL_TR_QUAKE) return("item_armor2");
		if (TR == FL_TR_Q2) return("q2_item_armor_combat");
		if (TR == FL_TR_Q3) return("q3_item_armor_combat");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ARM_SPR)
	{
		if (TR == FL_TR_WOLF) return("RMV");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_item_spiritarmor");
		if (TR == FL_TR_QUAKE) return("RMV"); // item_armor1 - not a good translation
		if (TR == FL_TR_Q2) return("q2_item_armor_shard");
		if (TR == FL_TR_Q3) return("q3_item_armor_shard");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ASHELLS)
	{
		if (TR == FL_TR_WOLF) return("w_clip");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_ammo_4shell");
		if (TR == FL_TR_QUAKE) return("item_shells");
		if (TR == FL_TR_Q2) return("q2_ammo_shells");
		if (TR == FL_TR_Q3) return("q3_ammo_shells");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ASHELLS_LG)
	{
		if (TR == FL_TR_WOLF) return("w_clip");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_ammo_shellbox");
		if (TR == FL_TR_QUAKE) return("item_shells_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_shells");
		if (TR == FL_TR_Q3) return("q3_ammo_shells");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ACELLS)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_flamer");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_ammo_cellpack");
		if (TR == FL_TR_QUAKE) return("item_cells");
		if (TR == FL_TR_Q2) return("q2_ammo_cells");
		if (TR == FL_TR_Q3) return("q3_ammo_cells");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ACELLS_LG)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_flamer"); // TDO: gas can ammo
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_ammo_cellbox");
		if (TR == FL_TR_QUAKE) return("item_cells_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_cells");
		if (TR == FL_TR_Q3) return("q3_ammo_cells");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_AROCKET)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_mortar");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_ammo_1rocket");
		if (TR == FL_TR_QUAKE) return("item_rockets");
		if (TR == FL_TR_Q2) return("q2_ammo_rockets");
		if (TR == FL_TR_Q3) return("q3_ammo_rockets");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_AROCKETS_LG)
	{
		if (TR == FL_TR_WOLF) return("w_weapon_mortar");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_ammo_rockbox");
		if (TR == FL_TR_QUAKE) return("item_rockets_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_rockets");
		if (TR == FL_TR_Q3) return("q3_ammo_rockets");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ABULLETS)
	{
		if (TR == FL_TR_WOLF) return("w_clip");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_ammo_clip");
		if (TR == FL_TR_QUAKE) return("item_spikes");
		if (TR == FL_TR_Q2) return("q2_ammo_bullets");
		if (TR == FL_TR_Q3) return("q3_ammo_bullets");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_D_ABULLETS_LG)
	{
		if (TR == FL_TR_WOLF) return("w_clip");
		if (TR == FL_TR_RESTORE || TR == FL_TR_DOOM) return("d_ammo_ammobox");
		if (TR == FL_TR_QUAKE) return("item_spikes_lg");
		if (TR == FL_TR_Q2) return("q2_ammo_bullets");
		if (TR == FL_TR_Q3) return("q3_ammo_bullets");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(dr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
/// wolf
	else if (e.scode == MC_W_MORTAR)
	{
		if (TR == FL_TR_RESTORE || TR == FL_TR_WOLF) return("w_weapon_mortar");
		if (TR == FL_TR_DOOM) return("d_weapon_rocketlauncher");
		if (TR == FL_TR_QUAKE) return("weapon_rocketlauncher");
		if (TR == FL_TR_Q2) return("q2_weapon_rocketlauncher");
		if (TR == FL_TR_Q3) return("q3_weapon_rocketlauncher");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(wr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_W_FLAMER)
	{
		if (TR == FL_TR_RESTORE || TR == FL_TR_WOLF) return("w_weapon_flamer");
		if (TR == FL_TR_DOOM) return("d_weapon_plasma");
		if (TR == FL_TR_QUAKE) return("weapon_lightning");
		if (TR == FL_TR_Q2) return("weapon_hyperblaster");
		if (TR == FL_TR_Q3) return("weapon_plasmagun");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(wr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_W_CHAINGUN)
	{
		if (TR == FL_TR_RESTORE || TR == FL_TR_WOLF) return("w_weapon_chaingun");
		if (TR == FL_TR_DOOM) return("d_weapon_chaingun");
		if (TR == FL_TR_QUAKE) return("weapon_supernailgun");
		if (TR == FL_TR_Q2) return("weapon_chaingun");
		if (TR == FL_TR_Q3) return("q3_weapon_machinegun");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(wr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_W_MACHGUN)
	{
		if (TR == FL_TR_RESTORE || TR == FL_TR_WOLF) return("w_weapon_machinegun");
		if (TR == FL_TR_DOOM) return("d_weapon_supershotgun");
		if (TR == FL_TR_QUAKE) return("weapon_nailgun");
		if (TR == FL_TR_Q2) return("q2_weapon_machinegun");
		if (TR == FL_TR_Q3) return("q3_weapon_machinegun");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(wr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_W_PISTOL)
	{
		if (TR == FL_TR_RESTORE || TR == FL_TR_WOLF) return("w_weapon_pistol");
		if (TR == FL_TR_DOOM) return("d_weapon_pistol");
		if (TR == FL_TR_QUAKE) return("weapon_shotgun");
		if (TR == FL_TR_Q2) return("q2_blaster");
		if (TR == FL_TR_Q3) return("weapon_gauntlet");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(wr));
		if (TR >= FL_TR_REMOVE) return("RMV");
	}
	else if (e.scode == MC_W_KNIFE)
	{
		if (TR == FL_TR_RESTORE || TR == FL_TR_WOLF) return("w_weapon_knife");
		if (TR == FL_TR_DOOM) return("d_weapon_saw");
		if (TR == FL_TR_QUAKE) return("weapon_axe");
		if (TR == FL_TR_Q2) return("q2_weapon_blaster"); // TDO: map item
		if (TR == FL_TR_Q3) return("weapon_gauntlet");
		if (TR == FL_TR_RANDIN) return(item_by_mcode(wr));
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
		NO_PI = 3.1415;
		if(e.map == "repic") e.map = "pic_item";
		item_call_save(e, mcc);
	}
	if (WARNING) bprint("\n");
};

void(entity e, float trv) master_item_control =
{
	if (e.classname == "func_make") return; // override

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
		bprint("\n - action for items with no direct translation:\n                0 = no change, 1 = remove, 2 = best guess, 3 = randomize in genre, 4 = randomize to any \n");
		bprint("var: pk_tr_q1def = ");
		bprint(ftos(TR_Q1DEF));
		bprint(" - pk_100 or q_100 and now q1 items on non quake map - 0 = remove, 1 = translate to quake\n");
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
		}
		else
			bprint("No translations set\n");
	bprint("\n");
	}

	cvar_set("pk_translate", "0");

};

// common item temp code - does nothing for now

void() q2_weapon_rocketlauncher =
{
	SUB_Nop();
};

void() q3_weapon_rocketlauncher =
{
	SUB_Nop();
};
