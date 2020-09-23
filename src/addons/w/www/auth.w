{<includes/global.inc}
{<includes/head.inc}

<div align="center">

{{G.mode!logout}?{P.rconpass?{@sleep:1}}
{
 {P.rconpass=c.rcon_password}?
                              {C.rconpass:{P.rconpass}}
                              {h.location:{G.redir?{G.redir}:/}}
                             :
<br><br>
	{{C.rconpass=c.rcon_password}?
                              {h.location:{G.redir?{G.redir}:/}}
:
{P.rconpass?<b>Bad password.</b>}

<form action="auth.w?redir={G.redir}" method="post" name="authform">
Please enter your rcon password \:<br><br>
<input type="password" name="rconpass">
<input type="submit" value="Ok">
<input type="hidden" name="setcookiesNULL" value="rconpass">
</form>

}
}
:
{C.rconpass:}
{h.location:/}
}
</div>
{<includes/tail.inc}
