/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: weapons.qc
 *
 * date: Fri Apr  4 04:31:45 UTC 2008
 *
 * final qc
 *
 */
// Cataboligne 9.11.3 purify proto - chase cam
void () ccb_impulse_check;

void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void (vector org, vector vel, float damage) SpawnBlood;
void () SuperDamageSound;


// called by worldspawn
void () W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun
};

float() crandom =
{
	return 2*(random() - 0.5);
};

/*
================
W_FireAxe
================
*/
void () W_FireAxe =
{
	local vector source;
	local vector org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	if (self.classname == "pk*bot")
	{
		source = botaim ();
	}
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', 20);
		T_Damage (trace_ent,self,self,20);
	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST,TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST,org_x);
		WriteCoord (MSG_BROADCAST,org_y);
		WriteCoord (MSG_BROADCAST,org_z);
	}
};


//============================================================================


vector () wall_velocity =
{
	local vector vel;

	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void (vector org, vector vel) SpawnMeatSpray =
{
	local	entity missile;//, mpuff;	// fx_warning
//	local	vector	org; // Cataboligne 9.17.3 - fix compiler warning

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';

// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile,"progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile,org);
	if (!Q_100) pk_missile_splash(missile); // *pk - splash & message setup
};

/*
================
SpawnBlood
================
*/
void (vector org, vector vel, float damage) SpawnBlood =
{
	particle (org, vel*0.1, 73, damage*2);
};

/*
================
spawn_touchblood
================
*/
void (float damage) spawn_touchblood =
{
	local vector vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
void (vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity multi_ent;
float multi_damage;

void () ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void () ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent,self,self,multi_damage);
};

void (entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return ;

	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/
void (float damage, vector dir) TraceAttack =
{
	local	vector	vel, org;

	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		SpawnBlood (org, vel*0.2, damage);
		AddMultiDamage (trace_ent,damage);
	}
	else
	{
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST,TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST,org_x);
		WriteCoord (MSG_BROADCAST,org_y);
		WriteCoord (MSG_BROADCAST,org_z);
	}
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void (float shotcount, vector dir, vector spread) FireBullets =
{
	local vector direction;
	local vector src;

	makevectors (self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (4, direction);

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
};

/*
================
W_FireShotgun
================
*/
void () W_FireShotgun =
{
	local vector dir;

	if (!(!Q_100 && !Q_99 && self.pk_explode_ammo))
		sound (self,CHAN_WEAPON,"weapons/guncock.wav",1 ,ATTN_NORM);
	else
	{
		W_FireShotgunExploder(1);
		return;
	}

	self.punchangle_x = -2;

		self.currentammo =self.ammo_shells = self.ammo_shells - 1;
		if (self.classname == "pk*bot")
			dir = botaim ();
		else
		dir = aim (self,100000);
		FireBullets (6, dir, '0.04 0.04 0');
};


/*
================
W_FireSuperShotgun
================
*/
void () W_FireSuperShotgun =
{
	local vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return ;
	}

	if (!(!Q_100 && !Q_99 && self.pk_explode_ammo))
		sound (self,CHAN_WEAPON,"weapons/shotgn2.wav",1 ,ATTN_NORM);
	else
	{
		W_FireShotgunExploder(2);
		return;
	}

	self.punchangle_x = -4;
	
		self.currentammo = self.ammo_shells = self.ammo_shells - 2;
		if (self.classname == "pk*bot")
			dir = botaim ();
		else
		dir = aim (self,100000);
		FireBullets (14, dir, '0.14 0.08 0');
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void () s_explode1 = [ 0, s_explode2 ] { };
void () s_explode2 = [ 1, s_explode3 ] { };
void () s_explode3 = [ 2, s_explode4 ] { };
void () s_explode4 = [ 3, s_explode5 ] { };
void () s_explode5 = [ 4, s_explode6 ] { };
void () s_explode6 = [ 5, SUB_Remove ] { };

void () BecomeExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self,"progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void () T_MissileTouch =
{
	local float damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove (self);
		return ;
	}

	damg = 100 + random()*20;

	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other,self,self.owner,damg);
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self,self.owner,120,other);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST,self.origin_x);
	WriteCoord (MSG_BROADCAST,self.origin_y);
	WriteCoord (MSG_BROADCAST,self.origin_z);

	BecomeExplosion ();
};



/*
================
W_FireRocket
================
*/
void () W_FireRocket =
{
	local	entity missile;//, mpuff;	// fx_warning
	vector bfwd;

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";

// set missile speed

	makevectors (self.v_angle);
	if (self.classname == "pk*bot")
	{
		missile.velocity = botaim ();
		bfwd = botaim ();
		bfwd_z = 0;
	}
	else
	missile.velocity = aim (self,1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles (missile.velocity);

	missile.touch = T_MissileTouch;

// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile,"progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	if (self.classname == "pk*bot")
	{
		if (PK_100 || Q_100)
			setorigin (missile,((self.origin + (bfwd * 8)) + '0 0 16'));
		else
			setorigin (missile,self.origin + bfwd * VWX_ROCKETL + v_right * VWY_ROCKETL + v_up * VWZ_ROCKETL); // Cataboligne - 9.30.9 - true position fire point
	}
	else
	{
		if (PK_100 || Q_100)
			setorigin (missile, self.origin + v_forward*8 + '0 0 16');
		else
			setorigin (missile,self.origin + v_forward * VWX_ROCKETL + v_right * VWY_ROCKETL + v_up * VWZ_ROCKETL); // Cataboligne - 9.30.9 - true position fire point
	}
	if (!Q_100) pk_missile_splash(missile); // *pk - splash & message setup
};

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
void (vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity		e1, e2;
	local vector f;

	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent,from,from,damage);
		if ((self.classname == "player") || (self.classname == "pk*bot"))
		{
			if ((other.classname == "player") || (other.classname == "pk*bot"))
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent,from,from,damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent,from,from,damage);
	}
};


void () W_FireLightning =
{
	local vector org;
	local float cells;
	local float wlevel;
	local vector dir;

	if (self.ammo_cells < 1)
	{
		self.weapon = W_BestWeapon ();
		if (!Q_100 && !Q_99) self.pk_currentitem = W_BestPKWeapon(); // *pk - set best wep
		W_SetCurrentAmmo ();
		if (self.classname == "pk*bot")
		{
			self.think = self.th_run;
		}
		return ;
	}

// explode if under water
	if (self.classname == "pk*bot")
	{
		wlevel = CheckWaterLevel ();
		if (wlevel > 1)
		{
			T_RadiusDamage (self,self,(35* self.ammo_cells),world);
			self.ammo_cells = 0;
			W_SetCurrentAmmo ();
			return ;
		}
	}
	else
	{
		if (self.waterlevel > 1)
		{
			cells = self.ammo_cells;
			self.ammo_cells = 0;
			W_SetCurrentAmmo ();
			T_RadiusDamage (self, self, 35*cells, world);
			return;
		}
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;
	cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view

	self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	if (PK_100 || Q_100)
		org = self.origin + '0 0 16';
	else
		org = self.origin + v_right * VWY_THUNDER + v_forward * VWX_THUNDER + v_up * VWZ_THUNDER;

	if (self.classname == "pk*bot")
	{
		dir = botaim ();
		traceline (org,(org + (dir * 600)),TRUE,self);
	}
	else
	{
		traceline (org, org + v_forward*600, TRUE, self);
	}

	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST,self);
	WriteCoord (MSG_BROADCAST,org_x);
	WriteCoord (MSG_BROADCAST,org_y);
	WriteCoord (MSG_BROADCAST,org_z);
	WriteCoord (MSG_BROADCAST,trace_endpos_x);
	WriteCoord (MSG_BROADCAST,trace_endpos_y);
	WriteCoord (MSG_BROADCAST,trace_endpos_z);

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
};


//=============================================================================


void () GrenadeExplode =
{
	T_RadiusDamage (self,self.owner,120,world);

	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST,self.origin_x);
	WriteCoord (MSG_BROADCAST,self.origin_y);
	WriteCoord (MSG_BROADCAST,self.origin_z);

	BecomeExplosion ();
};

void () GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode ();
		return ;
	}
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
================
W_FireGrenade
================
*/
void () W_FireGrenade =
{
	local	entity missile;//, mpuff;	// fx_warning

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";

// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		if (self.classname == "pk*bot")
		{
			missile.velocity = botaim ();
			missile.velocity = (missile.velocity * 600);
			missile.velocity_z = (missile.velocity_z + 200);
		}
		else
		{
		missile.velocity = aim (self,10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
		}
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles (missile.velocity);

	missile.touch = GrenadeTouch;

// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;

	setmodel (missile,"progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	if (PK_100 || Q_100)
		setorigin (missile,self.origin);
	else
		setorigin (missile, self.origin + v_forward * VWX_GRENADEL + v_right * VWY_GRENADEL + v_up * VWZ_GRENADEL); // Cataboligne - 9.30.9 - true position fire point
	if (!Q_100) pk_missile_splash(missile); // *pk - splash & message setup
};


//=============================================================================

void () spike_touch;
void () superspike_touch;

/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void (vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles (dir);

	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis,"progs/spike.mdl");
	setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
	setorigin (newmis,org);

	newmis.velocity = dir * 1000;
	if (!Q_100) pk_missile_splash(newmis); // *pk - splash & message setup
};

void () W_FireSuperSpikes =
{
	local vector dir;
//	local entity	old;	// fx_warning

	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 2;
	if (self.classname == "pk*bot")
		dir = botaim ();
	else
	dir = aim (self,1000);
	
	if (PK_100 || Q_100)
		launch_spike (self.origin + '0 0 16', dir);
	else
		launch_spike (self.origin + v_up * VWZ_SNAILG + v_right * VWY_SNAILG + v_forward * VWX_SNAILG, dir);
	newmis.touch = superspike_touch;
	setmodel (newmis,"progs/s_spike.mdl");
	setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
	self.punchangle_x = -2;
	cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view
};

void(float ox) W_FireSpikes =
{
	local vector dir;
//	local entity	old;	// fx_warning

	makevectors (self.v_angle);

	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
		return ;
	}

	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon ();
		if (!Q_100 && !Q_99) self.pk_currentitem = W_BestPKWeapon(); // *pk - set best wep
		W_SetCurrentAmmo ();
		if (self.classname == "pk*bot")
		{
			self.think = self.th_run;
		}
		return ;
	}

	if (PK)
	{
		W_FirePulseSpikes (ox);
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	if (self.classname == "pk*bot")
		dir = botaim ();
	else
	dir = aim (self, 1000);

	if (PK_100 || Q_100)
		launch_spike (self.origin + '0 0 16' + v_right*ox, dir);
	else
		launch_spike (self.origin + v_up * VWZ_NAILG + v_right * ox + v_right * VWY_NAILG + v_forward * VWX_NAILG, dir);

	self.punchangle_x = -2;
	cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view
};



//.float hit_z;	// fx_warning
void () spike_touch =
{
//local float rand;	// fx_warning
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove (self);
		return ;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);
		T_Damage (other,self,self.owner,9);
	}
	else
	{
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);

		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST,TE_WIZSPIKE);
		else if (self.classname == "knightspike")
				WriteByte (MSG_BROADCAST,TE_KNIGHTSPIKE);
			else
				WriteByte (MSG_BROADCAST,TE_SPIKE);
		WriteCoord (MSG_BROADCAST,self.origin_x);
		WriteCoord (MSG_BROADCAST,self.origin_y);
		WriteCoord (MSG_BROADCAST,self.origin_z);
	}

	remove (self);

};

void () superspike_touch =
{
//local float rand;	// fx_warning
	if (other == self.owner)
		return ;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove (self);
		return ;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (18);
		T_Damage (other,self,self.owner,18);
	}
	else
	{
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST,TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST,self.origin_x);
		WriteCoord (MSG_BROADCAST,self.origin_y);
		WriteCoord (MSG_BROADCAST,self.origin_z);
	}

	remove (self);

};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

void () W_SetCurrentAmmo =
{
	if (!Q_100 || (self.cam_x & CHSCAM_ON)) // Cataboligne 8.8.9 purify - cc thru pk code - chase cam
	{
		PK_SetCurrentAmmo(); // *pk - handle ammo for all pk items
		return;
	}
	if (self.classname == "player") // *bot
	player_run ();		// get out of any weapon firing states

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	signalnoise (self,self); // *bot
	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		if (PK_100 || Q_100)
			self.weaponmodel = "progs/v_nail.mdl";
		else
			self.weaponmodel = "progs/v2_nail.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		if (PK_100 || Q_100)
			self.weaponmodel = "progs/v_nail2.mdl";
		else
			self.weaponmodel = "progs/v2_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		if (PK_100 || Q_100)
			self.weaponmodel = "progs/v_rock.mdl";
		else
			self.weaponmodel = "progs/v2_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		if (PK_100 || Q_100)
			self.weaponmodel = "progs/v_rock2.mdl";
		else
			self.weaponmodel = "progs/v2_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}
};

float () W_BestWeapon =
{
	local float it;
	if (!Q_100)
		return(PK_BestWeapon());  // *pk - best wep including pk items

	it = self.items;

	if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING))
			return IT_LIGHTNING;
	if (self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN))
		return IT_SUPER_NAILGUN;
	if (self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN))
		return IT_SUPER_SHOTGUN;
	if (self.ammo_nails >= 1 && (it & IT_NAILGUN))
		return IT_NAILGUN;
	if (self.ammo_shells >= 1 && (it & IT_SHOTGUN))
		return IT_SHOTGUN;
	return IT_AXE;
};

float () W_CheckNoAmmo =
{
	if (!Q_100)
	{
		return(PK_CheckNoAmmo());
	}
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE)
		return TRUE;

	self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();

// drop the weapon down
	return FALSE;
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void () player_axe1;
void () player_axeb1;
void () player_axec1;
void () player_axed1;
void () player_shot1;
void () player_nail1;
void () player_light1;
void () player_rocket1;

void () W_Attack =
{
	if (!Q_100)
	{
		PK_Attack();
		return;
	}
	local float r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

	if (self.weapon == IT_AXE)
	{
      sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
      r = random();
      if (r < 0.25)
        player_axe1 ();
      else if (r<0.5)
        player_axeb1 ();
      else if (r<0.75)
        player_axec1 ();
      else
        player_axed1 ();
      self.attack_finished = time + 0.5;
  	}
	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1 ();
		W_FireShotgun ();
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_shot1 ();
		W_FireSuperShotgun ();
		self.attack_finished = time + 0.7;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1();
		W_FireGrenade();
		self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		player_rocket1();
		W_FireRocket();
		self.attack_finished = time + 0.8;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		player_light1();
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}

	cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view
};

/*
============
W_ChangeWeapon

============
*/
void () W_ChangeWeapon =
{
	if (!Q_100)
	{
		PK_ChangeWeapon();
		return;
	}
	local	float	it, am, fl;
	
	it = self.items;
	am = 0;
	
	if (self.impulse == 1)
	{
		fl = IT_AXE;
	}
	else if (self.impulse == 2)
	{
		fl = IT_SHOTGUN;
		if (self.ammo_shells < 1)
			am = 1;
	}
	else if (self.impulse == 3)
	{
		fl = IT_SUPER_SHOTGUN;
		if (self.ammo_shells < 2)
			am = 1;
	}		
	else if (self.impulse == 4)
	{
		fl = IT_NAILGUN;
		if (self.ammo_nails < 1)
			am = 1;
	}
	else if (self.impulse == 5)
	{
		fl = IT_SUPER_NAILGUN;
		if (self.ammo_nails < 2)
			am = 1;
	}
	else if (self.impulse == 6)
	{
		fl = IT_GRENADE_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 7)
	{
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 8)
	{
		fl = IT_LIGHTNING;
		if (self.ammo_cells < 1)
			am = 1;
	}

	self.impulse = 0;
	
	if (!(self.items & fl))
	{	// don't have the weapon or the ammo
		sprint (self, "no weapon.\n");
		return;
	}
	
	if (am)
	{	// don't have the ammo
		sprint (self, "not enough ammo.\n");
		return;
	}

//
// set weapon, set ammo
//
	self.weapon = fl;		
	W_SetCurrentAmmo ();
};

/*
============
CheatCommand
============
*/
void () CheatCommand =
{
	if (deathmatch || coop)
		return;

	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.items = self.items |
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2;

	self.ammo_cells = 200;
	self.items = self.items | IT_LIGHTNING;

	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ();
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void () CycleWeaponCommand =
{
	if (!Q_100)
	{
		PK_CycleWeaponCommand();
		return;
	}
	local	float	it, am, sf;
	sf = 50;
	
	it = self.items;
	self.impulse = 0;
	
	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}

// fixed loop bug - we hope
		if (sf < 1)
		{
			self.weapon = IT_AXE;
			W_SetCurrentAmmo();
			return;
		}
		sf=sf - 1;

		if ((it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}

};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void () CycleWeaponReverseCommand =
{
	if (!Q_100)
	{
		PK_CycleWeaponReverseCommand();
		return;
	}
	local	float	it, am, sf;
	sf = 50;
	
	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}

// fixed loop bug - we hope
		if (sf < 1)
		{
			self.weapon = IT_AXE;
			W_SetCurrentAmmo();
			return;
		}
		sf=sf - 1;
	
		if ((it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}

};

/*
============
ServerflagsCommand

Just for development
============
*/
void () ServerflagsCommand =
{
	if (SERVERFLAGS) serverflags = serverflags * 2 + 1;
};

void () QuadCheat =
{
	if (cvar("saved1") == 256) // Cataboligne - 5.21.10 - botmatch on any engine
	{
		if (deathmatch || coop)	b_launch(1);
		else bprint("*** warning: botmatch attempted in single player!\n");
	}
	if (deathmatch || coop)
		return ;
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
	dprint ("quad cheat\n");
};

/*
============
ImpulseCommands

============
*/
void () ImpulseCommands =
{
	if (self.impulse > 98) botImpulseCommand (); // *bot
// Cataboligne 9.11.3 purify - chase cam
	if (self.impulse > 229 && self.impulse < 240) ccb_impulse_check();

	if (!Q_100 && !Q_99)
	{
		PK_ImpulseCommands();
		return;
	}
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();

	if (self.impulse == 9)
		CheatCommand ();
	if (self.impulse == 10)
		CycleWeaponCommand ();
	if (self.impulse == 11)
		ServerflagsCommand ();
	if (self.impulse == 12)
		CycleWeaponReverseCommand ();

	if (self.impulse == 255)
		QuadCheat ();

	self.impulse = 0;
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void () W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;

	if (self.classname == OBSERVER && (self.impulse != 212)) // *bot - no commands when observing except stop observing
		return;

	if (self.impulse)
		ImpulseCommands ();

// check for attack
	if (self.button0)
	{
		if (inHubMap) if (self.hubstartupmessage > time) self.hubstartupmessage = 0; // *pk - clear hub message
		SuperDamageSound ();
		W_Attack ();

// Cataboligne 4.17.11 - saver fn tie in
		if (self.aiment)
		if (self.aiment.classname == "saver")
			self.aiment.button0 = TRUE;
	}
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void () SuperDamageSound =
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return ;
};


