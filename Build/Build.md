# Building `monohelper.lua`

When developing, you need a CT file that is in the same directory as the source
code, specifically 'bootstrap.lua'.  It's easiest to use the included
`CheatEngineMonoHelper.CT`, but if you want to setup your own you need to
follow these steps:

## Forms

The forms will exist embedded in the cheat table during development.
Later when creating the combined file 'monohelper.lua', you will the content
as strings which allow it to add the forms to your cheat table when using it.

Create a new form for each file in 'FormsFRM' and load it:

* formMonoClass.FRM
* formMonoImage.FRM
* formMonoSearch.FRM

Steps for each form:

1. In CE do 'Table->Create Form'
2. In editor do 'File->Load' (*not* 'Load LFM')
3. Select the file
4. Close the editor window (form window will still show up, now in run mode instead of design mode)
5. Close the form window
6. The form should now appear in the 'Table' menu and you can edit it from there

## Bootstrapping

The cheat table needs to be in the same directory as the source files,
specifically 'bootstrap.lua'.  The script below should be added as your
table script.  This has some utility functions and executes 'bootstrap.lua',
which itself loads other files and executes them.

Go to 'Table->Show Cheat Table Lua Script' (or CTRL+ALT+L)
and enter the code below then execute it

```lua
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
```

That's it, you should now see a 'Search' option under the 'Mono' menu when
attached to a game that supports CE mono features.

