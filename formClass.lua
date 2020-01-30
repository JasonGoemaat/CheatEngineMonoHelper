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
  if a.class.name < b.class.lowerName then return true end
  if b.class.lowerName < a.class.lowerName then return false end
  return a.name < b.name
end

local sortByClassThenOffset = function(a, b)
  if a.class.name < b.class.lowerName then return true end
  if b.class.lowerName < a.class.lowerName then return false end
  return a.offset < b.offset
end

local sortByName = function(a, b)
  return a.name < b.name
end

local sortByOffset = function(a, b)
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
    listitem.Caption = 'STATIC:'..string.format('%2X', field.offset or 0)
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

local parameters = { 'RCX', 'RDX', 'R8', 'R9', '[RBP+30]', '[RBP+38]', '[RBP+40]', '[RBP+48]', '[RBP+50]' }
local floatParameters = { 'XMM0', 'XMM1', 'XMM2', 'XMM3', 'XMM4', 'XMM5', 'XMM6'}

function mono.formClass:popupMethod_OnPopup(sender)
  
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
      if (p.type == "System.Single" or p.type == "System.Double") then param = floatParameters[i + 1] end
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

[enable]
assert("CryingSuns.PlayerStatus:BattleshipState:HasAuxiliarySystemType":+28, )
]]
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
    table.insert(data.instructions, parsed.instructionString)
    offset = offset + parsed.length
  end

  data.aobString = table.concat(aobs)
  data.returnString = util.safeAddress(getNameFromAddress(actualAddress + offset))
  data.returnOffset = offset
  return data
end

function hookMethod(method)

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
