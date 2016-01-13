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

void () NoPeeper;

void() end_observer =
{
	bprint(self.enemy.netname);
	bprint (", observer time ran out\n");
	self.nextthink = time + 1;
	self.think = SUB_Remove;
	self = self.enemy;
	NoPeeper();
};

void () Peeper =
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
	self.classname = "peeper";
	self.frame = 0;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_FLY;
	self.takedamage = DAMAGE_NO;
	self.frags = 0;
	self.weaponmodel = "";
	setmodel (self,string_null);
	setsize (self, ' 0 0 0', ' 0 0 0');
	bprint ("Observer mode activated\n");
};

void () NoPeeper =
{
	self.classname = "player";
	respawn ();
	bprint ("Observer mode turned off\n");
};

void () setPeeperMode =
{
	if (self.classname == "peeper")
	{
		NoPeeper ();
		return ;
	}
	Peeper ();
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
		AddAnotherBot ();
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
		AddAnotherBot ();
		AddAnotherBot ();
		AddAnotherBot ();
		AddAnotherBot ();
	}
	else if (self.impulse == 211)
	{
		removeAllBots ();
	}
	else if (self.impulse == 214)
	{
		setBotGravity ();
	}
	else if (self.impulse == 215)
	{
		setVerboseMode ();
	}
	else if (self.impulse == 217)
	{
		tmp = ftos (NUMPATHS);
		dprint (tmp);
		dprint (" botpaths placed\n");
	}
	else if (self.impulse == 117)
	{
		tmp = ftos (NUMPATHERS);
		dprint (tmp);
		dprint (" botpathers\n");
	}
	else if (self.impulse == 118)
	{
		tmp = ftos (NUMBOTS);
		dprint (tmp);
		dprint (" active bots\n");
	}
	else if (self.impulse == 119)
	{
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
		printIntro ();
	}
	else if (self.impulse == 212)
	{
		setPeeperMode ();
	}
	else if (self.impulse == 210)
	{
		PrintScores (MYSCORE);
	}
	else if (self.impulse == 220)
	{
		PrintScores (NORMALSCORE);
	}
	else if (self.impulse == 222)
	{
		PrintTopScores (0);
	}
	else if (self.impulse == 221)
	{
		UpdateTeamColors ();
	}
//	else if (self.impulse == 223)
//	{
//		self.items = (self.items | IT_INVULNERABILITY);
//		self.invincible_finished = (time + 30);
//	}
	else if (self.admin || (serverflags & UNRESTRICTED))
		botControl();
};

