/* ::-::
 *
 * Cataboligne
 *
 * file: pk_itm_loopcyc.qc
 *
 * date: 5/28/10
 *
 * qc - support painkeep 2.0 item loop cycles
 *
 */


// run loop cycles

// .target - timer string
// .noise - 0 str
// .noise1-4 1-4 string
// .target1-2 5-6 string
// .theowner - ent loop

void(entity e, string l0, string l1, string l2, string l3, string l4, string l5, string l6, string t0) loop_var =
{
	e.noise = l0;			// store access value of "pk_cyc_{*}" parm loop vars in set of .string ent fields
	e.noise1 = l1;			// so same loop think can run all cyc vars
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
	if (cvar(e.noise) == -666)
		return(0);
	else if (!cvar(e.noise1) && !cvar(e.noise2) && !cvar(e.noise3) && !cvar(e.noise4) && !cvar(e.target1) && !cvar(e.target2))
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
	local entity e;
	local string mmc;

	svm = cvar("pk_cyc_master");
	f = cvar(self.noise);
	rp = cvar(self.noise1);
	self.cnt = dr = rn = FALSE;

	if (!f && !rp) // 1 & 0 are zeroed - restore items & remove
	{
		rn = TRUE;
	}

	if (svm && self.wait != -666)
	{
		mmc = item_by_mcode(self.delay);
		e = find( world, classname, mmc);
	}
	else
		e = self.theowner;
	while (e)
	{
		if (!e.scode) e.scode = e.mcode;
		if (!self.cnt) self.cnt = e.mcode;
		if (cvar("pk_cyc_halt") || rn)
		{
			item_call_save(e, item_by_mcode(e.scode));
		}
		else if (e.classname == "dyn_item" && e.mcode != self.cnt)
			dr = TRUE;
		else
		{
			f = loop_next(self, 0); // check all 0's
			if (!f) // keep these ents gone, code0 = -666 goes here
			{
				e.model = "";
				e.nextthink = -1;
				e.pk_touch = e.touch = SUB_Null;
			}
			else // cycle according to rules
			{

// TDO: mass replace here for all loop x.theowner, else below

				self.delay = f = loop_next(self, e.mcode);
				e.pk_touch = (void()) 0;
				if (self.killtarget != "")
					item_call_save(e, self.killtarget);
				else
				if (!f)
				{
					if (WARNING) bprint("\b*** warning: loop code changed on live item loop - restoring item.\n");
					item_call_save(e, item_by_mcode(e.scode));
				}
				else
					item_call_save(e, item_by_mcode(f)); // set replacement item
				if (self.map == "rune") self.map = ""; // rune server deal - this is a just in case - map runes should be pic or nopic
			}
		}

		if (dr) e = find( e, classname, "dyn_item");
		else 
		{
			if (svm && self.wait != -666)
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
	local float f0, f1, fr, sf;
	local vector v1;

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
		if (f0 < 0) // detect mass replace
		{
			cl = item_by_mcode(fabs(f0));
			if (cl != "")
			{
				e.killtarget = cl;
				fr = f1;
				e.wait = -666; // so we dont master server these!
bprint("switch list to: ");
bprint(cl);
bprint("\n");
			}
		}
		e.delay = f1;
		cl = item_by_mcode(f1);
bprint("first item: ");
bprint(cl);
	}
	if (cl == "")
	{
		remove(e);
		return; // failed - 0 or 1 (or both) not valid map codes
	}

	if (!cvar(e.target)) cvar_set(e.target, "-60"); // default timer


// TDO: mass replace here for all listed items - wait must be -666, check all levels
// have to set cl for each listed mc & ignore f1 not finding a sr
	sf = 1;

	if (f0 > -1 || f0 == -666 || fr)
	{
		while (sf > 0 || fr)
		{
			if (!cvar("pk_cyc_master") || fr)
			{
				if (!e.theowner)
				{
					if (cl != "")
						e.theowner = s2 = sr = find( world, classname, cl);
				}
				if (!sr && !fr)
				{
					remove(e);
					return; // none on map right now
				}

			  while (s2) // chain em up
				{
				s2 = sr.theowner = find( sr, classname, cl);
		//		if (cl != "dyn_item")
		//			sr = sr.theowner;
				if (s2)
				if (s2.mcode == f0 || s2.mcode == f1)
					sr = sr.theowner;
				else
					s2 = sr.theowner = find( sr, classname, cl);

		//		if (cvar("pk_cyc_dyn") && !sr) cl = "dyn_item"; // include dynamics - must have 1 reg item to start loop.
				}
				if (fr)
				{
					f1 = loop_next(e, f1);
					cl = item_by_mcode(f1);
if (f1 != fr)
{
bprint(", next item: ");
bprint(cl);
}
					if (f1 == fr) fr = 0; // done drop out
					else s2 = sr;
				}
			}
			sf = sf - 1;
		}
bprint("\n");
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
				if (!s2) s2 = findradius(world.origin, 256000);
				if (!s2)
				{
					remove(e);
					return; // no location - fail!
				}
				v1 = s2.origin + ' 0 0 8';
				if (s2.flags & FL_ITEM)
					v1 = stdv_rndloc(s2.origin + ' 0 0 8', 50, 100);
				setorigin(sr, v1);
				sr.wad = cl;
				item_call_save(sr, cl); // make first one
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

	if (Q_100 || PK_100)
	{
		remove(self);
		return;
	}

	self.nextthink = time + 15; // recheck every 10 secs?

// no sense in cycling removed items or constantly rndize items
	if (cvar("pk_place_item") == 1) return;
	if (cvar("pk_place_item") == 2 && cvar("pk_place_item_reload")) return;
	
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
};

 // TDO: should warn if !pk_art
