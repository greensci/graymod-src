# Lua C++ Integration Guide for GrayMod

This document explains the Lua C++ files that have been ported from Srcbox_2025 and how to integrate them into your build system.

## Files Copied

### Core Lua Files

#### Public Headers (`mp/src/public/`)
- ✅ `lua.h` - Main Lua C API header
- ✅ `lualib.h` - Lua standard libraries header  
- ✅ `luaconf.h` - Lua configuration header

#### Shared Game Code (`mp/src/game/shared/`)

**Core Lua Manager:**
- ✅ `luamanager.cpp` - Main Lua state management and initialization
- ✅ `luamanager.h` - Lua manager header with macros for hooks/methods
- ✅ `luacachefile.cpp` - Lua bytecode caching system
- ✅ `luacachefile.h` - Cache file header
- ✅ `luasrclib.h` - Lua library registration declarations

**Lua Bindings for Source Engine Classes:**

These files provide Lua bindings for various Source Engine C++ classes:

- ✅ `lbasecombatweapon_shared.cpp/h` - CBaseCombatWeapon Lua bindings
- ✅ `lbaseentity_shared.cpp/h` - CBaseEntity Lua bindings  
- ✅ `lbaseplayer_shared.cpp/h` - CBasePlayer Lua bindings
- ✅ `lbspflags.cpp` - BSP flags enum bindings
- ✅ `leffect_dispatch_data.cpp/h` - CEffectData Lua bindings
- ✅ `lhl2mp_player_shared.cpp/h` - CHL2MP_Player Lua bindings
- ✅ `limovehelper.cpp/h` - IMoveHelper Lua bindings
- ✅ `lin_buttons.cpp` - IN_* button enum bindings
- ✅ `lipredictionsystem.cpp` - IPredictionSystem Lua bindings
- ✅ `lshareddefs.cpp/h` - Shared definitions and enums for Lua
- ✅ `lsrcinit.cpp` - Lua Source library initialization
- ✅ `ltakedamageinfo.cpp/h` - CTakeDamageInfo Lua bindings
- ✅ `lutil_shared.cpp` - Shared utility functions for Lua

#### Client-Side Scripted Controls (`mp/src/game/client/scripted_controls/`)
- ✅ `scriptedclientluapanel.cpp` - Scripted VGUI panel implementation
- ✅ `scriptedclientluapanel.h` - Scripted panel header

## Lua Library Dependencies

You will need to link against LuaJIT or Lua 5.1. The headers reference:

```cpp
#include "lua.hpp"  // This should include lua.h, lualib.h, and lauxlib.h
```

### Recommended: LuaJIT

LuaJIT is recommended for performance. You'll need:

1. **LuaJIT Library Files:**
   - Windows: `lua51.lib` / `lua51.dll`
   - Linux: `libluajit-5.1.a` or `libluajit-5.1.so`

2. **LuaJIT Include Directory:**
   Add to your include paths:
   - `luajit-2.0/` or `luajit-2.1/`

### Alternative: Vanilla Lua 5.1

If using standard Lua 5.1:
- `liblua.a` or `lua5.1.lib`
- Include directory with `lua.h`, `lualib.h`, `lauxlib.h`

## Build System Integration

### VPC (Valve Project Creator) Integration

Add to your `client.vpc` and `server.vpc`:

```vpc
$Configuration
{
	$Compiler
	{
		$AdditionalIncludeDirectories	"$BASE;$SRCDIR\public;$SRCDIR\public\luajit-2.1"
		$PreprocessorDefinitions		"$BASE;LUA_ENABLED"
	}
	
	$Linker
	{
		// Windows
		$AdditionalDependencies			"$BASE lua51.lib" [$WINDOWS]
		
		// Linux
		$AdditionalDependencies			"$BASE -lluajit-5.1" [$LINUX]
	}
}

$Project
{
	$Folder	"Source Files"
	{
		$Folder	"Lua"
		{
			$File	"$SRCDIR\game\shared\luamanager.cpp"
			$File	"$SRCDIR\game\shared\luacachefile.cpp"
			$File	"$SRCDIR\game\shared\lbasecombatweapon_shared.cpp"
			$File	"$SRCDIR\game\shared\lbaseentity_shared.cpp"
			$File	"$SRCDIR\game\shared\lbaseplayer_shared.cpp"
			$File	"$SRCDIR\game\shared\lbspflags.cpp"
			$File	"$SRCDIR\game\shared\leffect_dispatch_data.cpp"
			$File	"$SRCDIR\game\shared\lhl2mp_player_shared.cpp"
			$File	"$SRCDIR\game\shared\limovehelper.cpp"
			$File	"$SRCDIR\game\shared\lin_buttons.cpp"
			$File	"$SRCDIR\game\shared\lipredictionsystem.cpp"
			$File	"$SRCDIR\game\shared\lshareddefs.cpp"
			$File	"$SRCDIR\game\shared\lsrcinit.cpp"
			$File	"$SRCDIR\game\shared\ltakedamageinfo.cpp"
			$File	"$SRCDIR\game\shared\lutil_shared.cpp"
		}
	}
	
	$Folder	"Header Files"
	{
		$Folder	"Lua"
		{
			$File	"$SRCDIR\game\shared\luamanager.h"
			$File	"$SRCDIR\game\shared\luacachefile.h"
			$File	"$SRCDIR\game\shared\luasrclib.h"
			$File	"$SRCDIR\game\shared\lbasecombatweapon_shared.h"
			$File	"$SRCDIR\game\shared\lbaseentity_shared.h"
			$File	"$SRCDIR\game\shared\lbaseplayer_shared.h"
			$File	"$SRCDIR\game\shared\leffect_dispatch_data.h"
			$File	"$SRCDIR\game\shared\lhl2mp_player_shared.h"
			$File	"$SRCDIR\game\shared\limovehelper.h"
			$File	"$SRCDIR\game\shared\lshareddefs.h"
			$File	"$SRCDIR\game\shared\ltakedamageinfo.h"
			$File	"$SRCDIR\public\lua.h"
			$File	"$SRCDIR\public\lualib.h"
			$File	"$SRCDIR\public\luaconf.h"
		}
	}
}
```

For client-specific files, add to `client.vpc`:

```vpc
$File	"$SRCDIR\game\client\scripted_controls\scriptedclientluapanel.cpp"
$File	"$SRCDIR\game\client\scripted_controls\scriptedclientluapanel.h"
```

## Code Integration Steps

### 1. Initialize Lua in Your Game

In your game initialization code (client and server), add:

```cpp
#include "luamanager.h"

// In your game init function
void CMyGame::Init()
{
	// Initialize Lua
	L = luaL_newstate();
	luaL_openlibs(L);
	
	// Register Source engine libraries
	luasrc_init(L);
	
	// Load init scripts
	luasrc_dofile(L, "lua/includes/init.lua");
}

void CMyGame::Shutdown()
{
	// Clean up Lua
	if (L)
	{
		lua_close(L);
		L = NULL;
	}
}
```

### 2. Key Macros in luamanager.h

The header provides useful macros for calling Lua code:

**Call a Lua Hook:**
```cpp
BEGIN_LUA_CALL_HOOK("PlayerSpawn")
	lua_pushplayer(L, pPlayer);
END_LUA_CALL_HOOK(1, 0)
```

**Call a Weapon Method:**
```cpp
BEGIN_LUA_CALL_WEAPON_METHOD("PrimaryAttack")
	// Add arguments here
END_LUA_CALL_WEAPON_METHOD(0, 0)
```

### 3. Lua Paths Configuration

The system uses these predefined paths (from `luamanager.h`):

```cpp
#define LUA_ROOT                "lua"
#define LUA_PATH_CACHE          "lua_cache"
#define LUA_PATH_ADDONS         "addons"
#define LUA_PATH_ENUM           LUA_ROOT "\\includes\\enum"
#define LUA_PATH_EXTENSIONS     LUA_ROOT "\\includes\\extensions"
#define LUA_PATH_MODULES        LUA_ROOT "\\includes\\modules"
#define LUA_PATH_INCLUDES       LUA_ROOT "\\includes"
#define LUA_PATH_ENTITIES       LUA_ROOT "\\entities"
#define LUA_PATH_WEAPONS        LUA_ROOT "\\weapons"
```

### 4. Register VGUI Panel for Lua

In your VGUI initialization:

```cpp
#include "scripted_controls/scriptedclientluapanel.h"

// Register the scripted panel type
DECLARE_BUILD_FACTORY( CScriptedClientLuaPanel );
```

## Lua File Structure

Your game directory should have this Lua structure:

```
mod_*/
└── lua/
    ├── autorun/
    │   ├── client/
    │   │   └── derma_test.lua  (Already created!)
    │   └── server/
    ├── includes/
    │   ├── init.lua
    │   ├── enum/
    │   ├── extensions/
    │   │   ├── table.lua
    │   │   ├── string.lua
    │   │   └── math.lua
    │   └── modules/
    │       ├── hook.lua
    │       ├── list.lua
    │       └── draw.lua
    ├── derma/
    │   └── (Already populated!)
    ├── vgui/
    │   └── (Already populated!)
    ├── entities/
    ├── weapons/
    └── gameui/
```

## Testing Lua Integration

After building, test with console commands:

```
// Server
lua_run print("Server Lua works!")

// Client  
lua_run_cl print("Client Lua works!")

// Load a file
lua_dofile lua/test.lua

// Create a test panel (should work with Derma files already copied!)
lua_run_cl local frame = vgui.Create("DFrame"); frame:SetTitle("Test"); frame:SetSize(300,200); frame:Center(); frame:MakePopup()
```

## Key Classes and Their Lua Bindings

| C++ Class | Lua Binding File | Lua Table Name |
|-----------|-----------------|----------------|
| CBaseEntity | lbaseentity_shared.cpp | CBaseEntity |
| CBasePlayer | lbaseplayer_shared.cpp | CBasePlayer |
| CBaseCombatWeapon | lbasecombatweapon_shared.cpp | CBaseCombatWeapon |
| CHL2MP_Player | lhl2mp_player_shared.cpp | CHL2MP_Player |
| CTakeDamageInfo | ltakedamageinfo.cpp | CTakeDamageInfo |
| CEffectData | leffect_dispatch_data.cpp | CEffectData |
| IMoveHelper | limovehelper.cpp | IMoveHelper |

## Common Issues

### 1. Undefined Reference to `lua_*` functions
**Solution:** Make sure you're linking against `lua51.lib` or `libluajit-5.1.a`

### 2. Cannot find `lua.h`
**Solution:** Add LuaJIT include directory to your compiler include paths

### 3. `luasrc_*` functions not found
**Solution:** Include `luamanager.h` and make sure `lsrcinit.cpp` is compiled

### 4. Lua scripts not loading
**Solution:** Check that `LUA_ROOT` path exists in your game directory and contains the Lua files

### 5. VGUI panels not working
**Solution:** Ensure you've loaded the Derma system files (already in `lua/derma/` and `lua/vgui/`)

## Next Steps

1. ✅ Build your project with the new Lua files
2. ✅ Link against LuaJIT library
3. ✅ Initialize Lua in your game code
4. ✅ Test with the Derma test script (`derma_test` console command)
5. ⬜ Implement additional Lua bindings as needed
6. ⬜ Port spawnmenu, tool gun, and other Lua-based systems

## Additional Resources

- **LuaJIT:** https://luajit.org/
- **Lua 5.1 Reference:** https://www.lua.org/manual/5.1/
- **Garry's Mod Wiki (for Lua API reference):** https://wiki.facepunch.com/gmod/

## File Summary

**Total Files Copied:**
- 3 header files (public/)
- 3 core Lua manager files (shared/)
- 24 Lua binding files (shared/)
- 2 scripted panel files (client/)
- **Total: 32 C++ files**

These files provide the foundation for full Lua scripting support in GrayMod, compatible with Garry's Mod's Lua API.

