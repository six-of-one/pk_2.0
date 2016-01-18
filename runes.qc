/*
		+---------------------------------------+
		|  Runes code                           | SEC-HEAD
		+---------------------------------------+
*/

// implement runes for pk


void(entity e, float f, float r) rune_print =
{
	if (f < 0)
	{
		if (fabs(f) == R_EARTH) bprint("Earth rune - ");
		else if (fabs(f) == R_BLACK) bprint("Black rune - ");
		else if (fabs(f) == R_HELL) bprint("Hell rune -  ");
		else if (fabs(f) == R_ELDER) bprint("Elder rune - ");
		else bprint("Unkown rune - ");
		return;
	}

	if (e)
	{
	if (r)
	{
	if (f == R_EARTH) sprint(e, "Earth rune - ");
	else if (f == R_BLACK) sprint(e, "Black rune - ");
	else if (f == R_HELL) sprint(e, "Hell rune - ");
	else if (f == R_ELDER) sprint(e, "Elder rune - ");
	else bprint("Unkown rune - ");
	}

	if (f == RUNE_FLG_RS) sprint(e, "Resistance = 1/2 damage all attacks.\n");
	else if (f == RUNE_FLG_DM && RUNES < 2) 	sprint(e, "Damage = 2 x damage for 30 secs.  8 x damage if combined with quad.\n");
	else if (f == RUNE_FLG_DM) 	sprint(e, "Damage = 2 x damage.\n");
	else if (f == RUNE_FLG_HS) sprint(e, "Haste - double fire rate for most weps.\n");
	else if (f == RUNE_FLG_RG) sprint(e, "Regeneration - add 5 health | armor every 1/2 second\n");
	else sprint(e, "Rune not identified - unknown power!\n");

	return;
	}
	if (f == RUNE_FLG_RS) bprint("Resistance = 1/2 damage all attacks.\n");
	else if (f == RUNE_FLG_DM && RUNES < 2) 	bprint("Damage = 2 x damage for 30 secs.\n"); //  8 x damage if combined with quad.\n");
	else if (f == RUNE_FLG_DM) 	bprint("Damage = 2 x damage.\n");
	else if (f == RUNE_FLG_HS) bprint("Haste - double fire rate most weps.\n");
	else if (f == RUNE_FLG_RG) bprint("Regenerate 5 health | armor per .5 sec\n");
	else bprint("Rune not identified - unknown power!\n");
};

// return a rune bit mask for given map code or a map code for given rune bit mask

float(float mc, float bc) rune_bit_code =
{
	local float f;

	f = 0;
	if (mc == MC_SIGIL1) f = R_EARTH; //RUNE_FLG_RS; // these can be randomly assigned now
	else if (mc == MC_SIGIL2) f = R_BLACK; //RUNE_FLG_DM;
	else if (mc == MC_SIGIL4) f = R_HELL; //RUNE_FLG_HS;
	else if (mc == MC_SIGIL8) f = R_ELDER; //RUNE_FLG_RG;
	else if (bc == R_EARTH) f = MC_SIGIL1;
	else if (bc == R_BLACK) f = MC_SIGIL2;
	else if (bc == R_HELL) f = MC_SIGIL4;
	else if (bc == R_ELDER) f = MC_SIGIL8;

	return(f);
};

string(float b) rune_name =
{
	if (b == R_EARTH) return("Earth magic");
	if (b == R_BLACK) return("Black magic");
	if (b == R_HELL) return("Hell magic");
	if (b == R_ELDER) return("Elder magic");
	return("Unknown magic");
}

float nonserver_rune_found;

void(float b) rune_map_print =
{
	local float f;
	local entity e;

	f = 0 - b;
	rune_print(world, f, FALSE);
	bprint("(mc:");
	bprint(ftos(rune_bit_code(0, b)));
	bprint(" bit:");
	bit_print(RUNE_MASK_ALL, b);
	e = find(world, netname, rune_name(b));
	while (e && e.map != "rune")
	{
		nonserver_rune_found = TRUE; // found a map spawned / func_dynamic / func_make rune
		e = find(e, netname, rune_name(b));
	}
	if (e)
	{
		if (e.solid == SOLID_NOT)
			bprint(" regen-- ");
		else
			bprint(" spawned ");
	}
	else
		bprint(" ------- ");
	bprint(") ");
	rune_print(world, b, FALSE);
};

// one cvar implementation of manual rune cfg

// 1 - set sv_c_rune_set to a valid rune map code
// 2 - set sv_c_rune_set to a valid rune power bit code

void() mk_rune_set =
{
	if (!rune_set)
	{
		if (cvar("sv_c_rune_set"))
		{
			rune_set = cvar("sv_c_rune_set");
			if (rune_set < MC_SIGIL1 || rune_set > MC_SIGIL8) rune_set = 0;
			cvar_set("sv_c_rune_set", "0");
		}
	}
	else
	{
		if (cvar("sv_c_rune_set"))
		{
			if (RUNE_RANDOM) bprint("\b*** warning: manual rune config with rune random set!\n");
			if (rune_set == MC_SIGIL1) R_EARTH = cvar("sv_c_rune_set") & RUNE_MASK_ALL;
			else if (rune_set == MC_SIGIL2) R_BLACK = cvar("sv_c_rune_set") & RUNE_MASK_ALL;
			else if (rune_set == MC_SIGIL4) R_HELL = cvar("sv_c_rune_set") & RUNE_MASK_ALL;
			else if (rune_set == MC_SIGIL8) R_ELDER = cvar("sv_c_rune_set") & RUNE_MASK_ALL;
			cvar_set("sv_c_rune_set", "0");
			rune_set = 0;
		}
		if (!R_EARTH) R_EARTH = RUNE_FLG_RS; // any fail get assigned std. powers
		else if (!R_BLACK) R_BLACK = RUNE_FLG_DM;
		else if (!R_HELL) R_HELL = RUNE_FLG_HS;
		else if (!R_ELDER) R_ELDER = RUNE_FLG_RG;
	}
};

// print rune info on impulse from e to p

void(entity e, entity p) rune_id =
{
	local float f;

	f = 1;

	if (WARNING)
	if (!RUNES)
	{
		sprint(p, "*** Rune server is turned off.\n\n");
	}

	if (e == p) sprint(p, "You have");
	else
	{
		sprint(p, e.netname);
		sprint(p, " has");
	}
	if (!e.rune_flag)
	{
		sprint(p, " no runes.\n\n");
		return;
	}
	else	sprint(p, " the following runes:\n\n");
	while (f & RUNE_MASK_ALL)
	{
		if (f & e.rune_flag) rune_print(p, f, TRUE); 
		f = f * 2;
	}
};

// rune 1 rules - runes expire in pow time

void () rune_1_expire =
{
	if (self.owner.rune_flag & self.rune_flag)
	{
		if (self.rune_flag & RUNE_FLG_FLY)	
			self.owner.movetype = MOVETYPE_WALK;
		self.owner.rune_flag = self.owner.rune_flag - (self.owner.rune_flag & self.rune_flag);
		if (self.owner.target2 == "progs/q3_art.mdl") self.owner.target2 = "";
		sprint(self.owner, "The power of the ");
		sprint(self.owner, self.netname);
		if (self.noise4 == "q3_snd/poweruprespawn.wav")
			sprint(self.owner, " has expired.\n");
		else
		sprint(self.owner, " rune has expired.\n");
	}
	remove(self);
};

// because map runes still need to serverflag and random can change spawnflags

void () rune_sigil_touch =
{
	if (other.classname != "player")
			return;
	if (other.health <= 0)
		return ;

	centerprint (other,"You got the rune!");

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other,"bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	if (self.duration) // random runes - map run val goes here
		serverflags = serverflags | (self.duration & 15);
	else
	serverflags = serverflags | (self.spawnflags & 15);
	self.classname = "";		// so rune doors won't find it		Cat: ??? - huh?

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

// IDEA: rule 1 sfx here, 3 runes - 10+ secs, 4 runes - 1+ min or till death

void () rune_touch =
{
	local entity e;

	if (other.classname != "player")
	if (other.classname != "pk*bot")
			return;
	if (other.health <= 0)
		return ;

	if (self.map == "pic_item")
	if (!deathmatch) rune_sigil_touch(); // map rune in sp must allow touch even if rules prevent getting rune

	if (RUNES == 1)
	if (!RUNE_AR1M)
	if (other.rune_flag)
		return;

	if (RUNES == 1)
	if (other.rune_flag & self.spawnflags) // already got one
		return;

	if (self.map == "pic_item") rune_sigil_touch(); // map rune (should have pic_item set), do a touch for qstart map serverflags floor op

	if (! (self.spawnflags & RUNE_MASK)) // rune not allowed - prob map rune
		return;

	centerprint3 (other,"You got the ",self.netname," Rune!");
	sprint(other,"You have the power of ");
	rune_print(other, self.spawnflags, FALSE);

	sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd (other,"bf\n");

	other.rune_flag = other.rune_flag | (self.spawnflags & RUNE_MASK_ALL);

	if (RUNES == 1)
	{
		e = spawn();
		if (e)
		{
			e.classname = "rune_1_expiry";
			e.netname = self.netname;
			e.rune_flag = self.spawnflags & RUNE_MASK_ALL;
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
//	if (deathmatch !=  2) // this is likely a meaningless deal for runes
		self.nextthink = time + RSP_TIME;
		self.think = SUB_regen;
	}

//	serverflags = serverflags | (self.spawnflags & 15);

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};

// make runes for runeserver

// NOTE: other code making runes should NEVER set .delay - this would allow this code to remove the rune if server is turned off live

float rune_map; // runes on level

void() rune_maker =
{
	local entity e;
	local float sf, f;
	local vector v1;

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
			self = e;

			self.mcode = MC_SIGIL1 + rint(random() * 3.3);

			sf = 111;
			if (rune_count < 4) // spawn 4 uinque runes on a map when starting
			while (sf > 0)
			{
				f = rune_bit_code(self.mcode, 0) & RUNE_MASK;
				if (f && !(f & rune_map))
					sf = 0;
				else
					self.mcode = MC_SIGIL1 + rint(random() * 3.3);
				sf = sf - 1;
			}

			sf = 111;
			while (sf > 0)
			{
				f = rune_bit_code(self.mcode, 0);
				if (f & RUNE_MASK)
					sf = 0;
				else
					self.mcode = MC_SIGIL1 + rint(random() * 3.3);
				if (sf == 1)
				{
					f = 1;
					while (!( f & RUNE_MASK) && f < RUNE_MASK_ALL)
						f = f * 2;
					if (f > RUNE_MASK_ALL) // failed somehow to make any rune that fit rules
					{
						if (WARNING) bprint("*** warning: rune_make could not find a rune that fit mask rules - giving up\n");
						remove(self);
						return;
					}
				}
				sf = sf - 1;
			}

			self.wad = item_by_mcode(self.mcode);

			e = dyn_rndloc();
			if (!e) e = findradius(world.origin, 256000);
			if (!e) 
			{
				if (WARNING) bprint("*** warning: rune_make could not find a random (or any) location - giving up\n");
				remove(self);
				return; // crap - no location
			}
			v1 = e.origin + ' 0 0 8';
			if (e.flags & FL_ITEM) // randomize away from other map items
				v1 = stdv_rndloc(e.origin + ' 0 0 8', 50, 100);
			setorigin(self, v1);

			item_call(self.wad);

			AddToSplash(self); // splash code kills lava immersed runes

			rune_map = rune_map | self.spawnflags;
			self.count = 2 + random() * 3.8; // controls no-touch reposition code in check movement deal
			self.delay = self.cnt = 0;

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

			rune_count = rune_count + 1;
		}
	}
};

// count chg - remove rune(s) - must NOT remove non server made runes!

void(float r1, float p) remove_rune =
{
	local float f;
	local entity e;

	f = ceil(r1);
	e = find(world, map, "rune");

	while (e && f > 0)
	{
		f = f - 1;
		if (f < 1)
		{
			if (e.classname == "item_sigil")
			{
				if (p)
				{
				bprint("\b*** RUNE removed: ");
				bprint(e.netname);
				bprint("\n");
				}
				remove(e);
				e = world;
			}
		}
		e = find(e, map, "rune");
	}
};

// run runes

void() run_runes =
{
	local entity e;
	local float f, k, sf;

	RUNE_AR1M = cvar("sv_c_rune_allowrule1multi");
	RUNE_R1SFX = 0;
	if (RUNE_AR1M)
		RUNE_R1SFX = cvar("sv_c_rune_rule1sfx"); // if true and multi -  3 | 4 runes in 1 player have side effects

	RUNE_3_ACM = cvar("sv_c_rune_3acm");
	RUNE_MASK = cvar("sv_c_rune_mask") & RUNE_MASK_ALL;
	if (RUNE_MASK < 1 || RUNE_MASK > RUNE_MASK_ALL) RUNE_MASK = RUNE_MASK_ALL;

 	if (RUNE_RANDOM != cvar("sv_c_rune_random")) // changed random state
	{
		RUNE_RANDOM = cvar("sv_c_rune_random");

		R_EARTH = RUNE_FLG_RS; // normal cfg
		R_BLACK = RUNE_FLG_DM;
		R_HELL = RUNE_FLG_HS;
		R_ELDER = RUNE_FLG_RG;

		if (RUNE_RANDOM)
		{
			R_EARTH = 0;
			R_BLACK = 0;
			R_HELL = 0;
			R_ELDER = 0;
			sf = 100;
			f = RUNE_MASK_ALL;
			while (f != 0 && sf > 0) // try to make a nice one of each deal
			{
				k = rnd_bit_mask(f);
				if (!R_EARTH) R_EARTH = k;
				else if (!R_BLACK) R_BLACK = k;
				else if (!R_HELL) R_HELL = k;
				else if (!R_ELDER) R_ELDER = k;

				f = f - (f & k);
				sf = sf - 1;
			}
			if (!R_EARTH) R_EARTH = rnd_bit_mask(RUNE_MASK); // any fail get assigned random powers
			if (!R_BLACK) R_BLACK = rnd_bit_mask(RUNE_MASK);
			if (!R_HELL) R_HELL = rnd_bit_mask(RUNE_MASK);
			if (!R_ELDER) R_ELDER = rnd_bit_mask(RUNE_MASK);
			bprint("***   Runes randomly selected from pool of available rune powers\n");
		}
	}

	mk_rune_set(); // manual config

	if (RUNES != cvar("sv_c_rune")) // changed, off or on - controls rune server
	{
		RUNES = cvar("sv_c_rune");

		e = find(world,map,"rune"); // off or on, rid map of runes & makers
		while (e)
		{
			if (e.classname == "item_sigil")
				remove(e);
			e = find(e,map,"rune");
		}
		e = find(world, classname, "rune_maker");
		while (e)
		{
			remove(e);
			e = find(e, classname, "rune_maker");
		}
		rune_count = 0;

		if (RUNES) // turning runes on
		{
			e = spawn();
			if (e)
			{
				e.classname = "rune_maker";
				e.think = rune_maker;
				e.nextthink = time + PIC_TO + 2 + 23 * random(); // do this well after items spawn - PIC_TO
			}
			bprint("***   Runes of power will spawn on this map - keep an eye out\n");
		}
		else
			bprint("***   Rune server - turned off an all spawned runes removed\n");
	}

 	if (RUNE_CNT != cvar("sv_c_rune_cnt"))
	{
		RUNE_CNT = cvar("sv_c_rune_cnt");
		rune_count = cnt_ent(world, "map", "rune");
		if (RUNE_CNT < 1) RUNE_CNT  = 4;
		if (rune_count > 0)
		{
			while (rune_count > RUNE_CNT)
			{
				f = random() * rune_count;
				remove_rune(f, TRUE);
				rune_count = cnt_ent(world, "map", "rune");
			}
			if (rune_count < RUNE_CNT)
			{
				e = find(world, classname, "rune_maker");
				if (e) e.nextthink = time + 10 + random() * 60;
			}
		}
	}

	if (cvar("pk_runemap")) // display rune info on console (network - all players see this)
	{
		bprint("\bRunes:\n\n");
		if (RUNES) bprint("Runes will appear in random locations\n");
		else bprint("Rune server is deactivated\n"); // note: runes can still appear on map from func_dyn, rndize
		bprint("total rune count : ");
		bprint(ftos(RUNE_CNT));
		bprint("\n");
		bprint("runes on map : ");
		bprint(ftos(rune_count));
		bprint("\n");

		if (RUNE_RANDOM) bprint("runes are selecting random powers\n");
		bprint("\nallowed runes mask: ");
		bit_print(RUNE_MASK_ALL, RUNE_MASK);
		bprint(", of total : ");
		bit_print(RUNE_MASK_ALL, RUNE_MASK_ALL);
		bprint("\nwhere 0 indicates a forbidden rune\n\n");

		rune_map_print(R_EARTH);
		rune_map_print(R_BLACK);
		rune_map_print(R_HELL);
		rune_map_print(R_ELDER);
		bprint("\n");
		if (nonserver_rune_found)
			bprint("* non server Runes are loaded on this map.\n\n");
		cvar_set("pk_runemap", "0");
	}

};

.float rg_time;
.float regeneration_sound;
.float haste_sound;

void() RegenerationSound =
{
// RUNE play healing sound if player has regen rune
	if (self.regeneration_sound < time)
	{
		self.regeneration_sound = time + 1;
		sound(self, CHAN_BODY, "items/r_item1.wav", 1, ATTN_NORM);
	}
};

void() rune_regen =
{
	local float f;

	if (self.deadflag)
		return;

	if (self.view_ofs == '0 0 0')
		return;		// intermission or finale

	if (self.rg_time > time)
		return;

	f = 5;

	if (self.health < 100)
	{
		self.health = self.health + f; // NOTE: violates T_Heal rule (implied from t_dmg rule) of only fn to add health - relates to morphs & needs morph tweak here
		if (self.health > 100)
			self.health = 100;
		RegenerationSound();
	}
	if (self.target2 != "progs/q3_art.mdl") // apparently q3 doesnt regen armor
	if (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3))
	if (self.armorvalue < 200) // q2 allows values over 200
	{
		self.armorvalue = self.armorvalue + f;
		if ((self.items & IT_ARMOR3) && (self.armorvalue > 200)) // NOTE: increments q2 armor beyond local max limit in some cases (q2 jacket)
			self.armorvalue = 200;
		else if ((self.items & IT_ARMOR2) && (self.armorvalue > 150))
		  self.armorvalue = 150;
		else if ((self.items & IT_ARMOR1) && (self.armorvalue > 100))
			self.armorvalue = 100;
		else
			RegenerationSound();
//		if (self.armorvalue>250) self.armorvalue=200;
	}

	pk_setDamageSkin(self);
	self.rg_time = time + 0.5;
};

void() HasteSound =
{
// RUNE play haste (Chthon's roar) sound if player has Haste rune
		if (self.haste_sound < time)
		{
			self.haste_sound = time + 2;
			sound(self, CHAN_BODY, "boss1/sight1.wav", 1, ATTN_NORM);
		}
};

// op haste - ret true if att_fin needs set

float(float atf) rune_haste =
{
	if (!self.rune_flag & RUNE_FLG_HS) return(TRUE);

	self.attack_finished = time + atf;
	HasteSound();
	return(FALSE);
};

/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
End of level sigil, pick up to end episode and return to jrstart.
*/

// NOTE - q100 code never used because q100 can run a rune server - think on this

// fix initial server map load runes where random is on

void () item_sigil_set =
{
	if (RUNE_RANDOM)
	{
		if (self.owner.duration & 1) self.owner.spawnflags = rune_bit_code(MC_SIGIL1, 0);
		else if (self.owner.duration & 2) self.owner.spawnflags = rune_bit_code(MC_SIGIL2, 0);
		else if (self.owner.duration & 4) self.owner.spawnflags = rune_bit_code(MC_SIGIL4, 0);
		else if (self.owner.duration & 8) self.owner.spawnflags = rune_bit_code(MC_SIGIL8, 0);
	}
	remove(self);
};

void () item_sigil =
{
	local float f, rune;

	if (!RUNES)
	if (time < PIC_TO)
	{
		if (time < 2) // delay till we can read cvar - HUH?  dont freaking get why this is necc!  if this isnt done for an initial server start map load rune has sigil_touch set and things fail
		{
			self.nextthink = time + 1;
			self.think = item_sigil;
			return;
		}
		rune = FALSE;
		if (RUNES != cvar("sv_c_rune")) rune = cvar("sv_c_rune"); // map load issue - 1st map loaded has no RUNES val here for map load runes
		chaos_spawn(0, 0, 0, 0,  v0, v0, v0, v0, v0, "", "", SUB_Null, PIC_TO, item_sigil_set, SUB_Null, self, world); // random rune spawnflags fix
	}

	if (!self.spawnflags)
//		objerror ("no spawnflags");
	{
		if (Q_100 && Q_100_OBJERR) objerror("no spawnflags");
		else
		{
			if (WARNING)
			{
				if (Q_100 || PK_100)
					bprint("\n*** warning:\nsigil with no spawnflags - removed.\n");
				else
					bprint("\n*** warning:\nsigil with no spawnflags - randomizing.\n");
			}
			if (Q_100 || PK_100)
			{
				remove(self);
				return;
			}
			else
			self.spawnflags = rnd_bit_mask(15);
		}
	}

	precache_sound ("misc/runekey.wav");
	self.noise = "misc/runekey.wav";

	self.duration = 0;
	if (time < PIC_TO) // make sure map runes load the correct appearance even if powers change
	{
		self.duration = self.spawnflags & RUNE_MASK_ALL;
		if (self.spawnflags & 1) f = rune_bit_code(MC_SIGIL1, 0);
		else if (self.spawnflags & 2) f = rune_bit_code(MC_SIGIL2, 0);
		else if (self.spawnflags & 4) f = rune_bit_code(MC_SIGIL4, 0);
		else if (self.spawnflags & 8) f = rune_bit_code(MC_SIGIL8, 0);
		else f = rnd_bit_mask(15); // fail! no spawnflag - just pick one at random
		self.spawnflags = f;
	}

	if (self.spawnflags & R_EARTH)
	{
		precache_model ("progs/end1.mdl");
		setmodel (self,"progs/end1.mdl");
		self.netname = "Earth magic"; // Cataboligne - 5.32.10 - for rune server
	}
	if (self.spawnflags & R_BLACK)
	{
		precache_model2 ("progs/end2.mdl");
		setmodel (self,"progs/end2.mdl");
		self.netname = "Black magic"; // Cataboligne - 5.32.10 - for rune server
	}
	if (self.spawnflags & R_HELL)
	{
		precache_model2 ("progs/end3.mdl");
		setmodel (self,"progs/end3.mdl");
		self.netname = "Hell magic"; // Cataboligne - 5.32.10 - for rune server
	}
	if (self.spawnflags & R_ELDER)
	{
		precache_model2 ("progs/end4.mdl");
		setmodel (self,"progs/end4.mdl");
		self.netname = "Elder magic"; // Cataboligne - 5.32.10 - for rune server
	}

	if (time > PIC_TO)
	if(self.map == "")
		self.map = "rune"; // Cataboligne - 5.32.10 - for rune server

	if (RUNES || rune)
		self.touch = rune_touch;
	else
	self.touch = sigil_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
};
