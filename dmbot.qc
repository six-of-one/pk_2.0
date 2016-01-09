/* ::-::
 *
 * dectran: decompiler translator by Cataboligne v1.3 - (3.31.8)
 *
 * file: dmbot.qc
 *
 * date: Fri Apr  4 04:40:02 UTC 2008
 *
 * test 6
 *
 */


void () bot_start = [ 12, bot_walk ] { 	local string tmp;
	BotPostThink ();
	droptofloor(0, 0);
	self.nextthink = ((time + 0.2) + (0.2 * random ()));
	if ( (self.skil < 3) )
	{
		self.nextthink = (self.nextthink + (0.1 * (3- self.skil)));
	}
};

void () bot_stand1 = [ 12, bot_walk ] { 	ai_botstand ();
	BotPostThink ();
};

void () bot_walk = [ 6, bot_walk ] { 	self.weaponframe = 0;
	if ( (self.weapon == IT_AXE) )
	{
		if ( (self.walkframe == 6) )
		{
			self.walkframe = 0;
		}
		self.frame = (0+ self.walkframe);
	}
	else
	{
		if ( (self.walkframe == 6) )
		{
			self.walkframe = 0;
		}
		self.frame = (self.frame + self.walkframe);
	}
	self.walkframe = (self.walkframe + 1);
	ai_botseek (BOTSPEED);
	BotPostThink ();
};

void () bot_run = [ 6, bot_run ] { 	self.weaponframe = 0;
	if ( (self.weapon == IT_AXE) )
	{
		if ( (self.walkframe == 6) )
		{
			self.walkframe = 0;
		}
		self.frame = (0+ self.walkframe);
	}
	else
	{
		if ( (self.walkframe == 6) )
		{
			self.walkframe = 0;
		}
		self.frame = (self.frame + self.walkframe);
	}
	self.walkframe = (self.walkframe + 1);
	ai_botrun (BOTSPEED);
	BotPostThink ();
};

void () bot_chase = [ 6, bot_chase ] { 	self.weaponframe = 0;
	if ( (self.weapon == IT_AXE) )
	{
		if ( (self.walkframe == 6) )
		{
			self.walkframe = 0;
		}
		self.frame = (0+ self.walkframe);
	}
	else
	{
		if ( (self.walkframe == 6) )
		{
			self.walkframe = 0;
		}
		self.frame = (self.frame + self.walkframe);
	}
	self.walkframe = (self.walkframe + 1);
	aibot_chase (BOTSPEED);
	BotPostThink ();
};

void () bot_shot1 = [ 113, bot_shot2 ] { 	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () bot_shot2 = [ 114, bot_shot3 ] { 	self.weaponframe = 2;
	if ( (self.skil > 0.9) )
	{
		ai_botcharge (BOTSPEED);
	}
	BotPostThink ();
};

void () bot_shot3 = [ 115, bot_shot4 ] { 	self.weaponframe = 3;
	if ( (self.skil > 0) )
	{
		ai_botcharge (BOTSPEED);
	}
	BotPostThink ();
};

void () bot_shot4 = [ 116, bot_shot5 ] { 	self.weaponframe = 4;
	if ( (self.skil > 0) )
	{
		ai_botcharge (BOTSPEED);
	}
	else
	{
		ai_botcharge ((BOTSPEED * 0.5));
	}
	BotPostThink ();
};

void () bot_shot5 = [ 117, bot_shot6 ] { 	self.weaponframe = 5;
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_shot6 = [ 118, bot_run ] { 	self.weaponframe = 6;
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_trigger1 = [ 113, bot_trigger2 ] { 	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
};

void () bot_trigger2 = [ 114, bot_trigger3 ] { 	self.weaponframe = 2;
	ai_botseek (BOTSPEED);
	BotPostThink ();
};

void () bot_trigger3 = [ 115, bot_trigger4 ] { 	self.weaponframe = 3;
	ai_botseek (BOTSPEED);
	BotPostThink ();
};

void () bot_trigger4 = [ 116, bot_trigger5 ] { 	self.weaponframe = 4;
	ai_botseek (BOTSPEED);
	BotPostThink ();
};

void () bot_trigger5 = [ 117, bot_trigger6 ] { 	self.weaponframe = 5;
	ai_botseek (BOTSPEED);
	BotPostThink ();
};

void () bot_trigger6 = [ 118, bot_walk ] { 	self.weaponframe = 6;
	ai_botseek (BOTSPEED);
	BotPostThink ();
};

void () bot_axe1 = [ 119, bot_axe2 ] { 	self.weaponframe = 1;
};

void () bot_axe2 = [ 120, bot_axe3 ] { 	self.weaponframe = 2;
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_axe3 = [ 121, bot_axe4 ] { 	self.weaponframe = 3;
	W_FireAxe ();
	BotPostThink ();
};

void () bot_axe4 = [ 122, bot_run ] { 	self.weaponframe = 4;
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_axeb1 = [ 125, bot_axeb2 ] { 	self.weaponframe = 5;
};

void () bot_axeb2 = [ 126, bot_axeb3 ] { 	self.weaponframe = 6;
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_axeb3 = [ 127, bot_axeb4 ] { 	self.weaponframe = MOVETYPE_PUSH;
	W_FireAxe ();
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_axeb4 = [ 128, bot_run ] { 	self.weaponframe = 8;
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_axec1 = [ 131, bot_axec2 ] { 	self.weaponframe = 1;
};

void () bot_axec2 = [ 132, bot_axec3 ] { 	self.weaponframe = 2;
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_axec3 = [ 133, bot_axec4 ] { 	self.weaponframe = 3;
	W_FireAxe ();
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_axec4 = [ 134, bot_run ] { 	self.weaponframe = 4;
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_axed1 = [ 137, bot_axed2 ] { 	self.weaponframe = 5;
};

void () bot_axed2 = [ 138, bot_axed3 ] { 	self.weaponframe = 6;
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_axed3 = [ 139, bot_axed4 ] { 	self.weaponframe = MOVETYPE_PUSH;
	W_FireAxe ();
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_axed4 = [ 140, bot_run ] { 	self.weaponframe = 8;
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () dmbot_melee =
{
	self.weapon = W_BestBotWeapon ();
	W_BotAttack ();
};

void () bot_nail1 = [ 103, bot_nail2 ] { 	self.effects = (self.effects | EF_MUZZLEFLASH);
	self.weaponframe = (self.weaponframe + 1);
	if ( (self.weaponframe == 9) )
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireSpikes (4);
	ai_botnailcharge (BOTSPEED);
	self.attack_finished = (time + 0.2);
	BotPostThink ();
};

void () bot_nail2 = [ 104, bot_nail1 ] { 	self.effects = (self.effects | EF_MUZZLEFLASH);
	self.weaponframe = (self.weaponframe + 1);
	if ( (self.weaponframe == 9) )
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireSpikes (CONTENT_SLIME);
	ai_botnailcharge (BOTSPEED);
	self.attack_finished = (time + 0.2);
	BotPostThink ();
};

void () bot_light1 = [ 105, bot_light2 ] { 	self.effects = (self.effects | EF_MUZZLEFLASH);
	self.weaponframe = (self.weaponframe + 1);
	if ( (self.weaponframe == 5) )
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireLightning ();
	ai_botnailcharge (BOTSPEED);
	self.attack_finished = (time + 0.2);
	BotPostThink ();
};

void () bot_light2 = [ 106, bot_light1 ] { 	self.effects = (self.effects | EF_MUZZLEFLASH);
	self.weaponframe = (self.weaponframe + 1);
	if ( (self.weaponframe == 5) )
	{
		self.weaponframe = 1;
	}
	SuperDamageSound ();
	W_FireLightning ();
	ai_botnailcharge (BOTSPEED);
	self.attack_finished = (time + 0.2);
	BotPostThink ();
};

void () bot_rocket1 = [ 107, bot_rocket2 ] { 	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
	BotPostThink ();
};

void () bot_rocket2 = [ 108, bot_rocket3 ] { 	self.weaponframe = 2;
	if ( (self.skil > 2) )
	{
		ai_botcharge (BOTSPEED);
	}
	BotPostThink ();
};

void () bot_rocket3 = [ 109, bot_rocket4 ] { 	self.weaponframe = 3;
	if ( (self.skil > 1) )
	{
		ai_botcharge (BOTSPEED);
	}
	BotPostThink ();
};

void () bot_rocket4 = [ 110, bot_rocket5 ] { 	self.weaponframe = 4;
	if ( (self.skil > 1) )
	{
		ai_botcharge (BOTSPEED);
	}
	BotPostThink ();
};

void () bot_rocket5 = [ 111, bot_rocket6 ] { 	self.weaponframe = 5;
	if ( (self.skil > 0) )
	{
		ai_botcharge (BOTSPEED);
	}
	BotPostThink ();
};

void () bot_rocket6 = [ 112, bot_run ] { 	self.weaponframe = 6;
	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_rebound1 = [ 107, bot_rebound2 ] { 	self.weaponframe = 1;
	self.effects = (self.effects | EF_MUZZLEFLASH);
	BotPostThink ();
};

void () bot_rebound2 = [ 108, bot_rebound3 ] { 	self.weaponframe = 2;
	BotPostThink ();
};

void () bot_rebound3 = [ 109, bot_rebound4 ] { 	self.weaponframe = 3;
	BotPostThink ();
};

void () bot_rebound4 = [ 110, bot_rebound5 ] { 	self.weaponframe = 4;
	aibot_chase (BOTSPEED);
	BotPostThink ();
};

void () bot_rebound5 = [ 111, bot_rebound6 ] { 	self.weaponframe = 5;
	aibot_chase (BOTSPEED);
	BotPostThink ();
};

void () bot_rebound6 = [ 112, bot_chase ] { 	self.weaponframe = 6;
	aibot_chase (BOTSPEED);
	BotPostThink ();
};

void () bot_pain1 = [ 35, bot_pain2 ] { 	PainSound ();
	self.weaponframe = 0;
};

void () bot_pain2 = [ 36, bot_pain3 ] { 	
	local float r;
	r = ((4* random ()) + self.skil);
	if ( (r > 2) )
	{
		ai_botrun (BOTSPEED);
	}
	else
	{
		ai_botcharge (BOTSPEED);
	}
	BotPostThink ();
};

void () bot_pain3 = [ 37, bot_pain4 ] { 	if ( (self.skil >= TRUE) )
	{
		ai_botrun (BOTSPEED);
	}
	else
	{
		ai_botcharge (BOTSPEED);
	}
	BotPostThink ();
};

void () bot_pain4 = [ 38, bot_pain5 ] { 	if ( (self.skil > 0) )
	{
		ai_botrun (BOTSPEED);
	}
	else
	{
		ai_botcharge (BOTSPEED);
	}
	BotPostThink ();
};

void () bot_pain5 = [ 39, bot_pain6 ] { 	if ( (self.skil > 2) )
	{
		ai_botrun (BOTSPEED);
	}
	else
	{
		ai_botcharge (BOTSPEED);
	}
	BotPostThink ();
};

void () bot_pain6 = [ 40, bot_run ] { 	ai_botrun (BOTSPEED);
	BotPostThink ();
};

void () bot_axpain1 = [ 29, bot_axpain2 ] { 	PainSound ();
	self.weaponframe = 0;
	BotPostThink ();
};

void () bot_axpain2 = [ 30, bot_axpain3 ] { 	
	local float r;
	r = ((4* random ()) + self.skil);
	if ( (r > 2) )
	{
		ai_botrun (BOTSPEED);
	}
	else
	{
		ai_botcharge (BOTSPEED);
	}
	BotPostThink ();
};

void () bot_axpain3 = [ 31, bot_axpain4 ] { 	if ( (self.skil >= TRUE) )
	{
		ai_botrun (BOTSPEED);
	}
	BotPostThink ();
};

void () bot_axpain4 = [ 32, bot_axpain5 ] { 	ai_botcharge (BOTSPEED);
	BotPostThink ();
};

void () bot_axpain5 = [ 33, bot_axpain6 ] { 	ai_botrun (BOTSPEED);
	BotPostThink ();
};

void () bot_axpain6 = [ 34, bot_run ] { 	ai_botrun (BOTSPEED);
	BotPostThink ();
};

void () bot_pain =
{
	if ( self.weaponframe )
	{
		return ;
	}
	if ( (self.invisible_finished > time) )
	{
		return ;
	}
	if ( (self.weapon == IT_AXE) )
	{
		bot_axpain1 ();
	}
	else
	{
		bot_pain1 ();
	}
};

void () bot_diea1;
void () bot_dieb1;
void () bot_diec1;
void () bot_died1;
void () bot_diee1;
void () bot_die_ax1;
void () BotDead =
{
	self.nextthink = ((time + 0.3) + ((random () * (NUMBOTS + 3)) * 0.1));
	if ( teamplay )
	{
		self.nextthink = (self.nextthink + random ());
	}
	if ( TELEFRAGFLAG )
	{
		self.nextthink = (self.nextthink + (5* random ()));
		TELEFRAGFLAG = 0;
	}
	self.think = respawnBot;
	self.deadflag = DEAD_DEAD;
};

void () BotDie =
{
	local float i;
	if ( (self.deadflag != DEAD_NO) )
	{
		return ;
	}
	self.items = (self.items - (self.items & IT_INVISIBILITY));
	self.invisible_finished = 0;
	self.invincible_finished = 0;
	self.super_damage_finished = 0;
	self.radsuit_finished = 0;
	self.modelindex = modelindex_player;
	DropBackpack ();
	self.weaponmodel = "";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = (self.flags - (self.flags & FL_ONGROUND));
	self.movetype = MOVETYPE_TOSS;
	if ( (self.velocity_z < 10) )
	{
		self.velocity_z = (self.velocity_z + (random () * 300));
	}
	if ( (self.health < -40) )
	{
		GibPlayer ();
		BotDead ();
		return ;
	}
	DeathSound ();
	self.angles_x = 0;
	self.angles_z = 0;
	if ( (self.weapon == IT_AXE) )
	{
		bot_die_ax1 ();
		return ;
	}
	i = cvar ("temp1");
	if ( !i )
	{
		i = (1+ floor ((random () * 6)));
	}
	if ( (i == 1) )
	{
		bot_diea1 ();
	}
	else
	{
		if ( (i == 2) )
		{
			bot_dieb1 ();
		}
		else
		{
			if ( (i == 3) )
			{
				bot_diec1 ();
			}
			else
			{
				if ( (i == 4) )
				{
					bot_died1 ();
				}
				else
				{
					bot_diee1 ();
				}
			}
		}
	}
};

void () bot_diea1 = [ 50, bot_diea2 ] { };
void () bot_diea2 = [ 51, bot_diea3 ] { };
void () bot_diea3 = [ 52, bot_diea4 ] { };
void () bot_diea4 = [ 53, bot_diea5 ] { };
void () bot_diea5 = [ 54, bot_diea6 ] { };
void () bot_diea6 = [ 55, bot_diea7 ] { };
void () bot_diea7 = [ 56, bot_diea8 ] { };
void () bot_diea8 = [ 57, bot_diea9 ] { };
void () bot_diea9 = [ 58, bot_diea10 ] { };
void () bot_diea10 = [ 59, bot_diea11 ] { };
void () bot_diea11 = [ 60, bot_diea11 ] { 	BotDead ();
};

void () bot_dieb1 = [ 61, bot_dieb2 ] { };
void () bot_dieb2 = [ 62, bot_dieb3 ] { };
void () bot_dieb3 = [ 63, bot_dieb4 ] { };
void () bot_dieb4 = [ 64, bot_dieb5 ] { };
void () bot_dieb5 = [ 65, bot_dieb6 ] { };
void () bot_dieb6 = [ 66, bot_dieb7 ] { };
void () bot_dieb7 = [ 67, bot_dieb8 ] { };
void () bot_dieb8 = [ 68, bot_dieb9 ] { };
void () bot_dieb9 = [ 69, bot_dieb9 ] { 	BotDead ();
};

void () bot_diec1 = [ 70, bot_diec2 ] { };
void () bot_diec2 = [ 71, bot_diec3 ] { };
void () bot_diec3 = [ 72, bot_diec4 ] { };
void () bot_diec4 = [ 73, bot_diec5 ] { };
void () bot_diec5 = [ 74, bot_diec6 ] { };
void () bot_diec6 = [ 75, bot_diec7 ] { };
void () bot_diec7 = [ 76, bot_diec8 ] { };
void () bot_diec8 = [ 77, bot_diec9 ] { };
void () bot_diec9 = [ 78, bot_diec10 ] { };
void () bot_diec10 = [ 79, bot_diec11 ] { };
void () bot_diec11 = [ 80, bot_diec12 ] { };
void () bot_diec12 = [ 81, bot_diec13 ] { };
void () bot_diec13 = [ 82, bot_diec14 ] { };
void () bot_diec14 = [ 83, bot_diec15 ] { };
void () bot_diec15 = [ 84, bot_diec15 ] { 	BotDead ();
};

void () bot_died1 = [ 85, bot_died2 ] { };
void () bot_died2 = [ 86, bot_died3 ] { };
void () bot_died3 = [ 87, bot_died4 ] { };
void () bot_died4 = [ 88, bot_died5 ] { };
void () bot_died5 = [ 89, bot_died6 ] { };
void () bot_died6 = [ 90, bot_died7 ] { };
void () bot_died7 = [ 91, bot_died8 ] { };
void () bot_died8 = [ 92, bot_died9 ] { };
void () bot_died9 = [ 93, bot_died9 ] { 	BotDead ();
};

void () bot_diee1 = [ 94, bot_diee2 ] { };
void () bot_diee2 = [ 95, bot_diee3 ] { };
void () bot_diee3 = [ 96, bot_diee4 ] { };
void () bot_diee4 = [ 97, bot_diee5 ] { };
void () bot_diee5 = [ 98, bot_diee6 ] { };
void () bot_diee6 = [ 99, bot_diee7 ] { };
void () bot_diee7 = [ 100, bot_diee8 ] { };
void () bot_diee8 = [ 101, bot_diee9 ] { };
void () bot_diee9 = [ 102, bot_diee9 ] { 	BotDead ();
};

void () bot_die_ax1 = [ 41, bot_die_ax2 ] { };
void () bot_die_ax2 = [ 42, bot_die_ax3 ] { };
void () bot_die_ax3 = [ 43, bot_die_ax4 ] { };
void () bot_die_ax4 = [ 44, bot_die_ax5 ] { };
void () bot_die_ax5 = [ 45, bot_die_ax6 ] { };
void () bot_die_ax6 = [ 46, bot_die_ax7 ] { };
void () bot_die_ax7 = [ 47, bot_die_ax8 ] { };
void () bot_die_ax8 = [ 48, bot_die_ax9 ] { };
void () bot_die_ax9 = [ 49, bot_die_ax9 ] { 	BotDead ();
};

