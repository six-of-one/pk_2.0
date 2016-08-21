/* ::-::
 *
 * Cataboligne
 *
 * file: pk_itm_dynamic.qc
 *
 * date: 
 *
 * qc - support painkeep 2.0 dynamic items
 *
 */


// fn(item_repm) - replace / remove all items matching with a new item
// fn(item_bit) - provide item classname string by bit
// fn(item_call) - make item call based on string
// fn(item_down) - item (self) is removed from play for this map till admin overrides removal or new map is loaded
// fn(item_loop) - run loop making changes per pk_itemovr
// rep - item classname to replace
// cls - new classname
// op - save original classname in .wad so we can restore if mode is turned off

string (float bt) item_by_bit =
{
	if (bt == WEP_SSHOT) return("weapon_supershotgun");
	if (bt == WEP_NAILGUN) return("weapon_nailgun");
	if (bt == WEP_PERF) return("weapon_supernailgun");
	if (bt == WEP_GREN) return("weapon_grenadelauncher");
	if (bt == WEP_ROCKET) return("weapon_rocketlauncher");
	if (bt == WEP_THUNDER) return("weapon_lightning");
	if (bt == WEP_PKI) return("pki");
	if (bt == ART_INV) return("item_artifact_invulnerability");
	if (bt == ART_RAD) return("item_artifact_envirosuit");
	if (bt == ART_RING) return("item_artifact_invisibility");
	if (bt == ART_QUAD) return("item_artifact_super_damage");
	if (bt == ARM_GRN) return("item_armor1");
	if (bt == ARM_YEL) return("item_armor2");
	if (bt == ARM_RED) return("item_armorInv");
	if (bt == HEAL_15) return("item_health_15");
	if (bt == HEAL_25) return("item_health");
	if (bt == HEAL_100) return("item_health_mega");

	return("");
};

// ammo for a given wep - used for replacements & pk items subs

string (float bt) ammo_by_bit =
{
// wep ammo by bit
	if (bt == WEP_SSHOT) return("item_shells");
	if (bt == WEP_NAILGUN) return("item_spikes");
	if (bt == WEP_PERF) return("item_spikes");
	if (bt == WEP_GREN) return("item_rockets");
	if (bt == WEP_ROCKET) return("item_rockets");
	if (bt == WEP_THUNDER) return("item_cells");
	if (bt == WEP_PKI) return("pki");

	if (Q_100 | Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
		return("");
	
// pk item subs by special bits
	if (bt == WEP_GWELL) return("item_painkeep_gwell");
	if (bt == WEP_TURRET) return("item_painkeep_turret");
	if (bt == WEP_BTRAP) return("item_painkeep_beartrap");
	if (bt == WEP_EXPSH) return("item_painkeep_expshells");
	if (bt == WEP_GRAP) return("weapon_grapgun");
	if (bt == WEP_AIRG) return("weapon_airfist");
	if (bt == WEP_CPNB) return("item_painkeep_can");
	if (PK_ART) return(pk_art_ammo_by_bit(bt)); // Cataboligne 8.12.9 purify - pk artifacts

	return("");
};

void(string cls) item_call =
{
	if (cls == "weapon_supershotgun") weapon_supershotgun();
	else if (cls == "weapon_nailgun") weapon_nailgun();
	else if (cls == "weapon_supernailgun") weapon_supernailgun();
	else if (cls == "weapon_grenadelauncher") weapon_grenadelauncher();
	else if (cls == "weapon_rocketlauncher") weapon_rocketlauncher();
	else if (cls == "weapon_lightning")
	{
		if (PK) weapon_chainlg();
		else weapon_lightning();
	}
	else if (cls == "item_shells") { if (random() < 0.5) self.spawnflags = WEAPON_BIG2; item_shells(); }
	else if (cls == "item_spikes") { if (random() < 0.4) self.spawnflags = WEAPON_BIG2; item_spikes(); }
	else if (cls == "item_rockets") { if (random() < 0.2) self.spawnflags = WEAPON_BIG2; item_rockets(); }
	else if (cls == "item_cells") { if (random() < 0.8) self.spawnflags = WEAPON_BIG2; item_cells(); }
	else if (cls == "item_artifact_invulnerability") item_artifact_invulnerability();
	else if (cls == "item_artifact_super_damage") item_artifact_super_damage();
	else if (cls == "item_artifact_envirosuit") item_artifact_envirosuit();
	else if (cls == "item_artifact_invisibility") item_artifact_invisibility();
	else if (cls == "item_armor1") item_armor1();
	else if (cls == "item_armor2") item_armor2();
	else if (cls == "item_armorInv") item_armorInv();
	else if (cls == "item_health_15") { self.spawnflags = H_ROTTEN; item_health(); }
	else if (cls == "item_health") item_health();
	else if (cls == "item_health_mega") { self.spawnflags = H_MEGA; item_health(); }
	else if (cls == "item_painkeep_gwell") item_painkeep_gwell();
	else if (cls == "item_painkeep_turret") item_painkeep_turret();
	else if (cls == "item_painkeep_beartrap") item_painkeep_beartrap();
	else if (cls == "item_painkeep_expshells") item_painkeep_expshells();
	else if (cls == "weapon_grapgun") weapon_grapgun();
	else if (cls == "weapon_airfist") weapon_airfist();
	else if (cls == "item_painkeep_can") item_painkeep_can();
	else if (PK_ART) { if (! pk_art_item_call(cls)) return; }// Cataboligne 8.12.9 purify - pk artifacts
	else return;
	self.mdl = self.model;
	self.flags = FL_ITEM;
	self.movetype = MOVETYPE_TOSS;
	if (self.classname != "dyn_item") // dont do these for dyn items
	{
		self.classname = cls;
		if (PK) pk_placeitem();
		self.think = SUB_regen; // dont go thru place_item - use regen method
		self.nextthink = time + 1 + 3 * random(); // spread em out
		self.model = string_null;
	}
	self.solid = SOLID_NOT;
};

void() item_down =
{
	self.model = "";
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
};

void(string cls, string rep, string am, string ram) item_repm =
{
	local entity e, sv;
	local string pam;
	local float f;

	if (!find(world,wad,rep))
	{
		e = find(world,classname,rep);
		if (!e) return;
		while (e)
		{
			if (e.wad == "") e.wad = e.classname;
			e = find(e,classname,rep);
		}
	}
	pam = am;
	if (pk_itemovr & CON_INF) pam = "rem"; // inf ammo
	if (pk_itemovr & WEP_PKI)
	{
		f = WEP_STOP * ceil(2 * random()) * ceil(2 * random()) * ceil(2 * random());
		if (pk_itemovr & CON_INF) pam = "pki"; // inf ammo - pk item subs
	}
	sv = self;
	e = find(world,wad,rep);
	while (e)
	{
		self = e;
		if (cls == "rest")
		{
			item_call(rep);
			if (ram != "")
			{
				if (pam == "rem" || pam == "pki") item_repm(pam, ram, "", "");
				else item_repm("rest", ram, "", "");
			}
		}
		else if (cls == "" || cls == "pki" || cls == "rem")
		{
			if ((pk_itemovr & WEP_PKI) && PK && cls == "pki")
			{
				f = f * 2;
				if (f > WEP_CPNB) f = WEP_GWELL;
				item_call(ammo_by_bit(f)); // TDO: finish item call
			}
			else
				item_down();
			if (ram != "")
			if (ram != pam) item_repm(pam, ram, "", "");
		}
		else
		{
			item_call(cls);
			if (ram != "")
			if (ram != pam) item_repm(pam, ram, "", "");
		}
		e = find(e,wad,rep);
	}
	self = sv;
};


void() item_loop =
{
	local float f, e, pko, pks, sf, lvl, lvls, msk;
	local string cl;

	pks = 0;
	lvls = f = 1;
	e = lvl = WEP_STOP;

	while (f != CON_STOP)
	{
		pko = pk_itemovr;
		if (pko & CON_CYC)
		{
			sf = 2;
			msk = (lvl - 1) - (lvls - 1);
			f = self.cnt = self.count & msk;
			if (!f) f = self.cnt = lvls;
			else f = self.cnt = self.cnt * 2;
			if (f == lvl) f = self.cnt = lvls;
			while (sf > 0 && !(f & pk_itemovr))
			{
				f = self.cnt = self.cnt * 2;
				if (f == lvl) // loop once
				{
					f = self.cnt = lvls;
					sf = sf - 1;
				}
			}
			if (sf < 1) f = lvl;
			else
			{
				pko = f | CON_ONLY | CON_CYC;// | pko - (pko & (CON_NONE | CON_SUBS));
				pks = pks | f;
			}
		}
		else if (pko & CON_SUBS) // find a valid substitute code
		{
			e = floor(e / 2);
			if (e < lvls) e = lvl / 2;
			sf = 7;
			while ((e & pko) && e >= lvls && sf > 0)
			{
				e = floor(e / 2);
				sf = sf - 1;
			}
			if (e < lvls || sf < 1) pko = pko - (pko & CON_SUBS); // cant sub if no sub item - can this happen?
		}

	if (f != lvl)
	{
		if (! (pko & CON_RUN))
		{
			item_repm("rest", item_by_bit(f), "", ammo_by_bit(f)); // restore
//			return;
		}
		else if (f & pko) // bit active
		{
			if (pko & CON_ONLY)
			{
				for (e = lvls;e < lvl; e = e * 2)
				{
					cl = item_by_bit(f);
//					if (e != f)//{
					item_repm(cl, item_by_bit(e), ammo_by_bit(f), ammo_by_bit(e));

				}
			}
			else if (pko & CON_NONE)
			{
				cl = item_by_bit(e);
				if (pko & CON_SUBS) item_repm(cl, item_by_bit(f), ammo_by_bit(e), ammo_by_bit(f));
				else item_repm("", item_by_bit(f), "", ammo_by_bit(f));
			}
			else if (pko & CON_INF)
				item_repm("rest", item_by_bit(f), "", ammo_by_bit(f));
		}
		if (pko & CON_CYC) f = lvl;
		else f = f * 2;
	}
		if (f == lvl)
		{
//			if (lvl < CON_STOP)
//			{
//				e = lvl = CON_STOP;
//				f = lvls = ART_QUAD;
//			}

			if (lvl < ART_STOP)
			{
				e = lvl = ART_STOP;
				f = lvls = ART_QUAD;
			}
			else if (lvl < ARM_STOP)
			{
				e = lvl = ARM_STOP;
				f = lvls = ARM_GRN;
			}
			else if (lvl < HEAL_STOP)
			{
				e = lvl = HEAL_STOP;
				f = lvls = HEAL_15;
			}
		}
	}
	if (pk_itemovr & CON_CYC) // next item cycle
	{
		self.nextthink = time + CYC_TIME + crandom() * CYC_TIME;
		self.count = pks; // next cycle starts at these items
	}
	else
		remove(self);
};

// fn(infinite_ammo) - admin set infinite flag - load everyone up

// pk2.0 - retooled this so an infinte ammo wep will not give 99 units to a non inf ammo share

void() infinite_ammo =
{
	local entity e;
	local string src;

	ammo_frame = framecount + 6; // not every frame
	src = "player";
	e = find(world,classname,src);
	while (e)
	{
		if (e.health > 0) // this code has minor issues - gets replaced for advanced code set
		{
			if (e.items & IT_SUPER_SHOTGUN)
			if (pk_itemovr & WEP_SSHOT) 
			if (e.ammo_shells < 5) e.ammo_shells = 5;
			if (e.items & IT_NAILGUN)
			if (pk_itemovr & WEP_NAILGUN) 
			if (e.ammo_nails < 3) e.ammo_nails = 3;
			if (e.items & IT_SUPER_NAILGUN)
			if (pk_itemovr & WEP_PERF)
			if (e.ammo_nails < 5) e.ammo_nails = 5;
			if (e.items & IT_GRENADE_LAUNCHER)
			if (pk_itemovr & WEP_GREN)
			if (e.ammo_rockets < 2) e.ammo_rockets = 2;
			if (e.items & IT_ROCKET_LAUNCHER)
			if (pk_itemovr & WEP_ROCKET)
			if (e.ammo_rockets < 2) e.ammo_rockets = 2;
			if (e.items & IT_LIGHTNING || e.pk_items & PK_IT_CLIGHT)
			if (pk_itemovr & WEP_THUNDER)
			if (e.ammo_cells < 5) e.ammo_cells = 5;
		}
		e = find(e, classname,src);
		if (!e)
		if (src != "pk*bot")
		{
			src = "pk*bot";
			e = find(world, classname,src);
		}
	}
};

// fn(dyn_spawn) - create an item
// fn(dyn_rem) - remove a dynamic item after a timeout

void() dyn_rem =
{
	remove(self.enemy);
	remove(self);
	pk_ditems = pk_ditems - 1;
}

entity rseu; // random spawn ent origin used

void() dyn_spawn =
{
	local entity e, sv;
//	local string src;
	float ri, sf;

// get a random origin
  if (self.origin == v0)
  {
	ri = sf = 0;
	sv = e = find(world,classname,"player");
	while (e)
	{
		sv = e;
		e = find(e,classname,"player");
	}
	e = findradius(sv.origin, PK_DYNRAD);
	if (!e) return; // nothing found!
	sv = e;
	while (e.chain)
	{
		if (!e.chain) e = world;
		else if (e.chain.flags & FL_ITEM) { ri = ri + 1; e = e.chain; }
		else if (e.chain.classname == "info_player_deathmatch") { ri = ri + 1; e = e.chain; }
		else if (e.chain.classname == "info_teleport_destination") { ri = ri + 1; e = e.chain; }
		else if (e.chain.classname == "path_corner") { ri = ri + 1; e = e.chain; }
		else if (e.chain.classname == "hub_custom") { ri = ri + 1; e = e.chain; }
//		else if (e.chain.classname == "") { ri = ri + 1; e = e.chain; }
		else e.chain = e.chain.chain; // skipper!
	}
	e = sv;
	sf = ri * random(); // pick a random ent from list - idea: prioritize away from weps?
	while (sf > 0 && e)
	{
		if (rseu == e && ri > 2) { sf = sf - 1; e = e.chain; } // skipper!
		if (e) sv = e;
		e = e.chain;
		sf = sf - 1;
	}
	rseu = sv;
	self.origin = sv.origin + ' 0 0 16';
  }
  else
  {
	sv = findradius(self.origin, PK_DYNRAD);
  }
// give players notice
	bprint("*** Dynamic item spawned: ");
	bprint(self.wad);
	if (sv)
	{
		bprint(" near: ");
		bprint(sv.classname);
	}
	else
		bprint(" on the map");
	bprint("\n");

	item_call(self.wad);
	sv = spawn();
	sv.enemy = self;
	sv.think = dyn_rem;
	sv.nextthink = time + PK_DYNTO + crandom() * 55;
};

// think to handle dynamic item spawns if enabled

void() dyn_item =
{
	float cd, f, b;
	entity e;

	if (PK_100 || Q_100) // Cataboligne - 8.15.9 - pk compat mode, just in case
	{
	remove(self);
	return;
	}

	if (self.classname != "dyn_spawner")
	{
		self.classname = "dyn_spawner";
		self.nextthink = time + 5;// TEST 40 + 20 * crandom();
		self.count = 4 + 4 * random();
		if (DYN_FORCE || DYN_ARTFR_ONLY) self.count = pk_ditems + DYN_FORCE_CNT;
		if (!DYN_FORCE && !DYN_ARTFR && pk_ditems > 6) remove(self);
		else
		{
			if ((pk_flags & PK_DYNAMIC) || DYN_OVR)
			if (DYN_FORCE || DYN_ARTFR_ONLY)
			{
				bprint("*** Warning - dynamic items: force flags overlap normal flags, items may not spawn!\n");
				return;
			}
			bprint("***   Dynamic items will spawn on this map - keep an eye out\n");
		}
	}
	else if (!DYN_FORCE && !DYN_ARTFR_ONLY)
	{		
		if (!PK || (!(pk_flags & PK_DYNAMIC) && !DYN_OVR)) // got turned off go away
			remove(self);
	}
	else
	{
	if (pk_ditems < 0) pk_ditems = 0;
	if (pk_ditems < self.count)
	 {
		cd = 1 + 2 * random();
		while (cd > 0.2)
		{
			e = spawn();
			e.origin = v0; // use random locator
			if (e)
			{
				e.think = dyn_spawn;
				e.nextthink = 3 + 12 * random(); // time spread
				e.classname = "dyn_item";
				b = 7;
				f = 6.4; // painkeep items bits (7 - 13) = 128 - 8192
				if (DYN_ART || DYN_ARTFR) f = 10.4; // add in (14 - 17) 16384 - 131072
				if (DYN_ARTFR_ONLY) // only (14 - 17) 16384 - 131072
				{
					b = 14;
					f = 3.4;
				}
				e.cnt = AdminBitFlag(floor(b + f * random())); // item to spawn
				e.wad = ammo_by_bit(e.cnt); // classname to spawn
				if (random() < 0.027)  // small chance of clg + ammo
				{
					e.wad = "weapon_lightning";
					e = world;
					e = spawn();
					if (e)
					{
						e.think = dyn_spawn;
						e.nextthink = 1 + 4 * random();
						e.classname = "dyn_item";
						e.wad = "item_cells";
					}
					e = spawn();
					if (e)
					{
						e.think = dyn_spawn;
						e.nextthink = 1 + 4 * random();
						e.classname = "dyn_item";
						e.wad = "item_cells";
					}
				}
//				pk_ditems = pk_ditems + 1; // done in spawn
			}
			cd = cd - 1;
		}
	 }
	self.nextthink = time + 40 + 20 * crandom();
	}
};

// fn(bit_cnt) - count available bits for random selection

// fb - bits to count
// rb - return a random bit from set

float(float fb, float rb) bit_cnt =
{
	local float rs,f;

	if (fb > 0)
	{
		f = 1;
		while (f <= 8388608) // max float bits
		{
			if (f & fb) rs = rs + 1;
			f = f * 2;
		}
	}
	else
		return(0); // error cond - no bits set!

	if (!rb) return(rs);
// pick a random bit
	f = floor(random() * rs);
	rs = f;

	f = 1;
	while (f <= 8388608 && rs > -1) // max float bits
	{
		if (f & fb) rs = rs - 1;
		if (rs > -1) f = f * 2;
	}

	return(f);
};

// fn(func_dynitem) - map load dynamic item ent maker

// wait - time between spawns in secs
// delay - random deviation, neg (-) number uses crandom, randomize spawn time of item
// lip - range from origin to spawn items in quake units
// spawnflags & 1 - uses dyn spawn locator code
// spawnflags & 2 - spawn random ammo for weps loaded by fn - uses dyn_spawn locator code
// dest1 - weapon bit codes to select from
// dest2 - item bit codes to select from

// sv_kill_func_dynitem - stop func_dynitem processing

void() func_dynitem =
{
	local float rv, sb;
	local entity e;
	local vector v1;

	if (PK_100 || Q_100)
	{
	remove(self);
	return;
	}

// clear any of this
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;

// loop
	if (rv < 0) rv = crandom() * self.delay;
	else rv = random() * self.delay;

	self.think = func_dynitem;
	self.nextthink = time + self.wait + rv;

// spawn an item
	e = spawn();
	if (e)
	{
		e.think = dyn_spawn;
		e.nextthink = 1 + self.delay * random(); // time spread -- FIX - get rid of neg number
		e.classname = "dyn_item";

		if (self.spawnflags & 1) // cheat this - just use x,y coord
		{
			local float sf;
			sf = 100;
			v1_z = self.origin_z;
			v1_x = self.origin_x + crandom() * self.lip;
			v1_y = self.origin_y + crandom() * self.lip;
			while (pointcontents(v1) == CONTENT_SOLID && sf > 0) // IDEA - check lava below?
			{
				sf = sf - 1;
				v1_x = self.origin_x + crandom() * self.lip;
				v1_y = self.origin_y + crandom() * self.lip;
			}
			if (sf < 0) v1 = self.origin;
			setorigin(e, v1);
		}
		else
			setorigin(e, self.origin);
		if (self.dest1_x)
		{
			sb = e.cnt = bit_cnt(self.dest1_x, TRUE);
			e.wad = item_by_bit(e.cnt); // classname to spawn
			if ((self.spawnflags & 2) && (e.cnt & WEP_WEPSQ)) // make ammo for weps if spawnflags bit 2 set
			{
				rv = 1 + floor(random() * 3);
				while (rv > 0)
				{
					rv = rv - 1;
					e = world;
					e = spawn();
					if (e)
					{
						e.think = dyn_spawn;
						e.nextthink = 1 + 4 * random();
						e.classname = "dyn_item";
						e.cnt = sb;
						e.wad = ammo_by_bit(sb);
						e.origin = v0; // these can be anywhere
					}
				}
			}
		}
		else if (self.dest2_x)
		{
			e.cnt = bit_cnt(self.dest2_x, TRUE);
			e.wad = ammo_by_bit(e.cnt); // classname to spawn
		}
	}
};
