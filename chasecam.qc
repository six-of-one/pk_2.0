/*
chasecam file

--- see original for instructional comment - Cataboligne

====================================================================

*/
// vars

//.vector cam; // all chase cam data - moved for pre compile

// darkplaces deal
//.float clientcolors; //controls coloring on scoreboard (this determines player colors exactly like the "color" command, except for using a single number that contains pants and shirt colors (pants + shirt * 16, 0-255 potentially), so be sure to set it for a bot)

// already in pk for hub view
// string CL_BOBSET = "cl_bob 0.02\n"; // val for turning view bob back on when not in chasecam

string CAM_MODEL = "progs/null.mdl";
float CAM_DIST		= 100.0;
float CAM_Z			= 22.0;
float CAM_DEF; 					// set to 1 for default chase cam
float NO_CAM; 					// set to 1 to disable chase cam

float CHSCAM_NO_WATER = FALSE; // if true, cam will deactivate in water

// fn(chase_cam_precache) - init cam, cache files

void() chase_cam_precache =
{
//	precache_model ("progs/cross1.mdl" ); // lasertargeter
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
// changed to player.cam_y (distance)
// player.cam_z (zmult)
// set in client.qc for initial values

// Resets weapon model after changing view
// called by chase cam or player entities
// hack - handles cl_bob deal - Cataboligne 1.8.8
// IDEA - save bob value

// fn(cam_setbob) - handle bob settings

void(string bcm) cam_setbob =
{
	if (IROBOT(self)) return; // no cam for bots - no stuffcmd either

	if (bcm == "")
	{
		if (cvar("cl_bob")) stuffcmd( self, "cl_bob 0\n" ); // dont bob view
	}
	else if (bcm == CL_BOBSET)
	{
		if (cvar("cl_bob") != CL_BOBVAL) stuffcmd( self, bcm ); // bob view setting
	}
	else
	{
		stuffcmd( self, bcm );
	}
};

void( entity player_ent ) Chase_cam_setweapon =
{
	local entity e;

	e = self;
	self = player_ent;
	if ( (self.cam_x & CHSCAM_ON) )
	{
		self.weaponmodel = "";
		cam_setbob("");
	}
	else
	{
		W_SetCurrentAmmo();
		cam_setbob(CL_BOBSET);
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

	if (DARKPLACES || chaos)
	{
		NO_CAM = cvar("sv_cam_off"); // dp var disables cam
		if (chaos)
		if (cvar("cl_cam_off") != NO_CAM) NO_CAM = cvar("cl_cam_off");
	}

	if (Q_100 || PK_100 || NO_CAM) // Cataboligne - 8.16.9 - quake compatability mode
	{
		return;
	}

	stuffcmd( cam_owner, CAM_FOV );

	chase_cam = spawn();

	chase_cam.owner=cam_owner;

	// turn on bit-flag
	chase_cam.owner.cam_x = chase_cam.owner.cam_x | CHSCAM_ON;

	chase_cam.solid = SOLID_NOT;
	chase_cam.movetype = MOVETYPE_FLY;
	chase_cam.water_notify = ""; // Cataboligne - 6.13.10 - cam splash issue - just in case fix


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
	chase_cam.ammo_shells = cam_owner.cam_y / 3;

};

// secondary think for cam entities
void() Reable_chase_cam =
{
	self.nextthink = time + 0.1;

	//if (self.owner.health <= 0)
	if (self.owner.solid == SOLID_NOT)
	{
		//owner died in water, reset .cam_x flag for respawn
//		self.owner.cam_x = self.owner.cam_x | CHSCAM_ON;
		remove( self );
		return;
	}

	if (self.owner.classname == OBSERVER) return;
	if (self.owner.admin) return; // pk mods

	if ((CHSCAM_NO_WATER == TRUE) & (self.owner.waterlevel != 0))
		return;

	self.owner.cam_x = self.owner.cam_x | CHSCAM_ON;
	Chase_cam_setweapon( self.owner );

	self.skin = 1; // flag temp. disabled flag so track function-
						// will reset remote view
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_FLY;
	setmodel (self, CAM_MODEL);
	setsize (self, '0 0 0', '0 0 0');
	setorigin( self, self.owner.origin);
	self.ammo_shells = self.owner.cam_y / 3; // distance clipping
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
	stuffcmd( self.owner, STD_FOV );

	// turn off bit-flag-
	self.owner.cam_x = self.owner.cam_x - (self.owner.cam_x & CHSCAM_ON);

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


// fn(cam_deathmove) - enable death move

void () cam_deathmove =
{
	self.nextthink = time + 0.2;

	if (self.owner.solid != SOLID_NOT)
	{
		remove( self);
		return;
	}
	else if ( self.owner.button2 || self.owner.button1 || self.owner.button0 || intermission_running ) // respawn
	{
		self.owner.health = -1;
		self.owner.deadflag = DEAD_RESPAWNABLE; // really die & respawn
//		stuffcmd(self.owner,"scr_centertime 5\n");
//		stuffcmd(self.owner,"scr_centertime 240\n");
		self.think = SUB_Remove;
//		self = self.owner;
		setorigin(self.owner, self.oldorigin);
		self.owner.velocity = ' 0 0 0';
		if (!intermission_running) 
		{
			self.owner.think = respawn;
			self.owner.nextthink = time + 0.5;
		}
// fix - set viewport back if default no
//		if (!cvar("sv_cam_def") || NO_CAM || (chaos && !cvar("cl_cam_def")))
//			set_viewport(self.owner, self.owner); // NOTE: not the fix we wanted?
		return;
	}
	else if (DCAMTO && self.delay < time)
	{
		if (DCAMTOACT)
		{
//			self.owner.think = ClientDisconnect;
//			self.owner.nextthink = time + 0.5;
			stuffcmd( self.owner, "disconnect\n" );
			remove(self);
		}
		else
		{
			self.owner.think = respawn;
			self.owner.nextthink = time + 0.5;
		}
		return;
	}

// observers are very poor - no possesions
	if (self.owner.frame || self.owner.effects || self.owner.weapon || self.owner.currentammo || self.owner.model != "progs/null.mdl")
	{
		self.owner.invincible_time = self.owner.super_damage_finished = self.owner.radsuit_finished = self.owner.invisible_finished = self.owner.invincible_finished = 0;
		self.owner.effects = self.owner.items = 0; // self.owner.frame = 
//		self.owner.items = self.owner.items - (self.owner.items & (IT_QUAD | IT_SUIT | IT_INVISIBILITY | IT_INVULNERABILITY));
		self.owner.weapon = self.owner.currentammo = self.owner.ammo_shells = self.owner.ammo_nails = self.owner.ammo_rockets = self.owner.ammo_cells = 0;
		self.owner.pkprevweapon = self.owner.pklastweapon = self.owner.prevweapon = self.owner.lastweapon = 0;
// remove pk items & ammos
		self.owner.pkplus_egoammo = self.owner.pkplus_tombammo = self.owner.pkplus_actorammo = self.owner.pkplus_phoneammo = 0;
		self.owner.pk_gravitywellammo = self.owner.pk_turretammo = self.owner.pk_canpabammo = self.owner.pk_beartrapammo = self.owner.pk_explode_ammo = 0;
	}

	if (self.owner.model != "progs/null.mdl")
	{
		CopyToBodyQue (self.owner);
		setmodel(self.owner, "progs/null.mdl");
		setsize (self.owner,'-4 -4 -4', ' 4 4 4');
		self.owner.movetype = MOVETYPE_FLY; // set camera flight pattern delta
		self.owner.takedamage = DAMAGE_NO;
		self.owner.wait = 0;
		self.owner.view_ofs_z = 1;
		self.owner.water_notify = ""; // Cataboligne - 6.13.10 - deadcam splash issue
		self.oldorigin = self.owner.origin;
		setorigin(self.owner, self.origin);
		set_viewport(self.owner, self.owner);
		sprint(self.owner,"your spirit is free!\n");
	}
	if (cvar("fov") != DCAM_FOV) stuffcmd( self.owner, DCAM_SET_FOV ); // I see short dead dudes - enforce crow vision

	self.owner.weaponmodel = "";
	self.owner.weapon = 0;
	self.owner.flags = self.owner.flags | FL_ONGROUND;
};

// fn(cam_deathview) - view of recently deceased
// create new cam, or hijack chasecam to get here

void () cam_deathview =
{
	self.nextthink = time + 0.1;

	if (!self.wait && self.owner.model != "progs/null.mdl")
	{
		self.delay = 0;
		self.wait = time + 4;
		if (DCAMTO) self.delay = DCAMTO + time;
	}

	if (self.wait < time) // when timed out go to deathmove code
	{
		self.think = cam_deathmove;
	}

	if (self.owner.solid != SOLID_NOT)
	{

// FIX - viewport restore here
		set_viewport(self.owner, self.owner); // test this

		remove( self);
		return;
	}

//	if (self.owner.classname != "pk*bot") // deprecated - bots will not come here
	self.owner.classname = OBSERVER;

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

	self.owner.health = 1;
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
	e.classname = "deadcam";
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

	self.nextthink = time + 0.1;

	// check if player toggled
	if (! (self.owner.cam_x & CHSCAM_ON))
	{
		Remove_chase_cam( TRUE );
		return;
	}

	if (self.owner.solid == SOLID_NOT)
	{
//		stuffcmd( self.owner, STD_FOV );

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
			self.classname = "deadcam";
			if (self.skin) // temp disable flag is set
			{
				self.owner.view_ofs_z = -1;
				set_viewport( self.owner, self);
			}
		}
		return;
	}

	if (self.owner.admin) // pk mods - note: this is slightly annoying in operation
	{
		Remove_chase_cam( FALSE );
		return;
	}

// because non transparent vised water blocks cam traces
	if ( (CHSCAM_NO_WATER == TRUE) & (self.owner.waterlevel != 0) )
	{
		Remove_chase_cam( FALSE );
		return;
	}
	/*
	else if (self.owner.waterlevel != 0)
	{
		self.flags = self.flags | FL_WATERJUMP;
	}
	else
		self.flags = self.flags - (self.flags & FL_WATERJUMP);
	*/
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


/*
   bprint(  "cam org = " );
   bprint(  vtos(self.origin) );
   bprint(  "\n" );

local string s1;
   bprint(  "\n\n f_f = " );
   s1 = ftos( f_f );
   bprint(  s1 );
   bprint(  " ------ c-o = " );
   s1 = ftos( vlen(self.origin - self.owner.origin));
   bprint(  s1 );
   bprint(  "\n" );
*/

	// increment fade-back variable
	self.ammo_shells = self.ammo_shells + 4.5;
	if (self.ammo_shells > self.owner.cam_y)
		self.ammo_shells = self.owner.cam_y;

	makevectors( self.owner.v_angle );

	// set spot before clipping
	//.v_angle_x:
	//	78.8 (max down aim)
	//	-68.9 (max up aim)

	goal = owner_vec - (v_forward * self.ammo_shells);
	goal_z = goal_z + 14 + (self.ammo_shells * self.owner.cam_z);

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
	if (self.classname == OBSERVER) return;

	if ((CHSCAM_NO_WATER == TRUE) & (self.waterlevel != 0))
		return;

	if( (self.cam_x & CHSCAM_ON) )
	{
		// will be noticed by next think-
		// of player's chase cam entity
		self.cam_x = self.cam_x - CHSCAM_ON;
	}
	else
		Start_chase_cam( self, '0 0 0' );
};


void() Chase_cam_lvlstart_think =
{

	if ( (self.owner.cam_x & CHSCAM_ON) )
		Start_chase_cam( self.owner, '0 0 0' );

/*
	if ( (self.owner.cam_x & LASERTARG_ON) )
	{
		self.owner.cam_x = self.owner.cam_x - LASERTARG_ON;
		LaserTargeterToggle( self.owner );
	}
*/
	remove( self );
};


// called in CLIENT.QC by void() PutClientInServer-
// player.cam_x is set and saved between levels using parm16
// in CLIENT.QC
void() Chase_cam_level_start =
{

	local entity e;

	if (IROBOT(self)) return; // no cam start for bots

	e = spawn();
	e.owner = self;
	e.nextthink = time + 0.2;
	e.think = Chase_cam_lvlstart_think;
	stuffcmd(self, STD_FOV ); // incase of crow vision
};


// opt:
// 0 = minus
// 1 = plus
// 2 = read cvar temp1 for value
// (player.cam_y holds cam distance)
void(float opt) Chase_cam_change_dist =
{

	if (!opt)
	{
		self.cam_y = self.cam_y - 2;
		if (self.cam_y < 10)
			self.cam_y = 10;
	}
	else if (opt == 1)
		self.cam_y = self.cam_y + 2;
	else
		self.cam_y = cvar( "temp1" );

	sprint( self, "chasecam distance = " );
	sprint( self, ftos(self.cam_y) );
	sprint( self, "\n" );


};

// opt:
// 0 = minus
// 1 = plus
// 2 = read cvar temp1 for value
// (player.cam_z holds zmult)
void(float opt) Chase_cam_change_zmult =
{
	local float f;

	if (!opt)
	{
		self.cam_z = self.cam_z - 0.02;
		if (self.cam_z < 0)
			self.cam_z = 0;
	}
	else if (opt == 1)
		self.cam_z = self.cam_z + 0.02;
	else
	{
		f = cvar( "temp1" );
		self.cam_z = f * 0.01;
	}


	// convert and strip for display
	// apparantly,
	//	.cam_z = .cam_z +- 0.02;
	// don't _exactly_ add/sub 0.02
	f = self.cam_z * 100;
	f = rint( f );

	sprint( self, "chasecam verticle offset = " );
	sprint( self, ftos(f) );
	sprint( self, "\n" );
};

/*
Reads current values of cvar temp1:
opt:
	0 = into player.cam_y (chasecam distance)
	1 = into player.cam_z (zmult)
*/
void(float opt) Chase_cam_read_temp1 =
{
	if (!opt)
		Chase_cam_change_dist(2);
	else
		Chase_cam_change_zmult(2);
};

// fn(cam_parms) - manage parms between levels

// self must be player ent when this is called

void(float sel) cam_parms =
{
	if (IROBOT(self)) return; // no cam for bots

	CAM_DEF = 1; // compiled default for non dp engines
	if (DARKPLACES || chaos)
	{
		CAM_DEF = cvar("sv_cam_def"); // dp var disables default cam
		if (chaos)
		if (cvar("cl_cam_def") != CAM_DEF) CAM_DEF = cvar("cl_cam_def");

		NO_CAM = cvar("sv_cam_off"); // dp var disables cam
		if (chaos)
		if (cvar("cl_cam_off") != NO_CAM) NO_CAM = cvar("cl_cam_off");
	}

	if (Q_100 || PK_100 || NO_CAM) return; // Cataboligne - 8.16.9 - quake compatability mode

	if (!sel)
		{
// holds current state of cam and targeter between levels
		parm14 = self.cam_x + (self.cam_y & 255) * 256 + ((self.cam_z * 100) & 255) * 65536; // bit flags, cam distance, cam height
//		parm15 = self.dest1_y;
		}
	else if (sel == 1)
		{
		self.cam_x = parm14 & 255;
		self.cam_y = (parm14 & 65280)/256;
		self.cam_z = ((parm14 & 16711680)/65536)  * 0.01;
//		self.dest1_y = parm15;
		}
	else
		{
	// only reset if zeroed  (so DM/COOP respawns don't reset)
		if (self.deadflag == DEAD_RESPAWNABLE)
			parm14 = self.cam_x + (self.cam_y & 255) * 256 + ((self.cam_z * 100) & 255) * 65536; // bit flags, cam distance, cam height
		else
			parm14 = CAM_DEF + CAM_DIST * 256 + CAM_Z * 65536; // bit flags, cam distance, cam height
		}
};


// fn(bot_renew) - do button push for bots on think or call
// because bots, like sandmen __ALWAYS__ go to carosel to renew.

// NOTE: does this need to be in a bot file?

/*

// deprecated - just respawn below because its no longer a cam op deal

void() bot_renew =
{
		self.health = -1;
		self.deadflag = DEAD_RESPAWNABLE;
//		self.think = SUB_Remove;
//		self.nextthink = time + 0.2; // Cat - fixed 4.4.10 - these were not removing for frikbot

//	setorigin(self.owner, self.oldorigin);
//		self.velocity = ' 0 0 0';
		if (!intermission_running) 
		{
			self.think = respawn;
			self.nextthink = time + 0.5 + random() * 5;
		}
}
*/

	// prevent internal C from tilting the view after
	// QC has already initiated all death processes
void () dead_cam_set =
{
	viswep_ld(self, -2);

//	if (DARKPLACES || chaos)
//	{
//		NO_CAM = cvar("sv_cam_off"); // dp var disables cam
//		if (chaos)
//		if (cvar("cl_cam_off") != NO_CAM) NO_CAM = cvar("cl_cam_off");
//	}

	if (Q_100 || PK_100) return; // || NO_CAM) return; // Cataboligne - 8.16.9 - quake compatability mode

	if (IROBOT(self))  // no deadcam for bots
	{
/*

// deprecated - bot code already handles respawn, so no reason to duplicate this - tweak bot code for more random return to action

// the issue is that this steals bot die stuff causing wierdness - the frikbot zombie corpse deal

		local float cn, pn;

		cn = cnt_ent(world, "classname", OBSERVER); // count observers
		pn = cn + cnt_ent(world, "classname", "player") + cnt_ent(world, "classname", "pk*bot"); // count total players - need better way?
		if ((pn > 4 && cn < 2) || (pn > 8 && cn < 3))
		{
			self.nextthink = time + 5 + random() * 20 + pn * 2 * random();
			self.think = respawn;
		}
		else
			respawn();
*/
		return;
	}

// NOTE: wraith option still needs checked once we have chaos mod morph deal
	
	if (self.flags & FL_CLIENT)
	{
		if (self.aiment)
		if (self.aiment.classname == "deadcam") return; // dont make more than one - just in case

		if (! (self.cam_x & CHSCAM_ON))
			cam_startdeathview();
	}
};

// fn(cam_punch) - zero punchangle_x if cam active when firing weps

// self is player ent

void() cam_punch =
{
	if (self.cam_x & CHSCAM_ON) self.punchangle_x = 0;
};

void () ccb_impulse_check =
{

//	else if (self.impulse == 231) LaserTargeterToggle( self );

	if (IROBOT(self)) return; // no cam for bots - not sure how they would get here...

	if (DARKPLACES || chaos)
	{
		NO_CAM = cvar("sv_cam_off"); // dp var disables cam
		if (chaos)
		if (cvar("cl_cam_off") != NO_CAM) NO_CAM = cvar("cl_cam_off");
	}

	if (Q_100 || PK_100 || NO_CAM) return; // Cataboligne - 8.16.9 - quake compatability mode

//chase cam code
	if (self.impulse == 230) Toggle_chase_cam();

	else if (self.impulse == 232) Chase_cam_change_zmult(0); // minus
	else if (self.impulse == 233) Chase_cam_change_zmult(1); // plus
	else if (self.impulse == 234) Chase_cam_change_dist(0); // minus
	else if (self.impulse == 235) Chase_cam_change_dist(1); // plus

	else if (self.impulse == 238) Chase_cam_read_temp1(0); // read cvar temp1 into player.cam_y (cam distance)
	else if (self.impulse == 239) Chase_cam_read_temp1(1); // read cvar temp1 into player.cam_z (cam height)

};

// Cataboligne - 8.22.9 - fix jump out of water with chasecam

void (vector ts) cam_CheckWaterJump =
{
	local vector start, end;

// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin + ts;
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	if (trace_fraction < 1)
	{	// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1)
		{	// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
			return;
		}
	}
};

void() cam_waterjump =
{
//	if (! self.flags & FL_WATERJUMP)
	cam_CheckWaterJump (' 0 0 -8');
	if (! (self.flags & FL_WATERJUMP))
		cam_CheckWaterJump (' 0 0 -4');
	if (! (self.flags & FL_WATERJUMP))
		cam_CheckWaterJump (' 0 0 4');
	if (! (self.flags & FL_WATERJUMP))
		cam_CheckWaterJump (' 0 0 8');
//		if (! self.flags & FL_WATERJUMP)
//			cam_CheckWaterJump (' 0 0 10');
//		if (! self.flags & FL_WATERJUMP)
//			cam_CheckWaterJump (' 0 0 12');
};
