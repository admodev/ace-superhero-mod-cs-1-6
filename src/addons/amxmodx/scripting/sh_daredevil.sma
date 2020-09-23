// DAREDEVIL! - Yeah - well not all of his powers or it'd be unfair...
// 5/17/2003 Took out light up whole map code - too slow on most computers!

/* CVARS - copy and paste to shconfig.cfg

//Daredevil
daredevil_level 0
daredevil_radius 600		//Radius of the rings
daredevil_bright 192		//How bright to make the rings

*/

#include <amxmod>
#include <superheromod>

// VARIABLES
new gHeroName[]="Daredevil"
new gHasDarePower[SH_MAXSLOTS+1]
new gSpriteWhite, gRadius, gBright
//----------------------------------------------------------------------------------------------
public plugin_init()
{
	// Plugin Info
	register_plugin("SUPERHERO Daredevil","1.18","{HOJ} Batman/JTP10181")

	// DO NOT EDIT THIS FILE TO CHANGE CVARS, USE THE SHCONFIG.CFG
	register_cvar("daredevil_level", "0")
	register_cvar("daredevil_radius", "600")
	register_cvar("daredevil_bright", "192")

	// FIRE THE EVENT TO CREATE THIS SUPERHERO!
	shCreateHero(gHeroName, "Radar Sense", "ESP Rings show you when other players are approaching", false, "daredevil_level" )

	// REGISTER EVENTS THIS HERO WILL RESPOND TO! (AND SERVER COMMANDS)
	register_srvcmd("daredevil_init", "daredevil_init")
	shRegHeroInit(gHeroName, "daredevil_init")

	//ESP Rings Task
	set_task(2.0, "daredevil_esploop", 0, "", 0, "b")

}
//----------------------------------------------------------------------------------------------
public plugin_precache()
{
	gSpriteWhite = precache_model("sprites/white.spr")
}
//----------------------------------------------------------------------------------------------
public daredevil_init()
{
	// First Argument is an id
	new temp[6]
	read_argv(1,temp,5)
	new id = str_to_num(temp)

	// 2nd Argument is 0 or 1 depending on whether the id has flash
	read_argv(2,temp,5)
	new hasPowers = str_to_num(temp)

	gHasDarePower[id] = (hasPowers!=0)
}
//----------------------------------------------------------------------------------------------
public daredevil_esploop()
{
	if (!shModActive()) return

	new players[32]
	new pnum, vec1[3]
	new idring, id

	gRadius = get_cvar_num("daredevil_radius")
	gBright = get_cvar_num("daredevil_bright")

	get_players(players,pnum,"a")

	for (new i = 0; i < pnum; i++) {
		id = players[i]
		if (!gHasDarePower[id]) continue
		if (!is_user_alive(id)) continue
		for (new j = 0; j < pnum; j++) {
			idring = players[j]
			if (idring == id) continue
			if (!is_user_alive(idring)) continue
			if (!get_user_origin(idring,vec1,0)) continue
			message_begin(MSG_ONE,SVC_TEMPENTITY,vec1,id)
			write_byte( 21 )
			write_coord(vec1[0])
			write_coord(vec1[1])
			write_coord(vec1[2] + 16)
			write_coord(vec1[0])
			write_coord(vec1[1])
			write_coord(vec1[2] + gRadius )
			write_short( gSpriteWhite )
			write_byte( 0 ) // startframe
			write_byte( 1 ) // framerate
			write_byte( 6 ) // 3 life 2
			write_byte( 8 ) // width 16
			write_byte( 1 ) // noise
			write_byte( 100 ) // r
			write_byte( 100 ) // g
			write_byte( 255 ) // b
			write_byte( gBright ) //brightness
			write_byte( 0 ) // speed
			message_end()
		}
	}
}
//----------------------------------------------------------------------------------------------
public client_connect(id)
{
	gHasDarePower[id] = false
}
//----------------------------------------------------------------------------------------------