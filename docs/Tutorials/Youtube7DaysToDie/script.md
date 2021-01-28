# Video 1

## Tools
  
* Cheat Engine
* IL Spy
* dnSpy

> Show web site for dnSpy, download into O:\Tutorial and extract into O:\Tutorial\dnSpy, open

> Open 7 days to die game files (Steam->Local files or from Launcher, or just path to assemblies in explorer?)
> Then do quick look around of classes, search for 'Player', check out PlayerEntity:Update

> Show cheat engine page, patreon, how to download, why to use patreon

> Show MonoHelper site, open script, create table entry with `{$lua}` and script (ALTERNATIVE:
> download table with Mono Helper as a table entry)

> Switch to Game to show it's running, open EXE with CE

> Show mono menu, maybe quick look at finding EntityPlayer

> Run Mono Helper script, use 'Search' menu, explain about opening 'Assembly-CSharp' by default and
> show 'Image' menu, open 'EntityPlayer' class

> Show 'Update' method, explain why it's a good thing, use double-click, use each menu option, finally
> one that creates a table entry.

> Examine script, explain what the extra code is, parameters, link to Win64 ABI

> Activate script, show that values are updated

> Open structure dissector with address to examine EntityPlayer


NOTE: Check out GetBlockActivationCommands for possibly unlocking doors
Possibly 'OnBlockActivated':

		TileEntitySecureDoor tileEntitySecureDoor = (TileEntitySecureDoor)_world.GetTileEntity(_cIdx, _blockPos);
		if (tileEntitySecureDoor == null && !_world.IsEditor())
		{
			return false;
		}
		bool flag = (!_world.IsEditor()) ? tileEntitySecureDoor.IsLocked() : ((_blockValue.meta & 4) > 0);
		bool flag2 = !_world.IsEditor() && tileEntitySecureDoor.IsUserAllowed(GamePrefs.GetString(EnumGamePrefs.PlayerId));
		switch (_indexInBlockActivationCommands)

Can we do the same call to GetTileEntity and set IsLocked() to false?
It looks like the function is called, but is it really?
Also checks IsUserAllowed()
