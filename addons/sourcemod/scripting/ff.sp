/*
 * Copyright (C) 2022  Mikusch
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <dhooks>
#include <tf2_stocks>

#define TF_DMG_CUSTOM_NONE	0

// m_lifeState values
#define LIFE_ALIVE				0 // alive
#define LIFE_DYING				1 // playing death animation or still falling off of a ledge waiting to hit ground
#define LIFE_DEAD				2 // dead. lying still.
#define LIFE_RESPAWNABLE		3
#define LIFE_DISCARDBODY		4

#include "ff/methodmaps/Entity.sp"
#include "ff/methodmaps/Player.sp"

#include "ff/dhooks.sp"
#include "ff/sdkcalls.sp"
#include "ff/sdkhooks.sp"
#include "ff/stocks.sp"

public void OnPluginStart()
{
	GameData gamedata = new GameData("ff");
	if (gamedata == null)
		SetFailState("Could not find ff gamedata");
	
	// Initialize everything based on gamedata
	DHooks_Initialize(gamedata);
	SDKCalls_Initialize(gamedata);
	delete gamedata;
	
	Entity.InitializePropertyList();
	
	for (int client = 1; client <= MaxClients; client++)
	{
		if (IsClientInGame(client))
			OnClientConnected(client);
	}
}

public void OnClientConnected(int client)
{
	DHooks_OnClientConnected(client);
}

public void OnEntityCreated(int entity, const char[] classname)
{
	Entity.Create(entity);
	
	DHooks_OnEntityCreated(entity, classname);
	SDKHooks_OnEntityCreated(entity, classname);
}

public void OnEntityDestroyed(int entity)
{
	Entity(entity).Destroy();
}
