/*
	New sound funcs for pk

	Random sound generators:
	"classname" "func_thumpsound"      // Generate a random thumping sound
	... and many others. have a look at the src for details
*/

float() rand_time =
{
	return time + 1 + random() * 30;
	//return time + 1;
};

void() func_thumpsound_play =
{
	if ( ! pk_flags & PK_TP_SPARKSFLASH)
	{
	  local float r;
	  local string sname;
	  r = random() * 8;
	  if (r < 1)
	    sname = "random/thump/thump_1.wav";
	  else if (r < 2)
	    sname = "random/thump/thump_2.wav";
	  else if (r < 3)
	    sname = "random/thump/thump_3.wav";
	  else if (r < 4)
	    sname = "random/thump/thump_4.wav";
	  else if (r < 5)
	    sname = "random/thump/thump_5.wav";
	  else if (r < 6)
	    sname = "random/thump/thump_6.wav";
	  else if (r < 7)
	    sname = "random/thump/thump_7.wav";
	  else
	    sname = "random/thump/thump_8.wav";
	  sound (self, CHAN_AUTO, sname, 1, ATTN_NORM);
	}

	if (world.model == "maps/pk6.bsp" || world.model == "maps/pk7.bsp")
	  self.nextthink = time + 1;
	else
	  self.nextthink = rand_time();
};

void() func_cygnussound_play =
{
	if ( ! pk_flags & PK_TP_SPARKSFLASH)
	{
		local float r;
		local string sname;
		r = random() * 7;
		if (r < 1)
			sname = "random/cygnus/cygnus_1.wav";
		else if (r < 2)
			sname = "random/cygnus/cygnus_2.wav";
		else if (r < 3)
			sname = "random/cygnus/cygnus_3.wav";
		else if (r < 4)
			sname = "random/cygnus/cygnus_4.wav";
		else if (r < 5)
			sname = "random/cygnus/cygnus_5.wav";
		else if (r < 6)
			sname = "random/cygnus/cygnus_6.wav";
		else
			sname = "random/cygnus/cygnus_7.wav";
		sound (self, CHAN_AUTO, sname, 1, ATTN_NORM);
	}

	self.nextthink = rand_time();
};

void() func_birdsound_play =
{
	if ( ! pk_flags & PK_TP_SPARKSFLASH)
	{
		local float r;
		local string sname;
		r = random() * 10;
		if (r < 1)
			sname = "random/bird/bird_1.wav";
		else if (r < 2)
			sname = "random/bird/bird_2.wav";
		else if (r < 3)
			sname = "random/bird/bird_3.wav";
		else if (r < 4)
			sname = "random/bird/bird_4.wav";
		else if (r < 5)
			sname = "random/bird/bird_5.wav";
		else if (r < 6)
			sname = "random/bird/bird_6.wav";
		else if (r < 7)
			sname = "random/bird/bird_7.wav";
		else if (r < 8)
			sname = "random/bird/bird_8.wav";
		else if (r < 9)
			sname = "random/bird/bird_9.wav";
		else
			sname = "random/bird/bird_10.wav";
		sound (self, CHAN_AUTO, sname, 1, ATTN_NORM);
	}
	self.nextthink = rand_time();
};

void() func_growlsound_play =
{
	if ( ! pk_flags & PK_TP_SPARKSFLASH)
	{
		local float r;
		local string sname;
		r = random() * 6;
		if (r < 1)
			sname = "random/growl/growl_1.wav";
		else if (r < 2)
			sname = "random/growl/growl_2.wav";
		else if (r < 3)
			sname = "random/growl/growl_3.wav";
		else if (r < 4)
			sname = "random/growl/growl_4.wav";
		else if (r < 5)
			sname = "random/growl/growl_5.wav";
		else
			sname = "random/growl/growl_6.wav";
		sound (self, CHAN_AUTO, sname, 1, ATTN_NORM);
	}
	self.nextthink = rand_time();
};

void() func_moansound_play =
{
	if ( ! pk_flags & PK_TP_SPARKSFLASH)
	{
		local float r;
		local string sname;
		r = random() * 5;
		if (r < 1)
			sname = "random/moans/moan_1.wav";
		else if (r < 2)
			sname = "random/moans/moan_2.wav";
		else if (r < 3)
			sname = "random/moans/moan_3.wav";
		else if (r < 4)
			sname = "random/moans/moan_4.wav";
		else
			sname = "random/moans/moan_5.wav";
		sound (self, CHAN_AUTO, sname, 1, ATTN_NORM);
	}
	self.nextthink = rand_time();
};

void() func_swampsound_play =
{
	if ( ! pk_flags & PK_TP_SPARKSFLASH)
	{
		local float r;
		local string sname;
		r = random() * 10;
		if (r < 1)
			sname = "random/swamp/swamp_1.wav";
		else if (r < 2)
			sname = "random/swamp/swamp_2.wav";
		else if (r < 3)
			sname = "random/swamp/swamp_3.wav";
		else if (r < 4)
			sname = "random/swamp/swamp_4.wav";
		else if (r < 5)
			sname = "random/swamp/swamp_5.wav";
		else if (r < 6)
			sname = "random/swamp/swamp_6.wav";
		else if (r < 7)
			sname = "random/swamp/swamp_7.wav";
		else if (r < 8)
			sname = "random/swamp/swamp_8.wav";
		else if (r < 9)
			sname = "random/swamp/swamp_9.wav";
		else
			sname = "random/swamp/swamp_10.wav";
		sound (self, CHAN_AUTO, sname, 1, ATTN_NORM);
	}

	self.nextthink = rand_time();
};

void() func_painsound_play =
{
	if ( ! pk_flags & PK_TP_SPARKSFLASH)
	{
		local float r;
		local string sname;
		r = random() * 7;
		if (r < 1)
			sname = "random/pain/pain_1.wav";
		else if (r < 2)
			sname = "random/pain/pain_2.wav";
		else if (r < 3)
			sname = "random/pain/pain_3.wav";
		else if (r < 4)
			sname = "random/pain/pain_4.wav";
		else if (r < 5)
			sname = "random/pain/pain_5.wav";
		else if (r < 6)
			sname = "random/pain/pain_6.wav";
		else
			sname = "random/pain/pain_7.wav";
		sound (self, CHAN_AUTO, sname, 1, ATTN_NORM);
	}

	self.nextthink = rand_time();
};


void() func_sound_thump =
{
	// precaches
	precache_sound("random/thump/thump_1.wav");
	precache_sound("random/thump/thump_2.wav");
	precache_sound("random/thump/thump_3.wav");
	precache_sound("random/thump/thump_4.wav");
	precache_sound("random/thump/thump_5.wav");
	precache_sound("random/thump/thump_6.wav");
	precache_sound("random/thump/thump_7.wav");
	precache_sound("random/thump/thump_8.wav");

	self.think = func_thumpsound_play;
	self.nextthink = rand_time();
};

// For backwards compatibility
void() func_thumpsound =
{
	func_sound_thump();
};

void() func_sound_cygnus =
{
	// precaches
	precache_sound("random/cygnus/cygnus_1.wav");
	precache_sound("random/cygnus/cygnus_2.wav");
	precache_sound("random/cygnus/cygnus_3.wav");
	precache_sound("random/cygnus/cygnus_4.wav");
	precache_sound("random/cygnus/cygnus_5.wav");
	precache_sound("random/cygnus/cygnus_6.wav");
	precache_sound("random/cygnus/cygnus_7.wav");

	self.think = func_cygnussound_play;
	self.nextthink = rand_time();
};

void() func_sound_bird =
{
	// precaches
	precache_sound("random/bird/bird_1.wav");
	precache_sound("random/bird/bird_2.wav");
	precache_sound("random/bird/bird_3.wav");
	precache_sound("random/bird/bird_4.wav");
	precache_sound("random/bird/bird_5.wav");
	precache_sound("random/bird/bird_6.wav");
	precache_sound("random/bird/bird_7.wav");
	precache_sound("random/bird/bird_8.wav");
	precache_sound("random/bird/bird_9.wav");
	precache_sound("random/bird/bird_10.wav");

	self.think = func_birdsound_play;
	self.nextthink = rand_time();
};

void() func_sound_growl =
{
	// precaches
	precache_sound("random/growl/growl_1.wav");
	precache_sound("random/growl/growl_2.wav");
	precache_sound("random/growl/growl_3.wav");
	precache_sound("random/growl/growl_4.wav");
	precache_sound("random/growl/growl_5.wav");
	precache_sound("random/growl/growl_6.wav");

	self.think = func_growlsound_play;
	self.nextthink = rand_time();
};

void() func_sound_moan =
{
	// precaches
	precache_sound("random/moans/moan_1.wav");
	precache_sound("random/moans/moan_2.wav");
	precache_sound("random/moans/moan_3.wav");
	precache_sound("random/moans/moan_4.wav");
	precache_sound("random/moans/moan_5.wav");

	self.think = func_moansound_play;
	self.nextthink = rand_time();
};

void() func_sound_swamp =
{
	// precaches
	precache_sound("random/swamp/swamp_1.wav");
	precache_sound("random/swamp/swamp_2.wav");
	precache_sound("random/swamp/swamp_3.wav");
	precache_sound("random/swamp/swamp_4.wav");
	precache_sound("random/swamp/swamp_5.wav");
	precache_sound("random/swamp/swamp_6.wav");
	precache_sound("random/swamp/swamp_7.wav");
	precache_sound("random/swamp/swamp_8.wav");
	precache_sound("random/swamp/swamp_9.wav");
	precache_sound("random/swamp/swamp_10.wav");

	self.think = func_swampsound_play;
	self.nextthink = rand_time();
};

void() func_sound_pain =
{
	// precaches
	precache_sound("random/pain/pain_1.wav");
	precache_sound("random/pain/pain_2.wav");
	precache_sound("random/pain/pain_3.wav");
	precache_sound("random/pain/pain_4.wav");
	precache_sound("random/pain/pain_5.wav");
	precache_sound("random/pain/pain_6.wav");
	precache_sound("random/pain/pain_7.wav");

	self.think = func_painsound_play;
	self.nextthink = rand_time();
};

