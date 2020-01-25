local MonoClass = mono.MonoClass
MonoClass.mt = {
  __index = MonoClass,
  __tostring = function(t)
    return 'MonoClass '..tostring(t.id)..' "'..tostring(t.name)..'"'
  end,
  __lt = function(a, b)
    return a.lowerName < b.lowerName
  end
  
}

local MonoField = mono.MonoField
local MonoMethod = mono.MonoMethod

--[[
    Called from MonoImage:_init, 'c' is what is returned from enumerating classes.
--]]
function MonoClass.new(image, c)
  local obj = {
    name = c.classname,
    namespace = c.namespace,
    id = c.class,
    lowerName = string.lower(c.classname),
    image = image
  }

  setmetatable(obj, MonoClass.mt)
  return obj
end

function MonoClass:initFields()
  self.fields = {}
  self.fieldsByName = {}
  self.fieldsByLowerName = {}
  
  local temp = mono_class_enumFields(self.id)
  for i,f in ipairs(temp) do
    local field = MonoField.new(self, f)
    table.insert(self.fields, field)
    self.fieldsByLowerName[field.lowerName] = field;
    self.fieldsByName[field.name] = field
  end

  table.sort(self.fields)
end

function MonoClass:initMethods()
  self.methods = {}
  self.methodsByName = {}
  self.methodsByLowerName = {}
  
  local temp = mono_class_enumMethods(self.id)
  for i,m in ipairs(temp) do
    local method = MonoMethod.new(self, m)
    table.insert(self.methods, method)
    self.methodsByName[method.name] = method
    self.methodsByLowerName[method.lowerName] = method
  end

  table.sort(self.methods)
end
