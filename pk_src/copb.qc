/*
 * File: copb.qc
 *
 * Can of Pork & Beens source.
 *
 */


void() copb_eatCan =
{
	// allow above 100...
	other = self;
	T_Heal(other, 100, 1);

	self.copb_timeout = time + 30;
	self.search_time = time + (random() * 2);
};




void() copb_checkFart =
{
	if (self.copb_nextFartTimeout < time) // Ended last fart?
	if (self.search_time < time) // next fart time?
	{ // farting time
		local string fartNoise;
	  local float rs;

		// sound off
	  if (random() < 0.90)
	  { // 75% of the time I'm using small farts...
		  rs = rint((random() * 2) + 1);

		  fartNoise = "";
		  if (rs == 1)
		    fartNoise = "weapons/copb/copb_1.wav";
		  else if (rs == 2)
		    fartNoise = "weapons/copb/copb_2.wav";
	  	else
		    fartNoise = "weapons/copb/copb_3.wav";

	    self.search_time = time + 0.5 + (random() * 0.25);
	  }
	  else
	  {
	    if (random() < 0.5)
		    fartNoise = "weapons/copb/copb_4.wav";
		  else
	  	  fartNoise = "weapons/copb/copb_5.wav";

	    self.search_time = time + 1 + (random() * 0.75);
	  }

		sound (self, CHAN_AUTO, fartNoise, 1, ATTN_NORM);

	  // lets raise up a little...
	  if (self.flags & FL_ONGROUND)
	  {
	    // raise the bugger a bit
	    setorigin(self, self.origin + '0 0 1');
	  }

	  self.velocity_z = self.velocity_z + 200 + (random() * 200);

	  self.copb_nextFartTimeout = time + 3 + rint(random() * 2);
	}
};
