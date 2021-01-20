local parent = getAddressList().getMemoryRecordByDescription("PersonController:Update")
-- return memrec.getType() -- type 11

local n = getAddressList().createMemoryRecord()
n.setDescription('New Record')
n.appendToEntry(parent) -- also works: n.Parent = parent
n.Type = vtAutoAssembler -- must be set before setting 'Script'
n.Script = [[[enable]
[disable]
]]
getAddressList().SelectedRecord = n -- select record
n.Active = true
print('new record id:'..tostring(n.id))
return "DONE!"

--[[ other things:

ShowAsHex = true for address types
types can be:
  vtDword - for counter
  vtQword - for pointer
  vtSingle
  vtDouble
  vtString

Set 'Selected = true'
Set 'Active = true'

memrec.Color = 0xff0000 -- blue

IsGroupHeader - for record that is ONLY group header, maybe create header for script?

Interesting, you can set DropDownList to StringList, in 'value:description' lines, lets you select options?

Can use 'DontSave' for temp things

Can set Collapsed = true or false

Can set OffsetCount and Offset[index] for pointers

]]

