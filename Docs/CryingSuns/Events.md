# Events

I found `EventsConfiguration` which seems promising.   There's a ship aux system
that turns 50/50 events into 100% positive so there has to be something somewhere.

### EventsConfiguration

* 28 - anomalyNegative (single)
* 24 - anomalyPolice (single)
* 2c - anomalyPositive (single)
* 20 - anomalyforcedFightPercent (single)
* **58 - riskySuccessChance**

### BattleshipState

This has `HasAuxiliarySystemType(type)` which might be hacked for player (Team at +148 is '2')
to always return true?

Types:

* BattleshipWeaponImmunity
* Boomer
* CineticCharger
* PirateTransponder
* PreIgniter
* QuarksCoolingSystem
* QuickUndeployer
* RepairDrones
* **RiskyWinner - probably the 100% one**
* ScrapRecovery
* ScrapperDeployer
* StealthEngine
* TacticalLogs
