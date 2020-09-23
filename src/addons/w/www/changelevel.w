{<includes/global.inc}
{<includes/head.inc}

{v.refreshtimer:10} {##=Time between automatic page refresh, add <span id="timer">{v.refreshtimer}</span>&nbsp; where you want number to show}
{<includes/countdown.inc}

<div align="center">

{{v.admin|v.authed}?
{@@rcon:changelevel {{P.maptype=m}?{P.cyclemap}}{{P.maptype=c}?{P.custommap}}}
New map "<i>{{P.maptype=m}?{P.cyclemap}}{{P.maptype=c}?{P.custommap}}</i>" will now load.<br><br>
Page will reload in <span id="timer">{v.refreshtimer}</span>&nbsp;seconds<br>or click <a href=/>here</a> to go back.<br><br>
<table cellpadding="5"><tr><td><font size=-2><center><b><u>WARNING</u></b></center>You might not see correct values for your cvars, as your<br>{c.servercfgfile} will be loaded at the very end of the changelevel.</font></td>
<td><font size=-2><center><b><u>NOTE</u></b></center>The map will not be changed if it<br>was misspelled or if it does not exist.</font></td></tr></table>
:
{h.location:/auth_admin.w}
}
</div>

{<includes/tail.inc}