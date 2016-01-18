/* ::-::
 *
 * Cataboligne
 *
 * file: pk_art.defs.qc
 *
 * date: 8/12/09
 *
 * qc - support painkeep artifacts mod (tho 'tis a silly mod)
 *
 */

/* also referred to as painkeep plus

coding NOTES:

in most fn's self must be player ent requiring access to pk artifacts - this code is not generic

*/

// fn(pk_art_parms) - deal with change parms for artifacts

void(float sel) pk_art_parms =
{
	if (!sel)
	{
		parm11 = parm11 + ((self.pkplus_egoammo & 3) * 4096) + ((self.pkplus_tombammo & 3) * 16384) + ((self.pkplus_actorammo & 3) * 65536) + ((self.pkplus_phoneammo & 3) * 262144);
	}
	else // if (sel == 1)
	{
//		self.pk_items = PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE | parm10 | PK_IT_AXE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_CANPAB | PK_IT_BEARTRAP | (parm16 & PK_IT_EXTRADISP);
//		self.pk_items = self.pk_items | PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE;
		self.pkplus_egoammo = floor(parm11 / 4096) & 3;
		self.pkplus_tombammo = floor(parm11 / 16384) & 3;
		self.pkplus_actorammo = floor(parm11 / 65536) & 3;
		self.pkplus_phoneammo = floor(parm11 / 262144) & 3;
	}
};

// fn(pk_art_attack) - fire pk artifacts weps &| use items

// NOTE: dbl check PK_IT_AXE?

void() pk_art_attack  =
{
	if (self.pk_currentitem == PKPLUS_IT_TOMB)
	{
		tomb_launch ();
		self.pkplus_tombammo = (self.pkplus_tombammo - 1);
		self.attack_finished = (time + 0.5);
		if (self.pkplus_tombammo < 1)
		{
			self.pk_currentInventory = PK_IT_AXE;
			self.weapon = W_BestWeapon ();
			self.pk_currentitem = W_BestPKWeapon ();
			W_SetCurrentAmmo ();
		}
	}
	else if (self.pk_currentitem == PKPLUS_IT_ACTOR)
	{
		if (self.pkplus_actorskin == PKPLUS_ACTORQUAD)
		{
			actor_quad_activate ();
		}
		else
		{
			actor_pent_activate ();
		}
		self.pkplus_actorammo = (self.pkplus_actorammo - 1);
		self.attack_finished = (time + 0.5);
		if (self.pkplus_actorammo < 1)
		{
			self.pk_currentInventory = PK_IT_AXE;
			self.weapon = W_BestWeapon ();
			self.pk_currentitem = W_BestPKWeapon ();
			W_SetCurrentAmmo ();
		}
	}
	else if (self.pk_currentitem == PKPLUS_IT_PHONE)
	{
		phone_activate ();
		self.pkplus_phoneammo = (self.pkplus_phoneammo - 1);
		self.attack_finished = (time + 0.5);
		if (self.pkplus_phoneammo < 1)
		{
			self.pk_currentInventory = PK_IT_AXE;
			self.weapon = W_BestWeapon ();
			self.pk_currentitem = W_BestPKWeapon ();
			W_SetCurrentAmmo ();
		}
	}
};

// fn(pk_art_setcurrentammo) - set ammo on pk artifacts items

void(float wch) pk_art_setcurrentammo =
{
	if (self.pk_currentitem == PKPLUS_IT_EGO)
	{
		self.currentammo = self.pkplus_egoammo;
		self.weaponmodel = "progs/v_ego.mdl";
		self.weaponframe = 0;
		if (wch)
			sprint (self,"Ego\n");
	}
	else
	if (self.pk_currentitem == PKPLUS_IT_TOMB)
	{
		self.currentammo = self.pkplus_tombammo;
		self.weaponmodel = "progs/v_tomb.mdl";
		self.weaponframe = 0;
		if (wch)
			sprint (self,"Tomb\n");
	}
	else
	if (self.pk_currentitem == PKPLUS_IT_ACTOR)
	{
		if (self.pkplus_actorskin == PKPLUS_ACTORQUAD)
		{
			self.weaponmodel = "progs/v_actorb.mdl";
		}
		else
//		if (self.pkplus_actorskin == PKPLUS_ACTORPENT)
		{	
				self.weaponmodel = "progs/v_actorr.mdl";
		}
		self.currentammo = self.pkplus_actorammo;
		self.weaponframe = 0;
		if (wch)
			sprint (self,"Actor\n");
	}
	else if (self.pk_currentitem == PKPLUS_IT_PHONE)
	{
		self.currentammo = self.pkplus_phoneammo;
		self.weaponmodel = "progs/v_phone.mdl";
		self.weaponframe = 0;
		if (wch)
			sprint (self,"Cellular Phone\n");
	}
};

// fn(pk_art_hasammo) - check for pk artifact items
// NOTE: returns TRUE if false condition exists, FALSE in all other cases

float(float pkn) pk_art_hasammo =
{
		if (pkn == PKPLUS_IT_EGO)
		{
			if (self.pkplus_egoammo < 1)
				return TRUE;
		}
		else if (pkn== PKPLUS_IT_TOMB)
		{
			if (self.pkplus_tombammo < 1)
				return TRUE;
		}
		else if (pkn == PKPLUS_IT_ACTOR)
		{
			if (self.pkplus_actorammo < 1)
				return TRUE;
		}
		else if (pkn == PKPLUS_IT_PHONE)
		{
			if (self.pkplus_phoneammo < 1)
				return TRUE;
		}
	return FALSE;
};

// fn(pk_art_specialimpulse) - test for pk artifact impulse codes - note: do not like it done this way

void(float pkimp) pk_art_specialimpulse =
{
	if (pkimp == 161)
	{
		if (self.pkplus_egoammo < 1) return ;
		self.pk_currentitem = PKPLUS_IT_EGO;
		self.pk_currentInventory = PKPLUS_IT_EGO;
	}
	else if (pkimp == 162)
	{
		if (self.pkplus_tombammo < 1) return ;
		self.pk_currentitem = PKPLUS_IT_TOMB;
		self.pk_currentInventory = PKPLUS_IT_TOMB;
	}
	else if (pkimp == 163)
	{
	if (self.pkplus_actorammo < 1) return ;
	self.pkplus_actorskin = PKPLUS_ACTORPENT;
	self.pk_currentitem = PKPLUS_IT_ACTOR;
	self.pk_currentInventory = PKPLUS_IT_ACTOR;
	}
	else if (pkimp == 164)
	{
		if (self.pkplus_actorammo < 1) return ;
		self.pkplus_actorskin = PKPLUS_ACTORQUAD;
		self.pk_currentitem = PKPLUS_IT_ACTOR;
		self.pk_currentInventory = PKPLUS_IT_ACTOR;
	}
	else if (pkimp == 165)
	{
		if (self.pkplus_phoneammo < 1) return ;
		self.pk_currentitem = PKPLUS_IT_PHONE;
		self.pk_currentInventory = PKPLUS_IT_PHONE;
	}
};

// fn(pk_art_cycleobjects) - pk artifacts cycle - replaces reg painkeep code entirely

void() pk_art_cycleobjects =
{
	while (1)
	{
		if (self.pk_currentitem == PK_IT_AXE)
			self.pk_currentitem = PK_IT_GRAVITYWELL;
		else if (self.pk_currentitem == PK_IT_GRAVITYWELL)
			self.pk_currentitem = PK_IT_TURRET;
		else if (self.pk_currentitem == PK_IT_TURRET)
			self.pk_currentitem = PK_IT_BEARTRAP;
		else if (self.pk_currentitem == PK_IT_BEARTRAP)
			self.pk_currentitem = PK_IT_CANPAB;
		else if (self.pk_currentitem == PK_IT_CANPAB)
			self.pk_currentitem = PKPLUS_IT_EGO;
		else if (self.pk_currentitem == PKPLUS_IT_EGO)
			self.pk_currentitem = PKPLUS_IT_TOMB;
		else if (self.pk_currentitem == PKPLUS_IT_TOMB)
		{
			self.pkplus_actorskin = PKPLUS_ACTORQUAD;
			self.pk_currentitem = PKPLUS_IT_ACTOR;
		}
		else if (self.pk_currentitem == PKPLUS_IT_ACTOR)
		{
			if (self.pkplus_actorskin == PKPLUS_ACTORQUAD)
			{
				self.pkplus_actorskin = PKPLUS_ACTORPENT;
			}
			else
			{
			self.pkplus_actorskin = 0;
			self.pk_currentitem = PKPLUS_IT_PHONE;
			}
		}
		else if (self.pk_currentitem == PKPLUS_IT_PHONE)
			self.pk_currentitem = PK_IT_AXE;
		else
			return;		// get's here when the currentitem == a normal pk weapon

		if (HasAmmo(IT_AXE, self.pk_currentitem))
		{
			self.pk_currentInventory = self.pk_currentitem;
			return;
		}
	}
};

// fn(pk_art_cheat) - pk artifacts cheat command implementation

void() pk_art_cheat =
{
	self.pkplus_egoammo = PKPLUS_EGOAMMO_MAX;
	self.pkplus_tombammo = PKPLUS_TOMBAMMO_MAX;
	self.pkplus_actorammo = PKPLUS_ACTORAMMO_MAX;
	self.pkplus_phoneammo = PKPLUS_PHONEAMMO_MAX;
};

// fn(pk_art_bound_ammo) - pk artifacts ammo limits

void(entity oth)  pk_art_bound_ammo =
{
	if (oth.pkplus_egoammo > PKPLUS_EGOAMMO_MAX)
		oth.pkplus_egoammo = PKPLUS_EGOAMMO_MAX;
	if (oth.pkplus_tombammo > PKPLUS_TOMBAMMO_MAX)
		oth.pkplus_tombammo = PKPLUS_TOMBAMMO_MAX;
	if (oth.pkplus_actorammo > PKPLUS_ACTORAMMO_MAX)
		oth.pkplus_actorammo = PKPLUS_ACTORAMMO_MAX;
	if (oth.pkplus_phoneammo > PKPLUS_PHONEAMMO_MAX)
		oth.pkplus_phoneammo = PKPLUS_PHONEAMMO_MAX;
};

// fn(pk_art_powerup_touch) - pk artifacts powerup touch replacement

void () pk_art_powerup_touch =
{
	local float best;

	if (other.classname != "player")
			return;
	if (other.health <= 0)
		return ;

	sprint (other,"You got the ");
	sprint (other,self.netname);
	sprint (other,"\n");

	if (!PK || (PK && deathmatch != 4)) // *pk - my new rule, logical extrapolation
	if (deathmatch)
	{
		self.mdl = self.model;

		if ((self.classname == "item_artifact_invulnerability") ||
			(self.classname == "item_artifact_invisibility"))
			self.nextthink = time + 60*5;
		else
			self.nextthink = time + 60;

		self.think = SUB_regen;
	}

	sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;

// do the apropriate action
	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = 1;
		other.radsuit_finished = time + 30;
	}

	if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = 1;
		other.invincible_finished = time + 30;
		if (other.pkplus_actortype == PKPLUS_ACTORPENT) // pk art code here
			other.pkplus_actortype = 0;
	}

	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = 1;
		other.invisible_finished = time + 30;
	}

	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = 1;
		other.super_damage_finished = time + 30;
		if (other.pkplus_actortype == PKPLUS_ACTORQUAD) // pk art code here
			other.pkplus_actortype = 0;
		}

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

// fn(pk_art_backpack_touch) - pk artifacts in packs

// self is pack ent

void(entity oth, float acnt) pk_art_backpack_touch =
{
	local string bs;

	oth.pkplus_egoammo = (oth.pkplus_egoammo + self.pkplus_egoammo);
	oth.pkplus_tombammo = (oth.pkplus_tombammo + self.pkplus_tombammo);
	oth.pkplus_actorammo = (oth.pkplus_actorammo + self.pkplus_actorammo);
	oth.pkplus_phoneammo = (oth.pkplus_phoneammo + self.pkplus_phoneammo);

	if ( self.pkplus_egoammo )
	{
		if ( acnt )
			sprint (oth,", ");
		acnt = 1;
		bs = ftos (self.pkplus_egoammo);
		sprint (oth,bs);
		sprint (oth," EGOs");
	}
	if ( self.pkplus_tombammo )
	{
		if ( acnt )
			sprint (oth,", ");
		acnt = 1;
		bs = ftos (self.pkplus_tombammo);
		sprint (oth,bs);
		sprint (oth," Tombs");
	}
	if ( self.pkplus_actorammo )
	{
		if ( acnt )
			sprint (oth,", ");
		acnt = 1;
		bs = ftos (self.pkplus_actorammo);
		sprint (oth,bs);
		sprint (oth," Actors");
	}
	if ( self.pkplus_phoneammo )
	{
		if ( acnt )
			sprint (oth,", ");
		acnt = 1;
		bs = ftos (self.pkplus_phoneammo);
		sprint (oth,bs);
		sprint (oth," Cell Phones");
	}
};

// fn(pk_art_backpack_drop) - pk artifacts in packs, drop some

// itm is pack ent

void(entity itm) pk_art_backpack_drop =

{
	if (self.pk_currentitem == PKPLUS_IT_EGO)
		itm.netname = "EGO";
	else if (self.pk_currentitem == PKPLUS_IT_TOMB)
		itm.netname = "Tomb";
	else if (self.pk_currentitem == PKPLUS_IT_ACTOR)
		itm.netname = "Actor";
	else if (self.pk_currentitem == PKPLUS_IT_PHONE)
		itm.netname = "Cell Phone";

	itm.pkplus_egoammo = self.pkplus_egoammo;
	itm.pkplus_tombammo = self.pkplus_tombammo;
	itm.pkplus_actorammo = self.pkplus_actorammo;
	itm.pkplus_phoneammo = self.pkplus_phoneammo;
};


// fn(pk_art_checkpwr) - print pk artifacts run powerups

// returns FALSE is regular code can run
// self is player

float() pk_art_checkpwr =
{
// invincibility
	if (self.invincible_finished)
	{
// sound and screen flash when items starts to run out
		if (self.invincible_finished < time + 3)
		{
			if (self.invincible_time == 1)
			{
				if  (self.pkplus_actortype == PKPLUS_ACTORPENT) // pk art code here
					sprint (self,"Get ready to leave the RED stage - Good Performance!\n");
				else
					sprint (self, "Protection is almost burned out\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}

			if (self.invincible_time < time)
			{
				self.invincible_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.invincible_finished < time)
		{	// just stopped
			self.items = self.items - IT_INVULNERABILITY;
			self.invincible_time = 0;
			self.invincible_finished = 0;
			if (self.pkplus_actortype == PKPLUS_ACTORPENT) // pk art code here
				self.pkplus_actortype = 0;
		}
		if (self.invincible_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		
		return TRUE;
	}

// super damage
	if (self.super_damage_finished)
	{

// sound and screen flash when items starts to run out

		if (self.super_damage_finished < time + 3)
		{
			if (self.super_time == 1)
			{
				if (self.pkplus_actortype == PKPLUS_ACTORQUAD) // pk art code here
					sprint (self,"The BLUE Curtain is dropping - You really frightened them!\n");
				else
					sprint (self, "Quad Damage is wearing off\n");
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}

			if (self.super_time < time)
			{
				self.super_time = time + 1;
				stuffcmd (self, "bf\n");
			}
		}

		if (self.super_damage_finished < time)
		{	// just stopped
			self.items = self.items - IT_QUAD;
			self.super_damage_finished = 0;
			self.super_time = 0;
			if (self.pkplus_actortype == PKPLUS_ACTORQUAD)
				self.pkplus_actortype = 0;
		}
		if (self.super_damage_finished > time)
			self.effects = self.effects | EF_DIMLIGHT;
		else
			self.effects = self.effects - (self.effects & EF_DIMLIGHT);
		
		return TRUE;
	}

	return FALSE;
};

// fn(pk_art_obit) - print pk artifacts obituarys

// returns TRUE if obit complete

float(entity trg, entity infl, entity atkr) pk_art_obit =
{
	local float rnum;

		if (infl.classname == "ego")
		{
			rnum = random ();
			bprint (trg.netname);
			if (infl.owner == trg)
			{
				trg.frags = (trg.frags - 1);
				if (rnum < 0.250)
					bprint (" had a mental breakdown!\n");
				else if (rnum < 0.5)
					bprint (" let his EGO get out of control!\n");
				else if (rnum < 0.750)
					bprint ("'s own EGO was self destructive!\n");
				else
					bprint ("'s EGO sometimes has a mind of its own!\n");
				return TRUE;
			}
			atkr.frags = (atkr.frags + 1);
			if (rnum < 0.250)
				bprint (" was impressed by the power of ");
			else if (rnum < 0.5)
				bprint (" was counseled by ");
			else if (rnum < 0.750)
				bprint (" was overpowered by ");
			else
				bprint (" was manipulated by ");
			bprint (atkr.netname);
			bprint ("'s EGO\n");
			return TRUE;
		}
		if (infl.classname == "corpse")
		{
			rnum = random ();
			bprint (trg.netname);
			if (infl.owner == trg)
			{
				trg.frags = (trg.frags - 1);
				if (rnum < 0.250)
					bprint (" was caught robbing the family grave!\n");
				else if (rnum < 0.5)
						bprint (" could not get away from a relative's corpse\n");
				else if (rnum < 0.750)
					bprint (" should not have gone for the family's jewelry\n");
				else
					bprint (" was brought down by an old friend\n");
				return TRUE;
			}
			atkr.frags = (atkr.frags + 1);
			if (rnum < 0.250)
				bprint (" was dragged down by an old friend in ");
			else if (rnum < 0.5)
				bprint (" was laid to rest by ");
			else if (rnum < 0.750)
				bprint (", poor kid, got tuckered out dragging someone in ");
			else
				bprint (" should not have defiled ");
			bprint (atkr.netname);
			bprint ("'s Tomb\n");
			return TRUE;
		}

	return FALSE;
};

// fn(pk_art_ck_lava) - pk artifacts check for things in lava

// en is ent

void(entity en) pk_art_ck_lava =
{
	if (en.classname == "tomb")
	{
		en.think = tombdie;
		en.nextthink = (time + 0.1);
	}
};
// fn(pk_art_prinv) - print pk artifacts inventory with rest of pk inventory of same nature

void() pk_art_prinv =
{
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,6767882);
		WriteB3 (MSG_ONE,2126703);
		WriteB3 (MSG_ONE,8250);
		WriteBFloat (MSG_ONE,self.pkplus_egoammo);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,7296010);
		WriteB3 (MSG_ONE,7561837);
		WriteB3 (MSG_ONE,2112032);
		WriteBFloat (MSG_ONE,self.pkplus_tombammo);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,6504714);
		WriteB3 (MSG_ONE,7499636);
		WriteB3 (MSG_ONE,3809395);
		WriteB3 (MSG_ONE,32);
		WriteBFloat (MSG_ONE,self.pkplus_actorammo);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,6636298);
		WriteB3 (MSG_ONE,7695468);
		WriteB3 (MSG_ONE,7496044);
		WriteB3 (MSG_ONE,6836256);
		WriteB3 (MSG_ONE,6647407);
		WriteB3 (MSG_ONE,3809395);
		WriteB3 (MSG_ONE,32);
		WriteBFloat (MSG_ONE,self.pkplus_phoneammo);
};
// fn(pk_art_precache) - load er up

void() pk_art_precache =
{
	precache_sound ("ego/ego.wav");
	precache_model ("progs/ego.mdl");
	precache_model ("progs/v_ego.mdl");
	precache_model ("progs/tomb.mdl");
	precache_model ("progs/tomb2.mdl");
	precache_model ("progs/v_tomb.mdl");
	precache_sound ("tomb/heart.wav");
	precache_sound ("tomb/tombdrop.wav");
	precache_sound ("tomb/tombdie.wav");
	precache_sound ("tomb/tombopen.wav");
	precache_model ("progs/actor.mdl");
	precache_model ("progs/v_actorb.mdl");
	precache_model ("progs/v_actorr.mdl");
	precache_model ("progs/phone.mdl");
	precache_model ("progs/v_phone.mdl");
	precache_sound ("phone/phone.wav");
};

