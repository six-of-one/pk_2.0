/*
chasecam file
player entity variables used:
.dest_x      (HK WEAP)
.dest1_x     (HUD)
.dest1_y      (MSKIN PRO)
.dest2_x,y,z  (CAM)

  chase cam mod 
 Rob Albin, 09 Sep 96

 orig functions modified:
	WEAPONS.QC
		W_SetCurrentAmmo
		ImpulseCommands
	CLIENT.QC
		SetChangeParms
		SetNewParms
		DecodeLevelParms
		PutClientInServer

// player.dest2_x = bit-flag variable
// player.dest2_y = chasecam distance
// player.dest2_z = chasecam zmult (height offset)

********************************************************************

Cataboligne 9.11.3 - chasecam easy merge code

following notes detail quake-c v106 files that need modified to use this code:

********************************************************************

took out laser target calls - it seemed to malfunction in PK


=============
chasecam_b cam code
=============

(*) weapons
********************************************************************


*** place this code:

// Cataboligne 9.11.3 purify
	// disable model in chase view
	if ( (self.dest2_x & CHSCAM_ON) )
	{
		self.weaponmodel = "";
	}

*** after this code:

	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}

*** in fn(W_SetCurrentAmmo) of weapons.qc:

====================================================================

###### see fn below, this handles all this mods goodies!

*** place this code at the beginning of weapons.qc:

// Cataboligne 9.11.3 purify proto
void () ccb_impulse_check;

*** place this code:

// Cataboligne 9.11.3 purify
ccb_impulse_check();

*** after this code:

	if (self.impulse == 12)
		CycleWeaponReverseCommand ();

*** in fn(ImpulseCommands) of weapons.qc:

====================================================================


(*) ai
********************************************************************


*** place this code:

// Cataboligne 9.11.3 purify
// cam death view workaround
	if (client.solid == SOLID_NOT)
		return FALSE;

*** after this code:

	if (client.flags & FL_NOTARGET)
		return FALSE;
	if (client.items & IT_INVISIBILITY)
		return FALSE;

*** in fn(FindTarget) of ai.qc:

====================================================================

*** replace this code:

	if (self.enemy.health <= 0)

*** with this code:

// Cataboligne 9.11.3 purify
	// change detection method so monsters won't keep attacking
	// a dead player with health reset to one (no view tilting hack for cam view)
	if (self.enemy.solid == SOLID_NOT)
	//if (self.enemy.health <= 0)

*** and this code:

		if (self.oldenemy.health > 0)

*** with this code:

// Cataboligne 9.11.3 purify
		if (self.oldenemy.solid != SOLID_NOT)
		//if (self.oldenemy.health > 0)

*** in fn(ai_run) of ai.qc:

====================================================================


(*) world
********************************************************************


*** place this code:

// Cataboligne 9.11.3 purify
	precache_model ("progs/cross1.mdl" ); // lasertargeter

*** after this code:

	lightstyle(63, "a");

*** in fn(worldspawn) of world.qc:

====================================================================


(*) client
********************************************************************


*** place this code at the beginning of client.qc:

// Cataboligne 9.11.3 purify proto
void() cam_defaults;
void() cam_decode;

*** place this code:

// Cataboligne 9.11.3 purify
	cam_defaults();
	
*** after this code:
	
	parm8 = 1;
	parm9 = 0;

*** in fn(SetNewParms) of client.qc:

====================================================================

*** place this code:

// Cataboligne 9.11.3 purify
	cam_decode();
	
*** after this code:

	self.weapon = parm8;
	self.armortype = parm9 * 0.01;

*** in fn(DecodeLevelParms) of client.qc:

====================================================================


(*) combat
********************************************************************


*** place this code at the beginning of combat.qc:

// Cataboligne 9.11.3 purify proto
void() dead_cam_set;

*** place this code:

// Cataboligne 9.11.3 purify
dead_cam_set();

*** after this code:
 
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;

	monster_death_use();
	self.th_die ();

*** in fn(Killed) of combat.qc:

====================================================================

*/
// vars

// darkplaces deal
.float clientcolors; //controls coloring on scoreboard (this determines player colors exactly like the "color" command, except for using a single number that contains pants and shirt colors (pants + shirt * 16, 0-255 potentially), so be sure to set it for a bot)

// already in pk for hub view
// string CL_BOBAMT = "cl_bob 0.02\n"; // val for turning view bob back on when not in chasecam

string CAM_MODEL = "progs/null.mdl";
float CAM_DIST		= 100.0;
float CAM_Z			= 22.0;
float CAM_DEF		= 1; // set to 1 for default chase cam

float CHSCAM_NO_WATER = FALSE; // if true, cam will deactivate in water

// fn(chase_cam_precache) - init cam, cache files

void() chase_cam_precache =
{
	precache_model ("progs/cross1.mdl" ); // lasertargeter
	precache_model (CAM_MODEL);
};

//original chasecam.qc

void( entity m_e, entity v_e) set_viewport =
{
	msg_entity = m_e;                         // target of message
	WriteByte (MSG_ONE, SVC_SETVIEWPORT);
	WriteEntity (MSG_ONE, v_e);           // view port
};

void() Keep_cam_chasing_owner;
void( float opt ) Remove_chase_cam;

// (moved to defs.qc)
//float chasecam_dist = 118, chasecam_zmult = 0.30000;
// changed to player.dest2_y (distance)
// player.dest2_z (zmult)
// set in client.qc for initial values

// Resets weapon model after changing view
// called by chase cam or player entities
// hack - handles cl_bob deal - Cataboligne 1.8.8
// IDEA - save bob value
void( entity player_ent ) Chase_cam_setweapon =
{
	local entity e;

	e = self;
	self = player_ent;
	if ( (self.dest2_x & CHSCAM_ON) )
	{
		self.weaponmodel = "";
		stuffcmd( self, "cl_bob 0\n" ); // chase cam - dont bob view
	}
	else
	{
		W_SetCurrentAmmo();
		stuffcmd( self, CL_BOBAMT ); // fpv - bob back on
	}
	self = e;
};

// called either by player or chase cam entities (to restart)-
// vpos:
// '0 0 0' = start from player
// (else use as cam origin)
void( entity cam_owner, vector vpos ) Start_chase_cam =
{

	local entity	chase_cam;

	stuffcmd( cam_owner, "fov 80\n" );

	chase_cam = spawn();

	chase_cam.owner=cam_owner;

	// turn on bit-flag
	chase_cam.owner.dest2_x = chase_cam.owner.dest2_x | CHSCAM_ON;

	chase_cam.solid = SOLID_NOT;
	chase_cam.movetype = MOVETYPE_FLY;


	chase_cam.angles = chase_cam.owner.angles;

	setmodel (chase_cam, CAM_MODEL );
	setsize (chase_cam, '0 0 0', '0 0 0');

	if (vpos == '0 0 0')
		setorigin( chase_cam, chase_cam.owner.origin + '0 0 22' );
	else
		setorigin( chase_cam, vpos );

	chase_cam.classname = "chase_cam";

	chase_cam.nextthink = time + 0.1;
	chase_cam.think = Keep_cam_chasing_owner;

	// set CLOSE to 0 (ref. PlayerPreThink())
	//chase_cam.owner.view_ofs_z = -1;
	//set_viewport( cam_owner, chase_cam);
	chase_cam.skin = 1; // let track function handle the remote view
							  // part, start with "temp. disabled" flag set

	Chase_cam_setweapon( cam_owner );
	// distance clipping
	chase_cam.ammo_shells = cam_owner.dest2_y / 3;

};

// secondary think for cam entities
void() Reable_chase_cam =
{
	self.nextthink = time + 0.1;

	//if (self.owner.health <= 0)
	if (self.owner.solid == SOLID_NOT)
	{
		//owner died in water, reset .dest2_x flag for respawn
		self.owner.dest2_x = self.owner.dest2_x | CHSCAM_ON;
		remove( self );
		return;
	}

	if (self.owner.admin) return; // pk mods

	if ((CHSCAM_NO_WATER == TRUE) & (self.owner.waterlevel != 0))
		return;

	self.owner.dest2_x = self.owner.dest2_x | CHSCAM_ON;
	Chase_cam_setweapon( self.owner );

	self.skin = 1; // flag temp. disabled flag so track function-
						// will reset remote view
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_FLY;
	setmodel (self, CAM_MODEL);
	setsize (self, '0 0 0', '0 0 0');
	setorigin( self, self.owner.origin);
	self.ammo_shells = self.owner.dest2_y / 3; // distance clipping
	self.think = Keep_cam_chasing_owner;
	//Start_chase_cam( self.owner, '0 0 0' );
	//remove( self );

};


// called only by chase cam entities
// opt values
// TRUE = remove completely
// FALSE = remove view but keep alive with Reable_chase_cam();-
void( float opt ) Remove_chase_cam =
{
	stuffcmd( self.owner, "fov 90\n" );

	// turn off bit-flag-
	self.owner.dest2_x = self.owner.dest2_x - (self.owner.dest2_x & CHSCAM_ON);

	// set view-point back to normal
	set_viewport( self.owner, self.owner);


	setmodel( self, "" );
	self.velocity = '0 0 0';

	self.owner.view_ofs_z = 22;

	Chase_cam_setweapon( self.owner );

	if ( !opt )
	{
		self.nextthink = time + 0.1;
		self.think = Reable_chase_cam;
	}
	else
		remove( self );

};

// fn(cam_bodycopy) - copy players body after death, so we can move deathcam without dead body

void (entity cpy) cam_bodycopy =
{
	local entity nself;

	nself = spawn();
	setorigin(nself, cpy.origin);
	nself.modelindex = cpy.modelindex;
	setmodel(nself, cpy.model);
	nself.frame = cpy.frame;
	nself.flags = cpy.flags - (cpy.flags & (FL_CLIENT)); // not, I repeat, NOT...a client
	nself.solid = cpy.solid;
	nself.movetype = cpy.movetype;
	nself.velocity = cpy.velocity;
	nself.health = cpy.health;
	nself.netname = cpy.netname;
	nself.weapon = cpy.weapon;
	nself.angles = cpy.angles;
	nself.clientcolors = cpy.clientcolors;
	nself.v_angle = cpy.v_angle;
	setsize(nself, cpy.mins, cpy.maxs); 
}

// fn(cam_playerdying) - player is dying, set up death cam mover code
// called from player_die, before dead_cam_set

void () cam_playerdying =
{
	local entity dcam;

//	self.nextthink = -1; 
//	self.deadflag = DEAD_DEAD;
// death cam start
	dcam = spawn();
	dcam.classname = "deathmovethink";
	dcam.nextthink = time + 5.0;
	dcam.think = cam_deathmove;
	dcam.owner = self;
};

// fn(cam_deathmove) - allow dead player to move view - I'm dead...and I say I move

// pself is player

void () cam_deathmove =
{
	local entity pself;

	pself = self.owner;
	setmodel(pself, "progs/null.mdl");

	if (pself.solid != SOLID_NOT)
		remove( self);
	else if (pself.deadflag == DEAD_NO || intermission_running) // we died. need to respawn
	{
	stuffcmd( pself, "fov 130\n" ); // force crow vision
	pself.flags = pself.flags | FL_ONGROUND;
	if (self.cnt)
		{ // set cam ent size when not in solid - doesnt work in every case - better method?
		if ((pointcontents (pself.origin + '-32 -32 -32') != CONTENT_SOLID) &&
			(pointcontents (pself.origin + ' 32 -32 -32') != CONTENT_SOLID) &&
			(pointcontents (pself.origin + '-32 32 32') != CONTENT_SOLID) &&
			(pointcontents (pself.origin + ' 32 32 32') != CONTENT_SOLID))
			{
			setsize (pself,'-4 -4 -4', ' 4 4 4'); //veddy veddy shmall...
			self.cnt = 0;
			}
		}
	if ( pself.button2 || pself.button1 || pself.button0 || intermission_running ) // respawn
		{
		pself.health = -1;
		pself.deadflag = DEAD_DEAD; // really die & respawn
		set_viewport( pself, pself);
		stuffcmd( pself, "fov 90\n" );
//		stuffcmd(pself,"scr_centertime 5\n");
		remove(self);
		return;
		}
	}
	else // purgatory gate - died & need view
	{
	self.cnt = 1;
	pself.classname = "deadcam"; // monster fix - if they were already in chase, they dont stop following?!
	pself.attack_finished = -1;

// dead ents dont have possesions
	pself.weapon = 0;
	pself.items = pself.currentammo = pself.ammo_shells = pself.ammo_nails = pself.ammo_rockets = pself.ammo_cells = 0;
// movement deal
	cam_bodycopy(pself);
	pself.health = 1;
	pself.view_ofs_z = -1;
	pself.weaponmodel = "";
	pself.solid = SOLID_NOT;
	pself.movetype = MOVETYPE_FLY; // camera in flight - in case we died frozen or death code had funny business
	pself.deadflag = DEAD_NO;
	pself.flags = pself.flags | FL_ONGROUND;
	set_viewport( pself, pself);
	setsize (pself,' 0 0 0',' 0 0 0');
	if (pself.aiment != world)
		{
		setorigin(pself,pself.aiment.origin); //hijack chasecam deathview
		pself.angles = pself.aiment.angles;
		pself.velocity = pself.aiment.velocity;
		}
	stuffcmd( pself, "fov 130\n" ); // I see short dead dudes - FIX - lock out for tenebrae?
//	stuffcmd(pself,"scr_centertime 240\n");
	sprint(pself," your spirit is free!\n");
	}
	self.nextthink = time + 0.1;
}

// fn(cam_deathview) - view of recently deceased
// create new cam, or hijack chasecam to get here

void () cam_deathview =
{
	self.nextthink = time + 0.1;

	if (self.owner.solid != SOLID_NOT)
	{
		remove( self);
		return;
	}

	traceline( self.owner.origin, self.origin, TRUE, self.owner);

	if (trace_fraction < 1)
	{
		setorigin( self, trace_endpos - self.dest * 8);
		self.velocity = '0 0 0';
	}

	if (self.velocity != '0 0 0')
	{
		traceline( self.origin, self.origin + self.dest * 20, TRUE, self.owner);
		if (trace_fraction < 1 || trace_inwater ||
			 vlen( self.origin - self.owner.origin) > 200)
			self.velocity = '0 0 0';
	}

	self.owner.weaponmodel = "";
};

// fn(cam_startdeathview) - died and didnt have chasecam on
// called only by player ents immediately after being killed, if
// not already in chaseview, and not in water

void() cam_startdeathview =
{
	local entity e;
	local vector goal, ang;
	ang = self.v_angle;
	ang_x = 30; // pretend was a slight down aim
	self.weaponmodel = "";

	self.aiment = e = spawn();
	e.owner = self;
	e.solid = SOLID_NOT;
	e.movetype = MOVETYPE_FLY;
	e.angles = e.owner.angles;
	setmodel (e, CAM_MODEL );
	setsize (e, '0 0 0', '0 0 0');
	e.nextthink = time + 0.1;
	e.think = cam_deathview;
	makevectors( ang );
	goal = (self.origin + '0 0 18') - (v_forward * 120);
	traceline( self.origin + '0 0 18', goal, TRUE, self);
	setorigin( e, trace_endpos + (v_forward * 8));
	e.velocity = '0 0 0' - v_forward * 20;
	e.dest = '0 0 0' - v_forward; // save forward direction, used in cam_deathview

	set_viewport( self, e);
};


/*
	main think function for cam entities
		self.ammo_shells = distance clipping
		self.ammo_nails = hang-up flag
		self.dmg = lifts fix
		self.frags = lifts fix
		self.impulse = lifts fix
		self.dest = deathview vector to save 'v_forward' of fade direction
		self.skin = close proximity temporary disableing
		self.owner = player this cam is for

	.v_angle_x:
		78.8 (max down aim)
		-68.9 (max up aim)
*/
void() Keep_cam_chasing_owner =
{
	local vector vtmp1, vtmp2;
	local vector owner_vec, goal, dir;
	local float  dist, cap, f_f;


	//debug var
	//local string s;

	//bprint( "\n\n\nz velocity = " );
	//s = ftos( self.owner.velocity_z);
	//bprint( s);
	//bprint( "\n");
	// (results) velocity_z does move when running on sloped ground

	self.nextthink = time + 0.1;

	// check if player toggled
	if (! (self.owner.dest2_x & CHSCAM_ON))
	{
		Remove_chase_cam( TRUE );
		return;
	}

	if (self.owner.solid == SOLID_NOT)
	{
		stuffcmd( self.owner, "fov 90\n" );

		if (intermission_running)
		{
			set_viewport( self.owner, self.owner);
			remove( self );
		}
		else
		{  // deathview
			self.velocity = '0 0 0' - normalize( self.owner.origin - self.origin) * 20;
			self.angles = vectoangles( self.velocity);
			makevectors( self.angles);
			self.dest = v_forward; // save forward direction, used in cam_deathview
			self.think = cam_deathview;
			if (self.skin) // temp disable flag is set
			{
				self.owner.view_ofs_z = -1;
				set_viewport( self.owner, self);
			}
		}
		return;
	}

	if (self.owner.admin) // pk mods
	{
		Remove_chase_cam( FALSE );
		return;
	}

	if ( (CHSCAM_NO_WATER == TRUE) & (self.owner.waterlevel != 0) )
	{
		Remove_chase_cam( FALSE );
		return;
	}

	owner_vec = self.owner.origin + '0 0 22';

	// get player velocity relative to player's
	// current yaw
	// f_f (based on running calcs (maxspeed = 400)
	//  (back ~= 640, forward ~= 0)
	dir_y = self.owner.v_angle_y;
	makevectors( dir );
	f_f = vlen( (v_forward * 320) - self.owner.velocity );

	// held for use after second makevectors call for
	// pulling forward on a down aim
	dir = v_forward;

//   local string s;
//   sprint( self.owner, "\n\n f_f = " );
//   s = ftos( f_f );
//   sprint( self.owner, s );
//   sprint( self.owner, "\n f_r = " );
//   s = ftos( f_r );
//   sprint( self.owner, s );
//   sprint( self.owner, "\n" );

	// increment fade-back variable
	self.ammo_shells = self.ammo_shells + 4.5;
	if (self.ammo_shells > self.owner.dest2_y)
		self.ammo_shells = self.owner.dest2_y;

	makevectors( self.owner.v_angle );

	// set spot before clipping
	//.v_angle_x:
	//	78.8 (max down aim)
	//	-68.9 (max up aim)

	goal = owner_vec - (v_forward * self.ammo_shells);
	goal_z = goal_z + 14 + (self.ammo_shells * self.owner.dest2_z);

	// adjust initial goal
	//////////////////////////////////////////////////
	if (self.owner.v_angle_x > 0)
	{
		// pull forward
		cap = self.owner.v_angle_x;
		if (cap > 56) cap = 56;
		goal = goal + dir * cap;

		// pull down
		goal_z = goal_z - (self.owner.v_angle_x * (self.ammo_shells * 0.01));
		cap = self.owner.origin_z + 28;
		if (goal_z < cap)
			goal_z = cap;
	}

	// increase height if getting under the player
	if (goal_z < owner_vec_z)
	{
		vtmp1 = goal; vtmp1_z = 0;
		vtmp2 = owner_vec; vtmp2_z = 0;
		cap = vlen( vtmp1 - vtmp2 );
		if (cap < 100)
		{
			goal_z = goal_z + ((100 - cap) * 0.6);
			if ( goal_z > owner_vec_z )
				goal_z = owner_vec_z;
		}
	}
	//////////////////////////////////////

	// clip for brushes
	//////////////////////////////////////
	traceline (owner_vec, goal, FALSE, self.owner);
	// pull a little forward, avoids most hang-ups along walls
	goal = trace_endpos + ( v_forward * 2 );

	// clip fade-back variable
	traceline( owner_vec, owner_vec - (v_forward * self.ammo_shells), FALSE, self.owner);
	if (trace_fraction < 1)
	{
		self.ammo_shells = vlen(trace_endpos - owner_vec);
		cap = fabs( self.owner.v_angle_x ) - 10;
		if (cap > 0)
			self.ammo_shells = self.ammo_shells + cap;
	}

	traceline (self.origin, goal, FALSE, self.owner );
	if (trace_fraction < 1)
	{
		// half it if blocked
		dir = normalize(goal - owner_vec);
		dist = vlen(goal - owner_vec) * 0.5;
		goal =  owner_vec + dir * dist;
	}

	// pad for floors and ceilings
	traceline (goal, goal + '0 0 6', FALSE, self.owner );
	if (trace_fraction < 1 ) goal = trace_endpos - '0 0 6';
	else
	{
		traceline (goal, goal - '0 0 6', FALSE, self.owner );
		if (trace_fraction < 1 ) goal = trace_endpos + '0 0 6';
	}
	////////////////////////////////////////

	self.angles = self.owner.angles;

	traceline (self.origin, owner_vec, FALSE, self.owner );
	if (trace_fraction < 1)
	{
		// vtmp1_z:  0 = LOS to head
		//				-1 = LOS to feet, but not head
		//				-2 = no LOS
		traceline (self.origin, self.owner.origin - '0 0 24', FALSE, self.owner );
		if (trace_fraction == 1)
			vtmp1_z = -1;
		else
			vtmp1_z = -2;
	}
	else
		vtmp1_z = 0;
	if (vtmp1_z > -2)
	{
		dir = normalize(goal - self.origin);
		dist = vlen(goal - self.origin);

		cap = dist * 0.16;

		if (cap > 5.2)
			self.velocity = dir * dist * 5.2;
		else if (cap > 1)
			self.velocity = dir * dist * cap;
		else
			self.velocity = dir * dist;

		if (vtmp1_z == -1)
		{
			self.velocity_z = self.velocity_z - 400;
		}

		// tighten up if owner running backwards
		if (f_f > 560)
		{
			cap = self.velocity_z;
			self.velocity = self.velocity * 2;
			self.velocity_z = cap;
		}

		if (! self.owner.velocity_z)
		{
			// rising/lowering lifts fix,
			// quick and dirty hack, player.velocity_z stays at zero when
			// moving on a lift, so check through an alternate route for the
			// condition and amplify the current z velocity.
			if (self.owner.origin_z != self.frags)
				//if (self.dmg &&  (self.owner.flags & FL_ONGROUND)) // avoid landing on ground events that can happen between thinks
					// wierd setup here with the .impulse var, forces a skip for first occurance,
					// avoids logic catching vel_z same/org_z dif. instance that happens when player
					// transitions between sloping to level ground while running, (also took care
					// of the same type of thing for landing after a jump)
					if (self.impulse)
						self.velocity_z = self.velocity_z * 3;
					else
						self.impulse = TRUE;
		}
		else if (self.impulse)
			self.impulse = FALSE;

		// try to avoid hangups common to ceiling clips when player
		// is running
		if( self.oldorigin == self.origin )
		{
			if( dist > 16 )
			{
				self.ammo_nails = self.ammo_nails + 1;
				if( self.ammo_nails > 2 )
				{
					self.ammo_nails = 0;
					self.velocity = '0 0 0';
					setorigin( self, goal );
				}
			}
			else
				self.ammo_nails = 0;
		}
	}
	else
	{
		self.velocity = '0 0 0';
		setorigin( self, goal );
	}

	if (! self.skin) // .skin is 1 if in a temp disable state
	{
		if (vlen(self.owner.origin - self.origin) < 30)
		{
			self.skin = 1;
			self.owner.view_ofs_z = 22;
			set_viewport( self.owner, self.owner);
		}
	}
	else
	{
		if (vlen(self.owner.origin - self.origin) > 39)
		{
			self.skin = 0;
			self.owner.view_ofs_z = -1;
			set_viewport( self.owner, self);
		}
	}


	// hacks (only) section :-)

	// keep flag clear so internal C won't drop movement checks
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;

	self.oldorigin = self.origin; // cam hang-up hack
	self.frags = self.owner.origin_z; // 'on lift' hack
	self.dmg = self.owner.flags & FL_ONGROUND; // 'on lift' hack
};


// called by player only
void() Toggle_chase_cam =
{
	if (self.admin) return; // pk mods

	if ((CHSCAM_NO_WATER == TRUE) & (self.owner.waterlevel != 0))
		return;

	if (self.classname == "deadcam") return;

	if( (self.dest2_x & CHSCAM_ON) )
	{
		// will be noticed by next think-
		// of player's chase cam entity
		self.dest2_x = self.dest2_x - CHSCAM_ON;
	}
	else
		Start_chase_cam( self, '0 0 0' );
};


void() Chase_cam_lvlstart_think =
{

	if ( (self.owner.dest2_x & CHSCAM_ON) )
		Start_chase_cam( self.owner, '0 0 0' );

/*
	if ( (self.owner.dest2_x & LASERTARG_ON) )
	{
		self.owner.dest2_x = self.owner.dest2_x - LASERTARG_ON;
		LaserTargeterToggle( self.owner );
	}
*/
	remove( self );
};


// called in CLIENT.QC by void() PutClientInServer-
// player.dest2_x is set and saved between levels using parm16
// in CLIENT.QC
void() Chase_cam_level_start =
{

	local entity e;

	e = spawn();
	e.owner = self;
	e.nextthink = time + 0.2;
	e.think = Chase_cam_lvlstart_think;

	stuffcmd( self, "fov 90\n" ); // incase we died & had dead view last time
};


// opt:
// 0 = minus
// 1 = plus
// 2 = read cvar temp1 for value
// (player.dest2_y holds cam distance)
void(float opt) Chase_cam_change_dist =
{

	if (!opt)
	{
		self.dest2_y = self.dest2_y - 2;
		if (self.dest2_y < 10)
			self.dest2_y = 10;
	}
	else if (opt == 1)
		self.dest2_y = self.dest2_y + 2;
	else
		self.dest2_y = cvar( "temp1" );

	sprint( self, "chasecam distance = " );
	sprint( self, ftos(self.dest2_y) );
	sprint( self, "\n" );


};

// opt:
// 0 = minus
// 1 = plus
// 2 = read cvar temp1 for value
// (player.dest2_z holds zmult)
void(float opt) Chase_cam_change_zmult =
{
	local float f;

	if (!opt)
	{
		self.dest2_z = self.dest2_z - 0.02;
		if (self.dest2_z < 0)
			self.dest2_z = 0;
	}
	else if (opt == 1)
		self.dest2_z = self.dest2_z + 0.02;
	else
	{
		f = cvar( "temp1" );
		self.dest2_z = f * 0.01;
	}


	// convert and strip for display
	// apparantly,
	//	.dest2_z = .dest2_z +- 0.02;
	// don't _exactly_ add/sub 0.02
	f = self.dest2_z * 100;
	f = rint( f );

	sprint( self, "chasecam verticle offset = " );
	sprint( self, ftos(f) );
	sprint( self, "\n" );
};

/*
Reads current values of cvar temp1:
opt:
	0 = into player.dest2_y (chasecam distance)
	1 = into player.dest2_z (zmult)
*/
void(float opt) Chase_cam_read_temp1 =
{
	if (!opt)
		Chase_cam_change_dist(2);
	else
		Chase_cam_change_zmult(2);
};

// fn(cam_parms) - manage parms between levels

void(float sel) cam_parms =
{

	if (!sel)
		{
// holds current state of cam and targeter between levels
		parm14 = self.dest2_x + (self.dest2_y & 255) * 256 + ((self.dest2_z * 100) & 255) * 65536; // bit flags, cam distance, cam height
		parm15 = self.dest1_y;
		}
	else if (sel == 1)
		{
		self.dest2_x = parm14 & 255;
		self.dest2_y = (parm14 & 65280)/256;
		self.dest2_z = ((parm14 & 16711680)/65536)  * 0.01;
		self.dest1_y = parm15;
		}
	else
		{
	// only reset if zeroed  (so DM/COOP respawns don't reset)

		parm14 = CAM_DEF + CAM_DIST * 256 + CAM_Z * 65536; // bit flags, cam distance, cam height
		}
};


	// prevent internal C from tilting the view after
	// QC has already initiated all death processes
void () dead_cam_set =
{
	if ((self.flags & FL_CLIENT))
	{
		if ((self.dest2_x & CHSCAM_ON))
			self.health = 1;
		else //if ( (CHSCAM_NO_WATER == FALSE) | (self.waterlevel == 0))
		{
			self.health = 1;
			cam_startdeathview();
		}
	}
};

void () ccb_impulse_check =
{
//chase cam code

	if (self.impulse == 230) Toggle_chase_cam();
//	else if (self.impulse == 231) LaserTargeterToggle( self );

	else if (self.impulse == 232) Chase_cam_change_zmult(0); // minus
	else if (self.impulse == 233) Chase_cam_change_zmult(1); // plus
	else if (self.impulse == 234) Chase_cam_change_dist(0); // minus
	else if (self.impulse == 235) Chase_cam_change_dist(1); // plus

	else if (self.impulse == 238) Chase_cam_read_temp1(0); // read cvar temp1 into player.dest2_y (cam distance)
	else if (self.impulse == 239) Chase_cam_read_temp1(1); // read cvar temp1 into player.dest2_z (cam height)

};
