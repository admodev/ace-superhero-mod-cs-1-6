// Bomberman! - From the NES :)

/* CVARS - copy and paste to shconfig.cfg

//Bomberman
bomberman_level 0
bomberman_cooldown 5		//Cooldown time from bomb explostion until new planting
bomberman_xpbased 0			//Does he get more bombs each level           (def=0)
bomberman_bombs 1			//How Many Bombs does he start with           (def=1)
bomberman_bpl 1			//How Many More Bombs Does he get each level  (def=1)
bomberman_radius 400		//Radius of damage			(def=400)
bomberman_maxdamage 100		//Maximum Damage to deal		(def=100)

*/

//Thanks to TheLooser & Demonic_Frost for help testing

#include <amxmod>
#include <Vexd_Utilities>
#include <superheromod>

// GLOBAL VARIABLES
new gHeroName[]="Bomberman"
new bool:gHasBombPower[SH_MAXSLOTS+1]
new BombEntity[SH_MAXSLOTS + 1], BombAmmo[SH_MAXSLOTS + 1]
new gPlayerLevels[SH_MAXSLOTS+1]
new bombmodel[33], smoke, white, fire, boom
//----------------------------------------------------------------------------------------------
public plugin_init()
{
	// Plugin Info
	register_plugin("SUPERHERO Bomberman","1.18","AssKicR")

	// DO NOT EDIT THIS FILE TO CHANGE CVARS, USE THE SHCONFIG.CFG
	register_cvar("bomberman_level", "0" )
	register_cvar("bomberman_cooldown", "5" )
	register_cvar("bomberman_xpbased", "0" )
	register_cvar("bomberman_bombs", "1" )
	register_cvar("bomberman_bpl", "1" )
	register_cvar("bomberman_radius", "400" )
	register_cvar("bomberman_maxdamage", "100" )

	// FIRE THE EVENT TO CREATE THIS SUPERHERO!
	shCreateHero(gHeroName, "Remote Bombs", "Press +power button to plant, and again to detonate", true, "bomberman_level" )

	// REGISTER EVENTS THIS HERO WILL RESPOND TO! (AND SERVER COMMANDS)
	register_event("ResetHUD","newRound","b")

	// KEY DOWN
	register_srvcmd("bomberman_kd", "bomberman_kd")
	shRegKeyDown(gHeroName, "bomberman_kd")

	// INIT
	register_srvcmd("bomberman_init", "bomberman_init")
	shRegHeroInit(gHeroName, "bomberman_init")

	// LEVELS
	register_srvcmd("bomberman_levels", "bomberman_levels")
	shRegLevels(gHeroName,"bomberman_levels")
}
//----------------------------------------------------------------------------------------------
public plugin_precache()
{
	precache_sound("weapons/c4_plant.wav")
	boom = precache_model("sprites/zerogxplode.spr")

	//What Skin Is The Bomb Gonna Have
	if (file_exists("models/shmod/bomberman_bomb.mdl")) {
		precache_model("models/shmod/bomberman_bomb.mdl")
		copy(bombmodel,32,"models/shmod/bomberman_bomb.mdl")
	}
	else {
		precache_model("models/w_c4.mdl")
		copy(bombmodel,32,"models/w_c4.mdl")
	}
	smoke = precache_model("sprites/steam1.spr")
	white = precache_model("sprites/white.spr")
	fire = precache_model("sprites/explode1.spr")
}
//----------------------------------------------------------------------------------------------
public bomberman_init()
{
	// First Argument is an id
	new temp[6]
	read_argv(1,temp,5)
	new id=str_to_num(temp)

	// 2nd Argument is 0 or 1 depending on whether the id has Bomber man powers
	read_argv(2,temp,5)
	new hasPowers=str_to_num(temp)

	gHasBombPower[id] = (hasPowers!=0)

	if (gHasBombPower[id]) newRound(id)
}
//----------------------------------------------------------------------------------------------
public newRound(id)
{
	gPlayerUltimateUsed[id] = false

	if (!gHasBombPower[id]) return PLUGIN_CONTINUE

	if (BombEntity[id]) {
		RemoveEntity(BombEntity[id])
		BombEntity[id] = 0
	}

	if (get_cvar_num("bomberman_xpbased") == 1) {
		new bombs = ((gPlayerLevels[id]-get_cvar_num("bomberman_level"))*get_cvar_num("bomberman_bpl")+get_cvar_num("bomberman_bombs"))
		//new bombs=((level he is - level he must be) * bombs per level) + starting bombs
		if (bombs > 0) {
			BombAmmo[id] = bombs
		}
		else if (bombs == 0) {
			BombAmmo[id] = 1
		}
		else {
			BombAmmo[id] = 0
		}
	}
	else {
		new bombs = get_cvar_num("bomberman_bombs")
		BombAmmo[id] = bombs
	}
	return PLUGIN_CONTINUE
}
//----------------------------------------------------------------------------------------------
// RESPOND TO KEYDOWN
public bomberman_kd()
{
	if ( !hasRoundStarted() ) return

	// First Argument is an id with bomberman Powers!
	new temp[6]
	read_argv(1,temp,5)
	new id = str_to_num(temp)
	if ( !is_user_alive(id) ) return

	if (BombEntity[id] > 0) {
		explode_bomb(id)
	}
	else {
		plant_bomb(id)
	}
}
//----------------------------------------------------------------------------------------------
public plant_bomb(id)
{
	if (!is_user_alive(id)) return
	if (BombEntity[id] > 0) return

	if (BombAmmo[id] == 0) {
		playSoundDenySelect(id)
		client_print(id,print_center,"You have 0 bombs left")
		return
	}

	if ( gPlayerUltimateUsed[id]) {
		playSoundDenySelect(id)
		return
	}

	BombEntity[id] = CreateEntity("info_target")
	if (BombEntity[id] == 0) return

	Entvars_Set_String(BombEntity[id], EV_SZ_classname, "remote_bomb")
	ENT_SetModel(BombEntity[id], bombmodel)

	new Float:PlayerOrigin[3]
	Entvars_Get_Vector(id, EV_VEC_origin, PlayerOrigin)

	ENT_SetOrigin(BombEntity[id], PlayerOrigin)

	Entvars_Set_Int(BombEntity[id], EV_INT_solid, 0)
	Entvars_Set_Int(BombEntity[id], EV_INT_movetype, 6)
	Entvars_Set_Edict(BombEntity[id], EV_ENT_owner, id)

	emit_sound(BombEntity[id], CHAN_WEAPON, "weapons/c4_plant.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)

	BombAmmo[id]--
	client_print(id,print_center,"Bomb Planted: You have %d bombs left",BombAmmo[id])
}
//----------------------------------------------------------------------------------------------
public explode_bomb(id)
{
	if (!is_user_alive(id)) return
	if (BombEntity[id] == 0) return

	ultimateTimer(id, get_cvar_float("bomberman_cooldown"))

	new Float:vExplodeAt[3]
	Entvars_Get_Vector(BombEntity[id], EV_VEC_origin, vExplodeAt)

	blowUp(id, vExplodeAt)

	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(3)
	write_coord(floatround(vExplodeAt[0]))
	write_coord(floatround(vExplodeAt[1]))
	write_coord(floatround(vExplodeAt[2]))
	write_short(boom)
	write_byte(50)
	write_byte(15)
	write_byte(0)
	message_end()

	RemoveEntity(BombEntity[id])
	BombEntity[id] = 0
}
//----------------------------------------------------------------------------------------------
public client_connect(id)
{
	if (BombEntity[id]) {
		RemoveEntity(BombEntity[id])
	}
	BombEntity[id] = 0
	gPlayerUltimateUsed[id] = false
	gHasBombPower[id] = false
}
//----------------------------------------------------------------------------------------------
public client_disconnect(id)
{
	if (BombEntity[id]) {
		RemoveEntity(BombEntity[id])
	}
	BombEntity[id] = 0
	gPlayerUltimateUsed[id] = false
	gHasBombPower[id] = false
}
//----------------------------------------------------------------------------------------------
public bomberman_levels()
{
	new id[5]
	new lev[5]

	read_argv(1,id,4)
	read_argv(2,lev,4)

	gPlayerLevels[str_to_num(id)]=str_to_num(lev)
}
//----------------------------------------------------------------------------------------------
public blowUp( id, Float:vExplodeAt[3] )
{
	new Float:dRatio, damage, distanceBetween
	new damradius = get_cvar_num("bomberman_radius")
	new maxdamage = get_cvar_num("bomberman_maxdamage")
	new FFOn= get_cvar_num("mp_friendlyfire")

	new origin[3]
	origin[0]=floatround(vExplodeAt[0])
	origin[1]=floatround(vExplodeAt[1])
	origin[2]=floatround(vExplodeAt[2])+37

	explode(origin) // blowup even if dead

	for(new a = 1; a <= SH_MAXSLOTS; a++) {
		if( is_user_alive(a) && ( get_user_team(id) != get_user_team(a) || FFOn != 0 || a == id ) ) {
			new origin1[3]
			get_user_origin(a,origin1)
			distanceBetween = get_distance(origin, origin1 )
			if( distanceBetween < get_cvar_num("bomberman_radius") ) {
				dRatio = float(distanceBetween) / float(damradius)
				damage = maxdamage - floatround( maxdamage * dRatio)
				shExtraDamage(a, id, damage, "Bomberman Bomb")
			} // distance
		} // alive target...
	} // loop
}
//----------------------------------------------------------------------------------------------
public explode( vec1[3] )
{
	// blast circles
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY,vec1)
	write_byte( 21 )
	write_coord(vec1[0])
	write_coord(vec1[1])
	write_coord(vec1[2] + 16)
	write_coord(vec1[0])
	write_coord(vec1[1])
	write_coord(vec1[2] + 1936)
	write_short( white )
	write_byte( 0 ) // startframe
	write_byte( 0 ) // framerate
	write_byte( 2 ) // life 2
	write_byte( 20 ) // width 16
	write_byte( 0 ) // noise
	write_byte( 188 ) // r
	write_byte( 220 ) // g
	write_byte( 255 ) // b
	write_byte( 255 ) //brightness
	write_byte( 0 ) // speed
	message_end()

	//Explosion2
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte( 12 )
	write_coord(vec1[0])
	write_coord(vec1[1])
	write_coord(vec1[2])
	write_byte( 188 ) // byte (scale in 0.1's) 188
	write_byte( 10 ) // byte (framerate)
	message_end()

	//TE_Explosion
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY,vec1)
	write_byte( 3 )
	write_coord(vec1[0])
	write_coord(vec1[1])
	write_coord(vec1[2])
	write_short( fire )
	write_byte( 60 ) // byte (scale in 0.1's) 188
	write_byte( 10 ) // byte (framerate)
	write_byte( 0 ) // byte flags
	message_end()


	//Smoke
	message_begin( MSG_BROADCAST,SVC_TEMPENTITY,vec1)
	write_byte( 5 ) // 5
	write_coord(vec1[0])
	write_coord(vec1[1])
	write_coord(vec1[2])
	write_short( smoke )
	write_byte( 10 )  // 2
	write_byte( 10 )  // 10
	message_end()
}
//----------------------------------------------------------------------------------------------

