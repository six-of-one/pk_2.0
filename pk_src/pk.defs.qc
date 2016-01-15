
// constants

// ADMIN section
// dev - only enable this for painkeep maps or force pk mode (sv_ control) - any maps that loads a pk item / func
float PK;									// if set true painkeep code is enabled
float PK_MAP					= 6144;	// bit * = FALSE -- map sets painkeep mode  - PK = TRUE if: any pk*.bsp loaded, start.bsp loaded and message == "hub", a map loads any painkeep map item, PK = FALSE otherwise
float PK_ALWAYS				= 2048;	// bit *	= TRUE --- always in painkeep mode - PK = TRUE;
float PK_NEVER				= 4096;	// bit *	= TRUE --- never in painkeep mode  - PK = FALSE;
float PK_DYNAMIC				= 8192;	// bit *	= TRUE --- when always in painkeep mode & not on a PK map, dynamically load pk items if they are not present
												// items include  - bear trap, can o' beans, gravity well, harpoon, turret, airfist, chain thunderbolt, exploding shot, pulse nailgun
float PK_SPIKER				= 16384;	// bit *	= FALSE -- allow spike traps, set to true for original pk treatment of spike shooters - they are removed
float PK_XSOUND				= 32768;	// bit * = TRUE --- use extra pk sound set

float PK_HUB2					= 131072; // bit if TRUE, using hub2 - reload at hub loads
float PK_HUB3					= 262144; // bit if TRUE, using hub3 - reload at hub loads
string st_hub2					= "hub2"; // map names for 2nd & 3rd hub
string st_hub3					= "hub3";

float pk_flags;							// replaces old usage of temp1, savedgamecfg stores this
float pk_xsound;							// set to state of PK_XSOUND bit for sound code toggle
float pk_itemovr;						// control items - admin override
float pk_map;								// true if a painkeep map is loaded

float DARKPLACES_ENGINE	= 3275;	// for detecting darkplaces - modded engine sets cvar("chaos") to this value
float chaos;

float PK_ADMIN;							// allow admin - set this to 0 to completely disable all admin
float pk_adminimp;						// impulse set in admin.cfg to access admin commands, defaults to 255
float pk_admincode;						// code you must enter to access admin commands - set by admin.cfg, defaults to -1
float pk_adminpwdmask;					// if true password will be masked with *'s
float pk_admintime;						// if > 0 - inactivity timer for admin mode
float pk_adminframe;					// only do once per frame
float LIVE_ADMIN				= 100;	// for being in game with admin privs - previous painkeep admin mode
float ADMIN_LOGIN			= -2;		// .admin value for login
float USER_MENU				= -1;		// .admin value that handles user menu - admin code set runs user menus
float USER_TIMEOUT			= 5;		// timeout user menu in 5 secs
float USER_IMPULSE			= 39;		// user menu impulse
float ADMIN_FAILED_LOGIN	= -777;	// login didnt succeed
string ADMINCODE				= "float1\n"; // local command that loads admin security password
													  //- obscured to keep anyone with casual console access from divining its true meaning
string ADMINIMPULSE			= "float2\n"; // load the impulse
string ADMINTIME				= "float3\n"; // load the time out

// item admin
float WEP_SSHOT				= 1; 	 // admin of super shotgun
float WEP_NAILGUN			= 2; 	 // admin of nailgun
float WEP_PERF				= 4; 	 // admin of super nailgun
float WEP_GREN				= 8; 	 // admin of grenade
float WEP_ROCKET				= 16;  // admin of rocket
float WEP_THUNDER			= 32;  // admin of thunderbolt
float WEP_PKI					= 64;  // admin of pain keep items
float WEP_WEPSQ				= 63;  // all q weps									= 111111000000
float WEP_WEPSA				= 127; // incl pk items?							= 111111100000
float WEP_STOP				= 64;

// pk items special - not in override var
float WEP_GWELL				= 128;
float WEP_TURRET				= 256;
float WEP_BTRAP				= 512;
float WEP_EXPSH				= 1024;
float WEP_GRAP				= 2048;
float WEP_AIRG				= 4096;
float WEP_CPNB				= 8193;

float ART_QUAD				= 128;  // admin of quad
float ART_INV					= 256;  // admin of invulnerable
float ART_RAD					= 512;  // admin of rad suit
float ART_RING				= 1024; // admin of ring
float ART_ARTS				= 1920; // all art bits								= 000000011110
float ART_STOP				= 2048;

float ARM_GRN					= 2048;  // admin of green armor
float ARM_YEL					= 4096;  // admin of yellow armor
float ARM_RED					= 8192;  // admin of red armor
float ARM_ARMS				= 14336; // all armor bits							= 000000000000111
float ARM_STOP				= 16384;

// TDO: item admin over health requires a remap of classnames for this code to work
float HEAL_15					= 16384;  // admin of heal 15
float HEAL_25					= 32768;  // admin of heal 25
float HEAL_100				= 65536;  // admin of heal 100
float HEAL_HEALS				= 114688; // all health bits						= 000000000000000111
float HEAL_STOP				= 131072;

float CON_ANY					= 2097087; // any bit set in this mask	- any above + controls (all bits - 64)
float CON_STOP				= 16384; //131072;  // stop replace / remove cycle here
// CON_* entries
float CON_ONLY				= 131072;  // only the selected items will be loaded
float CON_NONE				= 262144;  // none of the selected items will be loaded
float CON_SUBS				= 524288;  // substitute something for removed items
float CON_INF					= 1048576; // infinite ammo weps
float CON_CYC					= 2097152; // cycle selected bits in thier group
float CON_RUN					= 4063232; // any control bit CON_* entries above - used by autorun
float CYC_TIME				= 60; // TEST - 240; // seconds for cycle base - 4 mins +|- 2 mins
void() item_loop;
float ammo_frame;
void() infinite_ammo;

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
void(entity e, float chan, string samp, float vol, float atten) pk_sound; // *frikbot
void(vector pos, string samp, float vol, float atten) pk_ambientsound = #74;

// from triggers

// For new teleporter sounds
float SOUND_GOT;
string normalsound;
string reversesound;

// PK new print prototypes...
//void(entity client, string s, string s1) centerprint2 = #73;	// sprint, but in middle
void(entity client, string s, string s1, string s2) centerprint3 = #73;	// sprint, but in middle
//void(entity client, string s, string s1, string s2, string s3) centerprint4 = #73;	// sprint, but in middle
void(entity client, string s, string s1, string s2, string s3, string s4) centerprint5 = #73;	// sprint, but in middle
//void(entity client, string s, string s1, string s2, string s3, string s4, string s5) centerprint6 = #73;	// sprint, but in middle
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
float PK_IT_AXE				= 1;
float PK_IT_GRAVITYWELL	= 2;
float PK_IT_TURRET			= 4;
float PK_IT_CANPAB			= 8;
float PK_IT_GRAPGUN			= 16;
float PK_IT_AIRGUN			= 32;
float PK_IT_CLIGHT			= 64;
float PK_IT_BEARTRAP		= 128;
float PK_IT_EXTRADISP		= 256;
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
float PK_GRAVITYWELLAMMO_MAX	= 1;
float PK_TURRETAMMO_MAX		= 3;
float PK_CANPABAMMO_MAX		= 1;
float PK_BEARTRAPAMMO_MAX		= 3;

// The current inventory item
.float pk_currentInventory;

// new gibs
entity damage_inflictor;	// set by T_Damage

// Variables used for the air gun.

// Used to flag states for entity's for the AirFist mod.
.float AIRG_Flags;

// Variables used to track when to turn of FLY movetype for flying entity's
.entity AIRG_FlyTracker;

// Constant used on the AIRG_Flags to specifiy that we have converted this
// flying monsters movetype from MOVETYPE_STEP to MOVETYPE_FLY (see horn.qc for
// more info).
float AIRG_STEPCONVERTEDTOFLY	= 2;

// Air Gun flag constants.
// Setting an entity's AIRG_Flags excludes it from harm
float AIRG_EXCLUDEENTITY	= 1;

// At the moment the AIRG_Flags variable is used only for the exclusion routine
// but this may change.

// Used in the Max Fire Rate Calculations.
.float AIRG_FireCount;
.float AIRG_Timeout;


// Airblast timeout variable.	Tracks how long the "blast" affects monsters...
.float AIRG_BlastTimeout;				// Airblast origin, & viewing angle
.vector AIRG_BlastOrigin;
.vector AIRG_BlastAngle;

// Prototypes used
void() launch_horn;
void(float firstBlast) horn_airblast;


// chain thunder bolt
.entity bolt_target;	    				// current player firing at ...
.entity bolt_targetNext;				// next target in the chain...
.float bolt_targetTimeout; 			// used to timeout the bolt_target...
.float bolt_targetNextTimeout; 		// used to timeout the bolt_targetNext...

.entity bolt_targetTimeoutEntity; 	// Entity timeout, used just for the nextthink!

.float bolt_conduitTimeout;			// Entity conduit timeout if the entity handles it...

//float	FL_GIBCONDUIT	= 8192;		// set if it's the first conduit entity

.float bolt_changeModelTimeout;		// used to change the view weapon modal timeout.

// Used as the lightning fire source entity so that the "player" can fire lightning himeself
.entity bolt_lightningFire;


// harpoon
.entity grap_cornerchainNext; 		// next in the rope corner chain.
.entity grap_ropechainPrev;			// prev in the rope chain.
.entity grap_owner; 						// Can't use owner cas the object can't see the owner!
.entity grap_pull;
.float grap_checkTimeout;
.float grap_state;
.float grap_length;
.vector grep_offset;						// harpoon target offset for bringing back to owner
.float grap_firetest;

float GRAP_IDEAL				= 0; 		// Going nothing
float GRAP_OUT				= 1; 		// It's outing out
float GRAP_IN					= 2; 		// It's comming back to the owner
float GRAP_TOHARPOON		= 3; 		// lengthen rope
float GRAP_FIXED				= 4; 		// The length is fixed.
float GRAP_ROPESHORTEN		= 5; 		// shorten rope
float GRAP_ROPELENGTHEN	= 6;		// lengthen rope
float GRAP_HARPOON			= 7;
float GRAP_CORNER			= 8;
float GRAP_ROPE				= 9;


// can o p&b
.float copb_timeout;
.float copb_nextFartTimeout;

// item repositions
.vector ip_orgOrigin;

// the timeout (in mins) where items move back to there original position...
float ip_timeout				= 2;


// exploding ammo for shotgun
.float pk_explode_ammo;
float PK_EXPLODEAMMO_MAX	= 10;

// For Drowning Ignoring armor
float ignorearmor;

// hub ops
//float PK_SF_HUB = 16;
string CL_BOBAMT                          = "cl_bob 0.02\n"; // val for turning view bob back on when not exited hub
float PK_SF_HUB				= 1024;	// moved to pk_flags
float PK_TP_TIMEMASK		= 63;
float inHubMap;
.float voteIntermission;

// MOTD
float MOTDTIME				= 70;		// The amount of "frames" for the motd message (minimum should be 20)
float DONTALLOWBOTS			= 1;		// If we want to show anti bots messages at startup
.float msgcount;
void() updateStatusDisplay;

.float laststattime;					// time of last status update


.float beartrap_time;
.float bt_immune_time;
float BT_BUFFER				= 2;	  	// The nuber of secs people are immune to beartraps after spawning

// Quake Packet Message
float	SVC_CENTERPRINT	= 26;

.float disconnectPlayer;

// If the SFX are enabled or not
//float sparkFlashOff;
float PK_TP_SPARKSFLASH	= 64;

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
float PK_TP_DUTYON			= 128;

// admin code
.float admin;
float(string mp) PK_mapmode;
void() PK_SetAdmin;
void() PK_AdminImpulse;
void() admin_sv_cfg;
void() admin_clear;
void() Admin_mainmenu;
float() admin_postthink;
void() admin_resettimeout;
void () observer; // *bot
float pk_flags_ck;
float pk_itemovr_ck;

float PK_TP_STATUSON		= 256;
.float hubstartupmessage;
.float messagetimeout;

.float revotemsg;

// For the level sequences, if the exec file has been run yet.
float execed;
float PK_TP_USERMAPON		= 512;

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
//void(entity e) PK_BackpackSetup;

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
.entity theowner; 						// .owner replacement pulse nailgun
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
.void() pk_touch; 						// group all touch code mods here
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
