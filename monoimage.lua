local MonoImage = mono.MonoImage
MonoImage.mt = {
  __index = MonoImage,
  __tostring = function(t)
    return 'MonoImage '..tostring(t.name)
  end
}

local MonoClass = mono.MonoClass

--[[
    List names of images, a name can be passed to MonoImage.new()
    or MonoImage(name) to create a MonoImage instance.
--]]
function MonoImage.enumerate()
  local names = {}
  mono_enumImages(function(img)
    local name = mono_image_get_name(img)
    table.insert(names, name)
  end)
  table.sort(names)
  return names
end

--[[
    Constructor doesn't do much, call :init(name, progress)
--]]
function MonoImage.new()
  local obj = { }
  setmetatable(obj, MonoImage.mt)
  return obj
end

--[[
    init() takes the image name and an optional callback for reporting progress
    and when it is complete.  The signature for this function is:
        function progress(complete, image, message, processed, total)
    This callback should be executed on the main CE thread.
--]]
function MonoImage:init(name, progress)
  if monopipe == nil then
    print('Launching mono data collector...')
    LaunchMonoDataCollector()
  end
  
  self.classes = {}                -- straight list of all classes
  self.classesByName = {}          -- dictionary for access by name
  self.classesByLowerName = {}     -- for access by lower case name
  self.classesById = {}            -- for access by id
  self.ignoredClassesByName = {}   -- for ignoring classes in searches, etc.
  self.progress = progress
  self.name = name or 'Assembly-CSharp' -- intelligent default for unity
  
  -- get id
  self.id = nil
  mono_enumImages(function(img)
    local foundName = mono_image_get_name(img)
    if foundName == self.name then self.id = img end
  end)
  
  if not self.id then
    print('NO ID!')
    print('name is', name, self.name)
    self:report(false, 'Error finding image named '..tostring(name))
    self.progress = nil
    self.total = nil
    self.count = nil
    return false
  end
  
  createThread(function(thread)
      self.thread = thread
      self:_init(thread)
    end)
end

--[[
    This is the function called by init() on another thread
--]]
function MonoImage:_init(thread)
  --print('MonoImage:_init thread is', thread, 'self is', tostring(self))
  self.thread = thread
  local temp = mono_image_enumClasses(self.id)
--  thread.synchronize(function(th)
--      print('Image '..tostring(self.id)..' has classes: '..tostring(temp))
--    end)
    
  self.classes = {}
  self.classesByName = {}
  self.classesByLowerName = {}
  self.classesById = {}
  self.missingNames = {}
  
  self.total = #temp
  self.count = 0
  self.message = "Getting classes"
  self:report(false, "Getting classes")
  
  -- populate classes without much information first so we can
  -- access our definitions when filling in parents, properties, etc.
  for i,c in ipairs(temp) do
    local class = MonoClass.new(self, c)
    if class.lowerName ~= nil then
      table.insert(self.classes, class)
      self.classesByName[class.name] = class
      self.classesByLowerName[class.lowerName] = class
      self.classesById[class.id] = class
    else
      --print("Nil lowername for class", c.class)
    end
    self.count = i
    if (i % 100 == 0 or i == #temp) then
      self:report(false, 'Fetching classes')
    end
  end
  table.sort(self.classes)
  
  for i,class in ipairs(self.classes) do
    class.parentId = mono_class_getParent(class.id)
    class.parent = self.classesById[class.parentId]
    self.count = i
    if (i % 100 == 0 or i == #temp) then
      self:report(false, 'Fetching parents')
    end
  end
  
  self.count = 0
  for i,class in ipairs(self.classes) do
    class:initFields()
    class:initMethods()
    self.count = i
    if (i % 100 == 0 or i == #temp) then
      self:report(false, 'Initializing fields and methods')
    end
  end
  
  self:report(true, 'Done')
end

--[[
    Report progress on the main CE thread to do gui updates
--]]
function MonoImage:report(done, message)
  if self.progress ~= nil and self.thread ~= nil then
    self.thread.synchronize(function(thread)
        self.progress(done, self, message, self.count, self.total)
      end)
  end
  
  if done then
    -- do cleanup here
    self.count = nil
    self.total = nil
    self.progress = nil
    self.thread = nil
  end
end


--[[  Sample code... weird

--return util.pretty(mono.MonoImage.enumerate())
mi = mono.MonoImage.new()
print('mi is "'..tostring(mi)..'"')
mi:init('Assembly-CSharp', function(c, i, m, p, t)
  print(m, p, t)
end)

--LaunchMonoDataCollector()
local thread = createThread(function(th)
  TESTIMAGES = {}
  mono_enumImages(function(img)
    th.synchronize(function() print(img) end)
  end)
end)

--]]
