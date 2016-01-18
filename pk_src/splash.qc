/* splish splash */

float SOLID_TIME = 120; // secs certain things can spend in solids

float NOT_IN_WATER = 0;
float pc;								// The content type the last entity to be checked just entered
float pcc;								// solid check below
float splash_count;			// The amout of splashes around. Used to keep the number down so we do'nt get any "No Free Edicts" messages

.float inwater;					// The water type the entity was in at last check
.string water_notify;		// Set to "yes" to make a splash
.void() splash_func;		// The function to call to make the splash
void() beartrapDie;	   // So we can remove bt's when in lava
void() turret_deathAnim;	  // So we can remove turrents whon in lava


// Remove a splash entity
void() Remove_Splash =
{
	splash_count = splash_count - 1;
	remove(self);
};

$frame splash1 splash2 splash3 splash4 splash5

void()	do_small_splash1 = [$splash1, do_small_splash2	] {};
void()	do_small_splash2 = [$splash1, do_small_splash3  ] {};
void()	do_small_splash3 = [$splash2, do_small_splash4  ] {};
void()	do_small_splash4 = [$splash2, do_small_splash5  ] {};
void()	do_small_splash5 = [$splash3, do_small_splash1  ] {Remove_Splash();};

void()	do_large_splash1 = [$splash1, do_large_splash2	] {};
void()	do_large_splash2 = [$splash2, do_large_splash3	] {};
void()	do_large_splash3 = [$splash3, do_large_splash4	] {};
void()	do_large_splash4 = [$splash4, do_large_splash5  ] {};
void()	do_large_splash5 = [$splash5, do_large_splash1  ] {Remove_Splash();};

// All lava splashes are big splashes, so they can be seen easily

void()	do_lava_splash1 = [$splash1, do_lava_splash2	] {};
void()	do_lava_splash2 = [$splash2, do_lava_splash3	] {};
void()	do_lava_splash3 = [$splash3, do_lava_splash4	] {};
void()	do_lava_splash4 = [$splash4, do_lava_splash1	] {Remove_Splash();};

/*
void()	do_lava_splash1 = [$splash1, do_lava_splash2	] {};
void()	do_lava_splash2 = [$splash1, do_lava_splash3	] {};
void()	do_lava_splash3 = [$splash2, do_lava_splash4	] {};
void()	do_lava_splash4 = [$splash2, do_lava_splash5	] {};
void()	do_lava_splash5 = [$splash3, do_lava_splash6	] {};
void()	do_lava_splash6 = [$splash3, do_lava_splash7	] {};
void()	do_lava_splash7 = [$splash4, do_lava_splash8	] {};
void()	do_lava_splash8 = [$splash4, do_lava_splash1	] {Remove_Splash();};
*/


// Make a splash at entity e
void(entity e) MakeSplash =
{
	if (splash_count < 20)
	{
		local entity newent;

		newent = spawn();

		setorigin(newent, e.origin);
		newent.solid = SOLID_NOT;
		newent.movetype = MOVETYPE_NONE;

		newent.nextthink = time + 0.1;

		if (pc == CONTENT_LAVA || e.inwater == CONTENT_LAVA)
		{
			setmodel(newent, "progs/s_splava.spr");
			newent.think = do_lava_splash1;
		}
		else
		{
			setmodel(newent, "progs/s_splash.spr");
			newent.think = e.splash_func;
		}

		splash_count = splash_count + 1;
	}
};

// Used to tell if an entity is in water
float(entity e) inWater =
{
	pcc = pc = pointcontents(e.origin);

	if (!(pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA))
		pc = NOT_IN_WATER;

	return pc;
};

// Makes splashes of an entity has meved in / out of water. Called in PlayerPreThink
void() CheckWaterLevels =
{
	local entity e;
	local float mv;

	cc_frame = framecount; // call only once per frame

	e = find(world, water_notify, "yes");

	while (e != world)
	{
		if (inWater(e) != e.inwater)
		{
	    if (e.classname == "drop")
	    {
	      sound(self, CHAN_AUTO, "misc/drip/drip_1.wav", 1, ATTN_NORM);
	      remove(e);
	    }
	    else
	    {
			if (!XENV || PK_100)
	      if ( ! pk_flags & PK_TP_SPARKSFLASH)
	        MakeSplash(e);

	      e.inwater = pc;

	      // Remove turrets and beartraps if they fall into the lava
	      if (pc == CONTENT_LAVA)
	      {
	        if (e.classname == "beartrap")
	        {
	          e.think = beartrapDie;
	          e.nextthink = time + 0.1;
	        }
	        else if (e.classname == "turret")
	        {
	          e.think = turret_deathAnim;
	          e.nextthink = time + 0.1;
	        }
			  else if (e.map  == "rune" && e.classname == "item_sigil")
			  {
				  local entity f;
	          e.think = SUB_Remove;
	          e.nextthink = time + 0.1;
				 rune_count = cnt_ent(world, "map", "rune") - 1;
				 f = find(world,classname,"rune_maker");
				 if (f) f.nextthink = time + 10 + random() * 60;
			  }
			  else if (e.classname == "tomb") // Cataboligne 8.12.9 purify - pk artifacts
			  {
					e.think = tombdie;
					e.nextthink = (time + 0.1);
			  }
	      }
	    }
	      
		}

// fall from grace - stuff out of level checks

// suspect shot stuff is from bots fallen out & not returned yet
		mv = 0 - cvar("sv_maxvelocity");

 		if (pcc == CONTENT_SOLID || (ceil(e.velocity_z) == -2011 || ceil(e.velocity_z) == mv))
		{
			if (ceil(e.velocity_z) == -2011 || ceil(e.velocity_z) == mv)
			{
				if (e.flags & FL_ITEM)
				{
					if (e.wait > -888)
					{
						e.wait = -888;
	//					bprint("*** warning: falling item hit -2011 vel*_z (terminal) - ");
	//					bprint(item_ident(e));
	//					bprint("\n");
					}
					if (e.ip_orgOrigin != v0) // put items back now
					{
						e.wait = e.wait - 1;
						if (e.wait < -895) e.movetype = MOVETYPE_NONE; // drastic but neccesary if a bounding box seems to cut into a wall / solid because item keeps falling after every reset
						e.ip_orgOrigin_z = e.ip_orgOrigin_z + 3;
						setorigin (e, e.ip_orgOrigin);
						e.velocity = v0;
//						e.think = ip_checkForMovement;
//						e.nextthink = time + CFM_TIME;
						if (WARNING)
						{
							bprint("*** warning: falling item reset - ");
							bprint(item_ident(e));
							if (e.movetype == MOVETYPE_NONE) bprint(" - FROZEN");
							bprint("\n");
						}
					}
				}
				else if (e.flags & FL_MONSTER && e.solid != SOLID_NOT) e.th_die(); // note: swim monsters dont set splash
				else if (IROBOT(e) ) //|| e.classname == "player")
				{
					f = spawn();
					f.classname = "CDM"; // Cataboligne - 2.20.11 - customized death messages
					f.netname = " fell from grace.";
					f.deadflag = 1; // use name
					f.frags = 0;
					T_Damage(e, e, f, 10000);
					remove(f);
				}
				else if (e.classname != "player")
				{
					if (WARNING)
					{
						bprint("*** warning: removed falling item - ");
						bprint(item_ident(e));
						bprint("\n");
					}
					if (e.classname == "turret") remove(e.turret_base);
					remove(e); // remove all else
				}
			}
		}

		e = find(e, water_notify, "yes");
	}
};

// Make the entity splash when it enteres / exits the water

void(entity e) AddToSplash =
{
	e.inwater = inWater(e);
	e.water_notify = "yes";
	e.splash_func = do_small_splash1;
};

void(entity e) AddToSplashBig =
{
	e.inwater = inWater(e);
	e.water_notify = "yes";
	e.splash_func = do_large_splash1;
};
