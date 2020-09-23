/* AMX Mod X
*   Slots Reservation Plugin
*
* by the AMX Mod X Development Team
*  originally developed by OLO
*
* This file is part of AMX Mod X.
*
*
*  This program is free software; you can redistribute it and/or modify it
*  under the terms of the GNU General Public License as published by the
*  Free Software Foundation; either version 2 of the License, or (at
*  your option) any later version.
*
*  This program is distributed in the hope that it will be useful, but
*  WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
*  General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program; if not, write to the Free Software Foundation,
*  Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*
*  In addition, as a special exception, the author gives permission to
*  link the code of this program with the Half-Life Game Engine ("HL
*  Engine") and Modified Game Libraries ("MODs") developed by Valve,
*  L.L.C ("Valve"). You must obey the GNU General Public License in all
*  respects for all of the code used other than the HL Engine and MODs
*  from Valve. If you modify this file, you may extend this exception
*  to your version of the file, but you are not obligated to do so. If
*  you do not wish to do so, delete this exception statement from your
*  version.
*/

#include <amxmodx>
#include <amxmisc>

// Comment if you don't want to hide not used reserved slots
#define HIDE_RESERVED_SLOTS

new g_cmdLoopback[16]

public plugin_init()
{
	register_plugin("Slots Reservation", AMXX_VERSION_STR, "AMXX Dev Team")
	register_dictionary("adminslots.txt")
	register_dictionary("common.txt")
	register_cvar("amx_reservation", "1")
	
	format(g_cmdLoopback, 15, "amxres%c%c%c%c", random_num('A', 'Z'), random_num('A', 'Z'), random_num('A', 'Z'), random_num('A', 'Z'))
	register_clcmd(g_cmdLoopback, "ackSignal")

#if defined HIDE_RESERVED_SLOTS
	new maxplayers = get_maxplayers()
	new players = get_playersnum(1)
	new limit = maxplayers - get_cvar_num("amx_reservation")
	setVisibleSlots(players, maxplayers, limit)
#endif
}

public ackSignal(id)
{
	new lReason[64]
	format(lReason, 63, "%L", id, "DROPPED_RES")
	server_cmd("kick #%d ^"%s^"", get_user_userid(id), lReason)
}

public client_authorized(id)
{
	new maxplayers = get_maxplayers()
	new players = get_playersnum(1)
	new limit = maxplayers - get_cvar_num("amx_reservation")

	if (access(id, ADMIN_RESERVATION) || (players <= limit))
	{
#if defined HIDE_RESERVED_SLOTS
		setVisibleSlots(players, maxplayers, limit)
#endif
		return PLUGIN_CONTINUE
	}
	
	client_cmd(id, g_cmdLoopback)

	return PLUGIN_HANDLED
}

#if defined HIDE_RESERVED_SLOTS
public client_disconnect(id)
{
	new maxplayers = get_maxplayers()
	
	setVisibleSlots(get_playersnum(1) - 1, maxplayers, maxplayers - get_cvar_num("amx_reservation"))
	return PLUGIN_CONTINUE
}

setVisibleSlots(players, maxplayers, limit)
{
	new num = players + 1

	if (players == maxplayers)
		num = maxplayers
	else if (players < limit)
		num = limit
	
	set_cvar_num("sv_visiblemaxplayers", num)
}
#endif