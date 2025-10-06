--[[
	Simple Derma GUI Test Script
	
	This is a minimal test to verify basic Derma functionality.
	Run this in console: lua_run_cl include("autorun/client/derma_test_simple.lua")
]]--

print( "=== SIMPLE DERMA TEST ===" )

-- Test 1: Check if vgui exists
if ( vgui ) then
	print( "[✓] vgui library exists" )
else
	print( "[✗] vgui library NOT found!" )
	return
end

-- Test 2: Check if vgui.Create exists
if ( vgui.Create ) then
	print( "[✓] vgui.Create function exists" )
else
	print( "[✗] vgui.Create function NOT found!" )
	return
end

-- Test 3: Try to create a simple panel
local testPanel = vgui.Create( "DPanel" )
if ( IsValid( testPanel ) ) then
	print( "[✓] DPanel created successfully" )
	testPanel:Remove()
else
	print( "[✗] Failed to create DPanel!" )
	return
end

-- Test 4: Try to create a DFrame
local frame = vgui.Create( "DFrame" )
if ( IsValid( frame ) ) then
	print( "[✓] DFrame created successfully" )
	
	frame:SetTitle( "Simple Test" )
	frame:SetSize( 300, 200 )
	frame:Center()
	frame:MakePopup()
	
	local label = vgui.Create( "DLabel", frame )
	label:SetPos( 10, 30 )
	label:SetText( "Derma is working!" )
	label:SizeToContents()
	
	local button = vgui.Create( "DButton", frame )
	button:SetPos( 10, 60 )
	button:SetSize( 100, 30 )
	button:SetText( "Close" )
	button.DoClick = function()
		frame:Close()
		print( "[✓] Button click works!" )
	end
	
	print( "[✓] All Derma tests passed!" )
	print( "=== DERMA TEST COMPLETE ===" )
else
	print( "[✗] Failed to create DFrame!" )
end

