// IRON MAN! - BASED ON JETPACK By Lazy / Modifications by OLO

/* CVARS - copy and paste to shconfig.cfg

//Iron Man
ironman_level 0
ironman_timer 0.1			//How often (seconds) to run the loop
ironman_thrust 125			//The upward boost every loop
ironman_maxspeed 400		//Max x and y speeds (while in air)
ironman_xymult 1.05			//Multiplies the current x,y vector when moving
ironman_armorfuel 1			//Uses armor as fuel
ironman_fuelcost 1			//How much armor does it cost per firing
ironman_armor 100			//How much armor does ironman start with?

*/

#include <amxmod>
#include <Vexd_Utilities>
#include <superheromod>

// GLOBAL VARIABLES
new gHeroName[]="Iron Man"
new bool:gHasIronManPower[SH_MAXSLOTS+1]
new bool:gRegenAllowed[SH_MAXSLOTS+1]
new g_MaxArmor[SH_MAXSLOTS+1]
new g_jetPackRunning[SH_MAXSLOTS+1]
new g_spriteFire

// BECAUSE THIS LOOP IS CALLED SO MUCH - INSTEAD OF READING CVARS OVER AND OVER
// I'LL KEEP IN GLOBAL - FOR ANTI-LAG HOPEFULLY
new gThrust, Float:gMaxSpeed, gUseFuel, gFuelCost, Float:gMultiplier
//----------------------------------------------------------------------------------------------
public plugin_init()
{
	// Plugin Info
	register_plugin("SUPERHERO Ironman","1.18","{HOJ} Batman/JTP10181")

	// DO NOT EDIT THIS FILE TO CHANGE CVARS, USE THE SHCONFIG.CFG
	register_cvar("ironman_level", "0" )
	register_cvar("ironman_timer", "0.1" )
	register_cvar("ironman_thrust", "125" )
	register_cvar("ironman_maxspeed", "400" )
	register_cvar("ironman_xymult", "1.05")
	register_cvar("ironman_armorfuel", "1" )
	register_cvar("ironman_fuelcost","1")
	register_cvar("ironman_armor","100")

	// FIRE THE EVENT TO CREATE THIS SUPERHERO!
	shCreateHero(gHeroName, "Rocket Pack", "Rocket Jetpack - Jump and rocket to take off", true, "ironman_level" )

	// REGISTER EVENTS THIS HERO WILL RESPOND TO! (AND SERVER COMMANDS)

	// KEY UP
	register_srvcmd("ironman_ku",   "ironman_ku")
	shRegKeyUp(gHeroName, "ironman_ku")

	// KEY DOWN
	register_srvcmd("ironman_kd", "ironman_kd")
	shRegKeyDown(gHeroName, "ironman_kd")

	// DEATH
	register_event("DeathMsg", "ironman_death", "a")

	//New Spawn
	register_event("ResetHUD","newSpawn","b")

	// INIT
	register_srvcmd("ironman_init", "ironman_init")
	shRegHeroInit(gHeroName, "ironman_init")

	//Let MOD know about his max armor
	shSetMaxArmor(gHeroName, "ironman_armor" )

}
//----------------------------------------------------------------------------------------------
public plugin_precache()
{
	g_spriteFire = precache_model("sprites/fire.spr")
	precache_sound("ambience/flameburst1.wav")
	precache_sound("debris/beamstart11.wav")
}
//----------------------------------------------------------------------------------------------
public ironman_init()
{
	// First Argument is an id
	new temp[6]
	read_argv(1,temp,5)
	new id=str_to_num(temp)

	// 2nd Argument is 0 or 1 depending on whether the id has iron man powers
	read_argv(2,temp,5)
	new hasPowers = str_to_num(temp)

	//Clear out any stale tasks
	remove_task(id)

	if ( hasPowers ) {
		set_task( get_cvar_float("ironman_timer"), "ironman_loop", id, "", 0, "b")
	}
	//This gets run if they had the power but don't anymore
	else if (gHasIronManPower[id]) {
		shRemArmorPower(id)
	}

	//Sets this variable to the current status
	gHasIronManPower[id] = (hasPowers!=0)
}
//----------------------------------------------------------------------------------------------
public plugin_cfg()
{
	loadCVARS()
}
//----------------------------------------------------------------------------------------------
public loadCVARS()
{
	gThrust = get_cvar_num("ironman_thrust")
	gMaxSpeed = get_cvar_float("ironman_maxspeed")
	gMultiplier = get_cvar_float("ironman_xymult")
	gUseFuel = get_cvar_num("ironman_armorfuel")
	gFuelCost = get_cvar_num("ironman_fuelcost")
}
//----------------------------------------------------------------------------------------------
public jetPackFireEffect(location[3])
{
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(17)
	write_coord(location[0])
	write_coord(location[1])
	write_coord(location[2])
	write_short(g_spriteFire)
	write_byte(5)
	write_byte(125)
	message_end()
}
//----------------------------------------------------------------------------------------------
public ironman_loop(id)
{
	new Float:velocity[3]
	new origin[3], userArmor

	if ( !is_user_alive(id) || !gRegenAllowed[id] ) return PLUGIN_HANDLED

	// Increase armor for this guy
	userArmor = get_user_armor(id)
	if ( userArmor < g_MaxArmor[id] && g_jetPackRunning[id] == 0 ) {

		//Give the armor item first so CS knows the player has armor
		if (userArmor <= 0) give_item(id, "item_assaultsuit")

		//Set the armor to what we want it to be
		set_user_armor(id, userArmor + 1 )
		return PLUGIN_HANDLED
	}

	// OK - We'll make this armor based - but also add armor
	// So you can run out of fuel, but get it back too
	if ( gUseFuel != 0 && gFuelCost > userArmor && g_jetPackRunning[id] == 1 ) {
		playSoundDenySelect(id)
		g_jetPackRunning[id] = 0
		set_user_info(id,"JP","0")
		emit_sound(id, CHAN_WEAPON, "debris/beamstart11.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
		client_print(id, print_center, "[SH](Ironman) You ran out of Rocket Pack Fuel")
		return PLUGIN_HANDLED
	}

	if (g_jetPackRunning[id] == 1) {

		// Decrement Fuel
		if ( gUseFuel != 0 ) {
			set_user_armor(id, userArmor - gFuelCost )
		}

		Entvars_Get_Vector(id, EV_VEC_velocity, velocity)

		velocity[0] = velocity[0] * gMultiplier
		velocity[1] = velocity[1] * gMultiplier
		velocity[2] += float(gThrust)

		if ( velocity[0] > gMaxSpeed ) 		velocity[0] = gMaxSpeed
		if ( velocity[0] < (gMaxSpeed * -1) )	velocity[0] = gMaxSpeed * -1
		if ( velocity[1] > gMaxSpeed  )		velocity[1] = gMaxSpeed
		if ( velocity[1] < (gMaxSpeed * -1) )	velocity[1] = gMaxSpeed * -1
		if ( velocity[2] > gThrust * 2.0 )		velocity[2] = gThrust * 2.0

		Entvars_Set_Vector(id, EV_VEC_velocity, velocity)

		get_user_origin(id, origin, 0)
		jetPackFireEffect(origin)
		emit_sound(id, CHAN_WEAPON, "ambience/flameburst1.wav", 1.0, ATTN_NORM, 0, PITCH_LOW)
	}
	return PLUGIN_CONTINUE
}
//----------------------------------------------------------------------------------------------
// RESPOND TO KEYDOWN
public ironman_kd()
{
	// First Argument is an id with Ironman Powers!
	new temp[6]
	read_argv(1,temp,5)
	new id=str_to_num(temp)

	if ( !is_user_alive(id) || !hasRoundStarted() ) return

	g_jetPackRunning[id] = 1
	set_user_info(id,"JP","1")

	//Reload CVARS to make sure the variables are current
	loadCVARS()
}
//----------------------------------------------------------------------------------------------
public ironman_death()
{
	new id = read_data(2)

	if ( id <= 0 || id > SH_MAXSLOTS ) return

	g_jetPackRunning[id] = 0
	set_user_info(id,"JP","0")
	gRegenAllowed[id] = false
}
//----------------------------------------------------------------------------------------------
// RESPOND TO KEYUP
public ironman_ku()
{
	// First Argument is an id with Ironman Powers!
	new temp[6]
	read_argv(1,temp,5)
	new id = str_to_num(temp)

	if (g_jetPackRunning[id] != 1) return

	g_jetPackRunning[id] = 0
	set_user_info(id,"JP","0")

	emit_sound(id, CHAN_WEAPON, "debris/beamstart11.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
}
//----------------------------------------------------------------------------------------------
public newSpawn(id)
{
	gRegenAllowed[id] = false
	set_task(1.0, "spawnDelay", id)
}
//----------------------------------------------------------------------------------------------
public spawnDelay(id)
{
	g_MaxArmor[id] = get_user_armor(id)
	gRegenAllowed[id] = true
}
//----------------------------------------------------------------------------------------------
public client_disconnect(id)
{
	// stupid check but lets see
	if ( id <= 0 || id > SH_MAXSLOTS ) return

	gHasIronManPower[id] = false
	g_jetPackRunning[id] = 0
	set_user_info(id,"JP","0")
	gRegenAllowed[id] = false

	// Yeah don't want any left over residuals
	remove_task(id)
}
//----------------------------------------------------------------------------------------------
public client_connect(id)
{
	// stupid check but lets see
	if ( id <= 0 || id > SH_MAXSLOTS ) return

	gHasIronManPower[id] = false
	g_jetPackRunning[id] = 0
	set_user_info(id,"JP","0")
	gRegenAllowed[id] = false

	// Yeah don't want any left over residuals
	remove_task(id)
}
//----------------------------------------------------------------------------------------------