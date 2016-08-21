/* ::-::
 *
 * Cataboligne
 *
 * file: pk_art.defs.qc
 *
 * date: 8/11/09
 *
 * qc - support painkeep artifacts mod (tho 'tis a silly mod)
 *
 */
 
 float PK_ART_DEF;			// admin uses to enable / disable artifacts support - compile with 0 to disable artifacts permanently
 float PK_ART;							// admin artifacts toggle - artifacts code works when non 0
 
void(float sel) pk_art_parms;
void() pk_art_precache;
void() pk_art_attack;
float(float pkn) pk_art_hasammo;
void(float pkimp) pk_art_specialimpulse;
void(float wch) pk_art_setcurrentammo;
void() pk_art_cycleobjects;
void() pk_art_cheat;
void() pk_art_prinv;
void(entity oth)  pk_art_bound_ammo;
void () pk_art_powerup_touch;
void(entity oth, float acnt) pk_art_backpack_touch;
void(entity itm) pk_art_backpack_drop;
float() pk_art_checkpwr;
float(entity trg, entity infl, entity atkr) pk_art_obit;
void(entity en) pk_art_ck_lava;
void (entity targ, entity inflictor, entity attacker, float damage) pk_art_T_Damage;
float(entity ck, string prv) pk_art_movshot_ck;
float(entity ck) pk_art_actor_ck;
string (float bt) pk_art_ammo_by_bit;
float(string cls) pk_art_item_call;
float(string mapNamed) pk_art_hubmapmsg;
void () phone_teleport;

 // prototypes - from
 // splash.qc
void () tombdie;
 // weapons.qc
void () ego_activate;
void () tomb_launch;
void () actor_quad_activate;
void () actor_pent_activate;
void () phone_activate;
// subs.qc
void (entity ownerEntity) ego_remove;


// const - subs.qc

float PKPLUS_TOMB_TIMETOFOLLOW	 = 20;
float TOMB_BUFFER				= 3;
float PKPLUS_TOMB_DMG		= 3;
float PKPLUS_EGOAMMO_MAX	= 2;
float PKPLUS_TOMBAMMO_MAX	= 3;
float PKPLUS_ACTORAMMO_MAX	= 1;
float PKPLUS_PHONEAMMO_MAX	= 1;
float PKPLUS_IT_EGO			= 256;
float PKPLUS_IT_TOMB			= 512;
float PKPLUS_IT_ACTOR		= 1024;
float PKPLUS_IT_PHONE		= 2048;
float PKPLUS_ACTORPENT		= 1;
float PKPLUS_ACTORQUAD		= 2;
float PKPLUS_ACTORINVIS		= 3;
float PRINT_HIGH				= 2;

// vars - subs.qc

/* hip code

deprecated - already in pk_bot

.vector neworigin;
.vector rotate;

.string path;
.string group;
.string event;

.float endtime;
.float rotate_type;
.float duration;
*/
//.entity next_ent; // fx_warning
//.entity lastvictim;
.entity tomb_target;
.entity tomb_touchable;

.float pkplus_egoammo;
.float orbitPosition;
.float egosoundtime;
.float tomb_time;
.float tomb_immune_time;
.float tomb_death_time;
.float tombdmg_time;
.float dodmg;
.float pkplus_tombammo;
.float tombsoundtime;
.float pkplus_actorammo;
.float pkplus_actortype;
.float pkplus_actorskin;
.float pkplus_phoneammo;

// for admin item management - follows ammo by bit stuff

float WEP_EGO					= 16384;
float WEP_TOMB					= 32768;
float WEP_ACTOR				= 65536;
float WEP_PHONE				= 131072;


// qc needing mods for support via pk 2.x

/*
actor.qc			***
client.qc		***
combat.qc		***
ego.qc			***
gravity.qc		***
horn.qc			***
items.qc			***
phone.qc			***
pkpitems.qc		***
player.qc		***
splash.qc		***
subs.qc			***
tomb.qc			***
turret.qc		***
weapons.qc		***

*/