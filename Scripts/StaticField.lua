function getStaticAddress(namespace, className, field)
  for i,domain in ipairs(mono_enumDomains()) do
    for j,assembly in ipairs(mono_enumAssemblies(domain)) do
      local image = mono_getImageFromAssembly(assembly)
      for k,class in ipairs(mono_image_enumClasses(imageId)) do
        local nsn = mono_class_getNamespace(class)
        local cn = mono_class_getName(class)
        if class.namespace == namespace and class.name == className then
          for l,field in ipairs(mono_image_enumFields(class)) do
          end
        end
      end
    end
  end
end

--function getStaticAddress(namespaceName, className, fieldName)
unregisterSymbol("CryingSuns:GameState:currentRunState")
unregisterSymbol("CryingSuns:GameState:currentRunState")
LaunchMonoDataCollector()
local class = mono_findClass("CryingSuns", "GameState")
for i,f in ipairs(mono_class_enumFields(class)) do
  if f.isStatic and f.name == "currentRunState" then
    registerSymbol("CryingSuns:GameState:currentRunState", mono_class_getStaticFieldAddress(mono_enumDomains()[1], class) + f.offset, true)
    break
  end
end
unregisterSymbol("CryingSuns:GameState:currentRunState")
--local address = mono_class_getStaticFieldAddress(mono_enumDomains()[1], class)
--return string.format("%X", address + field.offset)
--print(string.format("%X", address + field.offset))
--return field

--return getStaticAddress("CryingSuns", "GameState", "currentRunState")
--]]
