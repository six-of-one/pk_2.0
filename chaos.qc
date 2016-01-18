/*
		+---------------------------------------+
		|  Chaos code                           | SEC-HEAD
		+---------------------------------------+
*/

// implement chaos fn for pk

// fn (chaos_spawn) - the notorious and noxious spawn 'o chaos, right out of a dunwich horror story...

// spawn an ent & set basic properties, this stuff gets set almost every spawn
// reset - if not world, then reset parms on this ent
// ow - owner, overridden by master_own if set

// mvt - movetype
// sd - solid type
// cname - classname
// md - model
// flg - flags for ent
// ct - content check flags
// org - origin, uses self.origin if '0 0 0'
// smin - min bounding box			= for setsize
// smax - max bounding box			/
// an - facing angle
// tch - touch fn
// thk - think fn
// tht - think time
// thd - die, content chk fn

entity(float mvt, float sd, float flg, float ct, vector org, vector smin, vector smax, vector an, vector vel, string cname, string md, void() tch, float tht, void() thk, void() thd, entity ow, entity reset) chaos_spawn =
{
	local entity chaos_e;

	chaos_e = reset;
	if (chaos_e == world) chaos_e = spawn ();
	else 
		if (WARNING) {bprint("chaos_spawn() resetting: "); bprint(chaos_e.classname); bprint("\n"); }
	if (chaos_e == world) // failed to spawn, call fn still needs to check if live ent
		{
		if (WARNING) bprint("chaos_spawn() - ERROR: spawn() failed, returned world!\n");
		return(world);
		}

// init basic stuff
//	if (master_owner)	chaos_e.owner = master_owner;
//	else 
	chaos_e.owner = ow;
	chaos_e.classname = cname;
	chaos_e.movetype = mvt;
	chaos_e.solid = sd;
	chaos_e.flags = flg;
	chaos_e.angles = an;
	chaos_e.velocity = vel;

//	chaos_e._killmsg = chaos_e._killmsg2 = chaos_e.grab_callback = 
	chaos_e.th_stand = chaos_e.th_die = 
	chaos_e.th_walk = chaos_e.th_melee = /* chaos_e.upgrade_fn = */ chaos_e.touch = SUB_Null;

	if (tch != SUB_Null) chaos_e.touch = tch;
	if (thd != SUB_Null) chaos_e.th_die = /* chaos_e.th_stand = */ thd; // gen think & content chk

	if (thk != SUB_Null) // if we need to think
		{
//		chaos_e._stand = 
		chaos_e.think = thk;
		chaos_e.nextthink = time + tht;
		}

//	if (ct) content_cycle(chaos_e, ct, CONTENT_CHKTM);

	if (org != ' 0 0 0') setorigin (chaos_e, org);
	else setorigin (chaos_e, self.origin);
	setmodel (chaos_e, md);
	setsize (chaos_e, smin, smax);

	return(chaos_e);
};


// fn(cnt_ent) - count all such ents on level, make chain if head ent provided

// hent - head entity for chain struct
// match - find on this field
// srch - search for this

// RETURN - count of ents matching search parm

float(entity hent, string match, string srch) cnt_ent =
{
	local float rc;
	local entity sr, ch;

	sr = world;
	if (match == "classname") sr = find (world, classname, srch);
//	else if (match == "class_select") sr = find (world, class_select, srch);
//	else if (match == "quakeset") sr = find (world, quakeset, srch);
	else if (match == "netname") sr = find (world, netname, srch);
	else if (match == "map") sr = find (world, map, srch);
//	else if (match == "scode") sr = find (world, scode, srch);
	ch = hent;

	rc = 0;
	while (sr)
		{
			rc = rc + 1;
			if (hent)
			{
				ch.chain = sr;
				ch = sr;
			}
			if (match == "classname") sr = find (sr, classname, srch);
//			else if (match == "class_select") sr = find (sr, class_select, srch);
//			else if (match == "quakeset") sr = find (sr, quakeset, srch);
			else if (match == "netname") sr = find (sr, netname, srch);
			else if (match == "map") sr = find (sr, map, srch);
//			else if (match == "scode") sr = find (sr, scode, srch);
		}
	if (hent) ch.chain = world; // remove other potential chains left around - not even sure if this can happen
	return(rc);
}


// fn(bit_cnt) - count available bits for random selection

// fb - bits to count
// rb - return a random bit from set

float(float fb, float rb) bit_cnt =
{
	local float rs,f;

	if (fb > 0)
	{
		f = 1;
		while (f <= 8388608) // max float bits
		{
			if (f & fb) rs = rs + 1;
			f = f * 2;
		}
	}
	else
		return(0); // error cond - no bits set!

	if (!rb) return(rs);
// pick a random bit
	f = floor(random() * rs);
	rs = f;

	f = 1;
	while (f <= 8388608 && rs > -1) // max float bits
	{
		if (f & fb) rs = rs - 1;
		if (rs > -1) f = f * 2;
	}

	return(f);
};

void() SUB_Nop =
{
	return;
};

void() func_model_frames =
{
	self.frame = self.frame + 1;
	if (self.frame > self.state) self.frame = self.count;
	self.nextthink = time + self.delay;
};

// testing

void() func_model =
{
	self.mdl = self.model;
	precache_model (self.mdl);
	setmodel (self,self.mdl);

	self.frame = self.count;
	if (self.state)
	{
	if (self.delay <= 0) self.delay = 0.1;
	self.think = func_model_frames;
	self.nextthink = time + self.delay;
	}
};


// NOTE: came from chaos_env.qc

// fn(move_stop) halt a moving entity, play looped sound ns

void (entity e, string ns) move_stop =
{
	e.velocity = ' 0 0 0';
	e.movetype = MOVETYPE_NONE; // fails blast_move - removing fails shell casings in lava
	if (ns != "") sound(e, CHAN_WEAPON, ns, 1, ATTN_NORM);
};


// fn(loop_sound) - play a sound looped until stopped by remove, halt or search_time exceeded
// fn(loop_play) - plays loop sounds at given interval self.

// emulate looped ambient sounds - should be accurate to a fraction of seconds

// p - entity owning sound						.owner
// chan - sound channel							.cnt
// sd - sound wave to play						.noise1
// vl - volume level								.volume
// attn - attenuation setting					.aflag
// tm - time to loop sound						.delay - checked in .delay
// org1 - location of sound					.origin
// halt - if true stop sound matching entity p
// end - + time - time after which this sound ends .search_time

string LOOPSOUND = "sound_loop";
float LOOPFOREVER = 100000000000;

void() loop_play = 
{
	local entity p, q;

	q = find(world, classname, LOOPSOUND);
	while (q)
	{
//		if (q.weaponframe == framecount) return;
		p = find(q, classname, LOOPSOUND);
//		q.weaponframe = framecount;
		if (q.search_time < time) // done - remove
			remove(q);
		else if (q.distance < time) // hit time, replay
		{
			q.distance = time + q.delay;
			sound (q, q.cnt, q.noise1, q.volume, q.aflag);
//			if (DEVMSG) bprint("playing: "); bprint(q.noise1); newline(world);
		}
		q = p;
	}
};

entity(entity p, float chan, string sd, float vl, float attn, float tm, vector org1, float halt, float end) loop_sound =
{
	local entity q;
	local vector org;

	q = world;
/*

// for now this code just makes the new sound

	q = find(world, classname, LOOPSOUND);
	while (q)
	{
		if (q.owner == p && sd == q.noise1)
		{
			if (halt) { remove(q); return world; }
			else if (DEVMSG) { bprint("sound already playing: "); bprint(q.noise1); newline(world); }
			q.delay = tm;
			q.search_time = time + end;
			return q;
		}
		q = find(q, classname, LOOPSOUND);
	}
*/
	if (!q) // make new sound
	{
		org = org1;
		if (org == v0) org = p.origin;
		q = chaos_spawn(MOVETYPE_NONE, 0, 0, 0,  org, v0, v0, v0, v0, LOOPSOUND, "", SUB_Null, 0, SUB_Null, SUB_Null, p, world);
		q.cnt = chan;
		q.noise1 = sd;
		q.volume = vl;
		q.aflag = attn;
		q.delay = tm;
		q.distance = 0;
		q.search_time = time + end;
		return(q);
	}
}

// fn(ominous_hum) - idle sound for some weps
// ws - weapon sound
// rtime - time to loop - if zero play ws once
.float chaosweptime;
float hum_chan; // channel for hum - must be set prior to call, always reset to CHAN_WEAPON

void(string ws, float rtime) ominous_hum =
{
	if (WEPHUM)
	{
		if (!rtime)
		{
			self.chaosweptime = MAXFL;
			sound (self, hum_chan, ws, 1, ATTN_NORM);
		}
		else if (self.chaosweptime < time)
		{
			sound (self, hum_chan, "misc/null.wav", 1, ATTN_NORM);
			if (intermission_running)
				return;
			else if (ws != "")
			{
				sound (self, hum_chan, ws, 1, ATTN_NORM);
				self.chaosweptime = time + rtime;
			}
		}
		hum_chan = CHAN_WEAPON;
	}
};

// fn(newline) print newline to self client screen

void(entity e) newline =
{
if (e) sprint(e,"\n");
else bprint("\n");
}


// ENV
// use wrappers for engines these break (like fte)



float(entity e, float s) getsurfacenumpoints =
{
	if (chaos || DARKPLACES)
		return(getsurfacenumpoints_wrap(e, s));
};
vector(entity e, float s, float n) getsurfacepoint =
{
	if (chaos || DARKPLACES)
		return(getsurfacepoint_wrap(e, s, n));
};
vector(entity e, float s) getsurfacenormal =
{
	if (chaos || DARKPLACES)
		return(getsurfacenormal_wrap(e, s));
};
string(entity e, float s) getsurfacetexture =
{
	if (chaos || DARKPLACES)
		return(getsurfacetexture_wrap(e, s));
};
float(entity e, vector p) getsurfacenearpoint =
{
	if (chaos || DARKPLACES)
		return(getsurfacenearpoint_wrap(e, p));
};
vector(entity e, float s, vector p) getsurfaceclippedpoint =
{
	if (chaos || DARKPLACES)
		return(getsurfaceclippedpoint_wrap(e, s, p));
};


// fn(sky_touch) - new sky tex missile / object strike test - called by touch fns, as touch or think fn
// fn(sky_touch_pointer) - touch / think fn redirect - if called as touch or think does remove if RM_SKY set in content flags

// operation
// - 2 tests for origin v or entity e.origin + norm(e.velocity) * 10 - pointcontents and surface (darkplaces)
// - if surf non blank its value will be tested and disregard all other info

// return - TRUE if object is touching (near?) sky
// sets global string last texture for other code to reference

// e - passed entity, if world, try self, if self == world return FALSE

// IDEA - limit re-entry

/* sky list - so far

sky1, sky4 - quake 1 default skies
sky6 - chaos maps, black was also used for castle arioch - needs to be sky_black
sky2 - gallery map
sky0 - doom e1m1 q1 map, latest
skydark - stonehenge (thick enough for content check)

texture/ * skies - q3 maps
*/

float(string surf, vector v, entity e) sky_touch =
{
	local entity f;
	local float t, surfnum;
//	local string s3;
	string last_texture;

	if (XENV) return(FALSE);

	if (surf == "") // note - no q1 mode qual on surface string
	{
		surfnum = -1;
		t = FALSE;
		f = e;
		if (v == v0 && !f) f = self;
		if (v == v0 && f) v = f.origin + normalize(f.velocity) * 10;
		if (v == v0) return(t);

		if (pointcontents(v) == CONTENT_SKY) t = TRUE;

		last_texture = "";
		surfnum = getsurfacenearpoint(world, v);
	}

// new sky contents code

	if (surfnum >= 0 || surf != "")
	{
		if (surf == "") last_texture = getsurfacetexture(world, surfnum);
		else last_texture = surf;
		if (last_texture == "sky1" || last_texture == "sky4" || last_texture == "sky0" || last_texture == "sky2" || last_texture == "sky6") t = TRUE;
		else if (last_texture == "skydark") t = TRUE;
		else if (last_texture == "textures/K_sky/rabbit_skybox" || last_texture == "textures/skies/pjbasesky_arena1_sky") t = TRUE;
	}

	return(t);
};

void() sky_touch_pointer =
{

// FIX
//	if (sky_touch("", v0, self))
//	if (self.content_flag & RM_SKY) // has a remove sky setting - wont work after content_clear
//		SUB_Remove();

// IDEA - rethink code here if called as a think fn, till timeout
};


// fn(rnd_string) - randomly select one of 5 strings - great for sounds
// wt - weight seq. 1-100, if '0 0 0' chances are equal, example - for 50% rs1, 25% rs2, 12% rs3, 7% rs4, 3% rs5
//		  % for rs4 and rs5 are interpolated - w4 = z * (z / x)		 '50 25 12'
/*
		between 51 - 100 = rs1, 26 - 50 = rs2, 13 - 25 = rs3, 4 - 12 = rs4, < 4 = rs5
		THESE MUST BE IN ORDER WITH X THE LARGEST! - x > y > z AND x CANNOT be 0!
		rs1-5 strings, will return NULL if rs1 is NULL, other NULL string will not be selected
		i.e. if rs1 is the only non NULL string, it will always be the outcome

for 2 strings in rs1, rs5 
for 50/50 wt = '50 50 50'
for 75/25 wt = '75 75 75', string rs1 will be 25%
*/

string(vector wt, string rs1, string rs2, string rs3, string rs4, string rs5) rnd_string =
{
	local float w1,w2,w3,w4,rstr,cv;
	local string sl;

	sl = "";
	cv = 1;

	if (wt == ' 0 0 0') wt = ' 80.0 60.0 40.0';
	w1 = wt_x;
	w2 = wt_y;
	w3 = wt_z;
	w4 = ceil(wt_z * (wt_z / wt_x)); // gives 20 if chances eq. - 80 60 40 20

	if (rs1 != "")
	while (sl == "") 
		{
		rstr = rint(random() * 100); // 1-100
		sl = rs5;
		if (rstr > w4) sl = rs4;
		if (rstr > w3) sl = rs3;
		if (rstr > w2) sl = rs2;
		if (rstr > w1 || cv > 10) sl = rs1; // dont go past 10 iterations
		cv = cv + 1;
		}
	return sl;
};
