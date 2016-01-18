/*
		+---------------------------------------+
		|  Chaos code                           | SEC-HEAD
		+---------------------------------------+
*/

// implement chaos fn for pk


// fn(cnt_ent) - count all such ents on level, make chain if head ent provided

// hent - head entity for chain struct
// match - find on this field
// srch - search for this

// RETURN - count of ents matching search parm

float(entity hent, string match, string srch) cnt_ent =
{
	local float rc;
	local entity sr, ch;

	sr = world;
	if (match == "classname") sr = find (world, classname, srch);
//	else if (match == "class_select") sr = find (world, class_select, srch);
//	else if (match == "quakeset") sr = find (world, quakeset, srch);
	else if (match == "netname") sr = find (world, netname, srch);
//	else if (match == "scode") sr = find (world, scode, srch);
	ch = hent;

	rc = 0;
	while (sr)
		{
			rc = rc + 1;
			if (hent)
			{
				ch.chain = sr;
				ch = sr;
			}
			if (match == "classname") sr = find (sr, classname, srch);
//			else if (match == "class_select") sr = find (sr, class_select, srch);
//			else if (match == "quakeset") sr = find (sr, quakeset, srch);
			else if (match == "netname") sr = find (sr, netname, srch);
//			else if (match == "scode") sr = find (sr, scode, srch);
		}
	if (hent) ch.chain = world; // remove other potential chains left around - not even sure if this can happen
	return(rc);
}

void() func_model_frames =
{
	self.frame = self.frame + 1;
	if (self.frame > self.state) self.frame = self.count;
	self.nextthink = time + self.delay;
};

// used for various effects (8 ray star & visage level decor)

void() func_model =
{
	self.mdl = self.model;
	precache_model (self.mdl);
	setmodel (self,self.mdl);

	self.frame = self.count;
	if (self.state)
	{
	if (self.delay <= 0) self.delay = 0.1;
	self.think = func_model_frames;
	self.nextthink = time + self.delay;
	}
};


// fn(notmod) - test to see of entity should be in mod - if not, remove
// also test dp/c

/*
	affects (thus far)

	doors

*/

float(entity e) notmod =
{


// TESTING
	if (cvar("saved1") == 17) return(FALSE); // allow test



	if (e.wad == "!mod" || e.netname == "!mod")
	{
		remove(e);
		return(TRUE);
	}

	if (DARKPLACES || chaos)
	if (e.wad == "!dpc" || e.netname == "!dpc") // cant have it
	{
		remove(e);
		return(TRUE);
	}

	if (!DARKPLACES && !chaos)
	if (e.wad == "dpc" || e.netname == "dpc") // required by
	{
		remove(e);
		return(TRUE);
	}

	if (DARKPLACES)
	if (e.wad == "!dp" || e.netname == "!dp")
	{
		remove(e);
		return(TRUE);
	}

	if (!DARKPLACES)
	if (e.wad == "dp" || e.netname == "dp")
	{
		remove(e);
		return(TRUE);
	}

	if (chaos)
	if (e.wad == "!chaos" || e.netname == "!chaos")
	{
		remove(e);
		return(TRUE);
	}

	if (!chaos)
	if (e.wad == "chaos" || e.netname == "chaos")
	{
		remove(e);
		return(TRUE);
	}

	return(FALSE);
};

void () func_illusionary;

// mod only func_illusionary - doesnt appear if mod not running
// - further check of notmod specific code

void () m_func_illusionary =
{
	if (notmod(self)) return;

	func_illusionary();
};

// return a random bit from a mask

float(float msk) rnd_bit_mask =
{
	float f, sf, mm, b;

	if (msk < 1) return(0); // no other possibilities
	if (msk == 1) return(1);

	b = mm = 0;
	f = 1;
	if (f & msk) b = f;
	while (msk > f && mm < 23) // max out rnd selector
	{
		mm = mm + 1;
		f = AdminBitFlag(mm);
		if (!b)
		if (f & msk) b = f;
	}

	f = 0;
	sf = 100;
	while (f == 0 && sf > 0)
	{
		f = AdminBitFlag(random() * mm);
		if (! (f & msk)) f = 0;
		sf = sf - 1;
	}
	if (!f) // damn - didnt get one? - take first bit then
		f = b;
	return(f);
};


// make a bolt between 2 points, play sound at origin vec v1 if passed in snd

// "weapons/lstart.wav"

void(vector v1, vector v2, float typ, string snd) lightning_bolt =
{
	local entity e;
	local float te;

	e = spawn();
	e.think = SUB_Remove;
	e.nextthink = time + 0.5;
	te = typ;
	if (!te) te = TE_LIGHTNING2;
	
	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, te);
	WriteEntity (MSG_BROADCAST, e);
	WriteCoord (MSG_BROADCAST, v1_x);
	WriteCoord (MSG_BROADCAST, v1_y);
	WriteCoord (MSG_BROADCAST, v1_z);
	WriteCoord (MSG_BROADCAST, v2_x);
	WriteCoord (MSG_BROADCAST, v2_y);
	WriteCoord (MSG_BROADCAST, v2_z);

	if (snd)
	{
		e.origin = v1;
		sound (e, CHAN_WEAPON, snd, 1, ATTN_NORM);
//		e.orign = v2;
//		sound (e, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
	}
};


float() crandom;

void() th_arcarn =
{
	local float f;
	local vector v1;

	self.nextthink = time + self.wait + self.cnt * random();

	if (self.alpha == 0)
	{
		v1_x = self.distance * random();
		v1_y = self.distance * random();
		if (self.lip)
		if (random() < self.lip)
			v1_z = self.oldorigin_z + crandom() * self.height;

		setorigin(self, self.oldorigin + v1);
		setmodel(self, self.mdl);
		self.nextthink = time + 0.1 + 0.2 * random();
		self.aflag = 0.1;
	}
	if (self.alpha < 1)
	{
		self.alpha = self.alpha + self.aflag;
		self.nextthink = time + 0.1 + 0.2 * random();

		if (self.alpha > 0.6 && self.aflag == 0.1)
		{
			self.solid = SOLID_BSP;
			if (self.flags)
			if (random() < 0.33)
			{
				self.effects = rnd_bit_mask(self.flags);
			}
		}
		else if (self.alpha < 0.6 && self.aflag == -0.1)
		{
			self.solid = SOLID_NOT;
			self.effects = 0;
		}

		if (self.alpha > 1)
		{
			self.nextthink = time + self.delay + self.count * random();
			if (random() < self.style) 
				self.nextthink = time + (self.delay / 0.6) + (self.count / 0.5) * random();
			self.alpha = 1;
		}
		else if (self.alpha < 0.05)
		{
			f = 0;
			if (self.lefty)
			if (random() < 0.1)
				f = self.lefty;
			self.nextthink = time + self.wait + self.cnt * random() + f;
			self.alpha = 0;
			self.model = "";
			self.solid = 0;
		}
	}
	else
	{
		self.nextthink = time + 0.1 + 0.2 * random();
		self.aflag = -0.1;		
		self.alpha = self.alpha + self.aflag;
	}
	
};

// func_arcarn - archon arena blocks

// mdl = model to use
// following all have defaults (*)
// distance (64) - randomizing dist around center
// height (32) - possible height randomizer
// lip (0.25) - chance of variable height

// wait (20) - time to appear
// cnt (30) - randomizer on appear time
// lefty (rnd) - start time pause, random pauses

// delay (30) - time to hang
// count (40) - randomizer on hang time
// style (0) - chance of very short hangs

// flags (12) - bit map of allowed effects - EF_*

void() func_arcarn =
{
	local float f;

	if (!DARKPLACES)
	{
		precache_model("maps/aarn1.bsp");
		precache_model("maps/aarn2.bsp");
		precache_model("maps/aarn3.bsp");
	}

	f = random();
	if (self.mdl == "")
	if (f < 0.33)
		self.mdl = "maps/aarn1.bsp";
	else if (f < 0.66)
		self.mdl = "maps/aarn2.bsp";
	else
		self.mdl = "maps/aarn3.bsp";

	if (self.wait < 1) self.wait = 20; // appear time
	if (self.cnt < 1) self.cnt = 30;
	if (random() < 0.2)
	{
		f = random();
		if (f < 0.25) self.lefty = 30;
		else if (f < 0.5) self.lefty = 60;
		else if (f < 0.6) self.lefty = 80;
	}

	if (self.delay < 1) self.delay = 30; // hang time
	if (self.count < 1) self.count = 40;

	self.think = th_arcarn;
	self.nextthink = time + self.wait + self.cnt * random() + self.lefty;

	if (self.lefty) // small chance of fast starts - TDO: .var
	if (random() < 0.1)
		self.nextthink = time + self.wait * random();

	self.oldorigin = self.origin;
	if (self.distance < 1) self.distance = 64;
	if (self.height< 1) self.height = 32;
	if (!self.lip) self.lip = 0.24;

	self.alpha = 0;
	if (self.flags < 1) self.flags = 12;
};

// fn(func_saver) - save player from a fall
// fn(mk_saver) - setup saver
// fn(th_saver) - think runs saver
// fn(lt_saver) - extra bolts

void() lt_saver =
{
	lightning_bolt( self.origin,  self.enemy.origin, 0, "");
	self.delay = self.delay - 1;
	if (self.delay) self.nextthink = time + 0.3;
	else remove(self);
};

// stop player fall in targeting trigger and wait a few secs for them to FIRE to avoid fall

entity() PK_SelectSpawnPoint;
void(entity spot) ClearSpawnPoint;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;

void() th_saver =
{
	local string c3, c4, c5, c6;
	local entity spot;

	c3 = c4 = c5 = c6 = "";

	if (self.button0) // player accepted save - it costs .frags
	{
		self.aiment.frags = self.aiment.frags - self.frags;

// try a target first (hopefully a teleporter dest)
		if (self.target)
		{
			spot = find(world, targetname, self.target);
		}

// if no target, teleport player to a random spawn
		if (!spot)
		{
			spot = PK_SelectSpawnPoint (); // *pk - get a spawn point, pk style 
			ClearSpawnPoint(spot); // *pk
		}

		self.aiment.origin = spot.origin + '0 0 1';
		self.aiment.angles = spot.angles;
		self.aiment.fixangle = TRUE;		// turn this way immediately
		if (deathmatch || coop)
		{
			makevectors (self.aiment.angles);
			spawn_tfog (self.aiment.origin + v_forward*20);
		}

		spawn_tdeath (self.aiment.origin,self.aiment);

	}
	if (self.delay < 1 || self.button0)
	{
		centerprint(self.aiment, "");
		self.aiment.movetype = self.lefty;
		self.aiment.aiment = world;
		remove(self);
		return;
	}
	
	c3 = "You have ( ";
	c4 = " ) seconds to press FIRE\nThe cost = ";
	c5 = ftos(self.delay);
	c6 = ftos(self.frags);

	centerprint7(self.aiment, self.message, c3, c5, c4, c6, " frags\n", self.noise4);

	self.nextthink = time + 1;

	if (!self.aiment.ishuman) // NOTE: later exclude non score bots
	if (self.aiment.movetype != MOVETYPE_NONE)
	if (random() < 0.5) // 50 / 50 chance a bot will decide to save
	{
		self.button0 = TRUE;
		self.nextthink = time + 1 + 3 * random(); // fake consider time for bot
	}

	self.delay = self.delay - 1;
	self.aiment.movetype = MOVETYPE_NONE;

// fire a "catch" bolt (or something) - NOTE: make it "jagged"

	lightning_bolt( self.origin,  self.aiment.origin, 0, "weapons/lstart.wav");
	spot = spawn();
	spot.origin = self.origin;
	spot.aiment = self.aiment;
	spot.think = lt_saver;
	spot.nextthink = time + 0.3;
	spot.delay = 3;
	
};

void() mk_saver =
{
	local entity e;

	e = spawn();
	if (!e) return;

	e.origin = self.origin; //activator.origin;
	e.aiment = activator;
	e.classname = "saver";
	activator.aiment = e;

	e.message = self.message;
	e.noise4 = self.noise4;
	e.target = self.target;

	if (self.delay) e.delay = self.delay;
	else e.delay = 5;
	if (self.frags) e.frags = self.frags;
	else e.frags = 1;
	e.lefty = activator.movetype;
	e.button0 = FALSE;

	e.think = th_saver;
	e.nextthink = time + 0.1;
};

void() func_saver =
{
	self.use = mk_saver;
};
