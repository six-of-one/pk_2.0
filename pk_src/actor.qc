/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: actor.qc
 *
 * date: Wed Aug 12 05:11:40 UTC 2009
 *
 * 
 *
 */


void() actor_pent_activate =
{
	sprint(self,"Entering the Pentagram Stage\n");
	self.invincible_time = 1;
	self.invincible_finished = time + POW_TIME;
	self.items = self.items | IT_INVULNERABILITY;
	if ((random () * 100) < 5)
		self.pkplus_actortype = 0;
	else
		self.pkplus_actortype = PKPLUS_ACTORPENT;

	sound(self,CHAN_VOICE,"items/protect.wav",1,ATTN_NORM);
	stuffcmd(self,"bf\n");
};

void() actor_quad_activate =
{
	sprint(self,"Entering the Quad Stage\n");
	self.super_time = 1;
	self.super_damage_finished = time + POW_TIME;
	self.items = self.items | IT_QUAD;
	if ((random () * 100) < 5)
		self.pkplus_actortype = 0;
	else
		self.pkplus_actortype = PKPLUS_ACTORQUAD;

	sound(self,CHAN_VOICE,"items/damage.wav",1,ATTN_NORM);
	stuffcmd(self,"bf\n");
};

