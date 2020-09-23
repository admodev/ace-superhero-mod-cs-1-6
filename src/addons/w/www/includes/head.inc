<html>
<head>
<title>{c.hostname} - .: Configuração do Servidor :.</title>
<LINK Rel="StyleSheet" type="text/css" href="style.css">
</head>
<body>
<table border="0" style="border-width: 0px;" width="100%" height="100%" cellpadding="0" cellspacing="0"><tr><td valign="top">
<div class="w-title-big" align="center">.: Configuração do Servidor :.<br>
  <font size=2>{c.hostname}</font></div>
<div align="right"><b>.:</b> [ <a href="/">Home</a> <b>:</b> {{v.admin|v.authed}?{W.players?<a href="player_message.w">Messaging</a> <b>\:</b> <a href="votes.w">Votes</a> <b>\:</b>:Messaging <b>\:</b> Votes <b>\:</b>}} {v.authed?{W.players?<a href="player.w">Players</a> <b>\:</b>:Players <b>\:</b>} <a href="rcon.w">Rcon</a> <b>\:</b> <a href="config.w">Config</a> <b>\:</b> <a href="auth.w?mode=logout">Rcon Logout</a> <b>\:</b> :<a href="auth.w">Rcon Login</a> <b>\:</b> }{v.admin?<a href="auth_admin.w?mode=logout">Admin Logout</a>:<a href="auth_admin.w">Admin Login</a>} ] <b>:.</b></div>
<br>
