--[[ 
    A note has 'key' and 'text' fields, lists are sorted by key.
--]]

notes = notes or {}
notesmt = notesmt or {}

note = note or {}
notemt = notemt or {}

notemt.__index = note
notemt.__lt =  function(a,b) return a.key < b.key end

function notes.new(filename, useTableFile)
  local obj = {}
  setmetatable(obj, {__index = notes})
  obj:load(filename, useTableFile)
  return obj
end

function notes:load(filename, useTableFile)
  self.filename = filename
  self.useTableFile = useTableFile
  local s = loadTextFile(self.filename, self.useTableFile)
  self.dict = {}
  if s then self.dict = loadstring(s)() end
  self.lastSave = os.clock()
  self.lastChange = 0
end

function notes:save()
  local text = util.serialize(self.dict)
  saveTextFile(self.filename, text, self.useTableFile)
  self.lastSave = os.clock()
end

function notes:saveAs(filename, useTableFile)
  self.filename = filename
  self.useTableFile = useTableFile
  self:save()
end


function notes:update(key, text)
  if text == nil or string.len(text) == 0 then
    if self.dict[key] then self.dict[key] = nil end
  else
    self.dict[key] = {key = key, text = text}
  end
  self.lastUpdate = os.clock()
end

function notes:getList()
  local keys = {}
  for k,n in pairs(self.dict) do table.insert(keys, n) end
  return keys
end
