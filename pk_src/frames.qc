/*
	func_frame
	Written by Matt Houser
	fisty@canweb.net
	Ripped off...err... inspired by Dimensionalitiy's func_frame
	16:50GMT-5:10/01/97

	Usage:
		Required:
	"classname" "func_frame"
	"targetname" "..."	- Name of group of frames, also targetname for toggling on and off
	"cnt" "#"			- Frame # (1 based)
	
		Optional: (* only needed on frame #1)
	* "dmg" "#"		- Damage on touch (only when moving)
	* "target" "..."	- Target to call on touch
	* "spawnflags" "#"	- & 1: Use on touch (frame will advance on touch, and
						"target" will be triggered)
					- & 2: Stopped at start
					- & 4: Back and forth rather than looping
	"wait" "#"	- Time delay between this frame and the next (default is 0.1,
					-1 should stop the animation, ignored when spawnflags & 1)
	"noise" "..."	- wav to play when that frame is shown
					NOTE: if wav is too long, entire thing may not play if
					frame is shown AGAIN
	"noise1" "..."	- ditto but only played when animation moving in forward direction
				- not used unless (spawnflags & 4) and noise is not set
	"noise2" "..."	- ditto but only played when animation moving in backward direction
				- not used unless (spawnflags & 4) and noise is not set

	- Frames are played in order starting at 1 (duplicates may be missed)
	- On use, animation will start or stop
	- When stopped, no damage will be done
	- A wait of -1 on a frame will stop the animation there, a retrigger
		should start it up again
	- "noise" is played when a frame is shown, if "noise" is not set
		and spawnflags & 4 is set, noise1 or noise2 will be played depending on current
		direction of animation
		
	BUGS:
		- Slight disfiguration on some walls while moving
		- Slightly larger delay when looping back to frame #1 (gone now, not sure why)
		- Bounding box problems
		- If done properly, you can get stuck IN the animation
*/

float FF_USEONTOUCH = 1;
float FF_STOPPED = 2;
float FF_BACKANDFORTH = 4;

entity(float thisCount) func_frame_find_frame =
{
	local entity e;

	// quick error check
	if (thisCount <= 0)
		return world;
	
	// find all the entities that have our targetname
	e = find(world, targetname, self.targetname);
	while (e != world)
	{
		// cycle thru until we found the right frame
		if (e.cnt == thisCount && e.classname == "func_frame")
			//we found it
			return e;
		e = find(e, targetname, self.targetname);
	}
	return world;
};

void() func_frame_change_frame =
{
	local entity e;
	local float thisCount;
	local string countStr;
	
	if (self.cnt != 1)
		return;	// this line shouldn't ever be reached
	
	// which way? forward or reverse?	
	thisCount = self.enemy.cnt + self.state;
	if (self.spawnflags & FF_BACKANDFORTH)
	{
		if (thisCount < 1)	// we've hit the start of our loop, reverse gear
		{
			self.state = 1;	// forward now
			thisCount = 2;	
		}
	}

	// get the next frame
	e = func_frame_find_frame(thisCount);

	if (e == world)
	{
		// end of loop
		if (self.spawnflags & FF_BACKANDFORTH)
		{
			self.state = -1;	// backwards now
			e = func_frame_find_frame(self.enemy.cnt - 1);
			if (e == world)
			{
				// double wammy
				self.state = 0;
				e = self;
			}
		}
		else
			e = self;
	}

	//dprint("func_frame_change_frame ");
	// set the frame for future use
	self.enemy = e;

	// set the model
	if (e == self)
		setmodel(self, self.mdl);
	else
		setmodel(self, e.model);

	// play the sound signified by this frame
	if (e.noise)
		sound (self, CHAN_VOICE, e.noise, 1, ATTN_NORM);
	else if (self.spawnflags & FF_BACKANDFORTH)
	{
		if (self.state && e.noise2 != "")
			sound (self, CHAN_VOICE, e.noise2, 1, ATTN_NORM);
		else if (!self.state && e.noise1 != "")
			sound (self, CHAN_VOICE, e.noise1, 1, ATTN_NORM);
	}
		
	if (!(self.spawnflags & FF_USEONTOUCH))
	{
		if (e.wait < 0)	// if we've hit a -1 wait, signal a stopped state
		{
			self.spawnflags = self.spawnflags | FF_STOPPED;
			self.nextthink = -1;
			return;
		}
		else if (self.spawnflags & 2)
			// otherwise just make sure our state is the moving state
			self.spawnflags = self.spawnflags - FF_STOPPED;
		self.nextthink = self.ltime + e.wait;
	}
};

// Called when something triggers the frames
void() func_frame_use =
{
	// only #1 should do any using
	if (self.cnt != 1)
		return;	// this line shouldn't ever be reached

	// we don't use if we use on touch
	if (self.spawnflags & FF_USEONTOUCH)
		return;
		
	//dprint("func_frame_use ");
	// we use spawnflags & FF_STOPPED to tell if we're moving or not
	if (self.spawnflags & FF_STOPPED)
	{
		// get moving
		self.spawnflags = self.spawnflags - FF_STOPPED;
		self.think = func_frame_change_frame;
		self.nextthink = self.ltime + 0.1;
	}
	else
	{
		// stop
		self.nextthink = -1;
		self.spawnflags = self.spawnflags | FF_STOPPED;
	}
};

// Called when something touches the frames
void() func_frame_touch =
{
	// only #1 should be touchable
	if (self.cnt != 1)
		return;	// this line shouldn't ever be reached
		
	// damage
	if (self.dmg && !(self.spawnflags & FF_STOPPED))
		T_Damage(other, self, self, self.dmg);

	// change frame on touch only
	if (self.spawnflags & FF_USEONTOUCH)
	{
		func_frame_change_frame();
		// use any targets this may be dealing with
		activator = other;
		SUB_UseTargets();
	}
};

/*
	spawn function
*/
void() func_frame =
{
	// initial error checking
	if (!self.targetname)
	{
		// no targetname, no way to group
		if (PK_100 && PK_100_OBJERR) objerror("func_frame without a targetname\n");
		if (WARNING) bprint("\n*** warning:\nfunc_frame without a targetname - removing,\n\n");
		remove(self);
		return;
	}
	if (!self.cnt)
	{
		// no cnt, no way to know which frame this is
		if (PK_100 && PK_100_OBJERR) objerror("func_frame without a cnt\n");
		if (WARNING) bprint("\n*** warning:\nfunc_frame without a cnt - removing,\n\n");
		remove(self);
		return;
	}
	if (!self.wait)
		self.wait = 0.1;	// how long the current frame stays put

	// precache any sounds that are made this frame
	if (self.noise)
		precache_sound(self.noise);
	if (self.noise1)
		precache_sound(self.noise1);
	if (self.noise2)
		precache_sound(self.noise2);

	if (self.cnt == 1)
	{
		self.solid = SOLID_BSP;
		self.movetype = MOVETYPE_PUSH;
		self.state = 1;
		// save for restore later
		self.mdl = self.model;
		
		// 1 does all the work, 2 and so on are just additional frames
		setmodel(self, self.model);

		self.use = func_frame_use;
		self.touch = func_frame_touch;
		
		self.enemy = self;	// enemy says which frame we're on
		
		// if we're not use on touch
		if (!(self.spawnflags & FF_USEONTOUCH))
		{
			self.think = func_frame_change_frame;
			// and we're not stopped
			if (!(self.spawnflags & FF_STOPPED))
				// then get going
				self.nextthink = self.ltime + self.wait;
		}
	}
};

