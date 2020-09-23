/* AMX Mod script.
*
* (c) 2002-2003, OLO
* This file is provided as is (no warranties).
*
* On two minutes before the timelimit plugin
* displays menu with 5 random maps to select.
* One of the options is also map extending.
* Map with most votes becomes the nextmap.
*
* Maps to selected are in config/maps.ini file.
*
* Cvars:
* amx_extendmap_max <time in mins.> - max. time for overall extending
* amx_extendmap_step <time in mins.> - with what time the map will be extended
*
* NOTE: Nextmap plugin is required for proper working of this plugin.
*
*/

#include <translator>
#include <amxmod>
#include <amxmisc>

#define MAX_MAPS    128
#define SELECTMAPS  5

#define MAP_HISTORY  5
new g_hist_mapName[MAP_HISTORY][32]

new g_mapName[MAX_MAPS][32]
new g_mapNums

new g_nextName[SELECTMAPS]
new g_voteCount[SELECTMAPS+2]
new g_mapVoteNum
new g_teamScore[2]
new g_lastMap[32]

new bool:cstrike_running
new bool:g_selected = false
new logfilename[256]

public plugin_init()
{
  load_translations("mapchooser")
  register_plugin(_T("Nextmap chooser"),"0.9.9","default")
  register_menucmd(register_menuid("AMX Choose nextmap:"),(-1^(-1<<(SELECTMAPS+2))),"countVote")
  register_cvar("amx_extendmap_max","90")
  register_cvar("amx_extendmap_step","15")
  new mod_name[32]
  get_modname(mod_name,31)
  cstrike_running = equal(mod_name,"cstrike") ? true : false
  if (cstrike_running)  register_event("TeamScore", "team_score", "a")
  set_task(15.0,"voteNextmap",987456,"",0,"b")
  get_localinfo("lastMap",g_lastMap,31)
  set_localinfo("lastMap","")
  get_time("addons/amx/logs/admin%m%d.log",logfilename,255)
  load_history("addons/amx/config/maphist.ini")
  load_settings("addons/amx/config/maps.ini")
}

public checkVotes(){
   new b = 0
   for(new a = 0; a < g_mapVoteNum; ++a)
      if (g_voteCount[b] < g_voteCount[a])
         b = a
   if ( g_voteCount[SELECTMAPS] > g_voteCount[b] ) {
      new mapname[32]
      get_mapname(mapname,31)
      new Float:steptime = get_cvar_float("amx_extendmap_step")
      set_cvar_float("mp_timelimit", get_cvar_float("mp_timelimit") + steptime )
      client_print(0,print_chat,_T("Choosing finished. Current map will be extended to next %.0f minutes"), steptime )
      log_to_file(logfilename,"Vote: Voting for the nextmap finished. Map %s will be extended to next %.0f minutes",
         mapname , steptime )
      return
   }
   if ( g_voteCount[b] && g_voteCount[SELECTMAPS+1] <= g_voteCount[b] )
      set_cvar_string("amx_nextmap", g_mapName[g_nextName[b]] )
   new smap[32]
   get_cvar_string("amx_nextmap",smap,31)
   client_print(0,print_chat,_T("Choosing finished. The nextmap will be %s"), smap )
   log_to_file(logfilename,"Vote: Voting for the nextmap finished. The nextmap will be %s", smap)
}

public countVote(id,key){
   if ( get_cvar_float("amx_vote_answers") ) {
      new name[32]
      get_user_name(id,name,31)
      if ( key == SELECTMAPS )
         client_print(0,print_chat,_T("%s chose map extending"), name )
      else if ( key < SELECTMAPS )
         client_print(0,print_chat,_T("%s chose %s"), name, g_mapName[g_nextName[key]] )
   }
   ++g_voteCount[key]
   return PLUGIN_HANDLED
}

bool:isInMenu(id){
   for(new a=0; a<g_mapVoteNum; ++a)
      if (id==g_nextName[a])
         return true
   return false
}

public voteNextmap(){
  if (g_mapNums == 0){
    remove_task(987456)
    return
  }
  new mp_winlimit = get_cvar_num("mp_winlimit")
  new mp_maxrounds = get_cvar_num("mp_maxrounds")
  if (mp_winlimit || mp_maxrounds){
    new s = mp_winlimit - 2
    if ( s > g_teamScore[0] || s > g_teamScore[1] ||
      ( (mp_maxrounds - 2) > (g_teamScore[0] + g_teamScore[1]) ) ){
      g_selected = false
      return
    }
  }
  else {
    new timeleft = get_timeleft()
    if (timeleft<1||timeleft>129){
      g_selected = false
      return
    }
  }
  if (g_selected)
    return
  g_selected = true
  new menu[512], a, mkeys = (1<<SELECTMAPS+1)
  new pos = copy(menu,511,cstrike_running ? "\yAMX Choose nextmap:\w^n^n" : "AMX Choose nextmap:^n^n")
  new dmax = (g_mapNums > SELECTMAPS) ? SELECTMAPS : g_mapNums
  for(g_mapVoteNum = 0;g_mapVoteNum<dmax;++g_mapVoteNum){
    a=random_num(0,g_mapNums-1)
    while( isInMenu(a) )
      if (++a >= g_mapNums) a = 0
    g_nextName[g_mapVoteNum] = a
    pos += format(menu[pos],511,"%d. %s^n",g_mapVoteNum+1,g_mapName[a])
    mkeys |= (1<<g_mapVoteNum)
    g_voteCount[g_mapVoteNum] = 0
  }
  menu[pos++]='^n'
  g_voteCount[SELECTMAPS] = 0
  g_voteCount[SELECTMAPS+1] = 0
  new mapname[32]
  get_mapname(mapname,31)

  if (!mp_winlimit && !mp_maxrounds && get_cvar_float("mp_timelimit") < get_cvar_float("amx_extendmap_max")){
    pos += format(menu[pos],511,"%d. Extend map %s^n",SELECTMAPS+1,mapname)
    mkeys |= (1<<SELECTMAPS)
  }

  format(menu[pos],511,"%d. None",SELECTMAPS+2)
  show_menu(0,mkeys,menu,15)
  set_task(15.0,"checkVotes")
  client_print(0,print_chat,_T("It's time to choose the nextmap..."))
  client_cmd(0,"spk Gman/Gman_Choose2")
  log_to_file(logfilename,"Vote: Voting for the nextmap started")
}


load_history(filename[])
{
  if (!file_exists(filename)) return 0

  new a = 0
  for (new pos = 0; pos < MAP_HISTORY; pos++)
    read_file(filename,pos,g_hist_mapName[pos],31,a)

  return 1
}

load_settings(filename[])
{
  if (!file_exists(filename)) return 0

  new szText[32]
  new a, pos = 0
  new currentMap[32]
  get_mapname(currentMap,31)

  while ( g_mapNums < MAX_MAPS && read_file(filename,pos++,szText,31,a) )
  {
    if ( szText[0] != ';'
      && parse(szText, g_mapName[g_mapNums], 31 )
      && is_map_valid( g_mapName[g_mapNums] )
      && !equali( g_mapName[g_mapNums], currentMap ) )
    {
      g_mapNums++
      // check map history
      for (new i = 0; i < MAP_HISTORY; i++)
        if (equali(g_mapName[g_mapNums-1],g_hist_mapName[i]))
        {
          --g_mapNums
          break
        }
    }
  }

  return 1
}

public team_score(){
  new team[2]
  read_data(1,team,1)
  g_teamScore[ (team[0]=='C') ? 0 : 1 ] = read_data(2)
}

public plugin_end(){
  new current_map[32]
  get_mapname(current_map,31 )
  set_localinfo("lastMap",current_map)

  if (file_exists("addons/amx/config/maphist.ini"))
  {
    new text[32]
    new a = 0
    // shift list up 1
    for (new pos = 0; pos < MAP_HISTORY; pos++)
    {
      read_file("addons/amx/config/maphist.ini",pos+1,text,31,a)
      write_file("addons/amx/config/maphist.ini",text,pos)
    }
  }
  write_file("addons/amx/config/maphist.ini",current_map,MAP_HISTORY-1)

}