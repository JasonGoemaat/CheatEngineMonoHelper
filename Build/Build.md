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


## Getting form text:

```lua
local loadTextFile = function(name)
  local path = getMainForm().openDialog1.InitialDir..name
  local f, err = io.open(path, "r")
  -- fall back to table file if disk file error (doesn't exist)
  if f == nil then return loadTextFile(name, true) end
  local text = f:read("*all")
  f:close()
  return text
end

local text = loadTextFile("build/build.lua")
local result = loadstring(text)
return result()
```

## WORK IN PROGRESS

Sample script for what I'm thinking, including text of other files in with existing file.
This seems to work fine.  If we rely on exactly one space where they are and no spaces
in the file name, we should be able to use the lengths to pick out the file name pretty
easily.

Ok, this seems to work well.  The pattern to seach for returns only the file name,
but the pattern used to replace replaces the whole string from beginning brackets to closing
and allows for spaces in brackets.  The search should find the first one, and the replace
is limited by last parameter to one replace.  Works online...

```lua
local s = "[[-- #INCLUDEFILE(src/lua/mono/monofield.lua) ]]"

local s2 =[===[

  [[-- #INCLUDEFILE(src/lua/mono/monofield.lua) ]]
  [[-- #INCLUDEFILE(src/lua/mono/monomethod.lua) ]]
  [[-- #INCLUDEFILE(src/lua/mono/monoclass.lua) ]]
  [[-- #INCLUDEFILE(src/lua/mono/monoimage.lua) ]]
  
  [[-- #INCLUDEFILE(src/lua/monomenu.lua) ]]
  
  [[-- #INCLUDEFILE(src/forms/lua/formSelectImage.lua) ]]
  [[-- #INCLUDEFILE(src/forms/lua/formSearch.lua) ]]
  [[-- #INCLUDEFILE(src/forms/lua/formClass.lua) ]]
  
  ]===]

local patternOriginal = "%[%[%-%- *#INCLUDEFILE%([^%)]*%) *%]%]"
local pattern =         "%[%[%-%- *#INCLUDEFILE%(([^%)]*)%) *%]%]"

print("patternOriginal: (entire line with comments and spaces, use for gsub")
local simpleMatch = s:match(patternOriginal )
print(simpleMatch)
print()

print("pattern: pick out file name (between parens) alone for loading file")
local s2Match, a, b, c = s2:match(pattern)
print(s2Match)
print()


local r = s2:gsub(pattern, "FILE CONTENT", 1) -- limit to 1 replacement
print('result:')
print(r);
print()

print('s2 now:')
print(s2)
```

Ok, THIS script seems to be very nice, it handles includes like above, prevents
an endless loop of loading files if they have a circular reference:

```lua
local alreadyLoaded = {} -- to prevent endless loop

function includeLuaFile(name)
  if alreadyLoaded[name] then error("Already loaded file: "..tostring(name)) end
  alreadyLoaded[name] = true -- prevent endless loop

  local path = getMainForm().openDialog1.InitialDir..name
  print("loatTextFile() path: "..path);
  local f, err = io.open(path, "r")
  if f == nil then error("Cannot open path: "..tostring(path)..", "..tostring(err)) end
  local text = f:read("*all")
  print("  loaded bare text, size: "..tostring(string.len(text)))
  f:close()

  text = "\r\n[[--------------------------------------------------------------------------------\r\n  -- Included File: "..tostring(name).."\r\n  --------------------------------------------------------------------------------]]\r\n"..text

  -- search pattern, returns only the file name because it's a group in parens ()
  local patternSearch = "%[%[%-%- *#INCLUDEFILE%(([^%)]*)%) *%]%]"

  -- interesting, using a function it should call with file name, returning text
  text = text:gsub(patternSearch, includeLuaFile)
  return text
end
```