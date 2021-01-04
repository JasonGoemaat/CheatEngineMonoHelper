function loadTextFile(name, useTableFile)
  if useTableFile then
    local tableFile = findTableFile(name)
    if not tableFile then return nil, 'Unable to open table file "'..tostring(name)..'"' end
    local ss = createStringStream()
    ss.Position = 0 -- recommended on wiki: https://wiki.cheatengine.org/index.php?title=Lua:Class:TableFile
    ss.CopyFrom(tableFile.Stream, 0)
    local text = ss.DataString
    ss.destroy()
    return text
  else
    local path = getMainForm().openDialog1.InitialDir..name
    local f, err = io.open(path, "r")
    -- fall back to table file if disk file error (doesn't exist)
    if f == nil then return loadTextFile(name, true) end
    local text = f:read("*all")
    f:close()
    return text
  end
end

--[[
  Save a string to a text file.  If useTableFile is true it will be saved as
  a TableFile.  The directory should be where the cheat file is, it is the
  initial directory for the dialog when you are saving your cheat table.
--]]
function saveTextFile(name, text, useTableFile)
  if useTableFile then
    local tf = findTableFile(name)
    if tf ~= nil then
      tf.delete()
      tf = nil
    end
    tf = createTableFile(name)
    local ss = createStringStream(text)
    tf.Stream.CopyFrom(ss, 0)
    ss.destroy()
    return true
  else
    local path = getMainForm().saveDialog1.InitialDir..name
    local f, err = io.open(path, "w")
    if f == nil then return nil, err end
    f:write(text)
    f:close()
    return true
  end
end

print('Loading util.lua')
loadstring(loadTextFile('src/lua/util.lua'))()
print('Success!')
-- loadstring(loadTextFile('../temp/notes.lua'))()
loadstring(loadTextFile('mono.lua'))()
