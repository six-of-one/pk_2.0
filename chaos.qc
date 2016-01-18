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

/*
		+---------------------------------------+
		|  bit operations code                  | SEC-HEAD
		+---------------------------------------+
*/

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

// fn(return_bit) - return a requested bit from a value and mask if available

// bt - bit value
// msk - mask value
// op - operation
// df - default return value

float BIT_HIGH = 8388608;
float BIT_LOW = 1;

float (float bt, float msk, float op, float df) return_bit =
{
	local float f, v, sf;

	f = op;
	v = bt;
	sf = 64;
	if (msk != 0) v = bt & msk;
	if (!v) return(df);

	while (1)
	{
		if (v & f) return (f);
		if (op == BIT_LOW) f = f * 2;
		else //if (op == BIT_HIGH) - op doesnt have to be bit high
			f = floor(f / 2);
		sf = sf - 1;
		if (sf < 0 || f < BIT_LOW || f > BIT_HIGH) return(df);
	}
	return(df); // never executes - for dumb compiler warning
};

// given a mask (max value of all 1s - does not mask bits to print), print a bit set as string of 1s & 0s

void(float msk, float bt) bit_print =
{
	local float b, f, sf ;
	local string b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11 , b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23, b24;  

	if (msk < 1) return;
	if (bt < 1) bt = 0;

	b = fabs(bt);
	f = fabs(msk);
	sf = 24;

	while (sf > 0 && f >= 1)
	{
/*
bprint("mask: ");
bprint(ftos(f));
bprint(" bit: ");
bprint(ftos(b&1));
bprint(" sf: ");
bprint(ftos(sf));
bprint("\n");*/
		if (sf == 24) b1 = ftos(b & 1);
		else if (sf == 23) b2 = ftos(b & 1);
		else if (sf == 22) b3 = ftos(b & 1);
		else if (sf == 21) b4 = ftos(b & 1);
		else if (sf == 20) b5 = ftos(b & 1);
		else if (sf == 19) b6 = ftos(b & 1);
		else if (sf == 18) b7 = ftos(b & 1);
		else if (sf == 17) b8 = ftos(b & 1);
		else if (sf == 16) b9 = ftos(b & 1);
		else if (sf == 15) b10 = ftos(b & 1);
		else if (sf == 14) b11 = ftos(b & 1);
		else if (sf == 13) b12 = ftos(b & 1);
		else if (sf == 12) b13 = ftos(b & 1);
		else if (sf == 11) b14 = ftos(b & 1);
		else if (sf == 10) b15 = ftos(b & 1);
		else if (sf == 9) b16 = ftos(b & 1);
		else if (sf == 8) b17 = ftos(b & 1);
		else if (sf == 7) b18 = ftos(b & 1);
		else if (sf == 6) b19 = ftos(b & 1);
		else if (sf == 5) b20 = ftos(b & 1);
		else if (sf == 4) b21 = ftos(b & 1);
		else if (sf == 3) b22 = ftos(b & 1);
		else if (sf == 2) b23 = ftos(b & 1);
		else if (sf == 1) b24 = ftos(b & 1);
		b = floor(b / 2);
		f = floor(f / 2);
		sf = sf - 1;
	}
	if (sf < 1)		bprint(b24);
	if (sf < 2)		bprint(b23);
	if (sf < 3)		bprint(b22);
	if (sf < 4)		bprint(b21);
	if (sf < 5)		bprint(b20);
	if (sf < 6)		bprint(b19);
	if (sf < 7)		bprint(b18);
	if (sf < 8)		bprint(b17);
	if (sf < 9)		bprint(b16);
	if (sf < 10)	bprint(b15);
	if (sf < 11)	bprint(b14);
	if (sf < 12)	bprint(b13);
	if (sf < 13)	bprint(b12);
	if (sf < 14)	bprint(b11);
	if (sf < 15)	bprint(b10);
	if (sf < 16)	bprint(b9);
	if (sf < 17)	bprint(b8);
	if (sf < 18)	bprint(b7);
	if (sf < 19)	bprint(b6);
	if (sf < 20)	bprint(b5);
	if (sf < 21)	bprint(b4);
	if (sf < 22)	bprint(b3);
	if (sf < 23)	bprint(b2);
	if (sf <24)		bprint(b1);
};

// return 2^rl, bounded by 2^0 (lowest bit, 1) to 2^23 (highest bit, 8388608)

/*  code table:
1					0
2					1
4					2
8					3
16					4
32					5
64					6
128				7
256				8
512				9
1024				10
2048				11
4096				12
8192				13
16384				14
32768				15
65536				16
131072			17
262144			18
524288			19
1048576			20
2097152			21
4194304			22
8388608			23
*/

float (float rl) AdminBitFlag =
{
	local float f, e;

	f = floor(rl);
	if (f < 0 || f > 23) return(0);
	e = 1;
	while (f > 0)
	{
		f = f - 1;
		e = e * 2;
	}
	return(e);
};

// return a random bit from a mask

float(float msk) rnd_bit_mask =
{
	float f, sf, mm, b;

	if (msk < 1) return(0); // no other possibilities
	if (msk == 1) return(1);

	b = mm = 0;
	f = 1;
	if (f & msk) b = f;
	while (msk > f && mm < 23) // max out rnd selector
	{
		mm = mm + 1;
		f = AdminBitFlag(mm);
		if (!b)
		if (f & msk) b = f;
	}

	f = 0;
	sf = 100;
	while (f == 0 && sf > 0)
	{
		f = AdminBitFlag(random() * mm);
		if (! (f & msk)) f = 0;
		sf = sf - 1;
	}
	if (!f) // damn - didnt get one? - take first bit then
		f = b;
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
	if (DARKPLACES) // || chaos
		return(getsurfacenumpoints_wrap(e, s));
};
vector(entity e, float s, float n) getsurfacepoint =
{
	if (DARKPLACES)
		return(getsurfacepoint_wrap(e, s, n));
};
vector(entity e, float s) getsurfacenormal =
{
	if (DARKPLACES)
		return(getsurfacenormal_wrap(e, s));
};
string(entity e, float s) getsurfacetexture =
{
	if (DARKPLACES)
		return(getsurfacetexture_wrap(e, s));
};
float(entity e, vector p) getsurfacenearpoint =
{
	if (DARKPLACES)
		return(getsurfacenearpoint_wrap(e, p));
};
vector(entity e, float s, vector p) getsurfaceclippedpoint =
{
	if (DARKPLACES)
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

// IDEA: limit re-entry

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
		else if (last_texture == "c1_") t = TRUE;
		else if (last_texture == "textures/K_sky/rabbit_skybox" || last_texture == "textures/skies/pjbasesky_arena1_sky") t = TRUE;
	}

	return(t);
};

void() sky_touch_pointer =
{

// UNKNOWN op - decide what is happening with this code
//	if (sky_touch("", v0, self))
//	if (self.content_flag & RM_SKY) // has a remove sky setting - wont work after content_clear
//		SUB_Remove();

// IDEA: rethink code here if called as a think fn, till timeout
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

// fn(info_think) - think to display various info

// TESTING
float zz;

void () info_think =
{
	if (self.button0) 
	{
		bprint(self.noise);
		bprint(ftos(self.button0));
		bprint("\n");
	}
	else if (self.noise) bprint(self.noise);

	if (self.button1) 
	{
		bprint(self.noise1);
		bprint(ftos(self.button1));
		bprint("\n");
	}
	else if (self.noise1) bprint(self.noise1);

	if (self.button2) 
	{
		bprint(self.noise2);
		bprint(ftos(self.button2));
		bprint("\n");
	}
	else if (self.noise2) bprint(self.noise2);

	if (self.items) 
	{
		bprint(self.noise3);
		bprint(ftos(self.items));
		bprint("\n");
	}
	else if (self.noise3) bprint(self.noise3);

	if (self.weapon)
	{
		bprint(self.noise4);
		bit_print(MAXFL, self.weapon);
		bprint("\n");
	}
	else
	if (self.pos1) 
	{
		bprint(self.noise4);
		bprint(vtos(self.pos1));
		bprint("\n");
	}
	else if (self.noise4) bprint(self.noise4);

	if (self.target) bprint(self.target);
	if (self.target1) bprint(self.target1);
	if (self.target2) bprint(self.target2);

	remove(self);
};

float info_ttime;

void(float tm, string l1, string l2, string l3, string l4, string l5, float f1, float f2, float f3, float f4, vector v1, float bp) spawn_infot =
{
	local entity e;
	local float t;

	if (!WARNING) return;

	e = spawn();
	if (l1) e.noise = l1;
	if (l2) e.noise1 = l2;
	if (l3) e.noise2 = l3;
	if (l4) e.noise3 = l4;
	if (l5) e.noise4 = l5;

	if (f1) e.button0 = f1;
	if (f2) e.button1 = f2;
	if (f3) e.button2 = f3;
	if (f4) e.items = f4;
	if (v1 != v0) e.pos1 = v1;
	if (bp) e.weapon = bp;

	e.think = info_think;
	t = time + tm;
	if (t <= info_ttime) t = info_ttime + 1;
	e.nextthink = t;
	info_ttime = t;
}

// spawn_infot(1, "", "",  "",  "",  "", 0, 0, 0, 0, v0, 0);