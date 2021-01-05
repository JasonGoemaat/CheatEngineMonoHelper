# Mono Structures

Several structures are seen over and over.  CE doesn't seem to get their structures quite right.

## Array<type>

An example is in Crying Suns `BattleshipState` at offset 00F8 we have:

    CryingSuns.Fight.DeployableWeapon[] <DeployableWeapons>k__BackingField

The structure doesn't match what CE shows:

* 0018 - Count
* 0020+ - items (8 bytes each)


## List<type>

A generic list, for example Crying Suns has BattleshipState with at +E8:

    System.Collections.Generic.IList`1[CryingSuns.PlayerStatus.BattleshipWeaponState] weapons

The list itself:

* 0010 - _items - Array<type> with possibly some empty elements
* 0018 - _size - current number of items
* 001C - _version - possibly updated when underlying array is changed due to size change

_items is then a simple array with count (including empty slots) at +18 and items starting at +_20
