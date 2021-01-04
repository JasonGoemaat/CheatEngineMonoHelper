--[[ 
    
-- Sample call getting all (both), forms only, and lua only

local lf, err, c = loadfile("Build/build.lua")
local all, forms, lua = lf()
return forms, lua


-- Sample to reload and run LUA

local all, forms, lua = loadfile("Build/build.lua")() -- load build script into function and execute
print("Lua:")
print("--------------------------------------------------------------------------------")
print(lua)
print()
print("--------------------------------------------------------------------------------")
loadstring(lua)()

--]]

--[[--------------------------------------------------------------------------------
    - Forms
    --------------------------------------------------------------------------------]]

-- NOTE: this uses special syntax for multi=line strings, any number of equals can
-- appear between the brackets and the close is only when the same number of =
-- are between the close brackets
local sForms = [=====[

--[[--------------------------------------------------------------------------------
    -- Forms - Save strings as files in CE autorun\forms directory, then load form
    -- from file.  
    --------------------------------------------------------------------------------]]

local stringFormMonoClass = '[[-- #INCLUDEFORM(src/forms/formMonoClass.FRM) ]]'

local stringFormMonoImage = '[[-- #INCLUDEFORM(src/forms/formMonoImage.FRM) ]]'

local stringFormMonoSearch = '[[-- #INCLUDEFORM(src/forms/formMonoSearch.FRM) ]]'

local function saveForm(name, text)
    local path = getCheatEngineDir()..[[\autorun\forms\]]..name
    local f, err = io.open(path, "w")
    if f == nil then return nil, err end
    f:write(text)
    f:close()
    return true
end

saveForm('formMonoClass.frm', stringFormMonoClass)
saveForm('formMonoImage.frm', stringFormMonoImage)
saveForm('formMonoSearch.frm', stringFormMonoSearch)

-- set globals for use in lua
formMonoClass = createFormFromFile(getCheatEngineDir()..[[\autorun\forms\formMonoClass.frm]])
formMonoImage = createFormFromFile(getCheatEngineDir()..[[\autorun\forms\formMonoImage.frm]])
formMonoSearch = createFormFromFile(getCheatEngineDir()..[[\autorun\forms\formMonoSearch.frm]])

]=====]

local function loadFormAsLuaString(name)
  local path = getMainForm().openDialog1.InitialDir..name
  local f, err = io.open(path, "r")
  if f == nil then error("Cannot open path: "..tostring(path)..", "..tostring(err)) end
  local text = f:read("*all")
  f:close()
  return "[=========="..text.."]==========]"
end


local patternForm = "%[%[%-%- *#INCLUDEFORM%(([^%)]*)%) *%]%]"
local sectionForms = sForms:gsub(patternForm, loadFormAsLuaString)


--[[--------------------------------------------------------------------------------
    - Lua
    --------------------------------------------------------------------------------]]

local alreadyLoaded = {} -- to prevent ENDLESS endless loop

local function includeLuaFile(name)
  -- print('includeLuaFile: '..name)
  if alreadyLoaded[name] then error("build.lua - Already loaded file: "..tostring(name)) end
  alreadyLoaded[name] = true -- prevent endless loop

  local path = getMainForm().openDialog1.InitialDir..name
  -- print("includeLuaFile() path: "..path);
  local f, err = io.open(path, "r")
  if f == nil then error("build.lua - Cannot open path: "..tostring(path)..", "..tostring(err)) end
  local text = f:read("*all")
  -- print("  loaded bare text, size: "..tostring(string.len(text)))
  f:close()

  text = "\r\n--[[--------------------------------------------------------------------------------\r\n    -- Included File: "..tostring(name).."\r\n    --------------------------------------------------------------------------------]]\r\n"..text

  -- search pattern, returns only the file name because it's a group in parens ()
  local patternSearch = "%[%[%-%- *#INCLUDEFILE%(([^%)]*)%) *%]%]"

  -- interesting, using a function it should call with file name, returning text
  -- print("Got text, trying gsub:")
  -- print(tostring(text))
  -- print("includeLuaFile is: "..tostring(includeLuaFile))
  text = text:gsub(patternSearch, includeLuaFile)
  return text
end

local sectionLua = includeLuaFile("src/lua/bootstrap.lua")

local all = sectionForms.."\r\n\r\n"..sectionLua

local function saveBuildOutput(name, text)
  local path = getMainForm().saveDialog1.InitialDir.."Build/output/"..name
  local f, err = io.open(path, "w")
  if f == nil then return nil, err end
  f:write(text)
  f:close()
  return true
end

saveBuildOutput("all.lua", all)
saveBuildOutput("sectionForms.lua", sectionForms)
saveBuildOutput("sectionLua.lua", sectionLua)

-- all is what should be written to 
return all, sectionForms, sectionLua
