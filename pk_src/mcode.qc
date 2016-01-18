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

// sigil id - flags
float MC_SIGIL1				= 129;
float MC_SIGIL2				= 130;
float MC_SIGIL4				= 131;
float MC_SIGIL8				= 132;

float MC_Q1						= 133;

float MC_SIGIL					= 133;

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

};

// fn(pk_mcode) - map code for items

// e - ent being tested
// sc - classname to test
// returns map code value

float(string sc, entity e) pk_mcode =
{
	local float mc;
	local string tsc;

	tsc = sc;
	if (sc == "" && e) tsc = e.classname;
	if (tsc == "") return(0);

	if (tsc == "dyn_item")												mc = 0;
// q1
	else if (tsc == "weapon_supershotgun")							mc = MC_SUPER_SHOTGUN;
	else if (tsc == "weapon_nailgun")								mc = MC_NAILGUN;
	else if (tsc == "weapon_supernailgun")							mc = MC_SUPER_NAILGUN;
	else if (tsc == "weapon_grenadelauncher")						mc = MC_GRENADEL;
	else if (tsc == "weapon_rocketlauncher")						mc = MC_ROCKETL;
	else if (tsc == "weapon_lightning")								mc = MC_THUNDER;
// pk
	else if (tsc == "weapon_airfist")								mc = MC_AIRGUN;
	else if (tsc == "weapon_chainlg")								mc = MC_CHTHUNDR;
	else if (tsc == "weapon_grapgun")								mc = MC_GRAP;
	else if (tsc == "weapon_pulsenail")								mc = MC_PULSE_NAILGUN;
	else if (tsc == "item_painkeep_gwell")							mc = MC_GRAVITY;
	else if (tsc == "item_painkeep_turret")						mc = MC_SENTRY;
	else if (tsc == "item_painkeep_beartrap")						mc = MC_BEARTRAP;
	else if (tsc == "item_painkeep_expshells")					mc = MC_AEXPLSH;
	else if (tsc == "item_painkeep_can")							mc = MC_CANOBEANS;
	else if (tsc == "item_pkplus_ego")								mc = MC_EGO;
	else if (tsc == "item_pkplus_tomb")								mc = MC_TOMB;
	else if (tsc == "item_pkplus_actor")							mc = MC_MASK;
	else if (tsc == "item_pkplus_phone")							mc = MC_PHONE;
// ammo
	else if (tsc == "item_shells")									mc = MC_ASHELLS;
	else if (tsc == "item_spikes")									mc = MC_ANAILS;
	else if (tsc == "item_rockets")									mc = MC_AROCKETS;
	else if (tsc == "item_cells")										mc = MC_ACELLS;

	else if (tsc == "item_artifact_invulnerability")			mc = MC_PENT;
	else if (tsc == "item_artifact_super_damage")				mc = MC_QUAD;
	else if (tsc == "item_artifact_invisibility")				mc = MC_RING;
	else if (tsc == "item_artifact_envirosuit")					mc = MC_SUIT;

	else if (tsc == "item_health")									mc = MC_HEALTH;
	else if (tsc == "item_armor1")									mc = MC_ARMOR1;
	else if (tsc == "item_armor2")									mc = MC_ARMOR2;
	else if (tsc == "item_armorInv")									mc = MC_ARMOR3;
	else if (tsc == "item_key1")										mc = MC_KEY1;
	else if (tsc == "item_key2")										mc = MC_KEY2;
	else if (tsc == "item_sigil")										mc = MC_SIGIL;
// q3 - translates classname for now
//	else if (tsc == "")								mc = MC_;

	if (e) // qualify ent
	{
	if ((tsc == "item_shells") && (e.spawnflags & 1))			mc = MC_ASHELLS_LG;
	else if ((tsc == "item_spikes") && (e.spawnflags & 1))	mc = MC_ANAILS_LG;
	else if ((tsc == "item_rockets") && (e.spawnflags & 1))	mc = MC_AROCKETS_LG;
	else if ((tsc == "item_cells") && (e.spawnflags & 1))		mc = MC_ACELLS_LG;
	else if ((tsc == "item_health") && (e.spawnflags & 1))	mc = MC_HEALTHROT;
	else if ((tsc == "item_health") && (e.spawnflags & 2))	mc = MC_HEALTHMEGA;

	else if ((tsc == "item_sigil") && (e.spawnflags & R_EARTH))		mc = MC_SIGIL1;
	else if ((tsc == "item_sigil") && (e.spawnflags & R_BLACK))		mc = MC_SIGIL2;
	else if ((tsc == "item_sigil") && (e.spawnflags & R_HELL))		mc = MC_SIGIL4;
	else if ((tsc == "item_sigil") && (e.spawnflags & R_ELDER))		mc = MC_SIGIL8;
	}

	if (tsc != "dyn_item" && mc == 0)
	{
		bprint("\b *** item with no map code translation:\n");
		bprint(" -------------->  ");
		bprint(tsc);
		bprint("\n");
	}

	return(mc); 

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

	sc = item_by_mcode(mc);
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

	sv = self;
	self = spawn();
	self.wad = sc;

	setorigin(self, v1);
	item_call(sc);
	self.velocity_z = 300 + 100 * random();
	self.velocity_x = -170 + (random() * 340);
	self.velocity_y = -170 + (random() * 340);

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