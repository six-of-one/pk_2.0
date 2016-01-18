/*
	func_drip
	Written by Matt Houser
	19:14GMT-5:01/01/96

	"classname" "func_drip"
	"style" "#"	- not implemented yet
	"sounds" "#"	- not implemented yet
	"mean" "#" 	- Mean time between drips (default is 5)
	"stdev" "#" 	- Variation around the mean time (default is 0)
*/

void() func_drip_touch =
{
	local float r;
	// play sound
	if (other.classname == "worldspawn")
	{
		// random sound
		r = random() * 3;
		if (r < 1)
		{
			sound (self, CHAN_AUTO, "misc/drip/drip_1.wav", 1, ATTN_NORM);
		}
		else if (r < 2)
		{
			sound (self, CHAN_AUTO, "misc/drip/drip_3.wav", 1, ATTN_NORM);
		}
		else
		{
			sound (self, CHAN_AUTO, "misc/drip/drip_4.wav", 1, ATTN_NORM);
		}
	}
	else if (other.classname == "drop")
		return;
	else
		// muffled sound
		sound (self, CHAN_AUTO, "misc/drip/drip_2.wav", 1, ATTN_NORM);

	SUB_Remove();
};

void() func_drip_drop =
{
	local entity drop;

	if (!XENV || PK_100)
	if ( ! pk_flags & PK_TP_SPARKSFLASH)
	{
		// create new drop
		drop = spawn();
		drop.classname = "drop";
		drop.solid = SOLID_TRIGGER;
		drop.movetype = MOVETYPE_BOUNCE;
		drop.touch = func_drip_touch;
		setorigin(drop, self.origin);
		setmodel(drop, "progs/s_drip.spr");

	  // PAINKEEP SPLASH Not for splashing, but so we can remove it if it hits the water
	  AddToSplash(drop);
	}

	self.nextthink = time + meantime(self.mean, self.stdev);
};

void() func_drip =
{
	//precaches
	precache_model("progs/s_drip.spr");
	precache_sound("misc/drip/drip_1.wav");
	precache_sound("misc/drip/drip_2.wav");
	precache_sound("misc/drip/drip_3.wav");
	precache_sound("misc/drip/drip_4.wav");

	// default wait
	if (!self.mean)
		self.mean = 5.0;

	// default style
	if (!self.style)
		self.style = 1;

	// default sound
	if (!self.sounds)
		self.sounds = 1;

	self.think = func_drip_drop;
	self.nextthink = time + meantime(self.mean, self.stdev);
};
