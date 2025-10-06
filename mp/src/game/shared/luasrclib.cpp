//========= Copyright © 1996-2005, Valve Corporation, All rights reserved. ============//
//
// Purpose: Lua Source Library - Bindings for Source Engine
//
//=============================================================================//

#include "cbase.h"
#include "luasrclib.h"

extern "C"
{
	#include "lua.h"
	#include "lualib.h"
	#include "lauxlib.h"
}

// memdbgon must be the last include file in a .cpp file!!!
#include "tier0/memdbgon.h"

//-----------------------------------------------------------------------------
// Basic Lua functions
//-----------------------------------------------------------------------------

static int luasrc_Msg(lua_State *L)
{
	int n = lua_gettop(L);
	for (int i = 1; i <= n; i++)
	{
		if (lua_isstring(L, i))
		{
			Msg("%s", lua_tostring(L, i));
		}
		else
		{
			Msg("(non-string)");
		}
		
		if (i < n)
			Msg("\t");
	}
	Msg("\n");
	return 0;
}

static int luasrc_Warning(lua_State *L)
{
	int n = lua_gettop(L);
	for (int i = 1; i <= n; i++)
	{
		if (lua_isstring(L, i))
		{
			Warning("%s", lua_tostring(L, i));
		}
	}
	Warning("\n");
	return 0;
}

static int luasrc_Error(lua_State *L)
{
	const char *msg = luaL_checkstring(L, 1);
	Error("%s\n", msg);
	return 0;
}

static int luasrc_IsClient(lua_State *L)
{
#ifdef CLIENT_DLL
	lua_pushboolean(L, 1);
#else
	lua_pushboolean(L, 0);
#endif
	return 1;
}

static int luasrc_IsServer(lua_State *L)
{
#ifdef CLIENT_DLL
	lua_pushboolean(L, 0);
#else
	lua_pushboolean(L, 1);
#endif
	return 1;
}

static int luasrc_print(lua_State *L)
{
	int n = lua_gettop(L);
	for (int i = 1; i <= n; i++)
	{
		if (lua_isstring(L, i))
		{
			Msg("%s", lua_tostring(L, i));
		}
		else if (lua_isboolean(L, i))
		{
			Msg("%s", lua_toboolean(L, i) ? "true" : "false");
		}
		else if (lua_isnumber(L, i))
		{
			Msg("%f", lua_tonumber(L, i));
		}
		else if (lua_isnil(L, i))
		{
			Msg("nil");
		}
		else
		{
			Msg("%s", lua_typename(L, lua_type(L, i)));
		}
		
		if (i < n)
			Msg("\t");
	}
	Msg("\n");
	return 0;
}

//-----------------------------------------------------------------------------
// Library registration
//-----------------------------------------------------------------------------

static const luaL_Reg luasrc_funcs[] = {
	{"Msg", luasrc_Msg},
	{"Warning", luasrc_Warning},
	{"Error", luasrc_Error},
	{"IsClient", luasrc_IsClient},
	{"IsServer", luasrc_IsServer},
	{"print", luasrc_print},
	{NULL, NULL}
};

//-----------------------------------------------------------------------------
// Purpose: Initialize Lua Source bindings
//-----------------------------------------------------------------------------
void luasrc_init(lua_State *L)
{
	if (!L)
		return;

	// Register global functions (Lua 5.1 compatible way)
	for (int i = 0; luasrc_funcs[i].name != NULL; i++)
	{
		lua_pushcfunction(L, luasrc_funcs[i].func);
		lua_setglobal(L, luasrc_funcs[i].name);
	}

	// Create stub libraries for GMod compatibility
	// These will prevent "attempt to index global 'X'" errors
	
	// hook library stub
	lua_newtable(L);
	lua_setglobal(L, "hook");
	
	// timer library stub
	lua_newtable(L);
	lua_setglobal(L, "timer");
	
	// vgui library stub
	lua_newtable(L);
	lua_setglobal(L, "vgui");
	
	// concommand library stub
	lua_newtable(L);
	lua_setglobal(L, "concommand");
	
	// surface library stub
	lua_newtable(L);
	lua_setglobal(L, "surface");
	
	// input library stub
	lua_newtable(L);
	lua_setglobal(L, "input");
	
	// file library stub
	lua_newtable(L);
	lua_setglobal(L, "file");
	
	// util library stub
	lua_newtable(L);
	lua_setglobal(L, "util");
	
	// net library stub
	lua_newtable(L);
	lua_setglobal(L, "net");
	
	// ents library stub
	lua_newtable(L);
	lua_setglobal(L, "ents");
	
	// player library stub
	lua_newtable(L);
	lua_setglobal(L, "player");
	
	// team library stub
	lua_newtable(L);
	lua_setglobal(L, "team");
	
	// game library stub
	lua_newtable(L);
	lua_setglobal(L, "game");
	
	// Global stub functions
	lua_pushcfunction(L, [](lua_State *L) -> int {
		// IsValid stub - always return false for now
		lua_pushboolean(L, 0);
		return 1;
	});
	lua_setglobal(L, "IsValid");
	
	lua_pushcfunction(L, [](lua_State *L) -> int {
		// Color stub - return a table
		lua_newtable(L);
		lua_pushnumber(L, luaL_optnumber(L, 1, 255));
		lua_rawseti(L, -2, 1);
		lua_pushnumber(L, luaL_optnumber(L, 2, 255));
		lua_rawseti(L, -2, 2);
		lua_pushnumber(L, luaL_optnumber(L, 3, 255));
		lua_rawseti(L, -2, 3);
		lua_pushnumber(L, luaL_optnumber(L, 4, 255));
		lua_rawseti(L, -2, 4);
		return 1;
	});
	lua_setglobal(L, "Color");

	Msg("Lua Source bindings initialized\n");
}

