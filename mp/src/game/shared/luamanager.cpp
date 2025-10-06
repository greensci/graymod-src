//========= Copyright © 1996-2005, Valve Corporation, All rights reserved. ============//
//
// Purpose: Lua Manager - Basic Lua state management
//
//=============================================================================//

#include "cbase.h"
#include "luamanager.h"
#include "filesystem.h"

extern "C"
{
	#include "lua.h"
	#include "lualib.h"
	#include "lauxlib.h"
}

// memdbgon must be the last include file in a .cpp file!!!
#include "tier0/memdbgon.h"

//-----------------------------------------------------------------------------
// Purpose: Load and execute a Lua file
//-----------------------------------------------------------------------------
bool Lua_DoFile(lua_State *L, const char *filename)
{
	if (!L)
		return false;

	char fullPath[MAX_PATH];
	V_snprintf(fullPath, sizeof(fullPath), "%s", filename);

	// Check if file exists
	if (!filesystem->FileExists(fullPath, "MOD"))
	{
		Warning("Lua: File does not exist: %s\n", fullPath);
		return false;
	}

	// Load the file
	if (luaL_dofile(L, fullPath) != 0)
	{
		const char *error = lua_tostring(L, -1);
		Warning("Lua Error in %s: %s\n", fullPath, error);
		lua_pop(L, 1);
		return false;
	}

	return true;
}

//-----------------------------------------------------------------------------
// Purpose: Load all Lua files from a directory pattern
//-----------------------------------------------------------------------------
void Lua_LoadDirectory(lua_State *L, const char *pattern, const char *pathID)
{
	if (!L)
		return;

	FileFindHandle_t findHandle;
	const char *pFilename = filesystem->FindFirstEx(pattern, pathID ? pathID : "MOD", &findHandle);
	
	int filesLoaded = 0;
	while (pFilename)
	{
		if (!filesystem->FindIsDirectory(findHandle))
		{
			// Extract directory from pattern
			char directory[MAX_PATH];
			V_strcpy_safe(directory, pattern);
			char *lastSlash = V_strrchr(directory, '/');
			if (!lastSlash)
				lastSlash = V_strrchr(directory, '\\');
			if (lastSlash)
				*lastSlash = '\0';
			else
				directory[0] = '\0';
			
			// Build full path
			char fullPath[MAX_PATH];
			if (directory[0])
				V_snprintf(fullPath, sizeof(fullPath), "%s/%s", directory, pFilename);
			else
				V_snprintf(fullPath, sizeof(fullPath), "%s", pFilename);
			
			Msg("  Loading: %s\n", fullPath);
			
			// Read file into memory
			FileHandle_t file = filesystem->Open(fullPath, "rb", pathID);
			if (file)
			{
				int fileSize = filesystem->Size(file);
				char *buffer = new char[fileSize + 1];
				filesystem->Read(buffer, fileSize, file);
				buffer[fileSize] = '\0';
				filesystem->Close(file);
				
				// Execute the Lua code
				if (luaL_dostring(L, buffer) != 0)
				{
					const char *error = lua_tostring(L, -1);
					Warning("Lua Error in %s: %s\n", fullPath, error);
					lua_pop(L, 1);
							}
							else
							{
					filesLoaded++;
							}
				
				delete[] buffer;
						}
						else
						{
				Warning("  Failed to open file: %s\n", fullPath);
			}
		}
		
		pFilename = filesystem->FindNext(findHandle);
	}
	
	filesystem->FindClose(findHandle);
	
	if (filesLoaded > 0)
	{
		Msg("  Loaded %d Lua file(s)\n", filesLoaded);
	}
	else
	{
		Msg("  No Lua files found matching pattern: %s\n", pattern);
	}
}
