--[[
    Form for viewing a class
    
    Controls:
      listFields: TCEListView
      listMethods: TCEListView
      miSortFieldsByOffset - if Checked, sort by offset, otherwise by name
      miShowInherited - if Checked, add in methods and fields of parent(s)
      miShowUsage - if Checked, funcs and methods will be on other classes that use the type
      
      miFindFields - When clicked, find fields in all classes that have this class as a type
      miFindMethodCode - When clicked, find methods in all classes that have this class as a type
      
      
    Standard Mode:
      listFields (can sort by name (default) or offset)
        Offset
        Type
        Name
        Class - class it is defined on, blank if not inherited
      listMethods (sorted by name)
        Name
        Signature (return type, parameter types and names)
        Class - class it is defined on, blank if not inherited
      
    Usage Mode:
      listFields (sorted by Class then Name)
        Offset
        Type
        Class
--]]

local sortByClassThenName = function(a, b)
  if a.isConst and not b.isConst then return true end
  if b.isConst and not a.isConst then return false end
  if a.isConst and b.isConst then return a.constValue < b.constValue end
  if a.class.lowerName < b.class.lowerName then return true end
  if b.class.lowerName < a.class.lowerName then return false end
  return a.name < b.name
end

local sortByClassThenOffset = function(a, b)
  if a.isConst and not b.isConst then return true end
  if b.isConst and not a.isConst then return false end
  if a.isConst and b.isConst then return a.constValue < b.constValue end
  if a.class.lowerName < b.class.lowerName then return true end
  if b.class.lowerName < a.class.lowerName then return false end
  return a.offset < b.offset
end

local sortByName = function(a, b)
  if a.isConst and not b.isConst then return true end
  if b.isConst and not a.isConst then return false end
  if a.isConst and b.isConst then return a.constValue < b.constValue end
  return a.lowerName < b.lowerName
end

local sortByOffset = function(a, b)
  if a.isConst and not b.isConst then return true end
  if b.isConst and not a.isConst then return false end
  if a.isConst and b.isConst then return a.constValue < b.constValue end
  return a.offset < b.offset
end


--[[
    Show the search form, mono.selectedImage should be set to the
    image to search.
--]]
function mono.formClass:show(class, field, method)
  if mono.selectedImage == nil or class == nil then return end
  self.image = mono.selectedImage
  self.class = class
  
  -- function to update lists, for setting on menu items that
  -- make other changes
  local funcUpdate = function(sender) self:setFieldsAndMethods() end
  
  formMonoClass.listFields.OnData = function(sender, listitem)
    self:listFields_OnData(sender, listitem)
  end
  
  formMonoClass.listFields.OnDblClick = function(sender)
    self:listFields_OnDblClick(sender)
  end

  formMonoClass.listMethods.OnData = function(sender, listitem)
    self:listMethods_OnData(sender, listitem)
  end

  formMonoClass.listMethods.OnDblClick = function(sender)
    self:listMethods_OnDblClick(sender)
  end

  formMonoClass.miSortFieldsByOffset.OnClick = funcUpdate
  formMonoClass.miShowInherited.OnClick = funcUpdate
  formMonoClass.miShowUsage.OnClick = funcUpdate
  
  -- create our own lists of fields and methods that we can sort
  -- and filter
  self:setFieldsAndMethods()
  
  -- show form
  formMonoClass.show()

  if field then
    formMonoClass.pageMain.ActivePage = formMonoClass.tabFields
    for i = 1,#self.fields do
      if field.id == self.fields[i].id then
        formMonoClass.listFields.ItemIndex = i - 1
        formMonoClass.listFields.setFocus()
        break
      end
    end
  end

  if method then
    formMonoClass.pageMain.ActivePage = formMonoClass.tabMethods
    -- formMonoClass.listMethods.Selected
    -- listMethods.ItemIndex is 0 based, self.methods is 1 based
    for i = 1,#self.methods do
      if method.id == self.methods[i].id then
        formMonoClass.listMethods.ItemIndex = i - 1
        formMonoClass.listMethods.setFocus()
        break
      end
    end
  end
end

--[[
    Set fields and methods arrays, sorted appropriately and
    with extra fields, including possibly parent fields and methods
--]]
function mono.formClass:setFieldsAndMethods()
  local other = ''
  if formMonoClass.miShowUsage.Checked then other = ' (usage by other classes)' end

  formMonoClass.labelClassName.Caption = string.format('Mono Class: %s:%s%s', self.class.namespace, self.class.name, other)
  local fields = {}
  local methods = {}
  if formMonoClass.miShowUsage.Checked then
    ---------- show where class is used in other classes
    for i,class in ipairs(self.image.classes) do
      for j,method in ipairs(class.methods) do
        local found = false
        if method.returnType == self.class.name then
          found = true
        else
          for k,p in ipairs(method.parameters) do
            if p.typeName == self.class.name then found = true end
          end
        end
        if found then table.insert(methods, method) end
      end
      
      for j,field in ipairs(class.fields) do
        if field.typeName == self.class.name then table.insert(fields, field) end
      end
    end
  else
    ---------- basic class fields and methods
    local c = self.class
    
    while c ~= nil do
      for i,field in ipairs(c.fields) do
        table.insert(fields, field)
      end
      
      for i,method in ipairs(c.methods) do
        table.insert(methods, method)
      end
      
      if formMonoClass.miShowInherited.Checked then
        c = c.parent
      else
        c = nil
      end
    end
  end


  if formMonoClass.miSortByClassFirst.Checked then
    table.sort(fields, formMonoClass.miSortFieldsByOffset.Checked and sortByClassThenOffset or sortByClassThenName)
    table.sort(methods, sortByClassThenName)
  else
    table.sort(fields, formMonoClass.miSortFieldsByOffset.Checked and sortByOffset or sortByName)
    table.sort(methods, sortByName)
  end

  self.fields = fields
  self.methods = methods
  formMonoClass.listFields.Items.Count = 0
  formMonoClass.listFields.Items.Count = #fields
  formMonoClass.listMethods.Items.Count = 0
  formMonoClass.listMethods.Items.Count = #methods
end

-- handler to display fields in list view
function mono.formClass:listFields_OnData(sender, listitem)
  -- columns are offset (or 'STATIC'), Type, Name
  local index = listitem.Index + 1
  local field = self.fields[index]
  
  -- columns are Offset, Type, Name
  if field.isStatic then
    if field.isConst then
      listitem.Caption = 'Const:'..string.format('%2X', field.constValue or 0)
    else
      listitem.Caption = 'Static:'..string.format('%2X', field.offset or 0)
    end
  else
    listitem.Caption = string.format('%02X', field.offset or 0)
  end
  local className = ''
  if field.class.name ~= self.class.name then className = field.class.name end
  listitem.SubItems.text = table.concat({field.typeName or '??', field.name, className}, '\n')
end

-- handler to display methods in list view
function mono.formClass:listMethods_OnData(sender, listitem)
  local method = self.methods[listitem.Index + 1]
  if method == nil then
    listitem.Caption = 'nil index '..tostring(listitem.Index + 1)
  else
    listitem.Caption = method.name
    
    local className = ''
    if method.class.name ~= self.class.name then className = method.class.name end
    
    local ps = {}
    for i,p in ipairs(method.parameters) do
      table.insert(ps, string.format('%s %s', p.type, p.name))
    end
    local parms = method.returnType..' ('..table.concat(ps, ', ')..')'
   
    --print('className, method.class.name', className, method.class.name)
    listitem.SubItems.text = table.concat({ parms, className }, '\n')
  end
end

local getParameter = function(index, monoParam)
  local param = { index = index }
  if monoParam ~= nil then
    param.name = monoParam.name
    param.type = monoParam.type
  end
end

local parameters = { 'RCX', 'RDX', 'R8', 'R9', '[RBP+30]', '[RBP+38]', '[RBP+40]', '[RBP+48]', '[RBP+50]', '[RBP+58]', '[RBP+60]', '[RBP+68]', '[RBP+70]', '[RBP+78]' }
local floatParameters = { 'XMM0', 'XMM1', 'XMM2', 'XMM3', '[RBP+30]', '[RBP+38]', '[RBP+40]', '[RBP+48]', '[RBP+50]', '[RBP+58]', '[RBP+60]', '[RBP+68]', '[RBP+70]', '[RBP+78]' }

local parameters32 = { '[ebp+08]', '[ebp+0c]', '[ebp+10]', '[ebp+14]', '[ebp+18]', '[ebp+1c]', '[ebp+20]', '[ebp+24]', '[ebp+28]', '[ebp+2c]', '[ebp+30]', '[ebp+34]', '[ebp+38]', '[ebp+3c]' }

local addMenuItem = function(popup, name, caption, func)
  local mi = createMenuItem(popup.Items)
  mi.Name = name
  mi.Caption = caption
  mi.OnClick = func
  popup.Items.add(mi)
end

--[[
Popup for methods
]]
function mono.formClass:popupMethods_OnPopup(popup)
  local popup = formMonoClass.popupMethods
  popup.Items:clear()

  local method = self:getSelectedMethod()
  if method == nil then return end

  addMenuItem(popup, "miMethodsHook", "Hook", mono.formClass.methodHook)
  addMenuItem(popup, "miMethodsHookEntry", "Hook (Table Entry)", mono.formClass.methodHookEntry)
  addMenuItem(popup, "methodHookEntryOverridden", "Hook (Table Entry, Overridden)", mono.formClass.methodHookEntryOverridden)
  addMenuItem(popup, "miMethodsDisassemble", "Disassemble", mono.formClass.methodDisassemble)
  addMenuItem(popup, "miMethodsCreateTableScript", "Create Debug Entry", mono.formClass.methodCreateTableScript)
end

formMonoClass.popupMethods.OnPopup = function(sender) mono.formClass:popupMethods_OnPopup(sender) end

mono.formClass.methodHookEntryOverridden = function()
  mono.formClass.methodHook(1, 1)
end

mono.formClass.methodHookEntry = function()
  mono.formClass.methodHook(1)
end

local methodHook64 = function(entry_flag, override_flag)
  local self = mono.formClass
  local method = self:getSelectedMethod()
  if method == nil then
    print("No method selected!")
    return
  end

  local address = mono_compile_method(method.id)
  local hookInfo = hookAt(address)
  -- have aobString, hookString, returnString, instructions
  --[[ how to get method signature
  local ps = {}
  for i,p in ipairs(method.parameters) do
    table.insert(ps, string.format('%s %s', p.type, p.name))
  end
  local parms = method.returnType..' ('..table.concat(ps, ', ')..')'
  ]]

  local lines = {}
  
  if override_flag then
    local signature = mono_method_getSignature(method.id)
    table.insert(lines, '{$lua}')
    table.insert(lines, 'if syntaxcheck then return "define(hook,0)" end')
    table.insert(lines, 'local class_id = mono_findClass("'..method.class.namespace..'", "'..method.class.name..'")')
    table.insert(lines, 'local methods = mono_class_enumMethods(class_id)')
    table.insert(lines, 'for i = 1,#methods do')
    table.insert(lines, '  local m = methods[i]')
    table.insert(lines, '  if m.name == "'..method.name..'" and mono_method_getSignature(m.method) == "'..signature..'" then')
    table.insert(lines, '    local address = mono_compile_method(m.method)')
    table.insert(lines, '    return string.format("define(hook,%x)",address)')
    table.insert(lines, '  end')
    table.insert(lines, 'end')
    table.insert(lines, 'return nil, "COULD NOT FIND METHOD WITH SIGNATURE"')
    table.insert(lines, '{$asm}')
    --[[ This works in Underminer
    if syntaxcheck then return "define(hook,0)" end
    local class_id = mono_findClass("", "Inventory")
    local methods = mono_class_enumMethods(class_id)
    for i = 1,#methods do
      local m = methods[i]
      print(m.name.." signature: "..mono_method_getSignature(m.method))
      if m.name == "TryRemoveItem" and mono_method_getSignature(m.method) == "Item,int" then
        local address = mono_compile_method(m.method)
        return string.format("define(hook,%x)",address)
      end
    end
    return nil, "COULD NOT FIND METHOD WITH SIGNATURE"
    ]]
  else
    table.insert(lines, "define(hook,"..hookInfo.hookString..")")
  end
  table.insert(lines, "define(bytes,"..hookInfo.aobString..")")
  table.insert(lines, "")
  table.insert(lines, "[enable]")
  table.insert(lines, "")
  table.insert(lines, "assert(hook, bytes)")
  table.insert(lines, "alloc(newmem,$1000, hook)")
  table.insert(lines, "{")


  -- note: per x64 calling convention, RCX might actually be space for
  -- a pre-allocated structure for the return value and other parameters
  -- might be moved one further down the list
  table.insert(lines, "  RCX: "..method.class.name.." (this)")
  for i,p in ipairs(method.parameters) do
    local param = parameters[i + 1]
    if (p.type == "single" or p.type == "double" or p.type == "System.Single" or p.type == "System.Double") then param = floatParameters[i + 1] end
    table.insert(lines, "  "..param..": "..tostring(p.type).." "..tostring(p.name))
  end
  table.insert(lines, "")

  if (method.returnType == "single" or method.returnType == "double" or method.returnType == "System.Single" or method.returnType == "System.Double") then
    table.insert(lines, "  Returns XMM0 ("..method.returnType..")")
  else
    table.insert(lines, "  Returns RAX ("..method.returnType..")")
  end
  table.insert(lines, "}")
  table.insert(lines, "")
  table.insert(lines, "newmem:")
  table.insert(lines, "  // original code")
  for i,c in ipairs(hookInfo.instructions) do
    table.insert(lines, "  "..c)
  end
  table.insert(lines, "  jmp hook+"..string.format("%X", hookInfo.returnOffset))
  table.insert(lines, "")
  table.insert(lines, "hook:")
  table.insert(lines, "  jmp long newmem")
  table.insert(lines, "")
  table.insert(lines, "[disable]")
  table.insert(lines, "")
  table.insert(lines, "hook:")
  table.insert(lines, "  db bytes")
  table.insert(lines, "")
  table.insert(lines, "dealloc(newmem)")

  local t = {}
  for i,v in ipairs(lines) do
    table.insert(t, v);
    table.insert(t, "\r\n")
  end

  local aa = table.concat(t)

  if (entry_flag) then
    -- create table entry with hook code named after address
    local entry = getAddressList().createMemoryRecord()
    entry.setDescription("HOOK: "..method.class.name.."."..method.name)
    entry.Type = vtAutoAssembler -- must be set before setting 'Script'
    entry.Script = aa
    entry.Options = '[moHideChildren]'
    getAddressList().SelectedRecord = entry -- select new entry
    getAddressList().doValueChange() -- open editor
  else
    -- open up AA window with hook code
    getMemoryViewForm().AutoInject1.DoClick()
    
    for i=0,getFormCount()-1 do --this is sorted from z-level. 0 is top
      local f=getForm(i)

      if getForm(i).ClassName == 'TfrmAutoInject' then
        f.assemblescreen.Lines.Text = aa
        break
      end
    end
  end
end

local methodHook32 = function(entry_flag, override_flag)
  local self = mono.formClass
  local method = self:getSelectedMethod()
  if method == nil then
    print("No method selected!")
    return
  end

  local address = mono_compile_method(method.id)
  local hookInfo = hookAt(address)
  -- have aobString, hookString, returnString, instructions
  --[[ how to get method signature
  local ps = {}
  for i,p in ipairs(method.parameters) do
    table.insert(ps, string.format('%s %s', p.type, p.name))
  end
  local parms = method.returnType..' ('..table.concat(ps, ', ')..')'
  ]]

  local lines = {}
  
  if override_flag then
    local signature = mono_method_getSignature(method.id)
    table.insert(lines, '{$lua}')
    table.insert(lines, 'if syntaxcheck then return "define(hook,0)" end')
    table.insert(lines, 'local class_id = mono_findClass("'..method.class.namespace..'", "'..method.class.name..'")')
    table.insert(lines, 'local methods = mono_class_enumMethods(class_id)')
    table.insert(lines, 'for i = 1,#methods do')
    table.insert(lines, '  local m = methods[i]')
    table.insert(lines, '  if m.name == "'..method.name..'" and mono_method_getSignature(m.method) == "'..signature..'" then')
    table.insert(lines, '    local address = mono_compile_method(m.method)')
    table.insert(lines, '    return string.format("define(hook,%x)",address)')
    table.insert(lines, '  end')
    table.insert(lines, 'end')
    table.insert(lines, 'return nil, "COULD NOT FIND METHOD WITH SIGNATURE"')
    table.insert(lines, '{$asm}')
    --[[ This works in Underminer
    if syntaxcheck then return "define(hook,0)" end
    local class_id = mono_findClass("", "Inventory")
    local methods = mono_class_enumMethods(class_id)
    for i = 1,#methods do
      local m = methods[i]
      print(m.name.." signature: "..mono_method_getSignature(m.method))
      if m.name == "TryRemoveItem" and mono_method_getSignature(m.method) == "Item,int" then
        local address = mono_compile_method(m.method)
        return string.format("define(hook,%x)",address)
      end
    end
    return nil, "COULD NOT FIND METHOD WITH SIGNATURE"
    ]]
  else
    table.insert(lines, "define(hook,"..hookInfo.hookString..")")
  end
  table.insert(lines, "define(bytes,"..hookInfo.aobString..")")
  table.insert(lines, "")
  table.insert(lines, "[enable]")
  table.insert(lines, "")
  table.insert(lines, "assert(hook, bytes)")
  table.insert(lines, "alloc(newmem,$1000, hook)")
  table.insert(lines, "{")


  -- note: per x64 calling convention, RCX might actually be space for
  -- a pre-allocated structure for the return value and other parameters
  -- might be moved one further down the list
  table.insert(lines, "  [ebp+08]: "..method.class.name.." (this)")
  for i,p in ipairs(method.parameters) do
    local param = parameters32[i + 1]
    table.insert(lines, "  "..param..": "..tostring(p.type).." "..tostring(p.name))
  end
  table.insert(lines, "")

  if (method.returnType == "single" or method.returnType == "double" or method.returnType == "System.Single" or method.returnType == "System.Double") then
    table.insert(lines, "  Returns XMM0 ("..method.returnType..")")
  else
    table.insert(lines, "  Returns EAX ("..method.returnType..")")
  end
  table.insert(lines, "}")
  table.insert(lines, "")
  table.insert(lines, "newmem:")
  table.insert(lines, "  // original code")
  for i,c in ipairs(hookInfo.instructions) do
    table.insert(lines, "  "..c)
  end
  table.insert(lines, "  jmp hook+"..string.format("%X", hookInfo.returnOffset))
  table.insert(lines, "")
  table.insert(lines, "hook:")
  table.insert(lines, "  jmp long newmem")
  table.insert(lines, "")
  table.insert(lines, "[disable]")
  table.insert(lines, "")
  table.insert(lines, "hook:")
  table.insert(lines, "  db bytes")
  table.insert(lines, "")
  table.insert(lines, "dealloc(newmem)")

  local t = {}
  for i,v in ipairs(lines) do
    table.insert(t, v);
    table.insert(t, "\r\n")
  end

  local aa = table.concat(t)

  if (entry_flag) then
    -- create table entry with hook code named after address
    local entry = getAddressList().createMemoryRecord()
    entry.setDescription("HOOK: "..method.class.name.."."..method.name)
    entry.Type = vtAutoAssembler -- must be set before setting 'Script'
    entry.Script = aa
    entry.Options = '[moHideChildren]'
    getAddressList().SelectedRecord = entry -- select new entry
    getAddressList().doValueChange() -- open editor
  else
    -- open up AA window with hook code
    getMemoryViewForm().AutoInject1.DoClick()
    
    for i=0,getFormCount()-1 do --this is sorted from z-level. 0 is top
      local f=getForm(i)

      if getForm(i).ClassName == 'TfrmAutoInject' then
        f.assemblescreen.Lines.Text = aa
        break
      end
    end
  end
end

mono.formClass.methodHook = function(entry_flag, override_flag)
  if targetIs64Bit() then
    methodHook64(entry_flag, override_flag)
  else
    methodHook32(entry_flag, override_flag)
  end
end

mono.formClass.methodDisassemble = function()
  local self = mono.formClass
  local method = self:getSelectedMethod()
  if method == nil then
    print("No method selected!")
    return
  end

  local address = mono_compile_method(method.id)
  getMemoryViewForm().DisassemblerView.SelectedAddress = address
  getMemoryViewForm().show()
end

--[[
--------------------------------------------------------------------------------
-- Currently working on
--------------------------------------------------------------------------------
]]

local createTableScript64 = function()
  local self = mono.formClass
  local method = self:getSelectedMethod()
  if method == nil then
    print("No method selected!")
    return
  end

  local address = mono_compile_method(method.id)
  local hookInfo = hookAt(address)
  local pointerLabel = "p"..method.class.name.."_"..method.name

  local lines = {}
  table.insert(lines, "define(hook,"..hookInfo.hookString..")")
  table.insert(lines, "define(bytes,"..hookInfo.aobString..")")
  table.insert(lines, "")
  table.insert(lines, "[enable]")
  table.insert(lines, "")
  table.insert(lines, "assert(hook, bytes)")
  table.insert(lines, "alloc(newmem,$1000, hook)")
  table.insert(lines, "label("..pointerLabel..")")
  table.insert(lines, "")
  table.insert(lines, "{")


  -- note: per x64 calling convention, RCX might actually be space for
  -- a pre-allocated structure for the return value and other parameters
  -- might be moved one further down the list
  table.insert(lines, "  RCX: "..method.class.name.." (this)")
  for i,p in ipairs(method.parameters) do
    local param = parameters[i + 1]
    if (p.type == "single" or p.type == "double" or p.type == "System.Single" or p.type == "System.Double") then param = floatParameters[i + 1] end
    table.insert(lines, "  "..param..": "..tostring(p.type).." "..tostring(p.name))
  end
  table.insert(lines, "")

  table.insert(lines, "  Returns (RAX) "..method.returnType)
  table.insert(lines, "}")
  table.insert(lines, "")
  table.insert(lines, "newmem:")

  table.insert(lines, "  // increment counter, store instance and parameters (could be off for static method?)")
  table.insert(lines, "  push rbp")
  table.insert(lines, "  mov rbp,rsp")
  table.insert(lines, "  push rax")
  table.insert(lines, "  mov ["..pointerLabel.."], rcx")
  table.insert(lines, "  inc dword ptr ["..pointerLabel.."+8]")
  local parameterOffset = 0x10
  for i,p in ipairs(method.parameters) do
    local param = parameters[i + 1]
    if i < 4 then
      -- windows 64 ABI: first 3 parameters (plus 'this' in rcx) are in registers
      if (p.type == "single" or p.type == "double" or p.type == "System.Single" or p.type == "System.Double") then
        table.insert(lines, "  movss ["..pointerLabel.."+"..string.format("%x", parameterOffset).."], "..floatParameters[i + 1].."  // "..p.name)
      else
        table.insert(lines, "  mov ["..pointerLabel.."+"..string.format("%x", parameterOffset).."], "..parameters[i + 1].."  // "..p.name)
      end
    else
      -- doesn't really matter if it's float or not, we use [ebp+XX] as source and RAX as temp register to copy value
      table.insert(lines, "  mov rax,[rbp+"..string.format("%x", parameterOffset + 0x08).."]  // "..p.name)
      table.insert(lines, "  mov ["..pointerLabel.."+"..string.format("%x", parameterOffset).."], rax")
    end
    parameterOffset = parameterOffset + 8
  end
  table.insert(lines, "  pop rax")
  table.insert(lines, "  pop rbp")
  table.insert(lines, "")

  table.insert(lines, "  // original code")
  for i,c in ipairs(hookInfo.instructions) do
    table.insert(lines, "  "..c)
  end
  table.insert(lines, "  jmp hook+"..string.format("%X", hookInfo.returnOffset))
  table.insert(lines, "")
  table.insert(lines, "align 10")
  table.insert(lines, pointerLabel..":")
  table.insert(lines, "  dq 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0")
  table.insert(lines, "")

  table.insert(lines, "hook:")
  table.insert(lines, "  jmp newmem")
  table.insert(lines, "")
  table.insert(lines, "registersymbol("..pointerLabel..")")
  table.insert(lines, "")
  table.insert(lines, "[disable]")
  table.insert(lines, "")
  table.insert(lines, "hook:")
  table.insert(lines, "  db bytes")
  table.insert(lines, "")
  table.insert(lines, "unregistersymbol("..pointerLabel..")")
  table.insert(lines, "")
  table.insert(lines, "dealloc(newmem)")

  local t = {}
  for i,v in ipairs(lines) do
    table.insert(t, v);
    table.insert(t, "\r\n")
  end

  local aa = table.concat(t)

  local parent = getAddressList().createMemoryRecord()
  parent.setDescription(method.class.name..":"..method.name)
  parent.Type = vtAutoAssembler -- must be set before setting 'Script'
  parent.Script = aa
  parent.Options = '[moHideChildren]'
  getAddressList().SelectedRecord = parent -- select record

  addMemoryRecord(parent, pointerLabel, pointerLabel, vtQword, true)
  addMemoryRecord(parent, "Counter", pointerLabel.."+8", vtDword, false)
  parameterOffset = 0x10
  for i,p in ipairs(method.parameters) do
    local valueType = vtQword
    local showAsHex = false
    local param = parameters[i + 1]
    if (p.type == "single" or p.type == "System.Single") then
      valueType = vtSingle
    elseif (p.type == "double" or p.type == "System.Double") then
      valueType = vtDouble
    elseif (p.type == "int" or p.type == "System.Int32") then
      valueType = vtDword
    elseif (p.type == "long" or p.type == "System.Int64") then
      valueType = vtQword
    -- TODO: add pointer for string?
    else
      valueType = vtQword
      showAsHex = true
    end
    addMemoryRecord(parent, p.name.." ("..p.type..")", pointerLabel.."+"..string.format("%x", parameterOffset), valueType, showAsHex)
    parameterOffset = parameterOffset + 8
  end

  -- bring main window to front
  getMainForm().bringToFront()
end

local createTableScript32 = function()
  local self = mono.formClass
  local method = self:getSelectedMethod()
  if method == nil then
    print("No method selected!")
    return
  end

  local address = mono_compile_method(method.id)
  local hookInfo = hookAt(address)
  local pointerLabel = "p"..method.class.name.."_"..method.name

  local lines = {}
  table.insert(lines, "define(hook,"..hookInfo.hookString..")")
  table.insert(lines, "define(bytes,"..hookInfo.aobString..")")
  table.insert(lines, "")
  table.insert(lines, "[enable]")
  table.insert(lines, "")
  table.insert(lines, "assert(hook, bytes)")
  table.insert(lines, "alloc(newmem,$1000, hook)")
  table.insert(lines, "label("..pointerLabel..")")
  table.insert(lines, "")
  table.insert(lines, "{")

  -- note: per x64 calling convention, RCX might actually be space for
  -- a pre-allocated structure for the return value and other parameters
  -- might be moved one further down the list
  table.insert(lines, "  Parameters:")
  table.insert(lines, "    [ebp+08]: "..method.class.name.." (this)")
  for i,p in ipairs(method.parameters) do
    local param = parameters32[i + 1]
    table.insert(lines, "    "..param..": "..tostring(p.type).." "..tostring(p.name))
  end
  table.insert(lines, "")

  if method.returnType ~= "(System.Void)" then
    table.insert(lines, "  Returns (EAX) "..method.returnType)
  end
  table.insert(lines, "}")
  table.insert(lines, "")
  table.insert(lines, "newmem:")

  table.insert(lines, "  // increment counter, store instance and parameters (could be off for static method?)")
  table.insert(lines, "  push ebp")
  table.insert(lines, "  mov ebp,esp")
  table.insert(lines, "  push eax")
  table.insert(lines, "  mov eax,[ebp+08]")
  table.insert(lines, "  mov ["..pointerLabel.."], eax")
  table.insert(lines, "  inc dword ptr ["..pointerLabel.."+4]")
  local parameterOffset = 0x08
  for i,p in ipairs(method.parameters) do
    local param = parameters32[i + 1]
    table.insert(lines, "  mov eax,"..param)
    table.insert(lines, "  mov ["..pointerLabel.."+"..string.format("%x", parameterOffset).."],eax")
    parameterOffset = parameterOffset + 4
  end
  table.insert(lines, "  pop eax")
  table.insert(lines, "  pop ebp")
  table.insert(lines, "")

  table.insert(lines, "  // original code")
  for i,c in ipairs(hookInfo.instructions) do
    table.insert(lines, "  "..c)
  end
  table.insert(lines, "  jmp hook+"..string.format("%X", hookInfo.returnOffset))
  table.insert(lines, "")
  table.insert(lines, "align 10")
  table.insert(lines, pointerLabel..":")
  table.insert(lines, "  dq 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0")
  table.insert(lines, "")

  table.insert(lines, "hook:")
  table.insert(lines, "  jmp newmem")
  table.insert(lines, "")
  table.insert(lines, "registersymbol("..pointerLabel..")")
  table.insert(lines, "")
  table.insert(lines, "[disable]")
  table.insert(lines, "")
  table.insert(lines, "hook:")
  table.insert(lines, "  db bytes")
  table.insert(lines, "")
  table.insert(lines, "unregistersymbol("..pointerLabel..")")
  table.insert(lines, "")
  table.insert(lines, "dealloc(newmem)")

  local t = {}
  for i,v in ipairs(lines) do
    table.insert(t, v);
    table.insert(t, "\r\n")
  end

  local aa = table.concat(t)

  local parent = getAddressList().createMemoryRecord()
  parent.setDescription(method.class.name..":"..method.name)
  parent.Type = vtAutoAssembler -- must be set before setting 'Script'
  parent.Script = aa
  parent.Options = '[moHideChildren]'
  getAddressList().SelectedRecord = parent -- select record

  addMemoryRecord(parent, pointerLabel, pointerLabel, vtDword, true)
  addMemoryRecord(parent, "Counter", pointerLabel.."+4", vtDword, false)
  parameterOffset = 0x08
  for i,p in ipairs(method.parameters) do
    local valueType = vtDword
    local showAsHex = false
    local param = parameters[i + 1]
    if (p.type == "single" or p.type == "System.Single") then
      valueType = vtSingle
    elseif (p.type == "double" or p.type == "System.Double") then
      valueType = vtDouble
    elseif (p.type == "int" or p.type == "System.Int32") then
      valueType = vtDword
    elseif (p.type == "long" or p.type == "System.Int64") then
      valueType = vtQword
    -- TODO: add pointer for string?
    else
      valueType = vtQword
      showAsHex = true
    end
    addMemoryRecord(parent, p.name.." ("..p.type..")", pointerLabel.."+"..string.format("%x", parameterOffset), valueType, showAsHex)
    parameterOffset = parameterOffset + 4
  end

  -- bring main window to front
  getMainForm().bringToFront()
end

mono.formClass.methodCreateTableScript = function()
  if targetIs64Bit() then
    createTableScript64()
  else
    createTableScript32()
  end
end

function addMemoryRecord(parent, description, address, type, hex)
  local memrec = getAddressList().createMemoryRecord()
  memrec.setDescription(description)
  memrec.Address = address
  memrec.Type = type
  memrec.ShowAsHex = hex
  memrec.appendToEntry(parent) -- also works: n.Parent = parent
end


function mono.formClass:getSelectedMethod()
  local index = formMonoClass.listMethods.ItemIndex
  if index < 0 then return nil end
  return self.methods[index + 1]
end

function mono.formClass:listMethods_OnDblClick(sender)
  local method = self.methods[sender.ItemIndex + 1]
  --print("method: "..tostring(method.id))
  if method then
    local address = mono_compile_method(method.id)
    --print("address: "..tostring(address))
    getMemoryViewForm().DisassemblerView.SelectedAddress = address
    getMemoryViewForm().show()
    local hookInfo = hookAt(address)
    -- have aobString, hookString, returnString, instructions
    --[[ how to get method signature
    local ps = {}
    for i,p in ipairs(method.parameters) do
      table.insert(ps, string.format('%s %s', p.type, p.name))
    end
    local parms = method.returnType..' ('..table.concat(ps, ', ')..')'
    ]]

    local lines = {}
    table.insert(lines, "define(hook,"..hookInfo.hookString..")")
    table.insert(lines, "define(bytes,"..hookInfo.aobString..")")
    table.insert(lines, "")
    table.insert(lines, "[enable]")
    table.insert(lines, "")
    table.insert(lines, "assert(hook, bytes)")
    table.insert(lines, "alloc(newmem,$1000, hook)")
    table.insert(lines, "{")


    -- note: per x64 calling convention, RCX might actually be space for
    -- a pre-allocated structure for the return value and other parameters
    -- might be moved one further down the list
    table.insert(lines, "  RCX: "..method.class.name.." (this)")
    for i,p in ipairs(method.parameters) do
      local param = parameters[i + 1]
      if (p.type == "single" or p.type == "double" or p.type == "System.Single" or p.type == "System.Double") then param = floatParameters[i + 1] end
      table.insert(lines, "  "..param..": "..tostring(p.type).." "..tostring(p.name))
    end
    table.insert(lines, "")

    table.insert(lines, "  Returns (RAX) "..method.returnType)
    table.insert(lines, "}")
    table.insert(lines, "")
    table.insert(lines, "newmem:")
    table.insert(lines, "  // original code")
    for i,c in ipairs(hookInfo.instructions) do
      table.insert(lines, "  "..c)
    end
    table.insert(lines, "  jmp hook+"..string.format("%X", hookInfo.returnOffset))
    table.insert(lines, "")
    table.insert(lines, "hook:")
    table.insert(lines, "  jmp newmem")
    table.insert(lines, "")
    table.insert(lines, "[disable]")
    table.insert(lines, "")
    table.insert(lines, "hook:")
    table.insert(lines, "  db bytes")
    table.insert(lines, "")
    table.insert(lines, "dealloc(newmem)")

    local t = {}
    for i,v in ipairs(lines) do
      table.insert(t, v);
      table.insert(t, "\r\n")
    end
  
    local aa = table.concat(t)

    getMemoryViewForm().AutoInject1.DoClick()
    
    for i=0,getFormCount()-1 do --this is sorted from z-level. 0 is top
      local f=getForm(i)
  
      if getForm(i).ClassName == 'TfrmAutoInject' then
        f.assemblescreen.Lines.Text = aa
        break
      end
    end
  end
end

--[[
      When double-clicking a field, print out the base address for the statics of the
      class and the address of the clicked-on static field.

      TODO: Create table entry that will use lua to find statics:
        * mono_class_getStaticFieldAddress(mono_enumDomains()[1], mono_findClass("", "GameManager"))
--]]
function mono.formClass:listFields_OnDblClick(sender)
  local field = self.fields[sender.ItemIndex + 1]
  if field then
    local class = field.class
    local image = class.image
    local domainId = image.domain
    print('double-clicked on class '..tostring(field.class.name)..' field '..tostring(field.name)..' domain '..tostring(domainId))
    local address = mono_class_getStaticFieldAddress(domainId, class.id)
    print('statics base address: '..string.format("%x", address))
    print(class.name..'.'..field.name..': '..string.format("%x", address + field.offset))
  end
end

--[[
      IN PROGRESS - take an address and create an AA script to hook at that address
      expecting MONO code.  Will process instructions until 5 bytes (for jmp) are
      processed.  Basic format is like this for address 'CryingSuns.PlayerStatus:BattleshipState:HasAuxiliarySystemType+28'

// [enable]
// assert("CryingSuns.PlayerStatus:BattleshipState:HasAuxiliarySystemType":+28, )
]]
function hookAtFar(address)
  local pos = string.find(address, "+", 1, true)
  local name = address
  local offset = 0
  if (pos ~= nil) then
    name = string.substring(1, pos - 1)
    offset = tonumber(string.sub(pos + 1), 16)
  end
  local actualAddress = getAddress(name) + offset

  local data = {
    hookString = util.safeAddress(getNameFromAddress(actualAddress)), -- used for injection, etc
    instructions = {},
    aobString = ""
  }

  local aobs = {}

  while (offset < 14) do
    local parsed = disassembleAndParse(actualAddress + offset)
    if #aobs > 0 then table.insert(aobs, " ") end
    table.insert(aobs, parsed.bytesString)
    table.insert(data.instructions, parsed.instructionString)
    offset = offset + parsed.length
  end

  data.aobString = table.concat(aobs)
  data.returnString = util.safeAddress(getNameFromAddress(actualAddress + offset))
  data.returnOffset = offset
  return data
end

function hookAt(address)
  local pos = string.find(address, "+", 1, true)
  local name = address
  local offset = 0
  if (pos ~= nil) then
    name = string.substring(1, pos - 1)
    offset = tonumber(string.sub(pos + 1), 16)
  end
  local actualAddress = getAddress(name) + offset

  local data = {
    hookString = util.safeAddress(getNameFromAddress(actualAddress)), -- used for injection, etc
    instructions = {},
    aobString = ""
  }

  local aobs = {}

  while (offset < 5) do
    local parsed = disassembleAndParse(actualAddress + offset)
    if #aobs > 0 then table.insert(aobs, " ") end
    table.insert(aobs, parsed.bytesString)
    table.insert(data.instructions, "// "..parsed.instructionString)
    offset = offset + parsed.length
  end

  -- Use readmem to get all instruction bytes, but we only need to replace 5.
  -- Many times the instructions will look like this:
  -- FuelController:UseRecoverItem - 55                    - push rbp
  -- FuelController:UseRecoverItem+1- 48 8B EC              - mov rbp,rsp
  -- FuelController:UseRecoverItem+4- 48 83 EC 40           - sub rsp,40 { 64 }
  -- Hooking will overwrite the sub rsp instruction, but we only need to overwrite
  -- the '48 83' for the last 2 bytes of the jmp.   Since this is a value
  -- that frequently causes game updates to break scripts, we don't need
  -- to have it hard-coded.
  table.insert(data.instructions, "readmem(hook,"..tostring(offset)..")")

  data.aobString = table.concat(aobs):sub(1,14) -- 5 bytes is what we need, 14 characters
  data.returnString = util.safeAddress(getNameFromAddress(actualAddress + offset))
  data.returnOffset = offset
  return data
end

function hookMethod(method)
  print('hookMethod() is not implemented!')
end

--[[
      Expects address to be a number
]]
function disassembleAndParse(address)
  local disassembly = disassemble(address)
  local parts = util.split(disassembly, "-")
  for i = 1,#parts do
    if i == 2 then
      parts[i] = parts[i]:gsub("%s+", "") -- remove ALL whitespace from bytes
    else
      parts[i] = parts[i]:gsub("^%s*(.-)%s*$", "%1") -- remove whitespace from ends
    end
  end

  local aob = {}
  local i = 1
  while i < string.len(parts[2]) do
    if (i ~= 1) then table.insert(aob, " ") end
    table.insert(aob, string.sub(parts[2], i, i+1))
    i = i + 2
  end

  if (#parts > 3) then
    local result = util.slice(parts, 3)
    parts[3] = table.concat(result, '-')
  end

  local instructionString = parts[3]
  for k,v in parts[3]:gmatch("[0-9a-fA-F]+") do
    if k:len() == 8 or k:len() == 16 then
      instructionString = instructionString:gsub(k, getNameFromAddress(k))
    end
  end

  local result = {
    address = getAddress(address),
    addressString = util.safeAddress(getNameFromAddress(address)),
    aob = aob,
    bytesString = table.concat(aob),
    disassembly = disassembly,
    instructionString = instructionString,
    length = getInstructionSize(address),
    originalInstructionString = parts[3]
  }

  return result
end
