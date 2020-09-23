/*
*  AMX Mod script.
*
* (c) Copyright 2003, ST4life
* This file is provided as is (no warranties).
*/

#include <amxmod>

/*
* "FreeWelcomeMessage" is a plugin to design your WelcomeMessage to what ever
* you want.
*
*/

#define MAX_LINES 50

new datei_lesen[MAX_LINES][128]
new datei_puffer[MAX_LINES][128]
new lesen_num = 0

/*******************************************************************************
** initialize plugin                                                          **
*******************************************************************************/

public plugin_init(){
    register_plugin("FreeWelcomeMsg","0.4","ST4life")
    load_settings("addons/amx/freewelcomemsg.txt")
    return PLUGIN_CONTINUE
}

/*******************************************************************************
** reading files                                                              **
*******************************************************************************/

load_settings(filename[]){
    if(!file_exists(filename)) return 0
    new a, line = 0
    while(lesen_num < MAX_LINES && read_file(filename,line++,datei_lesen[lesen_num],128,a)){
        ++lesen_num
    }
    server_print("[FreeWelcomeMessage] Add %d lines",lesen_num)
    return 1
}

/*******************************************************************************
** client connect - read datas and show them to the player                    **
*******************************************************************************/

public client_connect(id){
    new name[32], authid[32], ip[32], hostname[32], nextmap[32], time[32], mapname[32], mod_ver[32], mod_ver2[32]
    new playersnum[3], maxplayers[3], timeleft[8], timelimit[8], c4timer[8], ff[8], logged[101]
    new amxmod[60], statsme[40], clanmod[40], adminmod[40], chicken[40], csguard[40], hlguard[40]
    new plbot[40], hlbooster[40], axn[40], bmx[40], atac[40], wc3[40], cdeath[40]
    new Float:mp_timelimit = get_cvar_float("mp_timelimit")
    new num_playersnum = get_playersnum()
    new num_maxplayers = get_maxplayers()
    num_to_str(num_playersnum,playersnum,2)
    num_to_str(num_maxplayers,maxplayers,2)
    format(c4timer,7,"%.0f",get_cvar_float("mp_c4timer"))
    format(ff,7,"%s",get_cvar_float("mp_friendlyfire") ? "on" : "off")
    get_cvar_string("hostname",hostname,63)
    get_user_name(id,name,31)
    get_user_authid(id,authid,31)
    get_user_ip(id,ip,31)
    get_time("%m/%d/%Y - %H:%M:%S",time,31)
    get_mapname(mapname,31)
    get_cvar_string("amx_nextmap",nextmap,31)
    if (mp_timelimit){
        new timelefta = get_timeleft()
        if (timelefta > 0)    format(timeleft,7,"%d:%02d",timelefta / 60, timelefta % 60)
        format(timelimit,7,"%.0f",mp_timelimit)
    }
    else {
        format(timeleft,7,"--:--")
        format(timelimit,7,"--")
    }
    new flags = get_user_flags(id)
    if (flags){
        new sflags[32]
        get_flags(flags,sflags,31)
        format(logged,100,"Your access is %s %s",sflags,(flags&ADMIN_IMMUNITY) ? "with immunity" : "without immunity")
    }
    else {
        format(logged,100,"You are not logged as admin or user with privileges")
    }
    get_cvar_string("amx_version",mod_ver,31)
    if (mod_ver[0]) format(amxmod,59,"AMX Mod %s",mod_ver)
    get_cvar_string("statsme_version",mod_ver,31)
    if (mod_ver[0]) format(statsme,39,"StatsMe %s",mod_ver)
    get_cvar_string("clanmod_version",mod_ver,31)
    if (mod_ver[0]) format(clanmod,39,"ClanMod %s",mod_ver)
    get_cvar_string("admin_mod_version",mod_ver,31)
    if (mod_ver[0]) format(adminmod,39,"AdminMod %s",mod_ver)
    get_cvar_string("chicken_version",mod_ver,31)
    if (mod_ver[0]) format(chicken,39,"Chicken %s",mod_ver)
    get_cvar_string("csguard_version",mod_ver,31)
    if (mod_ver[0]) format(csguard,39,"CSGuard %s",mod_ver)
    get_cvar_string("hlguard_version",mod_ver,31)
    if (mod_ver[0]) format(hlguard,39,"HLGuard %s",mod_ver)
    get_cvar_string("plbot_version",mod_ver,31)
    if (mod_ver[0]) format(plbot,39,"PLBot %s",mod_ver)
    get_cvar_string("booster_version",mod_ver,31)
    if (mod_ver[0]) format(hlbooster,39,"HL-Booster %s",mod_ver)
    get_cvar_string("axn_version",mod_ver,31)
    if (mod_ver[0]) format(axn,39,"AXN %s",mod_ver)
    get_cvar_string("bmx_version",mod_ver,31)
    if (mod_ver[0]) format(bmx,39,"BMX %s",mod_ver)
    get_cvar_string("atac_version",mod_ver,31)
    if (mod_ver[0]) format(atac,39,"ATAC %s",mod_ver)
    get_cvar_string("Warcraft_3_XP",mod_ver,31)
    if (mod_ver[0]) format(wc3,39,"Warcraft 3 XP %s",mod_ver)
    get_cvar_string("cdversion",mod_ver,31)
    get_cvar_string("cdrequired",mod_ver2,31)
    if (mod_ver[0]) format(cdeath,39,"Cheating-Death %s - %s",mod_ver,mod_ver2 ? "required" : "optional")
    for(new i = 0; i < lesen_num; ++i) {
        copy(datei_puffer[i],127,datei_lesen[i])
        replace(datei_puffer[i],127,"$authid$",authid)
        replace(datei_puffer[i],127,"$c4timer$",c4timer)
        replace(datei_puffer[i],127,"$ff$",ff)
        replace(datei_puffer[i],127,"$hostname$",hostname)
        replace(datei_puffer[i],127,"$ip$",ip)
        replace(datei_puffer[i],127,"$loggedin$",logged)
        replace(datei_puffer[i],127,"$mapname$",mapname)
        replace(datei_puffer[i],127,"$modamxmod$",amxmod)
        replace(datei_puffer[i],127,"$modstatsme$",statsme)
        replace(datei_puffer[i],127,"$modclanmod$",clanmod)
        replace(datei_puffer[i],127,"$modadminmod$",adminmod)
        replace(datei_puffer[i],127,"$modchicken$",chicken)
        replace(datei_puffer[i],127,"$modcsguard$",csguard)
        replace(datei_puffer[i],127,"$modhlguard$",hlguard)
        replace(datei_puffer[i],127,"$modplbot$",plbot)
        replace(datei_puffer[i],127,"$modhlbooster$",hlbooster)
        replace(datei_puffer[i],127,"$modaxn$",axn)
        replace(datei_puffer[i],127,"$modbmx$",bmx)
        replace(datei_puffer[i],127,"$modatac$",atac)
        replace(datei_puffer[i],127,"$modwc3$",wc3)
        replace(datei_puffer[i],127,"$cdeath$",cdeath)
        replace(datei_puffer[i],127,"$nextmap$",nextmap)
        replace(datei_puffer[i],127,"$playernum$",playersnum)
        replace(datei_puffer[i],127,"$playermax$",maxplayers)
        replace(datei_puffer[i],127,"$time$",time)
        replace(datei_puffer[i],127,"$timeleft$",timeleft)
        replace(datei_puffer[i],127,"$timelimit$",timelimit)
        replace(datei_puffer[i],127,"$username$",name)
        client_cmd(id, "echo ^"%s^"",datei_puffer[i])
    }
    return PLUGIN_CONTINUE
}