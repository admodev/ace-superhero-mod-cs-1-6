{<includes/global.inc}
{<includes/head.inc}

<div align="center">
{{v.authed|v.admin}?
 {W.players?
  {v.found:0}
  {G.uid?
   {@player:p.uid=G.uid:{v.found:1}{v.pname:{p.name}}{v.pip:{p.ip}}}
   {v.found?:<b>Player not found</b> !<br>}
  }
  {v.found?
   {P.exec?{@@rcon:webmod_privatesay "{v.pname}" "{P.exec}"} Message Sent!}
   <form action="player_message.w?uid={G.uid}" method="post">
   <table>
   <tr><td>Send a private message to {v.pname}\:</td></tr><tr><td align="center"><input type="text" name="exec"></td></tr>
   </table>
   <br>
   <input type="submit" value="Ok">
   </form>
   <a href="message_all.w">Send a public message</a>
  :
   <br>Please select a player \:<br>
   <form method="get" action="player_message.w">
   <select name="uid">
   {L.p:<option value="{p.uid}">{p.name}</option>}
   </select>
   <input type="submit" value="Ok">
   </form>
   <a href="message_all.w">Send a public message</a>
  }
 :
  {h.location:/}
 }
:
 {h.location:/auth_admin.w?redir=player_message.w}
}
</div>

{<includes/tail.inc}
