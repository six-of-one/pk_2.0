// pk weapon code moved here for adaptive code 

// exploding shotgun shells - brilliant really, who thought this up?	and would it really work - I think this needs to be on mythbusters

void()	es_explode1	=	[0,		es_explode2] {};
void()	es_explode2	=	[1,		es_explode3] {};
void()	es_explode3	=	[2,		es_explode4] {};
void()	es_explode4	=	[3,		es_explode5] {};
void()	es_explode5	=	[4,		SUB_Remove] {};

void() BecomeShellExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;

	if (random() < 0.5)
	{
		setmodel (self, "progs/x_explo1.spr");
	}
	else
	{
		setmodel (self, "progs/x_explo2.spr");
	}

	self.solid = SOLID_NOT;
	es_explode1 ();
};

void() explodeAttack =
{
	local float damg, i;
	local vector dir;

	damg = 12 + random() * 16;

	if (self.enemy.health)
	{
		T_Damage (self.enemy, self, self.owner, damg);
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 28, self.enemy);

	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	i = (random() * 15) + 1;

	while(i > 0)
	{
		dir_x = -50 + (random() * 100);
	  dir_y = -50 + (random() * 100);
	  dir_z = -25 + (random() * 50);
		particle(self.origin, dir, 225, 3);
	  i = i - 1;
	}

	BecomeShellExplosion ();
};

void(float damage, vector dir) TraceExplodeAttack =
{
	local entity explode;

	explode = spawn();

	explode.origin = trace_endpos - dir * 4;
	explode.owner = self;
	explode.enemy = trace_ent;
	explode.classname = "ExplodeShellsAttack";
	explode.weapon = self.weapon;
	explode.nextthink = time + 0.10 + (random() * 0.75);
	explode.think = explodeAttack;
};

void(float shotcount, vector dir, vector spread) FireExplodeShells =
{
	local	vector direction;
	local	vector	src;
	local float damage;

	if (shotcount >= 2)
	{
		damage = 2;
	}
	else
	{
		damage = 1;
	}

	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	while (shotcount > 0)
	{
		direction = dir + crandom() * spread_x * v_right + crandom() * spread_y * v_up;

		traceline (src, src + direction * 2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceExplodeAttack (damage, direction);

		shotcount = shotcount - 1;
	}
};

// called from W_FireShotgun && W_FireSuperShotgun - fire a shotgun with exploding shot
// shots is number of shots - 1 for shotgun & 2 for SS

void(float shots) W_FireShotgunExploder =
{
	local vector dir;

	self.punchangle_x = -2 * shots;

	self.currentammo = self.pk_explode_ammo = self.pk_explode_ammo - shots; // no inf for this! ammo_con(shots, self, "");

	if (self.classname == "pk*bot")
		dir = botaim ();
	else
	dir = aim (self, 100000);

	if (shots == 1)
	{
		sound (self, CHAN_WEAPON, "weapons/explode/expfire1.wav", 1, ATTN_NORM);
		FireExplodeShells((random() * 3) + 3, dir, '0.09 0.06 0');
	}
	else
	{
		sound (self, CHAN_WEAPON, "weapons/explode/expfire2.wav", 1, ATTN_NORM);
		FireExplodeShells((random() * 4) + 6, dir, '0.14 0.08 0');
	}

// if we run of out explode, switch to normal shells.
	if (self.pk_explode_ammo == 0)
	{
		self.currentammo = self.ammo_shells;
		W_SetCurrentAmmo();
	}
};

// called below - pulse spike code

/*
	rebound the pulse spike
*/
void() pulse_rebound =
{
	self.velocity = normalize(self.velocity) * 1000;
	self.movetype = MOVETYPE_FLYMISSILE;
	self.angles = vectoangles(self.velocity);
	self.think = SUB_Remove;
	self.nextthink = self.ltime;

	// we want to hurt the owner now...
	self.owner = world;
};

void() pulse_touch =
{
	local float rand;

	// owner protected? hahahaha
	//if (other == self.owner)
	//	return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
	  spawn_touchblood (27);
		self.owner = self.theowner;
	  T_Damage (other, self, self.owner, 27);
	}
	else
	{
		// play ricochet sound
		rand = random() * 100;
		if (rand < 33)
			sound (self, CHAN_AUTO, "weapons/pulse/ric_1.wav", 1, ATTN_NORM);
		else if (rand < 66)
			sound (self, CHAN_AUTO, "weapons/pulse/ric_2.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_AUTO, "weapons/pulse/ric_3.wav", 1, ATTN_NORM);

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);

		// rebound
		self.movetype = MOVETYPE_BOUNCE;
		self.think = pulse_rebound;
		self.ltime = self.nextthink;
		self.nextthink = time + 0.1;
		return;
	}

	remove(self);
};

// called from W_FireSpikes	- fire a pulse spike

void(float ox) W_FirePulseSpikes =
{
	local vector	dir;

	makevectors(self.v_angle);
	sound (self, CHAN_WEAPON, "weapons/pulse/pulse_1.wav", 1, ATTN_NORM);
	//self.attack_finished = time + 0.4;
	self.currentammo = self.ammo_nails = self.ammo_nails - ammo_con(1, self, "");
	if (self.classname == "pk*bot")
		dir = botaim ();
	else
	dir = aim (self, 1000);
	if (PK_100 || Q_100)
		launch_spike (self.origin + ' 0 0 16' + v_right*ox, dir);
	else
		launch_spike (self.origin + v_up * VWZ_PNAILG + v_right * (ox / 2.5) + v_right * VWY_PNAILG + v_forward * VWX_PNAILG, dir);
	newmis.touch = pulse_touch;
	newmis.theowner = self;
	setmodel (newmis, "progs/pnail.mdl");
	newmis.angles = vectoangles(dir);
	setsize (newmis, ' 0 0 0', ' 0 0 0');
	self.punchangle_x = -2;
	cam_punch(); // Cataboligne - 5.13.10 - cam purify - nullify fire punchangle if in cam view

	// time limit
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 2.0;
};

// called from W_SetCurrentAmmo - diverts

void() PK_SetCurrentAmmo =
{
	local float wchanged;

	wchanged = FALSE;

	if (self.classname == "player") // *bot - dont set run frames
	player_run ();		// get out of any weapon firing states

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	if (self.classname == OBSERVER)
	{
		self.currentammo = 0;
		self.weapon = 0;
		self.weaponframe = 0;
		self.weaponmodel = "";
		self.eweapon = world;
		return;
	}

	// PAINKEEP_PREVWEAPON_START
	if ((self.prevweapon != self.weapon) || (self.pkprevweapon != self.pk_currentitem) || (self.forcewchange == 1))
	{
		self.lastweapon = self.prevweapon;
		self.prevweapon = self.weapon;
		self.pklastweapon = self.pkprevweapon;
		self.pkprevweapon = self.pk_currentitem;
		self.forcewchange = FALSE;

		wchanged = TRUE;
		ominous_hum("", 1);
	}

	wchanged = wchanged & ((self.items & IT_INVISIBILITY) || (self.cam_x & CHSCAM_ON));
	if (DARKPLACES && cvar("chase_active")) wchanged = TRUE;

	if (wchanged)
		sprint(self, "You have selected the ");

	if (self.eweapon) // display got first
	{
		if (wchanged)
		{
			sprint(self, self.eweapon.netname);
			sprint(self, "\n");
		}
		wchanged = FALSE;
	}

	if (self.weapon == IT_AXE)
	{
		if (self.pk_currentitem == PK_IT_AXE)
		{
			self.currentammo = 0;
			self.weaponmodel = "progs/v_axe.mdl";
			self.weaponframe = 0;
			if (wchanged)
				sprint(self, "Axe\n");
		}
		else if (self.pk_currentitem == PK_IT_GRAVITYWELL)
		{
			self.currentammo = self.pk_gravitywellammo;
			self.weaponmodel = "progs/v_cube.mdl";
			self.weaponframe = 0;
			if (wchanged)
				sprint(self, "Gravity Well\n");
		}
		else if (self.pk_currentitem == PK_IT_TURRET)
		{
			self.currentammo = self.pk_turretammo;
			self.weaponmodel = "progs/v_turret.mdl";
			self.weaponframe = 0;
			if (wchanged)
				sprint(self, "AutoSentry\n");
		}
		else if (self.pk_currentitem == PK_IT_CANPAB)
		{
			self.currentammo = self.pk_canpabammo;
			self.weaponmodel = "progs/v_beans.mdl";
			self.weaponframe = 0;
			if (wchanged)
				sprint(self, "Can of Pork & Beans\n");
		}
		else if (self.pk_currentitem == PK_IT_GRAPGUN)
		{
// GRAPPLING_START
			self.currentammo = 1;
			if (PK_100 || Q_100)
				self.weaponmodel = "progs/v_harp.mdl";
			else
				self.weaponmodel = "progs/v2_harp.mdl";

			if (self.grap_cornerchainNext != world)
			{
				self.weaponframe = 8;
			}
			else
			{
				self.weaponframe = 0;
			}
			if (wchanged)
				sprint(self, "Harpoon Gun\n");
		}
		else if (self.pk_currentitem == PK_IT_BEARTRAP)
		{
			self.currentammo = self.pk_beartrapammo;
			self.weaponmodel = "progs/v_bear.mdl";
			self.weaponframe = 0;
			if (wchanged)
				sprint(self, "Beartrap\n");
		}
		else if (self.pk_currentitem == PK_IT_AIRGUN)
		{
			self.currentammo = 1;
			self.weaponmodel = "progs/v_airgun.mdl";
			self.weaponframe = 0;
			if (wchanged)
				sprint(self, "AirFist\n");
		}
// BOLT_START
		else if (self.pk_currentitem == PK_IT_CLIGHT)
		{
			self.currentammo = self.ammo_cells;
			if (self.bolt_changeModelTimeout < time)
			{
				self.weaponmodel = "progs/v_cl_off.mdl";
			}
			else
			{
				self.weaponmodel = "progs/v_cl_on.mdl";
			}
			self.weaponframe = 0;
			self.items = self.items | IT_CELLS;
			if (wchanged)
				sprint(self, "Chain Thunderbolt\n");
		}

// Cataboligne 8.12.9 purify - pk artifacts
		if (self.pk_currentitem == PKPLUS_IT_EGO)
		{
			self.currentammo = self.pkplus_egoammo;
			self.weaponmodel = "progs/v_ego.mdl";
			self.weaponframe = 0;
			if (wchanged)
				sprint (self,"Ego\n");
		}
		else if (self.pk_currentitem == PKPLUS_IT_TOMB)
		{
			self.currentammo = self.pkplus_tombammo;
			self.weaponmodel = "progs/v_tomb.mdl";
			self.weaponframe = 0;
			if (wchanged)
				sprint (self,"Tomb\n");
		}
		else if (self.pk_currentitem == PKPLUS_IT_ACTOR)
		{
			if (self.pkplus_actorskin == PKPLUS_ACTORQUAD)
			{
				self.weaponmodel = "progs/v_actorb.mdl";
			}
			else
//		if (self.pkplus_actorskin == PKPLUS_ACTORPENT)
			{	
					self.weaponmodel = "progs/v_actorr.mdl";
			}
			self.currentammo = self.pkplus_actorammo;
			self.weaponframe = 0;
			if (wchanged)
				sprint (self,"Actor\n");
		}
		else if (self.pk_currentitem == PKPLUS_IT_PHONE)
		{
			self.currentammo = self.pkplus_phoneammo;
			self.weaponmodel = "progs/v_phone.mdl";
			self.weaponframe = 0;
			if (wchanged)
				sprint (self,"Cellular Phone\n");
		}
// end pk_art
	}
	else if (self.weapon == IT_SHOTGUN)
	{
// EXPLODESHELLS_START
		if (self.pk_explode_ammo) {
			self.currentammo = self.pk_explode_ammo;
			self.weaponmodel = "progs/v_eshot.mdl";

		} else {
			self.currentammo = self.ammo_shells;
			if (PK_100 || Q_100)
			self.weaponmodel = "progs/v_shot.mdl";
			else
			self.weaponmodel = "progs/v2_shot.mdl";
		}
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
		if (wchanged)
			sprint(self, "Shotgun\n");
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
// EXPLODESHELLS_START
		if (self.pk_explode_ammo) {
			self.currentammo = self.pk_explode_ammo;
			self.weaponmodel = "progs/v_eshot2.mdl";

		} else {
			self.currentammo = self.ammo_shells;
			if (PK_100 || Q_100)
			self.weaponmodel = "progs/v_shot2.mdl";
			else
			self.weaponmodel = "progs/v2_shot2.mdl";
		}
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
		if (wchanged)
			sprint(self, "Super Shotgun\n");
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
// PULSE_GUN_START
		if (PK)
		{
			if (PK_100 || Q_100)
				self.weaponmodel = "progs/v_fnail.mdl";
			else
				self.weaponmodel = "progs/v2_pulsenail.mdl";
		}
		else
		{
			if (PK_100 || Q_100)
				self.weaponmodel = "progs/v_nail.mdl";
			else
				self.weaponmodel = "progs/v2_nail.mdl";
		}
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
		if (wchanged)
			sprint(self, "Pulse Rifle\n");
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
		if (wchanged)
			sprint(self, "Super Nailgun\n");
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
		if (wchanged)
			sprint(self, "Grenade Launcher\n");
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
		if (wchanged)
			sprint(self, "Rocket Launcher\n");
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
		if (wchanged)
			sprint(self, "Thunderbolt\n");
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
		if (wchanged)
			sprint(self, "An Unknown Weapon???\n");
	}

	if (self.eweapon) // set model / ammo
	{
		if (self.eweapon.lip)
		{
			if (self.eweapon.lip == AMMO_BULLETS)
				self.currentammo = self.ammo_bullet;
			else if (self.eweapon.lip == AMMO_SHELLS)
				self.currentammo = self.ammo_shells;
			else if (self.eweapon.lip == AMMO_CELLS)
				self.currentammo = self.ammo_cells;
			else if (self.eweapon.lip == AMMO_NAILS)
				self.currentammo = self.ammo_nails;
			else if (self.eweapon.lip == AMMO_ROCKETS)
				self.currentammo = self.ammo_rockets;
			else if (self.eweapon.lip == AMMO_GRENADES)
				self.currentammo = self.ammo_rockets;
			else if (self.eweapon.lip == AMMO_SLUGS)
				self.currentammo = self.ammo_slug;
			else if (self.eweapon.lip == AMMO_NONE)
				self.currentammo = 1;
		}
		self.weaponframe = 0;
		self.weaponmodel = self.eweapon.weaponmodel;
	}

// Cataboligne 8.8.9 purify - chase cam
	// disable model in chase view
		if ( (self.cam_x & CHSCAM_ON) || self.classname == OBSERVER)
		{
			self.weaponmodel = "";
		}
};

// just to update ammo counts since viswep controls "you have selected" & weaponmodel changes now

void() PK_SetCurrentAmmoOnly =
{
	if (self.classname == "player") // *bot - dont set run frames
	player_run ();		// get out of any weapon firing states

	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));

	if (self.classname == OBSERVER)
	{
		self.currentammo = 0;
		self.weapon = 0;
		self.weaponframe = 0;
		self.weaponmodel = "";
		self.eweapon = world;
		return;
	}

	if (self.weapon == IT_AXE)
	{
		if (self.pk_currentitem == PK_IT_AXE)
		{
			self.currentammo = 0;
			self.weaponframe = 0;
		}
		else if (self.pk_currentitem == PK_IT_GRAVITYWELL)
		{
			self.currentammo = self.pk_gravitywellammo;
			self.weaponframe = 0;
		}
		else if (self.pk_currentitem == PK_IT_TURRET)
		{
			self.currentammo = self.pk_turretammo;
			self.weaponframe = 0;
		}
		else if (self.pk_currentitem == PK_IT_CANPAB)
		{
			self.currentammo = self.pk_canpabammo;
			self.weaponframe = 0;
		}
		else if (self.pk_currentitem == PK_IT_GRAPGUN)
		{
// GRAPPLING_START
			self.currentammo = 1;

			if (self.grap_cornerchainNext != world)
			{
				self.weaponframe = 8;
			}
			else
			{
				self.weaponframe = 0;
			}
		}
		else if (self.pk_currentitem == PK_IT_BEARTRAP)
		{
			self.currentammo = self.pk_beartrapammo;
			self.weaponframe = 0;
		}
		else if (self.pk_currentitem == PK_IT_AIRGUN)
		{
			self.currentammo = 1;
			self.weaponframe = 0;
		}
// BOLT_START
		else if (self.pk_currentitem == PK_IT_CLIGHT)
		{
			self.currentammo = self.ammo_cells;
			self.weaponframe = 0;
			if (self.bolt_changeModelTimeout < time)
			{
				self.weaponmodel = "progs/v_cl_off.mdl";
			}
			else
			{
				self.weaponmodel = "progs/v_cl_on.mdl";
			}
			self.items = self.items | IT_CELLS;
		}

// Cataboligne 8.12.9 purify - pk artifacts
		if (self.pk_currentitem == PKPLUS_IT_EGO)
		{
			self.currentammo = self.pkplus_egoammo;
			self.weaponframe = 0;
		}
		else if (self.pk_currentitem == PKPLUS_IT_TOMB)
		{
			self.currentammo = self.pkplus_tombammo;
			self.weaponframe = 0;
		}
		else if (self.pk_currentitem == PKPLUS_IT_ACTOR)
		{
			if (self.pkplus_actorskin == PKPLUS_ACTORQUAD)
			{
				self.weaponmodel = "progs/v_actorb.mdl";
			}
			else
//		if (self.pkplus_actorskin == PKPLUS_ACTORPENT)
			{	
				self.weaponmodel = "progs/v_actorr.mdl";
			}
			self.currentammo = self.pkplus_actorammo;
			self.weaponframe = 0;
			}
		else if (self.pk_currentitem == PKPLUS_IT_PHONE)
		{
			self.currentammo = self.pkplus_phoneammo;
			self.weaponframe = 0;
		}
// end pk_art
	}
	else if (self.weapon == IT_SHOTGUN)
	{
// EXPLODESHELLS_START
		if (self.pk_explode_ammo) {
			self.currentammo = self.pk_explode_ammo;
			if (!self.eweapon) self.weaponmodel = "progs/v_eshot.mdl";

		} else {
			self.currentammo = self.ammo_shells;
			if (!self.eweapon)
			if (PK_100 || Q_100)
			self.weaponmodel = "progs/v_shot.mdl";
			else
			self.weaponmodel = "progs/v2_shot.mdl";
		}
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
// EXPLODESHELLS_START
		if (self.pk_explode_ammo) {
			self.currentammo = self.pk_explode_ammo;
			if (!self.eweapon) self.weaponmodel = "progs/v_eshot2.mdl";

		} else {
			self.currentammo = self.ammo_shells;
			if (!self.eweapon)
			if (PK_100 || Q_100)
			self.weaponmodel = "progs/v_shot2.mdl";
			else
			self.weaponmodel = "progs/v2_shot2.mdl";
		}
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.items = self.items | IT_NAILS;
		self.weaponframe = 0;
		}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}

	if (self.eweapon)
	{
		if (self.eweapon.lip)
		{
			if (self.eweapon.lip == AMMO_BULLETS)
				self.currentammo = self.ammo_bullet;
			else if (self.eweapon.lip == AMMO_SHELLS)
				self.currentammo = self.ammo_shells;
			else if (self.eweapon.lip == AMMO_CELLS)
				self.currentammo = self.ammo_cells;
			else if (self.eweapon.lip == AMMO_NAILS)
				self.currentammo = self.ammo_nails;
			else if (self.eweapon.lip == AMMO_ROCKETS)
				self.currentammo = self.ammo_rockets;
			else if (self.eweapon.lip == AMMO_GRENADES)
				self.currentammo = self.ammo_rockets;
			else if (self.eweapon.lip == AMMO_SLUGS)
				self.currentammo = self.ammo_slug;
			else if (self.eweapon.lip == AMMO_NONE)
				self.currentammo = 1;
		}
		self.weaponframe = 0;
	}
// Cataboligne 8.8.9 purify - chase cam
	// disable model in chase view
		if ( (self.cam_x & CHSCAM_ON) || self.classname == OBSERVER)
		{
			self.weaponmodel = "";
		}

};

// called from many places

float() W_BestPKWeapon =
{
	if (self.weapon == IT_AXE)
	{
		if (self.waterlevel <= 1 && (self.ammo_cells >= 2 || ammo_con(PK_IT_CLIGHT, self, "wpck")) && (self.pk_items & PK_IT_CLIGHT))
			return PK_IT_CLIGHT;
		if (self.pk_items & PK_IT_AIRGUN)
			return PK_IT_AIRGUN;
	}
	return PK_IT_AXE;
};

// called from various locs

/*
============
HasAmmo

New for PainKeep, makes things a whole lot simplier
============
*/

float(float weaponnum, float pknum) HasAmmo =
{
	local entity e;

	if (weaponnum == IT_AXE)
	{
		if (pknum == PK_IT_CLIGHT)
		{
			if (!ammo_con(pknum, self, "wpck"))
			if (self.ammo_cells < 2)
				return FALSE;
		}
		else if (pknum == PK_IT_GRAVITYWELL)
		{
			if (self.pk_gravitywellammo < 1)
				return FALSE;
		}
		else if (pknum == PK_IT_TURRET)
		{
			if (self.pk_turretammo < 1)
				return FALSE;
		}
		else if (pknum == PK_IT_BEARTRAP)
		{
			if (self.pk_beartrapammo < 1)
				return FALSE;
		}
		else if (pknum == PK_IT_CANPAB)
		{
			if (self.pk_canpabammo < 1)
				return FALSE;
		}

// Cataboligne 8.12.9 purify - pk artifacts
		else if (pknum == PKPLUS_IT_EGO)
		{
			if (self.pkplus_egoammo < 1)
				return FALSE;
		}
		else if (pknum == PKPLUS_IT_TOMB)
		{
			if (self.pkplus_tombammo < 1)
				return FALSE;
		}
		else if (pknum == PKPLUS_IT_ACTOR)
		{
			if (self.pkplus_actorammo < 1)
				return FALSE;
		}
		else if (pknum == PKPLUS_IT_PHONE)
		{
			if (self.pkplus_phoneammo < 1)
				return FALSE;
		}
// end pk_art
	}
	else	if (!ammo_con(weaponnum, self, "wpck"))
	{
		e = vchk(weaponnum, 0, self.vwepent);
		if (e.eweapon) // the selection has eweap code
		{
			if (e.eweapon.lip == AMMO_NONE)
				return TRUE;
			else if (e.eweapon.lip == AMMO_SHELLS)
			{
				if (self.ammo_shells >= e.eweapon.dmg_save)
					return TRUE;
				else
					return FALSE;
			}
			else if (e.eweapon.lip == AMMO_NAILS)
			{
				if (self.ammo_nails >= e.eweapon.dmg_save)
					return TRUE;
				else
					return FALSE;
			}
			else if (e.eweapon.lip == AMMO_BULLETS)
			{
				if (self.ammo_bullet >= e.eweapon.dmg_save)
					return TRUE;
				else
					return FALSE;
			}
			else if (e.eweapon.lip == AMMO_SLUGS)
			{
				if (self.ammo_slug >= e.eweapon.dmg_save)
					return TRUE;
				else
					return FALSE;
			}
			else if (e.eweapon.lip == AMMO_CELLS)
			{
				if (self.ammo_cells >= e.eweapon.dmg_save)
					return TRUE;
				else
					return FALSE;
			}
			else if (e.eweapon.lip == AMMO_ROCKETS)
			{
				if (self.ammo_rockets >= e.eweapon.dmg_save)
					return TRUE;
				else
					return FALSE;
			}
			else if (e.eweapon.lip == AMMO_GRENADES)
			{
				if (self.ammo_rockets >= e.eweapon.dmg_save)
					return TRUE;
				else
					return FALSE;
			}
			else if (e.eweapon.lip)
			{
				if (WARNING) bprint(" *** Warning: eweapon ammo type not recognized.\n");
				return FALSE;
			}
		}
		if (weaponnum == IT_SHOTGUN)
		{
			if (self.ammo_shells < 1 && self.pk_explode_ammo < 1)
				return FALSE;
		}
		else if (weaponnum == IT_SUPER_SHOTGUN)
		{
			if (self.ammo_shells < 2 && self.pk_explode_ammo < 2)
				return FALSE;
		}
		else if (weaponnum == IT_NAILGUN)
		{
			if (self.ammo_nails < 1)
				return FALSE;
		}
		else if (weaponnum == IT_SUPER_NAILGUN)
		{
			if (self.ammo_nails < 2)
				return FALSE;
		}
		else if (weaponnum == IT_GRENADE_LAUNCHER)
		{
			if (self.ammo_rockets < 1)
				return FALSE;
		}
		else if (weaponnum == IT_ROCKET_LAUNCHER)
		{
			if (self.ammo_rockets < 1)
				return FALSE;
		}
		else if (weaponnum == IT_LIGHTNING)
		{
			if (self.ammo_cells < 1)
				return FALSE;
		}
	}

	return TRUE;
};

/*
============
CanSelect

New for PainKeep, makes things a whole lot simplier
============
*/

float(float weaponnum, float pknum) CanSelect =
{
	// First, check that we have the weapon
	if (!self.items & weaponnum)
		return FALSE;

	if (weaponnum == IT_AXE && !(self.pk_items & pknum))
		return FALSE;

	local float am;
	am = HasAmmo(weaponnum, pknum);

	return am;
};


void() pk_special_impulse =
{
	if (self.impulse == 30)
	{
		if (!(self.pk_items & PK_IT_AIRGUN))
			return;

		self.pk_currentitem = PK_IT_AIRGUN;
	}
	else if (self.impulse == 31 || self.impulse == 21 || self.impulse == 22)
	{
		if (!(self.pk_items & PK_IT_GRAPGUN))
			return;

		self.pk_currentitem = PK_IT_GRAPGUN;
	}
	else if (self.impulse == 32)
	{
//		if (!ammo_con(PK_IT_CLIGHT, self, "wpck"))
//		if (self.ammo_cells < 2 || !(self.pk_items & PK_IT_CLIGHT))
		if (!HasAmmo(IT_AXE, PK_IT_CLIGHT) || !(self.pk_items & PK_IT_CLIGHT))
			return;

		self.pk_currentitem = PK_IT_CLIGHT;
	}
	else if (self.impulse == 33)
	{
		if (self.pk_gravitywellammo < 1)
			return;

	 	self.pk_currentInventory = self.pk_currentitem = PK_IT_GRAVITYWELL;
	}
	else if (self.impulse == 34)
	{
		if (self.pk_beartrapammo < 1)
			return;

	 	self.pk_currentInventory = self.pk_currentitem = PK_IT_BEARTRAP;
	}
	else if (self.impulse == 35)
	{
		if (cvar("saved1") == 482 || cvar("saved1") == 483) pk_cphub(); // making a custom hub, 482 = hub
		if (self.pk_turretammo < 1)
			return;

		self.pk_currentInventory = self.pk_currentitem = PK_IT_TURRET;
	}
	else if (self.impulse == 36)
	{
		if (self.pk_canpabammo < 1)
			return;

		self.pk_currentInventory = self.pk_currentitem = PK_IT_CANPAB;
	}
	else if (self.impulse == 37)
	{
		self.pk_currentInventory = self.pk_currentitem = PK_IT_AXE;
	}
	else if (self.impulse == USER_IMPULSE)
	{
		if (!self.admin)
			self.admin = USER_MENU;
		return;
	}
	else
	{ // print the current inventory items out.
		msg_entity = self;
		WriteByte(MSG_ONE, SVC_CENTERPRINT);

		// '\n\n\n\n\nYou Have:\nGravity Wells : '
		WriteB3(MSG_ONE, 657930);
		WriteB3(MSG_ONE, 5835274);
		WriteB3(MSG_ONE, 2127215);
		WriteB3(MSG_ONE, 7758152);
		WriteB3(MSG_ONE, 670309);
		// '--------\n'
		WriteB3(MSG_ONE, 2960685);
		WriteB3(MSG_ONE, 2960685);
		WriteB3(MSG_ONE, 666925);
		
		WriteB3(MSG_ONE, 6386247);
		WriteB3(MSG_ONE, 7629174);
		WriteB3(MSG_ONE, 5709945);
		WriteB3(MSG_ONE, 7105637);
		WriteB3(MSG_ONE, 3809395);
		WriteB3(MSG_ONE, 32);

		WriteBFloat(MSG_ONE, self.pk_gravitywellammo);

		// '										 '
		WriteB3(MSG_ONE, 2105376);
		WriteB3(MSG_ONE, 2105376);
		WriteB3(MSG_ONE, 2105376);
//		WriteB3(MSG_ONE, 2105376);

		// '\nAutoSentry's : '
		WriteB3(MSG_ONE, 7684362);
		WriteB3(MSG_ONE, 5468020);
		WriteB3(MSG_ONE, 7630437);
		WriteB3(MSG_ONE, 2586994);
		WriteB3(MSG_ONE, 3809395);
		WriteB3(MSG_ONE, 32);

		WriteBFloat(MSG_ONE, self.pk_turretammo);

		// '										 '
		WriteB3(MSG_ONE, 2105376);
		WriteB3(MSG_ONE, 2105376);
		WriteB3(MSG_ONE, 8224);
//		WriteB3(MSG_ONE, 2105376);
//		WriteB3(MSG_ONE, 2105376);

		// '\nCan Of Pork & Beens : '
		WriteB3(MSG_ONE, 6374154);
		WriteB3(MSG_ONE, 5185646);
		WriteB3(MSG_ONE, 5251174);
		WriteB3(MSG_ONE, 7041647);
		WriteB3(MSG_ONE, 2106912);
		WriteB3(MSG_ONE, 6645058);
		WriteB3(MSG_ONE, 2126702);
		WriteB3(MSG_ONE, 8250);

		WriteBFloat(MSG_ONE, self.pk_canpabammo);

		// '										 '
		WriteB3(MSG_ONE, 2105376);
		WriteB3(MSG_ONE, 2105376);
		WriteB3(MSG_ONE, 2105376);
		WriteB3(MSG_ONE, 2105376);
	WriteB3(MSG_ONE, 2105376);

		// '\nBear Traps : '
		WriteB3(MSG_ONE, 6636042);
		WriteB3(MSG_ONE, 2126433);
		WriteB3(MSG_ONE, 6386260);
		WriteB3(MSG_ONE, 2126704);
		WriteB3(MSG_ONE, 8250);

		WriteBFloat(MSG_ONE, self.pk_beartrapammo);

		// '										 '
		WriteB3(MSG_ONE, 2105376);
		WriteB3(MSG_ONE, 2105376);
//		WriteB3(MSG_ONE, 2105376);
//		WriteB3(MSG_ONE, 2105376);
//		WriteB3(MSG_ONE, 2105376);

		// '\nExploding Shells : '
		WriteB3(MSG_ONE, 7881994);
		WriteB3(MSG_ONE, 7302256);
		WriteB3(MSG_ONE, 7235940);
		WriteB3(MSG_ONE, 5447783);
		WriteB3(MSG_ONE, 7103848);
		WriteB3(MSG_ONE, 2126700);
		WriteB3(MSG_ONE, 8250);

		WriteBFloat(MSG_ONE, self.pk_explode_ammo);

		// '										 '
		if (self.pk_explode_ammo < 10) WriteB3(MSG_ONE, 32);
		WriteB3(MSG_ONE, 8224);
		WriteB3(MSG_ONE, 2105376);
		WriteB3(MSG_ONE, 2105376);
		WriteB3(MSG_ONE, 2105376);
//		WriteB3(MSG_ONE, 2105376);

		// '\n'
		WriteB3(MSG_ONE, 10);

		if (PK_ART) pk_art_prinv(); // Cataboligne 8.12.9 purify - pk artifacts

		if (self.pk_items & PK_IT_GRAPGUN)
		{
			// 'Harpoon Gun	'
			WriteB3(MSG_ONE, 7496008);
			WriteB3(MSG_ONE, 7303024);
			WriteB3(MSG_ONE, 4661358);
			WriteB3(MSG_ONE, 2125429);
			WriteB3(MSG_ONE, 32);
		}
		else
		{
			// '						 '
			WriteB3(MSG_ONE, 2105376);
			WriteB3(MSG_ONE, 2105376);
			WriteB3(MSG_ONE, 2105376);
			WriteB3(MSG_ONE, 2105376);
			WriteB3(MSG_ONE, 32);
		}

		if (self.pk_items & PK_IT_AIRGUN)
		{
			// 'AirFist	 '
			WriteB3(MSG_ONE, 7498049);
			WriteB3(MSG_ONE, 7563590);
			WriteB3(MSG_ONE, 2105460);
			WriteB3(MSG_ONE, 32);
		}
		else
		{
			// '					'
			WriteB3(MSG_ONE, 2105376);
			WriteB3(MSG_ONE, 2105376);
			WriteB3(MSG_ONE, 2105376);
			WriteB3(MSG_ONE, 32);
		}

		if (self.pk_items & PK_IT_CLIGHT)
		{
			// 'Chain Thunderbolt '
			WriteB3(MSG_ONE, 6383683);
			WriteB3(MSG_ONE, 2125417);
			WriteB3(MSG_ONE, 7694420);
			WriteB3(MSG_ONE, 6644846);
			WriteB3(MSG_ONE, 7299698);
			WriteB3(MSG_ONE, 2126956);
		}
		else
		{
			// '									'
			WriteB3(MSG_ONE, 2105376);
			WriteB3(MSG_ONE, 2105376);
			WriteB3(MSG_ONE, 2105376);
			WriteB3(MSG_ONE, 2105376);
			WriteB3(MSG_ONE, 2105376);
			WriteB3(MSG_ONE, 2105376);
		}

		WriteByte(MSG_ONE, 0);
		return;
	}

//
// set weapon, set ammo
//
	self.weapon = IT_AXE;
	self.forcewchange = TRUE;
	W_SetCurrentAmmo();
};


// called from various - diverts from BestWeapon

float() PK_BestWeapon =
{
	local	float	it;

	it = self.items;

//	if (self.waterlevel <= 1 && (self.ammo_cells >= 2 || ammo_con(PK_IT_CLIGHT, self, "wpck")) && (self.pk_items & PK_IT_CLIGHT))
	if (self.waterlevel <= 1 && HasAmmo(IT_AXE, PK_IT_CLIGHT) && (self.pk_items & PK_IT_CLIGHT))
		return IT_AXE;

//	if (self.waterlevel <= 1 && (self.ammo_cells >= 1 || ammo_con(IT_LIGHTNING, self, "wpck")) && (it & IT_LIGHTNING))
	if (self.waterlevel <= 1 && HasAmmo(IT_LIGHTNING, 0) && (it & IT_LIGHTNING))
			return IT_LIGHTNING;

	if (HasAmmo(IT_SUPER_NAILGUN, 0) && (it & IT_SUPER_NAILGUN))
		return IT_SUPER_NAILGUN;

	if ((self.ammo_shells >= 2 || self.pk_explode_ammo >= 2 || ammo_con(IT_SUPER_SHOTGUN, self, "wpck")) && (it & IT_SUPER_SHOTGUN))
		return IT_SUPER_SHOTGUN;

	if ((self.ammo_nails >= 1 || ammo_con(IT_NAILGUN, self, "wpck")) && (it & IT_NAILGUN))
		return IT_NAILGUN;

	if ((self.ammo_shells >= 1 || self.pk_explode_ammo >= 1 || ammo_con(IT_SHOTGUN, self, "wpck")) && (it & IT_SHOTGUN))
		return IT_SHOTGUN;

	if (self.pk_items & PK_IT_AIRGUN)
		return IT_AXE;

	return IT_AXE;
};

// called from below

float() PK_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_AXE)
		return TRUE;

	if (ammo_con(self.weapon, self, "wpck")) // see if its inf ammo wep
		return TRUE;
	
	self.weapon = W_BestWeapon ();
	self.pk_currentitem = W_BestPKWeapon(); // *pk - set best wep

	W_SetCurrentAmmo();

// drop the weapon down
	return FALSE;
};

void() pk_cycleObjects;

// fn(PK_CheckLivEnt) - check live ents for throwing fire & forget

// return false if we cant fire

float(float rot) PK_CheckLivEnt =
{
	if (self.weapon != IT_AXE || PK_100) return(TRUE);

	pk_livent = cnt_ent(world, "classname", "turret") + cnt_ent(world, "classname", "beartrap") + cnt_ent(world, "classname", "gravity") + cnt_ent(world, "classname", "tomb");
	
	if (self.pk_currentitem == PK_IT_GRAVITYWELL ||
		  self.pk_currentitem == PK_IT_TURRET ||
		  self.pk_currentitem == PK_IT_BEARTRAP ||
		  self.pk_currentitem == PKPLUS_IT_TOMB)
	{
		if (pk_livent < PK_MAX_LIVENT) return(TRUE);
	}
	else return(TRUE);

	if (WARNING)
	{
	bprint(" *** warning: too many live ents to fire selected weapon = ");
	bprint(ftos(pk_livent));
	bprint(".\n");
	}
	else
	{
	sprint(self, " *** warning: too many live ents to fire selected weapon = ");
	sprint(self, ftos(pk_livent));
	sprint(self, ".\n");
	}

	if (rot) // rotate weapons if we cant fire
	if (self.weapon == IT_AXE)
	{
		pk_cycleObjects();
	}
	return(FALSE);
};

// called from below

void() PK_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;

	if (!PK_CheckLivEnt (TRUE))
	return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

	if (self.eweapon)
	{
		e_weap_Attack();
		return;
	}

	if (self.weapon == IT_AXE)
	{
		if (self.pk_currentitem == PK_IT_AXE)
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
			if (rune_haste(0.25))
			self.attack_finished = time + 0.5;
		}
		else if (self.pk_currentitem == PK_IT_GRAVITYWELL)
		{
			// drop Gravity Well
			drop_gravity();
			self.pk_gravitywellammo = self.pk_gravitywellammo - 1;

			self.attack_finished = time + 0.5;

			// check if run out, change to bestweapon then.
			if (self.pk_gravitywellammo < 1)
			{
				self.pk_currentInventory = PK_IT_AXE;
				self.weapon = W_BestWeapon();
				self.pk_currentitem = W_BestPKWeapon();
				W_SetCurrentAmmo();

				vwep_firecary(self, PK_IT_GRAVITYWELL); // Cataboligne - 4.29.10 - when throwing a carryable check for viswep remove - glquake deal
			}
		}
		else if (self.pk_currentitem == PK_IT_TURRET)
		{
			// Drop Turret
			turret_dropTurret();
//			self.currentammo = self.pk_turretammo = self.pk_turretammo - 1; // Cataboligne - 8.20.9 - moved to fn call so a wall miss wont eat ammo

			self.attack_finished = time + 0.5;
			if (self.pk_turretammo < 1)
			{
				self.pk_currentInventory = PK_IT_AXE;
				self.weapon = W_BestWeapon();
				self.pk_currentitem = W_BestPKWeapon();
				W_SetCurrentAmmo();

				vwep_firecary(self, PK_IT_TURRET); // Cataboligne - 4.29.10 - when throwing a carryable check for viswep remove - glquake deal
			}
		}
		else if (self.pk_currentitem == PK_IT_CANPAB)
		{
			if (self.health > 249)
				return;

			// Open can of pork & beans
// COPB_START
			copb_eatCan();
			self.pk_canpabammo = self.pk_canpabammo - 1;

			self.attack_finished = time + 0.5;
			if (self.pk_canpabammo < 1)
			{
				self.pk_currentInventory = PK_IT_AXE;
				self.weapon = W_BestWeapon();
				self.pk_currentitem = W_BestPKWeapon();
				W_SetCurrentAmmo();

				vwep_firecary(self, PK_IT_CANPAB); // Cataboligne - 4.29.10 - when throwing a carryable check for viswep remove - glquake deal
			}
		}
		else if (self.pk_currentitem == PK_IT_GRAPGUN)
		{
			// Fire grappling gun
// GRAPPLING_START
			grap_fire();
		}
// BEARTRAP_START
		else if (self.pk_currentitem == PK_IT_BEARTRAP)
		{
			// Drop bear trap
			beartrap_dropBearTrap();
			self.currentammo = self.pk_beartrapammo = self.pk_beartrapammo - 1;

			self.attack_finished = time + 0.5;
			if (self.pk_beartrapammo < 1)
			{
				self.pk_currentInventory = PK_IT_AXE;
				self.weapon = W_BestWeapon();
				self.pk_currentitem = W_BestPKWeapon();
				W_SetCurrentAmmo();

				vwep_firecary(self, PK_IT_BEARTRAP); // Cataboligne - 4.29.10 - when throwing a carryable check for viswep remove - glquake deal
			}
		}
		else if (self.pk_currentitem == PK_IT_AIRGUN)
		{
			// Fire the AirFist weapon
			launch_horn();
		}
		else if (self.pk_currentitem == PK_IT_CLIGHT)
		{
			// Fire chain ligthning gun
// BOLT_START
	// Cataboligne 8.8.9 purify - chase cam
	// disable model in chase view
		if ( !(self.cam_x & CHSCAM_ON) )
			self.weaponmodel = "progs/v_cl_on.mdl"; // change to fire model...
			player_bolt1();
			self.attack_finished = time + 0.1;
		}
// Cataboligne 8.12.9 purify - pk artifacts
		else if (self.pk_currentitem == PKPLUS_IT_EGO)
		{
			ego_activate ();
			self.pkplus_egoammo = (self.pkplus_egoammo - 1);
			self.attack_finished = (time + 0.5);
			if (self.pkplus_egoammo < 1)
			{
				self.pk_currentInventory = PK_IT_AXE;
				self.weapon = W_BestWeapon ();
				self.pk_currentitem = W_BestPKWeapon ();
				W_SetCurrentAmmo ();

				vwep_firecary(self, PKPLUS_IT_EGO); // Cataboligne - 4.29.10 - when throwing a carryable check for viswep remove - glquake deal
			}
		}
		else	if (self.pk_currentitem == PKPLUS_IT_TOMB)
		{
			tomb_launch ();
			self.pkplus_tombammo = (self.pkplus_tombammo - 1);
			self.attack_finished = (time + 0.5);
			if (self.pkplus_tombammo < 1)
			{
				self.pk_currentInventory = PK_IT_AXE;
				self.weapon = W_BestWeapon ();
				self.pk_currentitem = W_BestPKWeapon ();
				W_SetCurrentAmmo ();

				vwep_firecary(self, PKPLUS_IT_TOMB); // Cataboligne - 4.29.10 - when throwing a carryable check for viswep remove - glquake deal
			}
		}
		else if (self.pk_currentitem == PKPLUS_IT_ACTOR)
		{
			if (self.pkplus_actorskin == PKPLUS_ACTORQUAD)
			{
				actor_quad_activate ();
			}
			else
			{
				actor_pent_activate ();
			}
			self.pkplus_actorammo = (self.pkplus_actorammo - 1);
			self.attack_finished = (time + 0.5);
			if (self.pkplus_actorammo < 1)
			{
				self.pk_currentInventory = PK_IT_AXE;
				self.weapon = W_BestWeapon ();
				self.pk_currentitem = W_BestPKWeapon ();
				W_SetCurrentAmmo ();

				vwep_firecary(self, PKPLUS_IT_ACTOR); // Cataboligne - 4.29.10 - when throwing a carryable check for viswep remove - glquake deal
			}
		}
		else if (self.pk_currentitem == PKPLUS_IT_PHONE)
		{
			phone_activate ();
			self.pkplus_phoneammo = (self.pkplus_phoneammo - 1);
			self.attack_finished = (time + 0.5);
			if (self.pkplus_phoneammo < 1)
			{
				self.pk_currentInventory = PK_IT_AXE;
				self.weapon = W_BestWeapon ();
				self.pk_currentitem = W_BestPKWeapon ();
				W_SetCurrentAmmo ();

				vwep_firecary(self, PKPLUS_IT_PHONE); // Cataboligne - 4.29.10 - when throwing a carryable check for viswep remove - glquake deal
			}
		}
// end pk_art

	}
	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1();
		W_FireShotgun ();
		if (rune_haste(0.28))
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_shot1();
		W_FireSuperShotgun ();
		if (rune_haste(0.38))
		self.attack_finished = time + 0.7;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		if (PK) player_pnail1(); // *pk - pulse nailgun fire frames
		else player_nail1();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1();
		W_FireGrenade();
		if (rune_haste(0.3))
		self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		player_rocket1();
		W_FireRocket();
		if (rune_haste(0.4))
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

// called below

void() pk_cycleObjects =
{
	while (1)
	{
		if (self.pk_currentitem == PK_IT_AXE)
			self.pk_currentitem = PK_IT_GRAVITYWELL;
		else if (self.pk_currentitem == PK_IT_GRAVITYWELL)
			self.pk_currentitem = PK_IT_TURRET;
		else if (self.pk_currentitem == PK_IT_TURRET)
			self.pk_currentitem = PK_IT_BEARTRAP;
		else if (self.pk_currentitem == PK_IT_BEARTRAP)
			self.pk_currentitem = PK_IT_CANPAB;
		else if (self.pk_currentitem == PK_IT_CANPAB)
// Cataboligne 8.12.9 purify - pk artifacts
			self.pk_currentitem = PKPLUS_IT_EGO;
		else if (self.pk_currentitem == PKPLUS_IT_EGO)
			self.pk_currentitem = PKPLUS_IT_TOMB;
		else if (self.pk_currentitem == PKPLUS_IT_TOMB)
		{
			self.pkplus_actorskin = PKPLUS_ACTORQUAD;
			self.pk_currentitem = PKPLUS_IT_ACTOR;
		}
		else if (self.pk_currentitem == PKPLUS_IT_ACTOR)
		{
			if (self.pkplus_actorskin == PKPLUS_ACTORQUAD)
			{
				self.pkplus_actorskin = PKPLUS_ACTORPENT;
			}
			else
			{
			self.pkplus_actorskin = 0;
			self.pk_currentitem = PKPLUS_IT_PHONE;
			}
		}
		else if (self.pk_currentitem == PKPLUS_IT_PHONE)
// end pk_art
			self.pk_currentitem = PK_IT_AXE;
		else
			return;		// get's here when the currentitem == a normal pk weapon

		if (HasAmmo(IT_AXE, self.pk_currentitem))
		{
			self.pk_currentInventory = self.pk_currentitem;
			return;
		}
	}
};

// called below

void() PK_ChangeWeapon =
{
		local float am, fl, fl2;

	am = 0;
		fl2 = 0;

	if (self.impulse == 1)
	{
		fl = IT_AXE;

// PAINKEEP_START
		if (self.weapon == IT_AXE)
				{ // if already selected axe.

			// toggle through all the objects we have.
					pk_cycleObjects();
				}

			// select the current inventory item
		 	fl2 = self.pk_currentInventory;
// PAINKEEP_END
	}
	else if (self.impulse == 2)
		fl = IT_SHOTGUN;
	else if (self.impulse == 3)
		fl = IT_SUPER_SHOTGUN;
	else if (self.impulse == 4)
		fl = IT_NAILGUN;
	else if (self.impulse == 5)
		fl = IT_SUPER_NAILGUN;
	else if (self.impulse == 6)
		fl = IT_GRENADE_LAUNCHER;
	else if (self.impulse == 7)
		fl = IT_ROCKET_LAUNCHER;
	else if (self.impulse == 8)
	{
				fl = IT_AXE;
				fl2 = PK_IT_CLIGHT;
	}

		am = !HasAmmo(fl, fl2);

// PAINKEEP_START
	// if already have the weapon or if you don't have the weapon, try the
		// double tap impulses.
		if (self.weapon == fl || !(self.items & fl) || (fl == IT_AXE && !(self.pk_items & fl2)) || am == 1)
		{
			if (self.impulse == 2)
				{
				fl = IT_AXE;
						fl2 = PK_IT_AIRGUN;
						am = !HasAmmo(fl, fl2);
				}
				else if (self.impulse == 8)
				{
						fl = IT_LIGHTNING;
						am = !HasAmmo(fl, fl2);
				}

		}
// PAINKEEP_END

	if (!(self.items & fl) || (fl == IT_AXE && !(self.pk_items & fl2)))
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
// PAINKEEP_START
	self.pk_currentitem = fl2;
// PAINKEEP_END
	self.forcewchange = TRUE;

	W_SetCurrentAmmo ();
};

// called below

void() PK_CycleWeaponCommand =
{
	local float sf;
	sf = 50;
	while (1)
	{
		if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_CLIGHT)
		{
			self.weapon = IT_AXE;
			self.pk_currentitem = self.pk_currentInventory;
		}
		else if (self.weapon == IT_AXE && self.pk_currentitem == self.pk_currentInventory)
		{
			self.weapon = IT_AXE;
			self.pk_currentitem = PK_IT_GRAPGUN;
		}
		else if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_GRAPGUN)
			self.weapon = IT_SHOTGUN;
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_AXE;
			self.pk_currentitem = PK_IT_AIRGUN;
		}
		else if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_AIRGUN)
			self.weapon = IT_SUPER_SHOTGUN;
		else if (self.weapon == IT_SUPER_SHOTGUN)
			self.weapon = IT_NAILGUN;
		else if (self.weapon == IT_NAILGUN)
			self.weapon = IT_SUPER_NAILGUN;
		else if (self.weapon == IT_SUPER_NAILGUN)
			self.weapon = IT_GRENADE_LAUNCHER;
		else if (self.weapon == IT_GRENADE_LAUNCHER)
			self.weapon = IT_ROCKET_LAUNCHER;
		else if (self.weapon == IT_ROCKET_LAUNCHER)
			self.weapon = IT_LIGHTNING;
		else if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_AXE;
			self.pk_currentitem = PK_IT_CLIGHT;
		}

// fix loop bug - we hope
		if (sf < 1)
		{
			self.weapon = IT_AXE;
			self.pk_currentitem = PK_IT_AXE;
			W_SetCurrentAmmo();
			return;
		}
		sf=sf - 1;

		if (CanSelect(self.weapon, self.pk_currentitem))
		{
			W_SetCurrentAmmo();
			return;
		}
	}

};

// called below

void() PK_CycleWeaponReverseCommand =
{
	local float sf;
	sf = 50;
	while (1)
	{
		if (self.weapon == IT_LIGHTNING)
			self.weapon = IT_ROCKET_LAUNCHER;
		else if (self.weapon == IT_ROCKET_LAUNCHER)
			self.weapon = IT_GRENADE_LAUNCHER;
		else if (self.weapon == IT_GRENADE_LAUNCHER)
			self.weapon = IT_SUPER_NAILGUN;
		else if (self.weapon == IT_SUPER_NAILGUN)
			self.weapon = IT_NAILGUN;
		else if (self.weapon == IT_NAILGUN)
			self.weapon = IT_SUPER_SHOTGUN;
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_AXE;
			self.pk_currentitem = PK_IT_AIRGUN;
		}
		else if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_AIRGUN)
			self.weapon = IT_SHOTGUN;
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_AXE;
			self.pk_currentitem = PK_IT_GRAPGUN;
		}
		else if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_GRAPGUN)
		{
			self.weapon = IT_AXE;
			self.pk_currentitem = self.pk_currentInventory;
		}
		else if (self.weapon == IT_AXE && self.pk_currentitem == self.pk_currentInventory)
		{
			self.weapon = IT_AXE;
			self.pk_currentitem = PK_IT_CLIGHT;
		}
		else if (self.weapon == IT_AXE && self.pk_currentitem == PK_IT_CLIGHT)
			self.weapon = IT_LIGHTNING;

// fix loop bug - we hope
		if (sf < 1)
		{
			self.weapon = IT_AXE;
			self.pk_currentitem = PK_IT_AXE;
			W_SetCurrentAmmo();
			return;
		}
		sf=sf - 1;

		if (CanSelect(self.weapon, self.pk_currentitem))
		{
			W_SetCurrentAmmo();
			return;
		}
	}

};

// called below

void() PK_CheatCommand =
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

	self.pk_gravitywellammo = PK_GRAVITYWELLAMMO_MAX;
	self.pk_turretammo = PK_TURRETAMMO_MAX;
	self.pk_canpabammo = PK_CANPABAMMO_MAX;
	self.pk_beartrapammo = PK_BEARTRAPAMMO_MAX;
	self.pk_explode_ammo = PK_EXPLODEAMMO_MAX;

	self.pk_items = self.pk_items | PK_IT_GRAPGUN | PK_IT_AIRGUN | PK_IT_CLIGHT;

// Cataboligne 8.12.9 purify - pk artifacts
	if (PK_ART)
	{
	self.pkplus_egoammo = PKPLUS_EGOAMMO_MAX;
	self.pkplus_tombammo = PKPLUS_TOMBAMMO_MAX;
	self.pkplus_actorammo = PKPLUS_ACTORAMMO_MAX;
	self.pkplus_phoneammo = PKPLUS_PHONEAMMO_MAX;
	}
// end pk_art

	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo();
};

// called below

void() PK_ImpulseCommands =
{
	local entity sv;

	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();
	else if (self.impulse == 9)
		PK_CheatCommand ();
	else if (self.impulse == 10)
		CycleWeaponCommand ();
	else if (self.impulse == 11)
		ServerflagsCommand ();
	else if (self.impulse == 12)
		CycleWeaponReverseCommand ();

	else if (self.impulse >= 30 && self.impulse <= 39 || self.impulse == 21 || self.impulse == 22) // user impulses
		pk_special_impulse();
	else if (self.impulse > 160 && self.impulse < 166) // Cataboligne 8.12.9 purify - pk artifacts
	{
		pk_art_specialimpulse(self.impulse);
		return;
	}

// Select best close combat weapon
	else if (self.impulse == 46)
	{
		self.weapon = W_BestWeapon();
		self.pk_currentitem = W_BestPKWeapon();

		W_SetCurrentAmmo();
	}

// GRAPPLING_START
	else if (self.impulse == 50)
	{
		grap_releaseHarpoon();
	}

// PAINKEEP_PREVWEAPON_START
	else if (self.impulse == 69)
	{
		if (CanSelect(self.lastweapon, self.pklastweapon))
		{
			self.weapon = self.lastweapon;
			self.pk_currentitem = self.pklastweapon;

			W_SetCurrentAmmo();
		}
	}

// SPARK_START
	else if (self.admin > 0 && self.impulse == 253)
	{
		if (pk_flags & PK_TP_SPARKSFLASH)
		{
			bprint("SFX Enabled.\n");
			pk_bas_flags(PK_TP_SPARKSFLASH, 1);
		}
		else
		{
			bprint("SFX Disabled.\n");
			pk_bas_flags(PK_TP_SPARKSFLASH, 0);
		}
		admin_sv_cfg();
	}

// PK_HUB_START
	else if (self.admin > 0 && self.impulse == 200)
	{
		if (pk_flags & PK_SF_HUB)
		{
			bprint("Hub mode OFF\n");
			pk_bas_flags(PK_SF_HUB, 0);
		}
		else
		{
			bprint("Hub mode ON\n");
			pk_bas_flags(PK_SF_HUB, 1);
		}
		if (pk_admintime > 0) admin_resettimeout();
	}

// MOTD_START
	else if (self.impulse == 201)
	{
		if (self.pk_items & PK_IT_EXTRADISP)
		{
			sprint(self, "Status Display OFF\n");
			self.pk_items = self.pk_items - PK_IT_EXTRADISP;
		}
		else
		{
			sprint(self, "Status Display ON\n");
			self.pk_items = self.pk_items | PK_IT_EXTRADISP;
		}
	}

// PK_DUTYCHECKING_START
	else if (self.admin > 0 && self.impulse == 202)
	{
		if (pk_flags & PK_TP_DUTYON)
		{
			bprint("Duty Checking OFF\n");
			pk_bas_flags(PK_TP_DUTYON, 0);
		}
		else
		{
			bprint("Duty Checking ON\n");
			pk_bas_flags(PK_TP_DUTYON, 1);
		}
		admin_sv_cfg();
	}

	else if (self.impulse == 225)
	{
		if (pk_flags & PK_TP_DUTYON)
			sprint(self, "Duty Checking On\n");
		else
			sprint(self, "Duty Checking Off\n");

		if (!(pk_flags & PK_TP_SPARKSFLASH))
			sprint(self, "SFX On\n");
		else
			sprint(self, "SFX Off\n");

		if (pk_flags & PK_TP_STATUSON)
			sprint(self, "Status On\n");
		else
			sprint(self, "Status Off\n");	 

		if (pk_flags & PK_TP_USERMAPON)
			sprint(self, "Custom Maps On\n");
		else
			sprint(self, "Custom Maps Off\n");
		if (pk_admintime > 0) admin_resettimeout();
	}

	else if (self.impulse == 255){
		QuadCheat ();
// TESTING - remove for upload
//		fn_make(cvar("saved1"), self.origin);
}

	self.impulse = 0;
};

// called from most player missile launchers

void(entity e) pk_missile_splash =
{
		AddToSplash(e); // *pk - Make this entity splash
		e.weapon = self.weapon; // *pk - Correct death message info - CHECK: see grenade kill issue
}
