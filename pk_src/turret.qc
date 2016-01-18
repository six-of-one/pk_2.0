/* auto sentry / turret */

$frame gunsearch gunfire1 gunfire2 gunfire3 gunfire4 gunmisfire1 gunmisfire2

void() turret_searchForEnemy;
void() turret_findTarget;
float (entity e) turret_inFront;
void() turret_attackEnemy;
void() turret_deathAnim;
void() turret_deathAnimBase;
void(vector org, vector vec) turret_launchNail;
void() turret_nailTouch;
void() turret_checkIfCanBeSolid;
void(string gibname, float dm) turret_throwGib;
void() turret_gibTouch;



void() turret_dropTurret =
{
	local	entity turret;
	local vector dir;

	if (self.pk_turretammo <= 0)
	{
		return;
	}

	if (!self.button0)
	{
		player_run ();
	  return;
	}

	// check if near a wall
	makevectors(self.v_angle);
	dir = self.origin + self.view_ofs;
	traceline (dir, dir + v_forward * 50, FALSE, self);

	makevectors (self.angles);
	if (trace_fraction != 1.0 && !trace_ent.takedamage)
	{
		// To near a wall, can't throw turret
	  sprint(self, "Can't throw AutoSentry, too close to a wall!!\n");
	  return;
	}

	if (self.flags & FL_CLIENT) // some qualification
		self.currentammo = self.pk_turretammo = self.pk_turretammo - 1; // Cataboligne - 8.20.9 - moved here to wall fail doesnt eat ammo
									// NOTE: self must always then be firing entity

	turret = spawn ();
	turret.owner = self;
	turret.movetype = MOVETYPE_STEP;
//	turret.movetype = MOVETYPE_TOSS;
//	turret.solid = SOLID_BBOX;
	turret.solid = SOLID_NOT;
	turret.classname = "turret";
	turret.takedamage = TRUE;
	turret.health = 300;
	turret.th_die = turret_deathAnim;
	turret.ammo_cells = 40;

// set direction
	turret.angles = self.angles;
	turret.v_angle = self.v_angle;

// set turret duration
	turret.turret_timeout = time + 20;

// set when the turret can target the owner
	turret.turret_ownertimeout = time + 3;

// look for enemy
	turret.nextthink = time + 0.1;
	turret.think = turret_searchForEnemy;

	setmodel (turret, "progs/turtop.mdl");
	setsize (turret, '-15 -14 -18', '21 7 10');
//	setorigin (turret, self.origin + self.view_ofs);
	setorigin (turret, self.origin);


	turret.turret_base = spawn ();
	turret.turret_base.owner = turret;
	turret.turret_base.movetype = MOVETYPE_TOSS;
//	turret.turret_base.solid = SOLID_BBOX;
	turret.turret_base.solid = SOLID_NOT;
	turret.turret_base.classname = "turret_base";
	turret.turret_base.takedamage = TRUE;
	turret.turret_base.health = 200;
	turret.turret_base.th_die = turret_deathAnimBase;

	// Throw away from you
	makevectors (self.angles);
	turret.velocity = turret.turret_base.velocity = (v_forward * (200 + random() * 100)) + (v_up * (200 + random() * 100));

// set direction
	turret.turret_base.angles = self.angles;
	turret.turret_base.v_angle = self.v_angle;

// set turret duration
	turret.turret_timeout = time + 20;

// look for enemy
	turret.nextthink = time + 0.1;
	turret.think = turret_searchForEnemy;

	setmodel(turret.turret_base, "progs/turstand.mdl");
//	setsize(turret.turret_base, '-15 -14 -18', '9 14 1');
	setsize (turret, '-5 -5 -18', '5 5 1');
//	setorigin (turret.turret_base, self.origin + self.view_ofs);
	setorigin (turret.turret_base, self.origin);

	// PAINKEEP SPLASH Make this entity splash
	AddToSplash(turret);
};



void() turret_searchForEnemy =
{
	// check if the turret time is up
	if (self.turret_timeout < time) {
	  turret_deathAnim();
	  return;
	}

	// set the gun, so always lines up with the stand
	setorigin(self, self.turret_base.origin);

	// check if needs to be seet solid
	if (self.solid == SOLID_NOT)
	{
		turret_checkIfCanBeSolid();
	}

	// set animation frame to the search frame
	self.frame = $gunsearch;

	// rotate and check for siting of the enemy
	self.angles = self.angles + '0 10 0';
	self.v_angle = self.angles;

	// try to find a enemy to target....
	turret_findTarget();

	// next check time
	self.nextthink = time + 0.1;
};


void() turret_findTarget =
{
	local float dist, tempDist;
	local entity head, selected;

	// find the closest target within the current view of the turret.

	// max distance that the turret can "see"
	dist = 10000;
	selected = world;

	head = findradius(self.origin, dist);

	while(head)
	{
		if (head.health > 1)
		if (head.takedamage)
		if (head != self)
		if (head.classname != "beartrap")
		if (!((head.classname == "turret") && (head.owner == self.owner)))
		if (head.classname != "turret_base")
		if (pk_art_movshot_ck(head, "turret")) // Cataboligne 8.12.9 purify - pk artifacts
	  //if (!(head.classname == "turret"))
	  //if (!(head.classname == "turret_base"))
		if (self.turret_ownertimeout < time || head != self.owner)
	 	if (head.classname != "player" || !(head.items & IT_INVISIBILITY))
	  {
	    tempDist = vlen(head.origin - self.origin);
	  	traceline(self.origin, head.origin, TRUE, self);

	    if (trace_fraction >= 1)
	    if (tempDist < dist)
	    if (turret_inFront(head))
	    if (visible(head))
	    {
		  	selected = head;
		    dist = tempDist;
	    }
	  }

	  head = head.chain;
	}

	// Make the turning sound.
	if (self.turret_soundtimeout < time)
	{
		sound (self, CHAN_WEAPON, "weapons/sentry/turrt_3.wav", 1, ATTN_NORM);
		self.turret_soundtimeout = time + 0.5;
	}

	// target found
	if (selected != world)
	{
		// set it as the enemy
	  self.enemy = selected;

	  // set view to the target
		self.angles = vectoangles(selected.origin - self.origin);

	  // Target Acquired...
//		sound (self, CHAN_AUTO, "weapons/sentry/turr_2b.wav", 1, ATTN_NORM);

	  // attack target now

	  // attack until can't see anymore.
		self.think = turret_attackEnemy;
	}
};



// modification of infront() from ai.qc to be tighter
float (entity e) turret_inFront =
{
	local vector  vec;
	local float    dot;

	makevectors (self.v_angle);
	vec = normalize (e.origin - self.origin);
	dot = vec * v_forward;

	if (dot > 0.8)
	{
	  return TRUE;
	}
	return FALSE;
};




void() turret_attackEnemy =
{
	// check if the turret time is up
	if (self.turret_timeout < time) {
	  turret_deathAnim();
	  return;
	}

	// set the gun, so always lines up with the stand
	setorigin(self, self.turret_base.origin);

	// check if needs to be seet solid
	if (self.solid == SOLID_NOT)
	{
		turret_checkIfCanBeSolid();
	}

 	if (self.ammo_cells > 0) {
		// attack frame's
		self.frame = self.frame + 1;

		// loop if at end of anim
		if (self.frame > 5) {
			self.frame = $gunfire1;
		}
	}
	else
	{
	  // Not enough ammo

		if (self.frame != 5)
	  {
			self.frame = $gunmisfire1;
			sound (self, CHAN_WEAPON, "weapons/sentry/turcl_2b.wav", 0.2, ATTN_NORM);
	  }
	  else
	  {
			self.frame = $gunmisfire2;
	  }
	}

	// if still visiable & alive
	if (visible(self.enemy) && self.enemy.health > 1 && (self.enemy.classname != "player" || !(self.enemy.items & IT_INVISIBILITY)))
	{
		local vector targetview;

	  // set view to the target
	  targetview = vectoangles((self.enemy.origin + self.enemy.view_ofs)- self.origin);

	  if (targetview != self.angles)
	  {
			self.angles = targetview;

	    if (self.turret_soundtimeout < time)
	    {
	      sound (self, CHAN_WEAPON, "weapons/sentry/turrt_3.wav", 1, ATTN_NORM);
	      self.turret_soundtimeout = time + 0.5;
	    }
	  }

	  // attack target now if you can
//	  if (self.attack_finished < time)
		if (self.frame == 1 || self.frame == 3)
	  {
	  	if (self.ammo_cells > 0)
	    { // is there enough ammo to fire?
	    	local vector firePosition;
				makevectors (self.angles);
	      if (self.frame == 1)
	      {
	      	firePosition = self.origin + (v_forward * 21) - (v_right * 3);
					turret_launchNail(firePosition, (self.enemy.origin + self.enemy.view_ofs) - firePosition);
	      }
	      else
	      {
	      	firePosition = self.origin + (v_forward * 21) + (v_right * 3);
					turret_launchNail(firePosition, self.enemy.origin - firePosition);
	      }

	      self.ammo_cells = self.ammo_cells - 1;
	    }

	    // when can I attack again
//	    self.attack_finished = time + 0.5;
	  }
	}
	else
	{ // not visible, look for next target.
		self.think = turret_searchForEnemy;

	  // change back to gun search frame
		self.frame = $gunsearch;

	  // reset view angle to normal
	  self.angles_x = 0;
//	  self.angles_y = 0;
	  self.angles_z = 0;
		self.v_angle = self.angles;
	}

	self.nextthink = time + 0.1;
};


void() turret_deathAnim =
{
	local float numOfGibs;

	// ThrowGib is a function in player.qc
	turret_throwGib("progs/turgib1.mdl", -50);
	turret_throwGib("progs/turgib2.mdl", -50);
	turret_throwGib("progs/turgib3.mdl", -50);


	numOfGibs = random() * 5;

	while(numOfGibs > 0)
	{
		local float dam;
	  dam = random() * -50;
		turret_throwGib("progs/turgib3.mdl", dam);
	  numOfGibs = numOfGibs - 1;
	}

	remove(self.turret_base);
//	remove(self);

	T_RadiusDamage (self, self, 100, self);

	// Taken from the function T_MissileTouch in weapons.qc
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	// Functions is in weapons.qc
	BecomeExplosion ();
};


void() turret_deathAnimBase =
{
	self = self.owner;
	turret_deathAnim();
};


void(string gibname, float dm) turret_throwGib =
{
	local	entity new;

	new = spawn();
	new.origin = self.origin;
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random()*10;
	new.frame = 0;
	new.flags = 0;
	new.classname = "turret_gib";
	new.owner = self.owner;
	new.touch = turret_gibTouch;

	// PAINKEEP SPLASH Make this entity splash
	AddToSplash(new);
};


void() turret_gibTouch =
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		return;
	}

	org = self.origin - 8 * normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity * 0.2, 10);
		T_Damage (other, self, self, 10);

		remove(self);
	  return;
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}
};



void(vector org, vector vec) turret_launchNail =
{
//	local entity newmis;

	vec = normalize(vec);

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
//	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/nail.mdl");
	setsize (newmis, '0 0 0', '0 0 0');

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = turret_nailTouch;

	// For the correct death messages
	newmis.pk_currentitem = PK_IT_TURRET;
	newmis.weapon = IT_AXE;

	// PAINKEEP SPLASH Make this entity splash
	AddToSplash(newmis);

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
};


void() turret_nailTouch =
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	org = self.origin - 8 * normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity * 0.2, 15);
		T_Damage (other, self, self.owner, 15);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);
};


void() turret_checkIfCanBeSolid =
{
	local entity head;

	// see if there are any objects that block the turret from becoming solid
	head = findradius(self.origin, 28);

	if (!head)
	{
		// if can become solid!!!
		self.turret_base.solid = SOLID_BBOX;
		self.solid = SOLID_BBOX;

	  // make correct size
		setsize(self, '-15 -14 -18', '21 7 10');
		setsize(self.turret_base, '-15 -14 -18', '9 14 1');
	}
};

