{<includes/global.inc}
{<includes/head.inc}
{{G.nopass=ask}?
:
{v.refreshtimer:2} {##=Time between automatic page refresh, add <span id="timer">{v.refreshtimer}</span>&nbsp; where you want number to show}
{<includes/countdown.inc}
}
<div align="center">

{{v.admin|v.authed}?


{{G.timelimit}?
{@@rcon:mp_timelimit {G.timelimit}}
Time limit changed to {G.timelimit} minutes !<br><br>
}

{{G.turnff=on}?
{@@rcon:mp_friendlyfire 1}
Friendly-fire is now ON !<br><br>
}
{{G.turnff=off}?
{@@rcon:mp_friendlyfire 0}
Friendly-fire is now OFF !<br><br>
}

{{G.nopass=yes}?
{@@rcon:sv_password ""}
Password removed !<br><br>
}

{{P.setpass}?
{@@rcon:sv_password "{P.setpass}"}
Password set !<br><br>
}

{{G.nopass=ask}?
Are you sure you want to remove the password?<br>
<a href="changecvar.w?nopass=yes">Yes</a> &nbsp; &nbsp; &nbsp; &nbsp;<a href="/">No</a><br><br>
}

{{G.nopass=ask}?:Redirect occurs is <span id="timer">{v.refreshtimer}</span>&nbsp;seconds<br>or click <a href=/>here</a> to go back.}
:
{h.location:/auth_admin.w}
}

</div>

{<includes/tail.inc}