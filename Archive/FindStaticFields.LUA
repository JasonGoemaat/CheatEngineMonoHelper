  staticFields = {}
  for i,c in ipairs(mi.classes) do
    for j,f in ipairs(c.staticFields) do
      table.insert(staticFields, f)
    end
  end
  table.sort(staticFields)

local temp = staticFields
staticFields = {}
for i,f in ipairs(temp) do
  if f.typeName ~= 'ID'
      and f.typeName ~= 'States'
      and f.name:find('$', 1, true) == nil
      and f.name:find('<', 1, true) == nil
      and f.typeName:find('_', 1, true) ~= 3
      and f.typeName:find('_', 1, true) ~= 4
  then
    table.insert(staticFields, f)
  else
    --print('Removing '..f.name)
  end
end

print('left with '..tostring(#staticFields)..' fields')

table.sort(staticFields, function(a, b) return a:getFullName() < b:getFullName() end)
for i,f in ipairs(staticFields) do
  print(f.typeName, f:getFullName())
end

