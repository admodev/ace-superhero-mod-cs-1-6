{<includes/global.inc}
{<includes/head.inc}

<div align="center">
{{v.authed|v.admin}?
{P.message?
	{@@rcon:webmod_publicsay "{P.message}"}
	Message sent!<br><br>
	Message sent was\:<br>
	<i>{P.message}</i>
}
{W.players?
	<form action=message_all.w method=post name=message>
	Public Message\: <input type="text" name="message" size="20"> 
	<input type="submit" value="OK">
	</form>
:
	{h.location:/}
}
:
 {h.location:/auth_admin.w?redir=message_all.w}
}
</div>

{<includes/tail.inc}
