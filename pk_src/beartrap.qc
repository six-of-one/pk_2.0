/* beartrap */

float PK_BT_TIMETOFOLLOW = 15;
float PK_BT_DMG = 2;
float PK_BT_TIME;


.entity beartrap_target;
.float beartrapdmg_time;
.float dodmg;

void(string gibname, float dm) beartrap_throwGib =
{
	local	entity new;

	new = spawn();
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.pk_currentitem = PK_IT_BEARTRAP;
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random() * 600;
	new.avelocity_y = random() * 600;
	new.avelocity_z = random() * 600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 3 + random() * 3;
	new.frame = 0;
	new.flags = 0;
	new.classname = "beartrap_gib";
	new.owner = self.owner;
	new.think = SUB_Remove;

	// PAINKEEP SPLASH Make this entity splash
	AddToSplash(new);
};

// Remove the beartrap from play
void() beartrapDie =
{
	local float numOfGibs;

	beartrap_throwGib("progs/beargib1.mdl", -50);
	beartrap_throwGib("progs/beargib2.mdl", -50);
	beartrap_throwGib("progs/beargib3.mdl", -50);

	numOfGibs = random() * 5;

	local float dam;

	while(numOfGibs > 0)
	{
	  dam = random() * -50;
	  beartrap_throwGib("progs/beargib4.mdl", dam);
	  numOfGibs = numOfGibs - 1;
	}

	sound(self, CHAN_AUTO, "weapons/btrap/btrap_3.wav", 1, ATTN_NORM);

	remove(self);
};

$frame bear01 bear02 bear03

// Follow the trapped person around and damage them
void() beartrapFollow =
{
	// SWP: 14/05/97 - check if the player has "respawned" or dead.
	if (!(self.beartrap_target.beartrap_time) || self.disconnectPlayer || self.beartrap_target.deadflag || self.beartrap_target.health < 0) // Cataboligne - 5.20.10 - beartrap single player code - targeting monsters
	{ // player is dead or respawned...
//		remove(self);
		beartrapDie(); // die when done instead of dissapearing
		return;
	}

	if (self.origin != self.beartrap_target.origin || self.angles != self.owner.angles)
	{
		setorigin(self, self.beartrap_target.origin);
		self.dodmg = TRUE;
		if (self.angles != self.owner.angles)
			self.angles = self.owner.angles;
	}

	self.beartrap_time = self.beartrap_time + 0.1;
	self.beartrapdmg_time = self.beartrapdmg_time + 0.1;

	// Inflict damage every second if the target has moved
	if (self.beartrapdmg_time >= 0.5)
	{
		if (self.dodmg)
		{
			T_Damage(self.beartrap_target, self, self.owner, PK_BT_DMG);
			self.dodmg = FALSE;
		}

		self.beartrapdmg_time = 0;
	}

	if (self.beartrap_time > PK_BT_TIMETOFOLLOW)
	  self.think = beartrapDie;
};

void() btf =
{
	beartrapFollow();

	self.nextthink = time + 0.1;
};

/*
void()	btf_1 =	[$bear01, btf_2 ] {beartrapFollow();};
void()	btf_2 =	[$bear02, btf_3 ] {beartrapFollow();};
void()	btf_3 =	[$bear03, btf ] {setmodel (self, "progs/bearbld.mdl");};
*/

void()	btf_1 =	[$bear02, btf_2 ] {beartrapFollow();};
void()	btf_2 =	[$bear03, btf ] {setmodel (self, "progs/bearbld.mdl");};

void() beartrapTouch =
{

	if (!deathmatch) // Cataboligne - 5.20.10 - beartrap single player code - turn off player target, allow monster target
	{
		if (other.classname == "player")
		{
			if (cvar("sv_sp_bt_noplayer")) return;
		}
		else if (! (other.flags & FL_MONSTER)) return;
	}
	else
	if (other.classname != "pk*bot") // *bot - bots get bit
	if (other.classname != "player")
	  return;

	// The owner of the beartrap is immune for a few secs
	if ((other == self.owner) && (self.beartrap_time > time))
		return;

	// People are immue to the bt a few secs after teleporting/spawning
	if (other.bt_immune_time > time)
	  return;

	other.beartrap_time = 1; // SWP: 14/05/97
	self.beartrap_target = other;
	self.beartrap_time = 0;
	self.beartrapdmg_time = 0;
	//self.think = beartrapFollow;
	self.think = btf_1;
	self.nextthink = time + 0.1;
	self.touch = SUB_Null;

	sound(self, CHAN_AUTO, "weapons/btrap/btrap_1.wav", 1, ATTN_NORM);
};



void() beartrap_dropBearTrap =
{
	local entity bt;

	if (self.pk_beartrapammo <= 0)
		return;

	if (!self.button0)
	{
		player_run ();
	  return;
	}

	PK_BT_TIME = 90; // def

	if (DARKPLACES || chaos)
	{
		PK_BT_TIME = cvar("pk_bt_time");
	}

	bt = spawn();
	bt.owner = self;
	bt.movetype = MOVETYPE_TOSS;
	bt.solid = SOLID_TRIGGER;
	bt.classname = "beartrap";
	bt.takedamage = TRUE;
	bt.health = 50;
	bt.th_die = beartrapDie;
	bt.netname = "Bear Trap";

	// For the correct death messages
	bt.pk_currentitem = PK_IT_BEARTRAP;
	bt.weapon = IT_AXE;

	// Used to give a few seconds go get away from the trap
	bt.beartrap_time = time + 3;

	// Kill it after 90 secs if nobody walks over it
	bt.think = beartrapDie;
	bt.nextthink = time + PK_BT_TIME;

	setmodel (bt, "progs/beartrap.mdl");
	setsize (bt, '-25 -24 -0', '25 25 8');

	setorigin (bt, self.origin);

	// Throw away from you
	makevectors (self.angles);
	bt.velocity = (v_forward * (200 + random() * 100)) + (v_up * (200 + random() * 100));

	bt.touch = beartrapTouch;

	sound(self, CHAN_AUTO, "weapons/btrap/bdrop_1.wav", 1, ATTN_NORM);

	// PAINKEEP SPLASH Make this entity splash
	AddToSplash(bt);
};
