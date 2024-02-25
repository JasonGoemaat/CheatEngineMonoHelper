-- table script for Dev.CT table

--[[--------------------------------------------------------------------------------
     Dev table script.  Load this into a cheat table in the root directory of this
     repository, or into Dev.CT
--]]

-- only execute once

DevMenu = DevMenu or {}

if DevMenu.miTopMenuItem == nil then
  -- does not exist, create new menu item second from last (before 'Help')
  local mfm=getMainForm().Menu
  DevMenu.miTopMenuItem = createMenuItem(mfm) -- create child
  DevMenu.miTopMenuItem.Caption = "Dev (MonoHelper)"
  mfm.Items.insert(mfm.Items.Count - 1, DevMenu.miTopMenuItem) --add near end before last item ('Help')
else
  -- exists already, clear children to recreate
  DevMenu.miTopMenuItem.clear()
end

local mi -- re-used

mi = createMenuItem(DevMenu.miTopMenuItem)
mi.Caption = "Build and Reload LUA"
mi.OnClick = function()
  local all, forms, lua = loadfile(getMainForm().openDialog1.InitialDir.."Build/build.lua")()
  loadstring(lua)()
  print('Reloaded lua!')
end
mi.Name = 'miDevReloadLua'
DevMenu.miTopMenuItem.Add(mi)
DevMenu.miDevReloadLua = mi

mi = createMenuItem(DevMenu.miTopMenuItem)
mi.Caption = "Build Only"
mi.OnClick = function()
  local all, forms, lua = loadfile(getMainForm().openDialog1.InitialDir.."Build/build.lua")()
  showMessage("Output is in Build/output/monohelper.lua, if you've changed the forms, save each one you changed to 'src/forms' and build again")
end
mi.Name = 'miDevBuildLua'
DevMenu.miTopMenuItem.Add(mi)
DevMenu.miDevBuildLua = mi

-- menu item will build, then copy the file to the CE autorun folder, easy to close and restart CE to see changes
mi = createMenuItem(DevMenu.miTopMenuItem)
mi.Caption = "Build and copy to CE autorun directory"
mi.OnClick = function()
  local all, forms, lua = loadfile(getMainForm().openDialog1.InitialDir.."Build/build.lua")()
  local path = getCheatEngineDir()..[[\autorun\monohelper.lua]]
  local f, err = io.open(path, "w")
  if f == nil then return nil, err end
  f:write(all)
  f:close()
  showMessage("Restart CE to see changes")
end
mi.Name = 'miDevBuildToCEAutorunDirectory'
DevMenu.miTopMenuItem.Add(mi)
DevMenu.miDevBuildAutorunLua = mi

-- menu item will build, then create a new table entry to run the script you
-- can copy to another table
mi = createMenuItem(DevMenu.miTopMenuItem)
mi.Caption = "Build and create table entry"
mi.OnClick = function()
  local all, forms, lua = loadfile(getMainForm().openDialog1.InitialDir.."Build/build.lua")()
  local aa = "[enable]\r\n${lua}\r\nLaunchMonoDataCollector()\r\n"..aa.."\r\n{$asm}\r\n[disable]\r\n"
  local entry = getAddressList().createMemoryRecord()
  entry.setDescription("MonoHelper")
  entry.Type = vtAutoAssembler -- must be set before setting 'Script'
  entry.Script = aa
end
mi.Name = 'miDevBuildToCEAutorunDirectory'
DevMenu.miTopMenuItem.Add(mi)
DevMenu.miDevBuildTableEntry = mi

