{<includes/global.inc}
{<includes/head.inc}

<div align="center">

{{G.mode!logout}?{P.admin?{@sleep:1}}
{
 {P.admin=c.webmod_adminpass}?
                              {C.admin:{P.admin}}
                              {h.location:{G.redir?{G.redir}:/}}
                             :
<br><br>
	{{C.admin=c.webmod_adminpass}?
                              {h.location:{G.redir?{G.redir}:/}}
:
{P.admin?<b>Bad Password.</b>}

<form action="auth_admin.w?redir={G.redir}" method="post" name="authform">
Please enter your admin password \:<br><br>
<input type="password" name="admin">
<input type="submit" value="Ok">
<input type="hidden" name="setcookiesNULL" value="admin"><br>
<br>If you are an administrator,<br>contact <b><a href="mailto\:{c.sv_contact}">{c.sv_contact}</a></b> for information.
</form>
}
}
:
{C.admin:}
{h.location:/}
}
</div>
{<includes/tail.inc}
