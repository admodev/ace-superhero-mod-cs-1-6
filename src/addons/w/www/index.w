{<includes/global.inc}
{<includes/head.inc}

{v.refreshtimer:10} {##=Time between automatic page refresh, add <span id="timer">{v.refreshtimer}</span>&nbsp; where you want number to show}
{v.showmappic:0} {#0=disable mappic, 1=enable mappic}

{<includes/countdown.inc}

{v.mappic:/mappics/{W.map}.jpg}
{v.mapok:{@file_exists:{W.moddir}/addons/w/www{v.mappic}}}

<center>
<b>.: Informa&ccedil;&otilde;es do Servidor :.</b><br>
<br>

<table align="center" cellspacing="1" cellpadding="2">

<tr>
<td class="normcell" align="center"><script language="javascript">document.write("<a href='javascript:location.reload()'>Refresh</a> <a href='javascript:setrefresh();'><span id='timer'>{v.refreshtimer}</span></a>");</script></td>
<td class="normcell" align="center"><a href="steam: &quot;-applaunch 10 -game cstrike +connect {c.ip}:{c.port}&quot;">Conectar no Servidor </a></td>
{{v.showmappic=1}?{v.mapok?<td class="transp" style="background-image\: url('{v.mappic}'); background-repeat\: no-repeat; background-position\: center" width="300" {{{v.authed}|{v.admin}}?rowspan="13":rowspan="10"}>&nbsp;</td>}}
</tr>

<tr>
<td class="normcell"><b>Nome:</b></td>
<td class="normcell" align="right">{c.hostname}</td>
</tr>

<tr>
<td class="normcell"><b>Jogadores:</b></td>
<td class="normcell" align="right">{W.users}/{W.maxplayers}
{{W.users=W.players}?:({W.players} Active)}
{v.p2known:0}{{{I.p2=i.p2}&{W.users>0}}?<br><font size=-2>({v.p2known:{@p2_known}}{v.p2known} known by p2)</font>}</td>
</tr>

<tr>
<td class="normcell"><b>Mapa Atual :</b></td>
<td class="normcell" align="right">{W.map}</td>
</tr>

{
{{v.authed}|{v.admin}}?
{{C.mapcycle=0}?{v.mapcycle:0}}
{{C.mapcycle=1}?{v.mapcycle:1}}
{{G.mapcycle=0}?{v.mapcycle:0}{C.mapcycle:0}}
{{G.mapcycle=1}?{v.mapcycle:1}{C.mapcycle:1}}

<tr>
<td class="normcell"><b><b>Proximo Mapa</b>\:</b></td>
<td class="normcell">
<form action=changelevel.w method=post name=changelevel>
<input type="radio" name="maptype" value="c"> Other\: <input type="text" name="custommap" size="20"><br>
<input type="radio" name="maptype" value="m" checked> Mapcycle\: <select name="cyclemap">
{v.mapcycle?
{L.L:v.mapname:
:{@trim:{<<{W.moddir}/{c.mapcyclefile}}}:<option name={v.mapname}{{v.mapname=W.map}? selected}>{v.mapname}</option>}
:{L.m:<option name={m.name}{{m.name=W.map}? selected}>{m.name}</option>}}
</select> <input type="submit" value="OK">
</form>
</td>
</tr>}


<tr>
<td class="normcell"><b>Proximo Mapa:</b></td>
<td class="normcell" align="right">{c.amx_nextmap}</td>
</tr>

<tr>
<td class="normcell"><b>Senha:</b></td>
<td class="normcell" align="right">{c.sv_password?{{v.authed|v.admin}?{c.sv_password} (<a href="changecvar.w?nopass=ask">Remove Password</a>):Sim}:N&atilde;o}</td>
</tr>

{{v.authed}?
<tr>
<td class="normcell"><b>{{c.sv_password=}?Add:Change} Password\:</b></td>
<td class="normcell" align="right">
<form action=changecvar.w method=post name=setpass><input type="text" name="setpass" size="20"> <input type="submit" value="OK"></form>
</td>
</tr>
}

{{c.mp_timelimit=0}?
<tr>
<td class="normcell"><b>Time Limit\:</b></td>
<td class="normcell" align="right">N&atilde;o tem tempo</td>
</tr>
:
<tr>
<td class="normcell"><b>Time Left\:</b></td>
<td class="normcell" align="right">{c.amx_timeleft} minutos </td>
</tr>

<tr>
<td class="normcell"><b>Time Limit\:</b></td>
<td class="normcell" align="right">{c.mp_timelimit}  minutos</td>
</tr>
}

{{{v.authed}|{v.admin}}?
<tr>
<td class="normcell"><b>Change Time Limit\:</b></td>
<td class="normcell" align="right"><a href="changecvar.w?timelimit=30">30</a>, <a href="changecvar.w?timelimit=45">45</a>, <a href="changecvar.w?timelimit=60">60</a>, <a href="changecvar.w?timelimit=75">75</a>, <a href="changecvar.w?timelimit=90">90</a>  minutos</td>
</tr>
}

<tr>
<td class="normcell"><b>Tempo do Round:</b></td>
<td class="normcell" align="right">{c.mp_roundtime}  minutos</td>
</tr>

<tr>
<td class="normcell"><b>Fogo-Amigo:</b></td>
<td class="normcell" align="right">{c.mp_friendlyfire?Ligado:Desligado} {{v.authed|v.admin}?(<a href="changecvar.w?turnff={{c.mp_friendlyfire=1}?off:on}">Change</a>)}</td>
</tr>

</table>

<br><br>
<b>.: Jogadores e Scores :.</b><br>
<br>
<table width="755" align="center" cellspacing="1" cellpadding="2">
<tr>
<td class="normcell" width="20" align="center"><b></b></td>
<td class="normcell" width="240" align="center"><b>Nick</b></td>
<td class="normcell" width="40" align="center"><b>Score</b></td>
<td width="40" align="center" class="normcell"><strong>Morte</strong></td>
<td class="normcell" width="75" align="center"><b>Time</b></td>
<td class="normcell" width="130" align="center"><b>Authid</b></td>
<td class="normcell" width="40" align="center"><b>Ping</b></td>
<td class="normcell" width="40" align="center"><b>Loss</b></td>
<td class="normcell" width="80" align="center"><b>IP</b></td>
<td class="normcell" width="50" align="center"><b>Admin</b></td>
</tr>
{W.players?
{L.l:v.whichteam:CT,TERRORIST,SPECTATOR,UNASSIGNED:
	{v.total_ping:0}{v.total_loss:0}{v.team_usercount:0}
	{L.u:{{p.team=v.whichteam}?
		{v.total_ping:{v.total_ping+p.ping}}{v.total_loss:{v.total_loss+p.loss}}{v.team_usercount:{v.team_usercount+1}}
	}}
	{{{{v.whichteam=SPECTATOR}|{v.whichteam=UNASSIGNED}}&{v.team_usercount=0}}?
	:
	<tr>
	<td class="team{v.whichteam}" colspan="2"><font size="4">{{v.whichteam=CT}?COUNTER-TERRORIST:{v.whichteam}}</font></td>
	<td class="team{v.whichteam}" colspan="2" align="center"><font size="4">{{v.whichteam=CT}?{@teamscore:CT}:{{v.whichteam=TERRORIST}?{@teamscore:TERRORIST}}}</font></td>
	<td class="team{v.whichteam}"></td>
	<td class="team{v.whichteam}" align="center">{v.team_usercount} Player{{v.team_usercount!1}?s}</td>
	{{v.team_usercount=0}?{v.team_usercount:1}}
	<td class="team{v.whichteam}" align="center">{v.total_ping/v.team_usercount}</td>
	<td class="team{v.whichteam}" align="center">{v.total_loss/v.team_usercount}</td>
	<td class="team{v.whichteam}"></td>
	<td class="team{v.whichteam}"></td>
	</tr>
	}
{L.p:
{{p.team=v.whichteam}?
{v.celltype:{p.team?team{p.team}:normcell}}
<tr>
<td class="{v.celltype}" align="center">{{{p.dead}&{p.team!SPECTATOR}&{p.team!UNASSIGNED}}?<img src="images/skull.gif" border="0">}{{p.bomb}?<img src="images/c4.gif" border="0">}{{p.vip}?<img src="images/vip.gif" border="0">}</td>
<td class="{v.celltype}">{v.authed?<a href="player.w?uid={p.uid}">{p.name}</a>:{v.admin?<a href="player_message.w?uid={p.uid}">{p.name}</a>:{p.name}}}</td>
<td class="{v.celltype}" align="center">{p.frags}</td>
<td class="{v.celltype}" align="center">{p.deaths}</td>
<td class="{v.celltype}" align="center">{p.ctime}</td>
<td class="{v.celltype}" align="center">{p.authid}</td>
<td class="{v.celltype}" align="center">{p.ping}</td>
<td class="{v.celltype}" align="center">{p.loss}{v.total_loss:{v.total_loss+p.loss}}</td>
<td class="{v.celltype}" align="center">{{v.admin|v.authed}?{p.ip}:Hidden}</td>
<td class="{v.celltype}" align="center">{{{{c.amx_userflags{p.id}}=z}|{{c.amx_userflags{p.id}}=}}?:Yes}</td>
</tr>
{v.team_usercount:{v.team_usercount+1}}
}
}
}
:
<tr>
  <td class="normcell" colspan="10" align="center"><i>N&atilde;o a Jogador </i>{W.users?<br>
    ({W.users} Currently Connecting)}</td></tr>
}
</table>
<table width="755" align="center" cellspacing="0" cellpadding="2">
<tr><td class="teamCT" width="325">Counter-Terrorists</td><td class="teamCT" align="center" width="50">{@teamscore:CT}</td>
<td class="normcell" width="5"></td>
<td class="teamTERRORIST" width="325">Terrorists</td><td class="teamTERRORIST" align="center" width="50">{@teamscore:TERRORIST}</td></tr>
</table>

<br><br>
<table align="center"style="border-width: 0">
<tr>
<td valign="top" align="center"><b>.: Configura&ccedil;&atilde;o :.</b><br>
  <br>
 <table width="300" align="center" cellspacing="1" cellpadding="2">
 {L.l:v.cvarname:sv_contact,mp_autoteambalance,mp_buytime,mp_c4timer,mp_flashlight,mp_footsteps,mp_freezetime,sv_alltalk:
 <tr><td class="normcell">{v.cvarname}</td><td class="normcell"><div align="right">{c.{v.cvarname}}</div></td></tr>}
 </table>
</td>

<td valign="top" align="center"><b>.: Mods Usados:.</b><br>
  <br>
 <table width="300" align="center" cellspacing="1" cellpadding="2">
 <tr><td class="normcell" width="50%">Server OS</td><td class="normcell" width="50%" align="right">{{W.OS=Win32}?Windows:{W.OS}}</td></tr>
 {c.metamod_version?<tr><td class="normcell"><a href="http\://www.metamod.org" target="_blank">MetaMod</a></td><td class="normcell" align="right">{c.metamod_version}</td></tr>}
 {c.admin_mod_version?<tr><td class="normcell"><a href="http\://www.adminmod.org" target="_blank">AdminMod</a></td><td class="normcell" align="right">{c.admin_mod_version}</td></tr>}
 {c.amx_version?<tr><td class="normcell"><a href="http\://www.amxmod.net" target="_blank">AMXMod</a></td><td class="normcell" align="right">{c.amx_version}</td></tr>}
 {c.amxmodx_version?<tr><td class="normcell"><a href="http\://www.amxmodx.org" target="_blank">AMX Mod X</a></td><td class="normcell" align="right">{c.amxmodx_version}</td></tr>}
 {c.hlg_version?<tr><td class="normcell"><a href="http\://www.thezproject.org" target="_blank">HLGuard</b></a></td>{{{c.hlg_version}&{c.hlg_checkversion}}?<td class="normcell" align="right">{c.hlg_checkversion}</td>:{c.hlg_version?<td class="normcell" align="right">{c.hlg_version}</td>}}</tr>}
 {c.booster_version?<tr><td class="normcell"><a href="http\://koti.mbnet.fi/axh/" target="_blank">HL-Booster</a></td><td class="normcell" align="right">{c.booster_version}</td></tr>}
 {c.chicken_version?<tr><td class="normcell"><a href="http\://www.djeyl.net/forum/index.php?showtopic=39888" target="_blank">ChickenMod</a></td><td class="normcell" align="right">{c.chicken_version}</td></tr>}
 <tr><td class="normcell"><a href="http://www.cortestrike.kit.net" target="_blank">WebMod</a></td>
 <td class="normcell" align="right">0.49BR</td>
 </tr>
 {c.p2_version?<tr><td class="normcell"><a href="http\://www.djeyl.net/p2.php?language=english" target="_blank">P2</a></td><td class="normcell" align="right">{c.p2_version}</td></tr>}
 {c.m4_version?<tr><td class="normcell"><a href="http\://www.djeyl.net/m4.php?language=english" target="_blank">M4</a></td><td class="normcell" align="right">{c.m4_version}</td></tr>}
 {{c.logd_debug!}?<tr><td class="normcell"><a href="http\://logd.sourceforge.net/" target="_blank">LogD</a></td>
 <td class="normcell" align="right">Sim</td>
 </tr>}
 {{c.damp_debug!}?<tr><td class="normcell"><a href="http\://logd.sourceforge.net/damp/" target="_blank">DamageAmp</a></td>
 <td class="normcell" align="right">Sim</td>
 </tr>}
 {c.headshot_version?<tr><td class="normcell"><a href="http\://www.olo.counter-strike.pl" target="_blank">HeadShot</a></td><td class="normcell" align="right">{c.headshot_version}</td></tr>}
 {c.plbot_version?<tr><td class="normcell"><a href="http\://www.olo.counter-strike.pl" target="_blank">PLBot</a></td><td class="normcell" align="right">{c.plbot_version}</td></tr>}
 {c.fakefull_version?<tr><td class="normcell"><a href="http\://www.olo.counter-strike.pl" target="_blank">FakeFull</a></td><td class="normcell" align="right">{c.fakefull_version}</td></tr>}
 {c.statsme_version?<tr><td class="normcell"><a href="http\://www.unitedadmins.com" target="_blank">StatsMe</a></td><td class="normcell" align="right">{c.statsme_version}</td></tr>}
 {c.clanmod_version?<tr><td class="normcell"><a href="http\://www.unitedadmins.com" target="_blank">ClanMod</a></td><td class="normcell" align="right">{c.clanmod_version}</td></tr>}
 {c.laserbeam_version?<tr><td class="normcell"><a href="http\://koti.mbnet.fi/axh/" target="_blank">LaserBeam</a></td><td class="normcell" align="right">{c.laserbeam_version}</td></tr>}
 {c.playername_version?<tr><td class="normcell"><a href="http\://koti.mbnet.fi/axh/" target="_blank">PlayerName</a></td><td class="normcell" align="right">{c.playername_version}</td></tr>}
 {c.scp_version?<tr><td class="normcell"><a href="http\://koti.mbnet.fi/axh/" target="_blank">Spawn & Chat Prot.</a></td><td class="normcell" align="right">{c.scp_version}</td></tr>}
 {c.wrecoil_version?<tr><td class="normcell"><a href="http\://koti.mbnet.fi/axh/" target="_blank">WeaponRecoil</a></td><td class="normcell" align="right">{c.wrecoil_version}</td></tr>}
 {c.axn_version?<tr><td class="normcell"><a href="http\://free.prohosting.com/~deedee/" target="_blank">AXN</a></td><td class="normcell" align="right">{c.axn_version}</td></tr>}
 {c.bmx_version?<tr><td class="normcell"><a href="http\://free.prohosting.com/~deedee/" target="_blank">BMX</a></td><td class="normcell" align="right">{c.bmx_version}</td></tr>}
 {c.wwclconfig_version?<tr><td class="normcell"><a href="http\://www.wwcl.net/index.php?country=gb" target="_blank">WWCLConfig</a></td><td class="normcell" align="right">{c.wwclconfig_version}</td></tr>}
 {c.logmod_version?<tr><td class="normcell"><a href="http\://logmod.hlsw.de/index-en.html" target="_blank">LogMod</a></td><td class="normcell" align="right">{c.logmod_version}</td></tr>}
 {{c.stripper2_log!}?<tr><td class="normcell"><a href="http\://www.planethalflife.com/botman/stripper2.shtml" target="_blank">Stripper2</a></td><td class="normcell" align="right">Yes</td></tr>}
 {{c.monster_log!}?<tr><td class="normcell"><a href="http\://www.planethalflife.com/botman/monster.shtml" target="_blank">Monster</a></td><td class="normcell" align="right">Yes</td></tr>}
 <tr>
   <td class="normcell">Seu IP </td>
   <td class="normcell" align="right">{W.clientip}</td></tr>
 </table>
</td></tr>
</table>
</center>
{<includes/tail.inc}