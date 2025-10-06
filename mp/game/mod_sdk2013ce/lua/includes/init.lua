--[[
	GrayMod Lua Initialization
	
	This file is loaded when Lua starts up.
	It loads all the base libraries and extensions needed for the system.
]]--

print("========================================")
print("  Loading GrayMod Lua System...")
print("========================================")

-- Determine if we're client or server
CLIENT = CLIENT or false
SERVER = SERVER or false

if CLIENT then
	print("[Lua] Running on CLIENT")
elseif SERVER then
	print("[Lua] Running on SERVER")
else
	print("[Lua] Running in MENU state")
end

-- Load core extensions
print("[Lua] Loading core extensions...")
if file.Exists("lua/includes/extensions/table.lua", "GAME") then
	include("includes/extensions/table.lua")
	print("  ✓ Table extensions loaded")
end

if file.Exists("lua/includes/extensions/string.lua", "GAME") then
	include("includes/extensions/string.lua")
	print("  ✓ String extensions loaded")
end

if file.Exists("lua/includes/extensions/math.lua", "GAME") then
	include("includes/extensions/math.lua")
	print("  ✓ Math extensions loaded")
end

-- Load core modules
print("[Lua] Loading core modules...")

-- Hook system is essential
if file.Exists("lua/includes/modules/hook.lua", "GAME") then
	require("hook")
	print("  ✓ Hook system loaded")
end

-- List system
if file.Exists("lua/includes/modules/list.lua", "GAME") then
	require("list")
	print("  ✓ List system loaded")
end

-- Baseclass system
if file.Exists("lua/includes/modules/baseclass.lua", "GAME") then
	require("baseclass")
	print("  ✓ Baseclass system loaded")
end

-- Client-specific initialization
if CLIENT then
	print("[Lua] Loading client-side modules...")
	
	-- Drawing library
	if file.Exists("lua/includes/modules/draw.lua", "GAME") then
		require("draw")
		print("  ✓ Draw library loaded")
	end
	
	-- Control panel system (for tools)
	if file.Exists("lua/includes/modules/controlpanel.lua", "GAME") then
		require("controlpanel")
		print("  ✓ Control panel loaded")
	end
	
	-- Load Derma GUI system
	print("[Lua] Initializing Derma GUI system...")
	if file.Exists("lua/derma/init.lua", "GAME") then
		include("derma/init.lua")
		print("  ✓ Derma initialized")
		
		-- Load base VGUI controls
		if file.Exists("lua/includes/vgui_base.lua", "GAME") then
			include("includes/vgui_base.lua")
			print("  ✓ VGUI base loaded")
		end
	else
		print("  ✗ WARNING: Derma system not found!")
	end
end

-- Server-specific initialization
if SERVER then
	print("[Lua] Loading server-side modules...")
	
	-- Undo system
	if file.Exists("lua/includes/modules/undo.lua", "GAME") then
		require("undo")
		print("  ✓ Undo system loaded")
	end
	
	-- Cleanup system
	if file.Exists("lua/includes/modules/cleanup.lua", "GAME") then
		require("cleanup")
		print("  ✓ Cleanup system loaded")
	end
end

print("========================================")
print("  GrayMod Lua System Ready!")
print("========================================")

-- Create global gamemode table if it doesn't exist
_GAMEMODE = _GAMEMODE or {}

-- Create global enum table for enumerations
_E = _E or {}

print("[Lua] Initialization complete!")

