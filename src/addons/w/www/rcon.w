{<includes/global.inc}
{<includes/head.inc}

<div align="center">

{v.authed?
	{P.command?
		Successfully sent the command to server console !<br><i>{P.command}</i>
		{@@rcon:{P.command}}
	}
<form action="rcon.w" method="post" name="rconform">
Please enter a command \:<br><br>
<input type="text" name="command">
<input type="submit" value="Ok">
</form>
<font size=-2><b><u>WARNING</u></b><br>You will not get any reply from the server for this command<br>due to the way this feature is implemented into Webmod.</font>
:
{h.location:/auth.w?redir=rcon.w}
}

</div>

{<includes/tail.inc}
