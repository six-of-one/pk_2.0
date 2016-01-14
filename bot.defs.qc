// **************************************
// bot consts & protos
// **************************************

float MSG_UPDATENAME			= 13;
float MSG_UPDATEFRAGS		= 14;
float MSG_UPDATECOLORS		= 17;

float FL_OBSERVER		= 131072; // flag for observer restrict
float observer_time;			// time limit for observer mode
float UNRESTRICTED				= 4096; // admin - allow anyone to issue bot impulse commands

// if .state ==, call cacheRoute when touching this item
float CACHE_ROUTE_TOUCH		= -1559742;
// if .state ==, call  bot_toucheditem when touching this item
float BOT_TOUCHED				= -2479551;
// do both
float BOT_TOUCHED_CACHE_ROUTE_TOUCH	= -4039293;

// do item touch bot checks - disabled because PK has its own master touch
//.void() bot_item_touch; 

.float id;


float fClientNo;
float fActiveClients;

// client links
void (float scoretype) PrintScores;
float () FindGood;
void (float abba) MakeGood;
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

// item links
void(entity e) bot_item_linx;
void(entity e) bot_BackpackSetup;

// admin
void() AddAnotherBot;
void(entity e) removeBot;
void () setVerboseMode;

// takeover, solves print to bot issues
// inactive while installed with frikbot code, which was adapted

/*
void(entity	client, string s) stuffcmd;
void(entity	client, string s) sprint;
void(entity	client, string s) centerprint;
*/
