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
	if (e.classname == "func_make") return; // override

// no sense in working removed items or constantly rndize items
	if (cvar("pk_place_item") == 1) return;
	if (cvar("pk_place_item") == 2 || cvar("pk_place_item") == 3)
	{
		if (cvar("pk_place_item_reload"))
		if (cvar("pk_place_item_reload") < 60) return;
		if (!PK_ART)
		{
			e.class_select = "";
			e.classname = "";
		}
		return;
	}
// TDO: fix where rndize once made pkplus and they got turned off - re-rndize them

	if (PK_ART) // turned back on - come here from loop
	{
		if (e.mcode != e.scode)
		{
			e.mcode = e.scode;
			e.wad = item_by_mcode(e.mcode);
			item_call_save(e, e.wad);
		}
		else
		{
			setmodel (e,e.mdl);
			e.touch = painkeep_touch;
			e.pk_touch = pkplus_touch;
		}
		return;
	}

	if (e.classname == "dyn_item")
		{
			if (WARNING) bprint("*** Warning - dynamic items: pk_art is off and dynamic made a pkplus item - hiding\n");
		}
//		else
//		if (WARNING) bprint("*** Warning - pk_art is off and code made a pkplus item - hiding\n");

	if (!cvar("pk_art_rep"))
		{
			setmodel (e,"");
			e.touch = SUB_Null;
		}
	else
		{
			local float f;
			f = MC_PK_RNDITM;
//			if (e.mcode > 149 && e.mcode < MC_PK)
			e.mcode = MC_PULSE_NAILGUN + rint(random() * f); // NOTE: starts with pulse gun - this could change if item order in mcode is changed!
			e.wad = item_by_mcode(e.mcode);
			if (e.wad != "")
			{
				e.pk_touch = (void()) 0; // so we can touch the new things
				item_call_save(e, e.wad);
			}
			else
			{
				e.mcode = e.scode;
				setmodel (e,"");
				e.touch = SUB_Null;
			}
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

	sr = "pkplus_item";
	e = find(world,class_select,sr);
	while (e)
	{
		pkplus_item_control(e);
		e = find(e,class_select,sr);
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
	if (self.class_select == "") self.class_select = "pkplus_item";
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
	if (self.class_select == "") self.class_select = "pkplus_item";
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
	if (self.class_select == "") self.class_select = "pkplus_item";
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
	if (self.class_select == "") self.class_select = "pkplus_item";
	if (!PK_ART) pkplus_item_control(self);
};


