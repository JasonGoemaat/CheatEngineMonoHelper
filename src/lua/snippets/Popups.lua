-- this works for changing the pop-up to have only the new menu item you add!
--[[ this works for changing the pop-up to have only the new menu item you add!

local mi = createMenuItem(formMonoClass.popupMethods.Items)
mi.Caption = "Click me!"
mi.OnClick = function()
  showMessage("You clicked me, silly goose!")
end
mi.name = 'miClickMe'
formMonoClass.popupMethods.Items:clear()
formMonoClass.popupMethods.Items.add(mi)

--]]


--------- TEMP
formMonoClass.popupMethods.Items:clear()
local mi = createMenuItem(formMonoClass.popupMethods.Items)
mi.Caption = "Click me again!"
mi.OnClick = function()
  print('you clicked the popup!')
  showMessage("You clicked me, silly goose!")
end
mi.name = 'miClickMe'
formMonoClass.popupMethods.Items.add(mi)

--]]

formMonoClass.popupMethods.Items.OnClick = function(sender) print('You clicked the popup!') end
formMonoClass.popupMethods.Items.setOnClick(function(sender) print('You clicked the popup!') end)
formMonoClass.popupMethods.OnPopup = function(sender) print('OnPopup!') end

formMonoClass.listMethods.OnSelectItem = function(sender)
  showMessage("You selected something!")
end



--------- set popup menu when it is clicked
formMonoClass.popupMethods.OnPopup = function(sender)
    formMonoClass.popupMethods.Items:clear()

    local mi
    
    mi = createMenuItem(formMonoClass.popupMethods.Items)
    mi.Caption = "Say hello"
    mi.OnClick = function()
      showMessage("Hello, world!")
    end
    mi.name = 'miSayHello'
    formMonoClass.popupMethods.Items.add(mi)

    mi = createMenuItem(formMonoClass.popupMethods.Items)
    mi.Caption = "CLICK ME!"
    mi.OnClick = function()
      showMessage("Thank you so much for clicking me!")
    end
    mi.name = 'miClickMe'
    formMonoClass.popupMethods.Items.add(mi)
end

