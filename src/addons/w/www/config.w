{<includes/global.inc}
{<includes/head.inc}
<table align="center"><tr><td>
{v.authed?
<form action=fileedit.w method=post name=fedit>
Select a Server file to edit \:<br><br>
<select name=filename>
<option value="{c.mapcyclefile}">MapCycle ({c.mapcyclefile})</option>
<option value="autoexec.cfg">Autoexec Config (autoexec.cfg)</option>
<option value="{c.servercfgfile}">Server Config ({c.servercfgfile})</option>
<option value="{c.motdfile}">MOTD ({c.motdfile})</option>
<option value="banned.cfg">Banned AuthIDs (banned.cfg)</option>
<option value="listip.cfg">Banned IPs (listip.cfg)</option>
<option value="addons/metamod/plugins.ini">MetaMod Plugins</option>
</select>
<input type=submit value=Edit>
</form>

{c.admin_mod_version?<form action=fileedit.w method=post name=fedit>
Select an AdminMod 2.50.60 file to edit \:<br><br>
<select name=filename>
<option value="addons/adminmod/config/adminmod.cfg">AdminMod Config</option>
{c.admin_plugin_file?<option value="{c.admin_plugin_file}">AdminMod Plugins</option>}
{c.users_file?<option value="{c.users_file}">AdminMod Admins</option>}
{c.ips_file?<option value="{c.ips_file}">AdminMod IPs</option>}
{c.maps_file?<option value="{c.maps_file}">AdminMod Maps</option>}
{c.words_file?<option value="{c.words_file}">AdminMod Word Filter</option>}
</select>
<input type=submit value=Edit>
</form>}

<!-- AMX (AMXMODX, see below) -->
{c.amx_version?<form action=fileedit.w method=post name=fedit>
Select an AMX file to edit \:<br><br>
<select name=filename>
<option value="addons/amx/config/amx.cfg">AMX Config</option>
<option value="addons/amx/config/plugins.ini">AMX Plugins</option>
<option value="addons/amx/config/users.ini">AMX Admins</option>
<option value="addons/amx/config/modules.ini">AMX Modules</option>
{c.KEEG_Redirect?<option value="addons/amx/redirect.cfg">Plugin\: Redirect</option>}
{c.Clan_Tag_Protection?<option value="addons/amx/clan_tag_protection.cfg">Plugin\: Clan Tag Protect</option>}
{c.chicken_version?<option value="addons/amx/config/chicken/chicken.cfg">Plugin\: ChickenMod Rebirth</option>}
</select>
<input type=submit value=Edit>
</form>}


<!-- AMXMODX (AMX, see above) -->
{c.amxmodx_version?<form action=fileedit.w method=post name=fedit>
Select an AMX Mod X file to edit \:<br><br>
<select name=filename>
<option value="addons/amxmodx/configs/amxx.cfg">AMX Mod X Config</option>
<option value="{c.amxx_plugins}">AMX Mod X Plugins</option>
<option value="addons/amxmodx/configs/users.ini">AMX Mod X Admins</option>
<option value="{c.amxx_modules}">AMX Mod X Modules</option>
</select>
<input type=submit value=Edit>
</form>}

{c.hlg_version?<form action=fileedit.w method=post name=fedit>
Select a HLGuard {c.hlg_checkversion?{c.hlg_checkversion}:{c.hlg_version}} file to edit \:<br><br>
<select name=filename>
{c.hlg_checkversion?<option value="addons/hlguard/config/hlguard.cfg">HLGuard Config</option>:<option value="addons/hlguard/hlguard.cfg">HLGuard Config</option>}
<option value="addons/hlguard/config/hlg_agreement.cfg">HLGuard Agreement Config</option>
<option value="addons/hlguard/config/hlg_custom.cfg">HLGuard Custom Config</option>
<option value="addons/hlguard/config/hlg_lan.cfg">HLGuard LAN Config</option>
<option value="addons/hlguard/config/hlg_league.cfg">HLGuard League Config</option>
<option value="addons/hlguard/config/hlg_menu.cfg">HLGuard Menu Config</option>
<option value="addons/hlguard/config/hlg_nameban.cfg">HLGuard NameBan Config</option>
<option value="addons/hlguard/config/hlg_net.cfg">HLGuard Net Config</option>
</select>
<input type=submit value=Edit>
</form>}

{c.m4_version?<form action=fileedit.w method=post name=fedit>
Select a MatchMod file to edit \:<br><br>
<select name=filename>
{{c.m4_server=LIGHT}?<option value="addons/m4/light.cfg">M4 Light General Config</option>:<option value="addons/m4/mysql.cfg">M4 MySQL Config</option>}
<option value="addons/m4/match.cfg">M4 Match Config</option>
<option value="addons/m4/normal.cfg">M4 Normal Config</option>
</select>
<input type=submit value=Edit>
</form>}

<form action=fileedit.w method=post name=fedit>
Select a WebMod {c.w_version} file to edit \:<br><br>
<select name=filename>
<option value="addons/w/www/index.w">Webmod Index.w</option>
<option value="addons/w/www/config.w">Webmod Config.w</option>
<option value="addons/w/ip.cfg">Webmod IP Config</option>
<option value="addons/w/www/style.css">Webmod CSS</option>
</select>
<input type=submit value=Edit>
</form>

{{{c.statsme_version}|{c.clanmod_version}|{c.DF_hook_on}|{c.p2_version}}?<form action=fileedit.w method=post name=fedit>
Select a different MetaMod plugin file to edit \:<br><br>
<select name=filename>
{c.statsme_version?<option value="addons/statsme/statsme.cfg">StatsMe Config</option>}
{c.clanmod_version?<option value="addons/clanmod/clanmod.cfg">ClanMod Config</option>}
{c.DF_hook_on?<option value="addons/hookmod/DF_config.cfg">Hookmod Config</option>}
{c.p2_version?<option value="addons/p2/p2.cfg">P2 Config</option>
 {{c.p2_data=file}?<option value="addons/p2/players.cfg">P2 Players</option>}
}
</select>
<input type=submit value=Edit>
</form>}
</td></tr></table>
:
{h.location:/auth.w?redir=config.w}
}

{<includes/tail.inc}