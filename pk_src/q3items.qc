/* ::-::
 *
 * Cataboligne
 *
 * file: q3items.qc
 *
 * date: 10/16/08
 *
 * qc - support q3 stuff so darkplaces can run q3 maps for painkeep
 *
 */


/*

q3 support via translation

q3 wep					pk wep
------------------------------------------
bfg						chain_lg
plasma					chain_lg
machinegun				supernailgun / nailgun
shotgun					supershotgun
grapplinghook			harpoon
railgun					gravity well / turret
lighting					lighting
------------------------------------------
slugs						explodeshells
grenades					rockets
lightning				cells
bfg						cells
------------------------------------------
armor shard				beartrap
item_armor_combat		item_armor2
item_armor_body		item_armorInv
------------------------------------------
item health sm			candle
item_health_large		item_health
item_health_mega		item_health
------------------------------------------
item_quad				item_artifact_super_damage
item_regen				item_artifact_invulnerability
item_invis				item_artifact_invisibility
item_enviro				item_artifact_envirosuit



FIX FIX FIX

- precache needed !

SV_ModelIndex("progs/v_reggun.mdl"): not precached (fix your code), precaching anyway
SV_ModelIndex("progs/v_q3_mgun.mdl"): not precached (fix your code), precaching anyway

SV_SoundIndex("sound/misc/w_pkup.wav"): not precached (fix your code), precaching anyway
SV_SoundIndex("sound/misc/am_pkup.wav"): not precached (fix your code), precaching anyway
SV_SoundIndex("sound/items/respawn1.wav"): not precached (fix your code), precaching anyway
SV_SoundIndex("reggun/fire4.wav"): not precached (fix your code), precaching anyway
SV_SoundIndex("sound/weapons/machinegun/machgf1b.wav"): not precached (fix your code), precaching anyway
SV_SoundIndex("sound/weapons/rocket/rocklf1a.wav"): not precached (fix your code), precaching anyway


*/

float SUSPENDED = 1; // some q3 items "float" in the air - hope this works

// fn(q3_suspend) - make q3 items suspended as per q3 map spawnflag SUSPEND

void() q3_suspend =
{
	self.map = "Q3";
	self.movetype = MOVETYPE_NONE;
};

// some weapons / items are translated into equivs

/*QUAKED weapon_bfg (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_bfg =
{
	self.classname = "weapon_chainlg";

	precache_model ("progs/g_clight.mdl");
	setmodel (self,"progs/g_clight.mdl");
	self.pk_currentitem = PK_IT_CLIGHT;
	self.netname = "Chain Thunderbolt";
	self.touch = painkeep_weapon_touch;
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
//	if (!(pk_flags & PK_MAP) && !PK) pk_map = PK = TRUE; // *pk - in map mode, set PK for painkeep mode
//	pk_ditems = pk_ditems + 1;

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

/*QUAKED weapon_plasmagun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_plasmagun =
{
	weapon_bfg();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

/*QUAKED weapon_machinegun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void() weapon_machinegun =
{
	if (random() < 0.6)
	{
		self.classname = "weapon_supernailgun";
		weapon_supernailgun();
	}
	else
	{
		self.classname = "weapon_nailgun";
		weapon_nailgun();
	}

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

/*QUAKED weapon_shotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_shotgun =
{
	self.classname = "weapon_supershotgun";
	weapon_supershotgun();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};


/*QUAKED weapon_grapplinghook (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void () weapon_grapplinghook =
{
	self.classname = "weapon_grapgun";
	self.touch = painkeep_weapon_touch;

	precache_model ("progs/g_harp.mdl");
	setmodel (self,"progs/g_harp.mdl");
	self.pk_currentitem = PK_IT_GRAPGUN;
	self.netname = "Harpoon Gun";
	setsize (self,'-16 -16 0','16 16 56');
	StartItem ();
//	if (!(pk_flags & PK_MAP) && !PK) pk_map = PK = TRUE; // *pk - in map mode, set PK for painkeep mode
//	pk_ditems = pk_ditems + 1;

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

//weapon_lightning - already exists

//weapon_railgun

void() weapon_railgun =
{
//weapon_airfist();
//weapon_grapgun();
	if (random() < 0.66)
	{
		self.classname = "item_painkeep_gwell";
		item_painkeep_gwell();
	}
	else 
//	if (random() < 0.5)
	{
		self.classname = "item_painkeep_turret";
		item_painkeep_turret();
	}
//	else
//	{
//		self.classname = "item_painkeep_beartrap";
//		item_painkeep_beartrap();
//	}

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() ammo_bullets =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	self.spawnflags = self.spawnflags | 1;
//	setorigin(self, self.origin + ' 0 0 16');
	item_spikes();
}

void() ammo_grenades =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	self.spawnflags = self.spawnflags | 1; // big
//	setorigin(self, self.origin + ' 0 0 16');
	item_rockets();
}

void() ammo_lightning =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	local entity e;
	self.spawnflags = self.spawnflags | 1;
//	setorigin(self, self.origin + ' 0 0 16');
	item_cells();
	e = spawn();
	setorigin(e, self.origin);
	e.spawnflags = self.spawnflags;
	self = e;
//	setorigin(self, self.origin + ' 0 0 16');
	item_cells();
}

void() ammo_bfg =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	self.spawnflags = self.spawnflags | 1;
//	setorigin(self, self.origin + ' 0 0 16');
	item_cells();
}

// spawnfunc_ - because quake already has variables ammo_* and the function names cannot be used
//  -- darkplaces has a special call mode for map items that appends spawnfunc_ to cover stuff like this

//ammo_shells
//ammo_rockets
//ammo_cells

void() spawnfunc_ammo_shells =
{
//	self.spawnflags = self.spawnflags | 1;
//	setorigin(self, self.origin + ' 0 0 16');
	item_shells();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() spawnfunc_ammo_rockets =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	self.spawnflags = self.spawnflags | 1; // q3 rockets are 10 pk
//	setorigin(self, self.origin + ' 0 0 16');
	item_rockets();
};

void() spawnfunc_ammo_cells =
{
	if (self.spawnflags & SUSPENDED) q3_suspend();

	self.spawnflags = self.spawnflags | 1; // big - note conflicts with suspend
//	setorigin(self, self.origin + ' 0 0 16');
	item_cells();
};

//ammo_slugs

void() ammo_slugs =
{
	self.classname = "item_painkeep_expshells";
//	setorigin(self, self.origin + ' 0 0 16');
	item_painkeep_expshells();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};


void() item_armor_combat =
{
	self.classname = "item_armor2";
	item_armor2();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_armor_body =
{
	self.classname = "item_armorInv";
	item_armorInv();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// heh heh

void() item_armor_shard =
{
	self.classname = "item_painkeep_beartrap";
	item_painkeep_beartrap();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// heh heh

void() item_health_small =
{
	self.classname = "light_painkeep_candle";
	light_painkeep_candle();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// 2 * health

void() item_health_large =
{

	local entity e;

	self.classname = "item_health";
	item_health();
	if (self.spawnflags & SUSPENDED) q3_suspend();

	e = spawn();
	setorigin(e, self.origin);
	e.spawnflags = self.spawnflags;
	self = e;
	item_health();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_health_mega =
{
	self.classname = "item_health";
	self.spawnflags = self.spawnflags | 2;
	item_health();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_quad =
{
	self.classname = "item_artifact_super_damage";
	item_artifact_super_damage();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_regen =
{
	self.classname = "item_artifact_invulnerability";
	item_artifact_invulnerability();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_invis =
{
	self.classname = "item_artifact_invisibility";
	item_artifact_invisibility();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

void() item_enviro =
{
	self.classname = "item_artifact_envirosuit";
	item_artifact_envirosuit();

	if (self.spawnflags & SUSPENDED) q3_suspend();
};

// enable other q3 map ents

/*		q3 ---
	QUAKED info_player_intermission (1 0 1) (-16 -16 -16) (16 16 16)
Camera for intermission screen between matches. This also automatically generates the podium for bot arena matches (see Notes). Can be aimed by setting the "angles" key or targeting an pointing to an aiming entity. Use only one per level.
-------- KEYS --------
angles: alternate "pitch, yaw, roll" angles method of aiming intermission camera (default 0 0 0).
target : point this to an info_notnull or target_position entity to set the camera's pointing angles.
-------- NOTES --------
In genuine bot arena matches, the podium for the 1st, 2nd and 3rd place players at the end of the match is generated by this entity. The podium's origin will automatically be located 128 units in the direction of the camera's view and 84 units down from the y height of the view line at that point. It will also always be generated on a level plane regardless of the pointing angle of the camera so if that angle is too steep, part of the podium model might not be visible. Make sure you leave at least 106 units of free space in front of where the camera points to otherwise the podium model won't be visible at all.
*/

void() info_player_intermission =
{

};

/*		q3 ---
	QUAKED target_position (0 .5 0) (-8 -8 -8) (8 8 8)
Aiming target for entities like light, misc_portal_camera and trigger_push (jump pads) in particular.
-------- KEYS --------
targetname : the entity that requires an aiming direction points to this.
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
-------- NOTES --------
To make a jump pad, place this entity at the highest point of the jump and target it with a trigger_push entity.
*/

void() target_position =
{

};


/*		q3 ---
	QUAKED misc_teleporter_dest (1 .5 .25) (-32 -32 -24) (32 32 -16)

Teleport destination location point for trigger_teleporter entities.
-------- KEYS --------
angle : direction in which player will look when teleported.
targetname : make the trigger_teleporter point to this.
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
*/


void() misc_teleporter_dest =
{
// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin = self.origin + '0 0 27';
	if (!self.targetname)
	{
		if (Q_100 && Q_100_OBJERR) objerror ("no targetname");
		bprint("q3 - misc_teleporter_dest missing name! please repair the map...\n");
		self.targetname = ftos(floor(random() * 65535));
	}

};

// altarbetas teleporter for some reason - works in q3

void() target_teleporter =
{
	misc_teleporter_dest();
};

// some q3 triggers may be like this ??

void() misc_teleporter =
{
	trigger_teleport();
};

// fn(q3_play_sound) - play a sound for target_speaker, repeating or by activator
// fn(q3_sound_think) - periodic repeating sound for target speaker

float Q3_LOOPON				= 1;
float Q3_LOOPOFF				= 2;
float Q3_GLOBAL				= 4;
float Q3_ACTIVATOR			= 8;

void() q3_play_sound =
{
	sound (self, CHAN_AUTO, self.noise, 1, self.aflag);
};

void() q3_sound_think =
{
	q3_play_sound();
	self.nextthink = time + self.wait + 5 * random();
};

/*		q3 ---
	QUAKED target_speaker (0 .7 .7) (-8 -8 -8) (8 8 8) LOOPED_ON LOOPED_OFF GLOBAL ACTIVATOR
Sound generating entity that plays .wav files. Normal non-looping sounds play each time the target_speaker is triggered. Looping sounds can be set to play by themselves (no activating trigger) or be toggled on/off by a trigger.
-------- KEYS --------
noise : path/name of .wav file to play (eg. sound/world/growl1.wav - see Notes).
wait : delay in seconds between each time the sound is played ("random" key must be set - see Notes).
random : random time variance in seconds added or subtracted from "wait" delay ("wait" key must be set - see Notes).
targetname : the activating button or trigger points to this.
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
-------- SPAWNFLAGS --------
LOOPED_ON : sound will loop and initially start on in level (will toggle on/off when triggered).
LOOPED_OFF : sound will loop and initially start off in level (will toggle on/off when triggered).
GLOBAL : sound will play full volume throughout the level.
ACTIVATOR : sound will play only for the player that activated the target.
-------- NOTES --------
The path portion value of the "noise" key can be replaced by the implicit folder character "*" for triggered sounds that belong to a particular player model. For example, if you want to create a "bottomless pit" in which the player screams and dies when he falls into, you would place a trigger_multiple over the floor of the pit and target a target_speaker with it. Then, you would set the "noise" key to "*falling1.wav". The * character means the current player model's sound folder. So if your current player model is Visor, * = sound/player/visor, if your current player model is Sarge, * = sound/player/sarge, etc. This cool feature provides an excellent way to create "player-specific" triggered sounds in your levels.

The combination of the "wait" and "random" keys can be used to play non-looping sounds without requiring an activating trigger but both keys must be used together. The value of the "random" key is used to calculate a minimum and a maximum delay. The final time delay will be a random value anywhere between the minimum and maximum values: (min delay = wait - random) (max delay = wait + random).
*/
void() target_speaker =
{
	precache_sound (self.noise);

	self.aflag = ATTN_NORM;
	if (self.spawnflags & Q3_GLOBAL) self.aflag = ATTN_NONE;

	self.use = q3_play_sound;

	if (self.flags & Q3_LOOPON)
	{
		ambientsound (self.origin, self.noise, 0.5, ATTN_STATIC);
//		loop_sound(self, CHAN_WEAPON,self.noise, 1, attn, 8.25, self.origin, 0, LOOPFOREVER); // FIX - want this for loopoff - problem is we need the sound length
	}
//	else if (self.flags & Q3_LOOPOFF) // TDO
//	{
//		ambientsound (self.origin, self.noise, 0.5, ATTN_STATIC);
//		loop_sound(self, CHAN_WEAPON,self.noise, 1, attn, 8.25, self.origin, 0, LOOPFOREVER);
//	}
	else if (self.wait)
	{
		self.think = q3_sound_think;
		self.nextthink = time + self.wait + 2 * crandom();
	}
};

// fn(q3trap_shooter_target) - finds target for q3 trap shooter if it has one, otherwise returns preset .movedir

vector() q3trap_shooter_target =
{
	local entity t;

// no target string
	if (self.target == "") return (self.movedir);

	t = find (world, targetname, self.target);
// target ent not found
	if (!t) return (self.movedir);
// found and targeted
	return (t.origin - self.origin);
};

// fn(q3_spikeshooter_use) - implement q3 shooters setup below

void() q3_spikeshooter_use =
{
	if (self.noise3 == "") self.noise3 = "weapons/spike2.wav";
	if (self.mdl == "") self.mdl = "progs/spike.mdl";
	if (self.delay < 100) self.delay = 500;

	sound (self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
	launch_spike (self.origin, q3trap_shooter_target());
	newmis.velocity = self.movedir * self.delay;
	setmodel (newmis, self.mdl);

	if (self.classname == "shooter_grenade")
	{
		newmis.classname = "grenade";
		newmis.movetype = MOVETYPE_BOUNCE;
		newmis.touch = GrenadeTouch;
		newmis.nextthink = time + 2.5;
		newmis.think = GrenadeExplode;
	}
	else if (self.classname == "shooter_rocket")
	{
		newmis.classname = "rocket";
		newmis.touch = T_MissileTouch;
		newmis.nextthink = time + 5;
		newmis.think = GrenadeExplode;
	}
	else if (self.classname == "shooter_plasma")
	{
		newmis.classname = "plasma";
		newmis.touch = spike_touch;
		newmis.nextthink = time + 5;
		newmis.think = SUB_Remove;
	}
	else
		newmis.touch = superspike_touch;
	
};

// fn(q3trap_shooter) - implement any of the q3 shooter traps

void() spikeshooter_use;

void() q3trap_shooter =
{
	SetMovedir ();
	self.use = q3_spikeshooter_use;

	precache_model ("progs/spike.mdl");
	precache_sound ("weapons/spike2.wav"); // defaults to a nail shooter trap if its buf'd up
};

/*		q3 ---
	QUAKED shooter_grenade (1 0 .5) (-8 -8 -8) (8 8 8)
This will shoot a grenade each time it's triggered. Aiming is done by setting the "angles" key or by targeting an info_notnull or target_position entity.
-------- KEYS --------
angles: this sets the pitch and yaw aiming angles of shooter (default 0 0). The roll angle does not apply.
targetname : activating trigger points to this.
target : this points to a target_position entity for aiming the grenades.
random : random aiming variance in degrees from the straight line to the targeted entity (default 0 - see Notes).
notfree : when set to 1, entity will not spawn in "Free for all" and "Tournament" modes.
notteam : when set to 1, entity will not spawn in "Teamplay" and "CTF" modes.
notsingle : when set to 1, entity will not spawn in Single Player mode (bot play mode).
-------- NOTES --------
When the random key is set, its value is used to calculate a maximum angle deviation from the normal trajectory formed by a straight line between the shooter and the aiming entity it targets. The final trajectory will be a random value anywhere between no deviation at all (0) to maximum deviation (value of the random key).

Both the setting "angles" key or "targeting a target_position" methods can be used to aim the shooter. However, the target_position method is simpler.*/

// TDO: q3 sounds | models, implement target

void() shooter_grenade =
{
	precache_model ("progs/grenade.mdl");
	precache_sound ("weapons/grenade.wav");
	precache_sound ("weapons/bounce.wav");
	q3trap_shooter();
	self.mdl = "progs/grenade.mdl";
	self.noise2 = "weapons/bounce.wav";
	self.noise3 = "weapons/grenade.wav";
	self.delay = 400;
};

/*QUAKED shooter_plasma (1 0 .5) (-8 -8 -8) (8 8 8)
*/

void() shooter_plasma =
{
	precache_model ("progs/lavaball.mdl"); // fix
	precache_sound ("q3_snd/hyprbf1a.wav");
	precache_sound ("q3_snd/plasmx1a.wav");
	q3trap_shooter();
	self.mdl = "progs/lavaball.mdl";
	self.noise2 = "q3_snd/plasmx1a.wav";
	self.noise3 = "q3_snd/hyprbf1a.wav";
	self.delay = 800;
};

/*QUAKED shooter_rocket (1 0 .5) (-8 -8 -8) (8 8 8)
*/

void() shooter_rocket =
{
	precache_model ("progs/missile.mdl");
	precache_sound ("weapons/sgun1.wav");
	q3trap_shooter();
	self.mdl = "progs/missile.mdl";
	self.noise3 = "weapons/sgun1.wav";
	self.delay = 1000;
};
