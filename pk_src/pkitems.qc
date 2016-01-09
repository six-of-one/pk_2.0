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
 * New weapons and items. These are not functional.
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

	if ( (other.classname != "player") )
	{
		grap_checkIfGrap ();
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

	if(self.pk_currentitem == PK_IT_GRAPGUN)
	{
		if (leave && (other.pk_items & PK_IT_GRAPGUN) )
			return ;
		new = PK_IT_GRAPGUN;
	}
	else if(self.pk_currentitem == PK_IT_AIRGUN)
	{
		if (leave && (other.pk_items & PK_IT_AIRGUN) )
				return ;
			new = PK_IT_AIRGUN;
	}
	else if(self.pk_currentitem == PK_IT_CLIGHT)
	{
		if (leave && (other.pk_items & PK_IT_CLIGHT))
			return ;

		other.ammo_cells = other.ammo_cells + 30;
		new = PK_IT_CLIGHT;
	}
	else
		objerror ("painkeep_weapon_touch: unknown classname");

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

	if ( leave )
		return ;

// remove it in single player, or setup for respawning in deathmatch
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
	{
		self.nextthink = time + 30;
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
	precache_model ("progs/g_airgun.mdl");
	setmodel (self,"progs/g_airgun.mdl");
	self.pk_currentitem = PK_IT_AIRGUN;
	self.netname = "AirFist";
	self.touch = painkeep_weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	//setsize (self, '-15 -9 25', '17 9 43');
	self.th_weight = dont_weight;
	StartItem ();
	if (pk_mode == PK_MAP && !PK) PK = TRUE; // *pk - in map mode, set PK for painkeep mode
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
	precache_model ("progs/g_clight.mdl");
	setmodel (self,"progs/g_clight.mdl");
	self.pk_currentitem = PK_IT_CLIGHT;
	self.netname = "Chain Thunderbolt";
	self.touch = painkeep_weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	self.th_weight = dont_weight;
	StartItem ();
	if (pk_mode == PK_MAP && !PK) PK = TRUE; // *pk - in map mode, set PK for painkeep mode
};


/*QUAKED weapon_grapgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_grapgun =
{
	self.touch = painkeep_weapon_touch;

	precache_model ("progs/g_harp.mdl");
	setmodel (self,"progs/g_harp.mdl");
	self.pk_currentitem = PK_IT_GRAPGUN;
	self.netname = "Harpoon Gun";
	setsize (self,'-16 -16 0','16 16 56');
	self.th_weight = dont_weight;
	StartItem ();
	if (pk_mode == PK_MAP && !PK) PK = TRUE; // *pk - in map mode, set PK for painkeep mode
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
		if (other.ammo_shells >= 100)
			return;
		other.ammo_shells = other.ammo_shells + self.aflag;
	}

// spikes
	if (self.weapon == 2)
	{
		if (other.ammo_nails >= 200)
			return;
		other.ammo_nails = other.ammo_nails + self.aflag;
	}

//	rockets
	if (self.weapon == 3)
	{
		if (other.ammo_rockets >= 100)
			return;
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}

//	cells
	if (self.weapon == 4)
	{
		if (other.ammo_cells >= 100)
			return;
		other.ammo_cells = other.ammo_cells + self.aflag;
	}

	bound_other_ammo ();

	sprint (other, "You got the ");
	sprint (other, self.netname);
	sprint (other, "\n");
// ammo touch sound
	sound (other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");

// change to a better weapon if appropriate

	if ( other.weapon == best )
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
	  self.nextthink = time + 30;
	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


// The touch func for our new items

void() painkeep_touch =
{
	local entity stm2;

	if (other.classname != "player") // pk - this is where the grap can grab stuff
	{
		grap_checkIfGrap();
		return;
	}

	if (self.pk_touch != painkeep_touch) // all items route through here - handle special cases, other touch fns & return
	{
		if (self.pk_touch == ammo_touch) self.pk_touch = pk_ammo_touch; // new fn for ammo collections
		if (self.pk_touch == pk_ammo_touch) // new & different ammo conditions
		{
//	cells
			if (self.weapon == 4 || self.weapon == -4)
			{
				if (other.ammo_cells >= 200)
					return;
				other.ammo_cells = other.ammo_cells + self.aflag;
				self.weapon = -4; // dont catch 100 cell limit in ammo_touch, always handle this here
			}

			if (self.weapon == 5) // *pk exploding shells
			{
				if (other.pk_explode_ammo >= PK_EXPLODEAMMO_MAX)
					return;
				other.pk_explode_ammo = other.pk_explode_ammo + self.aflag;
			}	
		}

		self.pk_touch();
		if (deathmatch == 3) // *pk - new dm mode settings
		{
			if (self.pk_touch == ammo_touch)
				self.nextthink = time + 15;
			if (self.pk_touch == armor_touch)
				self.nextthink = time + 20;
			
		}

		return;
	}

	// check if it can be picked up
	if(self.pk_items == PK_IT_BEARTRAP)
	{
		// check ammo
		if(other.pk_beartrapammo >= PK_BEARTRAPAMMO_MAX)
		{
			return;
		}
		other.pk_beartrapammo = other.pk_beartrapammo + 1;
	}
	else if(self.pk_items == PK_IT_TURRET)
	{
		// check ammo
		if(other.pk_turretammo >= PK_TURRETAMMO_MAX)
		{
			return;
		}
		other.pk_turretammo = other.pk_turretammo + 1;
	}
	if(self.pk_items == PK_IT_GRAVITYWELL)
	{
		// check ammo
		if(other.pk_gravitywellammo >= PK_GRAVITYWELLAMMO_MAX)
		{
			return;
		}
		other.pk_gravitywellammo = other.pk_gravitywellammo + 1;
	}
	else if(self.pk_items == PK_IT_CANPAB)
	{
		// check ammo
		if(other.pk_canpabammo >= PK_CANPABAMMO_MAX)
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
		if(self.pk_items == PK_IT_GRAVITYWELL)
			self.nextthink = time + 60*2;
		else
			self.nextthink = time + 60;
	}
	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};



/*QUAKED item_painkeep_gwell (0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_gwell =
{
	self.touch = painkeep_touch;

	self.noise = "items/protect.wav";
	setmodel (self,"progs/cubsmall.mdl");
	self.netname = "Gravity Well";
	self.pk_items = PK_IT_GRAVITYWELL;
	//setsize (self, '-32 -32 -32', '32 32 32');
	setsize (self, '-16 -16 -24', '16 16 32');
	self.th_weight = dont_weight;
	StartItem ();
	if (pk_mode == PK_MAP && !PK) PK = TRUE; // *pk - in map mode, set PK for painkeep mode
};

/*QUAKED item_painkeep_turret (0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_turret =
{
	self.touch = painkeep_touch;

	precache_model2 ("progs/tpower.mdl");
	setmodel (self,"progs/tpower.mdl");
	self.netname = "AutoSentry";
	self.pk_items = PK_IT_TURRET;

	setsize (self,'-7 -7 -7','4 7 21');
	self.th_weight = dont_weight;
	StartItem ();
	if (pk_mode == PK_MAP && !PK) PK = TRUE; // *pk - in map mode, set PK for painkeep mode
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
	self.touch = painkeep_touch;

	precache_model ("progs/beans.mdl");
	setmodel (self,"progs/beans.mdl");
	self.netname = "Can of pork and beans";
	self.pk_items = PK_IT_CANPAB;
	setsize (self, '-16 -16 -24', '16 16 32');
	self.th_weight = dont_weight;
	StartItem ();
	if (pk_mode == PK_MAP && !PK) PK = TRUE; // *pk - in map mode, set PK for painkeep mode
};

/*QUAKED item_painkeep_beartrap(0 .5 .8) (-16 -16 -24) (16 16 32)
*/
void () item_painkeep_beartrap =
{
	self.touch = painkeep_touch;

	precache_model ("progs/bearpick.mdl");
	setmodel (self,"progs/bearpick.mdl");
	self.netname = "Bear Trap";
	self.pk_items = PK_IT_BEARTRAP;
	setsize (self, '-16 -16 -24', '16 16 32');
	self.th_weight = dont_weight;
	StartItem ();
	if (pk_mode == PK_MAP && !PK) PK = TRUE; // *pk - in map mode, set PK for painkeep mode
};



/*QUAKED light_painkeep_candle (0 .5 0) (-10 -10 -20) (10 10 20)
Currently exactly the same as a small wall torch
*/
void () light_painkeep_candle =
{
	precache_model ("progs/candle.mdl");
	setmodel (self,"progs/candle.mdl");
	FireAmbient ();
	makestatic (self);
	if (pk_mode == PK_MAP && !PK) PK = TRUE; // *pk - in map mode, set PK for painkeep mode
};


/*QUAKED item_painkeep_expshells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void () item_painkeep_expshells =
{
	self.touch = ammo_touch;

	precache_model ("maps/b_eshel0.bsp");
	setmodel (self,"maps/b_eshel0.bsp");
	self.aflag = 10;

	self.weapon = 5;
	self.netname = "Exploding Shells";
	setsize (self, '0 0 0', '32 32 56');
	self.th_weight = dont_weight;
	StartItem ();
	if (pk_mode == PK_MAP && !PK) PK = TRUE; // *pk - in map mode, set PK for painkeep mode
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

void() ip_checkForMovement =
{
	if(self.solid != SOLID_NOT)
	if(self.ip_orgOrigin != self.origin)
	{ // position has changed... repawn after x minutes..
		self.think = ip_regen;
		self.nextthink = time + (ip_timeout * 60);
		return;
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
};

// called from PlaceItem, starts position think checks

void() pk_item_position_init =
{
	self.ip_orgOrigin = self.origin;

	self.think = ip_checkForMovement;
	self.nextthink = time + 60;
};

// called from bound_ammo - bounds for pk ammo

void() pk_bound_ammo =
{
	if (other.ammo_cells > 200)
		other.ammo_cells = 200;

	if(other.pk_gravitywellammo > PK_GRAVITYWELLAMMO_MAX)
		other.pk_gravitywellammo = PK_GRAVITYWELLAMMO_MAX;
	if(other.pk_turretammo > PK_TURRETAMMO_MAX)
		other.pk_turretammo = PK_TURRETAMMO_MAX;
	if(other.pk_canpabammo > PK_CANPABAMMO_MAX)
		other.pk_canpabammo = PK_CANPABAMMO_MAX;
	if(other.pk_beartrapammo > PK_BEARTRAPAMMO_MAX)
		other.pk_beartrapammo = PK_BEARTRAPAMMO_MAX;

	if(other.pk_explode_ammo > PK_EXPLODEAMMO_MAX)
		other.pk_explode_ammo = PK_EXPLODEAMMO_MAX;
};

// called from below - replacement for RankForWeapon - provides rank for some pk stuff

float(float w, float w2) PK_RankForWeapon =
{
bprint("PK_RankForWeapon\n");
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
bprint("PK_BackpackTouch\n");
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
bprint("PK_DropBackpack\n");
	local entity	item;

	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells + self.pk_explode_ammo))
		return;	// nothing in it

	item = spawn();
	item.origin = self.origin - '0 0 24';

	item.pk_items = 0;
	item.items = self.weapon;
	if (item.items == IT_AXE)
	{
		if(self.pk_currentitem == PK_IT_AXE)
			item.netname = "Axe";
		else if(self.pk_currentitem == PK_IT_GRAVITYWELL)
			item.netname = "Gravity Well";
		else if(self.pk_currentitem == PK_IT_TURRET)
			item.netname = "AutoSentry";
		else if(self.pk_currentitem == PK_IT_GRAPGUN)
			item.netname = "Harpoon Gun";
		else if(self.pk_currentitem == PK_IT_BEARTRAP)
			item.netname = "Bear Trap";
		else if(self.pk_currentitem == PK_IT_AIRGUN)
			item.netname = "AirFist";
		else if(self.pk_currentitem == PK_IT_CLIGHT)
			item.netname = "Chain Thunderbolt";
	}
	else if (item.items == IT_SHOTGUN)
		item.netname = "Shotgun";
	else if (item.items == IT_SUPER_SHOTGUN)
		item.netname = "Double-barrelled Shotgun";
	else if (item.items == IT_NAILGUN)
		item.netname = "Pulse Rifle";
	else if (item.items == IT_SUPER_NAILGUN)
		item.netname = "Super Nailgun";
	else if (item.items == IT_GRENADE_LAUNCHER)
		item.netname = "Grenade Launcher";
	else if (item.items == IT_ROCKET_LAUNCHER)
		item.netname = "Rocket Launcher";
	else if (item.items == IT_LIGHTNING)
		item.netname = "Thunderbolt";
	else
		item.netname = "";

	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;

		item.pk_gravitywellammo = self.pk_gravitywellammo;
		item.pk_turretammo = self.pk_turretammo;
		item.pk_canpabammo = self.pk_canpabammo;
		item.pk_beartrapammo = self.pk_beartrapammo;
	item.pk_explode_ammo = self.pk_explode_ammo;
	
	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);

	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;

	item.nextthink = time + 120;	// remove after 2 minutes
	item.think = SUB_Remove;
	AddToSplash(item); // *pk - splash tossed items
};

// called from PlaceItem - sorts many things now - happens 0.2 secs after map load

void() pk_placeitem =
{
	pk_item_position_init();

// handle extra item stuff
	self.pk_touch = self.touch;
	self.touch = painkeep_touch; // route everything here

// Cataboligne - added check here because new mode (not permanently PK & loaded a PK map can set PK mode after nailguns get loaded on map
	if (self.classname == "weapon_nailgun" || self.weapon == IT_NAILGUN)
	if (self.model == "progs/g_nail.mdl")
	{
		setmodel (self, "progs/g_fnail.mdl");
		self.netname = "Pulse Rifle";
	}
};
