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

loadstring(loadTextFile('bootstrap.lua'))()
