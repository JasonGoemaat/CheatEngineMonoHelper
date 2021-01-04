
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

loadstring(loadTextFile('monofield.lua'))()
loadstring(loadTextFile('monomethod.lua'))()
loadstring(loadTextFile('monoclass.lua'))()
loadstring(loadTextFile('monoimage.lua'))()

loadstring(loadTextFile('monomenu.lua'))()

loadstring(loadTextFile('formSelectImage.lua'))()
loadstring(loadTextFile('formSearch.lua'))()
loadstring(loadTextFile('formClass.lua'))()
