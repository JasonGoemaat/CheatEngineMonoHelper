------------------------------------------------------------------------[[
Top-level menu support

------------------------------------------------------------------------]]

mono.menu = mono.menu or {
  top = nil, -- top-level menu item
  selectImage = nil, -- 'Select Image' for mono only
  search = nil, -- 'Search' for mono only
  notes = nil, -- 'Notes'
}

mono.setup = mono.setup or {
  _oldOnOpenProcess = nil, -- for our handler to call when process opened
  _checkedProcessId = nil, -- so we only check a process once for mono dlls
  _hasMono = false, -- will check when menu clicked if mono is available for a new process
}

function mono.createMainFormMenu()
  local mfm = createMenuItem(getMainForm().Menu)
  if mfm == nil then
    print('Cannot find main menu!')
    return
  end
  
  if not mono.menu.top then
    mono.menu.top = createMenuItem(mfm)
    mono.menu.top.Caption = translate("Ext")
    mono.menu.top.OnClick = function(sender) mono.menu.clickTop(sender) end
  end
  
end

function mono.menu.clickTop(sender)
  -- enable mono items if mono is available
  -- for that, we keep track of open process id and if it was checked,
  -- if the process id changes, we need to check for mono features again
  local pid = getOpenedProcessID()
  if pid ~= mono.setup.f_checkedPID then
  end
end

mono.createMainFormMenu()

