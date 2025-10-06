-- Working Lua Test Script
-- This demonstrates what currently works in GrayMod Lua

print("===============================================")
print("GrayMod Lua - Working Features Test")
print("===============================================")

-- Test 1: Basic Lua
print("\n[TEST 1] Basic Lua functionality:")
local testTable = {1, 2, 3, "hello", "world"}
print("  Table created with", #testTable, "elements")

-- Test 2: Math
print("\n[TEST 2] Math operations:")
print("  2 + 2 =", 2 + 2)
print("  10 * 5 =", 10 * 5)
print("  math.sqrt(16) =", math.sqrt(16))

-- Test 3: String operations
print("\n[TEST 3] String operations:")
local str = "GrayMod"
print("  String:", str)
print("  Length:", string.len(str))
print("  Uppercase:", string.upper(str))

-- Test 4: Functions
print("\n[TEST 4] Custom functions:")
local function greet(name)
	return "Hello, " .. name .. "!"
end
print(" ", greet("Player"))

-- Test 5: Side detection
print("\n[TEST 5] Client/Server detection:")
if IsClient() then
	print("  Running on: CLIENT")
else
	print("  Running on: SERVER")
end

-- Test 6: Available libraries
print("\n[TEST 6] Available Lua libraries:")
print("  hook:", type(hook))
print("  timer:", type(timer))
print("  vgui:", type(vgui))
print("  concommand:", type(concommand))

-- Test 7: Color function
print("\n[TEST 7] Color function:")
local col = Color(255, 128, 0, 255)
print("  Color created:", col[1], col[2], col[3], col[4])

print("\n===============================================")
print("Note: Most libraries are stubs and don't have")
print("functions yet. They will be implemented later.")
print("===============================================\n")

