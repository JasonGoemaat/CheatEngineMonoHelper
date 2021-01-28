# 7 Days to Die Turotial

## Setup

### ILSpy is awesome

[Download ILSpy](https://github.com/icsharpcode/ILSpy/releases), it's pretty
awesome.  don't know about the vsi, I downloaded the binaries zip, unzipped
it into `O:\apps\ILSpy`, opened that directory, right-clicked on the `ILSpy.exe`
and created a shortcut, then added that shortcut to my start menu.

You can now open ILSpy either with the exe, the shortcut, or now it's on
your start page.  I removed the assemblies that were lisetd, and loaded
`Assembly-CSharp.dll` from where it was installed with my game:

    O:\Games\Steam\steamapps\common\7 Days To Die\7DaysToDie_Data\Managed

ILSpy decompiles the source code.  It really helps understanding the assembly
code to look at the method sources.

### Make sure MonoHelper is loaded

You need [Release](../../Releases) 1.2.0 at least for some of the functionality
I'll be using.  You can add the LUA script to your CE autorun directory, make
it your table script, or add it in an AA script in a `{$lua}` section.  The
script does NOT need to be included with your table, the scripts it generates
work without it.  This will add the 'Search' action under the 'Mono' menu that
appears when you attach to a game that uses Mono.

## Investigating

I'm starting with knowledge of what I want to hook.  Doing investigation before
I found a method `XUiC_ItemStack.HandleDropOne()` which is sounds pretty
interesting.  What I want to do is make it increase the number of items
we have.  I'd like to make it drop a full stack instead of just one.

Search for 'dropone' in ILSpy and you'll see this method:

```c#
// XUiC_ItemStack
using Audio;

protected virtual void HandleDropOne()
{
	ItemStack currentStack = base.xui.dragAndDrop.CurrentStack;
	if (!currentStack.IsEmpty())
	{
		int num = 1;
		if (this.itemStack.IsEmpty())
		{
			ItemStack itemStack = currentStack.Clone();
			itemStack.count = num;
			currentStack.count -= num;
			base.xui.dragAndDrop.CurrentStack = currentStack;
			ItemStack = itemStack;
			if (placeSound != null)
			{
				Manager.PlayXUiSound(placeSound, 0.75f);
			}
		}
		else if (currentStack.itemValue.type == this.itemStack.itemValue.type)
		{
			int value = currentStack.itemValue.ItemClass.Stacknumber.Value;
			if (this.itemStack.count + 1 <= value)
			{
				ItemStack itemStack2 = this.itemStack.Clone();
```

This looks like it would be a nice place to hook.  It would be nice to have it
drop a full stack and not take any from the stack we have (or make it full
as well), but that would involve getting deeper into the code than I'd like.

What's super easy is injecting at the start of a method and just using
the point to the instance that is in rcx or using or altering one of the
parameters to perform a cheat.

So open up CE, attach to the game, make sure you've run the MonoHelper script,
and do `Mono->Search`.  Enter 'dropone' in the search box and double-click
on the method we want (the one on XUiC_ItemStack, not XUiC_RequiredItemStack).
This will open the class window.

Note that at Offset A8 is a field naed 'itemStack of type 'ItemStack'.  From
looking at the C# code above, this appears to be the target of the drop, not
the stack that is being held, which is 'currentStack' in the code above.

'currentStack' is found by looking at `base.xui.dragAndDrop.CurrentStack`
Click on 'Options -> Include Inherited' to show inherited fields and methods.
Near the top is a field named `<xui>k__BackingField` at Offset 90.  This weird
naming common for some fields, I'm not 100% sure why, but it seems to be
renamed like that if it's a property wit hgeters and setters, but not all the
time.

Now click on the 'Methods' tab and find `HandleDropOne`.  This is the method
we want to hook.  Right-click on it and select the third option,
`Create Table Script`.  This should create a new table entry with the
description `XUiC_ItemStack:HandleDropOne`.  If you activate it you will see
an entry for `pXUiC_ItemStack_HandleDropOne` which we be a pointer to the
last `XUiC_ItemStack` the method was called on.  There's also a `Counter`
memory record showing you how many times it's been called.

Open the script to see the source:

```asm
define(hook,"XUiC_ItemStack:HandleDropOne")
define(bytes,55 48 8B EC 48 83 EC 70)

[enable]

assert(hook, bytes)
alloc(newmem,$1000, hook)
label(pXUiC_ItemStack_HandleDropOne)

{
  RCX: XUiC_ItemStack (this)

  Returns (RAX) System.Void
}

newmem:
  // increment counter, store instance and parameters (could be off for static method?)
  push rax
  mov [pXUiC_ItemStack_HandleDropOne], rcx
  inc dword ptr [pXUiC_ItemStack_HandleDropOne+8]
  pop rax

  // original code
  push rbp
  mov rbp,rsp
  sub rsp,70
  jmp hook+8

align 10
pXUiC_ItemStack_HandleDropOne:
  dq 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

hook:
  jmp newmem

registersymbol(pXUiC_ItemStack_HandleDropOne)

[disable]

hook:
  db bytes

unregistersymbol(pXUiC_ItemStack_HandleDropOne)

dealloc(newmem)
```

Let's do some analysis of the assemblyin the actual method.  Right-click on
the method in the Class window again and select 'Disassemble'.  If you've
activated the table entry, you'll see the jmp to the new ode and then the rest
of the method:

```
XUiC_ItemStack:HandleDropOne - E9 5B05ECE5           - jmp 1F39B5C0000
XUiC_ItemStack:HandleDropOne+5- 83 EC 70              - sub esp,70
XUiC_ItemStack:HandleDropOne+8- 48 89 75 D8           - mov [rbp-28],rsi
XUiC_ItemStack:HandleDropOne+c- 48 89 7D E0           - mov [rbp-20],rdi
XUiC_ItemStack:HandleDropOne+10- 4C 89 65 E8           - mov [rbp-18],r12
XUiC_ItemStack:HandleDropOne+14- 4C 89 6D F0           - mov [rbp-10],r13
XUiC_ItemStack:HandleDropOne+18- 4C 89 7D F8           - mov [rbp-08],r15
XUiC_ItemStack:HandleDropOne+1c- 48 8B F1              - mov rsi,rcx
XUiC_ItemStack:HandleDropOne+1f- 48 8B 86 90000000     - mov rax,[rsi+00000090]
XUiC_ItemStack:HandleDropOne+26- 48 8B C8              - mov rcx,rax
XUiC_ItemStack:HandleDropOne+29- 83 39 00              - cmp dword ptr [rcx],00
XUiC_ItemStack:HandleDropOne+2c- 48 8B 80 50010000     - mov rax,[rax+00000150]
XUiC_ItemStack:HandleDropOne+33- 48 8B C8              - mov rcx,rax
XUiC_ItemStack:HandleDropOne+36- 83 39 00              - cmp dword ptr [rcx],00
XUiC_ItemStack:HandleDropOne+39- 4C 8B A0 B0000000     - mov r12,[rax+000000B0]
XUiC_ItemStack:HandleDropOne+40- 49 8B C4              - mov rax,r12
XUiC_ItemStack:HandleDropOne+43- 48 8B C8              - mov rcx,rax
XUiC_ItemStack:HandleDropOne+46- 83 38 00              - cmp dword ptr [rax],00
XUiC_ItemStack:HandleDropOne+49- 48 8D 64 24 00        - lea rsp,[rsp+00]
XUiC_ItemStack:HandleDropOne+4e- 49 BB 4B9FA2B5F3010000 - mov r11,000001F3B5A29F4B
XUiC_ItemStack:HandleDropOne+58- 41 FF D3              - call r11
```

If you know the windows x64 calling conventions (or read the comment near the
top of the generated script), you know that `rcx` starts off as the instance
of `XUiC_ItemStack` the method is being executed on.  We have this section
of code pretty early:

```
mov rsi,rcx
mov rax,[rsi+00000090]
mov rcx,rax
cmp dword ptr [rcx],00
mov rax,[rax+00000150]
mov rcx,rax
cmp dword ptr [rcx],00
mov r12,[rax+000000B0]
```

It moves the XUiC_ItemStack pointer to rsi and loads rax and cx with what's
at offset 90, which we know from looking at the Class window is 
`<xui>k__BackingField`.  It then loads rax with `[rax+150]`.  If we look
at the type 'XUi', offset 150 is type `XUiC_DragAndDropWindow` and is
named `<dragAndDrop>k__BackingField`.  This is `base.xui.dragAndDrop`
in the source code.  The next th ing it does is load r12 with what's
at `[rax+b0]`.  I bet you can figure out what that does just looking at the
source:

```c#
ItemStack currentStack = base.xui.dragAndDrop.CurrentStack;
```

So rax is at that point `base.xui.dragAndDrop`, so r12 is now
`base.xui.dragAndDrop.CurrentStack`.  Remember, that seems to be the stack we
are currently *holding*, and `itemStack` is the stack we're dropping onto.