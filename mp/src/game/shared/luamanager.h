//========= Copyright © 1996-2005, Valve Corporation, All rights reserved. ============//
//
// Purpose: Lua Manager - Basic Lua state management
//
//=============================================================================//

#ifndef LUAMANAGER_H
#define LUAMANAGER_H
#ifdef _WIN32
#pragma once
#endif

struct lua_State;

// Load and execute a Lua file
bool Lua_DoFile(lua_State *L, const char *filename);

// Load all Lua files from a directory pattern
void Lua_LoadDirectory(lua_State *L, const char *pattern, const char *pathID = NULL);

#endif // LUAMANAGER_H
