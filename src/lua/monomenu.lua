if mono.menu.timer then
  mono.menu.timer.destroy()
  mono.menu.timer = nil
end

function mono.menu:init()
  --if self.menuSearch or self.timer then return end
  self.timer = createTimer()
  self.timer.Interval = 1000
  self.timer.OnTimer = function(timer)
    -- wait for normal mono script to create mono menu, check every 5 seconds
    if not miMonoTopMenuItem then return end
    
    self.timer.destroy()
    self.timer = nil

    local existing = util.getSubmenuByCaption(miMonoTopMenuItem, 'Search')
    if existing ~= nil then self.menuSearch = createMenuItem(miMonoTopMenuItem) else self.menuSearch = existing end
    self.menuSearch.Caption = 'Search'
    self.menuSearch.Name = 'miMonoSearch'
    self.menuSearch.OnClick = function(sender) self:OnSearchClick() end
    if existing == nil then miMonoTopMenuItem.add(self.menuSearch) end
  end
end

function mono.menu:OnSearchClick()
  if mono.selectedImage then
    mono.formSearch:show()
    formMonoSearch:centerScreen()
  else
    mono.formSelectImage:show()
  end
end

mono.menu:init()
