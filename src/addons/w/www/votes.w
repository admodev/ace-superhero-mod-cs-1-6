{<includes/global.inc}
{<includes/head.inc}
<div align="center">
{{v.authed|v.admin}?
 {W.players?
  {v.found:0}
  {G.votefor?
   {p.votefor:G.votefor:{v.found:1}{G.votefor:{p.votefor}}}
  }
  {v.found?
   {{{{G.votefor}=amx_votemap}|{{G.votefor}=amx_voteban}|{{G.votefor}=amx_votekick}}?
   {P.exec?{@@rcon:{G.votefor} {P.exec}} Voting in progress !}
   <form action="votes.w?votefor={G.votefor}" method="post">
   <table>
   <tr><td>{G.votefor} \:</td></tr><tr><td align="center"><input type="text" name="exec"></td></tr>
   </table>
   <br>
   <input type="submit" value="Ok">
   </form>
   {P.exec?<table cellpadding="5"><tr><td><font size=-2><center><b><u>NOTE</u></b><br>If the map or person does not exist,<br>the vote will <b>not</b> occur.</center></font></td>
   <td><font size=-2><center><b><u>NOTE</u></b><br>The vote will <b>not</b> occur if {c.amx_vote_delay} seconds<br>have not passed since the last vote.</center></font></td></tr></table>}
   :
   You cannot "vote" for that option.<br>
   <br>Please select a proper vote type \:<br>
   <form method="get" action="votes.w">
   <select name="votefor">
   <option value="amx_votekick">Vote Kick</option>
   <option value="amx_voteban">Vote Ban</option>
   <option value="amx_votemap">Vote Map</option>
   </select>
   <input type="submit" value="Ok">
   </form>
   }
  :
   <br>Please select a vote type \:<br>
   <form method="get" action="votes.w">
   <select name="votefor">
   <option value="amx_votekick">Vote Kick</option>
   <option value="amx_voteban">Vote Ban</option>
   <option value="amx_votemap">Vote Map</option>
   </select>
   <input type="submit" value="Ok">
   </form>
  }
 :
  {h.location:/}
 }
:
 {h.location:/auth_admin.w?redir=votes.w}
}
</div>

{<includes/tail.inc}
