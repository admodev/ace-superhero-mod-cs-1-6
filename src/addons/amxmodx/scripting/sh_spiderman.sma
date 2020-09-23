// SPIDERMAN! - BASED ON SPACEDUDE'S NINJA HOOK

/* CVARS - copy and paste to shconfig.cfg

//Spiderman
spiderman_level 0
spiderman_moveacc 140		//How quickly he can move while on the hook
spiderman_reelspeed 400		//How fast hook line reels in
spiderman_hookstyle 2		//1=spacedude, 2=spacedude auto reel (spiderman), 3=cheap kids real	(batgirl)
spiderman_teamcolored 1		//1=teamcolored web lines 0=white web lines
spiderman_maxhooks 60		//Max ammout of hooks allowed (-1 is an unlimited ammount)

*/

#include <amxmod>
#include <Vexd_Utilities>
#include <superheromod>

#if defined AMX98
	#include <xtrafun>  //Only for the constants, doesn't use any functions
#endif

// GLOBAL VARIABLES
#define HOOKBEAMLIFE  100
#define HOOKBEAMPOINT 1
#define HOOKKILLBEAM  99
#define HOOK_DELTA_T  0.1  // units per second

new gHeroName[]="Spider-Man"
new bool:gHasSpiderPower[SH_MAXSLOTS+1]
new g_hookLocation[SH_MAXSLOTS+1][3]
new g_hookLength[SH_MAXSLOTS+1]
new bool:g_hooked[SH_MAXSLOTS+1]
new Float:g_hookCreated[SH_MAXSLOTS+1]
new g_hooksLeft[SH_MAXSLOTS+1]
new g_spriteWeb
//----------------------------------------------------------------------------------------------
public plugin_init()
{
	// Plugin Info
	register_plugin("SUPERHERO Spider-Man","1.18","{HOJ} Batman/JTP10181")

	// DO NOT EDIT THIS FILE TO CHANGE CVARS, USE THE SHCONFIG.CFG
	register_cvar("spiderman_level", "0" )
	register_cvar("spiderman_moveacc", "140" )
	register_cvar("spiderman_reelspeed", "400" )
	register_cvar("spiderman_hookstyle", "2" )
	register_cvar("spiderman_maxhooks", "60" )
	register_cvar("spiderman_teamcolored", "1" )

	// FIRE THE EVENT TO CREATE THIS SUPERHERO!
	shCreateHero(gHeroName, "Web Swing", "Shoot Web to Swing - Jump Reels In, Duck Reels Out", true, "spiderman_level" )

	// REGISTER EVENTS THIS HERO WILL RESPOND TO! (AND SERVER COMMANDS)

	// KEY UP
	register_srvcmd("spiderman_ku",   "spiderman_ku")
	shRegKeyUp(gHeroName, "spiderman_ku")

	// KEY DOWN
	register_srvcmd("spiderman_kd", "spiderman_kd")
	shRegKeyDown(gHeroName, "spiderman_kd")

	// DEATH
	register_event("DeathMsg", "spiderman_death", "a")  // Re-uses KeyUp!

	// INIT
	register_srvcmd("spiderman_init", "spiderman_init")
	shRegHeroInit(gHeroName, "spiderman_init")

	// Reset theHookCounts every round (regardless of spiderpower)
	register_event("ResetHUD","newRound","b")

}
//----------------------------------------------------------------------------------------------
public plugin_precache()
{
	precache_sound("bullchicken/bc_bite2.wav")
	g_spriteWeb = precache_model("sprites/zbeam4.spr")
}
//----------------------------------------------------------------------------------------------
public spiderman_init()
{
	// First Argument is an id
	new temp[6]
	read_argv(1,temp,5)
	new id=str_to_num(temp)

	// 2nd Argument is 0 or 1 depending on whether the id has spiderman powers
	read_argv(2,temp,5)
	new hasPowers = str_to_num(temp)

	gHasSpiderPower[id] = (hasPowers!=0)
	if ( g_hooked[id] ) spiderman_hookOff(id)
}
//----------------------------------------------------------------------------------------------
public spiderman_kd()
{
	new temp[6]
	read_argv(1,temp,5)
	new id = str_to_num(temp)

	if ( g_hooked[id] || !is_user_alive(id) || !gHasSpiderPower[id] || !hasRoundStarted() ) return

	spiderman_hookOn(id)
}
//----------------------------------------------------------------------------------------------
public spiderman_ku()
{
	new temp[10]
	read_argv(1,temp,9)
	new id=str_to_num(temp)

	if ( g_hooked[id] ) spiderman_hookOff(id)
}
//----------------------------------------------------------------------------------------------
public spiderman_death()
{
	new id = read_data(2)
	if ( id < 1 || id > SH_MAXSLOTS) return
	if ( g_hooked[id] ) spiderman_hookOff(id)
}
//----------------------------------------------------------------------------------------------
public spiderman_checkWeb(parm[])
{
	new id=parm[0]
	new style=parm[1]

	if (style==1) spiderman_physics(id, false)
	if (style==2) spiderman_physics(id, true)
	if (style>2 || style < 0 ) spiderman_cheapReel( id )
}
//----------------------------------------------------------------------------------------------
public spiderman_physics(id, bool:autoReel)
{
	new user_origin[3], user_look[3], user_direction[3], move_direction[3]
	new A[3], D[3], buttonadjust[3]
	new acceleration, Float:vTowards_A, Float:DvTowards_A
	new Float:velocity[3], null[3], buttonpress

	if ( !g_hooked[id]  ) return

	if (!is_user_alive(id)) {
		spiderman_hookOff(id)
		return
	}

	if ( g_hookCreated[id] + HOOKBEAMLIFE/10 <= get_gametime() ) {
		beamentpoint(id)
	}

	null[0] = 0
	null[1] = 0
	null[2] = 0

	get_user_origin(id, user_origin)
	get_user_origin(id, user_look, 2)

	Entvars_Get_Vector(id, EV_VEC_velocity, velocity)

	buttonadjust[0] = 0
	buttonadjust[1] = 0

	buttonpress = Entvars_Get_Int(id, EV_INT_button)

	if (buttonpress&IN_FORWARD) {
		buttonadjust[0] += 1
	}
	if (buttonpress&IN_BACK) {
		buttonadjust[0] -= 1
	}
	if (buttonpress&IN_MOVERIGHT) {
		buttonadjust[1] += 1
	}
	if (buttonpress&IN_MOVELEFT) {
		buttonadjust[1] -= 1
	}
	if (buttonpress&IN_JUMP) {
		buttonadjust[2] += 1
	}
	if (buttonpress&IN_DUCK) {
		buttonadjust[2] -= 1
	}

	if (buttonadjust[0] || buttonadjust[1]) {
		user_direction[0] = user_look[0] - user_origin[0]
		user_direction[1] = user_look[1] - user_origin[1]

		move_direction[0] = buttonadjust[0] * user_direction[0] + user_direction[1] * buttonadjust[1]
		move_direction[1] = buttonadjust[0] * user_direction[1] - user_direction[0] * buttonadjust[1]
		move_direction[2] = 0

		velocity[0] += move_direction[0] * get_cvar_float("spiderman_moveacc") * HOOK_DELTA_T / get_distance(null,move_direction)
		velocity[1] += move_direction[1] * get_cvar_float("spiderman_moveacc") * HOOK_DELTA_T / get_distance(null,move_direction)
	}
	if (buttonadjust[2] < 0 || (buttonadjust[2] && g_hookLength[id] >= 60)) {
		g_hookLength[id] -= floatround(buttonadjust[2] * get_cvar_float("spiderman_reelspeed") * HOOK_DELTA_T)
	}
	else if (autoReel && !(buttonpress&IN_DUCK) && g_hookLength[id] >= 200) {
		buttonadjust[2] += 1
		g_hookLength[id] -= floatround(buttonadjust[2] * get_cvar_float("spiderman_reelspeed") * HOOK_DELTA_T)
	}

	A[0] = g_hookLocation[id][0] - user_origin[0]
	A[1] = g_hookLocation[id][1] - user_origin[1]
	A[2] = g_hookLocation[id][2] - user_origin[2]

	D[0] = A[0]*A[2] / get_distance(null,A)
	D[1] = A[1]*A[2] / get_distance(null,A)
	D[2] = -(A[1]*A[1] + A[0]*A[0]) / get_distance(null,A)

	new aDistance = get_distance(null,D) ? get_distance(null,D) : 1
	acceleration = (-get_cvar_num("sv_gravity")) * D[2] / aDistance

	vTowards_A = (velocity[0] * A[0] + velocity[1] * A[1] + velocity[2] * A[2]) / get_distance(null,A)
	DvTowards_A = float((get_distance(user_origin,g_hookLocation[id]) - g_hookLength[id]) * 4)

	if (get_distance(null,D) > 10) {
		velocity[0] += (acceleration * HOOK_DELTA_T * D[0]) / get_distance(null,D)
		velocity[1] += (acceleration * HOOK_DELTA_T * D[1]) / get_distance(null,D)
		velocity[2] += (acceleration * HOOK_DELTA_T * D[2]) / get_distance(null,D)
	}

	velocity[0] += ((DvTowards_A - vTowards_A) * A[0]) / get_distance(null,A)
	velocity[1] += ((DvTowards_A - vTowards_A) * A[1]) / get_distance(null,A)
	velocity[2] += ((DvTowards_A - vTowards_A) * A[2]) / get_distance(null,A)

	Entvars_Set_Vector(id, EV_VEC_velocity, velocity)
}
//----------------------------------------------------------------------------------------------
public spiderman_cheapReel(id)
{
	// Cheat Web - just drags you where you shoot it...

	if ( !g_hooked[id] ) return

	new user_origin[3]
	new Float:velocity[3]

	if (!is_user_alive(id)) {
		spiderman_hookOff(id)
		return
	}

	get_user_origin(id, user_origin)

	Entvars_Get_Vector(id, EV_VEC_velocity, velocity)

	new distance = get_distance( g_hookLocation[id], user_origin )
	if ( distance > 60 ) {
		velocity[0] = (g_hookLocation[id][0] - user_origin[0]) * ( 1.0 * get_cvar_num("spiderman_reelspeed") / distance )
		velocity[1] = (g_hookLocation[id][1] - user_origin[1]) * ( 1.0 * get_cvar_num("spiderman_reelspeed") / distance )
		velocity[2] = (g_hookLocation[id][2] - user_origin[2]) * ( 1.0 * get_cvar_num("spiderman_reelspeed") / distance )
	}
	else {
		velocity[0] = 0.0
		velocity[1] = 0.0
		velocity[2] = 0.0
	}

	Entvars_Set_Vector(id, EV_VEC_velocity, velocity)
}
//----------------------------------------------------------------------------------------------
public spiderman_hookOn(id)
{
	new parm[2], user_origin[3]
	parm[0] = id

	if ( !is_user_alive(id) ) return PLUGIN_HANDLED

	if ( g_hooksLeft[id] == 0 ) {
		playSoundDenySelect(id)
		return PLUGIN_HANDLED
	}

	if ( g_hooksLeft[id] > 0 ) g_hooksLeft[id]--

	if ( g_hooksLeft[id]>=0 && g_hooksLeft[id]<5 ) {
		client_print(id, print_center, "You have %d Spiderman hooks left", g_hooksLeft[id] )
	}

	g_hooked[id] = true
	set_user_info(id,"ROPE","1")
	get_user_origin(id, user_origin)
	get_user_origin(id, g_hookLocation[id], 3)
	g_hookLength[id] = get_distance(g_hookLocation[id],user_origin)
	set_user_gravity(id,0.001)
	beamentpoint(id)
	emit_sound(id, CHAN_STATIC, "bullchicken/bc_bite2.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
	parm[1]=get_cvar_num("spiderman_hookstyle")
	set_task(HOOK_DELTA_T, "spiderman_checkWeb", id, parm, 2, "b")

	return PLUGIN_CONTINUE
}
//----------------------------------------------------------------------------------------------
public spiderman_hookOff(id)
{
	g_hooked[id] = false
	set_user_info(id,"ROPE","0")
	killbeam(id)
	if ( is_user_connected(id) ) shSetGravityPower(id)
	remove_task(id)
}
//----------------------------------------------------------------------------------------------
public beamentpoint(id)
{
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
	write_byte( HOOKBEAMPOINT )
	write_short( id )
	write_coord( g_hookLocation[id][0] )
	write_coord( g_hookLocation[id][1] )
	write_coord( g_hookLocation[id][2] )
	write_short( g_spriteWeb )// sprite index
	write_byte( 0 )           // start frame
	write_byte( 0 )           // framerate
	write_byte( HOOKBEAMLIFE )// life
	write_byte( 10 )          // width
	write_byte( 0 )           // noise
	if (!get_cvar_num("spiderman_teamcolored")) {
		write_byte( 250 )       // r, g, b
		write_byte( 250 )       // r, g, b
		write_byte( 250 )       // r, g, b
	}
	// Terrorist
	else if (get_user_team(id)==1) {
		write_byte( 255 )     // r, g, b
		write_byte( 0 )       // r, g, b
		write_byte( 0 )       // r, g, b
	}
	// Counter-Terrorist
	else {
		write_byte( 0 )      // r, g, b
		write_byte( 0 )      // r, g, b
		write_byte( 255 )    // r, g, b
	}
	write_byte( 150 )        // brightness
	write_byte( 0 )          // speed
	message_end( )
	g_hookCreated[id] = get_gametime()
}
//----------------------------------------------------------------------------------------------
public killbeam(id)
{
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
	write_byte( HOOKKILLBEAM )
	write_short( id )
	message_end()
}
//----------------------------------------------------------------------------------------------
public newRound(id)
{
	g_hooksLeft[id] = get_cvar_num("spiderman_maxhooks")
	if ( g_hooked[id] ) spiderman_hookOff(id)
}
//----------------------------------------------------------------------------------------------
public client_disconnect(id)
{
	// stupid check but lets see
	if ( id <= 0 || id > SH_MAXSLOTS ) return

	// Yeah don't want any left over residuals
	remove_task(id)
}
//----------------------------------------------------------------------------------------------