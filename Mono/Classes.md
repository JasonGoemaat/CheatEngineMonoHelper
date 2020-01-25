# Bootstrap

To bootstrap you can use just have 'loadTextFile` function in your
table file and load the others with it, here a 'bootstrap.lua'
that loads other files...

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
            local path = getMainForm().saveDialog1.InitialDir..name
            local f, err = io.open(path, "r")
            -- fall back to table file if disk file error (doesn't exist)
            if f == nil then return loadTextFile(name, true) end
            local text = f:read("*all")
            f:close()
            return text
        end
    end

    loadstring(loadTextFile('bootstrap.lua'))()

# bootstrap.lua

My generic functions `loadTextFile()` and `saveTextFile()`.

Calls to load other files:

* config.lua
* notes.lua
* mono.lua

# config.lua

# notes.lua

Has `notes` global defined...

    local ct = ct or {}
    ct.notes = notes.new('notes.lua', true) -- optional bool for use TableFile
    ct.notes:save()
    ct.notes:saveAs('notes.lua') -- optional bool false, so save to disk, does not change settings
    ct.notes:show() -- show window to view/edit notes
