/*
	light_lightning
	Created by Matt Houser

	Usage:

	"classname" "light_lightning"
	"origin" "x x x"	- Origin of the entity
	"style" "14"		- This is required
	"light" "#"		- Brightness of the lightning (1000 is pretty good)
	"mean" "#"		- Mean time of next event (default 5)
	"stdev" "#"		- Variation around the mean time (default 0)
*/

.entity next; // for the linked list of lightning

void() lightning_think;

// only the first lightning uses this funciton
void() lightning_stop =
{
	// stop the lightning
	lightstyle(14, "a");
	self.nextthink = time + meantime(self.mean, self.stdev);
	self.think = lightning_think;
};

void(float r) lightning_flash =
{
	local entity oself;
	local string pattern;
	local string soundfile;
	local float duration;

	// call the .next's flash
	if (self.next != world)
	{
		oself = self;
		self = self.next;
		lightning_flash(r);
		self = oself;
	}

	// depending on the random #
	if (r < 1)
	{
		r = 1;
		pattern = "zzzzmmdzzaaazzzmmma";
		duration = 2.0;
		soundfile = "misc/thunder/thunder5.wav";
	}
	else if (r < 2)
	{
		r = 2;
		pattern = "zzddzzzzmddmmmddzzddzddzzzzzmm";
		duration = 3.0;
		soundfile = "misc/thunder/thunder1.wav";
	}
	else if (r < 3)
	{
		r = 3;
		pattern = "zzzzfffzzz";
		duration = 1.0;
		soundfile = "misc/thunder/thunder2.wav";
	}
	else if (r < 4)
	{
		r = 4;
		pattern = "zzzdddzzzzzmmf";
		duration = 1.4;
		soundfile = "misc/thunder/thunder3.wav";
	}
	else
	{
		r = 5;
		pattern = "zzzzzddzzm";
		duration = 1.0;
		soundfile = "misc/thunder/thunder4.wav";
	}

	// all play the sound, but only the first controls the light level
	sound(self, CHAN_VOICE, soundfile, 1, ATTN_NONE);
	if (self.cnt == 1)
	{
		lightstyle(14, pattern);
		self.nextthink = time + duration;
		self.think = lightning_stop;

		// print a message
		//bprint("Now playing lighting sequence #");
		//bprint(ftos(r));
		//bprint("\n");
	}
};

void() lightning_think =
{
	local float r;

	// randomly choose a thunder/lightning pattern
	r = random() * 5;
	lightning_flash(r);
};

void() findFirst =
{
	// ok the last frame we set determined which light_lightning was the first
	if (self.cnt == 1)
	{
		// only the first light_lightning will actually do any randomization
		self.think = lightning_think;
		self.nextthink = time + meantime(self.mean, self.stdev);
	}
};

void() linkLightning =
{
	self.think = findFirst;
	self.nextthink = time + 0.1;

	// turn off the light
	lightstyle(14, "a");

	// ok find the next light_lightning
	self.next = find(self, classname, "light_lightning");
	if (self.next != world)
	{
		// tell the next one that it's not the first
		self.next.cnt = 0;
	}
};

void() light_lightning =
{

	if ((cvar("temp1") & PK_TP_SPARKSFLASH))
		remove(self);

	// error checking
	if (self.style != 14)
	{
		objerror("light_lightning with style != 14\n");
		remove(self);
		return;
	}

	// precache
	precache_sound("misc/thunder/thunder5.wav");
	precache_sound("misc/thunder/thunder1.wav");
	precache_sound("misc/thunder/thunder2.wav");
	precache_sound("misc/thunder/thunder3.wav");
	precache_sound("misc/thunder/thunder4.wav");

	// default mean time
	if (!self.mean)
		self.mean = 5.0;

	self.cnt = 1;
	self.think = linkLightning;
	self.nextthink = time + 0.1;
};
