Looking at Raft, I found myself doing the same thing a lot during initial investigation:

* Hook Function
* Add global alloc for temp variable
* Add code to push rax, mov global ref to rax, store rcx (and other parms) at rax along with counter, pop rax
* Save script as table entry
* Activate table entry
* Add variables for RCX, Counter, and any params as children to script

For investigations like this it would be SUPER handy to have a one or two click method for doing this.

### Ideas:

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
## Wishlist
* Enum values - They are *usually* in order, starting at 0, but not always (i.e. CryingSuns)
