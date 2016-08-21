/*
 * File: grap.qc
 *
 * Grappling Gun source.
 *
 */

// GRAPPLING defs
.entity grap_cornerchainNext;	// next in the rope corner chain.
.entity grap_ropechainPrev;	// prev in the rope chain.
.entity grap_owner; // Can't use owner cas the object can't see the owner!
.entity grap_pull;
.float grap_checkTimeout;
.float grap_state;
//.float grap_length;
.vector grep_offset;	// harpoon target offset for bringing back to owner
.float grap_firetest;

float SAFE_LOOP = 300; // count of loop limit in case a grap test gets stuck somehow

/*
   put in SAFE_LOOP to fix this, which I have seen a few times;

// dm4 pk code test of dyn items, item override, custom hub
// in lava w/pent, fired grap up to ciel & sunk down to bot.

server Profile:
[CallCount] [Statements] [BuiltinCost]
  3333410  36668276 103338686 grap_checkIfCanBeRemoved
      821  40022120     27001 grap_checkCornerLines
  3337285 ----- builtin ----- 
     9618    312161    824122 CheckWaterLevels
Host_Error: server runaway loop counter hit limit of 10000000 jumps
tip: read above for list of most-executed functions

*/



/*
// moved to pk.defs.qc

float GRAP_IDEAL = 0; // Going nothing
float GRAP_OUT = 1; // It's outing out
float GRAP_IN = 2; // It's comming back to the owner
float GRAP_TOHARPOON = 3; // lengthen rope
float GRAP_FIXED = 4; // The length is fixed.
float GRAP_ROPESHORTEN = 5; // shorten rope
float GRAP_ROPELENGTHEN = 6; // lengthen rope
float GRAP_HARPOON = 7;
float GRAP_CORNER = 8;
float GRAP_ROPE = 9;
*/
// defs_END


void() grap_touch;
float() grap_maintainRope;
void() grap_touchOwner;
void() grap_goToOwner;
void() grap_maintainHarpoon;
entity(entity ropeOwner) grap_createRope;
void(entity grapOwner) grap_remove;
void(entity grapOwner) grap_removeRope;
void() grap_ownerToTarget;
entity(entity start) grap_findHarpoon;
void(entity corner) grap_removeCorner;
void() grep_touchCorner;
void(entity corner, vector cornerOrigin) grep_createCornerRope;
float() grap_checkCornerLines;
float(entity cornerOwner) grap_createCorner;
float(entity cornerOwner) grap_forceCheckCorner;
float(entity owner, vector ownerOrigin, vector tryOrigin) grap_checkIfCanBeRemoved;



float CHAN_GRAPROPE	=	5;
float GRAPROPE_MAXLEENGTH = 1500;

void() grap_fire =
{
	local entity harpoon, temp;
	local vector dir;

	if (self.grap_firetest)
	{
		return;
	}

	temp = self;
	self.grap_firetest = 1;

	if (self.grap_cornerchainNext)
	{ // Harpoon already out there
		harpoon = grap_findHarpoon(self);

		// Check if it is waiting to come back...
	  if (self.grap_state == GRAP_IDEAL)
	  {
	    // bring back...
	    self.grap_cornerchainNext.nextthink = time + 0.1;
	    self.grap_cornerchainNext.think = grap_ownerToTarget;
	    self.grap_cornerchainNext.grap_checkTimeout = time + 0.5;
	    self.grap_cornerchainNext.touch = grap_touchOwner;
	    self.grap_state = GRAP_TOHARPOON;
	    self.grap_checkTimeout = 0;

		  self.attack_finished = time + 0.4;
	  }
	  else
	  {
		  self.attack_finished = time + 1;

	    // remove harpoon
	    other = self;
	    self = harpoon;
	    grap_touchOwner();
	  }
		self = temp;
	  return;
	}

	// check if near a wall
	makevectors(self.v_angle);
	dir = self.origin;
	traceline (dir, dir + v_forward * 75, FALSE, self);

	if (trace_fraction != 1.0 && !trace_ent.takedamage)
	{
		// To near a wall, can't throw turret
	  sprint(self, "Too close to a wall!!\n");
	  return;
	}

	// play firing sound
	sound (self, CHAN_AUTO, "weapons/grapple/grapl_2.wav", 1, ATTN_NORM);

	makevectors(self.v_angle);
	dir = v_forward;

	// create & launch harpoon
	harpoon = spawn();

	harpoon.grap_owner = self;
	harpoon.angles = vectoangles(dir);
	harpoon.movetype = MOVETYPE_FLYMISSILE;
	harpoon.solid = SOLID_BBOX;
	setmodel (harpoon, "progs/harpoon.mdl");
	setsize (harpoon, VEC_ORIGIN, VEC_ORIGIN);
	harpoon.punchangle_x = -2;
	harpoon.touch = grap_touch;
	harpoon.grap_state = GRAP_HARPOON;

	// For the correct death messages
	harpoon.pk_currentitem = PK_IT_GRAPGUN;
	harpoon.weapon = IT_AXE;

	self.grap_cornerchainNext = harpoon;

	harpoon.classname = "Harpoon";
	setorigin (harpoon, self.origin + '0 0 16');
	harpoon.velocity = dir * 2000;


	// let out rope

	self.grap_state = GRAP_OUT;

	self.grap_checkTimeout = 0;


	self.attack_finished = time + 0.5;

	player_grapfire1();
	self = temp;
};


void() grap_releaseHarpoon =
{
	if (self.grap_cornerchainNext)
	{ // Harpoon is out there
		local entity harpoon, temp;

	  harpoon = grap_findHarpoon(self);

	  // remove harpoon
	  temp = self;
	  other = self;
	  self = harpoon;
	  grap_touchOwner();
		self = temp;
	}
};


float() grap_maintainRope =
{
	local entity corner;
	local vector cornerOrigin, v1;
	local float totalLength,sf;

	totalLength = 0;
	// play rope sounds needed...
	if (self.grap_state == GRAP_OUT)
	{
		if (self.grap_checkTimeout < time)
	  {
			sound (self, CHAN_GRAPROPE, "weapons/grapple/grapr_2.wav", 1, ATTN_NORM);
	    self.grap_checkTimeout = time + 3.2;
	  }
	}
	else if (self.grap_state == GRAP_IN || self.grap_state == GRAP_TOHARPOON)
	{
		if (self.grap_checkTimeout < time)
	  {
			sound (self, CHAN_GRAPROPE, "weapons/grapple/graps_2.wav", 1, ATTN_NORM);
	    self.grap_checkTimeout = time + 3.2;
	  }
	}
	else if (self.grap_checkTimeout > time)
	{
	  sound (self, CHAN_GRAPROPE, "misc/null.wav", 1, ATTN_NORM);
	  self.grap_checkTimeout = 0;
	}

	// for each segment between corners
	corner = self;
// Cataboligne - 4.4.11 - start point of rope at end of harpoon gun, new vw calc
  	if (!PK_100)
		v1 = cornerOrigin = corner.origin + grap_vw_adj(corner);
	else
	cornerOrigin = corner.origin + '0 0 16';

	sf = SAFE_LOOP;
	while(corner.grap_cornerchainNext && sf > 0)
	{
		sf = sf - 1;

		totalLength = totalLength + vlen(corner.grap_cornerchainNext.origin - cornerOrigin);

		grep_createCornerRope(corner, cornerOrigin);

		corner = corner.grap_cornerchainNext;
		cornerOrigin = corner.origin;
	}

// Cataboligne - 4.4.11 - 
// TEST - attempt to move closeset seg fwd if backing past start point
  	if (!PK_100)
	{
		corner = self.grap_cornerchainNext.grap_ropechainPrev;
		while (corner.grap_ropechainPrev)
			corner = corner.grap_ropechainPrev;
		if (vlen(v1 - corner.origin) < 40)
		{
			v1 = normalize(corner.origin - v1);
			corner.origin = corner.origin + (v1 * 16);
		}
	}
	
	return totalLength;
};


void(entity corner, vector cornerOrigin) grep_createCornerRope =
{
	local entity rope, ropeOwner;
	local vector startPoint, dir, vangle;
	local float sf;

	// Calculate viewing angle
	vangle = normalize(corner.grap_cornerchainNext.origin - cornerOrigin);
	vangle = vectoangles(vangle);

	ropeOwner = corner.grap_cornerchainNext;

	ropeOwner.angles = vangle;

	// if going out, create coil's
	if (self.grap_state == GRAP_OUT)
	{
		if(vlen(cornerOrigin - ropeOwner.origin) < 86)
	  {
	    // if there is rope, then delete
	    if (ropeOwner.grap_ropechainPrev)
	    {
	      grap_removeRope(ropeOwner);
	    }
	    return;
	  }

	  // Calculate direction to owner.
		dir = normalize(cornerOrigin - ropeOwner.origin);

	  // Calculate start point of the coil
		startPoint = ropeOwner.origin + (dir * 68);

	  if (ropeOwner.grap_ropechainPrev)
	  {
	    rope = ropeOwner.grap_ropechainPrev;
	  }
	  else
	  {
	    rope = grap_createRope(ropeOwner);
	    rope.classname = "HarpoonCoil";
	    setmodel(rope, "progs/harpcoil.mdl");
	  }
	  rope.origin = startPoint;
	  rope.velocity = '0 0 0';
	  rope.angles = vangle;

	  ropeOwner = rope;



		sf = SAFE_LOOP;
		while(sf > 0)
		{
			sf = sf - 1;

	    // create a coil entity if there is room
	    if (vlen(cornerOrigin - ropeOwner.origin) < 32)
	    {
	      // if there is rope, then delete
	      if (ropeOwner.grap_ropechainPrev)
	      {
	        grap_removeRope(ropeOwner);
	      }
	      return;
	    }

	    // Calculate direction to owner.
	    dir = normalize(cornerOrigin - ropeOwner.origin);

	    // Calculate start point of the coil
	    startPoint = ropeOwner.origin + (dir * 32);

	    if (ropeOwner.grap_ropechainPrev)
	    {
	      rope = ropeOwner.grap_ropechainPrev;
	    }
	    else
	    {
	      rope = grap_createRope(ropeOwner);
	      rope.classname = "HarpoonCoil";
	      setmodel(rope, "progs/harpcoil.mdl");
	    }
	    rope.origin = startPoint;
	    rope.velocity = '0 0 0';
	    rope.angles = vangle;

	    ropeOwner = rope;
	  }
	}
	else // create rope instead
	{
	  // create a coil entity if there is room
	  if (vlen(cornerOrigin - ropeOwner.origin) < 70)
	  {
	    // if there is rope, then delete
	    if (ropeOwner.grap_ropechainPrev)
	    {
	      grap_removeRope(ropeOwner);
	    }
	    return;
	  }

	  // Calculate direction to owner.
	  dir = normalize(cornerOrigin - ropeOwner.origin);

	  // Calculate start point of the coil
	  startPoint = ropeOwner.origin + (dir * 70);

	  if (ropeOwner.grap_ropechainPrev)
	  {
	    rope = ropeOwner.grap_ropechainPrev;

	    // if a coil, convert to a rop
	    if (rope.classname == "HarpoonCoil")
	    {
	      rope.classname = "HarpoonRope";
	      setmodel(rope, "progs/harprope.mdl");
	    }
	  }
	  else
	  {
	    rope = grap_createRope(ropeOwner);
	    rope.classname = "HarpoonRope";
	    setmodel(rope, "progs/harprope.mdl");
	  }
	  rope.origin = startPoint;
	  rope.velocity = '0 0 0';
	  rope.angles = vangle;

	  ropeOwner = rope;


		sf = SAFE_LOOP;
		while(sf > 0)
		{
			sf = sf - 1;

	    // create a coil entity if there is room
	    if (vlen(cornerOrigin - ropeOwner.origin) < 35)
	    {
	      // if there is rope, then delete
	      if (ropeOwner.grap_ropechainPrev)
	      {
	        grap_removeRope(ropeOwner);
	      }
	      return;
	    }

	    // Calculate direction to owner.
	    dir = normalize(cornerOrigin - ropeOwner.origin);

	    // Calculate start point of the coil
	    startPoint = ropeOwner.origin + (dir * 34);

	    if (ropeOwner.grap_ropechainPrev)
	    {
	      rope = ropeOwner.grap_ropechainPrev;

	      if (rope.classname == "HarpoonCoil")
	      {
	        rope.classname = "HarpoonRope";
	        setmodel(rope, "progs/harprope.mdl");
	      }
	    }
	    else
	    {
	      rope = grap_createRope(ropeOwner);
	      rope.classname = "HarpoonRope";
	      setmodel(rope, "progs/harprope.mdl");
	    }
	    rope.origin = startPoint;
	    rope.velocity = '0 0 0';
	    rope.angles = vangle;

	    ropeOwner = rope;
	  }
	}

};


void() grap_touch =
{
	local entity grapOwner;
//	local vector temp;
	local float sf;

	if (other == self.grap_owner)
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		self.grap_pull = self;
		grap_touchOwner();
		return;
	}

	self.touch = SUB_Null;

	grapOwner = self.grap_owner;
	sf = SAFE_LOOP;
	while(grapOwner.grap_state == GRAP_CORNER && sf > 0)
	{
		sf = sf - 1;
	  grapOwner = grapOwner.grap_owner;
	}


// hit something that bleeds
//	if (other.takedamage)
	if ((other.health && other.solid != SOLID_BSP && other.solid != SOLID_NOT) || other.solid == SOLID_TRIGGER || grapOwner.grap_firetest)
	{
	  self.grap_owner.grap_checkTimeout = 0;
		self.touch = grap_touchOwner;

		// set the corner touch functions.
		grapOwner = self.grap_owner;
		sf = SAFE_LOOP;
		while(grapOwner.grap_state == GRAP_CORNER && sf > 0)
		{
			sf = sf - 1;
		  grapOwner.touch = grep_touchCorner;
		  grapOwner = grapOwner.grap_owner;
		}

	  // set owner state
	  grapOwner.grap_state = GRAP_IN;

		if (other.health && other.solid != SOLID_BSP && other.solid != SOLID_NOT)
	  {
			// play hit sound
			sound(self, CHAN_AUTO, "weapons/grapple/grapf_1.wav", 1, ATTN_NORM);

			spawn_touchblood (9);
			T_Damage(other, self, grapOwner, 9);

	  }
	  else
	  {
			// play hit sound
			sound (self, CHAN_AUTO, "weapons/grapple/graph_2b.wav", 1, ATTN_NORM);
	  }

	  // drag to the owner.
	  if ((other.health && other.solid != SOLID_BSP && other.solid != SOLID_NOT) || other.solid == SOLID_TRIGGER)
	  {
		  self.grap_pull = other;
		  self.grap_pull.grap_owner = self.grap_owner;
	  	self.grap_pull.movetype = MOVETYPE_FLY;
	  }
	}
	else
	{
		// play hit sound
		sound (self, CHAN_AUTO, "weapons/grapple/graph_2b.wav", 1, ATTN_NORM);

	  grapOwner.grap_state = GRAP_IDEAL;
	}

	// come back to the grap_owner
	// setting the velocity does some weird things
	self.velocity = '0 0 0';

	// stop creation of rope
	if (self.grap_pull)
	{
	  self.nextthink = time + 0.1;
	  self.think = grap_goToOwner;
	  self.grap_checkTimeout = time + 0.5;
	  self.grep_offset = (self.origin - self.grap_pull.origin);
	}
	else if (grapOwner.grap_firetest)
	{
	  self.nextthink = time + 0.1;
	  self.think = grap_goToOwner;
	  self.grap_checkTimeout = time + 0.5;
	}
};


void() grap_touchOwner =
{
	local entity grapOwner;
	local float sf;

	// if touch grap_pull, don't bother to remove self, not there yet.
	if (self.grap_pull == other)
	{
		return;
	}

	// check if hit a corner...
	if (self.grap_state == GRAP_CORNER)
	{
	  // send on to next corner...
	  grapOwner = self;
	  self = self.grap_cornerchainNext;

	  grap_removeCorner(grapOwner);

	  self.nextthink = time + 0.1;
	  self.think = grap_ownerToTarget;
	  self.grap_checkTimeout = time + 0.5;
	  self.touch = grap_touchOwner;
	}
	else
	{
	  // stop sounds...
	  sound (self.grap_owner, CHAN_GRAPROPE, "misc/null.wav", 1, ATTN_NORM);
	  self.grap_owner.grap_checkTimeout = 0;

	  // remove everything
	  grapOwner = self.grap_owner;
		sf = SAFE_LOOP;
		while(grapOwner.grap_state == GRAP_CORNER && sf > 0)
		{
			sf = sf - 1;
			grapOwner = grapOwner.grap_owner;
	  }

	  grap_remove(grapOwner);
	}
};



void() grap_goToOwner =
{
	local vector temp;

	if (self.grap_checkTimeout < time)
	{
		if (self.origin == self.oldorigin || (!PK_100 && vlen(self.origin - self.grap_owner.origin) < 50))
	  { // stuck on wall or something
	  	other = self.grap_owner;
	    grap_touchOwner();
	    return;
	  }
	}

	self.oldorigin = self.origin;

	self.nextthink = time + 0.1;

	if (self.grap_pull)
	if (self.grap_pull.solid != SOLID_TRIGGER)
	if (self.grap_pull.health < 1 || self.grap_pull.solid == SOLID_NOT)  // check if the entity is dead or "picked up"
	{
	  self.grap_pull.grap_owner = world;

	  if (self.grap_pull.classname == "player")
	  {
	    if (!self.grap_pull.deadflag && !self.disconnectPlayer)
	    {
	      self.grap_pull.movetype = MOVETYPE_WALK;
	    }
	  }
	  else
	  {
	    self.grap_pull.movetype = MOVETYPE_STEP;
	  }
		self.grap_pull = world;
	}

	if (self.grap_pull)
	{
		// give veelocity to target entity.
		temp = normalize((self.grap_owner.origin) - self.grap_pull.origin);
		self.grap_pull.velocity = temp * 500;

	  if (self.grap_pull.flags & FL_ONGROUND)
	  {
	    self.grap_pull.flags = self.grap_pull.flags - FL_ONGROUND;
		  setorigin(self.grap_pull, self.grap_pull.origin + '0 0 1');
	  }

	  // set current harpoon origin relative
	  self.origin = self.grap_pull.origin + self.grep_offset;
	  setorigin(self, self.origin);
 }
 else
 {
		temp = normalize((self.grap_owner.origin + '0 0 16') - self.origin);
		self.velocity = temp * 500;
 }
};


void() grap_ownerToTarget =
{
	local float dist;
	local string str;

	// double check if is valid
	if (self.grap_owner.grap_state != GRAP_TOHARPOON)
	{
		return;
	}

	if (self.grap_checkTimeout < time)
	{
		if (self.grap_owner.origin == self.grap_owner.oldorigin)
	  { // stuck on wall or something
	  	other = self.grap_owner;
	    grap_touchOwner();
	    return;
	  }
	}

	// only check if it's going to the harpoon
	if (self.grap_state != GRAP_CORNER)
	{
	  dist = vlen(self.grap_owner.origin - self.origin);
	  str = ftos(dist);

	  if (dist < 53)  // must be in touching distance...
	  {
	    other = self.grap_owner;
	    grap_touchOwner();
	    return;
	  }
	}

	self.nextthink = time + 0.1;
};


void() grap_maintainHarpoon =
{
//	local vector harpoonDifference;
//	local float chainLength, vecfactor;
	local entity temp;

	temp = self;

//	if (self.grap_owner) // if being pulled by a harpoon
//	{
//		local vector temp;
//		temp = normalize((self.grap_owner.origin + '0 0 16') - self.origin);
//		self.velocity = self.velocity = temp * 500;
//	}

	if (!self.grap_cornerchainNext) // if harpoon not out
	{
		self.grap_firetest = 0;
		return;
	}

	if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_GRAPGUN)
	{
		if (!self.button0)
	  {
			self.grap_firetest = 0;
	  }
	}
	else
	{
		self.grap_firetest = 0;
	}

	if ((self.teleport_time > time) || 	// if player goes through teleport
		(self.view_ofs == '0 0 0'))	     // or intermission
	{
	  other = self;
	  self = grap_findHarpoon(self);
	  grap_touchOwner();
		self = temp;
	  return;
	}

	if (grap_checkCornerLines())
	{
	  other = self;
	  self = grap_findHarpoon(self);
	  grap_touchOwner();
		self = temp;
	  return;
	}

	if (grap_maintainRope() > GRAPROPE_MAXLEENGTH)
	{
		if (self.grap_state == GRAP_IDEAL || self.grap_state == GRAP_OUT)
	  {
	  	local entity harpoon;

	    // bring back...
			harpoon = grap_findHarpoon(self);

		  harpoon.grap_owner.grap_checkTimeout = 0;
			harpoon.touch = grap_touchOwner;
			harpoon.grap_pull = world;
			harpoon.nextthink = time + 0.1;
		  harpoon.think = grap_goToOwner;
		  harpoon.grap_checkTimeout = time + 0.5;
		  self.grap_state = GRAP_IN;
	    return;
	  }
	  else if (self.grap_state != GRAP_IN)
	  { // remove...
		  other = self;
		  self = grap_findHarpoon(self);
	  	grap_touchOwner();
			self = temp;
	    return;
	  }
	}


	if (self.grap_state == GRAP_TOHARPOON)
	{
		local vector normDir;
		normDir = normalize(self.grap_cornerchainNext.origin - (self.origin + '0 0 16'));
		self.velocity = normDir * 500;
	}
};


void(entity grapOwner) grap_remove =
{
	local entity e, f;
	local float sf;
	e = grapOwner.grap_cornerchainNext;

	sf = SAFE_LOOP;
	while(e && sf > 0)
	{
		sf = sf - 1;
		f = e;
	  e = e.grap_cornerchainNext;

	  if (f.grap_pull)
	  {
			f.grap_pull.grap_owner = world;

	    if (f.grap_pull.classname == "player")
	    {
	    	if (!f.grap_pull.deadflag && !self.disconnectPlayer)
	      {
		      f.grap_pull.movetype = MOVETYPE_WALK;
	      }
	    }
	    else
	    {
	      f.grap_pull.movetype = MOVETYPE_STEP;
	    }
	  }

	  grap_removeRope(f);
// Cataboligne - 4.4.11 - remove harpoon positioner rope at start point
	  if (f.enemy) remove (f.enemy);

	  remove(f);
	}

	grapOwner.grap_cornerchainNext = world;
};


void(entity grapOwner) grap_removeRope =
{
	local entity e, f;
	local float sf;
	e = grapOwner.grap_ropechainPrev;

	sf = SAFE_LOOP;
	while(e && sf > 0)
	{
		sf = sf - 1;
		f = e;
	  e = e.grap_ropechainPrev;

	  if (f.grap_pull)
	  {
			f.grap_pull.grap_owner = world;

	    if (f.grap_pull.classname == "player")
	    {
	    	if (!f.grap_pull.deadflag && !self.disconnectPlayer)
	      {
		      f.grap_pull.movetype = MOVETYPE_WALK;
	      }
	    }
	    else
	    {
	      f.grap_pull.movetype = MOVETYPE_STEP;
	    }
	  }

	  remove(f);
	}

	grapOwner.grap_ropechainPrev = world;
};


entity(entity ropeOwner) grap_createRope =
{
	local entity rope;

	rope = spawn();
	rope.movetype = MOVETYPE_FLYMISSILE;
	rope.solid = SOLID_NOT;
	setsize (rope, VEC_ORIGIN, VEC_ORIGIN);
	rope.punchangle_x = -2;

	rope.angles = ropeOwner.angles;
	rope.grap_owner = ropeOwner.grap_owner;
	rope.owner = ropeOwner;

	rope.grap_state = GRAP_ROPE;

	// add to the end of the chain...
	ropeOwner.grap_ropechainPrev = rope;

	return rope;
};






// Find the harpoon entity.
entity(entity start) grap_findHarpoon =
{
	local float sf;

	sf = SAFE_LOOP;
	while(start.grap_cornerchainNext && sf > 0)
	{
		sf = sf - 1;
		start = start.grap_cornerchainNext;

	  if (start.grap_state != GRAP_CORNER)
	  {
	  	return start;
	  }
	}

	return start;
};


void(entity corner) grap_removeCorner =
{
	// remove the owner connection.
	corner.grap_owner.grap_cornerchainNext = corner.grap_cornerchainNext;

	// remove the next corner owner connection.
	if (corner.grap_cornerchainNext)
	{
		corner.grap_cornerchainNext.grap_owner = corner.grap_owner;
	}

	// remove the rope for this corner.
	grap_removeRope(corner);

	// now finially remove the corner.
	remove(corner);
};



void() grep_touchCorner =
{
	if (other != self.grap_cornerchainNext)
	{
		// remove corner
		grap_removeCorner(self);

		// move onto the next corner.
	  // this is done in the grap_goToOwner
	}
};



float() grap_checkCornerLines =
{
	local entity corner, tryNext, del;
	local vector cornerOrigin;
	local float sf;

	corner = self.grap_cornerchainNext;
	cornerOrigin = self.origin + '0 0 16';

	sf = SAFE_LOOP;
	while(corner && sf > 0)
	{
		sf = sf - 1;

		// check if the line is broken
	  traceline (cornerOrigin, corner.origin, TRUE, self.grap_pull);

	  if (trace_fraction < 1.0)
	  { // line is broken, create a new corner.
	  	if (grap_createCorner(corner.grap_owner))
	    {
	    	// if it was the owner that went out of line, do a double check...
	      if (corner.grap_owner == self)
	      {
	      	if (grap_forceCheckCorner(self))
	        {
	        	return TRUE;
	        }
	      }
	      else
	      {
		    	return TRUE;
	      }
	    }
	  }
	  else
	  { // check if a corner can be deleted.
	    tryNext = corner.grap_cornerchainNext;

			sf = 500;
			while(tryNext && sf > 0)
				{
				sf = sf - 1;
	    	if (grap_checkIfCanBeRemoved(corner.grap_owner, cornerOrigin, tryNext.origin))
	      { // Up to this corner can be deleted.

				while(corner != tryNext && sf > 0)
				{
						sf = sf - 1;
						del = corner;
	          corner = corner.grap_cornerchainNext;
						grap_removeCorner(del);
	        }
	      }

	      tryNext = tryNext.grap_cornerchainNext;
	    }
	  }

		cornerOrigin = corner.origin;
	  corner = corner.grap_cornerchainNext;
	}

	// if going to target, resetup goto
	if (self.grap_state == GRAP_TOHARPOON)
	{
		if (self.grap_cornerchainNext.nextthink < time)
	  {
		  self.grap_cornerchainNext.nextthink = time + 0.1;
		  self.grap_cornerchainNext.grap_checkTimeout = time + 0.5;
	  }

	  self.grap_cornerchainNext.think = grap_ownerToTarget;
	  self.grap_cornerchainNext.touch = grap_touchOwner;
	}

	return FALSE;
};



float(entity cornerOwner) grap_createCorner =
{
	local vector dir, startPoint, checkPos, ownerOrigin;
	local float checkAmount;

	// try the plane normal out to 100 to see if we can find a corner.

	dir = trace_plane_normal;
	startPoint = trace_endpos;
	checkAmount = 1;

	if (cornerOwner.grap_state == GRAP_CORNER)
	{
		ownerOrigin = cornerOwner.origin;
	}
	else
	{
		ownerOrigin = cornerOwner.origin + '0 0 16';
	}

	while(checkAmount <= 100)
	{
		checkPos = startPoint + (dir * checkAmount);
		traceline (ownerOrigin, checkPos, TRUE, self.grap_pull);

		if (trace_fraction == 1.0)
	  {
			traceline (cornerOwner.grap_cornerchainNext.origin, checkPos, TRUE, self.grap_pull);

			if (trace_fraction == 1.0)
		  {
				local entity corner;

	      // setup corner.
	      corner = spawn();
	      corner.solid = SOLID_NOT;

	      corner.grap_owner = cornerOwner;
	      corner.owner = self;

	      corner.grap_state = GRAP_CORNER;

	      // Add another 5 just for space...
				checkPos = startPoint + (dir * (checkAmount + 5));
	      corner.origin = checkPos;

	      corner.grap_cornerchainNext = cornerOwner.grap_cornerchainNext;
	      cornerOwner.grap_cornerchainNext = corner;

	      corner.grap_cornerchainNext.grap_owner = corner;

	      return FALSE;
	    }
	  }

	  checkAmount = checkAmount + 1;
	}

	return TRUE;
};




float(entity cornerOwner) grap_forceCheckCorner =
{
	local vector endPos, dir;
	local float length;

	endPos = cornerOwner.oldorigin + '0 0 16';

	// double check that the old origin can see the next point.
	traceline (cornerOwner.grap_cornerchainNext.origin, endPos, TRUE, self.grap_pull);

	if (trace_fraction < 1.0)
	{
		return TRUE; // can't see the oldorigin, something must be very wrong here
	}

	length = vlen(endPos - (cornerOwner.origin + '0 0 16'));
	dir = normalize(endPos - (cornerOwner.origin + '0 0 16'));

	endPos = endPos + dir;
	length = length - 1;

	// try the difference between the origin & oldorigin
	while(length > 0)
	{
	  traceline (cornerOwner.grap_cornerchainNext.origin, endPos, TRUE, self.grap_pull);

	  if (trace_fraction < 1.0)
	  {
	  	// found the first, can't see point.
	    // now run the  grap_createCorner function
	    return grap_createCorner(cornerOwner);
	  }

	  endPos = endPos + dir;
	  length = length - 1;
	}

	// should never get here...
	return TRUE;
};



float(entity ownerEntity, vector ownerOrigin, vector tryOrigin) grap_checkIfCanBeRemoved =
{
	// try the line...
	traceline (ownerOrigin, tryOrigin, TRUE, self.grap_pull);

	if (trace_fraction == 1.0)
	{
		if (ownerEntity == self)
	  {
	    // if the owner... Try the full model size...
	    traceline (ownerOrigin + (VEC_HULL_MIN * 2), tryOrigin, TRUE, self.grap_pull);

	    if (trace_fraction < 1.0)
	    {
	      return FALSE;
	    }

	    traceline (ownerOrigin + (VEC_HULL_MAX * 2), tryOrigin, TRUE, self.grap_pull);

	    if (trace_fraction < 1.0)
	    {
	      return FALSE;
	    }
	  }

	  return TRUE;
	}

	return FALSE;
};



void() grap_checkIfGrap =
{
	local float sf;

	if (other.classname == "Harpoon")
	{ // we have a harpoon from a grappling hook, drag back..
		local entity temp;
		local entity grapOwner;

	  // and it's going out...
	  grapOwner = other.grap_owner;
		sf = SAFE_LOOP;
		while(grapOwner.grap_state == GRAP_CORNER && sf > 0)
		{
		sf = sf - 1;
	    grapOwner = grapOwner.grap_owner;
	  }

	  if (grapOwner.grap_state == GRAP_OUT)
	  {
	    temp = self;
	    self = other;
	    other = temp;
	    grap_touch();
	  }
	}
};

