/*
func_train_2d
Version 1.01

Written by Matt Houser
fisty@canweb.net

Based on id softwares func_train

Trains are moving platforms that players can ride.
The targets origin specifies the min point of the train at each corner.
The train spawns at the first target it is pointing at.
speed	default 100
dmg		default	2
sounds
1) ratchet metal

2d changes:
* on use (n), train will progress to targetn
* stops at all path_corners

use "cnt" "..." in the trigger to tell which dir (1 or 2) the button tells
the train to go

path_corners need a "target1" "..." and "target2" "..." instead of the single
"target" "..."

*/

// mod to pk 2.1 code 7/13/10 - added WARNING tag

// used by path_corners to specify the 2 possible destinations
.string target1;
.string target2;

void(float n) func_train_2d_next;
void() func_train_2d_find;
void() func_train_2d_wait;

void() func_train_2d_blocked =
{
	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 0.5;
	T_Damage (other, self, self, self.dmg);
};

void() func_train_2d_use =
{
	   if (!other.cnt)
		{
	        if (PK_100 && PK_100_OBJERR) objerror("func_train_2d_use: button does not specify direction in cnt");
	        else
			  {
				  if (WARNING) bprint("\n*** warning:\nfunc_train_2d_use: button does not specify direction in cnt - removing\n\n");
				  MAP_OBSTR = TRUE;
				  remove(self);
				  return;
			  }
		}

	   if (self.think == func_train_2d_find)
	        func_train_2d_next(other.cnt);
	   else if (self.wait)
	        func_train_2d_next(other.cnt);
};

void() func_train_2d_wait =
{
	   self.nextthink = self.ltime + -1;
	   self.wait = -1;
	   sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
};

void(float n) func_train_2d_next =
{
	local entity	targ;

	   // find the one we're at
	   targ = find (world, targetname, self.target);
	   if (n == 1)
	   {
	        if (targ.target1)
	             self.target = targ.target1;
	        else
			  {
					if (PK_100 && PK_100_OBJERR) objerror("func_train_2d_next: path_corner has no target1");
					else
					{
						if (WARNING) bprint("\n*** warning:\nfunc_train_2d_next: path_corner has no target1 - removing\n\n");
						MAP_OBSTR = TRUE;
						remove(self);
						return;
					}
			  }
	   }
	   else if (n == 2)
	   {
	        if (targ.target2)
	             self.target = targ.target2;
	        else
			  {
					if (PK_100 && PK_100_OBJERR) objerror("func_train_2d_next: path_corner has no target2");
					else
					{
						if (WARNING) bprint("\n*** warning:\nfunc_train_2d_next: path_corner has no target2 - removing\n\n");
						MAP_OBSTR = TRUE;
						remove(self);
						return;
					}
			  }
	   }

	   // find the next one in sequence
	   targ = find (world, targetname, self.target);

	   if (!self.target)
			{
					if (PK_100 && PK_100_OBJERR) objerror("func_train_2d_next: no next target");
					else
					{
						if (WARNING) bprint("\n*** warning:\nfunc_train_2d_next: no next target - removing\n\n");
						MAP_OBSTR = TRUE;
						remove(self);
						return;
					}
			}

	   self.wait = 0;
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	   SUB_CalcMove (targ.origin - self.mins, self.speed,
	        func_train_2d_wait);
};

void() func_train_2d_find =
{
	local entity	targ;

	   targ = find (world, targetname, self.target);
	   //self.target = targ.target;
	setorigin (self, targ.origin - self.mins);
};

void() func_train_2d =
{	
	   if (!self.speed)
		self.speed = 100;
	if (!self.target)
			{
					if (PK_100 && PK_100_OBJERR) objerror("func_train_2d without a target");
					else
					{
						if (WARNING) bprint("\n*** warning:\nfunc_train_2d without a target - removing\n\n");
						MAP_OBSTR = TRUE;
						remove(self);
						return;
					}
			}
	if (!self.dmg)
		self.dmg = 2;

	if (self.sounds == 0)
	{
		self.noise = ("misc/null.wav");
		precache_sound ("misc/null.wav");
		self.noise1 = ("misc/null.wav");
		precache_sound ("misc/null.wav");
	}

	if (self.sounds == 1)
	{
		self.noise = ("plats/train2.wav");
		precache_sound ("plats/train2.wav");
		self.noise1 = ("plats/train1.wav");
		precache_sound ("plats/train1.wav");
	}

	self.cnt = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	   self.blocked = func_train_2d_blocked;
	   self.use = func_train_2d_use;
	self.classname = "train";

	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);

// start trains on the second frame, to make sure their targets have had
// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	   self.think = func_train_2d_find;
};
