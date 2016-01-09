// **************************************
// bot consts & protos
// **************************************

float MSG_UPDATENAME	 = 13;
float MSG_UPDATEFRAGS	 = 14;
float MSG_UPDATECOLORS	 = 17;

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
void() set_CarriedPath;
void() set_initBotLevel;
