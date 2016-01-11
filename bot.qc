/* ::-::
 *
 * Cataboligne
 *
 * file: bot.qc
 *
 * date: Sun Apr 6
 *
 * moved various bot fn() here for adaptive code
 *
 */

// relocate from client.qc



float () FindGood =
{
	fClientNo = (fClientNo + 1);
	if (!(fActiveClients & 1))
	{
		fActiveClients = (fActiveClients | 1);
		return (1);
	}
	else if (!(fActiveClients & 2))
	{
		fActiveClients = (fActiveClients | 2);
		return (2);
	}
	else if (!(fActiveClients & 4))
	{
		fActiveClients = (fActiveClients | 4);
		return (3);
	}
	else if (!(fActiveClients & 8))
	{
		fActiveClients = (fActiveClients | 8);
		return (4);
	}
	else if (!(fActiveClients & 16))
	{
		fActiveClients = (fActiveClients | 16);
		return(TE_LIGHTNING1);
	}
	else if (!(fActiveClients & 32))
	{
		fActiveClients = (fActiveClients | 32);
		return (6);
	}
	else if (!(fActiveClients & 64))
	{
		fActiveClients = (fActiveClients | 64);
		return (7);
	}
	else if (!(fActiveClients & 128))
	{
		fActiveClients = (fActiveClients | 128);
		return (8);
	}
	else if (!(fActiveClients & 256))
	{
		fActiveClients = (fActiveClients | 256);
		return (9);
	}
	else if (!(fActiveClients & 512))
	{
		fActiveClients = (fActiveClients | 512);
		return (10);
	}
	else if (!(fActiveClients & 1024))
	{
		fActiveClients = (fActiveClients | 1024);
		return (11);
	}
	else if (!(fActiveClients & 2048))
	{
		fActiveClients = (fActiveClients | 2048);
		return(12);
	}
	else if (!(fActiveClients & 4096))
	{
		fActiveClients = (fActiveClients | 4096);
		return (13);
	}
	else if (!(fActiveClients & 8192))
	{
		fActiveClients = (fActiveClients | 8192);
		return(14);
	}
	else if (!(fActiveClients & 16384))
	{
		fActiveClients = (fActiveClients | 16384);
		return(15);
	}
	else if (!(fActiveClients & 32768))
	{
		fActiveClients = (fActiveClients | 32768);
		return (16);
	}
	else
	{
		return (-1);
	}

};

void (float abba) MakeGood =
{
	local float ackbar;
	ackbar = WEAPON_SHOTGUN;
	abba = (abba - 1);
	while (abba > NAMEBOTS)
	{
		ackbar = (ackbar * 2);
		abba = (abba - 1);
	}
	fClientNo = (fClientNo - 1);
	fActiveClients = (fActiveClients - (fActiveClients & ackbar));
};

void (entity object) Update_Frags =
{
	WriteByte (MSG_ALL,MSG_UPDATEFRAGS);
	WriteByte (MSG_ALL,object.id);
	WriteShort (MSG_ALL,object.frags);
};



void (entity c) PrintClientScore =
{
	if ((c.frags > -10) && (c.frags < 0))
	{
		bprint (" ");
	}
	else if (c.frags >= 0)
	{
		if (c.frags < 100)
		{
			bprint (" ");
		}
		if (c.frags < 10)
		{
			bprint (" ");
		}
	}
};

void () DumpScore =
{
	local entity e;
	local entity sort;
	local entity walk;
	if (world.chain)
	{
		error ("DumpScore: world.chain is set");
	}
	e = find (world,classname,"player");
	sort = world;
	while (e)
	{
		if (!sort)
		{
			sort = e;
			e.chain = world;
		}
		else
		{
			if (e.frags > sort.frags)
			{
				e.chain = sort;
				sort = e;
			}
			else
			{
				walk = sort;
				do
				{
					if (!walk.chain)
					{
						e.chain = world;
						walk.chain = e;
					}
					else if (walk.chain.frags < e.frags)
					{
						e.chain = walk.chain;
						walk.chain = e;
					}
					else
					{
						walk = walk.chain;
					}
				} while (walk.chain != e);
			}
		}
		e = find (e,classname,"player");
	}
	bprint ("\n");
	while (sort)
	{
		PrintClientScore (sort);
		sort = sort.chain;
	}
	bprint ("\n");
};



float () getrandombotskin =
{
	local float botskin;
	botskin = random ();
	if (botskin <= 0.066)
	{
		return(NAMEBOTS);
	}
	if ((botskin > 0.066) && (botskin <= 0.132))
	{
		return (1);
	}
	if ((botskin > 0.132) && (botskin <= 0.198))
	{
		return (2);
	}
	if ((botskin > 0.198) && (botskin <= 0.264))
	{
		return (3);
	}
	if ((botskin > 0.264) && (botskin <= 0.330))
	{
		return (4);
	}
	if ((botskin > 0.330) && (botskin <= 0.396))
	{
		return(TE_LIGHTNING1);
	}
	if ((botskin > 0.396) && (botskin <= 0.462))
	{
		return (6);
	}
	if ((botskin > 0.462) && (botskin <= 0.528))
	{
		return (7);
	}
	if ((botskin > 0.528) && (botskin <= 0.594))
	{
		return (8);
	}
	if ((botskin > 0.594) && (botskin <= 0.660))
	{
		return (9);
	}
	if ((botskin > 0.660) && (botskin <= 0.726))
	{
		return (10);
	}
	if ((botskin > 0.726) && (botskin <= 0.792))
	{
		return (11);
	}
	if ((botskin > 0.792) && (botskin <= 0.858))
	{
		return(12);
	}
	if ((botskin > 0.858) && (botskin <= 0.924))
	{
		return (13);
	}
	if ((botskin > 0.924) && (botskin <= 1))
	{
		return(15);
	}
	else
	{
		return(15);
	}
};


//	*bot skin code - not sure to include - requiers parm mod

void() bot_skinParms =
{
	if (SKINSMODE)
	{
		parm4 = ((parm4 + (self.skin * 512)) + (16384* SKINSMODE));
	}
};

//encode bot details for level change

void() bot_changeParms =
{
	local float offset, toffset, team1;
	local float nb, nt;
	local entity e;

	e = find(world,classname,"pk*bot");
	offset = toffset = 1;
	parm12 = parm13 = 0; // tuned for painkeep merge
	team1 = 100;
	nb = nt = 0;
	while (e)
	{
		if (e.team == 99)
		{
			nb = (nb + 1);
			if (nb < 6)
			{
				parm12 = (parm12 + (((offset * e.skil) * 10) & (offset * 31)));
				offset = (offset * 32);
			}
		}
		else
		{
			if (team1 == 100)
			{
				team1 = e.team;
			}
			if (e.team == team1)
			{
				nt = (nt + 1);
				if (nt < 6)
				{
				parm13 = (parm13 + (((toffset * e.skil) * 10) & (toffset * 31)));
					toffset = (toffset * 32);
				}
			}
		}
		e = find (e,classname,"pk*bot");
	}
};

void() bot_skinDecode =
{
	local float skinno;

	if (parm4 > 511)
	{
		SKINSMODE = ((parm4 & 49152) / 16384);
		skinno = (parm4 & 7680);
		parm4 = (parm4 & 511);
		skinChange (self,skinno);
	}
};

// deprecated into below
/*
void() set_CarriedPath =
{
	if (self.movetarget == world)
	{
		NewCarriedPath ();
	}
	setorigin (self.movetarget,self.origin);
	self.movetarget.movetarget = world;
	self.pathtype = NEVERTARGET;
	if (!self.pather)
	{
		NUMPATHERS = (NUMPATHERS + 1);
	}
	self.pather = 1;

// other init code
	self.th_cache = cacheenemy;

};
*/

void() set_initBotLevel =
{
	local float dedflags;

  	dedflags = cvar ("temp2");
	if (dedflags & DEDICATED)
	{
		serverflags = (dedflags | INITLEVEL);
		cvar_set ("temp2","0");
	}
	if (serverflags & INITLEVEL)
	{
		initBotLevel ();
	}

// from prev fn() - set_CarriedPath
	if (self.movetarget == world)
	{
		NewCarriedPath ();
	}
	setorigin (self.movetarget,self.origin);
	self.movetarget.movetarget = world;
	self.pathtype = NEVERTARGET;
	if (!self.pather)
	{
		NUMPATHERS = (NUMPATHERS + 1);
	}
	self.pather = 1;

// other init code
	self.th_cache = cacheenemy;
};

// client connect / disconnect handle for *bots

void(float con) bot_con =
{
// connection
	if (con)
	{
		self.id = FindGood ();
		self.impulse = 204; // printinit
		randombotskin = getrandombotskin ();
		initscore ();
	}
	else // disconnect
	{
		MakeGood (self.id);
		self.classname = "nobody";
	}
};

// count bot kills & deaths for scoreboard - extract from ClientObituary, called after ClientObit divert

void(entity targ, entity attacker) bot_kill =
{
	local entity e, f;

	e = f = world;
	if (targ.classname == "pk*bot")
	{
		e = targ;
		e.classname = "player"; // you can fool some of the code...
	}
	if (attacker.classname == "pk*bot")
	{
		f = attacker;
		f.classname = "player";
	}

	if (PK) PK_ClientObituary(targ, damage_inflictor, attacker); // *pk - pk death handler
	else
	ClientObituary(targ, attacker);

	if (e) e.classname = "pk*bot";
	if (f) f.classname = "pk*bot";

	if ((targ.classname == "player") || (targ.classname == "pk*bot"))
	{
		if (attacker.classname == "teledeath")
		{
//			attacker.owner.frags = attacker.owner.frags + 1;
			if (attacker.owner.classname == "pk*bot")
			{
				TELEFRAGFLAG = 1;
			}
			countkill (attacker.owner,targ);
			if (attacker.owner.classname == "pk*bot")
			{
				WriteByte (MSG_ALL,MSG_UPDATEFRAGS);
				WriteByte (MSG_ALL,attacker.owner.id);
				WriteShort (MSG_ALL,attacker.owner.frags);
			}
			return;
		}

		if (attacker.classname == "teledeath2")
		{
//			targ.frags = targ.frags - 1;
			countkill (targ,targ);
			if (targ.classname == "pk*bot")
			{
				WriteByte (MSG_ALL,MSG_UPDATEFRAGS);
				WriteByte (MSG_ALL,targ.id);
				WriteShort (MSG_ALL,targ.frags);
			}
			return;
		}

		if ((attacker.classname == "player") || (attacker.classname == "pk*bot"))
		{
			if (targ == attacker)
			{
				// killed self
//				attacker.frags = attacker.frags - 1;
				if (attacker.classname == "pk*bot")
				{
					WriteByte (MSG_ALL,MSG_UPDATEFRAGS);
					WriteByte (MSG_ALL,attacker.id);
					WriteShort (MSG_ALL,attacker.frags);
				}
				countkill (attacker,attacker);
			
				return;
			}
			else if ((teamplay == 2) && (targ.team > 0)&&(targ.team == attacker.team))
			{
//				attacker.frags = attacker.frags - 1;
				return;
			}
			else
			{
//				attacker.frags = attacker.frags + 1;
				if (attacker.classname == "pk*bot")
				{
					WriteByte (MSG_ALL,MSG_UPDATEFRAGS);
					WriteByte (MSG_ALL,attacker.id);
					WriteShort (MSG_ALL,attacker.frags);
				}
				countkill (attacker,targ);
			}
			return;
		}
		else
		{
//			targ.frags = targ.frags - 1;
			countkill (targ,targ);
		}
	}
};

/*
 * Cataboligne
 *
 * only print & stuffcmd to real players - frikbot code borrow - noted to protect against sz_ overflows because bots dont retrieve the messages
 *
 */

// inactive while installed with frikbot code, which was adapted to work the same & noted *bot
// TDO: adapt frikbot ishuman test
/*
void(entity client, string s)	bot_stuffcmd = #21;
void(entity client, string s)	bot_sprint = #24;
void(entity client, string s)	bot_centerprint = #73;

void(entity	client, string s) stuffcmd =
{
	if (client.classname == "pk*bot") return;
//	if (client.ishuman == 1)
		bot_stuffcmd(client, s);
};

void(entity	client, string s) sprint =
{
	if (client.classname == "pk*bot") return;
//	if (client.ishuman == 1)
		bot_sprint(client, s);
};
void(entity	client, string s) centerprint =
{
	if (client.classname == "pk*bot") return;
//	if (client.ishuman == 1)
		bot_centerprint(client, s);
};
*/

// bot touch - do bot stuff for some items - removed touch hooks

void() bot_touch =
{
	local entity e;

	e = world;

	if (self.state == CACHE_ROUTE_TOUCH || self.state == BOT_TOUCHED_CACHE_ROUTE_TOUCH)
	{
		if (other.movetarget.movetarget){
			cacheRoute (other.movetarget,other.movetarget.movetarget,0,self);
if (0) {
bprint("hi, code base here, ran bot cacheRoute for item ( ");
bprint(self.classname);
bprint(" , ");
bprint(self.netname);
bprint(" )\n");}
}
	}

// NOTE: original code has bot call this after collecting item - this is slightly different as it calls it no matter what
// also, the original code seems kind of borked in its intent - the announce goes out and >poof< the item is gone!
	if (other.classname == "pk*bot")
	{
		if (self.state == BOT_TOUCHED || self.state == BOT_TOUCHED_CACHE_ROUTE_TOUCH)
		{
if (0) {
bprint("hi, code base here, ran bot_toucheditem for item ( ");
bprint(self.classname);
bprint(" , ");
bprint(self.netname);
bprint(" )\n");}
			bot_toucheditem ();
		}
		e = other;
		e.classname = "player";
	}
//	self.bot_item_touch();
	self.pk_touch();
	if (e)
	{
		if (e.think == player_run) e.think = e.th_run;
		if (e.think == player_stand1) e.think = e.th_stand;
		e.classname = "pk*bot";
if (0) {
bprint("hi, code base here, bot touched item ( ");
bprint(self.classname);
bprint(" , ");
bprint(self.netname);
if (self.solid == SOLID_NOT) bprint(") and collected it.\n");
else bprint(" )\n");}
	}
};

// backpack setup special 
void(entity e) bot_BackpackSetup =
{
//	e.bot_item_touch = e.touch;
	e.pk_touch = e.touch;
	e.touch = bot_touch;
	e.classname = "Backpack"; // *bot backpack code follows
	e.th_weight = backpackweight;
	e.state = BOT_TOUCHED;
	if (PK) e.touch = painkeep_touch; // *pk
}

// remove item hooks & put here - code diverts here from PlaceItem

void(entity e) bot_item_linx =
{
if (e.state)
{
bprint("hi, code base here with a dev note, this is odd: bot item ( ");
bprint(e.classname);
bprint(" , ");
bprint(e.netname);
bprint(" ) - already has .state set?\n");
}

// clear state for cacheRoute calls
	e.state = 0;
// set bot item master touch
	if (!PK)
	{
//		e.bot_item_touch = e.touch;
		e.pk_touch = e.touch;
		e.touch = bot_touch;
	}
// health items
	if (e.classname == "item_health") // || e.model == "maps/b_bh10.bsp" / "maps/b_bh25.bsp / maps/b_bh100.bsp
	{
//bprint("in bot item health\n");
		e.state = BOT_TOUCHED;
		e.th_weight = healthweight;
		if (e.healtype == 2) // || e.model == "maps/b_bh100.bsp"
		{
			e.th_cache = cachepowerup;
			e.th_update = updatepowerup;	
			e.state = BOT_TOUCHED_CACHE_ROUTE_TOUCH;
		}
		return;
	}

// armor
	if (e.model == "progs/armor.mdl") // IDEA: how to catch armor if model can change?
	{
//bprint("in bot item armor\n");
		e.th_weight = armorweight;
		e.th_cache = cachearmor;
		e.th_update = updatearmor;
		e.state = BOT_TOUCHED_CACHE_ROUTE_TOUCH;
		return;
	}

// weapons
	if (e.classname == "weapon_supershotgun")
	{
		e.th_weight = ssgweight;
	}
	else if (e.classname == "weapon_nailgun")
	{
		e.th_weight = nailgunweight;
	}
	else if (e.classname == "weapon_supernailgun")
	{
		e.th_weight = supernailweight;
		e.th_cache = cachenail;
		e.th_update = updatenail;
		e.state = CACHE_ROUTE_TOUCH;
	}
	else if (e.classname == "weapon_grenadelauncher")
	{
		e.th_weight = glauncherweight;
		e.th_cache = cachegrenade;
		e.th_update = updategrenade;
		e.state = CACHE_ROUTE_TOUCH;
	}
	else if (e.classname == "weapon_rocketlauncher")
	{
		e.th_weight = rlauncherweight;
		e.th_cache = cacherocket;
		e.th_update = updaterocket;
		e.state = CACHE_ROUTE_TOUCH;
	}
	else if (e.classname == "weapon_lightning")
	{
		e.th_weight = lightningweight;
		e.th_cache = cachelightning;
		e.th_update = updatelightning;
		e.state = CACHE_ROUTE_TOUCH;
	}
	if (e.touch == weapon_touch || e.pk_touch == weapon_touch) return;

// ammo
	if (e.classname == "item_shells")
	{
		e.th_weight = shellweight;
	}
	else if (e.classname == "item_spikes")
	{
		e.th_weight = nailweight;
	}
	else if (e.classname == "item_rockets")
	{
		e.th_weight = rocketweight;
	}
	else if (e.classname == "item_cells")
	{
		e.th_weight = cellweight;
	}
	if (e.touch == ammo_touch || e.pk_touch == ammo_touch)
	{
		e.state = BOT_TOUCHED;
		return;
	}

// artifacts
	if (e.touch == powerup_touch || e.pk_touch == powerup_touch)
	{
//bprint("in bot item powerup\n");
		e.th_weight = artifactweight;
		if (e.classname != "item_artifact_envirosuit")
		{
			e.th_weight = artifactweight;
			e.th_cache = cachepowerup;
			e.th_update = updatepowerup;
			e.state = CACHE_ROUTE_TOUCH;
		}
		return;
	}

// any painkeep item - seems coder didnt program bot for these
	if (e.pk_items || e.pk_currentitem || e.netname == "Exploding Shells") // yuk :(~
	{
//bprint("in bot item PK\n");
	e.th_weight = dont_weight;
	return;
	}

bprint("hi, code base here, this is odd: bot item ( ");
bprint(e.classname);
bprint(" , ");
bprint(e.netname);
bprint(" ) - fell through tests!\n");

/* deprecated for easy code above
	if (e.classname == "item_artifact_super_damage")
	{
		e.th_weight = artifactweight;
		e.th_cache = cachepowerup;
		e.th_update = updatepowerup;
	}
	else if (e.classname == "item_artifact_invulnerability")
	{
		e.th_weight = artifactweight;
		e.th_cache = cachepowerup;
		e.th_update = updatepowerup;
	}
	else if (e.classname == "item_artifact_invisibility")
	{
		e.th_weight = artifactweight;
		e.th_cache = cachepowerup;
		e.th_update = updatepowerup;
	}
	else if (e.classname == "item_artifact_envirosuit")
	{
		e.th_weight = artifactweight;
	}
	if (e.touch == powerup_touch || e.pk_touch == powerup_touch) return;
*/


//	else if (e.classname == "")
//	{
//
//	}
};
