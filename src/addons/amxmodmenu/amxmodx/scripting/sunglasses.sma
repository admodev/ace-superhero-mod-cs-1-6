/* 
*
*	Sunglasses
*	Version 1.0 
*	Author: Calzinger; Calzinger@hotmail.com (MSN)  xSouLHeLLTemplaR (AIM) 
*	Author: AssKicR;	to_asskicr@hotmail.com (MSN)  DaAssKicR (AIM) 
*	Thanks to Blunted1 for testing, suggestions, and other important aid.
* 
*	This plugin will add sunglasses to Counter-Strike. You can buy/sell your pair
*	of sunglasses. While wearing a pair of sunglasses, your vision will be dimmed 
*	slightly, but you will be immune to flashbangs. Be careful though, if you are 
*	not wearing a pair of sunglasses, you can be struck by the sun and be blinded
*	temporarily! You can set the cost of sunglasses, the amount of darken of the 
*	sunglasses, and enable/disable buyzone & buytime.
*
*	Requirements: 
*		Compiled on 0.9.4.
*		Tested successfully on 0.9.3.
*		Tested successfully on 0.9.4.
*		Should work successfully on 0.9.5.
* 
*	Admin Commands: 
*		amx_shades < nick, uniqueid, #userid, @TEAM, or * > <- Gives shades to specified client(s)
*		amx_unshades < nick, uniqueid, #userid, @TEAM, or * > <- Causes shades to break
*
*	Client Commands: 
*		say /shades <- Displays the Sunglasses help menu 
*		buyshades <- Buys a pair for specified player 
*			(Player must be in buyzone if specified by CVAR) 
*		sellshades <- Sells player's pair of shades for 75% of the sell price
* 
*	Server CVARs: 
*		amx_shades_darken "100 - 200" <- Amount of darkness when a player has sunglasses on
*		amx_shades_cost "1500 - 10000" <- Amount of cash it takes to buy a pair of sunglasses 
*		amx_shades_buyzone 1/0 <- If on, player will required to be in a buyzone when buying sunglasses 
*		amx_shades_buytime 1/0 <- If on, only allows player to buy sunglasses during buytime
* 
*/

#include <amxmodx> 
#include <amxmisc> 
#include <cstrike>

new shade
new bool:sun[33] 

new bool:BuyTimeAllow 
new bool:BuyZoneAllow[33] 
new Float:BuyTimeFloat 
new BuyTimeNum 
new bool:BuyTimeCvar 
new bool:BuyZoneCvar 

public client_connect(id) { 
	sun[id]=false 
} 

public client_disconnect(id) { 
	sun[id]=false 
	
} 

public amx_sunglasses(id,level,cid) { 
	if (!cmd_access(id,level,cid,2)) { 
		return PLUGIN_HANDLED 
	} 

	new target[32] 
	read_argv(1,target,31) 

	new admin[32] 
	get_user_name(id,admin,31) 

	if (target[0]=='@') { 
		new team[32], inum 
		get_players(team,inum,"e",target[1]) 
		if (inum==0) { 
			console_print(id,"[AMX] No clients found on such team.") 
			return PLUGIN_HANDLED 
		} 
		for (new i=0;i<inum;++i) { 
			sun[team[i]]=true 
			client_print(0,print_chat,"AMX Command: %s has gave all %s's sunglasses.",admin,target[1]) 
		} 
	} 
	else if (target[0]=='*') { 
		new all[32], inum
		get_players(all,inum) 
		for (new i=0;i<inum;++i) { 
			sun[all[i]]=true 
			client_print(0,print_chat,"AMX Command: %s has gave all clients sunglasses.",admin) 
		} 
	} 
	else { 
		new player = cmd_target(id,target,0) 
		new playername[32] 
		get_user_name(player,playername,31) 

		if (!player) {  
			return PLUGIN_HANDLED 
		} 

		sun[player]=true 
		client_print(0,print_chat,"AMX Command: %s has given %s sunglasses.",admin,playername) 
	} 

	return PLUGIN_HANDLED 
} 

public amx_unsunglasses(id,level,cid) { 
	if (!cmd_access(id,level,cid,2)) { 
		return PLUGIN_HANDLED 
	} 

	new target[32] 
	read_argv(1,target,31) 

	new admin[32] 
	get_user_name(id,admin,31) 

	if (target[0]=='@') { 
		new team[32], inum 
		get_players(team,inum,"e",target[1]) 
		if (inum==0) { 
			console_print(id,"[AMX] No clients found on such team.") 
			return	PLUGIN_HANDLED 
		} 
		for (new i=0;i<inum;i++) { 
			sun[team[i]]=false 
			BreakShades(team[i],15,1,255,255,0,255) 
			client_print(0,print_chat,"AMX Command: %s caused all of the %s's sunglasses to break.",admin,target[1]) 
		} 
	} 
	else if (target[0]=='*') { 
		new all[32], inum 
		get_players(all,inum) 
		for (new i=0;i<inum;++i) { 
			sun[all[i]]=false
			BreakShades(all[i],15,1,255,255,0,255)
			client_print(0,print_chat,"AMX Command: %s has caused all clients' sunglasses to break.",admin) 
		} 
	} 
	else { 
		new player = cmd_target(id,target,0) 
		new playername[32] 
		get_user_name(player,playername,31) 

		if (!player) { 
			return PLUGIN_HANDLED 
		} 

		sun[player]=false
		BreakShades(player,15,1,255,255,0,255)
		client_print(0,print_chat,"AMX Command: %s has caused %s's sunglasses to break.",admin,playername) 
	} 

	return PLUGIN_HANDLED 
} 

public cost_force() { 
	if (get_cvar_num("amx_shades_cost") < 1500) { 
		set_cvar_num("amx_shades_cost",1500) 
	} 
	if (get_cvar_num("amx_shades_cost") > 10000) { 
		set_cvar_num("amx_shades_cost",10000) 
	} 
	return PLUGIN_CONTINUE 
} 

public shade_init() { 
	new all[32], all_num 
	get_players(all,all_num) 
	for (new i=0; i < all_num;i++) { 
		if(sun[all[i]]) { 
			new alpha = get_cvar_num("amx_shades_darken") 
			if ((alpha > 200) && (all[i] >= 1) && (all[i] <= 32)) { 
				message_begin(MSG_ONE,shade,{0,0,0},all[i]) 
				write_short( 15 ) 
				write_short( 15 ) 
				write_short( 12 ) 
				write_byte( 0 ) 
				write_byte( 0 ) 
				write_byte( 0 ) 
				write_byte( 200 ) 
				message_end() 
			} 
			else if ((alpha < 100) && (all[i] >= 1) && (all[i] <= 32)) { 
				message_begin(MSG_ONE,shade,{0,0,0},all[i]) 
				write_short( 15 ) 
				write_short( 15 ) 
				write_short( 12 ) 
				write_byte( 0 ) 
				write_byte( 0 ) 
				write_byte( 0 ) 
				write_byte( 100 ) 
				message_end()
			} 
			else if ((alpha >=100) && (alpha <= 200) && (all[i] >= 1) && (all[i] <= 32)) { 
				message_begin(MSG_ONE,shade,{0,0,0},all[i]) 
				write_short( 15 ) 
				write_short( 15 ) 
				write_short( 12 ) 
				write_byte( 0 ) 
				write_byte( 0 ) 
				write_byte( 0 ) 
				write_byte( alpha ) 
				message_end() 
			} 
		} 
		//else if (!sun[all[i])	 
	} 

	return PLUGIN_CONTINUE 
} 

public advertise() { 
	if (get_cvar_num("amx_shades_on") == 1) {
		new all[32], all_num 
		get_players(all,all_num) 
		for (new i=0;i<all_num;i++) { 
			if ((!sun[all[i]]) && (get_cvar_num("amx_shades_advertise") != 0)) { 
				message_begin(MSG_ONE,shade,{0,0,0},all[i]) 
				write_short( 1<<15 ) 
				write_short( 1<<1 ) 
				write_short( 1<<12 ) 
				write_byte( 255 ) 
				write_byte( 255 ) 
				write_byte( 0 ) 
				write_byte( 200 ) 
				message_end() 
				client_print(all[i],print_center,"You should have bought a pair of Sunglasses! Type /shades for details!")
			} 
		} 
	}
	return	PLUGIN_CONTINUE 
} 

public BreakShades(id, fade, hold, red, green, blue, alpha)
  {
	 if (!is_user_alive(id)) return
	 message_begin(MSG_ONE,shade,{0,0,0},id)
	 write_short( 1<<fade ) // fade lasts this long duration
	 write_short( 1<<hold ) // fade lasts this long hold time
	 write_short( 1<<12 ) // fade type (in / out)
	 write_byte( red ) // fade red
	 write_byte( green ) // fade green
	 write_byte( blue ) // fade blue
	 write_byte( alpha ) // fade alpha
	 message_end()
  }

public SellShades(id, fade, hold, red, green, blue, alpha)
  {
	 if (!is_user_alive(id)) return
	 message_begin(MSG_ONE,shade,{0,0,0},id)
	 write_short( 1<<fade ) // fade lasts this long duration
	 write_short( 1<<hold ) // fade lasts this long hold time
	 write_short( 1<<12 ) // fade type (in / out)
	 write_byte( red ) // fade red
	 write_byte( green ) // fade green
	 write_byte( blue ) // fade blue
	 write_byte( alpha ) // fade alpha
	 message_end()
  }

public RoundTime() 
{ 
	if ( read_data(1)==get_cvar_num("mp_freezetime") || read_data(1)==6 ) // freezetime starts 
	{ 
		remove_task(701) // remove buytime task 
		BuyTimeAllow = true 
		BuyTimeFloat = get_cvar_float("mp_buytime") * 60 
		BuyTimeNum = floatround(BuyTimeFloat,floatround_floor) 
		BuyTimeCvar = (get_cvar_num("amx_shades_buytime")) ? true : false 
		BuyZoneCvar = (get_cvar_num("amx_shades_buyzone")) ? true : false 
	} 
	else // freezetime is over 
	{ 
		set_task(BuyTimeFloat,"BuyTimeTask",701) 
	} 

	return PLUGIN_CONTINUE 
} 

public BuyTimeTask() 
{ 
	BuyTimeAllow = false // buytime is over 
} 

public BuyIcon(id) // player is in buyzone? 
{ 
	if (read_data(1)) 
		BuyZoneAllow[id] = true 
	else 
		BuyZoneAllow[id] = false 

	return PLUGIN_CONTINUE 
} 

public Check(id) // check if player can buy 
{
	if ( get_cvar_num("amx_shades_on")!=1){
		client_print(id,print_chat,"[SHADES] Sry, the admin has disables shades.") 
		return false 
	}
	if ( !is_user_alive(id)){
		client_print(id,print_center,"You cannot buy while dead.") 
		return false 
	}
	
	if ((!BuyZoneAllow[id]&&BuyZoneCvar) ) {
		client_print(id,print_center,"You cannot buy outside of the buyzone.") 
		return false 
	}
	
	if (BuyTimeCvar) { 
		if (!CheckTime(id)) 
			return false 
	} 
	return true 
}

public CheckTime(id) // check buytime 
{ 
	if (!BuyTimeAllow) 
	{ 
		client_print(id,print_center,"%d seconds have passed...^n^nYou can't buy anything now!",BuyTimeNum) 
		return false 
	} 
	return true 
} 

public buy_shades(id) { 
	new name[32] 
	get_user_name(id,name,31) 
	new userCash = cs_get_user_money(id) 
	new shade_cost = get_cvar_num("amx_shades_cost")  
	
	if (sun[id]) { 
		client_print(id,print_chat,"[SHADES] You currently have a pair of shades.") 
		return PLUGIN_HANDLED
	}
	if (!Check(id)) { 
		return PLUGIN_HANDLED
	} 

	if (userCash < shade_cost) { 
		client_print(id,print_center,"You have insufficient funds!") 
		client_print(id,print_chat,"[SHADES] You do not have enough money to buy sunglasses. You need $%i.",shade_cost) 
		return	PLUGIN_HANDLED 
	} 
	else if (userCash >= shade_cost) { 
		sun[id]=true 
		cs_set_user_money(id,userCash - shade_cost,1) 
		client_print(id,print_chat,"[SHADES] You have successfully bought a pair of sunglasses.") 
		return	PLUGIN_HANDLED 
	} 
	
	return PLUGIN_HANDLED 
} 

public sell_shades(id) { 
	new name[32] 
	get_user_name(id,name,31) 
	new userCash = cs_get_user_money(id) 
	new shade_sell = get_cvar_num("amx_shades_cost")*2/3
  
	if (!sun[id]) {
		client_print(id,print_chat,"[SHADES] You currently do not have any shades.")
	}

	if (sun[id]) { 
		sun[id]=false
		cs_set_user_money(id,userCash + shade_sell,1)
		client_print(id,print_chat,"[SHADES] You have sold your shades for 75 percent of the sell price.") 
		SellShades(id, 15, 1, 255, 255, 0, 0)
	} 

	return PLUGIN_HANDLED 
} 

public HandleSay(id) { 
	new Speech[192] 
	read_args(Speech,192) 
	remove_quotes(Speech) 
	if( (containi(Speech, "shades") != -1) || (containi(Speech, "sun") != -1) || (containi(Speech, "flash") != -1) || (containi(Speech, "glass") != -1) ){ 
			client_print(id,print_chat, "[SHADES] You can buy Sunglasses on this server. Type /shades for details.") 
		} 
	return PLUGIN_CONTINUE 
} 

public shade_help(id) 
{ 
  new buffer[1024] 
  new len = copy( buffer ,  1023 ,  "Buy Sunglasses:^n\ 
  Bind a key to buyshades -- OR -- Type buyshades in console^n^n\
  To Sell Sunglasses:^n\ 
  Bind a key to sellshades -- OR -- type sellshades in console^n^n\ 
  In order to bind a key you must open your console and use the bind command: ^n\ 
  Bind ^"key^" ^"command^" ^n^n" )
	
  len += copy( buffer[len] ,  1023-len , "In this case the commands are ^"buyshades^" & ^"sellshades^".^nHere are some examples:^n\ 
	 bind / buyshades				bind / sellshades^n^n\ 
  When you have the Sunglassess:^n\
  - Your screen will become a little darker. ^n\ 
  - You will be protected from flashbangs. ^n\ 
  - You will be protected from the sun.") 
  show_motd(id,buffer ,"Shades Help:") 
  return PLUGIN_HANDLED 
} 

public plugin_init() { 
	register_plugin("Sunglasses","1.1","Calzinger/AssKicR") 
	register_clcmd("buyshades","buy_shades") 
	register_clcmd("sellshades","sell_shades") 
	register_concmd("amx_shades","amx_sunglasses",ADMIN_LEVEL_A,"< Nick, UniqueID, #userid, @TEAM, or * > gives player a pair of sunglasses") 
	register_concmd("amx_unshades","amx_unsunglasses",ADMIN_LEVEL_A,"< Nick, UniqueID< #userid, @TEAM, or * > removes player's sunglasses") 
	register_cvar("amx_shades_darken","150") 
	register_cvar("amx_shades_cost","8000") 
	register_cvar("amx_shades_buyzone","1") 
	register_cvar("amx_shades_buytime","1") 
	register_cvar("amx_shades_advertise","1") 
	register_cvar("amx_shades_on","1")
	register_event("StatusIcon","BuyIcon","be","2=buyzone") 
	register_event("RoundTime","RoundTime","bc") 

	register_clcmd("say","HandleSay",0) 
	register_clcmd("say /shades", "shade_help",0,": Opens Shades help menu")

	set_task(0.1,"shade_init",0,"",0,"b") 
	set_task(0.5,"cost_force",0,"",0,"b") 
	set_task(300.0,"advertise",0,"",0,"b") 

	shade = get_user_msgid("ScreenFade") 

	return PLUGIN_CONTINUE 
} 
