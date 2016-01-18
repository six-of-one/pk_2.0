/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: phone.qc
 *
 * date: Wed Aug 12 05:11:43 UTC 2009
 *
 * 
 *
 */


entity (entity caller) SelectPhoneDestination =
{
	local entity spot;
	local entity phonedest1;
	local entity phonedest2;
	local entity phonedest3;
	local float selectspot;
	local float totalspots;
	local float callingdistance;
	phonedest1 = caller;
	phonedest2 = caller;
	phonedest3 = caller;
	totalspots = 0;
	spot = find (world,classname,"info_player_deathmatch");
	while ( spot )
	{
		totalspots = (totalspots + 1);
		callingdistance = vlen ((caller.origin - spot.origin));
		if ( (callingdistance > vlen ((caller.origin - phonedest1.origin))) )
		{
			phonedest3 = phonedest2;
			phonedest2 = phonedest1;
			phonedest1 = spot;
		}
		else
		if ( (callingdistance > vlen ((caller.origin - phonedest2.origin))) )
		{
			phonedest3 = phonedest2;
			phonedest2 = spot;
		}
		else
		if ( (callingdistance > vlen ((caller.origin - phonedest3.origin))) )
		{
			phonedest3 = spot;
		}
		spot = find (spot,classname,"info_player_deathmatch");
	}
	if ( (totalspots > 3) )
	{
		totalspots = 3;
	}
	selectspot = floor (((totalspots * random ()) + 1));
	if ( (selectspot == 1) )
	{
		spot = phonedest1;
	}
	else
	if ( (selectspot == 2) )
	{
		spot = phonedest2;
	}
	else
	if ( (selectspot == 3) )
	{
		spot = phonedest3;
	}
	return(spot);
};

void () phone_teleport =
{
	local entity phonedest;
	local vector org;
	phonedest = SelectPhoneDestination (self.owner);
	spawn_tfog2 (self.owner.origin);
	ClearSpawnPoint (phonedest);
	makevectors (phonedest.mangle);
	org = (phonedest.origin + (32 * v_forward));
	spawn_tfog (org);
	spawn_tdeath (phonedest.origin,self.owner);
	self.owner.aiment = world; // Cataboligne - 5.4.10 - telefrag escape for admin, need to reset this
	if ( !self.owner.health )
	{
		self.owner.origin = phonedest.origin;
		self.owner.velocity = ((v_forward * self.owner.velocity_x) + (v_forward * self.owner.velocity_y));
		remove (self);
		return ;
	}
	setorigin (self.owner,phonedest.origin);
	self.owner.angles = self.owner.mangle;
	if ( (other.classname == "player") )
	{
		self.owner.fixangle = 1;
		self.owner.teleport_time = (time + 0.7);
		self.owner.bt_immune_time = (time + BT_BUFFER);
		if ( (self.owner.flags & FL_ONGROUND) )
		{
			self.owner.flags = (self.owner.flags - 512);
		}
		self.owner.velocity = (v_forward * 300);
	}
	self.owner.flags = (self.owner.flags - (self.owner.flags & FL_ONGROUND));
	remove (self);
};

void () phone_activate =
{
	local entity ent;
	ent = spawn ();
	sound (self,CHAN_VOICE,"phone/phone.wav",1,ATTN_NORM);
	ent.owner = self;
	ent.think = phone_teleport;
	ent.nextthink = (time + 0.5);
};

