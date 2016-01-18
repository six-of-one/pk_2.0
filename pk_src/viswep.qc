/*

visible weapon support

Cataboligne 9.26.9
*/

// TEST - check for errors in viswep chains
string vw_error;

void(entity e) vw_errck =
{
	local entity pr, tr, ltr;
	tr = pr = e;
	ltr = world;
	while (tr)
	{
		if (tr.classname != "viswep")
		{
			vw_error = tr.classname;
			if (tr.vwepent)
			if (tr.vwepent.classname  == "viswep")
				if (tr != e) ltr = tr.vwepent;
			tr.vwepent = world;
			pr.vwepent = ltr; // always unlink - yes this is a repair in a test situ
		}
		pr = tr;
		tr = tr.vwepent;
	}
};


.float viswframe; // special framing - drop / pull [not used yet]
.entity exteriormodeltoclient; // dp var -- viswep deal - good fix for dp

string VW_DEFGUN = "progs/vw_qgun.mdl";

// fn(viswep_pre) - precache

void() viswep_pre =
{
// quake 1 weps
	precache_model ("progs/vw_qgun.mdl");
	precache_model ("progs/vw_axe.mdl");
	precache_model ("progs/vw_shot.mdl");
	precache_model ("progs/vw_dblshot.mdl");
	precache_model ("progs/vw_nailg.mdl");
	precache_model ("progs/vw_snailg.mdl");
	precache_model ("progs/vw_gren.mdl");
	precache_model ("progs/vw_rock.mdl");
	precache_model ("progs/vw_light.mdl");
// pk weps
	precache_model ("progs/vw_pnailg.mdl");
	precache_model ("progs/vw_cube.mdl");
	precache_model ("progs/vw_sentry.mdl");
	precache_model ("progs/vw_canpab.mdl");
	precache_model ("progs/vw_harp.mdl");
	precache_model ("progs/vw_airgun2.mdl");
	precache_model ("progs/vw_clight.mdl");
	precache_model ("progs/vw_beartrap.mdl");
	precache_model ("progs/vw_pkp_actor.mdl");
	precache_model ("progs/vw_pkp_ego.mdl");
	precache_model ("progs/vw_pkp_phone.mdl");
	precache_model ("progs/vw_pkp_tomb.mdl");
// armor
	precache_model ("progs/vw_armor.mdl");

};

// fn(FL_MELEE) - detect melee weps
// fn(FL_RANGE) - detect range weps

// qw - quake wep bit
// pkw - pkwep bit

float(float qw, float pkw) FL_MELEE =
{
	local float Q_MELEE, PK_MELEE;
	local float c;

	Q_MELEE = IT_AXE;
	PK_MELEE = PK_IT_AXE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_BEARTRAP | PK_IT_CANPAB | PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE;

	if (PK_100) PK_MELEE = PK_IT_AXE;

	c = FALSE;

	if (pkw)
	{
		if (pkw & PK_MELEE) c = TRUE;
		return(c);
	}

	if (qw & Q_MELEE) c = TRUE;

//	if (mc >= MC_CARRYABLE) c = TRUE; // demolition inventory bits hack
	return(c);
};

float(float qw, float pkw) FL_RANGE =
{
	local float Q_RANGE, PK_RANGE;
	local float c;

	Q_RANGE = IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING;
	PK_RANGE = PK_IT_GRAPGUN | PK_IT_AIRGUN | PK_IT_CLIGHT;

	if (PK_100) PK_RANGE = PK_RANGE | PK_IT_GRAVITYWELL | PK_IT_TURRET | PK_IT_BEARTRAP | PK_IT_CANPAB | PKPLUS_IT_EGO | PKPLUS_IT_TOMB | PKPLUS_IT_ACTOR | PKPLUS_IT_PHONE;

	c = FALSE;

	if (pkw)
	{
		if (pkw & PK_RANGE) c = TRUE;
		return(c);
	}

	if (qw & Q_RANGE) c = TRUE;

	return(c);
};

// fn(mk_pkbits) - put pkbits together for vis wep ops

// need this because pk_items have carryable bits always set

//float pkbits; // global so _ld can use it

float(entity e) mk_pkbits =
{
	local float cpkweps, nbits;

	cpkweps = PK_IT_AXE | PK_IT_GRAPGUN | PK_IT_AIRGUN | PK_IT_CLIGHT; // collectable pk weps
	nbits = e.pk_items & cpkweps;

	if(e.pk_gravitywellammo > 0) nbits = nbits | PK_IT_GRAVITYWELL;
	if(e.pk_turretammo > 0) nbits = nbits | PK_IT_TURRET;
	if(e.pk_canpabammo > 0) nbits = nbits | PK_IT_CANPAB;
	if(e.pk_beartrapammo > 0) nbits = nbits | PK_IT_BEARTRAP;
//	if(e.pk_explode_ammo > 0) nbits = nbits | 
	if(e.pkplus_egoammo > 0) nbits = nbits | PKPLUS_IT_EGO;
	if(e.pkplus_tombammo > 0) nbits = nbits | PKPLUS_IT_TOMB;
	if(e.pkplus_actorammo > 0) nbits = nbits | PKPLUS_IT_ACTOR ;
	if(e.pkplus_phoneammo > 0) nbits = nbits | PKPLUS_IT_PHONE;

	return(nbits);
};

// fn(vw_chain) - chain up viswep for an ent, rebuild vwepent list(s)

// e - ent we want viswep for

entity(entity e) vw_chain =
{
	local entity f, c, ch;

	c = world;
	ch = e;
	f = find(world,classname,"viswep");

	while (f)
	{
		if (f.owner == e)
		{
			if (!c) c = f;
//			else
//			{
//				ch.chain = f; // NOTE - use vwepent?
//			}
				// chain up any viswep with owner = world
			if (ch) ch.vwepent = f; // this becomes a list rebuild
			ch = f;
			f.vwepent = world; // unlink old stuff
		}

		f = find(f,classname,"viswep");
	}
	return (c);
};

// fn([pk]vload) - load up vwepent for an ent

// e - ent loading to
// fl - flag of wep to load

// TEST - finding viswep hanging bug
void() vwep_tst =
{
	local entity tr;

	tr = self.owner.vwepent;
	if (tr == self)
	if (0) 
	if (self.delay)
	{
		self.delay = 1;
		bprint("*** Test - tracking weps, I am a: ");
		bprint(self.model);
		if (self.vwepent) bprint(" +chain ");
		bprint(" - carried by: ");
		bprint(self.owner.netname);
		bprint(" - ");
		bprint(self.owner.classname);
		if (self.owner.ishuman) bprint(" - a human.");
		else bprint(" - a bot.");
		bprint("\n");
	}

	while (tr)
	{
		
		if (tr == self)
		{
			self.nextthink = time + 0.1;
			return;
		}
		tr = tr.vwepent;
	}
	if (!self.wait) self.wait = time;
		bprint("***			***\n");
		bprint("***			*** Test - error - we (");
		bprint(self.model);
			bprint(") have been orphaned by: ");
		bprint(self.owner.netname);
		bprint(" -  at: ");
		bprint(ftos(self.wait));
		bprint("\n");
//	self.nextthink = time + 0.1;
//	self.think = SUB_Remove;
	vw_chain(self.owner);
};

entity(entity e, float fl) vload =
{
	local entity tr;
	local string md;

	md = "";
	tr = e;
// TEST - think for vwep check
local float tst;
//if (!tr.vwepent) 
	tst = 1;

	while (tr.vwepent)
		tr = tr.vwepent;

	tr.vwepent = spawn();
	setorigin(tr.vwepent, e.origin);
	tr.vwepent.vwepent = world;
	tr.vwepent.owner = e;
	tr.vwepent.classname = "viswep";
	setsize (tr.vwepent, v0, v0);

	tr.vwepent.weapon = fl;
	tr.vwepent.pk_currentitem = 0;

	if (fl == IT_AXE) md = "progs/vw_axe.mdl";
	else if (fl == IT_SHOTGUN) md = "progs/vw_shot.mdl";
	else if (fl == IT_SUPER_SHOTGUN) md = "progs/vw_dblshot.mdl";
	else if (fl == IT_NAILGUN && PK) md = "progs/vw_pnailg.mdl";
	else if (fl == IT_NAILGUN) md = "progs/vw_nailg.mdl";
	else if (fl == IT_SUPER_NAILGUN) md = "progs/vw_snailg.mdl";
	else if (fl == IT_GRENADE_LAUNCHER) md = "progs/vw_gren.mdl";
	else if (fl == IT_ROCKET_LAUNCHER) md = "progs/vw_rock.mdl";
	else if (fl == IT_LIGHTNING) md = "progs/vw_light.mdl";
	else if (fl == IT_ARMOR1) md = "progs/vw_armor.mdl";
	if (md == "") md = VW_DEFGUN;
	tr.vwepent.mdl = md;
	setmodel(tr.vwepent, md);

/*
	if (DARKPLACES) // TEST - trying movement deal - movetype 12
	{
		tr.vwepent.movetype = MOVETYPE_FOLLOW; // make the tr.vwepent follow
		tr.vwepent.solid = SOLID_NOT; // MOVETYPE_FOLLOW is always non-solid
		tr.vwepent.aiment = e; // make the tr.vwepent follow e
		tr.vwepent.punchangle = e.angles; // the original angles of e
		tr.vwepent.view_ofs = '0 0 0'; //tr.vwepent.origin - e.origin; // relative origin
		tr.vwepent.v_angle = '0 0 0'; //tr.vwepent.angles - e.angles; // relative angles
	}
*/

// TEST
//if (fl != IT_AXE) {
if (0) {
bprint(" -----		  call load: ");
bprint(md);
bprint(" for: ");
bprint(e.netname);
bprint("\n");
}
if (tst)
{
	tr.vwepent.think = vwep_tst;
	tr.vwepent.nextthink = time + 0.5;
}
	return(tr.vwepent);
};

//TEST
entity

//void
(entity e, float fl) pkvload =
{
	local entity tr;
	local string md;

	tr = vload(e, IT_AXE);

	md = "";
//	tr = e;
//	while (tr.vwepent)
//		tr = tr.vwepent;

	tr.pk_currentitem = fl;
	if (fl == PK_IT_AXE) md = "progs/vw_axe.mdl";
	else if (fl == PK_IT_GRAVITYWELL) md = "progs/vw_cube.mdl";
	else if (fl == PK_IT_TURRET) md = "progs/vw_sentry.mdl";
	else if (fl == PK_IT_CANPAB) md = "progs/vw_canpab.mdl";
	else if (fl == PK_IT_GRAPGUN) md = "progs/vw_harp.mdl";
	else if (fl == PK_IT_AIRGUN) md = "progs/vw_airgun2.mdl";
	else if (fl == PK_IT_CLIGHT) md = "progs/vw_clight.mdl";
	else if (fl == PK_IT_BEARTRAP) md = "progs/vw_beartrap.mdl";
	else if (fl == PKPLUS_IT_EGO) md = "progs/vw_pkp_ego.mdl";
	else if (fl == PKPLUS_IT_TOMB) md = "progs/vw_pkp_tomb.mdl";
	else if (fl == PKPLUS_IT_ACTOR) md = "progs/vw_pkp_actor.mdl";
	else if (fl == PKPLUS_IT_PHONE) md = "progs/vw_pkp_phone.mdl";

	if (md == "") md = VW_DEFGUN;
	tr.mdl = md;
	setmodel(tr, md);

// TEST
if (0) {
bprint(" -----		call pkload: ");
bprint(md);
bprint(" for: ");
bprint(e.netname);
bprint("\n");
}

if (1)
{
	tr.think = vwep_tst;
	tr.nextthink = time + 0.5;
}
return(tr);
// TEST


};

// fn (vchk) - check for a given item & return ent pointer if found

// can be used for vw special

entity(float qw, float pkw, entity vh) vchk =
{
	local entity f;

	f = vh;
	while (f)
	{
		if (f.weapon == qw && f.pk_currentitem == pkw) return (f);
		f = f.vwepent;
	}
	return(world);
};

// fn (viswep_ld) - load or unload viswep models

// vh - head ent
// e - player ent
// cd - 1 = load em up, -1 = unload em
//			future expansion: -1 dead throw em, -2 unload em
//			-3 - init, unload then countdown set

void(entity e, float cd) viswep_ld =
{
	local entity tr, pr;
	local float pkbits, bts, pkts, f, at;

local entity vh; //TEST now
	tr = vh = e.vwepent;
	pr = e;
	at = pkts = bts = 0;

	pkbits = mk_pkbits(e);

// TEST
	local float nvw, fld;
if (!tr) nvw = 1;// came in with null viswep set


// NOTE: fix - need unload (-1) here
	if (cd < 0)
	{


// TEST
if (0) //!tr) // came in with null viswep set
if (!tr)
{
	bprint("*** null viswep set for: ");
	bprint(self.netname);
	bprint(" - ");
	bprint(self.classname);
	bprint("\n");
}


		while (tr)
		{


// TEST
if (0) {
if (tr == vh) bprint(">>>    Unlinking for ");
if (tr == vh) bprint(tr.owner.netname);
if (tr == vh) bprint("	---	");
bprint(tr.model);
bprint(" --- ");
}

// TEST *** VW ERROR
if (tr == vh) {vw_errck(vh);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: viswep_ld: ");
		bprint(ftos(cd));
		bprint("\n");
	}}


			pr = tr;
			tr = tr.vwepent;
			pr.mdl = "";
			remove(pr);

// TEST
if (0) 
if (!tr)
{
bprint(" -- ");
bprint(ftos(tr.owner.items));
bprint(" -- pk = ");
bprint(ftos(mk_pkbits(tr.owner)));
}

		}
		if (e) // because we may come here with self = first viswep ent
		if (e.classname != "viswep")
			e.vwepent = world;

// TEST
//bprint("\n");


//		if (cd == -3)
//		{
//			self.vwepent = spawn();
//			self.vwepent.delay = time + 1;
//		}
		return;
	}

// TEST
float unlk;

// have items & check for inventory
	while (tr)
	{
		pr = world;
		if (tr.armortype)
		{
			at = e.armortype;
			if (!at)
			{
//				tr.mdl = "";
//				tr.think = SUB_Remove;
//				tr.nextthink = time + 0.01;
//				tr.model = "";
				pr = tr.vwepent;
				remove(tr);
			}
			if (at > 0.6) tr.skin = 2;
			else if (at <= 0.6) tr.skin = 1;
			else if (at <= 0.3) tr.skin = 0;
			tr.armortype = at;
		}
		else
		if (tr.weapon != IT_AXE || !pkbits)
		{
			if (! tr.weapon & e.items)
			{


// TEST
if (0) {
		bprint("*** Unlinking -  a: ");
		if (tr.model != "") bprint(tr.model);
		else  eprint(tr);
//		else { bprint(tr.classname); bprint(" - "); bprint(tr.netname); }
		if (tr.vwepent) bprint(" +chain ");
		bprint(" - carried by: ");
		bprint(tr.owner.netname);
		bprint(" - ");
		bprint(tr.owner.classname);
		if (tr.owner.ishuman) bprint(" - a human -- ");
		else bprint(" - a bot -- ");
bprint(ftos(tr.owner.items));
bprint(" -- pk = ");
bprint(ftos(mk_pkbits(tr.owner)));
		bprint("\n");
		unlk = 1;
}

//				tr.mdl = "";
//				tr.think = SUB_Remove;
//				tr.nextthink = time + 0.01;
//				tr.model = "";
//				pr.vwepent = tr.vwepent;
				pr = tr.vwepent;
				remove(tr);
				}
			else
				bts = bts | tr.weapon;
		}
		else
		{
			if (! tr.pk_currentitem & pkbits)
			{


// TEST
if (0) {
		bprint("*** Unlinking -  a: ");
		if (tr.model != "") bprint(tr.model);
		else  eprint(tr);//{ bprint(tr.classname); bprint(" - "); bprint(tr.netname); }
		if (tr.vwepent) bprint(" +chain ");
		bprint(" - carried by: ");
		bprint(tr.owner.netname);
		bprint(" - ");
		bprint(tr.owner.classname);
		if (tr.owner.ishuman) bprint(" - a human -- ");
		else bprint(" - a bot -- ");
bprint(ftos(tr.owner.items));
bprint(" -- pk = ");
bprint(ftos(mk_pkbits(tr.owner)));
		bprint("\n");
		unlk = 1;
}

//				tr.mdl = "";
//				tr.think = SUB_Remove;
//				tr.nextthink = time + 0.01;
//				tr.model = "";
//				pr.vwepent = tr.vwepent;
				pr = tr.vwepent;
				remove(tr);
			}
			else
				pkts = pkts | tr.pk_currentitem;
		}
//		pr = tr;
		if (pr) tr = pr;
		else if (tr) tr = tr.vwepent;


// TEST
if (0) //unlk)
{
		bprint("    --- Unlinked ");
		if (tr) bprint("trace is: ");
		if (tr) bprint(tr.model);
//		if (pr) if (pr.model != "") bprint(" -  prev is: ");
//		if (pr) if (pr.model != "") bprint(pr.model);
//		if (pr) if (pr.model == "") bprint(" -  prev is deleted ");
		if (tr.vwepent) bprint(" -  next trace is: ");
		if (tr.vwepent) bprint(tr.vwepent.model);
		if (!tr) bprint(" -  nothing left.");
		bprint("\n");
}
unlk = 0;


	}

	if (VW_ARMOR)
	if (e.armortype && !at)
	{
		tr = vload(e, IT_ARMOR1);

// TEST
if (0) 
if (!nvw) {
if (!fld) {
	bprint(">>>    loading arm for ");
	bprint(self.netname);
	bprint("	---	");
	fld = 1;
}
		bprint(tr.model);
		bprint(" --- ");
}


		tr.armortype = at = e.armortype;
		if (tr.armortype > 0.6) tr.skin = 2;
		else if (tr.armortype <= 0.6) tr.skin = 1;
		else if (tr.armortype <= 0.3) tr.skin = 0;
	}
//	if (!pkbits)
//	if ((self.items & IT_AXE) && !(bts & IT_AXE))
//		vload(self, IT_AXE);

	f = 1;
	while ( f & qweps && f < 8388609 ) // NOTE: this will not load an axe
	{
		if ((e.items & f) && !(bts & f)){
// TEST
			tr = 
			vload(e, f);

// TEST
if (0) 
if (!nvw) {
if (!fld) {
	bprint(">>>    loading qw for ");
	bprint(self.netname);
	bprint("	---	");
	fld = 1;
}
		bprint(tr.model);
		bprint(" --- ");

}
}


		f = f * 2;
	}

	f = 1;
	while ( f & pkweps && f < 8388609 )
	{
		if ((pkbits & f) && !(pkts & f)){
// TEST
			tr = 
			pkvload(e, f);

// TEST
if (0) 
if (!nvw) {
if (!fld) {
	bprint(">>>    loading pkw for ");
	bprint(self.netname);
	bprint("	---	");
	fld = 1;
}
		bprint(tr.model);
		bprint(" --- ");
}

}


		f = f * 2;
	}

if (0) 
if (fld)  {
bprint(" -- ");
bprint(ftos(self.items));
bprint(" -- pk = ");
bprint(ftos(mk_pkbits(self)));
bprint("\n");
}


// TEST *** VW ERROR
vw_errck(vh);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: viswep_ld: ");
		bprint(ftos(cd));
		bprint("\n");
	}

// TEST 
if (0) 
if (nvw)
{
	tr = self.vwepent;
bprint(">>>    Just linked for ");
bprint(tr.owner.netname);
bprint(" - self = ");
bprint(self.netname);
bprint("	---	");
	while (tr)
	{
		bprint(tr.model);
		bprint(" --- ");
		tr = tr.vwepent;
	}
bprint(" -- ");
bprint(ftos(self.items));
bprint(" -- pk = ");
bprint(ftos(mk_pkbits(self)));
bprint("\n");
}

};

// fn(viswep_pkbot) - load / unload pkbots

float vw_bot_frame; // handle pk*bots

void() viswep_pkbot =
{
	local entity sv;

	vw_bot_frame = framecount;

	sv = self;
	self = find(world,classname,"pk*bot");
	while (self)
	{
		viswep_post();


// TEST *** VW ERROR
vw_errck(self.vwepent);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: pkbot post: ");
		bprint(self.netname);
		bprint("\n");
	}


// bot post think checks - NOTE: need to go elsewhere
		if (self.copb_timeout)
		{
			if (self.copb_timeout >= time)
			{
				copb_checkFart();
			}
			else
			{
				self.copb_timeout = 0;
			}
		}

		self = find(self,classname,"pk*bot");
	}

	self = sv;
};

// fn(viswep_post) - postthink viswep run code

// self - player ent

float vw_frame; // once per frame

void() viswep_post =
{
	local entity vhead;
	local float qld, pkbits; 

//	if (!self.flags & FL_CLIENT) return;

	vw_chain(self);

// TEST *** VW ERROR
vw_error = "";

vhead = find(world,classname,"pk*bot");
while (vhead)
	{
		if (vhead.vwepent)
			vw_errck(vhead.vwepent);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: master entry: ");
		bprint(vhead.netname);
		bprint("\n");
	}
vw_error = "";

		vhead = find(vhead,classname,"pk*bot");
	}
vhead = find(world,classname,"player");
while (vhead)
	{
	if (vhead.vwepent)
		vw_errck(vhead.vwepent);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: master entry: ");
		bprint(vhead.netname);
		bprint("\n");
	}
vw_error = "";

		vhead = find(vhead,classname,"player");
	}
// TEST *** VW ERROR
//vw_errck(self.vwepent);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: post entry: ");
		bprint(self.netname);
		bprint("\n");
	}

	if (vw_bot_frame != framecount)
	if (self.classname != "pk*bot" && self.ishuman) viswep_pkbot();

														// NOTE - check this vs. invisibility for norm & morphs
	if (self.deadflag || self.classname == OBSERVER || self.view_ofs == '0 0 0' || self.model == "") //(self.admin && self.admin != USER_MENU)) //intermission_running)
	{


vw_errck(self.vwepent);


		if (self.vwepent) viswep_ld(self, -2); // unload all weps - for now just removes ent, later deadthrow what's not put in pack if died


// TEST *** VW ERROR
//vw_errck(self.vwepent);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: viswep logical (dead etc) unload on: ");
		bprint(self.netname);
		bprint("\n");
	}


		return;
	}

	vhead = self.vwepent;

//	qld = FALSE;

	if (PK_100 || Q_100)
	{
		if (!vhead)
		{
			vload(self, 8388608);
			if (self.weapon == IT_AXE && !self.pk_currentitem || self.pk_currentitem == PK_IT_AXE)
				vload(self, IT_AXE);
		}
		else
		{
			if (self.weapon == IT_AXE && !self.pk_currentitem || self.pk_currentitem == PK_IT_AXE)
			{
				if (!self.vwepent.vwepent) vload(self, IT_AXE);
			}
			else
			{
				if (self.vwepent.vwepent)
				{
					self.vwepent.vwepent.mdl = "";
					remove(self.vwepent.vwepent);
					self.vwepent.vwepent = world;
				}
			}
		}


// TEST *** VW ERROR
vw_errck(self.vwepent);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: viswep PK100 or Q100 on: ");
		bprint(self.netname);
		bprint("\n");
	}


	}
	else
	{

	if (!vhead){
		viswep_ld(self, 1);


// TEST *** VW ERROR
vw_errck(self.vwepent);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: viswep init - no chain on: ");
		bprint(self.netname);
		bprint("\n");
	}
}

	else
	{
		if (self.items & qweps != vhead.items || vhead.armorvalue != self.armortype * VW_ARMOR) qld = TRUE;

		pkbits = mk_pkbits(self);
		if (vhead.pk_items != pkbits || qld) viswep_ld(self, 1);
	}


// TEST *** VW ERROR
vw_errck(self.vwepent);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: viswep updating existing on: ");
		bprint(self.netname);
		bprint("\n");
		
//		viswep_ld(vhead, -1);
//		viswep_ld(vhead, 1);
	}


	
	}

	if (!self.vwepent) return;

// detect changes later
	vhead = self.vwepent;
	vhead.items = self.items & qweps;
	vhead.pk_items = pkbits;
	vhead.armorvalue = self.armortype; // FIX - does not match above test - will always cause qld if armortype & VW_ARMOR = 0

// run viswep frame match

	local float vadd, vframe, dwep, gremlin_frame_adjust, grap_frame_adjust, pkdwep;
	local vector vofs, vang; // gremlin vwep offsets

	if (vhead)
		{
		vhead.owner.viswframe = -1; // FIX - remove to use visframe code anywhere
		vang = v_forward;
		vang_z = 0;
//		makevectors(vang);
		}

	dwep = vhead.owner.weapon; // active wep, or pulled
	pkdwep = vhead.owner.pk_currentitem;
//	if (vhead.owner.flags & FL_DROP) dwep = vhead.owner.prev_weapon; // drop this down first

	while (vhead) // IDEA - do this in engine & test above for chaos = CHAOS_ENGINE
		{
		qld = grap_frame_adjust = gremlin_frame_adjust = vadd = 0;
//		vofs = vhead.finaldest_x * normalize(vang) + vhead.finaldest_y * normalize(v_right);
	//	vofs_z = vhead.finaldest_z;
		if (vhead.owner.items & IT_INVISIBILITY) vhead.model = ""; // heh heh, player invisible
		else
		if (vhead.mdl != "" && vhead.classname == "viswep") // TEST - fix can not modify free ent, by ignoring anything not a viswep
		if (vhead.model == "" || (vhead.origin + vofs) != vhead.owner.origin || vhead.angles != vhead.owner.angles || vhead.weaponframe != vhead.owner.frame) // update track
			{
			if (vhead.model == "") setmodel(vhead, vhead.mdl);
			vhead.weaponframe = vhead.owner.frame; // track player frame, vw .frame may not match

			vframe = vhead.owner.frame;
																		// adjust for gremlin flying frames & carried gun, pretty hackish isnt it?
//			if (vhead.owner.model == "progs/gremlin-fly.mdl" && vhead.owner._stand == gremlin_hover && vhead.owner.frame >= grem_fly_frame) gremlin_frame_adjust = grem_fly_frame;
	
			if( ! (vhead.owner.dest2_x & CHSCAM_ON) ) vhead.exteriormodeltoclient = vhead.owner; // darkplaces - works for dp!
			else vhead.exteriormodeltoclient = world;

			if (PK_100 || Q_100)
			{
				if (vhead.weapon != IT_AXE && dwep != IT_AXE) qld = TRUE;
				else if (vhead.pk_currentitem != PK_IT_AXE && pkdwep != PK_IT_AXE) qld = TRUE;
				else if (vhead.weapon == IT_AXE && dwep == IT_AXE) qld = TRUE;
			}
			else if (dwep > 0)
			{
				if ((vhead.weapon == dwep) && (dwep != IT_AXE)) qld = TRUE; // main weapon - not holstered
				else if ((vhead.weapon == dwep) && (vhead.pk_currentitem == pkdwep)) qld = TRUE;
			}

			if (qld)
				{
																		// grap hook out - adjust run / stand frameset
				if (vhead.mdl == "progs/vw_harp.mdl" && vhead.owner.grap_cornerchainNext != world && (vhead.owner.frame - gremlin_frame_adjust)< 11) // $pain1
					grap_frame_adjust = VW_HARP_FRADJ;
				vofs = ' 0 0 0';
				if (vhead.owner.viswframe > -1) vframe = vhead.owner.viswframe;
				if (FL_MELEE(vhead.weapon, vhead.pk_currentitem)) {
					if ( (vhead.owner.frame - gremlin_frame_adjust) >= melee_frames) vadd = viswaddf - melee_frames;
					} else if (FL_RANGE(vhead.weapon, vhead.pk_currentitem) || (vhead.mdl == VW_DEFGUN)) {
					if ( (vhead.owner.frame - gremlin_frame_adjust) < range_frames) vadd = viswaddf;
				 }

				} // IDEA - viswframe weps on gremlins back for special frames
			vhead.frame = vframe + vadd - gremlin_frame_adjust - grap_frame_adjust;
//			if (!DARKPLACES) // TEST --- movetype 12
//				{
				setorigin(vhead, vhead.owner.origin + vofs); // ... sync visible weapon model
				vhead.angles = vhead.owner.angles;
//				}
			}
		vhead = vhead.vwepent;
		}

// TEST *** VW ERROR
vw_errck(self.vwepent);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: post exit: ");
		bprint(self.netname);
		bprint("\n");
	}
/*
	vhead = find(world,classname,"viswep");
	while (vhead)
	{
		if (vhead.vwepent)
		if (vhead.vwepent.classname != "viswep")
		{
		bprint("vw error - ");
		bprint(vhead.vwepent.classname);
		if (vhead.vwepent.classname == "")
			bprint(vhead.vwepent.netname);
			
		bprint(" found in master test exit by: ");
		bprint(vhead.model);
		bprint(" - ");
		bprint(vhead.owner.netname);
		bprint("\n");
		
		vhead.vwepent = world; // NOTE: fixing in test!
		}
		vhead = find(vhead,classname,"viswep");
	}
*/
vw_error = "";

	vhead = find(world,classname,"pk*bot");
	while (vhead)
	{
		if (vhead.vwepent)
			vw_errck(vhead.vwepent);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: master exit: ");
		bprint(vhead.netname);
		bprint("\n");
	}
vw_error = "";

		vhead = find(vhead,classname,"pk*bot");
	}
	vhead = find(world,classname,"player");
	while (vhead)
	{
		if (vhead.vwepent)
			vw_errck(vhead.vwepent);
if (vw_error != "")
	{
		bprint("vw error - ");
		bprint(vw_error);
		bprint(" found in vw chain for: master exit: ");
		bprint(vhead.netname);
		bprint("\n");
	}
vw_error = "";

		vhead = find(vhead,classname,"player");
	}

};

// run full viswep frames for super nailgun / nailgun

void() player_nail3   =[$lightfatt3, player_nail4  ] 
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireSpikes (4);
	self.attack_finished = time + 0.2;
};
void() player_nail4   =[$lightfatt4, player_nail1  ] // *pk - viswep - Cataboligne - 9.29.9
{
	self.effects = self.effects | EF_MUZZLEFLASH;

	if (!self.button0)
		{player_run ();return;}
	self.weaponframe = self.weaponframe + 1;
	if (self.weaponframe == 9)
		self.weaponframe = 1;
	SuperDamageSound();
	W_FireSpikes (-4);
	self.attack_finished = time + 0.2;
};

// run full viswep frames for chain thunderbolt

void() player_bolt3	 =[$lightfatt3, player_bolt4  ]
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

void() player_bolt4	 =[$lightfatt4, player_bolt1  ]
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

// fn(grap_vw_adj) - adjust start position for viswep location

vector(entity hent) grap_vw_adj =
{
	local vector vwa;

	vwa = v0;
	if (!hent) return (vwa);
//	if (hent.flags & FL_CLIENT)
	makevectors(hent.v_angle);
	if (hent.frame > 10) // retr | shoot frames
	{
		vwa = VWX_HARP_RETR * v_forward + VWY_HARP_RETR * v_right + VWZ_HARP_RETR * v_up;
	}
	else
	{
		vwa = VWX_HARP_IDLE * v_forward + VWY_HARP_IDLE * v_right + VWZ_HARP_IDLE * v_up;
	}
	return(vwa);
};
