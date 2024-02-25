
-- moduled
mono = mono or {}

-- classes
mono.MonoClass = mono.MonoClass or {}
mono.MonoField = mono.MonoField or {}
mono.MonoMethod = mono.MonoMethod or {}
mono.MonoImage = mono.MonoImage or {}

mono.menu = mono.menu or {}

mono.popups = mono.popups or {}

mono.formSelectImage = mono.formSelectImage or {}
mono.formSearch = mono.formSearch or {}
mono.formClass = mono.formClass or {}

-- defines
mono.TYPE_NAMES = {
  [0] = 'END',
  [1] = 'void',
  [2] = 'bool',
  [3] = 'char',
  [4] = 'sbyte',
  [5] = 'byte',
  [6] = 'short',
  [7] = 'ushort',
  [8]= 'int',
  [9]= 'uint',
  [10] = 'long',
  [11] = 'ulong',
  [12] = 'float',
  [13] = 'double',
  [14] = 'string',
  [15] = 'ptr',
  [16] = 'byref',
  [17] = 'valuetype',
  [18] = 'class',
  [19] = 'var',
  [20] = 'array',
  [21] = 'genericinst',
  [22] = 'typedbyref',
  [24] = 'I',
  [25] = 'U',
  [0x1b] = 'FNPTR',
  [0x1c] = 'object',
  [0x1d] = 'szarray', -- 0-based one-dim-array
  [0x1e] = 'mvar',
  [0x1f] = 'CMOD_REQD', -- typedef or typeref token
  [0x20] = 'CMOD_OPT',  -- optional arg: typedef or typeref token
  [0x21] = 'INTERNAL',
  [0x40] = 'MODIFIER', -- Or with the following types
  [0x41] = 'SENTINEL', -- sentinel for varargs method signature
  [0x45] = 'PINNED', -- local var that points to pinned object
  [0x55] = 'ENUM', -- an enumeration
}

mono.reset = function()
  -- close any open forms
  if formMonoClass ~= nil then 
    formMonoClass.close()
    formMonoClass:destroy()
  end
  if formMonoImage ~= nil then
    formMonoImage.close()
    formMonoImage:destroy()
  end
  if formMonoSearch ~= nil then
    formMonoSearch.close()
    formMonoSearch:destroy()
  end

  -- unselect image, refs won't be correct if re-ran
  if mono then
    mono.selectedImage = nil
    if mono.timer then mono.clearTimer() end
  end
end

mono.clearTimer = function()
  if mono.timer then
    mono.timer.enabled = false
    mono.timer = nil
  end
end

-- if mono.hookedOnProcessOpened ~= nil then
--   MainForm.OnOnProcessOpened  = mono.hookedOnProcessOpened
--   mono.hookedOnProcessOpened = nil
-- else
--   mono.hookedOnProcessOpened = MainForm.OnProcessOpened
-- end

-- MainForm.OnProcessOpened = function()
--   if mono.hookedOnProcessOpened ~= nil then 
--   mono.reset()
-- end


[[-- #INCLUDEFILE(src/lua/mono/monofield.lua) ]]
[[-- #INCLUDEFILE(src/lua/mono/monomethod.lua) ]]
[[-- #INCLUDEFILE(src/lua/mono/monoclass.lua) ]]
[[-- #INCLUDEFILE(src/lua/mono/monoimage.lua) ]]

[[-- #INCLUDEFILE(src/lua/monomenu.lua) ]]

[[-- #INCLUDEFILE(src/lua/generators/index.lua) ]]

[[-- #INCLUDEFILE(src/lua/forms/formSelectImage.lua) ]]
[[-- #INCLUDEFILE(src/lua/forms/formSearch.lua) ]]
[[-- #INCLUDEFILE(src/lua/forms/formClass.lua) ]]
