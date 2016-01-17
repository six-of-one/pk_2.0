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

// some weapons are translated in equivs

/*QUAKED weapon_bfg (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_bfg =
{
	self.classname = "weapon_chainlg";

	precache_model ("progs/g_clight.mdl");
	setmodel (self,"progs/g_clight.mdl");
	self.pk_currentitem = PK_IT_CLIGHT;
	self.netname = "Chain Thunderbolt";
	self.touch = painkeep_weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
//	if (!(pk_flags & PK_MAP) && !PK) pk_map = PK = TRUE; // *pk - in map mode, set PK for painkeep mode
//	pk_ditems = pk_ditems + 1;
};

/*QUAKED weapon_plasmagun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_plasmagun =
{
	weapon_bfg();
};

/*QUAKED weapon_machinegun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_machinegun =
{
	if (random() < 0.6)
	{
		self.classname = "weapon_supernailgun";
		weapon_supernailgun();
	}
	else
	{
		self.classname = "weapon_nailgun";
		weapon_nailgun();
	}
};

/*QUAKED weapon_shotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_shotgun =
{
	self.classname = "weapon_supershotgun";
	weapon_supershotgun();
};


/*QUAKED weapon_grapplinghook (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_grapplinghook =
{
	self.classname = "weapon_grapgun";
	self.touch = painkeep_weapon_touch;

	precache_model ("progs/g_harp.mdl");
	setmodel (self,"progs/g_harp.mdl");
	self.pk_currentitem = PK_IT_GRAPGUN;
	self.netname = "Harpoon Gun";
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
//	if (!(pk_flags & PK_MAP) && !PK) pk_map = PK = TRUE; // *pk - in map mode, set PK for painkeep mode
//	pk_ditems = pk_ditems + 1;
};

//weapon_lightning
//weapon_railgun

void() ammo_bullets =
{
	self.spawnflags = self.spawnflags | 1;
	item_spikes();
}

void() ammo_grenades =
{
	item_rockets();
}

void() ammo_lightning =
{
	local entity e;
	self.spawnflags = self.spawnflags | 1;
	item_cells();
	e = spawn();
	setorigin(e, self.origin);
	e.spawnflags = self.spawnflags;
	self = e;
	item_cells();
}

void() ammo_bfg =
{
	self.spawnflags = self.spawnflags | 1;
	item_cells();
}


//ammo_shells
//ammo_rockets
//ammo_cells
//ammo_slugs

void() item_armor_combat =
{
	self.classname = "item_armor2";
	item_armor2();
};

void() item_armor_body =
{
	self.classname = "item_armorInv";
	item_armorInv();
};

// 2 * health

void() item_health_large =
{
	local entity e;
	item_health();
	e = spawn();
	setorigin(e, self.origin);
	e.spawnflags = self.spawnflags;
	self = e;
	item_health();
};

void() item_health_mega =
{
	self.spawnflags = self.spawnflags | 2;
	item_health();
};

void() item_quad =
{
	item_artifact_super_damage();
};

void() item_regen =
{
	item_artifact_invulnerability();
};

void() item_invis =
{
	item_artifact_invisibility();
};

void() item_enviro =
{
	item_artifact_envirosuit();
};

void() misc_teleporter_dest =
{
	self.classname = "info_teleport_destination";
	info_teleport_destination();
};