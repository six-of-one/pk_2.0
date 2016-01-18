

// precache all PK items here - relocated from world.qc

void() pk_precache =
{
// old ambient sounds for pk_mode not set to PK

	precache_sound ("alt_ambience/windfly.wav");
	precache_sound ("alt_ambience/hum1.wav");
	precache_sound ("alt_sounds/items/r_item2.wav");
	precache_sound ("alt_sounds/misc/secret.wav");

// New teleport sounds
	precache_sound ("misc/teleport/tele_1.wav");
	precache_sound ("misc/teleport/tele_2.wav");
	precache_sound ("misc/teleport/tele_3.wav");
	precache_sound ("misc/teleport/tele_4.wav");
	precache_sound ("misc/teleport/tele_1a.wav");
	precache_sound ("misc/teleport/tele_2a.wav");
	precache_sound ("misc/teleport/tele_3a.wav");
	precache_sound ("misc/teleport/tele_4a.wav");

// SPLASH
	precache_model ("progs/s_splash.spr");
	precache_model ("progs/s_splava.spr");

// extra gibs ...
	precache_model ("progs/g_arm.mdl");
	precache_model ("progs/g_boot.mdl");
	precache_model ("progs/g_eye.mdl");
	precache_model ("progs/g_fore.mdl");
	precache_model ("progs/g_leg.mdl");

// Gib1 alternative
	precache_model ("progs/qtgib1.mdl");

// Gib2 alternatives
	precache_model ("progs/qtgib2.mdl");

// h_player alternative
	precache_model ("progs/qtgib3.mdl");

// Painkeep item pickup sound
	precache_sound("misc/pickup/tone2.wav");

// view models
	precache_model ("progs/v_bear.mdl");
	precache_model ("progs/v_turret.mdl");
	precache_model ("progs/v_harp.mdl");
	precache_model ("progs/v_cube.mdl");
	precache_model ("progs/v_beans.mdl");

// files used in the AirFist.
	precache_model ("progs/v_airgun.mdl");	// Player view of airgun
	precache_model ("progs/s_ablast.spr");	// Air Gun Fire sprite

// weapon precache


// TURRET_START
	precache_model ("progs/nail.mdl");
	precache_model ("progs/turgib1.mdl");
	precache_model ("progs/turgib2.mdl");
	precache_model ("progs/turgib3.mdl");
	precache_model ("progs/turstand.mdl");
	precache_model ("progs/turtop.mdl");
	precache_model ("progs/turtop2.mdl");
	precache_sound ("weapons/sentry/turrt_3.wav");
	precache_sound ("weapons/sentry/turcl_2b.wav");

// GRAVITY Moved to here so the cheat command would work correctly
	precache_model ("progs/cubsmall.mdl");
	precache_model ("progs/cube.mdl");
	precache_model ("progs/cubel.mdl");
	precache_sound ("misc/grav/grav_new.wav");
	precache_sound ("items/protect.wav");

// AIRG_MAIN_START
// prechache the AirFist fire sounds.
	precache_sound ("weapons/airfist/agfire.wav");	// Air gunfire
	precache_sound ("weapons/airfist/agfail.wav");	// Air gunfailed fire
	precache_sound ("weapons/airfist/agwater.wav");	 // Air gun	under water shot
	precache_sound ("weapons/airfist/agwfail.wav");	 // Air gun fail water shot

// GRAPPLING_START
	precache_sound ("weapons/grapple/graph_2b.wav");// Hit solid
	precache_sound ("weapons/grapple/grapf_1.wav");	 // Hit fresh
	precache_sound ("weapons/grapple/grapl_2.wav");	 // Launch
	precache_sound ("weapons/grapple/grapr_2.wav");	 // Rope going out
	precache_sound ("weapons/grapple/graps_2.wav");	 // Rope coming back
	precache_model ("progs/harpoon.mdl");
	precache_model ("progs/harprope.mdl");
	precache_model ("progs/harpcoil.mdl");
	precache_model ("progs/g_harp.mdl");
	precache_model ("progs/v_harp.mdl");
	precache_sound ("misc/null.wav");

// BOLT_START
	precache_model ("progs/v_cl_off.mdl");
	precache_model ("progs/v_cl_on.mdl");
	precache_sound ("weapons/clight/clight_1.wav");
	precache_model ("progs/fryguy.mdl");

// COPB_START
	precache_sound ("weapons/copb/copb_1.wav");// Fart sounds...
	precache_sound ("weapons/copb/copb_2.wav");
	precache_sound ("weapons/copb/copb_3.wav");
	precache_sound ("weapons/copb/copb_4.wav");
	precache_sound ("weapons/copb/copb_5.wav");

// PULSE_GUN_START
	precache_model ("progs/g_fnail.mdl");
	precache_model ("progs/pnail.mdl");
	precache_model ("progs/v_fnail.mdl");
	precache_sound ("weapons/pulse/pulse_1.wav");
	precache_sound ("weapons/pulse/ric_1.wav");
	precache_sound ("weapons/pulse/ric_2.wav");
	precache_sound ("weapons/pulse/ric_3.wav");

	precache_model ("progs/v_fnail.mdl");

// BEARTRAP
	precache_sound ("weapons/btrap/btrap_1.wav");
	precache_sound ("weapons/btrap/bdrop_1.wav");
	precache_sound ("weapons/btrap/btrap_3.wav");
	precache_model ("progs/beartrap.mdl");
	precache_model ("progs/bearbld.mdl");
	precache_model ("progs/beargib1.mdl");
	precache_model ("progs/beargib2.mdl");
	precache_model ("progs/beargib3.mdl");
	precache_model ("progs/beargib4.mdl");

// EXPLODESHELLS_START
	precache_model ("progs/v_eshot.mdl");
	precache_model ("progs/v_eshot2.mdl");
	precache_sound ("weapons/explode/expfire1.wav");
	precache_sound ("weapons/explode/expfire2.wav");
	precache_model ("progs/x_explo1.spr");
	precache_model ("progs/x_explo2.spr");

// for the Hub map pop respawn
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");

// extra player sounds
	precache_sound ("player/gib_1.wav");
	precache_sound ("player/gib_2.wav");
	precache_sound ("player/gib_3.wav");

// admin
	precache_model ("progs/s_light.spr");// light up admin
	precache_model ("progs/hub_port.mdl"); // custom hub levels
	precache_model ("progs/shambler.mdl"); // custom hub levels

// relocated (pkitems.qc) for dynamic items
	precache_model ("progs/tpower.mdl");
	precache_model ("progs/beans.mdl");
	precache_model ("progs/bearpick.mdl");
	precache_model ("maps/b_eshel0.bsp");
	precache_model ("progs/g_airgun2.mdl");
	precache_model ("progs/g_clight.mdl");
	precache_model ("progs/g_harp.mdl");

// relocated (pkpitems.qc) for dynamic items
	precache_model ("progs/ego.mdl");
	precache_model ("progs/tomb.mdl");
	precache_model ("progs/actor.mdl");
	precache_model ("progs/phone.mdl");

};

// precache early required by: dynamic items, translates, cycles
//			things that havent been map loaded can still be called up

void() q1_precache =
{
// relocated (items.qc) for dynamic items
// heal
	precache_model ("maps/b_bh10.bsp");
	precache_sound ("items/r_item1.wav");
	precache_model ("maps/b_bh100.bsp");
	precache_sound ("items/r_item2.wav");
	precache_model ("maps/b_bh25.bsp");
	precache_sound ("items/health1.wav");
	precache_model ("maps/b_explob.bsp");
	precache_model ("maps/b_exbox2.bsp");
	precache_sound ("weapons/r_exp3.wav");
// armor
	precache_model ("progs/armor.mdl");
// weps
	precache_model ("progs/g_shot.mdl");
	precache_model ("progs/g_nail.mdl");
	precache_model ("progs/g_nail2.mdl");
	precache_model ("progs/g_rock.mdl");
	precache_model ("progs/g_rock2.mdl");
	precache_model ("progs/g_light.mdl");
// ammo
	precache_model ("maps/b_shell1.bsp");
	precache_model ("maps/b_shell0.bsp");
	precache_model ("maps/b_nail1.bsp");
	precache_model ("maps/b_nail0.bsp");
	precache_model ("maps/b_rock1.bsp");
	precache_model ("maps/b_rock0.bsp");
	precache_model ("maps/b_batt1.bsp");
	precache_model ("maps/b_batt0.bsp");
// keys
	precache_sound ("misc/medkey.wav");
	precache_sound ("misc/runekey.wav");
	precache_sound ("misc/basekey.wav");
	precache_model ("progs/w_s_key.mdl");
	precache_model ("progs/m_s_key.mdl");
	precache_model ("progs/b_s_key.mdl");
	precache_model ("progs/w_g_key.mdl");
	precache_model ("progs/m_g_key.mdl");
	precache_model ("progs/b_g_key.mdl");
// sigil
	precache_sound ("misc/runekey.wav");
	precache_model ("progs/end1.mdl");
	precache_model ("progs/end2.mdl");
	precache_model ("progs/end3.mdl");
	precache_model ("progs/end4.mdl");
	precache_sound ("boss1/sight1.wav");
// artifacts
	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	precache_model ("progs/suit.mdl");
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	precache_model ("progs/invisibl.mdl");
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");

// new modes for turret
	precache_model ("progs/laser.mdl");
	precache_sound ("enforcer/enfire.wav");
	precache_sound ("enforcer/enfstop.wav");

// visible weapon support - projectile / shell eject location alternate v models (1pv)

	precache_model ("progs/v2_shot.mdl");
	precache_model ("progs/v2_shot2.mdl");
	precache_model ("progs/v2_nail.mdl");
	precache_model ("progs/v2_nail2.mdl");
	precache_model ("progs/v2_rock.mdl");
	precache_model ("progs/v2_rock2.mdl");
	precache_model ("progs/v2_pulsenail.mdl");
	precache_model ("progs/v2_harp.mdl");

};