/*
		+---------------------------------------+
		|  Runes code                           | SEC-HEAD
		+---------------------------------------+
*/

// implement runes for pk


void(entity e, float f, float r) rune_print =
{
	if (e)
	{
	if (r)
	{
	if (f == R_EARTH) sprint(e, "Earth rune - ");
	else if (f == R_BLACK) sprint(e, "Black rune - ");
	else if (f == R_HELL) sprint(e, "Hell rune - ");
	else if (f == R_ELDER) sprint(e, "Elder rune - ");
	else if (f == R_ELDER) sprint(e, "Elder rune - ");
	}

	if (f == RUNE_FLG_RS) sprint(e, "Resistance = 1/2 damage all attacks.\n");
	else if (f == RUNE_FLG_DM && RUNES == 1) 	sprint(e, "Damage = 2 x damage for 30 secs.  8 x damage if combined with quad.\n");
	else if (f == RUNE_FLG_DM) 	sprint(e, "Damage = 2 x damage.\n");
	else if (f == RUNE_FLG_HS) sprint(e, "Haste - double fire rate most weps.\n");
	else if (f == RUNE_FLG_RG) sprint(e, "Regeneration - regen 5 health | armor every 1/2 second\n");
	else sprint(e, "Rune not identified - unknown power!\n");

	return;
	}
	if (f == RUNE_FLG_RS) bprint("Resistance = 1/2 damage all attacks.\n");
	else if (f == RUNE_FLG_DM && RUNES == 1) 	bprint("Damage = 2 x damage for 30 secs.  8 x damage if combined with quad.\n");
	else if (f == RUNE_FLG_DM) 	bprint("Damage = 2 x damage.\n");
	else if (f == RUNE_FLG_HS) bprint("Haste - double fire rate most weps.\n");
	else if (f == RUNE_FLG_RG) bprint("Regeneration - regen 5 health | armor every 1/2 second\n");
	else bprint("Rune not identified - unknown power!\n");
};

// return a rune bit mask for given map code

float(float mc) rune_bit =
{
	local float f;

	f = 0;
	if (mc == MC_SIGIL1) f = R_EARTH; //RUNE_FLG_RS;
	else if (mc == MC_SIGIL2) f = R_BLACK; //RUNE_FLG_DM;
	else if (mc == MC_SIGIL4) f = R_HELL; //RUNE_FLG_HS;
	else if (mc == MC_SIGIL8) f = R_ELDER; //RUNE_FLG_RG;

	return(f);
};

// one cvar implementation of manual rune cfg

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

// run runes

void() run_runes =
{
	local entity e;
	local float f, k, sf;

	RUNE_3_ACM = cvar("sv_c_rune_3acm");
	RUNE_CNT = cvar("sv_c_rune_cnt");
	RUNE_MASK = cvar("sv_c_rune_mask") & RUNE_MASK_ALL;

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
			if (!R_EARTH) R_EARTH = k; // any fail get assigned random powers
			else if (!R_BLACK) R_BLACK = k;
			else if (!R_HELL) R_HELL = k;
			else if (!R_ELDER) R_ELDER = k;
			bprint("***   Runes randomly selected from pool of available rune powers\n");
		}
	}

	mk_rune_set(); // manual config

	if (RUNES != cvar("sv_c_rune")) // changed, off or on
	{
		RUNES = cvar("sv_c_rune");

		e = find(world,map,"rune"); // off or on, rid map of runes
		while (e)
		{
			remove(e);
			e = find(e,map,"rune");
		}

		if (RUNES) // turning runes on
		{
			rune_count = 0;
			e = spawn();
			if (e)
			{
				e.classname = "rune_maker";
				e.think = rune_maker;
				e.nextthink = time + 30 * random(); // do this well after items spawn
			}
			bprint("***   Runes of power will spawn on this map - keep an eye out\n");
		}
	}

	if (!PK_100)
	if (cvar("pk_runemap")) // display rune info on console (network - all players see this)
	{
		bprint("\bRunes:\n\n");
		if (RUNES) bprint("Runes will appear in random locations\n");
		else bprint("Runes are deactivated\n");
		bprint("total rune count : ");
		bprint(ftos(RUNE_CNT));
		bprint("\n");

		if (RUNE_RANDOM) bprint("runes are selecting random powers\n");
		bprint("\nallowed runes mask: ");
		bit_print(RUNE_MASK_ALL, RUNE_MASK);
		bprint(", of total : ");
		bit_print(RUNE_MASK_ALL, RUNE_MASK_ALL);
		bprint("\nwhere 0 indicates an unused rune\n\n");

		bprint("earth magic | (mc:121 bit:");
		bit_print(RUNE_MASK_ALL, R_EARTH);
		bprint(") ");
		rune_print(world, R_EARTH, FALSE);
		bprint("black magic | (mc:122 bit:");
		bit_print(RUNE_MASK_ALL, R_BLACK);
		bprint(") ");
		rune_print(world, R_BLACK, FALSE);
		bprint("hell magic  | (mc:123 bit:");
		bit_print(RUNE_MASK_ALL, R_HELL);
		bprint(") ");
		rune_print(world, R_HELL, FALSE);
		bprint("elder magic | (mc:124 bit:");
		bit_print(RUNE_MASK_ALL, R_ELDER);
		bprint(") ");
		rune_print(world, R_ELDER, FALSE);
		bprint("\n");
		cvar_set("pk_runemap", "0");
	}

};

