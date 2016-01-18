/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: pkpitems.qc
 *
 * date: Wed Aug 12 05:11:43 UTC 2009
 *
 * 
 *
 */

// painkeep artifacts support

void () pkplus_weapon_touch =
{
	local float hadammo;
	local float best;
	local float new;
	local float oldi;
	local float leave;
	if ( !(other.flags & FL_CLIENT))
	{
		grap_checkIfGrap();
		return ;
	}
	stemp = self;
	self = other;
	best = W_BestWeapon ();
	self = stemp;
	if (((deathmatch == 2) || (deathmatch == 3)) || coop)
		leave = 1;
	else
		leave = 0;

/*

deprecated - handled by pk v1.2.1 code

	if (self.pk_currentitem == PK_IT_GRAPGUN)
	{
		if (leave && (other.pk_items & PK_IT_GRAPGUN)) return ;

		new = PK_IT_GRAPGUN;
	}
	else
	{
		if (self.pk_currentitem == PK_IT_AIRGUN)
		{
			if (leave && (other.pk_items & PK_IT_AIRGUN)) return ;

			new = PK_IT_AIRGUN;
		}
		else
		{
			if (self.pk_currentitem == PK_IT_CLIGHT)
			{
				if (leave && (other.pk_items & PK_IT_CLIGHT)) return ;

				other.ammo_cells = (other.ammo_cells + 30);
				new = PK_IT_CLIGHT;
			}
			else
			{
				dprint ("painkeep_weapon_touch: unknown classname");
				return;
			}
		}
	}
*/
	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");
	sound (other,CHAN_ITEM,"weapons/pkup.wav",1,ATTN_NORM);
	stuffcmd (other,"bf\n");
	bound_other_ammo ();
	oldi = other.pk_items;
	other.pk_items = (other.pk_items | new);
	stemp = self;
	self = other;
//	Deathmatch_Weapon (0,IT_AXE,new); // fix
	W_SetCurrentAmmo ();
	self = stemp;
	if ( leave )
	{
		return ;
	}
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
	{
		self.nextthink = (time + RSP_TIME);
		self.think = SUB_regen;
	}
	activator = other;
	SUB_UseTargets ();
};

void () pkplus_touch =
{
	if (!PK_ART) return;

	if (other.classname != "player") //&& other.classname != "pk*bot")
	{
		grap_checkIfGrap();
		return ;
	}

	if (self.pk_items == PKPLUS_IT_EGO)
	{
		if (other.pkplus_egoammo >= PKPLUS_EGOAMMO_MAX) return ;
		other.pkplus_egoammo = (other.pkplus_egoammo + 1);
	}
	if (self.pk_items == PKPLUS_IT_TOMB)
	{
		if (other.pkplus_tombammo >= PKPLUS_TOMBAMMO_MAX) 	return ;
		other.pkplus_tombammo = (other.pkplus_tombammo + 1);
	}
	if (self.pk_items == PKPLUS_IT_ACTOR)
	{
		if (other.pkplus_actorammo >= PKPLUS_ACTORAMMO_MAX) return ;
		other.pkplus_actorammo = (other.pkplus_actorammo + 1);
	}
	if (self.pk_items == PKPLUS_IT_PHONE)
	{
		if (other.pkplus_phoneammo >= PKPLUS_PHONEAMMO_MAX) return ;
		other.pkplus_phoneammo = (other.pkplus_phoneammo + 1);
	}
	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");
	sound (other,CHAN_ITEM,"misc/pickup/tone2.wav",1,ATTN_NORM);
	stuffcmd (other,"bf\n");
	stemp = self;
	self = other;
	W_SetCurrentAmmo ();
	self = stemp;
	self.solid = SOLID_NOT;
	self.model = string_null;
	if (deathmatch != 2) // PK ART FIX ***
	{
		if ((self.pk_items == PKPLUS_IT_EGO) || (self.pk_items == PKPLUS_IT_PHONE))
		{
			self.nextthink = (time + (RSP_TIME * 10));
		}
		else
		{
			self.nextthink = (time + RSP_TIME * 2);
		}
	}
	self.think = SUB_regen;
	activator = other;
	SUB_UseTargets ();
};

void () item_pkplus_ego =
{
	if (!PK_ART)
	{
		remove(self);
		return;
	}
	self.touch = pkplus_touch;
	precache_model ("progs/ego.mdl");
	self.noise = "items/protect.wav";
	setmodel (self,"progs/ego.mdl");
	self.netname = "EGO";
	self.pk_items = PKPLUS_IT_EGO;
	setsize (self,'-16 -16 -24','16 16 32');
	StartItem ();
};

void () item_pkplus_tomb =
{
	if (!PK_ART)
	{
		remove(self);
		return;
	}
	self.touch = pkplus_touch;
	precache_model ("progs/tomb.mdl");
	self.noise = "items/protect.wav";
	setmodel (self,"progs/tomb.mdl");
	self.netname = "Tomb";
	self.pk_items = PKPLUS_IT_TOMB;
	setsize (self,'-16 -16 -24','16 16 32');
	StartItem ();
};

void () item_pkplus_actor =
{
	if (!PK_ART)
	{
		remove(self);
		return;
	}
	self.touch = pkplus_touch;
	precache_model ("progs/actor.mdl");
	setmodel (self,"progs/actor.mdl");
	self.netname = "Actor";
	self.pk_items = PKPLUS_IT_ACTOR;
	setsize (self,'-16 -16 -24','16 16 32');
	StartItem ();
};

void () item_pkplus_phone =
{
	if (!PK_ART)
	{
		remove(self);
		return;
	}
	self.touch = pkplus_touch;
	precache_model ("progs/phone.mdl");
	setmodel (self,"progs/phone.mdl");
	self.netname = "Cellular Phone";
	self.pk_items = PKPLUS_IT_PHONE;
	setsize (self,'-16 -16 -24','16 16 32');
	StartItem ();
};

// fn (pk_art_ammo_by_bit) - pk artifacts ammo for a given wep 

string (float bt) pk_art_ammo_by_bit =
{
// pk art item subs by special bits
	if (bt == WEP_EGO) return("item_pkplus_ego");
	if (bt == WEP_TOMB) return("item_pkplus_tomb");
	if (bt == WEP_ACTOR) return("item_pkplus_actor");
	if (bt == WEP_PHONE) return("item_pkplus_phone");

	return("");
};

// fn (pk_art_item_call) - pk artifacts call to create item

// return TRUE if attemp was made
// NOTE: must be called with proper self ent!

float(string cls) pk_art_item_call =
{
	local float ev;

	ev = FALSE;

	if (cls == "item_pkplus_ego")
	{
		item_pkplus_ego();
		ev = TRUE;
	}
	else if (cls == "item_pkplus_tomb")
	{
		item_pkplus_tomb();
		ev = TRUE;
	}
	else if (cls == "item_pkplus_actor")
	{
		item_pkplus_actor();
		ev = TRUE;
	}
	else if (cls == "item_pkplus_phone")
	{
		item_pkplus_phone();
		ev = TRUE;
	}

	return(ev);
};
