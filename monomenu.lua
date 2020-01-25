function mono.menu:init()
  if self.menuSearch or self.timer then return end
  self.timer = createTimer()
  self.timer.Interval = 1000
  self.timer.OnTimer = function(timer)
    -- wait for normal mono script to create mono menu
    if not miMonoTopMenuItem then return end
    
    self.menuSearch = createMenuItem(miMonoTopMenuItem)
    self.menuSearch.Caption = 'Search'
    self.menuSearch.Name = 'miMonoSearch'
    self.menuSearch.OnClick = function(sender) self:OnSearchClick() end
    miMonoTopMenuItem.add(self.menuSearch)
    self.timer.destroy()
    self.timer = nil
  end
end

function mono.menu:OnSearchClick()
  if mono.selectedImage then
    mono.formSearch:show()
  else
    mono.formSelectImage:show()
  end
end

mono.menu:init()
