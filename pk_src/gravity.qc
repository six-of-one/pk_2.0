/*
	gravity well
	Written by Matt Houser
	an Evolve project
*/

$frame cubelf01 cubelf02 cubelf03 cubelf04 cubelf05 cubelf06 cubelf07 cubelf08
$frame cubelf09 cubelf10 cubelf11 cubelf12 cubelf13 cubelf14 cubelf15 cubelf16
$frame cubelf17 cubelf18 cubelf19 cubelf20

void() gravity_touch =
{
	// try to gib whatever touched the gravity centre
	if (other.takedamage && other.health > 0)
	{
		// sound

		T_Damage(other, self, self.owner, 5000);
	}
};

void() gravity_pull =
{
	local entity e;
	local float d;
	local vector org;
	local float gPercent;
	local float gDist = 960;		// range of the weapon
	local float gPower = 512;	// ideal speed of pull

	if (time > self.attack_finished)
	{
		// turn off bright light
		if (self.effects & EF_BRIGHTLIGHT)
			self.effects = self.effects - EF_BRIGHTLIGHT;

		// do an explosion
		T_RadiusDamage(self, self.owner, 80, world);

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);

		BecomeExplosion();
		return;
	}

	org = (self.absmin + self.absmax) * 0.5;
	e = findradius(self.origin, gDist);


	while (e)
	{
		if (visible(e))
		if (e.classname != "gravity") // don't yank on any other gravity wells
		if (e.classname != "beartrap")
		//if (e != self.owner)
		if (e.movetype != MOVETYPE_NONE) // anything that can move
		if (e.movetype != MOVETYPE_PUSH)
		if (e.movetype != MOVETYPE_NOCLIP)
		{
			d = vlen(e.origin - org);
			if (e.flags & FL_ONGROUND)
			{
				// raise the object a bit
				setorigin(e, e.origin + '0 0 1');
				e.flags = e.flags - FL_ONGROUND;
			}
			//dprint(e.classname);
			gPercent = 1 - (d / gDist);

			// modify the velocity
			e.velocity = e.velocity + normalize(self.origin - e.origin) * gPower * gPercent;
		}
		e = e.chain;
	}
};

void() gravity_pulse1 = [ $cubelf01, gravity_pulse2 ] { gravity_pull(); };
void() gravity_pulse2 = [ $cubelf02, gravity_pulse3 ] { gravity_pull(); };
void() gravity_pulse3 = [ $cubelf03, gravity_pulse4 ] { gravity_pull(); };
void() gravity_pulse4 = [ $cubelf04, gravity_pulse5 ] { gravity_pull(); };
void() gravity_pulse5 = [ $cubelf05, gravity_pulse6 ] { gravity_pull(); };
void() gravity_pulse6 = [ $cubelf06, gravity_pulse7 ] { gravity_pull(); };
void() gravity_pulse7 = [ $cubelf07, gravity_pulse8 ] { gravity_pull(); };
void() gravity_pulse8 = [ $cubelf08, gravity_pulse9 ] { gravity_pull(); };
void() gravity_pulse9 = [ $cubelf09, gravity_pulse10 ] { gravity_pull(); };
void() gravity_pulse10 = [ $cubelf10, gravity_pulse11 ] { gravity_pull(); };
void() gravity_pulse11 = [ $cubelf11, gravity_pulse12 ] { gravity_pull(); };
void() gravity_pulse12 = [ $cubelf12, gravity_pulse13 ] { gravity_pull(); };
void() gravity_pulse13 = [ $cubelf13, gravity_pulse14 ] { gravity_pull(); };
void() gravity_pulse14 = [ $cubelf14, gravity_pulse15 ] { gravity_pull(); };
void() gravity_pulse15 = [ $cubelf15, gravity_pulse16 ] { gravity_pull(); };
void() gravity_pulse16 = [ $cubelf16, gravity_pulse17 ] { gravity_pull(); };
void() gravity_pulse17 = [ $cubelf16, gravity_pulse18 ] { gravity_pull(); };
void() gravity_pulse18 = [ $cubelf16, gravity_pulse19 ] { gravity_pull(); };
void() gravity_pulse19 = [ $cubelf16, gravity_pulse20 ] { gravity_pull(); };
void() gravity_pulse20 = [ $cubelf16, gravity_pulse1 ] { gravity_pull(); };

void() gravity_explode =
{
	//if (time > self.attack_finished)
	//{
		// TODO something funky in the water?

		setmodel(self, "progs/cubel.mdl");
		self.attack_finished = time + 3.2;	// duration of gravity well
		self.touch = gravity_touch;
		self.effects = self.effects | EF_BRIGHTLIGHT;
	  self.pk_currentitem = PK_IT_GRAVITYWELL;
		self.think = gravity_pulse1;
		self.nextthink = time + 0.1;
	//	return;
	//}

	//sound (self, CHAN_BODY, "misc/gravsp_3.wav", 1, ATTN_NORM);
	//self.nextthink = time + 1.0;
};

void() drop_gravity =
{
	local entity gravity;

	// create a gravity object
	gravity = spawn();
	gravity.classname = "gravity";
	gravity.owner = self;
	gravity.solid = SOLID_TRIGGER;
	gravity.movetype = MOVETYPE_TOSS;

	// set it's placement and velocity
	setorigin(gravity, self.origin + self.view_ofs);
	gravity.velocity = self.velocity * 0.5;
	setmodel(gravity, "progs/cube.mdl");
	// TODO get acurate sizing
	setsize(gravity, '-32 -32 -32', '32 32 32');

	/*
	gravity.think = gravity_explode;
	gravity.nextthink = time + 1.0;
	gravity.attack_finished = time + 2.1;
	*/
	gravity.think = gravity_explode;
	gravity.nextthink = time + 2.0;
	sound (self, CHAN_BODY, "misc/grav/grav_new.wav", 1, ATTN_NORM);

	// Throw away from you
	makevectors (self.angles);
	gravity.velocity = (v_forward * (200 + random() * 100)) + (v_up * (200 + random() * 100));

	// For the correct death messages
	gravity.pk_currentitem = PK_IT_GRAVITYWELL;
	gravity.weapon = IT_AXE;

	// PAINKEEP SPLASH Make this entity splash
	AddToSplash(gravity);
};

