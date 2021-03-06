// Anubis - King Of The Underworld

/* CVARS - copy and paste to shconfig.cfg

//Anubis
anubis_level 0
anibus_showdamage 1		//(0|1) - hide|show bullet damage..
anibus_showchat 1		//(0|1) - hide|show ghostchat messages..

*/

/*
*   v1.17 - JTP10181
*	- Added ablily to disable the ghostchat like function
*		for servers that already have ghostchat
*/

#include <amxmod>
#include <Vexd_Utilities>
#include <superheromod>

// GLOBAL VARIABLES
new gHeroName[]="Anubis"
new bool:gHasAnubisPowers[SH_MAXSLOTS+1]
new gmsgSayText

//----------------------------------------------------------------------------------------------
public plugin_init()
{
	// Plugin Info
	register_plugin("SUPERHERO Anubis","1.18","AssKicR/JTP10181")

	// DO NOT EDIT THIS FILE TO CHANGE CVARS, USE THE SHCONFIG.CFG
	register_cvar("anubis_level", "0" )
	register_cvar("anibus_showdamage", "1")
	register_cvar("anibus_showchat", "1")

	// FIRE THE EVENT TO CREATE THIS SUPERHERO!
	shCreateHero(gHeroName, "Dark Notices", "Nothing Is Secret From You.  Hear Enemies - See Damage", false, "anubis_level" )

	// REGISTER EVENTS THIS HERO WILL RESPOND TO! (AND SERVER COMMANDS)
	register_event("ResetHUD","anubis_newround","b")
	register_srvcmd("anubis_init", "anubis_init")
	shRegHeroInit(gHeroName, "anubis_init")

	// Damage Event
	register_event("Damage", "damage_msg", "b", "2!0", "3=0", "4!0")

	// Say
	register_clcmd("say", "handle_say")
	register_clcmd("say_team", "handle_say")

	gmsgSayText = get_user_msgid("SayText")

}
//----------------------------------------------------------------------------------------------
public anubis_init()
{

	new temp[6]
	// First Argument is an id
	read_argv(1,temp,5)
	new id = str_to_num(temp)

	// 2nd Argument is 0 or 1 depending on whether the id has anubis
	read_argv(2,temp,5)
	new hasPowers=str_to_num(temp)

	// Got to disable anubis that lost his powers...
	gHasAnubisPowers[id] = (hasPowers!=0)

	if (gHasAnubisPowers[id]) anubis_speak_on(id)
	else anubis_speak_off(id)

}
//----------------------------------------------------------------------------------------------
public anubis_newround(id)
{
	if (gHasAnubisPowers[id]) anubis_speak_on(id)
}
//----------------------------------------------------------------------------------------------
public handle_say(id)
{

	if ( !get_cvar_num("anibus_showchat") ) return PLUGIN_CONTINUE

	new command[10],players[SH_MAXSLOTS]
	new message[191],name[33], player_count
	new teamname[5], sMessage[191]
	read_argv(0, command, 16)
	read_argv(1, message, 190)

	if (equal(message,"") || equal(message,"[")) return PLUGIN_CONTINUE

	new is_alive = is_user_alive(id)
	new team = get_user_team(id)
	new isSayTeam = equal(command, "say_team")
	get_user_name(id, name, 32)

	if (team == 1) copy(teamname,4,"(T)")
	else if (team == 2)	copy(teamname,4,"(CT)")

	format(sMessage,190, "%c[DN]%s%s%s :  %s^n", 2,  isSayTeam ? teamname : "", is_alive ? "*ALIVE*" : "*DEAD*", name, message)
	get_players(players, player_count, "c")

	for (new i = 0; i < player_count; i++) {
		if (gHasAnubisPowers[players[i]] && is_user_connected(players[i])) {
			if (is_user_alive(players[i]) && !is_alive || isSayTeam && team != get_user_team(players[i])) {
				message_begin(MSG_ONE,gmsgSayText,{0,0,0},players[i])
				write_byte(id)
				write_string(sMessage)
				message_end()
			}
		}
	}
	return PLUGIN_CONTINUE
}
//----------------------------------------------------------------------------------------------
public anubis_speak_on(id)
{
	if (gHasAnubisPowers[id] && is_user_connected(id)) {
		SetSpeak(id, SPEAK_LISTENALL)
	}
}
//----------------------------------------------------------------------------------------------
public anubis_speak_off(id)
{
	if (!gHasAnubisPowers[id] && is_user_connected(id)) {
		SetSpeak(id, SPEAK_NORMAL)
	}
}
//----------------------------------------------------------------------------------------------
public damage_msg(vIndex)
{

	if (!is_user_connected(vIndex)) return PLUGIN_CONTINUE

	if ( get_cvar_num("anibus_showdamage") ) {
		new aIndex = get_user_attacker(vIndex)
		if ( aIndex <= 0 || aIndex > SH_MAXSLOTS ||vIndex <= 0 || vIndex > SH_MAXSLOTS  || vIndex == aIndex ) return PLUGIN_CONTINUE

		new damage = read_data(2)
		if ( is_user_alive(aIndex) && gHasAnubisPowers[aIndex]) {
			set_hudmessage(0, 100, 200, -1.0, 0.55, 2, 0.1, 2.0, 0.02, 0.02, 74)
			show_hudmessage(aIndex,"%i", damage)
		}

		if ( is_user_alive(vIndex) && gHasAnubisPowers[vIndex] ) {
			set_hudmessage(200, 0, 0, -1.0, 0.48, 2, 0.1, 2.0, 0.02, 0.02, 76)
			show_hudmessage(vIndex,"%i", damage)
		}
	}
	return PLUGIN_CONTINUE
}
//----------------------------------------------------------------------------------------------
public client_connect(id)
{
	gHasAnubisPowers[id] = false
}
//----------------------------------------------------------------------------------------------