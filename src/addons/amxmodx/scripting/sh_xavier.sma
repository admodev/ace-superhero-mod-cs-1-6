// XAVIER! - BASED ON SPACEDUDE'S NEW XTRAFUNMOD - FORGOT WHERE I FOUND THE TRACEME CODE
// 1.14.4 - significant change - no xtrafun needed for this now...

/* CVARS - copy and paste to shconfig.cfg

//Xavier
xavier_level 7
xavier_traillength 25			//Length of trail behind players
xavier_showteam 0				//Show trails on your team
xavier_showenemy 1				//Show trails on enemies
xavier_refreshtimer 5.0			//How often do the trails refresh

*/

#include <amxmod>
#include <superheromod>

// GLOBAL VARIABLES
new gHeroName[]="Xavier"
new bool:gHasXavierPower[SH_MAXSLOTS+1]
new g_spriteLaserBeam
//----------------------------------------------------------------------------------------------
public plugin_init()
{
	// Plugin Info
	register_plugin("SUPERHERO Xavier","1.18","{HOJ} Batman")

	// DO NOT EDIT THIS FILE TO CHANGE CVARS, USE THE SHCONFIG.CFG
	register_cvar("xavier_level", "7" )
	register_cvar("xavier_traillength", "25" )
	register_cvar("xavier_showteam", "0" )
	register_cvar("xavier_showenemy", "1" )
	register_cvar("xavier_refreshtimer", "5.0" )

	// FIRE THE EVENT TO CREATE THIS SUPERHERO!
	shCreateHero(gHeroName, "Detect Team", "Detect what team a player is on by a glowing trail", false, "xavier_level" )

	// REGISTER EVENTS THIS HERO WILL RESPOND TO! (AND SERVER COMMANDS)

	// INIT
	register_srvcmd("xavier_init", "xavier_init")
	shRegHeroInit(gHeroName, "xavier_init")

	register_event("DeathMsg","death","a")
	register_event("ResetHUD","newRound","b")
}
//----------------------------------------------------------------------------------------------
public plugin_precache()
{
	g_spriteLaserBeam = precache_model("sprites/laserbeam.spr")
}
//----------------------------------------------------------------------------------------------
public xavier_init()
{
	// First Argument is an id
	new temp[6]
	read_argv(1,temp,5)
	new id=str_to_num(temp)
	read_argv(2,temp,5)
	new hasPowers = str_to_num(temp)

	//Clear out any stale tasks
	remove_task(id)

	if ( hasPowers ) {
		set_task(get_cvar_float("xavier_refreshtimer"),"trailMoveCheck", id, "", 0, "b")
	}
	//This gets run if they had the power but don't anymore
	else if (gHasXavierPower[id]) {
		removeAllMarks(id)
	}

	//Sets this variable to the current status
	gHasXavierPower[id] = (hasPowers != 0)
}
//----------------------------------------------------------------------------------------------
public removeAllMarks(id)
{
	new players[32], n

	if ( is_user_connected(id) && gHasXavierPower[id] )  {
		get_players(players, n, "a")
		for ( new p = 0; p < n; p++ ) {
			if ( players[p] == id ) continue
			removeMark(id,players[p])
		}
	}
}
//----------------------------------------------------------------------------------------------
public removeMark(id, pid)
{
	if ( !is_user_connected(id) ) return
	message_begin(MSG_ONE, SVC_TEMPENTITY, {0,0,0}, id)
	write_byte(99)
	write_short(pid)
	message_end()
}
//----------------------------------------------------------------------------------------------
public addAllMarks(id)
{
	new players[32], n
	new bool:sameTeam
	new bool:showTeam
	new bool:showEnemy

	if ( is_user_alive(id) && gHasXavierPower[id] )  {

		showTeam = ( get_cvar_num("xavier_showteam") != 0 )
		showEnemy =( get_cvar_num("xavier_showenemy") != 0 )

		get_players(players, n, "a")
		for ( new p = 0; p < n; p++ ) {

			if ( players[p] == id ) continue
			sameTeam = ( get_user_team(id)==get_user_team(players[p]) )

			if ( (sameTeam && showTeam) || (!sameTeam && showEnemy) )
			addMark(id,players[p])
		}
	}
}
//----------------------------------------------------------------------------------------------
public addMark(id, pid)
{
	if ( !is_user_alive(pid) ) return

	removeMark(id, pid)
	if ( get_user_team(pid) == 1 ) {
		make_trail(id, pid, 255, 0, 0, g_spriteLaserBeam)
	}
	if ( get_user_team(pid) == 2 ) {
		make_trail(id, pid, 0, 0, 255, g_spriteLaserBeam)
	}
}
//----------------------------------------------------------------------------------------------
public make_trail(id, markid, iRed, iGreen, iBlue, spr)
{
	if ( id == markid ) return

	if ( !is_user_alive(id) ) return
	message_begin(MSG_ONE, SVC_TEMPENTITY, {0,0,0}, id)
	write_byte(22)
	write_short(markid)
	write_short(spr)
	write_byte(get_cvar_num("xavier_traillength") ) //length
	write_byte(8)      //width
	write_byte(iRed)   //red
	write_byte(iGreen) //green
	write_byte(iBlue)  //blue
	write_byte(150)    //bright
	message_end()
}
//----------------------------------------------------------------------------------------------
public trailMoveCheck(id)
{
	addAllMarks(id)    // Refresh the Marks...
}
//----------------------------------------------------------------------------------------------
public death()
{
	if (!shModActive() ) return

	new victim_id = read_data(2)
	removeAllMarks(victim_id)
}
//----------------------------------------------------------------------------------------------
public newRound(id)
{
	if ( is_user_alive(id) && gHasXavierPower[id] )  {
		addAllMarks(id)
	}
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
