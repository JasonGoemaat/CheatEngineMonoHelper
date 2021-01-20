--[[ 
    
-- Sample call getting all (both), forms only, and lua only
local all, forms, lua = loadfile(getMainForm().openDialog1.InitialDir.."Build/build.lua")()
return forms, lua


-- Sample to reload and run LUA
local all, forms, lua = loadfile(getMainForm().openDialog1.InitialDir.."Build/build.lua")() -- load build script into function and execute
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
    -- Forms - Save strings as temp files, then load using createFormFromFile()  
    --------------------------------------------------------------------------------]]

-- close any open forms
if formMonoClass ~= nil then 
  formMonoClass.close()
  formMonoClass:destroy()
  formMonoClass = nil
end
if formMonoImage ~= nil then
  formMonoImage.close()
  formMonoImage:destroy()
  formMonoImage = nil
end
if formMonoSearch ~= nil then
  formMonoSearch.close()
  formMonoSearch:destroy()
  formMonoSearch = nil
end

-- unselect image, refs won't be correct if re-ran
if mono then mono.selectedImage = nil end


-- generate forms from saved XML
local stringFormMonoClass = [[-- #INCLUDEFORM(src/forms/formMonoClass.FRM) ]]

local stringFormMonoImage = [[-- #INCLUDEFORM(src/forms/formMonoImage.FRM) ]]

local stringFormMonoSearch = [[-- #INCLUDEFORM(src/forms/formMonoSearch.FRM) ]]

local function saveForm(text)
  local path = os.tmpname() -- get temp file name
  local f, err = io.open(path, "w")
  if f == nil then return nil, err end
  f:write(text)
  f:close()
  return path
end

local function createFormFromString(text)
  local path = saveForm(text)
  local form = createFormFromFile(path)
  pcall(os.remove, path)
  return form
end

-- create forms from xml (using temp files)
formMonoClass = createFormFromString(stringFormMonoClass)
formMonoImage = createFormFromString(stringFormMonoImage)
formMonoSearch = createFormFromString(stringFormMonoSearch)
]=====]

local function loadFormAsLuaString(name)
  local path = getMainForm().openDialog1.InitialDir..name
  local f, err = io.open(path, "r")
  if f == nil then error("Cannot open path: "..tostring(path)..", "..tostring(err)) end
  local text = f:read("*all")
  f:close()
  return "[==========["..text.."]==========]"
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

  text = "\n--[[--------------------------------------------------------------------------------\n    -- Included File: "..tostring(name).."\n    --------------------------------------------------------------------------------]]\n"..text

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

local all = sectionForms.."\n"..sectionLua

local function saveBuildOutput(name, text)
  local path = getMainForm().saveDialog1.InitialDir.."Build/output/"..name
  local f, err = io.open(path, "w")
  if f == nil then return nil, err end
  f:write(text)
  f:close()
  return true
end

saveBuildOutput("monohelper.lua", all)
saveBuildOutput("sectionForms.lua", sectionForms)
saveBuildOutput("sectionLua.lua", sectionLua)

-- all is what should be written to 
return all, sectionForms, sectionLua
