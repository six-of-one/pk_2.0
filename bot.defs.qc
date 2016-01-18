// **************************************
// bot consts & protos
// **************************************

float MSG_UPDATENAME			= 13;
float MSG_UPDATEFRAGS		= 14;
float MSG_UPDATECOLORS		= 17;

float observer_time;			// time limit for observer mode

// if .state ==, call cacheRoute when touching this item
float CACHE_ROUTE_TOUCH		= -1559742;
// if .state ==, call  bot_toucheditem when touching this item
float BOT_TOUCHED				= -2479551;
// do both
float BOT_TOUCHED_CACHE_ROUTE_TOUCH	= -4039293;

float BOT_SAVE_SKILL			= 12; // number of bots that can save skill between levels for 1 players parms

// bot mask for flags
//float UNRESTRICTED			= 4096;
float BOTS						= 240;		// (serverflags)                 11110000
float TEAMBOTS					= 3840;		//  (serverflags)            111100000000
float UNRESTRICTED			= 4096; 		//  (serverflags)           1000000000000 - admin - allow anyone to issue bot impulse commands
float TEAMFLAG					= 16384;		//  (serverflags)         100000000000000
float INITLEVEL				= 32768;		//  (serverflags)        1000000000000000 - server - indicate bots need to be spawned after level load
float FL_OBSERVER				= 65536; 	//  (serverflags)       10000000000000000 - admin - flag for observer restrict
float DEDICATED				= 4194304;	//  (serverflags) 10000000000000000000000

// orig

float NORMALSCORE				= 1;
float MYSCORE					= 2;
float DONT_WANT				= 0;
float KINDA_WANT				= 20;
float WANT						= 35;
float MUST_HAVE				= 100;
float SEARCH_RADIUS			= 600;
float LOOPTIME					= 20;
float MAXPATHERS				= 16;
float REGULARTARGET	 		= 0;
float CARRIED					= 1;
float DROPPED					= 2;
float NEVERTARGET				= 3;
float TELEPORT					= 4;
float LOCAL_TIME				= 7;
float CANTURN					= 1;
float NOTURN					= 2;
float STRAFE_DIR				= 16;
float FAR_SEEK					= 32;
float WATERUPDOWN				= 64;
float NODROP					= 128;
float RUNAWAY					= 256;
float GETGOODY					= 512;
float ONTRAIN					= 1024;
float MULTIENEMY				= 2048;

// do item touch bot checks - disabled because PK has its own master touch
//.void() bot_item_touch; 

.float id;

// orig
.float(entity e) th_weight;
.float(entity node, float len, entity item) th_cache;
.void() th_update;
.float istrigger;
//.float healtype;
.float playerkills;
.float playerdeaths;
.float botkills;
.float botdeaths;
.float suicides;
.vector lastseenpos;
.float enemyrun;
.float goody_time;
.float strafetime;
.float strafeonly;
.void() strafethink;
.float strafeyaw;
.float strafedist;
.entity movetarget2;
.entity movetarget3;
.entity movetarget4;
.entity movetarget5;
.entity movetarget6;
.entity lastbot;
.float lasttime;
.float pather;
.float pathtype;
.float skil;
.float rocketlen;
.entity rocketcache;
.float lightninglen;
.entity lightningcache;
.float armorlen;
.entity armorcache;
.float pendinglen;
.entity pendingcache;
.float naillen;
.entity nailcache;
.float grenadelen;
.entity grenadecache;
.float poweruplen;
.entity powerupcache;
.float enemylen;
.entity enemycache;
.float endpoint;
.string teamname;


float VERBOSEBOT;
float BOTSPEED;
float NUMBOTS;
float GRAVITY;
float MAXJUMP;
float INVGRENADELEVELDIST;
float GRENADEMAXHEIGHT;
float LEVELJUMPTIME;
float NUMPATHS;
float NUMGIBS;
float NUMPATHERS;
float SKINSMODE;
float RECURSEDEPTH;
vector REBOUNDSPOT;
float REBOUND;
float TELEFRAGFLAG;
entity NOISEQUEUE;
float HELPING;
float NAMEBOTS;


// Cataboligne - xreaper add in code implement
float XRP = 1; // if true xreap code will be used - mostly extra messages from bots


float c_skill; // holder - carry skill for bot spawning

float last_time_left;
float randombotskin;
float nearlight;

//float max_clients; // *frikbot merge
// float active_clients;

//deprecated
//float fClientNo;
//float fActiveClients;
//void (float abba) MakeGood;
//void (float scoretype) PrintScores;
//float () FindGood;

// id bots
float(entity e) IROBOT; // whats up canner?

// client links
float () getrandombotskin;
void () NewCarriedPath;
void () initBotLevel;
void() bot_skinParms;
void() bot_skinDecode;
//void() set_CarriedPath;
void() set_initBotLevel;
void(float con) bot_con;
void(entity targ, entity attacker) bot_kill;
void() bot_changeParms;
void() bot_changelevel;
void() ai_botstand;

// item links
void(entity e) bot_item_linx;
void(entity e) bot_BackpackSetup;

// admin
void(float skl) AddAnotherBot;
void(entity e) removeBot;
void () setVerboseMode;

// takeover, solves print to bot issues
// inactive while installed with frikbot code, which was adapted

/*
void(entity	client, string s) stuffcmd;
void(entity	client, string s) sprint;
void(entity	client, string s) centerprint;
*/

// orig
float () CheckWaterLevel;
float () CheckDropPath;
void () DropBotPath;
void () endEnemy;
float () BotFoundTarget;
vector () botaim;
void () botImpulseCommand;

// deprecated
//void () initscore;
//void (entity killer, entity killed) countkill;
void (entity ply, float n) removeTeamBots;
void (entity ply, float n) addTeamBots;
void (entity e, float newskin) skinChange;
void () NewCarriedPath;
void (entity a, entity b) addTarget;
void (entity en2) secondEnemy;
void () bot_toucheditem;
void (entity node, entity targ, float len, entity item) cacheRoute;
void () setBotGravity;
void () bot_touched;
void () enemy_touched;
void (entity bot) bot_triggered;

void (entity noisemaker, entity noiseobject) signalnoise;
float (entity e) hearnoise;
entity () noisetarget;
float (entity targ) Spotvisible;
float (entity targ) Platvisible;
float (vector spot) dropline;
void () secret_touch;
