# Dock

`Dock:Update` is handy to hook...

## Structure

* 0028: state (0=empty, 1=removing, 2=deployed, 3=adding)
* 007C: timerPercent (set to 1.0 when deploying to make deployed)
* 0084: deployableType (0=squadron, 1=weapon, 2=officer)
* 0088: dockType (0=squadron, 1=weapon, 3-5= support squadron, weapon, hull)
* 0094: team (2=player, 3=enemy)

## Cheats

Good one is to hook Dock:Update and make things deploy quickly. 

* Check that team (+94) is 2 for player
* Check that state (+28) is 3 for adding
* Set timerPercent (+7C) to 1.0, it will then be fully deployed

Another one is to get at the battleship weapons and make them ready to use...

* Check that team (+94) is 2 for player
* Check that state (+28) is 2 for deployed
* Check that deployableType (+84) is 1 for weapon
* Load currentDeployable (+60) which should be `DeployableWeapon`
* 


## Enums

DeployableType:

* 0: squadron
* 1: weapon
* 2: officer

DockType:

* 0: squadron
* 1: weapon
* 3: supportSquadron
* 4: supportWeapon
* 5: supportHull
* officer
