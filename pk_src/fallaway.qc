/*
	func_fallaway
	Written by Matt Houser

		* Optional
	"classname" "func_fallaway"
	* "targetname" "..."	- Target name
	* "wait" "#"			- time delay between touch/use and begin of fall
							(default 0.1)
*/

void() func_fallaway_begin_fall =
{
	// last for 7 seconds then remove self
	self.think = SUB_Remove;
	self.nextthink = self.ltime + 7;
	
	// get into "fall mode"
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_BOUNCE;
	self.touch = SUB_Null;
	self.use = SUB_Null;
};

void() func_fallaway_fall1;

vector() makeShuffle =
{
	local vector v;
	v_x = crandom() * 4;
	v_y = crandom() * 4;
	v_z = crandom() * 8;
	return v;
};

void() func_fallaway_fall2 =
{
	local vector sVector;
	sVector = makeShuffle();
	// shuffle around a bit
	if (self.cnt >= 6)
		SUB_CalcMove(self.origin + sVector, 64, func_fallaway_begin_fall);
	else
		SUB_CalcMove(self.origin + sVector, 64, func_fallaway_fall1);
};

void() func_fallaway_fall1 =
{
	if (self.cnt == 0)
		sound (self, CHAN_AUTO, "misc/fall_1.wav", 1, ATTN_NORM);
	local vector sVector;
	sVector = makeShuffle();
	// shuffle around a bit
	self.cnt = self.cnt + 1;
	SUB_CalcMove(self.origin + sVector, 64, func_fallaway_fall2);
};

void() func_fallaway_use =
{
	// start the shuffle after "wait" amount of time
	self.cnt = 0;
	self.think = func_fallaway_fall1;
	self.nextthink = self.ltime + self.wait;
};

void() func_fallaway_touch =
{
	// no more touchies
	self.touch = SUB_Null;
	
	func_fallaway_use();
};

void() func_fallaway =
{
	// setup use delay
	if (!self.wait)
		self.wait = 0.1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	precache_sound("misc/fall_1.wav");
	if (self.targetname)
	{
		// fall on use
		self.use = func_fallaway_use;	
	}
	else
	{
		// fall on touch
		self.touch = func_fallaway_touch;
	}
	setmodel(self, self.model);
};
