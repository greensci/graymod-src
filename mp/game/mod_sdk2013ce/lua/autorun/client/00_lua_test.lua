-- Simple Lua test script for client
Msg("===============================================\n")
Msg("Hello from CLIENT Lua autorun!\n")
Msg("Lua is working on the client side!\n")

if IsClient() then
	Msg("IsClient() returned true - correct!\n")
else
	Warning("IsClient() returned false - something is wrong!\n")
end

Msg("===============================================\n")

