local class = mono_findClass("CryingSuns.Navigation", "NavigationAlertLevel")
return mono_class_enumFields(class)
--[[
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
