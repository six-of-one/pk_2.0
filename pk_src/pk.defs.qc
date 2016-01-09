
// constants
// dev - only enable this for painkeep maps or force pk mode (sv_ control) - any maps that loads a pk item / func
float PK; // if set true painkeep code is enabled
float PK_MAP					= 0; // bits 1 & 2 = FALSE -- map sets painkeep mode - PK = TRUE if: any pk*.bsp loaded, start.bsp loaded and message == "hub", a map loads any painkeep map item, PK = FALSE otherwise
float PK_ALWAYS				= 1; // bit 1	= TRUE --- always in painkeep mode - PK = TRUE;
float PK_NEVER				= 2; // bit 2	= TRUE --- never in painkeep mode - PK = FALSE;
float PK_DYNAMIC				= 4; // bit 4	= TRUE --- when always in painkeep mode & not on a PK map, dynamically load pk items if they are not present
											// items include - bear trap, can o' beans, gravity well, harpoon, turret, airfist, chain thunderbolt, exploding shot, pulse nailgun
float PK_SPIKER				= 8; // bit 8	= TRUE --- allow spike traps, set to false for original pk treatment of spike shooters - they are removed
float PK_XSOUND				= 16;// bit 16 = TRUE --- use extra pk sound set

float pk_mode; // set bits to determin state of PK above, if darkplaces engine can be detected, this will load from cvar("sv_pk_mode"), otherwise first 5 bits of cvar("temp2")
float pk_xsound; // set to state of PK_XSOUND bit for sound code toggle

float DARKPLACES_ENGINE	= 3275; // for detecting darkplaces - modded engine sets cvar("chaos") to this value
float chaos;

// **************************************
// painkeep protos

// **************************************

// so we can make new sv_ console vars
//DP_REGISTERCVAR - adds a new console cvar to the server console (in singleplayer this is the player's console), the cvar exists until the mod is unloaded or the game quits.
//idea: LordHavoc - darkplaces implementation: LordHavoc
float(string name, string value) registercvar = #93;

// relocated from defs.qc

// hijacked for pk_mode running non pk maps with non pk sounds
//void(entity e, float chan, string samp, float vol, float atten) pk_sound = #8;
void(entity e, float chan, string samp, float vol, float atten) pk_sound;
void(vector pos, string samp, float vol, float atten) pk_ambientsound = #74;

// from triggers

// For new teleporter sounds
float SOUND_GOT;
string normalsound;
string reversesound;

// PK new print prototypes...
void(entity client, string s, string s1) centerprint2 = #73;	// sprint, but in middle
void(entity client, string s, string s1, string s2) centerprint3 = #73;	// sprint, but in middle
void(entity client, string s, string s1, string s2, string s3) centerprint4 = #73;	// sprint, but in middle
void(entity client, string s, string s1, string s2, string s3, string s4) centerprint5 = #73;	// sprint, but in middle
void(entity client, string s, string s1, string s2, string s3, string s4, string s5) centerprint6 = #73;	// sprint, but in middle
void(entity client, string s, string s1, string s2, string s3, string s4, string s5, string s6) centerprint7 = #73;	// sprint, but in middle

// auto turrets
.float turret_timeout;
.float turret_soundtimeout;
.float turret_ownertimeout;
.entity turret_base;

// items
.float pk_items;	// Items used for impulse 1
.float pk_currentitem;

// Items used in impulse 1
float PK_IT_AXE	       = 1;
float	PK_IT_GRAVITYWELL	= 2;
float	PK_IT_TURRET			= 4;
float	PK_IT_CANPAB			= 8;
float PK_IT_GRAPGUN	   = 16;
float PK_IT_AIRGUN	    = 32;
float	PK_IT_CLIGHT	  	= 64;
float PK_IT_BEARTRAP		= 128;
float PK_IT_EXTRADISP	 = 256;
/*
Impulse 1 will toggle between Axe, Bear Trap, CoPB, AS, and GW.


Custom impulses:

Impulse 30 - AirFist
Impulse 31 - Grappling Gun
Impulse 22 - Pulse Nailgun
Impulse 33 - Chain Lightning Gun
Impulse 34 - Gravity Well
Impulse 35 - Bear Trap
Impulse 36 - AutoSentry
Impulse 37 - Can of Pork and Beans
Impulse 38 - Axe (just to do complete)
*/
// turret ammo
.float pk_gravitywellammo, pk_turretammo, pk_canpabammo, pk_beartrapammo;

// Ammo Max'S
float PK_GRAVITYWELLAMMO_MAX = 1;
float PK_TURRETAMMO_MAX = 3;
float PK_CANPABAMMO_MAX = 1;
float PK_BEARTRAPAMMO_MAX = 3;

// The current inventory item
.float pk_currentInventory;

// new gibs
entity	damage_inflictor;	// set by T_Damage

// Variables used for the air gun.

// Used to flag states for entity's for the AirFist mod.
.float AIRG_Flags;

// Variables used to track when to turn of FLY movetype for flying entity's
.entity AIRG_FlyTracker;

// Constant used on the AIRG_Flags to specifiy that we have converted this
// flying monsters movetype from MOVETYPE_STEP to MOVETYPE_FLY (see horn.qc for
// more info).
float AIRG_STEPCONVERTEDTOFLY = 2;

// Air Gun flag constants.
// Setting an entity's AIRG_Flags excludes it from harm
float AIRG_EXCLUDEENTITY = 1;

// At the moment the AIRG_Flags variable is used only for the exclusion routine
// but this may change.

// Used in the Max Fire Rate Calculations.
.float AIRG_FireCount;
.float AIRG_Timeout;


// Airblast timeout variable.	Tracks how long the "blast" affects monsters...
.float AIRG_BlastTimeout;	// Airblast origin, & viewing angle
.vector AIRG_BlastOrigin;
.vector AIRG_BlastAngle;

// Prototypes used
void() launch_horn;
void(float firstBlast) horn_airblast;


// chain thunder bolt
.entity bolt_target;	    // current player firing at ...
.entity bolt_targetNext;	// next target in the chain...
.float bolt_targetTimeout; // used to timeout the bolt_target...
.float bolt_targetNextTimeout; // used to timeout the bolt_targetNext...

.entity bolt_targetTimeoutEntity; // Entity timeout, used just for the nextthink!

.float bolt_conduitTimeout; // Entity conduit timeout if the entity handles it...

//float	FL_GIBCONDUIT	= 8192;	// set if it's the first conduit entity

.float bolt_changeModelTimeout; // used to change the view weapon modal timeout.

// Used as the lightning fire source entity so that the "player" can fire lightning himeself
.entity bolt_lightningFire;


// harpoon
.entity grap_cornerchainNext; // next in the rope corner chain.
.entity grap_ropechainPrev;		// prev in the rope chain.
.entity grap_owner; 				// Can't use owner cas the object can't see the owner!
.entity grap_pull;
.float grap_checkTimeout;
.float grap_state;
.float grap_length;
.vector grep_offset;				// harpoon target offset for bringing back to owner
.float grap_firetest;

float GRAP_IDEAL = 0; 			// Going nothing
float GRAP_OUT = 1; 			// It's outing out
float GRAP_IN = 2; 				// It's comming back to the owner
float GRAP_TOHARPOON = 3; 	// lengthen rope
float GRAP_FIXED = 4; 			// The length is fixed.
float GRAP_ROPESHORTEN = 5; 	// shorten rope
float GRAP_ROPELENGTHEN = 6;	// lengthen rope
float GRAP_HARPOON = 7;
float GRAP_CORNER = 8;
float GRAP_ROPE = 9;


// can o p&b
.float copb_timeout;
.float copb_nextFartTimeout;

// item repositions
.vector ip_orgOrigin;

// the timeout (in mins) where items move back to there original position...
float ip_timeout = 2;


// exploding ammo for shotgun
.float pk_explode_ammo;
float PK_EXPLODEAMMO_MAX = 10;

// For Drowning Ignoring armor
float ignorearmor;

// hub ops
float PK_SF_HUB = 16;
float PK_TP_TIMEMASK = 63;
float inHubMap;
.float voteIntermission;

// MOTD
float MOTDTIME = 70;			// The amount of "frames" for the motd message (minimum should be 20)
float DONTALLOWBOTS = 1;		// If we want to show anti bots messages at startup
.float msgcount;
void() updateStatusDisplay;

.float laststattime;			// time of last status update


.float beartrap_time;
.float bt_immune_time;
float BT_BUFFER = 2;	  		// The nuber of secs people are immune to beartraps after spawning

// Quake Packet Message
float	SVC_CENTERPRINT		= 26;

.float disconnectPlayer;

// If the SFX are enabled or not
//float sparkFlashOff;
float PK_TP_SPARKSFLASH = 64;

// Last weapon stuff
.float lastweapon;
.float prevweapon;
.float pklastweapon;
.float pkprevweapon;
.float forcewchange;

// CenterPrint functions
void(float to, float f) WriteB3;
void(float to, float f) WriteBDigit;
void(float to, float f) WriteBFloat;

// duty checks
.float pk_dutychecking;
float PK_TP_DUTYON = 128;

// admin
void() AdminCommands;
void() CheckAdmin;
.float admin;
.float indata;
.float kick;
.entity kicker;

float PK_TP_STATUSON = 256;
.float hubstartupmessage;
.float messagetimeout;

.float revotemsg;

// For the level sequences, if the exec file has been run yet.
float execed;
float PK_TP_USERMAPON = 512;

// **************************************
// Cataboligne relocated from many places

// new pk central code point reqs
void() grap_releaseHarpoon;
void() SUB_regen;
void(entity e) AddToSplashBig;
// pk_prethink
void() WaterMove;
void() CheckRules;
void() CheckWaterJump;
void() PlayerDeathThink;
void() PlayerJump;
float() W_BestWeapon;
void() W_SetCurrentAmmo;
void() CheckWaterLevels;
// pk_postthink
void () W_WeaponFrame;
void() CheckPowerups;

// moved from v106 *.qc - Cataboligne - 3.27.8

// client code
void() grap_maintainHarpoon;
void() bolt_checkTargets;
void() player_conduitJerk;
void() copb_checkFart;
void() SetNewPKParms;
void(entity targ, entity inflictor, entity attacker) PK_ClientObituary;

// item code
void() grap_checkIfGrap;
void() ip_checkForMovement;
float() W_BestPKWeapon;
void(entity targ) pk_setDamageSkin;
// added
void() painkeep_touch;
void() pk_bound_ammo;
void() pk_item_position;
void() pk_item_position_init;
float(float w, float w2) PK_RankForWeapon;
void(float new, float new2) PK_Deathmatch_Weapon;
void() PK_DropBackpack;
void() PK_BackpackTouch;

// player code
void() bolt_fire;
void()	bolt_s_explode1;
void(entity grapOwner) grap_remove;

// added
void() pk_harpoon_frames;
void() player_pnail1;
void() PK_PlayerDie;
void() PK_GibPlayer;
void() PK_DeathSound;
//void(float sec) pk_player_sound;

// weapons
.entity theowner; // .owner replacement pulse nailgun
void() turret_dropTurret;
void() beartrap_dropBearTrap;
void() drop_gravity;
void() grap_fire;
void(float shotcount, vector dir, vector spread) FireExplodeShells;
void() pulse_touch;
void()	player_bolt1;
void() copb_eatCan;

// added
void(float shots) W_FireShotgunExploder;
void(float ox) W_FirePulseSpikes;
void() PK_SetCurrentAmmo;
float(float weaponnum, float pknum) CanSelect;
float(float weaponnum, float pknum) HasAmmo;
void() PK_WeaponFrame;
float() PK_BestWeapon;
float() PK_CheckNoAmmo;
void() PK_ChangeWeapon;
void() PK_CheatCommand;
void() PK_CycleWeaponCommand;
void() PK_CycleWeaponReverseCommand;
void() PK_ImpulseCommands;
void() PK_Attack;
void(entity e) pk_missile_splash;

// new features
.void() pk_touch; // group all touch code mods here
void() pk_placeitem;

/*

NOTES:

code base: these are done in many places, here for portability

	if (PK) AddToSplashBig(self); // *pk - Make this entity splash
	if (PK) AddToSplash(missile); // *pk - Make this entity splash

	if (PK) newmis.AIRG_Flags = AIRG_EXCLUDEENTITY; // *pk - 

	if (other.classname != "player")
	{
		if (PK) grap_checkIfGrap(); // *pk - harpoon item move checks
		return;
	}

deathmatch modes

1 = regular quake dm, all items respawn, guns are always taken on touch
2 = old doom dm rules - guns are not taken as ammo on touch if you have one already, _only_ powerups respawn (if wep is taken it does not dissapear)
3 = new PK rule - guns are not taken as ammo, ammo respawns in 15 secs, health & armor respawn (if wep is taken it does not dissapear)
4+ = (unintentional but logical extrapolation from code) - healths & pk weps respawn, ammo, armor, powerups & weapons do not, weapons dissappear (gone till reload!)


for portability the following fn()'s are entirely replaced when running in PK mode - note this does make modding this mod harder as much code can be run from 2 places

RankForWeapon() - called separately in v106 & pk code - has different parms, called from respective *Deathmatch_Weapon
WeaponFrame() - called from pre think loop, not a divert

--- tie in dirverts exec for most of the code

CheatCommand()
CycleWeaponReverseCommand()
CycleWeaponCommand()
ChangeWeapon()
ImpulseCommands()
Attack()

DropBackpack()
BackpackTouch()
DeathSound()
GibPlayer()
PlayerDie()
ClientObituary() - divert by fn() call, still runs killed code afterwards
Deathmatch_Weapon - divert by fn() call, still runs weapon_touch code afterwards
BestWeapon()
SetCurrentAmmo()
PlayerPreThink
PlayerPostThink

SPECIAL NOTE: to make mods to both v106 (or other) code and painkeep - make mod before tie in call diversion.
					if your code requiers more complex mods you will need to either a) mod both code sets, or b) make a new code set
					if you choose to mod both code sets we recommend a tie in fn() call to the same code
*/
