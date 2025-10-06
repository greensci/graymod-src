# Derma GUI Test Scripts

This directory contains test scripts to verify that the Derma GUI system has been successfully ported to GrayMod.

## Test Files

### 1. `autorun/client/derma_test.lua` (Automatic Test)
This script automatically creates a test window when you load a map.

**Features:**
- Automatically opens on map load
- Tests DFrame, DLabel, DButton, DScrollPanel
- Tests Derma_Message and Derma_Query dialogs
- Includes multiple interactive buttons
- Console command: `derma_test` to manually open window

**Expected Result:**
- A window titled "GrayMod Derma Test" appears 2 seconds after map load
- Window can be dragged, resized, and closed
- Buttons respond to clicks
- Dialogs appear when buttons are clicked

### 2. `autorun/client/derma_test_simple.lua` (Manual Test)
A minimal test script that performs basic checks and creates a simple window.

**How to Run:**
```
lua_run_cl include("autorun/client/derma_test_simple.lua")
```

**Expected Output:**
```
=== SIMPLE DERMA TEST ===
[✓] vgui library exists
[✓] vgui.Create function exists
[✓] DPanel created successfully
[✓] DFrame created successfully
[✓] All Derma tests passed!
=== DERMA TEST COMPLETE ===
```

## Prerequisites

Before these tests will work, ensure your C++ engine has implemented:

### Required Lua Bindings:

#### VGUI Functions:
- `vgui.Create( classname, parent, name )`
- `vgui.Register( classname, table, base )`
- `vgui.GetControlTable( classname )`
- Panel metatable with methods:
  - `SetPos()`, `SetSize()`, `GetPos()`, `GetSize()`
  - `SetTitle()`, `SetText()`
  - `SetParent()`, `GetParent()`
  - `MakePopup()`, `Center()`
  - `SetDraggable()`, `SetSizable()`
  - `Remove()`, `Close()`
  - `IsValid()` global function

#### Surface Functions:
- `surface.CreateFont( name, fontData )`
- `surface.SetDrawColor( r, g, b, a )`
- `surface.DrawRect( x, y, w, h )`
- `surface.SetMaterial( material )`
- `surface.DrawTexturedRect( x, y, w, h )`

#### Material Functions:
- `Material( path )`
- GWEN texture functions:
  - `GWEN.CreateTextureBorder()`
  - `GWEN.CreateTextureNormal()`

#### Input Functions:
- `input.IsMouseDown( button )`
- `input.IsKeyDown( key )`
- `input.IsShiftDown()`, `input.IsControlDown()`
- `gui.MouseX()`, `gui.MouseY()`

#### Other Functions:
- `hook.Add( event, name, func )`
- `hook.Run( event, ... )`
- `timer.Simple( delay, func )` (for automatic test)
- `concommand.Add( name, func )`
- `print()`, `Msg()`
- `Color( r, g, b, a )`
- `IsValid( entity )`

### Required Lua Files (Already Copied):
- ✅ derma/init.lua
- ✅ derma/derma.lua
- ✅ derma/derma_animation.lua
- ✅ derma/derma_utils.lua
- ✅ derma/derma_menus.lua
- ✅ skins/default.lua
- ✅ vgui/dpanel.lua
- ✅ vgui/dbutton.lua
- ✅ vgui/dlabel.lua
- ✅ vgui/dframe.lua
- ✅ vgui/dscrollpanel.lua
- ✅ vgui/dvscrollbar.lua
- ✅ vgui/dhscrollbar.lua
- ✅ vgui/dscrollbargrip.lua
- ✅ includes/vgui_base.lua
- ✅ includes/extensions/client/panel.lua
- ✅ includes/extensions/client/panel/animation.lua
- ✅ includes/extensions/client/panel/dragdrop.lua
- ✅ includes/extensions/client/panel/scriptedpanels.lua
- ✅ includes/modules/draw.lua
- ✅ includes/modules/list.lua
- ✅ includes/modules/hook.lua
- ✅ includes/modules/baseclass.lua
- ✅ includes/extensions/table.lua
- ✅ includes/extensions/string.lua
- ✅ includes/extensions/math.lua

## Troubleshooting

### Window doesn't appear automatically
1. Check console for error messages
2. Make sure `InitPostEntity` hook is implemented
3. Try manual command: `derma_test`
4. Try the simple test: `lua_run_cl include("autorun/client/derma_test_simple.lua")`

### Lua errors appear
1. Check that all required Lua files are present
2. Verify C++ bindings are implemented
3. Check console output for which function is missing
4. Run the simple test to see which specific component fails

### Window appears but doesn't work
- If window appears but can't drag: Check mouse input handling
- If buttons don't work: Check `OnMousePressed`/`OnMouseReleased` events
- If window is invisible: Check `Paint` functions and surface drawing
- If text doesn't show: Check font creation and `surface.DrawText()`

### Common Errors and Solutions

**Error:** `attempt to index global 'vgui' (a nil value)`
- **Solution:** VGUI library not initialized in Lua VM

**Error:** `attempt to call method 'Create' (a nil value)`
- **Solution:** vgui.Create not bound to Lua

**Error:** `bad argument #1 to 'Create' (invalid class)`
- **Solution:** VGUI panels not registered, check vgui_base.lua is loaded

**Error:** `attempt to call field 'MakePopup' (a nil value)`
- **Solution:** Panel metatable methods not implemented in C++

## Success Criteria

✅ **Test Passes If:**
- Window appears on screen
- Window has title bar and close button
- Window can be dragged around
- Window can be resized (if sizable)
- Labels display text correctly
- Buttons respond to clicks
- Console shows success messages
- No Lua errors in console

## Next Steps After Tests Pass

1. Add more VGUI controls (DTextEntry, DComboBox, etc.)
2. Test drag-and-drop functionality
3. Test animations
4. Implement spawnmenu system
5. Add tool gun and C menu

