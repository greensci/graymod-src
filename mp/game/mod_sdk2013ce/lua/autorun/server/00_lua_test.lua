-- Simple Lua test script for server
Msg("===============================================\n")
Msg("Hello from SERVER Lua autorun!\n")
Msg("Lua is working on the server side!\n")

if IsServer() then
	Msg("IsServer() returned true - correct!\n")
else
	Warning("IsServer() returned false - something is wrong!\n")
end

Msg("===============================================\n")

