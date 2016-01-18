// constants

vector v0						= ' 0 0 0';
float MAXFL						= 16777215; // max float - max bit mask
float WARNING;									// display warnings

// ADMIN section
// dev - only enable this for painkeep maps or force pk mode (sv_ control) - any maps that loads a pk item / func
float PK;									// if set true painkeep code is enabled
float PK_MAP					= 6144;	// bit * = FALSE -- map sets painkeep mode  - PK = TRUE if: any pk*.bsp loaded, start.bsp loaded and message == "hub", a map loads any painkeep map item, PK = FALSE otherwise
float PK_ALWAYS				= 2048;	// bit *	= TRUE --- always in painkeep mode - PK = TRUE;
float PK_NEVER					= 4096;	// bit *	= TRUE --- never in painkeep mode  - PK = FALSE;
float PK_DYNAMIC				= 8192;	// bit *	= TRUE --- when always in painkeep mode & not on a PK map, dynamically load pk items if they are not present
												// items include  - bear trap, can o' beans, gravity well, harpoon, turret, airfist, exploding shot, XXX - chain thunderbolt, pulse nailgun
float PK_SPIKER				= 16384;	// bit *	= FALSE -- allow spike traps, set to true for original pk treatment of spike shooters - they are removed
float PK_XSOUND				= 32768;	// bit * = TRUE --- use extra pk sound set
// compatability modes for the purists out there
float PK_100;								// painkeep compatability mode - if true run 100% true to pk v1.11, no extras (has menus)
float PK_99						= FALSE;	// painkeep 99% compatability mode - if true pk (main mod) works as pk but extra env effects are disabled
float Q_100;								// quake 1 compatability mode - if true run 100% true to quake 1, why? just for kicks...
float Q_99						= FALSE;	// quake 1 99% compatability mode - if true pk stuff is removed, but admin, item enhancements & env remain

												// many object errors are tweaked to simply remove the offending component - if these 2 vars are set true, and objerror will be generated
float PK_100_OBJERR;						// if true objerr that would have exited game (and have since been fixed) will cause an objerr
float Q_100_OBJERR;						// if true objerr that would have exited game (and have since been fixed) will cause an objerr
float MAP_OBSTR;							// object errors -> warnings that remove map items should set this. so map repair (tbd) can init an emergency exit
float MAP_REPAIR;							// if true map repairs will execute
void() q_startmap;						// fix start map issue for q single player


float PK_HUB2					= 131072; // bit if TRUE, using custom hub - only used for level transtion from hub vote
//float PK_HUB3					= 262144; // bit if TRUE, using hub3 - reload at hub loads - deprecated
float PK_ADHUB					= 1;		// set to 0 PK_mapmode and admin menu will ignore new maps - item load can still set PK mode for any pk map
//float PK_HUBEXIT;							// TRUE - loading a non PK map while running a custom hub exits the hub loop, FALSE - always return to a custom hub from any map load
float PK_ADMINMAP;						// if true this is an admin map command that overrides custom hub call from GotoNextMap
//float PK_CUSTOMHUB;						// if TRUE, level running is a custom hub

string st_hub2					= "hub2"; // map names for 2nd & 3rd hub
string st_hub3					= "hub3";

float pk_flags;							// replaces old usage of temp1, savedgamecfg stores this
float pk_xsound;							// set to state of PK_XSOUND bit for sound code toggle

float pk_itemovr;							// control items - admin override
float pk_map;								// true if a painkeep map is loaded
float pk_ditems;							// count painkeep items for dyn_items code
float PK_DYNTO					= 120;	// timeout in 120 secs
float PK_DYNRAD				= 8000;	// dynamic radius search 8000 units
float DARKPLACES;							// for detecting darkplaces - modded engine sets cvar("chaos") to this value

float CHAOS_ENG			= 10100010110111; // chaos engine id
float chaos;

float PK_ADMIN;							// allow admin - set this to 0 to completely disable all admin
float pk_adminimp;						// impulse set in admin.cfg to access admin commands, defaults to 255
float pk_admincode;						// code you must enter to access admin commands - set by admin.cfg, defaults to -1
float pk_adminpwdmask;					// if true password will be masked with *'s
float pk_admintime;						// if > 0 - inactivity timer for admin mode
float pk_adminframe;						// only do once per frame
float LIVE_ADMIN				= 100;	// for being in game with admin privs - previous painkeep admin mode
float ADMIN_LOGIN				= -2;		// .admin value for login
float USER_MENU				= -1;		// .admin value that handles user menu - admin code set runs user menus
float USER_TIMEOUT			= 5;		// timeout user menu in 5 secs
float USER_IMPULSE			= 39;		// user menu impulse
float ADMIN_FAILED_LOGIN	= -777;	// login didnt succeed
string ADMINCODE				= "float1\n"; // local command that loads admin security password
													  //- obscured to keep anyone with casual console access from divining its true meaning
string ADMINIMPULSE			= "float2\n"; // load the impulse
string ADMINTIME				= "float3\n"; // load the time out
string ADMINMAPCMD			= "_mapcmd\n"; // append to mapname for alias cmd
float pk_mapcmd				= 1; // TOD: admin option later
float pk_mapcfg				= 1; // TOD: admin option later
//string ADMINSRVCMD			= "_srvcmd\n"; // server vars alias cmd
//float pk_srvcmd				= 1; // TOD: admin option later
float pk_srvcfg				= 1; // TOD: admin option later
void(float tm) th_bot_changeParms; // save bot parms to cvar or parm*

void() pk_srvcmd_set;

// item override admin
float DYN_OVR;
float DYN_ART;
float DYN_FORCE;
float DYN_ARTFR;
float DYN_ARTFR_ONLY; // if set true dynamic only adds artifacts to map
float DYN_FORCE_CNT; // max forced items to load
float DYN_START_TIME			= 5;	// seconds till dynamic spawner starts its thing - precache must cutoff before this, leave a couple secs for map load

float WEP_SSHOT				= 1; 	 // admin of super shotgun
float WEP_NAILGUN				= 2; 	 // admin of nailgun
float WEP_PERF					= 4; 	 // admin of super nailgun
float WEP_GREN					= 8; 	 // admin of grenade
float WEP_ROCKET				= 16;  // admin of rocket
float WEP_THUNDER				= 32;  // admin of thunderbolt
float WEP_PKI					= 64;  // admin of pain keep items
float WEP_WEPSQ				= 63;  // all q weps									= 111111000000
float WEP_WEPSA				= 127; // incl pk items?							= 111111100000
float WEP_STOP					= 128;

// pk items special - not in override var
float WEP_GWELL				= 128;
float WEP_TURRET				= 256;
float WEP_BTRAP				= 512;
float WEP_EXPSH				= 1024;
float WEP_GRAP					= 2048;
float WEP_AIRG					= 4096;
float WEP_CPNB					= 8192;

float ART_QUAD					= 128;  // admin of quad
float ART_INV					= 256;  // admin of invulnerable
float ART_RAD					= 512;  // admin of rad suit
float ART_RING					= 1024; // admin of ring
float ART_ARTS					= 1920; // all art bits								= 000000011110
float ART_STOP					= 2048;

float ARM_GRN					= 2048;  // admin of green armor
float ARM_YEL					= 4096;  // admin of yellow armor
float ARM_RED					= 8192;  // admin of red armor
float ARM_ARMS					= 14336; // all armor bits							= 000000000000111
float ARM_STOP					= 16384;

float HEAL_15					= 16384;  // admin of heal 15
float HEAL_25					= 32768;  // admin of heal 25
float HEAL_100					= 65536;  // admin of heal 100
float HEAL_HEALS				= 114688; // all health bits						= 000000000000000111
float HEAL_STOP				= 131072;

float ITEM_ANY					= 131071; // any item bits set

float CON_ANY					= 8388607; // any bit set in this mask	- any above + controls (all bits - 64)
float CON_STOP					= 131072;  // stop replace / remove cycle here
// CON_* entries
float CON_ONLY					= 131072;  // only the selected items will be loaded
float CON_NONE					= 262144;  // none of the selected items will be loaded
float CON_SUBS					= 524288;  // substitute something for removed items
float CON_INF					= 1048576; // infinite ammo to all weps with bit set above - except carryables
float CON_CYC					= 2097152; // cycle selected bits in thier group
float CON_CHAOS				= 2490368; // item chaos it all 3 control bits set
float CON_RUN					= 4063232; // any control bit CON_* entries above - used by autorun
float CYC_TIME					= 60; // TEST - 240; // seconds for cycle base - 4 mins +|- 2 mins

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

//DP_MOVETYPEFOLLOW
//idea: id Software, LordHavoc (redesigned)
//darkplaces implementation: LordHavoc
//movetype definitions:
float MOVETYPE_FOLLOW = 12;

// relocated from defs.qc

string (string s) precache_sound__ = #19;  // dynamic items deal
string (string s) precache_model__ = #20; 
string (string s) precache_sound;
string (string s) precache_model; 

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
float pk_attack;		// bit 1 = can make a pk attack on any map, bit 2 = pk_artifacts attack
void() use_pkitem; // bots using pk items

// viswep
float qweps, pkweps; // inventory bit masks for weps
.entity vwepent; // vis wep entity pointers
void() viswep_post;
void() viswep_pre;
void(entity vh, float cd) viswep_ld;
void vw_harpoon_pnt(float v_frm); // harpoon rope point
vector(entity hent) grap_vw_adj;

void() player_nail3;
float VW; // viswep support - set to 0 to return to generic gun / axe
float VW_ARMOR; // viswep armor support - eventually admin controlled & cvar

// Items used in impulse 1
float PK_IT_AXE				= 1;
float PK_IT_GRAVITYWELL		= 2;
float PK_IT_TURRET			= 4;
float PK_IT_CANPAB			= 8;
float PK_IT_GRAPGUN			= 16;
float PK_IT_AIRGUN			= 32;
float PK_IT_CLIGHT			= 64;
float PK_IT_BEARTRAP			= 128;
float PK_IT_EXTRADISP		= 4096; //= 256; - pk artifacts support recode

float PK_IT_RANGE				= 112; // range weps - grap, airgun, chainthunder
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
float PK_TURRETAMMO_MAX			= 3;
float PK_CANPABAMMO_MAX			= 1;
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
float AIRG_EXCLUDEENTITY		= 1;

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
float GRAP_OUT					= 1; 		// It's outing out
float GRAP_IN					= 2; 		// It's comming back to the owner
float GRAP_TOHARPOON			= 3; 		// lengthen rope
float GRAP_FIXED				= 4; 		// The length is fixed.
float GRAP_ROPESHORTEN		= 5; 		// shorten rope
float GRAP_ROPELENGTHEN		= 6;		// lengthen rope
float GRAP_HARPOON			= 7;
float GRAP_CORNER				= 8;
float GRAP_ROPE				= 9;

float VW_HARP_FRADJ        = 20; // frame adjust from run / stand for a fired harp

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
string CL_BOBSET           = "cl_bob 0.02\n"; // val for turning view bob back on when not exited hub
float CL_BOBVAL				= 0.02; // standard bob amount
float PK_SF_HUB				= 1024;	// moved to pk_flags
float PK_TP_TIMEMASK			= 63;
float inHubMap;
float custom_hub_loaded;				// if TRUE custom hub is used
float custom_hub_fail;				// if TRUE custom hub was removed but inhubmap may be set

.float voteIntermission;
string() hub_select;
float() check_custom_hub;
float(float cn) bot_vote;			// bot...vote

// MOTD
float MOTDTIME					= 120;		// The amount of "frames" for the motd message (minimum should be 20)
float DONTALLOWBOTS			= 1;		// If we want to show anti bots messages at startup
.float msgcount;
void() updateStatusDisplay;

.float laststattime;					// time of last status update


.float beartrap_time;
.float bt_immune_time;
float BT_BUFFER				= 2;	  	// The nuber of secs people are immune to beartraps after spawning

// Quake Packet Message
float	SVC_CENTERPRINT		= 26;

.float disconnectPlayer;

// If the SFX are enabled or not
//float sparkFlashOff;
float PK_TP_SPARKSFLASH		= 64;

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
void() Admin_mainmenu;
float() admin_postthink;
void() admin_resettimeout;
void() observer; // *bot
void() observer_off;
string OBSERVER = "jafo"; // nod to Blue Thunder : "just another fucking observer"
float pk_flags_ck;
float pk_itemovr_ck;
float (float rl) AdminBitFlag;
void() dyn_item;
void() pk_cphub;
void(entity e) pk_admincfg;
void () tfragadmin_touch;

float PK_TP_STATUSON			= 256;
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
void() bolt_s_explode1;
void(entity grapOwner) grap_remove;
void() pk_stand_frames;
void() pk_run_frames;

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
//void() PK_WeaponFrame;
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

// Rotation
.vector neworigin;
.vector rotate;
.float endtime;
.float rotate_type;
.string path;
.string group;
.string event;
.float duration;


.vector cam; // all chase cam data
void() cam_punch;						// return punchangle if passed parm - otherwise set self. var
void() dead_cam_set;					// Cataboligne 9.11.3 purify proto - chase cam
float DCAMTO					= 0;	// testing 120; // timeout for death cam 2 mins
float DCAMTOACT				= 0;	// action after timeout 0 = respawn, 1 = disconnect

// cam vision field settings
float DCAM_FOV					= 130; // dead cam crow vision
string DCAM_SET_FOV			= "fov 130\n"; // set it if not set or changed
string STD_FOV					= "fov 90\n";
string CAM_FOV					= "fov 80\n"; // field for cam view

// Cataboligne - projectile / cartridge fire(d) positioning - 9.30.9

// really needed by viswep & chasecam which shows how bad original positioning looks

float FL_NDISMDL				= 8388608; // flag to prevent display of viswep models

// q weps
// shotguns - cart eject - just an extra
float VWX_SHOTGUN				= 11;
float VWY_SHOTGUN				= 9;
float VWZ_SHOTGUN				= 9;

float VWX_VEL_SHOTGUN		= 8;	// cart eject velocity
float VWY_VEL_SHOTGUN		= 48;
float VWZ_VEL_SHOTGUN		= 16;

// nails
float VWX_NAILG				= 16;	// 12		v_forward *
float VWY_NAILG				= 9;	//			v_right *
float VWZ_NAILG				= 15;	// 16		v_up *

float VWX_SNAILG				= 22;	// 14
float VWY_SNAILG				= 9;
float VWZ_SNAILG				= 15;	// 16

float VWX_PNAILG				= 31;	// 15
float VWY_PNAILG				= 9.5;// 8
float VWZ_PNAILG				= 14;	// 15

// rockets
float VWX_ROCKETL				= 20;
float VWY_ROCKETL				= 11;
float VWZ_ROCKETL				= 16;

float VWX_GRENADEL			= 18;	// 10
float VWY_GRENADEL			= 11;
float VWZ_GRENADEL			= 16;

// cell guns
float VWX_THUNDER				= 12;
float VWY_THUNDER				= 8;
float VWZ_THUNDER				= 16;

// pk weps
// cell guns
float VWX_CHTHUNDER			= 20;	// 18
float VWY_CHTHUNDER			= 8;
float VWZ_CHTHUNDER			= 16;

float VWX_HARP_IDLE			= 4;	// harpoon is fired, player standing idle
float VWY_HARP_IDLE			= -10;
float VWZ_HARP_IDLE			= -6;

float VWX_HARP_RETR			= 8;	// harpoon being retracted
float VWY_HARP_RETR			= 8;
float VWZ_HARP_RETR			= 0;


// testing
.float alpha; // darkplaces model transparency!

entity lastspawn;

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
