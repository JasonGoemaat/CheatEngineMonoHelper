local DEFAULT_ASSEMBLY_NAME = "Assembly-CSharp"
local imageHasBeenSelected = false

function mono.formSelectImage:show()
  LaunchMonoDataCollector()
  formMonoImage.listImages.Visible = true
  formMonoImage.buttonSelectImage.Visible = true
  formMonoImage.progressImage.Visible = false
  formMonoImage.labelMessage.Visible = false
  
  self.imageNames = mono.MonoImage.enumerate()
  table.sort(self.imageNames)
  local items = formMonoImage.listImages.Items
  items.Clear()

  local foundIndex = 0
  for i,name in ipairs(self.imageNames) do
    items.add(name)
    if name == DEFAULT_ASSEMBLY_NAME then foundIndex = i end
  end
  
  local handler = function(sender)
    mono.formSelectImage.OnSelectImage(self)
  end
  
  formMonoImage.buttonSelectImage.OnClick = handler
  formMonoImage.listImages.OnDblClick = handler
  
  formMonoImage.show()

  if foundIndex ~= 0 and imageHasBeenSelected == false then
    formMonoImage.listImages.ItemIndex = foundIndex
    mono.formSelectImage:OnSelectImage()
  end
end

function mono.formSelectImage:OnSelectImage()
  imageHasBeenSelected = true
  local index = formMonoImage.listImages.ItemIndex + 1
  if self.imageNames == nil or index < 1 or index > #self.imageNames then return end
  local imageName = self.imageNames[index]
 
  formMonoImage.listImages.Visible = false
  formMonoImage.buttonSelectImage.Visible = false
  formMonoImage.progressImage.Visible = true
  formMonoImage.labelMessage.Visible = true
  formMonoImage.labelMessage.Caption = 'Finding classes...'
  
  local image = mono.MonoImage.new()
  
  formMonoImage.progressImage.Min = 0
  local progressHandler = function(done, image, message, count, total)
    if total ~= nil and total > 0 and count ~= nil and count >= 0 then
      message = string.format('%s  %d/%d', message, count, total)
      formMonoImage.progressImage.Max = total
      formMonoImage.progressImage.Position = count
    end
    
    formMonoImage.labelMessage.Caption = message
    if done then self:OnImageComplete(image) end
  end
  
  image:init(imageName, progressHandler)
end

function mono.formSelectImage:OnImageComplete(image)
  self.image = image
  mono.selectedImage = image
  formMonoImage.Close()
  mono.formSearch:show()
  formMonoSearch:centerScreen()
end
