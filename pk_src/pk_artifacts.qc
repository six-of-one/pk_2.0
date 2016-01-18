/* ::-::
 *
 * Cataboligne
 *
 * file: pk_art.defs.qc
 *
 * date: 8/12/09
 *
 * qc - support painkeep artifacts mod (tho 'tis a silly mod)
 *
 */

/* also referred to as painkeep plus

coding NOTES:

in most fn's self must be player ent requiring access to pk artifacts - this code is not generic

*/



// fn(pk_art_specialimpulse) - test for pk artifact impulse codes - note: do not like it done this way

void(float pkimp) pk_art_specialimpulse =
{
	if (pkimp == 161)
	{
		if (self.pkplus_egoammo < 1) return ;
		self.pk_currentitem = PKPLUS_IT_EGO;
		self.pk_currentInventory = PKPLUS_IT_EGO;
	}
	else if (pkimp == 162)
	{
		if (self.pkplus_tombammo < 1) return ;
		self.pk_currentitem = PKPLUS_IT_TOMB;
		self.pk_currentInventory = PKPLUS_IT_TOMB;
	}
	else if (pkimp == 163)
	{
	if (self.pkplus_actorammo < 1) return ;
	self.pkplus_actorskin = PKPLUS_ACTORPENT;
	self.pk_currentitem = PKPLUS_IT_ACTOR;
	self.pk_currentInventory = PKPLUS_IT_ACTOR;
	}
	else if (pkimp == 164)
	{
		if (self.pkplus_actorammo < 1) return ;
		self.pkplus_actorskin = PKPLUS_ACTORQUAD;
		self.pk_currentitem = PKPLUS_IT_ACTOR;
		self.pk_currentInventory = PKPLUS_IT_ACTOR;
	}
	else if (pkimp == 165)
	{
		if (self.pkplus_phoneammo < 1) return ;
		self.pk_currentitem = PKPLUS_IT_PHONE;
		self.pk_currentInventory = PKPLUS_IT_PHONE;
	}
};

 

// fn(pk_art_movshot_ck) - check pk artifacts to see if they can be moved or shot at

// return TRUE if none are or not using pk art

float(entity ck, string prv) pk_art_movshot_ck =
{
	local float ev;

	ev = TRUE;
	if (!PK_ART) return(ev);

	if (ck.classname == "tomb" && (prv == "turret" || prv == "horn"))
		ev = FALSE;
	else if (ck.classname == "touchtomb" && (prv == "turret" || prv == "horn"))
		ev = FALSE;
	else if (ck.classname == "ego" && prv == "grav")
		ev = FALSE;
	else if (ck.classname == "corpse" && prv != "horn")
		ev = FALSE;
	else if (ck.classname == "func_button" && prv == "turret") // CHECK: is this test needed??
		ev = FALSE;

	return(ev);
};


// fn(pk_art_prinv) - print pk artifacts inventory with rest of pk inventory of same nature

void() pk_art_prinv =
{
	local float f;

	f = FALSE;
	if (self.pkplus_egoammo > 0)
	{
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,6767882);
		WriteB3 (MSG_ONE,2126703);
		WriteB3 (MSG_ONE,8250);
		WriteBFloat (MSG_ONE,self.pkplus_egoammo);
		f = TRUE;
	}
	if (self.pkplus_tombammo > 0)
	{
		WriteB3 (MSG_ONE,7296010);
		WriteB3 (MSG_ONE,7561837);
		WriteB3 (MSG_ONE,2112032);
		WriteBFloat (MSG_ONE,self.pkplus_tombammo);
		f = TRUE;
	}
	if (self.pkplus_actorammo > 0)
	{
		WriteB3 (MSG_ONE,32);
		WriteB3 (MSG_ONE,6504714);
		WriteB3 (MSG_ONE,7499636);
		WriteB3 (MSG_ONE,3809395);
		WriteB3 (MSG_ONE,32);
		WriteBFloat (MSG_ONE,self.pkplus_actorammo);
		f = TRUE;
	}
	if (self.pkplus_phoneammo > 0)
	{
		WriteB3 (MSG_ONE,8224);
		WriteB3 (MSG_ONE,6636298);
		WriteB3 (MSG_ONE,7695468);
		WriteB3 (MSG_ONE,7496044);
		WriteB3 (MSG_ONE,6836256);
		WriteB3 (MSG_ONE,6647407);
		WriteB3 (MSG_ONE,3809395);
		WriteB3 (MSG_ONE,32);
		WriteBFloat (MSG_ONE,self.pkplus_phoneammo);
		f = TRUE;
	}
	if (f)
	{
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,2105376);
		WriteB3 (MSG_ONE,8224);
		WriteB3 (MSG_ONE,2570);
	}
};

// fn(pk_art_precache) - load er up

void() pk_art_precache =
{
	precache_sound ("ego/ego.wav");
	precache_model ("progs/ego.mdl");
	precache_model ("progs/v_ego.mdl");

	precache_model ("progs/tomb.mdl");
	precache_model ("progs/tomb2.mdl");
	precache_model ("progs/v_tomb.mdl");
	precache_sound ("tomb/heart.wav");
	precache_sound ("tomb/tombdrop.wav");
	precache_sound ("tomb/tombdie.wav");
	precache_sound ("tomb/tombopen.wav");
	precache_sound ("zombie/z_gib.wav");
	precache_model ("progs/h_zombie.mdl");

	precache_model ("progs/actor.mdl");
	precache_model ("progs/v_actorb.mdl");
	precache_model ("progs/v_actorr.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	
	precache_model ("progs/phone.mdl");
	precache_model ("progs/v_phone.mdl");
	precache_sound ("phone/phone.wav");
};

// fn(pk_art_hubmapmsg) - print messages for hub votes

// returns - TRUE if name printed, FALSE otherwise

float(string mapNamed) pk_art_hubmapmsg =
{
	local float r;

	r = FALSE;

	if (mapNamed == "pkts19")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3748211);
		r = TRUE;
	}
	else if (mapNamed == "pkts18")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3682675);
		r = TRUE;
	}
	else if (mapNamed == "pkts17")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3617139);
		r = TRUE;
	}
	else if (mapNamed == "pkts16")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3551603);
		r = TRUE;
	}
	else if (mapNamed == "pkts15")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3486067);
		r = TRUE;
	}
	else if (mapNamed == "pkts14")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3420531);
		r = TRUE;
	}
	else if (mapNamed == "pkts13")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3354995);
		r = TRUE;
	}
	else if (mapNamed == "pkts12")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3289459);
		r = TRUE;
	}
	else if (mapNamed == "pkts11")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3223923);
		r = TRUE;
	}
	else if (mapNamed == "pkts10")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3158387);
		r = TRUE;
	}
	else if (mapNamed == "pkts09")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3747955);
		r = TRUE;
	}
	else if (mapNamed == "pkts08")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3682419);
		r = TRUE;
	}
	else if (mapNamed == "pkts07")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3616883);
		r = TRUE;
	}
	else if (mapNamed == "pkts06")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3551347);
		r = TRUE;
	}
	else if (mapNamed == "pkts05")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3485811);
		r = TRUE;
	}
	else if (mapNamed == "pkts04")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3420275);
		r = TRUE;
	}
	else if (mapNamed == "pkts03")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3354739);
		r = TRUE;
	}
	else if (mapNamed == "pkts02")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3289203);
		r = TRUE;
	}
	else if (mapNamed == "pkts01")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3223667);
		r = TRUE;
	}
	else if (mapNamed == "spear")
	{
		WriteB3 (MSG_ONE,6647923);
		WriteB3 (MSG_ONE,29281);
		r = TRUE;
	}
	else if (mapNamed == "pkts00")
	{
		WriteB3 (MSG_ONE,7629680);
		WriteB3 (MSG_ONE,3158131);
		r = TRUE;
	}
	else if (mapNamed == "painkeep")
	{
		WriteB3 (MSG_ONE,6906224);
		WriteB3 (MSG_ONE,6646638);
		WriteB3 (MSG_ONE,28773);
		r = TRUE;
	}
	else if (mapNamed == "pk0")
	{
		WriteB3 (MSG_ONE,3173232);
		r = TRUE;
	}
	else if (mapNamed == "pk8")
	{
		WriteB3 (MSG_ONE,3697520);
		r = TRUE;
	}
	else if (mapNamed == "pk9")
	{
		WriteB3 (MSG_ONE,3763056);
		r = TRUE;
	}
	else if (mapNamed == "pk13")
	{
		WriteB3 (MSG_ONE,3238768);
		WriteB3 (MSG_ONE,51);
		r = TRUE;
	}
	else if (mapNamed == "pk14")
	{
		WriteB3 (MSG_ONE,3238768);
		WriteB3 (MSG_ONE,52);
		r = TRUE;
	}
	else if (mapNamed == "pk16")
	{
		WriteB3 (MSG_ONE,3238768);
		WriteB3 (MSG_ONE,54);
		r = TRUE;
	}
	else if (mapNamed == "pkn1")
	{
		WriteB3 (MSG_ONE,7236464);
		WriteB3 (MSG_ONE,49);
		r = TRUE;
	}
	else if (mapNamed == "pkn2")
	{
		WriteB3 (MSG_ONE,7236464);
		WriteB3 (MSG_ONE,50);
		r = TRUE;
	}
	else if (mapNamed == "pkn3")
	{
		WriteB3 (MSG_ONE,7236464);
		WriteB3 (MSG_ONE,51);
		r = TRUE;
	}
	else if (mapNamed == "pkn7")
	{
		WriteB3 (MSG_ONE,7236464);
		WriteB3 (MSG_ONE,55);
		r = TRUE;
	}
	else if (mapNamed == "pkn9")
	{
		WriteB3 (MSG_ONE,7236464);
		WriteB3 (MSG_ONE,57);
		r = TRUE;
	}
	else if (mapNamed == "pkn13")
	{
		WriteB3 (MSG_ONE,7236464);
		WriteB3 (MSG_ONE,13105);
		r = TRUE;
	}
	else if (mapNamed == "pkn16")
	{
		WriteB3 (MSG_ONE,7236464);
		WriteB3 (MSG_ONE,13873);
		r = TRUE;
	}
	else if (mapNamed == "air2")
	{
		WriteB3 (MSG_ONE,7498081);
		WriteB3 (MSG_ONE,50);
		r = TRUE;
	}
	else if (mapNamed == "court")
	{
		WriteB3 (MSG_ONE,7696227);
		WriteB3 (MSG_ONE,29810);
		r = TRUE;
	}
	else if (mapNamed == "air3")
	{
		WriteB3 (MSG_ONE,7498081);
		WriteB3 (MSG_ONE,51);
		r = TRUE;
	}
	else if (mapNamed == "fragtown")
	{
		WriteB3 (MSG_ONE,6386278);
		WriteB3 (MSG_ONE,7304295);
		WriteB3 (MSG_ONE,28279);
		r = TRUE;
	}
	else if (mapNamed == "doom1_e1")
	{
		WriteB3 (MSG_ONE,7303012);
		WriteB3 (MSG_ONE,6238573);
		WriteB3 (MSG_ONE,12645);
		r = TRUE;
	}
	else if (mapNamed == "haunted")
	{
		WriteB3 (MSG_ONE,7692648);
		WriteB3 (MSG_ONE,6648942);
		WriteB3 (MSG_ONE,100);
		r = TRUE;
	}
	else if (mapNamed == "factory")
	{
		WriteB3 (MSG_ONE,6512998);
		WriteB3 (MSG_ONE,7499636);
		WriteB3 (MSG_ONE,121);
		r = TRUE;
	}
	else if (mapNamed == "summerpk")
	{
		WriteB3 (MSG_ONE,7173491);
		WriteB3 (MSG_ONE,7497069);
		WriteB3 (MSG_ONE,27504);
		r = TRUE;
	}
	else if (mapNamed == "egyptra")
	{
		WriteB3 (MSG_ONE,7956325);
		WriteB3 (MSG_ONE,7500912);
		WriteB3 (MSG_ONE,97);
		r = TRUE;
	}
	else if (mapNamed == "factory2")
	{
		WriteB3 (MSG_ONE,6512998);
		WriteB3 (MSG_ONE,7499636);
		WriteB3 (MSG_ONE,12921);
		r = TRUE;
	}
	else if (mapNamed == "factory3")
	{
		WriteB3 (MSG_ONE,6512998);
		WriteB3 (MSG_ONE,7499636);
		WriteB3 (MSG_ONE,13177);
		r = TRUE;
	}
	else if (mapNamed == "toxic")
	{
		WriteB3 (MSG_ONE,7892852);
		WriteB3 (MSG_ONE,25449);
		r = TRUE;
	}
	else if (mapNamed == "q1edgepk")
	{
		WriteB3 (MSG_ONE,6631793);
		WriteB3 (MSG_ONE,6645604);
		WriteB3 (MSG_ONE,27504);
		r = TRUE;
	}
	else if (mapNamed == "castle2")
	{
		WriteB3 (MSG_ONE,7561571);
		WriteB3 (MSG_ONE,6646900);
		WriteB3 (MSG_ONE,50);
		r = TRUE;
	}

	return(r);
};
