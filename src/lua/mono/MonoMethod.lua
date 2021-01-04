local MonoMethod = mono.MonoMethod
MonoMethod.mt = {
  __index = MonoMethod,
  __tostring = function(t)
    return 'MonoMethod '..tostring(t.id)..' "'..tostring(t.name)..'"'
  end,
  __lt = function(a, b)
    return a.lowerName < b.lowerName
  end
}

function MonoMethod.new(class, m)
  local obj = {
    class = class,
    id = m.method,
    name = m.name,
    lowerName = string.lower(m.name),
    parameters = {}
  }
  setmetatable(obj, MonoMethod.mt)

  lastmethod = obj
  local types, parameternames, returntype = mono_method_getSignature(obj.id)
  local typenames={}
  local tn
  if types ~= nil then
    for tn in string.gmatch(types, '([^,]+)') do
      table.insert(typenames, tn)
    end
  end
  
  for i=1,#typenames do
    table.insert(obj.parameters, { name = parameternames[i], type = typenames[i] })
  end
  obj.returnType = returntype

  return obj
end

--[[
    Get parameters for method
--]]
function MonoMethod:fetchParms()
  if self.parms ~= nil then return nil end
  if self.class.image.ignoredClassesByName[self.class.name] ~= nil then return nil end
  local status, parms = pcall(function()
         local result = mono_method_get_parameters(self.id)
         return result
       end)

  if status then
    -- success!
    self.parms = parms
  else
    self.class.image.ignoredClassesByName[self.class.name] = true
    print('Error with class '..tostring(self.class.name)..' method '..tostring(self.name))
    error('Error fetching parameters for '..tostring(self.class.name)..'.'..tostring(self.name))
  end
end
