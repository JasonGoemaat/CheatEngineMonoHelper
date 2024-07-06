Looking at Raft, I found myself doing the same thing a lot during initial investigation:

* Hook Function
* Add global alloc for temp variable
* Add code to push rax, mov global ref to rax, store rcx (and other parms) at rax along with counter, pop rax
* Save script as table entry
* Activate table entry
* Add variables for RCX, Counter, and any params as children to script

For investigations like this it would be SUPER handy to have a one or two click method for doing this.

## TODO

Recent (2024-02-25):

* Default or separate option so 'hook' creates a standard table entry (and opens?)
* Toggle for enabling 14 byte far jmp, default to 5 (current uses 14)
* Toggle to use 'readmem', default on...  Mostly for 5 byte jumps where 'sub rsp,xxx' won't overwrite the xxx, helpful for not having to update scripts on game updates
* Put AA commands in comments for classes in parameter list, calling class, and maybe fields?
  * `GETMONOSTRUCT(Inventory,:Inventory)` should work
  * Test in CE LUA window: `return monoAA_GETMONOSTRUCT("Inventory", ":Inventory", false)`
  * Check that parent fields are included, or add parent classes separately and note in comments?
* Better structure dissect for arrays, lists, dictionaries?
  * Sucks that the indexed items are often wrong, or there are multiple
  * Keys and Values are dumb
  * Maybe LUA form to parse and display dictionary contents?   Table with Key, Value?
* Look into calling mono method?  Creating mono class? 

Older:

* TODO: popup on method -> generate 'find pointer' script
  * Actually adds a new memrec to CE with a script doing my standard stuff to find the pointer
  * Method 'PlayerController:Update' will globalalloc 'pPlayerController_Update'
    * push rax
    * mov rax,pPlayerController_Update
    * inc dword ptr [rax] // counter
    * mov [rax+8], rcx     // parameter 1
    * mov [rax+10], rdx    // parameter 2
    * movss [rax+18], xmm3 // parameter 3
    * pop rax
  * Table entries under script as a group header for counter and parameters


* TODO: Check on why search is funky: Evil Bank Manager
  * CountryRelationship has `PoliticSkill[] politicSkills` property, `System.Single <buyPrice>k__BackingField`, and `Country <country>k__BackingField`
  * Accessible from CountryInfoCard, CountryRelationshipCard, RegionPoliticSkillWindow, DeleteLicenseWindow, DeleteLicenseNotificationWindow, ConversationWindow
    * CountryInfoCard has various click methods (Invest, Property, Relationshop) and updates relationship value
    * CountryRelationshipCard has OnSkillClick(), OpenConversationWindow()
    * RegionPoliticSkillWindow has DeactivateTab, Apply, OnWindowShowing, OnWindowHidint, SetActiveTab
    * DeleteLicenseWindow has ONWindowShowing() and ShowNotification()
    * DeleteLicenseNotificationWindow has Accept() and Decline() as well as OnWindowShowing()
    * ConversationWindow has 

* TODO: Sample of search being buggy:
  * EvilBankManager - looking for CountryRelationshipCard, start typing and after the last 'C' in  `CountryRelationshipC` it only shows CountryRelationship.  With a 'T' instead it works for others, weird...  `RelationshipC` works fine
  * Searching for ConversationWindow buggy, 'Window' finds it
    * Ok, weird, seems to depend on pasting or not, or fixes itself
  * Might need to 'prepare' some helper functions as it seems to be spotty, next time run a single function in the LUA console to output the exact terms, etc being used for the search and allow checking of what is called in the search...
  * Pretty simple, it does `lower == nil or class.lowerName:find(lower, 1, true) ~= nil`
  * Check: return mono.formSearch.found.classes[1].lowerName
  * Look for match in `for i,class in ipairs(mono.formSearch.image.classes) do print(class.lowerName) end`

* TODO: When in 'Show usages' mode of class window, double-clicking on field should open that class
    * Currently it does the static field logic, showing 0 as the address in the console
* TODO: Figure out way to hook the right overloaded method
    * Samples in EvilBankManager:
      * UserBank:GetCapital has two versions, one takes a Single parameter, the other has none
      * UserBank:GetResourceCount takes either int or Resource/ResourceType
      * Sample: `System.Single GetResourceCount(int resourceId)`
        * monoAA_GetOverloadedFunction(SYMBOL_NAME, "UserBank:GetResourceCount", System.Single, int)
    * Could be pretty short AA script looking for parameter signatures, or lua script
* TODO: DblClick on static field generates script with {$lua} code to find it and define?
    * Alternate: LUA code to get base address for static class and define? - doesn't work with mono generate struct due to conflicting offsets, maybe CLASS_FIELD as define?
* TODO: Alternate for having memrecs for script and pointers - more difficult but cooler
    * Able to hook methods from window, list in separate window and enable/disable/remove
    * LUA could keep track of a 'globals' memory region and where the pointers for each method are
    * LUA could show count, pointers, etc in it's own window
    * LUA could open structure dissect and generate structure using it's information for names
* TODO: generate script inside mono method, not at start - three options:
    1. Simple inject - use bytes being replaced and exact address
    2. AOB - use AOB search to find point in code, bytes must remain the same
    3. Advanced AOB - allow hooking code with offset of field
        * One option would be to identify the field and change the value based on mono dissect
            * Example: 'movss [rax+5c],xmm0 // set current health'
                * 5c is offset of 'currentHealth' field, look for that offset in the type the method belongs on
                * LUA code in top of script will alter the AOB to search for
                * LUA code in top of script will search for AOB only inside method boundaries (or start of method + x + 100) for instance where x is offset we're hooking, or will stop when it finds another 'push rbp; mov rbp, rsp', or when it finds a ret (though there could be more than one of these)
                * use readmem/writemem to replace with exact code, or use AOB found in step 1 that we're replacing (how?  separate enable/disable sections)


## Ideas:

* Right-click pop-up to add to list (at the least could add as a menu option)
* One option is to create the entire table entry with script and supporting variables, default name "TEST: Class.Method"
* Another option would be to have method 'hooked', using popup or menu if popup not working right

* We could keep list of methods separate and show like check or '(hooked)' in list
* Could have separate page or tab displaying these, and enable/disable individually
    * Could click on one to open in structure dissector, possibly create and select structure automatically
    * Show list of hooked (enabled or disabled) methods in different tab
    * Show Counter of executions and last parameter values
    * Click to open structure dissector with RCX value (maybe other params too)
    * Should be able to select text of parameter values to copy/paste
    * Maybe popup ('Copy RCX: 78919199FC' for example)
* 

## Other Todo

* AA vars in generated scripts are always shown in comments as int registers, it would be nice for singles/doubles to have the XMM register specified instead
    * Maybe for Int32 have only EDX listed for example, not RDX?
    * Pretty sure Registers are RCX, RDX, R8?, R9?, and corresponding XMM0-XMM3
    * i.e. RCX will be instance pointer, first single param will be RDX or XMM1, etc.
* Detect when mono not running and start instead of print error to console
    * could be when activate/reactivate we have to re-select assembly
    * auto-reselect assembly in this case?
        * probably possible to check and trap error when switching to window or performing operations and auto-reselect assembly by name
* Auto-select 'Assembly-CSharp' if present?
* Figure out static variables and how to access them
* Finish 'Notes' you can enter for classes, methods, fields
* Finish 'Notes' page listing all notes, ability to go to class, method, field

## General MONO

* Nice to have single command to launch mono if it isn't already there in AA, no {$lua} required
* Nice to have static variables accessible as symbols (i.e. `mov rax, Class.StaticVariableName` then `mov eax, [rax]`)
* Way to reference certain overloaded methods
    * It should AT LEAST be possible to do it with a little LUA code in the script, instead of using AOB which is HORRIBLY slow (~10 seconds on my laptop for Raft)
    * Maybe something like 'ClassName.MethodName`2' or something
* Check out monoform_AddStaticClassField
    * and monoAA_GETMONOSTATICFIELDDATA(assemblyname, namespace, classname, fieldname, symclassname, false)

      local addrs = getAddressList()
      local classname=mono_class_getName(class)
      local namespace=mono_class_getNamespace(class)
      local assemblyname=mono_image_get_name(image)

    * hmmm... "if monopipe.il2cpp then return end" when 
* try registerAutoAssemblerCommand("GETMONOSTRUCT", monoAA_GETMONOSTRUCT)
* Interesting, seems like it just skips the . in the name
    name=name:match "^%s*(.-)%s*$"
    classname=classname:match "^%s*(.-)%s*$"
    namespace=namespace:match "^%s*(.-)%s*$"

    local class=mono_findClass(namespace, classname)
    if (class==nil) or (class==0) then
        return nil,translate("The class ")..namespace..":"..classname..translate(" could not be found")
    end
* can just pass class to mono_class_getStaticFieldAddress and itwill use domain = 0, which seems to work

## Wishlist

* Enum values - They are *usually* in order, starting at 0, but not always (i.e. CryingSuns)
