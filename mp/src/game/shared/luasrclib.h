//========= Copyright © 1996-2005, Valve Corporation, All rights reserved. ============//
//
// Purpose: Lua Source Library - Bindings for Source Engine
//
//=============================================================================//

#ifndef LUASRCLIB_H
#define LUASRCLIB_H
#ifdef _WIN32
#pragma once
#endif

struct lua_State;

// Initialize Lua Source bindings
void luasrc_init(lua_State *L);

#endif // LUASRCLIB_H
