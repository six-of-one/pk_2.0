/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: botimp.qc
 *
 * date: Fri Apr  4 04:40:01 UTC 2008
 *
 * final qc
 *
 */


void (entity e, float newskin) skinChange =
{
	local entity b;
	if (!SKINSMODE)
	{
		e.skin = 0;
		return ;
	}
	if (newskin < 0)
	{
		newskin = 15;
	}
	if (newskin > 15)
	{
		newskin = 0;
	}
	e.skin = newskin;
	if (teamplay)
	if (e.classname == "player")
	{
		b = find (world,classname,"pk*bot");
		while (b)
		{
			if (b.team == e.team)
			{
				b.skin = e.skin;
			}
			b = find (b,classname,"pk*bot");
		}
	}
};

void () removeSkins =
{
	local entity e;
	SKINSMODE = 0;
	e = find (world,classname,"player");
	while (e)
	{
		e.skin = 0;
		e = find (e,classname,"player");
	}
	e = find (world,classname,"pk*bot");
	while (e)
	{
		e.skin = 0;
		e = find (e,classname,"pk*bot");
	}
};

void () setSkinsMode =
{
	if (SKINSMODE == 2)
	{
		removeSkins ();
		bprint ("Skins mode turned off\n");
		return ;
	}
	SKINSMODE = (SKINSMODE + 1);
	if (SKINSMODE == 1)
	{
		bprint ("Skins mode activated\n");
	}
	else
	{
		bprint ("Skill-based skins mode activated\n");
	}
};

void () observer_off;

void() end_observer =
{
	bprint(self.enemy.netname);
	bprint (", observer time ran out\n");
	self.nextthink = time + 1;
	self.think = SUB_Remove;
	self = self.enemy;
	observer_off();
};

// Cataboligne - 8.16.9 - observer fix - move fast while flying - using cam_deathmove

// FIX - do something with body so it doesnt just "vanish", maybe a trance, or kibble it down or some such

void () observer =
{
	local entity e;

	if (!self.admin)
	{
		if (! serverflags & FL_OBSERVER) // restricted, only admins can observe
			return;
		if (observer_time) // can only observe for this long
		{
			e = spawn();
			e.nextthink = time + observer_time;
			e.think = end_observer;
			e.enemy = self;
		}
	}
	cam_startdeathview(); // get a cam ent
	set_viewport(self, self); // dont really need death view
	setmodel(self, "progs/null.mdl");
	setsize (self,'-4 -4 -4', ' 4 4 4'); // dont look in floors / walls
	self.movetype = MOVETYPE_FLY;
	self.health = self.view_ofs_z = 1;
	self.aiment.oldorigin = self.origin;
	self.aiment.think = cam_deathmove; // straight to death move, do not collect $200
	self.classname = OBSERVER;
	self.owner.frags = 0; // woo - lose score?
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	centerprint (self,"Observer mode activated\nPress \bFIRE\b to exit and respawn\n");
	self.wad = "\nObserver mode activated\nPress \bFIRE\b to exit and respawn\n";
};

void () observer_off =
{
	self.classname = "player";
	respawn ();
	bprint ("Observer mode turned off\n");
};

void () setobserverMode =
{
	if (self.classname == OBSERVER)
	{
		observer_off ();
		return ;
	}
	observer ();
};

void () setVerboseMode =
{
	VERBOSEBOT = !VERBOSEBOT;
};

void () setNamingMode =
{
	NAMEBOTS = !NAMEBOTS;
};

void () botControl =
{
	local string tmp;
	if (self.impulse == 202)
	{
		setSkinsMode ();
	}
	else if (self.impulse == 205)
	{
		AddAnotherBot(-1);
	}
	else if ((self.impulse > 99) && (self.impulse < 116))
	{
		if (teamplay)
		{
			SetTeamBots (self.impulse - 100);
		}
		else
		{
			SetMaxBots (self.impulse - 100);
		}
	}
	else if (self.impulse == 208)
	{
		AddAnotherBot(-1);
		AddAnotherBot(-1);
		AddAnotherBot(-1);
		AddAnotherBot(-1);
	}
	else if (self.impulse == 211)
	{
		removeAllBots();
	}
	else if (self.impulse == 214)
	{
		setBotGravity();
	}
	else if (self.impulse == 215)
	{
		setVerboseMode();
	}
	else if (self.impulse == 217)
	{
		tmp = ftos (NUMPATHS);
		dprint (tmp);
		dprint (" botpaths placed\n");

		tmp = ftos (NUMPATHERS);
		dprint (tmp);
		dprint (" botpathers\n");

		tmp = ftos (NUMBOTS);
		dprint (tmp);
		dprint (" active bots\n");

		tmp = ftos (serverflags);
		dprint (tmp);
		dprint (" server flags\n");
	}
	else if (self.impulse == 218)
	{
		serverflags = serverflags - (serverflags & UNRESTRICTED);
		bprint ("Unrestricted mode cleared\n");
	}
};

void () botImpulseCommand =
{
	if (self.impulse == 200)
	{
		skinChange (self,(self.skin + 1));
	}
	else if (self.impulse == 201)
	{
		skinChange (self,(self.skin - 1));
	}
	else if (self.impulse == 204)
	{
		if (!PK) printIntro ();
	}
	else if (self.impulse == 212)
	{
		setobserverMode ();
	}
	else if (self.impulse == 221)
	{
		UpdateTeamColors ();
	}
	else if (self.admin || (serverflags & UNRESTRICTED))
		botControl();
};

