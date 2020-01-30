local MonoField = mono.MonoField
MonoField.mt = {
  __index = MonoField,
  __tostring = function(t)
    return 'MonoField '..tostring(t.id)..' "'..tostring(t.name)..'"'
  end,
  __lt = function(a, b)
    return a.lowerName < b.lowerName
  end
}

-- class is a monoclass table, f is a table with results from
-- mono_class_enumFields
function MonoField.new(class, f)
  local obj = {
    class = class,
    id = f.field,
    name = f.name,
    isStatic = f.isStatic,
    isConst = f.isConst,
    offset = f.offset,
    monoType = f.monotype,
    lowerName = string.lower(f.name),
    foundTypeName = f.typeName,
    typeName = mono.TYPE_NAMES[f.monotype] or 'UnknownType'..tostring(f.monotype)
  }

  -- should be types where we might have a 'Class'
  --if f.monotype == 15 or f.monotype == 16 or f.monotype == 18 or f.monotype then
  --end

  obj.typeClassId = mono_type_getClass(obj.id)
  if obj.typeClassId ~= nil then
    -- this is the 'type' of the field
    obj.typeClass = class.image.classesById[obj.typeClassId]
    if obj.typeClass ~= nil then
      obj.typeName = obj.typeClass.name
    else
      if class.image.missingNames[obj.typeClassId] then
        obj.typeName = class.image.missingNames[obj.typeClassId]
      else
        obj.typeName = mono_class_getFullName(obj.typeClassId)
        class.image.missingNames[obj.typeClassId] = obj.typeName
      end
    end
  end

  setmetatable(obj, MonoField.mt)
  return obj
end

function MonoField:getFullName()
  local s = ""
  if self.class.namespace ~= nil and self.class.namespace:len() > 0 then s = self.class.namespace..':' end
  s = s..self.class.name..'.'
  s = s..self.name
  return s
end
