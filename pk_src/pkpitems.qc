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


/*

deprecated - handled by pk v1.2.1 code - not used at all !!

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
*/

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
			self.nextthink = (time + (RSP_TIME * 4));
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

// handle live pk_art on startup

void(entity e) pkplus_item_control =
{
	if (PK_ART) // turned back on - come here from loop
	{
		setmodel (e,e.mdl);
		e.touch = painkeep_touch;
		e.pk_touch = pkplus_touch;
		return;
	}

	if (time < PIC_TO)
//	if (cvar("pk_place_item") != 0) // pic - just block appearance, rnd does rest - not needed
	{
		setmodel (e,"");
		e.touch = SUB_Null;
	}
	else // IDEA: option to turn into rnd regular pk items
	{
		if (e.classname == "dyn_item")
		{
			if (WARNING) bprint("*** Warning - dynamic items: pk_art is off and dynamic made a pkplus item - hiding\n");
		}
		else
		if (WARNING) bprint("*** Warning - pk_art is off and code made a pkplus item - hiding\n");
		setmodel (e,"");
		e.touch = SUB_Null;
	}

};

// twiddled after map load

void() pkplus_item_control_loop =
{
	local entity e, sv;
	local string sr;

// note: disabled - if rndize makes any that get clobbered we want to restore them
//	if (cvar("pk_place_item") != 0)
//		return;

	sr = "150";									// IDEA: get these like this: = ftos(pk_mcode("item_pkplus_ego", world));
	e = find(world,sscode,sr);
	while (e)
	{
		pkplus_item_control(e);
		e = find(e,sscode,sr);
		if (!e)
		{
		if (sr == "150") sr = "151";
		else if (sr == "151") sr = "152";
		else if (sr == "152") sr = "153";
		e = find(e,sscode,sr);
		}
	}
};

void () item_pkplus_ego =
{
	self.touch = pkplus_touch;
	precache_model ("progs/ego.mdl");
	self.noise = "items/protect.wav";
	setmodel (self,"progs/ego.mdl");
	self.netname = "EGO";
	self.pk_items = PKPLUS_IT_EGO;
	setsize (self,'-16 -16 -24','16 16 32');
	StartItem ();
	if (!PK_ART) pkplus_item_control(self);
};

void () item_pkplus_tomb =
{
	self.touch = pkplus_touch;
	precache_model ("progs/tomb.mdl");
	self.noise = "items/protect.wav";
	setmodel (self,"progs/tomb.mdl");
	self.netname = "Tomb";
	self.pk_items = PKPLUS_IT_TOMB;
	setsize (self,'-16 -16 -24','16 16 32');
	StartItem ();
	if (!PK_ART) pkplus_item_control(self);
};

void () item_pkplus_actor =
{
	self.touch = pkplus_touch;
	precache_model ("progs/actor.mdl");
	setmodel (self,"progs/actor.mdl");
	self.netname = "Actor";
	self.pk_items = PKPLUS_IT_ACTOR;
	setsize (self,'-16 -16 -24','16 16 32');
	StartItem ();
	if (!PK_ART) pkplus_item_control(self);
};

void () item_pkplus_phone =
{
	self.touch = pkplus_touch;
	precache_model ("progs/phone.mdl");
	setmodel (self,"progs/phone.mdl");
	self.netname = "Cellular Phone";
	self.pk_items = PKPLUS_IT_PHONE;
	setsize (self,'-16 -16 -24','16 16 32');
	StartItem ();
	if (!PK_ART) pkplus_item_control(self);
};


