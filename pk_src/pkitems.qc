/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: pkitems.qc
 *
 * date: Fri Apr  4 04:31:44 UTC 2008
 *
 * final qc
 *
 */



/*
 * New weapons and items. These are not functional. -- Cataboligne - huh? what does this mean??
 *
 * weapon_airfist
 * weapon_grapgun
 * weapon_rmine
 * weapon_chainlg
 * item_painkeep_gwell
 * item_painkeep_turret
 * item_painkeep_lantern
 * item_painkeep_can
 * item_painkeep_beartrap
 * light_painkeep_candle
 * item_painkeep_expshells
 *
 */


// New weapons

void () painkeep_weapon_touch =
// The touch func for our new items
{
	local	float	hadammo, best, new, oldi;
	local	entity	stm2;
	local float leave;

	if (other.classname != "player") // *bot
	{
		grap_checkIfGrap();
		return ;
	}

// if the player was using his best weapon, change up to the new one if better
	stm2 = self;
	self = other;
	best = W_BestWeapon ();
	self = stm2;

	if (deathmatch == 2 || deathmatch == 3 || coop)
		leave = 1;
	else
		leave = 0;

	if (self.pk_currentitem == PK_IT_GRAPGUN)
	{
		if (leave && (other.pk_items & PK_IT_GRAPGUN))
			return ;
		new = PK_IT_GRAPGUN;
	}
	else if (self.pk_currentitem == PK_IT_AIRGUN)
	{
		if (leave && (other.pk_items & PK_IT_AIRGUN))
				return ;
			new = PK_IT_AIRGUN;
	}
	else if (self.pk_currentitem == PK_IT_CLIGHT)
	{
		if (leave && (other.pk_items & PK_IT_CLIGHT))
			return ;

		other.ammo_cells = other.ammo_cells + 30;
		new = PK_IT_CLIGHT;
	}
	else if (self.classname == "weapon_pulsenail" || self.mcode == MC_PULSE_NAILGUN)
	{
		if (leave && (other.items & IT_NAILGUN))
			return ;
		hadammo = other.ammo_nails;
		new = 0;
		other.items = other.items | IT_NAILGUN; // special for this
		other.ammo_nails = other.ammo_nails + 30;
		PK_Deathmatch_Weapon (IT_AXE, IT_NAILGUN);
	}
	else
	{
		if (PK_100 && PK_100_OBJERR) objerror("painkeep_weapon_touch: unknown classname");
		else
		{
			bprint("\n*** warning:\npainkeep_weapon_touch: unknown classname (");
			bprint(self.classname);
			bprint(") - ignoring\n\n");
			self.touch = SUB_Null;
			return;
		}
	}

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");

// weapon touch sound
	sound (other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd (other,"bf\n");

	bound_other_ammo ();

// change to the weapon
	oldi = other.pk_items;
	other.pk_items = other.pk_items | new;

	stm2 = self;
	self = other;

// PAINKEEP_START
	/*
	if (!deathmatch)
	{
		self.weapon = IT_AXE;
		self.pk_currentitem = new;
	}
	else
	*/
	PK_Deathmatch_Weapon (IT_AXE, new);
// PAINKEEP_END

	W_SetCurrentAmmo ();

	self = stm2;

	if (leave)
		return ;

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
	{
		self.nextthink = time + RSP_TIME;
		self.think = SUB_regen;
	}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED weapon_airfist (0 .5 .8) (-16 -16 0) (16 16 32)
new QUAKED weapon_airfist (0 .5 .8) (-15 -9 25) (17 9 43)
*/

void () weapon_airfist =
{
	if (Q_100 | Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	if (PK_100)
	{
		precache_model ("progs/g_airgun.mdl");
		setmodel (self,"progs/g_airgun.mdl");
	}
	else
	{
		precache_model ("progs/g_airgun2.mdl");
		setmodel (self,"progs/g_airgun2.mdl");
	}
	self.pk_currentitem = PK_IT_AIRGUN;
	self.netname = "AirFist";
	self.touch = painkeep_weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	//setsize (self, '-15 -9 25', '17 9 43');
	StartItem ();
};

/*QUAKED weapon_rmine (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_rmine =
{
	remove (self);
};

/*QUAKED weapon_chainlg (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_chainlg =
{
	if (Q_100 | Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	precache_model ("progs/g_clight.mdl");
	setmodel (self,"progs/g_clight.mdl");
	self.pk_currentitem = PK_IT_CLIGHT;
	self.netname = "Chain Thunderbolt";
	self.touch = painkeep_weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
};


/*QUAKED weapon_grapgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_grapgun =
{
	if (Q_100 | Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	self.touch = painkeep_weapon_touch;

	precache_model ("progs/g_harp.mdl");
	setmodel (self,"progs/g_harp.mdl");
	self.pk_currentitem = PK_IT_GRAPGUN;
	self.netname = "Harpoon Gun";
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
};

// dynamic items go away when touched

void() pk_dyn_touch =
{
	if (self.classname != "dyn_item") return;
	if (self.netname != "cells") pk_ditems = pk_ditems - 1;
	remove(self);
};
// called from below - handle ammo touch extras

void() pk_ammo_touch =
{
	local entity	sv;
	local float best, bestpk; // *pk - best pk wep

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

// if the player was using his best weapon, change up to the new one if better
	sv = self;
	self = other;
	best = W_BestWeapon();
	bestpk = W_BestPKWeapon(); // *pk - best pk wep
	self = sv;

// shotgun
	if (self.weapon == 1)
	{
		if (other.ammo_shells >= Q1_SHELLAMMO_MAX)
			return;
		other.ammo_shells = other.ammo_shells + self.aflag;
	}

// spikes
	if (self.weapon == 2)
	{
		if (other.ammo_nails >= Q1_NAILAMMO_MAX)
			return;
		other.ammo_nails = other.ammo_nails + self.aflag;
	}

//	rockets
	if (self.weapon == 3)
	{
		if (other.ammo_rockets >= Q1_ROCKETAMMO_MAX)
			return;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}

//	cells
	if (self.weapon == 4)
	{
		if (other.ammo_cells >= Q1_CELLAMMO_MAX)
			return;
		other.ammo_cells = other.ammo_cells + self.aflag;
	}

	if (self.weapon == 5) // *pk exploding shells
	{
		if (other.pk_explode_ammo >= PK_EXPLODEAMMO_MAX)
			return;
		other.pk_explode_ammo = other.pk_explode_ammo + self.aflag;
	}	
	
	bound_other_ammo ();

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other, "\n");
// ammo touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// change to a better weapon if appropriate

	if (other.weapon == best)
		if (best != IT_AXE || bestpk == other.pk_currentitem) // *pk best pk wep checks
	{
		sv = self;
		self = other;
		self.weapon = W_BestWeapon();
		self.pk_currentitem = W_BestPKWeapon(); // *pk - best pk wep
		W_SetCurrentAmmo ();
		self = sv;
	}

// if changed current ammo, update it
	sv = self;
	self = other;
	W_SetCurrentAmmo();
	self = sv;

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
	  self.nextthink = time + RSP_TIME;
	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
	if (pk_flags & PK_DYNAMIC) pk_dyn_touch();
};


// The touch func for our new items

void() painkeep_touch =
{
	local entity stm2;

	if (other.admin)
	if (other.admin != LIVE_ADMIN)
	if (other.admin != USER_MENU)
		return; // *pk - admin - no collecting stuff

	local entity e;
	e = world;
	if (other.classname == "pk*bot") // *bot
	{
		if (self.state == BOT_TOUCHED || self.state == BOT_TOUCHED_CACHE_ROUTE_TOUCH) // *bot code - patch in bot_toucheditem for bots - routes here because this is PK master touch fn()
		{
			bot_toucheditem ();
		}
//		if (self.pk_touch != painkeep_touch) // bots dont get pktouch stuff yet...
//		{
			e = other;
			e.classname = "player";
//		}
	}

	if (other.classname == "player") // *bot
//	if (self.pk_touch != painkeep_touch)
	if (self.state == CACHE_ROUTE_TOUCH || self.state == BOT_TOUCHED_CACHE_ROUTE_TOUCH) // *bot code - patch in cacheRoute for bot code - routes here because this is PK master touch fn()
	{
		if (other.movetarget.movetarget)
			cacheRoute (other.movetarget,other.movetarget.movetarget,0,self);
	}

	if (other.classname != "player") // pk - this is where the grap can grab stuff
	{
		grap_checkIfGrap();
		return;
	}

	if (self.pk_touch == (void()) 0)
	{
		bprint("\b *** warning: in painkeep_touch for: ");
		bprint(self.classname);
		bprint(" and pk_touch is (void) 0 !!\n");
		if (self.classname != "dyn_item") item_call(self.classname);
		else if (self.wad != "") item_call(self.wad);
		else if (self.scode) item_call(item_by_mcode(self.scode));
		return;
	}
	else
	if (self.pk_touch != painkeep_touch) // all items route through here - handle special cases, other touch fns & return
	{
		if (self.pk_touch == ammo_touch) self.pk_touch = pk_ammo_touch; // new fn for ammo collections

		self.pk_touch();
		if (self.solid == SOLID_NOT)
		if (deathmatch == 3) // *pk - new dm mode settings
		{
			if (self.pk_touch == ammo_touch)
				self.nextthink = time + 15;
			if (self.pk_touch == armor_touch)
				self.nextthink = time + 20;
		}

		if (e)
		{
			e.classname = "pk*bot";
			if (e.think == player_run) e.think = e.th_run;
			if (e.think == player_stand1) e.think = e.th_stand;
		}
		if (pk_flags & PK_DYNAMIC) pk_dyn_touch();
		return;
	}

	if (e) e.classname = "pk*bot";

	// check if it can be picked up
	if (self.pk_items == PK_IT_BEARTRAP)
	{
		// check ammo
		if (other.pk_beartrapammo >= PK_BEARTRAPAMMO_MAX)
		{
			return;
		}
		other.pk_beartrapammo = other.pk_beartrapammo + 1;
	}
	else if (self.pk_items == PK_IT_TURRET)
	{
		// check ammo
		if (other.pk_turretammo >= PK_TURRETAMMO_MAX)
		{
			return;
		}
		other.pk_turretammo = other.pk_turretammo + 1;
	}
	if (self.pk_items == PK_IT_GRAVITYWELL)
	{
		// check ammo
		if (other.pk_gravitywellammo >= PK_GRAVITYWELLAMMO_MAX)
		{
			return;
		}
		other.pk_gravitywellammo = other.pk_gravitywellammo + 1;
	}
	else if (self.pk_items == PK_IT_CANPAB)
	{
		// check ammo
		if (other.pk_canpabammo >= PK_CANPABAMMO_MAX)
		{
			return;
		}
		other.pk_canpabammo = other.pk_canpabammo + 1;
	}


	// print message of what you picked up
	/*
	sprint(other, "You now have a ");
	sprint(other, self.netname);
	sprint(other, " to unleash on your enemy's\n");
	*/
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");

// pickup souond
	sound (other, CHAN_ITEM, "misc/pickup/tone2.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// if changed current ammo, update it
	stm2 = self;
	self = other;
	W_SetCurrentAmmo();
	self = stm2;

	// remove object until it is time to respawn
	self.solid = SOLID_NOT;
	self.model = string_null;
	if (deathmatch != 2)
	{
		if (self.pk_items == PK_IT_GRAVITYWELL)
			self.nextthink = time + RSP_TIME * 2;
		else
			self.nextthink = time + RSP_TIME;
	}
	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
	
	if (pk_flags & PK_DYNAMIC) pk_dyn_touch();
};


/*QUAKED item_painkeep_gwell (0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_gwell =
{
	if (Q_100 | Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	self.touch = painkeep_touch;

	self.noise = "items/protect.wav";
	precache_model ("progs/cubsmall.mdl");
	setmodel (self,"progs/cubsmall.mdl");
	self.netname = "Gravity Well";
	self.pk_items = PK_IT_GRAVITYWELL;
	//setsize (self, '-32 -32 -32', '32 32 32');
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_painkeep_turret (0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_turret =
{
	if (Q_100 | Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	self.touch = painkeep_touch;

	precache_model ("progs/tpower.mdl");
	setmodel (self,"progs/tpower.mdl");
	self.netname = "AutoSentry";
	self.pk_items = PK_IT_TURRET;

	setsize (self,'-7 -7 -7','4 7 21');
	StartItem ();
};

/*QUAKED item_painkeep_lantern (0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_lantern =
{
	remove (self);
};


/*QUAKED item_painkeep_can(0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_can =
{
	if (Q_100 | Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	self.touch = painkeep_touch;

	precache_model ("progs/beans.mdl");
	setmodel (self,"progs/beans.mdl");
	self.netname = "Can of pork and beans";
	self.pk_items = PK_IT_CANPAB;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};

/*QUAKED item_painkeep_beartrap(0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_beartrap =
{
	if (Q_100 | Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	self.touch = painkeep_touch;

	precache_model ("progs/bearpick.mdl");
	setmodel (self,"progs/bearpick.mdl");
	self.netname = "Bear Trap";
	self.pk_items = PK_IT_BEARTRAP;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};



/*QUAKED light_painkeep_candle (0 .5 0) (-10 -10 -20) (10 10 20)
Currently exactly the same as a small wall torch
*/
void () light_painkeep_candle =
{
	if (Q_100 | Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	precache_model("progs/candle.mdl");
	setmodel (self,"progs/candle.mdl");
	FireAmbient ();
	makestatic (self);
	if (!(pk_flags & PK_MAP) && !PK) pk_map = PK = TRUE; // *pk - in map mode, set PK for painkeep mode
};


/*QUAKED item_painkeep_expshells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void () item_painkeep_expshells =
{
	if (Q_100 | Q_99) // Cataboligne - 8.16.9 - quake 1 compatability mode(s)
	{
		remove(self);
		return;
	}

	self.touch = ammo_touch;

	precache_model ("maps/b_eshel0.bsp");
	setmodel (self,"maps/b_eshel0.bsp");
	self.aflag = 10;

	self.weapon = 5;
	self.netname = "Exploding Shells";
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

// moved from items.qc - Cataboligne - 3.27.8

// think to reset to SUB_regen after item moved & timeout

void() ip_regen =
{
	self.model = string_null;
	self.solid = SOLID_NOT;

	self.nextthink = time + 1;
	self.think = SUB_regen;
};

// think to check for item movement, set respawn think if moved
// chaos mod vector

void() ip_checkForMovement =
{
	local entity e;

	if (self.solid != SOLID_NOT)
 {
	if (self.map == "rune" && RUNES)
	{
		self.cnt = self.cnt + 1;
		if (self.cnt > self.count) // not touched in 2 - 6 mins
		{
			e = dyn_rndloc();
			if (!e) 	e = findradius(world.origin, 256000);
			if (e)
			{
				setorigin(self, e.origin + ' 0 0 4');
				if (e.flags & FL_ITEM) // randomize away from other map items
					self.origin = stdv_rndloc(e.origin + ' 0 0 4', 50, 100);
				self.ip_orgOrigin = self.origin;
				self.count = 2 + random() * 3.8; // reset for new location
				self.cnt = 0;

				bprint("\b*** RUNE relocating: ");
				bprint(self.netname);
				bprint(" near: ");
				bprint(e.classname);
				bprint("\n");
			}
		}
	}
	else
	if (self.ip_orgOrigin != self.origin)
	{ // position has changed... repawn after x minutes..
		self.think = ip_regen;
		self.nextthink = time + (ip_timeout * (RSP_TIME * 2));
		return;
	}
 }
	self.nextthink = time + 60;
};

// called from SUB_regen - restors position, rethinks

void() pk_item_position =
{
	self.owner = world;

	if (self.ip_orgOrigin == ' 0 0 0' && self.oldorigin != ' 0 0 0') // Cataboligne - in case mode was set to PK after some map items got loaded
		self.ip_orgOrigin = self.oldorigin;

	if (self.ip_orgOrigin != ' 0 0 0') // Cataboligne - tweak: in case this doesnt get set, we dont want to put any item like this at 0, 0, 0
		setorigin (self, self.ip_orgOrigin);

	self.think = ip_checkForMovement;
	self.nextthink = time + 60;

// dynamic items should not end up here
//if (self.classname == "dyn_item")
//bprint("********* error: dynamic in item position *********");

};

// called from PlaceItem, starts position think checks
// chaos mod vector

void() pk_item_position_init =
{
	if (!PK) bprint("*** pk_item_position_init called when not in PK mode.\n");

	self.ip_orgOrigin = self.origin;

	self.think = ip_checkForMovement;
	self.nextthink = time + 60;

// dynamic items should not end up here
//if (self.classname == "dyn_item")
//bprint("******** error: dynamic in ip *********");

};

// called from bound_ammo - bounds for pk ammo

void() pk_bound_ammo =
{
	if (other.ammo_cells > Q1_CELLAMMO_MAX)
		other.ammo_cells = Q1_CELLAMMO_MAX;

	if (other.pk_gravitywellammo > PK_GRAVITYWELLAMMO_MAX)
		other.pk_gravitywellammo = PK_GRAVITYWELLAMMO_MAX;
	if (other.pk_turretammo > PK_TURRETAMMO_MAX)
		other.pk_turretammo = PK_TURRETAMMO_MAX;
	if (other.pk_canpabammo > PK_CANPABAMMO_MAX)
		other.pk_canpabammo = PK_CANPABAMMO_MAX;
	if (other.pk_beartrapammo > PK_BEARTRAPAMMO_MAX)
		other.pk_beartrapammo = PK_BEARTRAPAMMO_MAX;

	if (other.pk_explode_ammo > PK_EXPLODEAMMO_MAX)
		other.pk_explode_ammo = PK_EXPLODEAMMO_MAX;

	if (PK_ART) pk_art_bound_ammo(other); // Cataboligne 8.12.9 purify - pk artifacts
};

// called from below - replacement for RankForWeapon - provides rank for some pk stuff

float(float w, float w2) PK_RankForWeapon =
{
	if (w == IT_AXE && w2 == PK_IT_CLIGHT)
		return 1;
	if (w == IT_LIGHTNING)
		return 2;
	if (w == IT_ROCKET_LAUNCHER)
		return 3;
	if (w == IT_SUPER_NAILGUN)
		return 4;
	if (w == IT_GRENADE_LAUNCHER)
		return 5;
	if (w == IT_SUPER_SHOTGUN)
		return 6;
	if (w == IT_NAILGUN)
		return 7;
	if (w == IT_SHOTGUN)
		return 8;
	if (w == IT_AXE && w2 == PK_IT_AIRGUN)
		return 9;
	return 10;
};

// replacement for Deathmatch_Weapon - handles high risk wep switch

void(float new, float new2) PK_Deathmatch_Weapon =
{
	local float or, nr;

	// Never change to the rl or gl
	if (new == IT_ROCKET_LAUNCHER || new == IT_GRENADE_LAUNCHER)
		return;

	// If your in water don't change to the lightning gun
	if (new == IT_LIGHTNING && self.waterlevel > 1)
		return;


// change self.weapon if desired
	or = PK_RankForWeapon (self.weapon, self.pk_currentitem);
	nr = PK_RankForWeapon (new, new2);
	if (nr < or)
	{
		self.weapon = new;
		self.pk_currentitem = new2;
	}
};

// refered from below

void() PK_BackpackTouch =
{
	local string	bs;
	local	float	best, new;
	local		entity	st1;
	local	float	acount;

	if (other.classname != "player") // pk - this is where the grap can grab stuff
	{
		grap_checkIfGrap();
		return;
	}
	if (other.health <= 0)
		return;

	acount = 0;
	sprint (other, "You get ");

	if (self.items)
// PAINKEEP_START
		if ((other.items & self.items) == 0 || (self.items == IT_AXE && (other.pk_items & self.pk_items) == 0))
// PAINKEEP_END
		{
			acount = 1;
			sprint (other, "the ");
			sprint (other, self.netname);
		}

// if the player was using his best weapon, change up to the new one if better
	st1 = self;
	self = other;
	best = W_BestWeapon();
	self = st1;

// change weapons
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells = other.ammo_cells + self.ammo_cells;

	other.pk_gravitywellammo = other.pk_gravitywellammo + self.pk_gravitywellammo;
	other.pk_turretammo = other.pk_turretammo + self.pk_turretammo;
	other.pk_canpabammo = other.pk_canpabammo + self.pk_canpabammo;
	other.pk_beartrapammo = other.pk_beartrapammo + self.pk_beartrapammo;
 	other.pk_explode_ammo = other.pk_explode_ammo + self.pk_explode_ammo;

	if (PK_ART) pk_art_backpack_touch(other, acount); // Cataboligne 8.12.9 purify - pk artifacts

	new = self.items;
	if (!new)
		new = other.weapon;
	other.items = other.items | new;

	other.pk_items = other.pk_items | self.pk_items;

	bound_other_ammo ();

	if (self.ammo_shells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.ammo_shells);
		sprint (other, bs);
		sprint (other, " shells");
	}
	if (self.ammo_nails)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.ammo_nails);
		sprint (other, bs);
		sprint (other, " nails");
	}
	if (self.ammo_rockets)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.ammo_rockets);
		sprint (other, bs);
		sprint (other, " rockets");
	}
	if (self.ammo_cells)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.ammo_cells);
		sprint (other, bs);
		sprint (other, " cells");
	}
	if (self.pk_gravitywellammo)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.pk_gravitywellammo);
		sprint (other, bs);
		sprint (other, " Gravity Wells");
	}
	if (self.pk_turretammo)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.pk_turretammo);
		sprint (other, bs);
		sprint (other, " AutoSentrys");
	}
	if (self.pk_canpabammo)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.pk_canpabammo);
		sprint (other, bs);
		sprint (other, " Can's");
	}
	if (self.pk_beartrapammo)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.pk_beartrapammo);
		sprint (other, bs);
		sprint (other, " Bear Traps");
	}
	if (self.pk_explode_ammo)
	{
		if (acount)
			sprint(other, ", ");
		acount = 1;
		bs = ftos(self.pk_explode_ammo);
		sprint (other, bs);
		sprint (other, " Exploding Shells");
	}

	sprint (other, "\n");
// backpack touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// remove the backpack, change self to the player
	remove(self);
	self = other;

// change to the weapon
	if (!deathmatch)
		self.weapon = new;
	else
	PK_Deathmatch_Weapon (new, 0); // *pk - new wep switch rule for higher risk weps

	W_SetCurrentAmmo ();
};

// called from DropBackpack

void() PK_DropBackpack =
{
	newmis = world;
	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells + self.pk_explode_ammo))
		return;	// nothing in it

	newmis = spawn();
	newmis.origin = self.origin - '0 0 24';

	newmis.pk_items = 0;
	newmis.items = self.weapon;
	if (newmis.items == IT_AXE)
	{
		if (self.pk_currentitem == PK_IT_AXE)
			newmis.netname = "Axe";
		else if (self.pk_currentitem == PK_IT_GRAVITYWELL)
			newmis.netname = "Gravity Well";
		else if (self.pk_currentitem == PK_IT_TURRET)
			newmis.netname = "AutoSentry";
		else if (self.pk_currentitem == PK_IT_GRAPGUN)
			newmis.netname = "Harpoon Gun";
		else if (self.pk_currentitem == PK_IT_BEARTRAP)
			newmis.netname = "Bear Trap";
		else if (self.pk_currentitem == PK_IT_AIRGUN)
			newmis.netname = "AirFist";
		else if (self.pk_currentitem == PK_IT_CLIGHT)
			newmis.netname = "Chain Thunderbolt";
	}
	else if (newmis.items == IT_SHOTGUN)
		newmis.netname = "Shotgun";
	else if (newmis.items == IT_SUPER_SHOTGUN)
		newmis.netname = "Double-barrelled Shotgun";
	else if (newmis.items == IT_NAILGUN)
		newmis.netname = "Pulse Rifle";
	else if (newmis.items == IT_SUPER_NAILGUN)
		newmis.netname = "Super Nailgun";
	else if (newmis.items == IT_GRENADE_LAUNCHER)
		newmis.netname = "Grenade Launcher";
	else if (newmis.items == IT_ROCKET_LAUNCHER)
		newmis.netname = "Rocket Launcher";
	else if (newmis.items == IT_LIGHTNING)
		newmis.netname = "Thunderbolt";
	else
		newmis.netname = "";

	newmis.ammo_shells = self.ammo_shells;
	newmis.ammo_nails = self.ammo_nails;
	newmis.ammo_rockets = self.ammo_rockets;
	newmis.ammo_cells = self.ammo_cells;

	newmis.pk_gravitywellammo = self.pk_gravitywellammo;
	newmis.pk_turretammo = self.pk_turretammo;
	newmis.pk_canpabammo = self.pk_canpabammo;
	newmis.pk_beartrapammo = self.pk_beartrapammo;
	newmis.pk_explode_ammo = self.pk_explode_ammo;

		if (PK_ART) pk_art_backpack_drop(newmis); // Cataboligne 8.12.9 purify - pk artifacts

	newmis.velocity_z = 300;
	newmis.velocity_x = -100 + (random() * 200);
	newmis.velocity_y = -100 + (random() * 200);

	newmis.flags = FL_ITEM;
	newmis.solid = SOLID_TRIGGER;
	newmis.movetype = MOVETYPE_TOSS;
	setmodel (newmis, "progs/backpack.mdl");
	setsize (newmis, '-16 -16 0', '16 16 56');
	newmis.touch = BackpackTouch;

	newmis.nextthink = time + 120;	// remove after 2 minutes
	newmis.think = SUB_Remove;
	AddToSplash(newmis); // *pk - splash tossed items
};

// randomize any item

void() rndize_item =
{
	local entity e;
	local float sf;

	if (self.owner.mcode < MC_Q1)
		self.owner.mcode = 102 + rint(random() * 30);
	else if (self.owner.mcode < MC_PK)
		self.owner.mcode = 141 + rint(random() * 12);

	sf = 100;
	if (RUNES)
	while (self.owner.mcode >= MC_SIGIL1 && self.owner.mcode <= MC_SIGIL8 && sf > 0) // runes dont allow runes to be made here
	{
		self.owner.mcode = 102 + rint(random() * 30);
		sf = sf - 1;
		if (sf < 1) self.owner.mcode = self.owner.scode; // fail
	}

	self.owner.wad = item_by_mcode(self.owner.mcode);
	e = self;
	self = self.owner;
	self.pk_touch = (void()) 0; // so we can touch the new things

// TDO: chaos mod vector here
	e.cnt = cvar("pk_place_item_reload"); // randomize every so often

//	bprint("*** rndize item: ");
	if (cvar("pk_place_item") == 0)
	{
//		bprint("admin turned off & exiting randomize items & restoring\n");
		self.wad = item_by_mcode(self.scode);
		e.cnt = 0;
	}
//	bprint(self.classname);
//	bprint(" is now: ");
//	bprint(self.wad);
//	bprint("\n");

	item_call(self.wad);

	if (!e.cnt)
		remove(e);
	else
	{
		e.nextthink = time + fabs(e.cnt) + random() * e.cnt;
	}
};

// Called by place item under specific conditions for map load

void() place_item_control =
{
	if (cvar("pk_place_item") == 1)
	{
		remove(self);
		return;
	}
	else if (cvar("pk_place_item") == 2)
	{
		local entity e;
		e = spawn();
		if (e)
		{
			e.owner = self;
			e.think = rndize_item;
			e.nextthink = time + 5 + random() * 2;
			e.classname = "rndize_item";
		}
	}
};

// called from PlaceItem - sorts many things now - happens 0.2 secs after map load

void() pk_placeitem =
{

	if (self.classname != "dyn_item")
	{
		pk_item_position_init();
	}
	else
	{
		self.velocity_z = 300 + 100 * random();
		self.velocity_x = -170 + (random() * 340);
		self.velocity_y = -170 + (random() * 340);
	}

// handle extra item stuff
	if (self.pk_touch == (void()) 0) // dont swamp pointers
	{
		self.pk_touch = self.touch;
	}
	self.touch = painkeep_touch; // take over - route everything here

// Cataboligne - added check here because new mode (not permanently PK & loaded a PK map can set PK mode after nailguns get loaded on map
	if (PK)
	if (self.wad == "")
	if (self.classname == "weapon_nailgun" || self.weapon == IT_NAILGUN)
	if (self.model == "progs/g_nail.mdl")
	{
		setmodel (self, "progs/g_fnail.mdl");
		self.netname = "Pulse Rifle";
	}

	self.mcode = pk_mcode("", self); // put map code on ent - do we need this? placeitem sets these too
	self.sscode = ftos(self.mcode);
	if (!self.scode) self.scode = self.mcode;
};


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
	local string scls;
	local float rd;

	rd = random();
	if (self.classname != "dyn_item") rd = 1;
	
	scls = cls;
	if (cls == "weapon_supershotgun") weapon_supershotgun();
	else if (cls == "weapon_nailgun") weapon_nailgun();
	else if (cls == "weapon_supernailgun") weapon_supernailgun();
	else if (cls == "weapon_grenadelauncher") weapon_grenadelauncher();
	else if (cls == "weapon_rocketlauncher") weapon_rocketlauncher();
	else if (self.classname == "dyn_item" && cls == "weapon_lightning")
	{
		if (PK) weapon_chainlg();
		else weapon_lightning();
	}
	else if (cls == "weapon_lightning") weapon_lightning();
	else if (cls == "item_shells") { if (rd < 0.5) self.spawnflags = WEAPON_BIG2; item_shells(); }
	else if (cls == "item_spikes") { if (rd < 0.4) self.spawnflags = WEAPON_BIG2; item_spikes(); }
	else if (cls == "item_rockets") { if (rd < 0.2) self.spawnflags = WEAPON_BIG2; item_rockets(); }
	else if (cls == "item_cells") { if (rd < 0.8) self.spawnflags = WEAPON_BIG2; item_cells(); }

	else if (cls == "item_shells_lg") { self.spawnflags = WEAPON_BIG2; item_shells(); scls = "item_shells"; }
	else if (cls == "item_spikes_lg") { self.spawnflags = WEAPON_BIG2; item_spikes(); scls = "item_spikes"; }
	else if (cls == "item_rockets_lg") { self.spawnflags = WEAPON_BIG2; item_rockets(); scls = "item_rockets"; }
	else if (cls == "item_cells_lg") { self.spawnflags = WEAPON_BIG2; item_cells(); scls = "item_cells"; }

	else if (cls == "item_artifact_invulnerability") item_artifact_invulnerability();
	else if (cls == "item_artifact_super_damage") item_artifact_super_damage();
	else if (cls == "item_artifact_envirosuit") item_artifact_envirosuit();
	else if (cls == "item_artifact_invisibility") item_artifact_invisibility();
	else if (cls == "item_armor1") item_armor1();
	else if (cls == "item_armor2") item_armor2();
	else if (cls == "item_armorInv") item_armorInv();
	else if (cls == "item_health_15") { self.spawnflags = H_ROTTEN; item_health(); scls = "item_health";}
	else if (cls == "item_health") item_health();
	else if (cls == "item_health_mega") { self.spawnflags = H_MEGA; item_health(); scls = "item_health"; }

	else if (cls == "item_key1") item_key1();
	else if (cls == "item_key2") item_key2();

	else if (cls == "item_sigil1") { self.spawnflags = rune_bit(MC_SIGIL1); item_sigil(); scls = "item_sigil"; }
	else if (cls == "item_sigil2") { self.spawnflags = rune_bit(MC_SIGIL2); item_sigil(); scls = "item_sigil"; }
	else if (cls == "item_sigil4") { self.spawnflags = rune_bit(MC_SIGIL4); item_sigil(); scls = "item_sigil"; }
	else if (cls == "item_sigil8") { self.spawnflags = rune_bit(MC_SIGIL8); item_sigil(); scls = "item_sigil"; }

//	else if (cls == "item_") item_();

	else if (cls == "item_painkeep_gwell") item_painkeep_gwell();
	else if (cls == "item_painkeep_turret") item_painkeep_turret();
	else if (cls == "item_painkeep_beartrap") item_painkeep_beartrap();
	else if (cls == "item_painkeep_expshells") item_painkeep_expshells();
	else if (cls == "weapon_chainlg") weapon_chainlg();
	else if (cls == "weapon_pulsenail") weapon_pulsenail();
	else if (cls == "weapon_grapgun") weapon_grapgun();
	else if (cls == "weapon_airfist") weapon_airfist();
	else if (cls == "item_painkeep_can") item_painkeep_can();
	else if (PK_ART) { if (! pk_art_item_call(cls)) return; }// Cataboligne 8.12.9 purify - pk artifacts
	else return;
	self.mdl = self.model;
	if (self.classname != "dyn_item") // dont do these for dyn items
	{
		self.classname = scls;
//		if (PK)  // try this out
		pk_placeitem();
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
bprint("repm: item_repm internal - rest -- rem | pki replace or restore\n");
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
bprint("repm: restore on -:-, pki or rem --- ram != pam\n");
			if (ram != "")
			if (ram != pam) item_repm(pam, ram, "", "");
		}
		else
		{
			item_call(cls);
bprint("repm: restore on end else --- ram != pam\n");
			if (ram != "")
			if (ram != pam) item_repm(pam, ram, "", "");
		}
		e = find(e,wad,rep);
	}
	self = sv;
};


void() item_loop =
{
	local float f, e, d, pko, pks, sf, lvl, lvls, msk;
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
bprint("repm: restore on no con_run\n");
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
bprint("repm: restore on con_only\n");
					item_repm(cl, item_by_bit(e), ammo_by_bit(f), ammo_by_bit(e));

				}
			}
			else if (pko & CON_NONE)
			{
				cl = item_by_bit(e);
	bprint("repm: restore on con_none - con_subs or else\n");
			if (pko & CON_SUBS) item_repm(cl, item_by_bit(f), ammo_by_bit(e), ammo_by_bit(f));
				else item_repm("", item_by_bit(f), "", ammo_by_bit(f));
			}
			else if (pko & CON_INF) { bprint("repm: restore on rest - con_inf\n");

				item_repm("rest", item_by_bit(f), "", ammo_by_bit(f)); }
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

void() infinite_ammo =
{
	local entity e;
	local string src;

	ammo_frame = framecount + 6; // not every frame
	src = "player";
	e = find(world,classname,src);
	while (e)
	{
		if (e.health > 0)
		{
			if (e.weapon == IT_SUPER_SHOTGUN)
			if (pk_itemovr & WEP_SSHOT) e.ammo_shells = 99;
			if (e.weapon == IT_NAILGUN)
			if (pk_itemovr & WEP_NAILGUN) e.ammo_nails = 99;
			if (e.weapon == IT_SUPER_NAILGUN)
			if (pk_itemovr & WEP_PERF) e.ammo_nails = 99;
			if (e.weapon == IT_GRENADE_LAUNCHER)
			if (pk_itemovr & WEP_GREN) e.ammo_rockets = 99;
			if (e.weapon == IT_ROCKET_LAUNCHER)
			if (pk_itemovr & WEP_ROCKET) e.ammo_rockets = 99;
			if (e.weapon == IT_LIGHTNING || e.pk_items & PK_IT_CLIGHT)
			if (pk_itemovr & WEP_THUNDER) e.ammo_cells = 99;
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
// fn(dyn_rndloc) - get a random location to spawn an item dynamically

void() dyn_rem =
{
	remove(self.enemy);
	remove(self);
	pk_ditems = pk_ditems - 1;
}

entity rseu; // random spawn ent origin used

// returns a "near" entity to use its origin - this is really the only safe way to pick a random location within a map

entity() dyn_rndloc =
{
	float ri, sf;
	local entity e, sv;

	ri = sf = 0;
	sv = e = find(world,classname,"player");
	while (e)
	{
		sv = e;
		e = find(e,classname,"player");
	}
	e = findradius(sv.origin, PK_DYNRAD);
	if (!e) return(world); // nothing found!
	sv = e;
	while (e.chain) // count stuff for a random location selection from all these items found in range
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
	return(sv);
};

// some deviation around a random loc, rule out solid areas

vector(vector v1, float d1, float r1) stdv_rndloc =
{
	vector v2;
	local float sf, pco, f, k;

	v2 = v1;
	sf = 500;
	pco = CONTENT_SOLID;

	while (sf > 0 && pco == CONTENT_SOLID)
	{
		f = crandom() * r1;
		k = d1;
		if (f < 0) k = 0 - d1;
		v2_x = v1_x + k + f;
		f = crandom() * r1;
		k = d1;
		if (f < 0) k = 0 - d1;
		v2_y = v1_y + k + f;
		pco = pointcontents(v2);
		sf = sf - 1;
		if (sf < 1) v2 = v1;
	}
	return(v2);
};

void() dyn_spawn =
{
	local entity sv;

// get a random origin
  if (self.origin == v0)
  {
		sv = dyn_rndloc();
		if (!sv) return; // nothing found!
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

	if (PK_100 || Q_100 || !(pk_flags & PK_DYNAMIC || DYN_OVR || DYN_FORCE || DYN_ARTFR)) // Cataboligne - 8.15.9 - pk compat mode, just in case
	{
//		bprint("*** Warning - dynamic items deactivated\n");
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
// deprecated for remover above
//	else if (!DYN_FORCE && !DYN_ARTFR_ONLY)
//	{		
//		if (!PK || (!(pk_flags & PK_DYNAMIC) && !DYN_OVR)) // got turned off go away
//			remove(self);
//	}
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

// pk_dyn_func_stop - stop func_dynitem processing

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

// stop item spawn when set true - leaves func_ ents on map
	if (cvar("pk_dyn_func_stop")) return;

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

// run loop cycles

// .target - timer string
// .noise - 0 str
// .noise1-4 1-4 string
// .target1-2 5-6 string
// .theowner - ent loop

void(entity e, string l0, string l1, string l2, string l3, string l4, string l5, string l6, string t0) loop_var =
{
	e.noise = l0;
	e.noise1 = l1;
	e.noise2 = l2;
	e.noise3 = l3;
	e.noise4 = l4;
	e.target1 = l5;
	e.target2 = l6;
	e.target = t0;
}

// try to find the next map code in the loop vars, given the current mcode
// if called with search 0 - verify there are loop values

float(entity e, float p) loop_next =
{
	local float f, rp, sf;
	
	if (!p)
	{
	if (!cvar(e.noise1) && !cvar(e.noise2) && !cvar(e.noise3) && !cvar(e.noise4) && !cvar(e.target1) && !cvar(e.target2))
		return(0);
	else
		return(102); // default here in case
	}

	if (p == cvar(e.noise)) rp = 1;
	else if (p == cvar(e.noise1)) rp = 2;
	else if (p == cvar(e.noise2)) rp = 3;
	else if (p == cvar(e.noise3)) rp = 4;
	else if (p == cvar(e.noise4)) rp = 5;
	else if (p == cvar(e.target1)) rp = 6;
	else if (p == cvar(e.target2)) rp = 1;
	else return(0); // value p not found

	sf = 15;
	f = 0;

	while (!f && sf > 0)
	{
		if (rp == 1)
		{
			f = cvar(e.noise1);
			if (!f) rp = 2;
		}
		if (rp == 2)
		{
			f = cvar(e.noise2);
			if (!f) rp = 3;
		}
		if (rp == 3)
		{
			f = cvar(e.noise3);
			if (!f) rp = 4;
		}
		if (rp == 4)
		{
			f = cvar(e.noise4);
			if (!f) rp = 5;
		}
		if (rp == 5)
		{
			f = cvar(e.target1);
			if (!f) rp = 6;
		}
		if (rp == 6)
		{
			f = cvar(e.target2);
			if (!f) rp = 1;
		}
		sf = sf - 1;
	}
	return(f);
};

void() loopcyc_think =
{
	local float f, rp, rn, dr, svm;
	local entity e, sv;
	local string mmc;

	svm = cvar("pk_cyc_master");
	sv = self;
	f = cvar(sv.noise);
	rp = cvar(sv.noise1);
	sv.cnt = dr = rn = FALSE;

	if (!f && !rp) // 1 & 0 are zeroed - restore items & remove
	{
		rn = TRUE;
	}

	if (svm && sv.wait != -666)
	{
		mmc = item_by_mcode(self.delay);
		e = find( world, classname, mmc);
	}
	else
		e = sv.theowner;
	while (e)
	{
		self = e;
		if (!e.scode) e.scode = e.mcode;
		if (!sv.cnt) sv.cnt = e.mcode;
		if (cvar("pk_cyc_halt") || rn)
		{
			item_call(item_by_mcode(e.scode));
		}
		else if (e.classname == "dyn_item" && e.mcode != sv.cnt)
			dr = TRUE;
		else
		{
			f = loop_next(sv, 0); // check all 0's
			if (!f) // keep these ents gone
			{
				e.model = "";
				e.nextthink = -1;
				e.pk_touch = e.touch = SUB_Null;
			}
			else // cycle according to rules
			{
				sv.delay = f = loop_next(sv, e.mcode);
				e.pk_touch = (void()) 0;
				if (!f)
				{
					bprint("\b*** warning: loop code changed on live item loop - restoring item.\n");
					item_call(item_by_mcode(e.scode));
				}
				else
					item_call(item_by_mcode(f)); // set replacement item
			}
		}

		if (dr) e = find( e, classname, "dyn_item");
		else 
		{
			if (svm && sv.wait != -666)
				e = find( e, classname, mmc);
			else
				e = e.theowner;
		}

		if (!dr && !e && cvar("pk_cyc_dyn"))
		{
			e = find( world, classname, "dyn_item");	
			dr = TRUE;
		}
	}


	self = sv;
	if (rn)
	{
		remove(self);
		return;
	}

	f = cvar(self.target);
	if (f < 0) // negative - 20% + random() 80%
	{
		f = fabs(f);
		rp = 0.2 * f;
		f = f - rp;
		rn = random() * f;
		f = rn + rp;
	}

	self.nextthink = time + f;
};

void(entity e) init_loopcyc =
{
	local entity sr, s2;
	local string cl;
	local float f0, f1;

	e.theowner = world;
	cl = "";
	f0 = cvar(e.noise);
	f1 = cvar(e.noise1);
	if (!f0 && !f1)
	{
		remove(e);
		return; // failed - no 0 or 1
	}
	if (f0)
	{
		e.delay = f0;
		cl = item_by_mcode(f0);
	}
	if (cl == "")
	{
		e.delay = f1;
		cl = item_by_mcode(f1);
	}
	if (cl == "")
	{
		remove(e);
		return; // failed - 0 or 1 (or both) not valid map codes
	}

	if (!cvar(e.target)) cvar_set(e.target, "-60"); // default timer

	if (f0 > -1)
	{
	  if (!cvar("pk_cyc_master"))
	 {
		e.theowner = sr = find( world, classname, cl);
		if (!sr)
		{
			remove(e);
			return; // none on map right now
		}

	  while (sr) // chain em up
		{
		sr.theowner = find( sr, classname, cl);
//		if (cl != "dyn_item")
//			sr = sr.theowner;
		if (sr.mcode == f0 || sr.mcode == f1)
			sr = sr.theowner;
		else
			sr = find( sr, classname, cl);

//		if (cvar("pk_cyc_dyn") && !sr) cl = "dyn_item"; // include dynamics - must have 1 reg item to start loop.
		}
	 }

	}
	else // create a series of random cycle items
	{
		e.wait = -666; // so we dont master server these!
		f0 = fabs(f0);
		while (f0 > 0)
		{
			sr = spawn();
			if (!e.theowner) e.theowner = sr;
			else s2.theowner = sr;
			if (sr)
			{
				s2 = dyn_rndloc();
				if (!s2)
				{
					remove(e);
					return; // no location - fail!
				}
				sr.origin = s2.origin + ' 0 0 8';
				if (s2.flags & FL_ITEM)
					sr.origin = stdv_rndloc(s2.origin + ' 0 0 8', 50, 100);
				s2 = self;
				self = sr;
				self.wad = cl;
				item_call(cl); // make first one
				self = s2;
				s2 = sr; // for the chain up
			}
			f0 = f0 - 1;
		}
	}

	f0 = cvar(e.target);
	if (f0 < 0) // negative - 20% + random() 80%
	{
		f0 = fabs(f0);
		f1 = 0.2 * f0;
		f0 = f0 - f1;
		f0 = f1 +  random() * f0;
	}

	e.think = loopcyc_think;
	e.nextthink = time + f0;
};

void() start_loopcyc =
{
	local entity e;

	if (!find(world, noise, "pk_cyc_lg_0"))
	{
	e = spawn();
	loop_var(e, "pk_cyc_lg_0", "pk_cyc_lg_1", "pk_cyc_lg_2", "pk_cyc_lg_3", "pk_cyc_lg_4", "pk_cyc_lg_5", "pk_cyc_lg_6", "pk_cyc_lg_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "pk_cyc_rl_0"))
	{
	e = spawn();
	loop_var(e, "pk_cyc_rl_0", "pk_cyc_rl_1", "pk_cyc_rl_2", "pk_cyc_rl_3", "pk_cyc_rl_4", "pk_cyc_rl_5", "pk_cyc_rl_6", "pk_cyc_rl_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "pk_cyc_gl_0"))
	{
	e = spawn();
	loop_var(e, "pk_cyc_gl_0", "pk_cyc_gl_1", "pk_cyc_gl_2", "pk_cyc_gl_3", "pk_cyc_gl_4", "pk_cyc_gl_5", "pk_cyc_gl_6", "pk_cyc_gl_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "pk_cyc_sng_0"))
	{
	e = spawn();
	loop_var(e, "pk_cyc_sng_0", "pk_cyc_sng_1", "pk_cyc_sng_2", "pk_cyc_sng_3", "pk_cyc_sng_4", "pk_cyc_sng_5", "pk_cyc_sng_6", "pk_cyc_sng_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "pk_cyc_ng_0"))
	{
	e = spawn();
	loop_var(e, "pk_cyc_ng_0", "pk_cyc_ng_1", "pk_cyc_ng_2", "pk_cyc_ng_3", "pk_cyc_ng_4", "pk_cyc_ng_5", "pk_cyc_ng_6", "pk_cyc_ng_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "pk_cyc_ssg_0"))
	{
	e = spawn();
	loop_var(e, "pk_cyc_ssg_0", "pk_cyc_ssg_1", "pk_cyc_ssg_2", "pk_cyc_ssg_3", "pk_cyc_ssg_4", "pk_cyc_ssg_5", "pk_cyc_ssg_6", "pk_cyc_ssg_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "pk_cyc_pkw_0"))
	{
	e = spawn();
	loop_var(e, "pk_cyc_pkw_0", "pk_cyc_pkw_1", "pk_cyc_pkw_2", "pk_cyc_pkw_3", "pk_cyc_pkw_4", "pk_cyc_pkw_5", "pk_cyc_pkw_6", "pk_cyc_pkw_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "pk_cyc_pkc_0"))
	{
	e = spawn();
	loop_var(e, "pk_cyc_pkc_0", "pk_cyc_pkc_1", "pk_cyc_pkc_2", "pk_cyc_pkc_3", "pk_cyc_pkc_4", "pk_cyc_pkc_5", "pk_cyc_pkc_6", "pk_cyc_pkc_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "pk_cyc_art_0"))
	{
	e = spawn();
	loop_var(e, "pk_cyc_art_0", "pk_cyc_art_1", "pk_cyc_art_2", "pk_cyc_art_3", "pk_cyc_art_4", "pk_cyc_art_5", "pk_cyc_art_6", "pk_cyc_art_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "pk_cyc_ammo_0"))
	{
	e = spawn();
	loop_var(e, "pk_cyc_ammo_0", "pk_cyc_ammo_1", "pk_cyc_ammo_2", "pk_cyc_ammo_3", "pk_cyc_ammo_4", "pk_cyc_ammo_5", "pk_cyc_ammo_6", "pk_cyc_ammo_t");
	init_loopcyc(e);
	}

	if (!find(world, noise, "pk_cyc_itm_0"))
	{
	e = spawn();
	loop_var(e, "pk_cyc_itm_0", "pk_cyc_itm_1", "pk_cyc_itm_2", "pk_cyc_itm_3", "pk_cyc_itm_4", "pk_cyc_itm_5", "pk_cyc_itm_6", "pk_cyc_itm_t");
	init_loopcyc(e);
	}

	self.nextthink = time + 15; // recheck every 10 secs?
};

// rune 1 rules - runes expire in pow time

void () rune_1_expire =
{
	self.owner.rune_flag = 0;
	sprint(self.owner, "The power of the ");
	sprint(self.owner, self.netname);
	sprint(self.owner, " rune has expired.\n");
	remove(self);
};

void () rune_touch =
{
	local entity e;

	if (other.classname != "player")
	if (other.classname != "pk*bot")
			return;
	if (other.health <= 0)
		return ;
	if (RUNES == 1)
	if (other.rune_flag)
		return ;

	centerprint3 (other,"You got the ",self.netname," Rune!");
	sprint(other,"You have the power of ");
	rune_print(other, self.spawnflags, FALSE);

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other,"bf\n");

	other.rune_flag = other.rune_flag | self.spawnflags;

	if (RUNES == 1)
	{
		e = spawn();
		if (e)
		{
			e.classname = "rune_1_expiry";
			e.netname = self.netname;
			e.think = rune_1_expire;
			e.nextthink = time + POW_TIME;
			e.owner = other;
		}
	}
	if (RUNES == 3)
	{
		if (self.spawnflags & RUNE_FLG_RS) other.rune_3_resist = other.rune_3_resist + RUNE_3_ACM;
		if (self.spawnflags & RUNE_FLG_DM) other.rune_3_dmg = other.rune_3_dmg + RUNE_3_ACM;
		if (self.spawnflags & RUNE_FLG_HS) other.rune_3_haste = other.rune_3_haste + RUNE_3_ACM;
		if (self.spawnflags & RUNE_FLG_RG) other.rune_3_rgn = other.rune_3_rgn + RUNE_3_ACM;
	}

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
	self.cnt = 0;
	self.count = self.count + 0.13; // increment for each grab - more activity = less chance of rune moving

	if (RUNES == 1 || RUNES == 3)
	{
	if (deathmatch !=  2) // this is likely a meaningless deal for runes
		self.nextthink = time + RSP_TIME;
	self.think = SUB_regen;
	}

//	serverflags = serverflags | (self.spawnflags & 15);

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

// make runes for runeserver
float rune_map; // runes on level

void() rune_maker =
{
	local entity e;
	local float sf, f;

	if (rune_count < RUNE_CNT)
	{
		if (rune_count < 2) // make at least 2 sort of quicker
			self.nextthink = time + random() * 30;
		else
			self.nextthink = time + 10 + random() * 60;

// make a rune
		e = spawn();
		if (e)
		{
			rune_count = rune_count + 1;
			self = e;

			self.mcode = MC_SIGIL1 + rint(random() * 3.3);
			sf = 111;
// if ((rune_map & 15) != (RUNE_MASK & 15))  // basic 4 runes spawn first, fulfilling mask goal, could be 0
			if (rune_count < 4) // spawn 4 uinque runes on a map when starting
			while (sf > 0)
			{
				f = rune_bit(self.mcode);
				if (!(f & rune_map))
					sf = 0;
				else
					self.mcode = MC_SIGIL1 + rint(random() * 3.3);
				sf = sf - 1;
			}
			self.wad = item_by_mcode(self.mcode);

			e = dyn_rndloc();
			if (!e) 	e = findradius(world.origin, 256000);
			if (!e) 
			{
				bprint("*** warning: rune_make could not find a random (or any) location - giving up\n");
				remove(self);
				return; // crap - no location
			}
			self.origin = e.origin + ' 0 0 8';
			if (e.flags & FL_ITEM) // randomize away from other map items
				self.origin = stdv_rndloc(e.origin + ' 0 0 8', 50, 100);

			item_call(self.wad);
			self.pk_touch = rune_touch;
			AddToSplash(self); // splash code kills lava immersed runes

			rune_map = rune_map | self.spawnflags;
			self.count = 2 + random() * 3.8; // controls no-touch reposition code in check movement deal
			self.cnt = 0;

			bprint("\b*** RUNE spawned: ");
			bprint(self.netname);
			if (e)
			{
				bprint(" near: ");
				bprint(e.classname);
			}
			else
			bprint(" on the map");
			bprint("\n");

		}
	}
};