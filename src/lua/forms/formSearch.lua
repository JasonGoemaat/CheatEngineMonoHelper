--[[
    Form for searching an image.
    
    Controls:
      pageMain.tabSearch - main tab
      editSearchText: TCEEdit
      listSearchClasses: TCEListView
      listSearchFields: TCEListView
      listSearchMethods: TCEListView
      miImage: TMenuItem - main menu Image entry
      miImageSelectImage - entry to re-open select image form
--]]

mono.formSearch.found = mono.formSearch.found or {}
mono.formSearch.found.classes = mono.formSearch.found.classes or {}
mono.formSearch.found.fields = mono.formSearch.found.fields or {}
mono.formSearch.found.methods = mono.formSearch.found.methods or {}

--[[
    Show the search form, mono.selectedImage should be set to the
    image to search.
--]]
function mono.formSearch:show()
  if mono.selectedImage == nil then return end
  self.image = mono.selectedImage
  
  -- setup event handlers
  formMonoSearch.miImageSelectImage.OnClick = function(sender) self:SelectImageClick() end
  
  formMonoSearch.listSearchClasses.OnData = function(sender, listitem)
    self:listSearchClasses_OnData(sender, listitem)
  end
  
  formMonoSearch.listSearchClasses.OnDblClick = function(sender)
    local class = self.found.classes[sender.ItemIndex + 1]
    mono.formClass:show(class, nil, nil)
  end
  
  formMonoSearch.listSearchFields.OnData = function(sender, listitem)
    self:listSearchFields_OnData(sender, listitem)
  end
  
  formMonoSearch.listSearchFields.OnDblClick = function(sender)
    local field = self.found.fields[sender.ItemIndex + 1]
    if field then
      mono.formClass:show(field.class, field, nil)
    end
  end
  
  formMonoSearch.listSearchMethods.OnData = function(sender, listitem)
    self:listSearchMethods_OnData(sender, listitem)
  end
  
  formMonoSearch.listSearchMethods.OnDblClick = function(sender)
    local method = self.found.methods[sender.ItemIndex + 1]
    if method then
      mono.formClass:show(method.class, nil, method)
    end
  end
  
  formMonoSearch.editSearchText.OnChange = function(sender)
    self:search(formMonoSearch.editSearchText.Text, formMonoSearch.cbStaticFieldsOnly.Checked)
  end

  formMonoSearch.cbStaticFieldsOnly.OnChange = function(sender)
    self:search(formMonoSearch.editSearchText.Text, formMonoSearch.cbStaticFieldsOnly.Checked)
  end
  
  -- popups
  formMonoSearch.listSearchClasses.PopupMenu = formMonoSearch.popupClasses
  local count = 0
  formMonoSearch.popupClasses.OnPopup = function(sender)
    -- print('formMonoSearch.popupClasses.OnPopup "'..tostring(sender.name)..'" count '..tostring(count))
    count = count + 1
  end
  
  -- perform initial search to set 'found' results, probably empty text
  self:search(formMonoSearch.editSearchText.Text, formMonoSearch.cbStaticFieldsOnly.Checked)  

  -- show form
  formMonoSearch.show()
end

--[[
    When menu item to select an image is clicked, hide this form and
    show the image select form
--]]
function mono.formSearch:SelectImageClick()
  formMonoSearch.close()
  mono.formSelectImage:show()
end

--[[
    When typing in the edit box to filter results, filter the lists of
    classes, fields, and methods with the lower case of the text
--]]
function mono.formSearch:search(text, staticFieldsOnly)
  local lower = nil
  if text ~= nil then lower = text:lower() end

  local classes = {}
  local methods = {}
  local fields = {}
  for i,class in ipairs(self.image.classes) do
    if lower == nil or class.lowerName:find(lower, 1, true) ~= nil then table.insert(classes, class) end
    for j,method in ipairs(class.methods) do
      if lower == nil or method.lowerName:find(lower, 1, true) ~= nil then table.insert(methods, method) end
    end
    for j,field in ipairs(class.fields) do
      if lower == nil or field.lowerName:find(lower, 1, true) ~= nil then
        if (not staticFieldsOnly) or field.isStatic then
          table.insert(fields, field)
        end
      end
    end
  end
  self.found.classes = classes
  self.found.fields = fields
  self.found.methods = methods
  formMonoSearch.listSearchClasses.Items.Count = #classes
  formMonoSearch.listSearchFields.Items.Count = #fields
  formMonoSearch.listSearchMethods.Items.Count = #methods
end

-- handler to display classes in list view
function mono.formSearch:listSearchClasses_OnData(sender, listitem)
  local index = listitem.Index + 1
  local class = self.found.classes[index]
  listitem.Caption = class.name
end

-- handler to display fields in list view
function mono.formSearch:listSearchFields_OnData(sender, listitem)
  local field = self.found.fields[listitem.Index + 1]
  if field == nil then
    listitem.Caption = 'nil index '..tostring(index)
  else
    listitem.Caption = field.name
    local staticString = ""
    if field.isStatic then staticString = "Static" end
    if field.isConst then staticString = "Const" end
    local xtra = { field.class.name,  staticString }
    listitem.SubItems.text = table.concat(xtra, '\n')
  end
end

-- handler to display methods in list view
function mono.formSearch:listSearchMethods_OnData(sender, listitem)
  local method = self.found.methods[listitem.Index + 1]
  if method == nil then
    listitem.Caption = 'nil index '..tostring(index)
  else
    listitem.Caption = method.name
    listitem.SubItems.text = method.class.name
  end
end

-- handler for static fields only checkbox
function mono.formSearch:cbStaticFieldsOnly_OnChange(sender)
  self:search(formMonoSearch.editSearchText.Text, formMonoSearch.cbStaticFieldsOnly.Checked)
end
