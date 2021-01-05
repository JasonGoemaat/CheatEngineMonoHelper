First, we can find `Battlefield.instance` or hook `Update(time)` or hook `Pause()`
Battlefield has:

* 0070 - EnemyBattleship (BattleshipStateForFight)
* 0078 - PlayerBattleship (BattleshipStateForFight)

BattleshipStateForFight can hook `Update(time)`, `TakeDamages(amount, source)`

* get_Team() - +40 (BattleshipState) then +148

* 0040 - BattleshipState

BattleshipState has cool stuff, like weapons (+E8)...

* 00E8 - weapons (List<BattleshipWeaponState>)
* 00F0 - weaponDocks (List<Dock>)

### WeaponDocks

So we have Battle
