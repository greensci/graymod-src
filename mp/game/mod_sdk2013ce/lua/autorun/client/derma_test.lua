--[[
	Derma GUI Test Script
	
	This script creates a simple test window to verify that the Derma GUI system
	is working correctly in GrayMod.
	
	The window will appear when you load a map.
]]--

print( "Loading Derma Test Script..." )

-- Function to create and show the test window
local function CreateTestWindow()
	
	print( "Creating Derma Test Window..." )
	
	-- Create the main frame
	local frame = vgui.Create( "DFrame" )
	frame:SetTitle( "GrayMod Derma Test" )
	frame:SetSize( 400, 300 )
	frame:Center()
	frame:SetDraggable( true )
	frame:SetSizable( true )
	frame:ShowCloseButton( true )
	frame:MakePopup() -- Make it capture keyboard/mouse input
	
	-- Add a label with instructions
	local label = vgui.Create( "DLabel", frame )
	label:SetPos( 20, 40 )
	label:SetSize( 360, 20 )
	label:SetText( "Derma GUI System is Working!" )
	label:SetFont( "DermaLarge" )
	label:SetTextColor( Color( 255, 255, 255 ) )
	
	-- Add a description label
	local descLabel = vgui.Create( "DLabel", frame )
	descLabel:SetPos( 20, 80 )
	descLabel:SetSize( 360, 60 )
	descLabel:SetText( "This window confirms that the Derma GUI base system\nhas been successfully ported to GrayMod.\n\nYou can drag this window and close it." )
	descLabel:SetTextColor( Color( 200, 200, 200 ) )
	descLabel:SetWrap( true )
	descLabel:SetAutoStretchVertical( true )
	
	-- Add a test button
	local button = vgui.Create( "DButton", frame )
	button:SetPos( 20, 160 )
	button:SetSize( 150, 30 )
	button:SetText( "Click Me!" )
	button.DoClick = function()
		print( "Button clicked!" )
		
		-- Show a message dialog
		Derma_Message( 
			"Button test successful!\nDerma controls are responding to input.",
			"Success!",
			"OK"
		)
	end
	
	-- Add a second button to create another window
	local button2 = vgui.Create( "DButton", frame )
	button2:SetPos( 180, 160 )
	button2:SetSize( 200, 30 )
	button2:SetText( "Open Another Window" )
	button2.DoClick = function()
		Derma_Query(
			"Do you want to create another test window?",
			"Create Window?",
			"Yes", function() CreateTestWindow() end,
			"No", function() print( "User cancelled" ) end
		)
	end
	
	-- Add a close button at the bottom
	local closeBtn = vgui.Create( "DButton", frame )
	closeBtn:SetPos( 20, 260 )
	closeBtn:SetSize( 360, 30 )
	closeBtn:SetText( "Close Window" )
	closeBtn.DoClick = function()
		frame:Close()
	end
	
	-- Add a scrollable panel to test scroll controls
	local scroll = vgui.Create( "DScrollPanel", frame )
	scroll:SetPos( 20, 200 )
	scroll:SetSize( 360, 50 )
	
	local scrollLabel = vgui.Create( "DLabel", scroll )
	scrollLabel:SetPos( 0, 0 )
	scrollLabel:SetSize( 340, 100 )
	scrollLabel:SetText( "This is a scrollable panel.\nYou can add lots of content here and it will scroll.\nTry scrolling this text!" )
	scrollLabel:SetWrap( true )
	scrollLabel:SetAutoStretchVertical( true )
	
	print( "Derma Test Window Created Successfully!" )
	
	return frame
end

-- Hook into map initialization
-- This will run when a map is fully loaded
hook.Add( "InitPostEntity", "DermaTestWindow", function()
	
	print( "Map loaded - Creating test window in 2 seconds..." )
	
	-- Delay the window creation slightly to ensure everything is ready
	timer.Simple( 2, function()
		CreateTestWindow()
	end )
	
end )

-- Also add a console command to manually create the window
concommand.Add( "derma_test", function()
	CreateTestWindow()
end )

print( "Derma Test Script Loaded! Window will appear when map loads." )
print( "You can also type 'derma_test' in console to manually create the window." )

