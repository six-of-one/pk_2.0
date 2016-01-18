// frame sequence for animating pk items

// Cataboligne - 9.26.9 - visible weapons model (player has no gun!)

// running
$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6

// standing
$frame stand1 stand2 stand3 stand4 stand5

// pain
$frame pain1 pain2 pain3 pain4 pain5 pain6

//
// fire wep attacks
//
//$frame nailatt1 nailatt2 nailatt3 nailatt4
// light fire frames
$frame lightfatt1 lightfatt2 lightfatt3 lightfatt4

// *** duplicate of player.mdl frames above - not really necc... in fact dont use, some vw_ were not animated here
$frame dont_use1 dont_use2 dont_use3 dont_use4

$frame rockatt1 rockatt2 rockatt3 rockatt4 rockatt5 rockatt6

$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6

// crouching & prone frames

$frame crouchdown1 crouchdown2 crouchdown3
$frame crouch1 crouch2 crouch3 crouch4 crouch5
$frame prone1 prone2 prone3 prone4 prone5 prone6 prone7

// weapon access

$frame dropull1 dropull2 dropull3 dropull4 dropull5 dropull6 dropull7

// axe animation

$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6
$frame axstnd1 axstnd2 axstnd3 axstnd4 axstnd5 axstnd6
$frame axstnd7 axstnd8 axstnd9 axstnd10 axstnd11 axstnd12
$frame axpain1 axpain2 axpain3 axpain4 axpain5 axpain6

// axe attacks

$frame axatt1 axatt2 axatt3 axatt4 axatt5 axatt6

$frame axattb1 axattb2 axattb3 axattb4 axattb5 axattb6

$frame axattc1 axattc2 axattc3 axattc4 axattc5 axattc6

$frame axattd1 axattd2 axattd3 axattd4 axattd5 axattd6

//
// death
//

$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6
$frame axdeth7 axdeth8 axdeth9

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10 deatha11

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12 deathc13 deathc14 deathc15

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7
$frame deathd8 deathd9

$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7
$frame deathe8 deathe9

// viswep stuff - not found in player mdl -  player animation frame data should not go past frame deathe9

$frame dthrow1 dthrow2 dthrow3 dthrow4 dthrow5


void(float ab, float gb, float amx, float gmx) wk_frames =
{
	if (self.eweapon && FL_MELEE(self.eweapon, 0, 0)) //self.weapon, self.pk_currentitem ))
	{
		if (self.walkframe >= amx)
			self.walkframe = 0;
		self.frame = ab + self.walkframe;
	}
	else
	if (self.weapon == IT_AXE && FL_MELEE(self.eweapon, self.weapon, self.pk_currentitem ))
	{
		if (self.walkframe >= amx)
			self.walkframe = 0;
		self.frame = ab + self.walkframe;
	}
	else
	{
		if (self.walkframe >= gmx)
			self.walkframe = 0;
		self.frame = gb + self.walkframe;
	}
	
};

// pk player code moved here for adaptive code 

void() pk_stand_frames =
{
	wk_frames($axstnd1, $stand1, 12, 5);
	return;
//	if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_AXE)
	if (self.weapon == IT_AXE && FL_MELEE(self.eweapon, self.weapon, self.pk_currentitem ))
//	if (FL_MELEE(self.eweapon, self.weapon, self.pk_currentitem ))
	{
		if (self.walkframe >= 12)
			self.walkframe = 0;
		self.frame = $axstnd1 + self.walkframe;
	}
	else
	{
		if (self.walkframe >= 5)
			self.walkframe = 0;
		self.frame = $stand1 + self.walkframe;
	}
};

void() pk_run_frames =
{
	wk_frames($axrun1, $rockrun1, 6, 6);
	return;
//	if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_AXE)
	if (self.weapon == IT_AXE && FL_MELEE(self.eweapon, self.weapon, self.pk_currentitem ))
//	if (FL_MELEE(self.eweapon, self.weapon, self.pk_currentitem ))
	{
		if (self.walkframe == 6)
			self.walkframe = 0;
		self.frame = $axrun1 + self.walkframe;
	}
	else
	{
		if (self.walkframe == 6)
			self.walkframe = 0;
		self.frame = self.frame + self.walkframe;
	}
};


// harpoon frame control

void() pk_harpoon_frames =
{

	if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_GRAPGUN && self.grap_cornerchainNext != world)
	{
		if (self.grap_state == GRAP_IN || self.grap_state == GRAP_TOHARPOON)
		{
			if (self.weaponframe > 11 || self.weaponframe < 9)
			{
				self.weaponframe = 9;
			}
			else
			{
				self.weaponframe = self.weaponframe + 1;
			}
			if (!PK_100) //stuffcmd( self, "cl_bob 0\n" ); // dont bob while pulling in
				cam_setbob("");
		}
		else
		{
			self.weaponframe = 8;
			if (!PK_100)
			if ( !(self.cam_x & CHSCAM_ON) ) //stuffcmd( self, CL_BOBSET );
				cam_setbob(CL_BOBSET);
		}
	}
	else
	{
		self.weaponframe=0;
		if (!PK_100)
		if ( !(self.cam_x & CHSCAM_ON) ) //stuffcmd( self, CL_BOBSET );
				cam_setbob(CL_BOBSET);
	}

};

// pulse nailgun frames

void(float ox) pulse_fire =
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
	{
		player_run ();
		return;
	}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireSpikes (ox);
	if (rune_haste(0.3))
	self.attack_finished = time + 0.6;
};

void() pulse_idle =
{
	if (!self.button0)
	{
		player_run();
		return;
	}

	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;
};

void() player_pnail1	 =[$lightfatt1, player_pnail2]
{
	pulse_fire(4);
	self.nextthink = time + 0.1;
};

void() player_pnail2	 =[$lightfatt2, player_pnail3]
{
	pulse_idle();
	self.nextthink = time + 0.2;
};

void() player_pnail3	 =[$lightfatt3, player_pnail4]
{
	pulse_fire(-4);
	self.nextthink = time + 0.1;
};

void() player_pnail4	 =[$lightfatt4, player_pnail1]
{
	pulse_idle();
	self.nextthink = time + 0.2;
};

// chain thunderbolt code & frames

void() player_bolt1	 =[$lightfatt1, player_bolt2  ]
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;
	SuperDamageSound();
	bolt_fire();
	self.attack_finished = time + 0.2;
};

void() player_bolt2	 =[$lightfatt2, player_bolt3  ] // *pk - viswep - Cataboligne - 9.29.9
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 5)
		self.weaponframe = 1;
	SuperDamageSound();
	bolt_fire();
	self.attack_finished = time + 0.2;
};


void()	bolt_s_explode1	=	[0,		bolt_s_explode2] {};
void()	bolt_s_explode2	=	[0,		bolt_s_explode3] {};
void()	bolt_s_explode3	=	[0,		bolt_s_explode4] {};
void()	bolt_s_explode4	=	[1,		bolt_s_explode5] {};
void()	bolt_s_explode5	=	[1,		bolt_s_explode6] {};
void()	bolt_s_explode6	=	[1,		bolt_s_explode7] {};
void()	bolt_s_explode7	=	[2,		bolt_s_explode8] {};
void()	bolt_s_explode8	=	[2,		bolt_s_explode9] {};
void()	bolt_s_explode9	=	[2,		bolt_s_explode10] {};
void()	bolt_s_explode10	=	[3,		bolt_s_explode11] {};
void()	bolt_s_explode11	=	[3,		bolt_s_explode12] {};
void()	bolt_s_explode12	=	[3,		bolt_s_explode13] {};
void()	bolt_s_explode13	=	[4,		bolt_s_explode14] {};
void()	bolt_s_explode14	=	[4,		bolt_s_explode15] {};
void()	bolt_s_explode15	=	[4,		bolt_s_explode16] {};
void()	bolt_s_explode16	=	[5,		SUB_Remove] {};

// Airfist fire animation.
//	For the external view we use the rock fire animation with the
//	recoil part lengthened.

void() player_airgun1	 =[$rockatt1, player_airgun2  ] {self.weaponframe=1;};
void() player_airgun2	 =[$rockatt2, player_airgun3  ] {self.weaponframe=2;};
void() player_airgun3	 =[$rockatt3, player_airgun4  ] {self.weaponframe=3;};
void() player_airgun4	 =[$rockatt3, player_airgun5  ] {self.weaponframe=4;};
void() player_airgun5	 =[$rockatt4, player_airgun6  ] {self.weaponframe=5;};
void() player_airgun6	 =[$rockatt4, player_airgun7  ] {self.weaponframe=6;};
void() player_airgun7	 =[$rockatt5, player_airgun8  ] {self.weaponframe=7;};
void() player_airgun8	 =[$rockatt6, player_run  ] {self.weaponframe = 8;};

// AirFist failed fire animation.
//	For the external view we use the nail gun fire animation.

void() player_failedairgun1	 =[$lightfatt1, player_failedairgun2  ] {self.weaponframe=6;};
void() player_failedairgun2	 =[$lightfatt2, player_failedairgun3  ] {self.weaponframe=7;};
void() player_failedairgun3	 =[$lightfatt2, player_run  ] {self.weaponframe=8;};

// GRAPPLING_START

void() player_grapfire1 = [$lightfatt1, player_grapfire2 ] {self.weaponframe = 1;};
void() player_grapfire2 = [$lightfatt1, player_grapfire3 ] {self.weaponframe = 2;};
void() player_grapfire3 = [$lightfatt2, player_grapfire4 ] {self.weaponframe = 3;};
void() player_grapfire4 = [$lightfatt2, player_grapfire5 ] {self.weaponframe = 4;};
void() player_grapfire5 = [$lightfatt1, player_grapfire6 ] {self.weaponframe = 5;};
void() player_grapfire6 = [$lightfatt1, player_grapfire7 ] {self.weaponframe = 6;};
void() player_grapfire7 = [$lightfatt2, player_run ] {self.weaponframe = 7;};

// player sound code - mostly unused - put this on a sv_ var - these are now setup to override the default sounds if active, just to simplify the coding
// sec indicates section of player code sound is played from - NOTE: these are all commented out in player.qc

void(float sec) pk_player_sound =
{
	local float rs;

/* none of these sounds are provided
	if (sec == 1) // water drowning sounds
	{
		rs = rint((random() * 7) + 1);

		if (rs == 1)
			sound (self, CHAN_VOICE, "player/suck_1.wav", 1, ATTN_NORM);
		else if (rs == 2)
			sound (self, CHAN_VOICE, "player/suck_2.wav", 1, ATTN_NORM);
		else if (rs == 3)
			sound (self, CHAN_VOICE, "player/suck_3.wav", 1, ATTN_NORM);
		else if (rs == 4)
			sound (self, CHAN_VOICE, "player/suck_4.wav", 1, ATTN_NORM);
		else if (rs == 5)
			sound (self, CHAN_VOICE, "player/suck_5.wav", 1, ATTN_NORM);
		else if (rs == 6)
			sound (self, CHAN_VOICE, "player/suck_6.wav", 1, ATTN_NORM);
		else if (rs == 7)
			sound (self, CHAN_VOICE, "player/suck_7.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/suck_8.wav", 1, ATTN_NORM);
	}
	else if (sec == 2) // slime pain sounds
	{
// & now lava as well...
		rs = rint((random() * 4) + 1);

		if (rs == 1)
			sound (self, CHAN_VOICE, "player/burn_1.wav", 1, ATTN_NORM);
		else if (rs == 2)
			sound (self, CHAN_VOICE, "player/burn_2.wav", 1, ATTN_NORM);
		else if (rs == 3)
			sound (self, CHAN_VOICE, "player/burn_3.wav", 1, ATTN_NORM);
		else if (rs == 4)
			sound (self, CHAN_VOICE, "player/burn_4.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/burn_5.wav", 1, ATTN_NORM);
		return;
	}
	else if (sec == 3) // pain sounds
	{
		rs = rint((random() * 6) + 1);

		self.noise = "";
		if (rs == 1)
			self.noise = "player/pain_1.wav";
		else if (rs == 2)
			self.noise = "player/pain_2.wav";
		else if (rs == 3)
			self.noise = "player/pain_3.wav";
		else if (rs == 4)
			self.noise = "player/pain_4.wav";
		else if (rs == 5)
			self.noise = "player/pain_5.wav";
		else if (rs == 6)
			self.noise = "player/pain_6.wav";
		else
			self.noise = "player/pain_7.wav";
	}
	else if (sec == 4) // water death sounds
	{
		rs = rint((random() * 3) + 1);

		if (rs == 1)
			sound (self, CHAN_VOICE, "player/drown_1.wav", 1, ATTN_NORM);
		else if (rs == 2)
			sound (self, CHAN_VOICE, "player/drown_2.wav", 1, ATTN_NORM);
		else if (rs == 3)
			sound (self, CHAN_VOICE, "player/drown_3.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "player/drown_4.wav", 1, ATTN_NORM);
	}
	else if (sec == 5) // death sounds
	{
		rs = rint ((random() * 10) + 1);

		if (rs == 1)
			self.noise = "player/death_1.wav";
		else if (rs == 2)
			self.noise = "player/death_2.wav";
		else if (rs == 3)
			self.noise = "player/death_3.wav";
		else if (rs == 4)
			self.noise = "player/death_4.wav";
		else if (rs == 5)
			self.noise = "player/death_5.wav";
		else if (rs == 6)
			self.noise = "player/death_6.wav";
		else if (rs == 7)
			self.noise = "player/death_7.wav";
		else if (rs == 8)
			self.noise = "player/death_8.wav";
		else if (rs == 9)
			self.noise = "player/death_9.wav";
		else if (rs == 10)
			self.noise = "player/death_10.wav";
		else
			self.noise = "player/death_11.wav";
	}
	else */ if (sec == 6) // death gib sounds
	{
		rs = rint ((random() * 4) + 1);

		if (rs == 1)
			sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
		else if (rs == 2)
			sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
		else if (rs == 3)
			sound (self, CHAN_VOICE, "player/gib_1.wav", 1, ATTN_NONE);
		else if (rs == 4)
			sound (self, CHAN_VOICE, "player/gib_2.wav", 1, ATTN_NONE);
		else
			sound (self, CHAN_VOICE, "player/gib_3.wav", 1, ATTN_NONE);
	}
};

// called from below

void() PK_DeathSound =
{
local float		rs;

	// water death sounds
	if (self.waterlevel == 3)
	{
		DeathBubbles(5);

		sound (self, CHAN_VOICE, "player/h2odeath.wav", 1, ATTN_NONE);
//		if (pk_xsound) pk_player_sound(4);
		return;
	}

	rs = rint ((random() * 4) + 1);
	if (rs == 1)
		self.noise = "player/death1.wav";
	if (rs == 2)
		self.noise = "player/death2.wav";
	if (rs == 3)
		self.noise = "player/death3.wav";
	if (rs == 4)
		self.noise = "player/death4.wav";
	if (rs == 5)
		self.noise = "player/death5.wav";

//		if (pk_xsound) pk_player_sound(5);
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	return;
};

// called from below

void() PK_GibPlayer =
{
// DAMAGE_SKINS_START
	self.skin = 0;

// GIBS_START
	if (random() > 0.5)
	{
		ThrowHead ("progs/h_player.mdl", self.health);
	}
	else
	{
		ThrowHead ("progs/qtgib3.mdl", self.health);
	}

	if (random() > 0.5)
	{
		ThrowGib ("progs/gib1.mdl", self.health);
	}
	else
	{
		ThrowGib ("progs/qtgib1.mdl", self.health);
	}


	if (random() > 0.5)
	{
		ThrowGib ("progs/gib2.mdl", self.health);
	}
	else
	{
		ThrowGib ("progs/qtgib2.mdl", self.health);
	}


	ThrowGib ("progs/gib3.mdl", self.health);

	ThrowGib ("progs/g_arm.mdl", self.health);
	//ThrowGib ("progs/g_arm.mdl", self.health);
	ThrowGib ("progs/g_boot.mdl", self.health);
	ThrowGib ("progs/g_eye.mdl", self.health);
	//ThrowGib ("progs/g_eye.mdl", self.health);
	//ThrowGib ("progs/g_fore.mdl", self.health);
	ThrowGib ("progs/g_fore.mdl", self.health);
	ThrowGib ("progs/g_leg.mdl", self.health);

	self.deadflag = DEAD_DEAD;

	if (damage_attacker.classname == "teledeath")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

	if (damage_attacker.classname == "teledeath2")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

	if (random() < 0.5)
		sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	else
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
	if (pk_xsound) pk_player_sound(6); // NOTE --- only functional extra sound because the files exist for this
};

// called from player die

void() PK_PlayerDie =
{
	local	float	i;

	self.items = self.items - (self.items & IT_INVISIBILITY);

	self.invisible_finished = 0;	// don't die as eyes
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.copb_timeout = 0;
	self.modelindex = modelindex_player;	// don't use eyes

	self.pkplus_actortype = 0; // Cataboligne 8.12.9 purify - pk artifacts

	self.deadflag = DEAD_DYING;
	self.movetype = MOVETYPE_TOSS;

	self.weaponmodel = "";

	if (self.grap_cornerchainNext)	// Grappling harpoon is out there, remove...
	{
		grap_remove(self);
	}

	if (self.bolt_conduitTimeout > time) // it's the conduit time for this player...
	{
	  local entity flame;

		setorigin(self, self.origin + '0 0 10');
		setmodel (self, "progs/fryguy.mdl");

		self.skin = 0;

	  // Go up in flames...
	  flame = spawn();
	  flame.owner = self;
	  flame.movetype = MOVETYPE_FLYMISSILE;
	  flame.velocity = '0 0 25';
	  flame.solid = SOLID_NOT;
	  flame.classname = "fire";
	  flame.origin = self.origin - '0 0 15';
	  flame.think = bolt_s_explode1;
	  flame.nextthink = time;
	  setmodel (flame, "progs/s_explod.spr");
	  setsize (flame, '0 0 0', '0 0 0');

		player_conduitJerk();
		return;
	}

	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.view_ofs = '0 0 -8';


	if (deathmatch || coop)
		DropBackpack();

	if (self.velocity_z < 10)
		self.velocity_z = self.velocity_z + random()*300;

	if (self.health < -40 || (!XENV && pointcontents(self.origin) == CONTENT_LAVA)) // TEST - new feature, need full height test
	{
		GibPlayer();
		return;
	}

	DeathSound();

	self.angles_x = 0;
	self.angles_z = 0;

	if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_AXE)
	{
		player_die_ax1();
		return;
	}

// PAINKEEP commented out cas temp1 is now used in the Hub system.
//	i = cvar("temp1");
//	if (!i)
		i = 1 + floor(random()*6);

	if (i == 1)
		player_diea1();
	else if (i == 2)
		player_dieb1();
	else if (i == 3)
		player_diec1();
	else if (i == 4)
		player_died1();
	else
		player_diee1();
};
