[README.md](Home)

## Battle

Battle is quite complicated.  You have the `Battleship` for each side, and
various `HexCellObject`.  Plus weapons can be on the battleship or on a
`HCOSquadron` (HexCellObject Squadron).  Then you have `DeployableWeapon`.

### Battlefield

* STATIC (10) instance (Battlefield)
* 0070 - EnemyBattleship (BattleshipStateForFight)
* 0078 - PlayerBattleship (BattleshipStateForFight)
* 00E0 - CurrentFightState (FightState)
* Update(single _time)

### BattleshipStateForFight

* **0040 - BattleshipState**
* 00A0 - fightLifeState (LifeState enum - high, low)

### BattleshipState

> Could loop through 

* 0148 - Team (2=player, 3=enemy)
* 00B8 - DeployableSquadrons (DeployableSquadron[])
* 00F8 - DeployableWeapons (DeployableWeapon[])
* 013C - FuelMax (float)
* 0140 - StructuresLife (float)
* 00A0 - battleshipLife (BattleshipLife)
* 00E0 - deployableOfficers (DeployableOfficer[])
* 00D8 - officers (List<PlayerStatus.OfficerState>)
* 00B0 - squadronDocks (List<Fight.Dock>)
* 00A8 - squadrons (List<PlayerStatus.SquadronState)>)
* 00F0 - weaponDocks (List<Fight.Dock)>) - change enemy state (+28) to 1 to make them undeploy, change mine to 2 to make it deployed, 0 would be undeployed and 3 would be deployign and have to change timer at +7C to 1.0), team is at +94 (2 is good)
* 00E8 - weapons (List<BattleshipWeaponState>)

### BattleshipWeaponState (inherited from FleetUnitState) - mostly useless, just changes from in and out of combat

* 0028 - battleship (BattleshipState)

### Dock

(Battlefield.instance.PlayerBattleship(+78).BattleshipState(+40).weaponDocks(+F0))

0028 - (BYTE) State (2 = deployed, 3 = deploying), 1 = undeploying, 0 = empty)

### DeployableWeapon

* 0030 - LinkedDock
    * 0078 timerDuration (3.0)
    * 0080 timerPercent (0.25163) - setting to 1.0 completes it
* 0038 - hovered (BOOL)
* 00A0 - selected (BOOL)

### Weapon

* 0048 - deployableWeapon
* 00E0 - Owner (IFleetMember) - could be different types?
    * (if battleship weapon)
        * 0040 - BattleshipState



### IFleetMember

* get_type() returns FleetMemberType (Battleship or Squadron)


### HCOSquadron

* 0028 - State (4 = battle over?)
* 0080 - abilities
    * 0020 - hco (pointer back to HCOSquadron)
    * 0028 - abilities
        * 0010 - _items
            * 0020 - Item[2] (actually first item)
                * 0018 - hco (pointer back to HCOSquadron)
                * 0020 - kind (1?)
                * 0028 - timer (should be 0)
                * 002C - isActive
        * 0018 - size (count)
    * 0030 - TimedAbility (same as Item[2] above - the first ability, could be used to make them more active?)
* 0088 - Definition (possibly shared, don't over-use, perhaps copy?  but need to alloc in GC area...  change to another?
    * 0018 - id
        * 0010 - Length
        * 0014 - Value (this is the start of the string, i.e. '"frigate-mk2-prototype"`), could be used to seaparate drones, frigates, etc.
    * 0030 - skirmishWeapon
    * 0048 - rangedWeapon
    * 0050 - life (i.e. 110.0)
* 0090 - SkirmishWeapon
    * 0048 - deployableWeapon (NULL for frigate weapon)
    * 00E0 - Owner (poitner back to HCOSquadron)
    * 0108 - DamageFactor (1.0, maybe update?)
    * 010C - baseAimingDuration (0.0)
    * 0110 - baseFireBySeconds (1.0)
    * 0114 - BaseTimeLeftBeforeWeaponCooled (1.0)
    * 0118 - BaseTimeLeftBeforeAimOk (0.0)
    * 011C - ReadyAtTime (2036.8?)
    * 0124 - Range (1.0)
* 00A8 - HcoTypeKey (+10 = Length (21), +14 is start of string 'frigate-mk2-prototype'))
* 0143 - canBeAttacked (BYTE (boolean) = 1, possibly set to 0?)
* 0148 - LifeMax (110.0)
* 014C - RealLifeMax (0.0?)
* 0160 - selected (BYTE or bool 0)
* 0164 - life (110.0)
* 01D0 - Team (2 = player, 3 = enemy)

