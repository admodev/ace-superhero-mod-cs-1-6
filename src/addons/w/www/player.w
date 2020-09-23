{<includes/global.inc}
{<includes/head.inc}

<div align="center">
{v.authed?
 {W.players?
  {v.found:0}
  {G.uid?
   {@player:p.uid=G.uid:{v.found:1}{v.pname:{p.name}}{v.pip:{p.ip}}}
   {v.found?:<b>Player not found</b> !<br>}
  }
  {v.found?
   {P.exec?{@@execclient:{G.uid}:{P.exec}}}
   {P.ban?
    {v.bantime:{P.tempban?{{P.bantime>0}?{P.bantime}:0}:0}}
    {{P.bantype=ip}?
     {@@rcon:addip {v.bantime} {v.pip}}
    :
     {@@rcon:banid {v.bantime} #{G.uid}}
    }
   }
   {P.kick?{@@rcon:kick #{G.uid}}{h.location:player.w}}
   <form action="player.w?uid={G.uid}" method="post">
   Admin player \: <b>{v.pname}</b><br><br>
   <table border="0">
   <tr><td><input type="checkbox" name="kick" style="border-style\: none;"></td><td colspan="2">kick</td></tr>
   <tr><td><input type="checkbox" name="ban" style="border-style\: none;"></td><td>ban \:</td><td><div align="right">
     <select name="bantype">
     <option value="authid">AuthID</option>
     <option value="ip">IP</option>
     </select>
   </div></td></tr>
   <tr><td><input type="checkbox" name="tempban" style="border-style\: none;"></td><td>tempban (minutes) \:</td><td><div align="right">
     <input type="text" name="bantime" size="5">
   </div></td></tr>
   </table>
   <br><br>
   <table>
   <tr><td>Send to {v.pname}'s console \:</td><td><input type="text" name="exec"></td></tr>
   </table>
   <br>
   <input type="submit" value="Ok">
   </form>
  :
   <br>Please select a player \:<br>
   <form method="get" action="player.w">
   <select name="uid">
   {L.p:<option value="{p.uid}">{p.name}</option>}
   </select>
   <input type="submit" value="Ok">
   </form>
  }
 :
  {h.location:/}
 }
:
 {h.location:/auth.w?redir=player.w}
}
</div>

{<includes/tail.inc}
