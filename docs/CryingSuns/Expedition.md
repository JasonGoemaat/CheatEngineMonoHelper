[README.md](Home)

## Expedition

An Expedition is when you go to the planet.  An officer and group of commandos goes
from step to step and encounters various 'ExpedictionSituation's.   Some of these have
officer skills that can be used, it would be nice to be able to resolve each
situation successfully.

### ExpeditionSituation

I tried just returning 1 from `get_HasSkillToResolve()`, but that didn't work.  I think
you'd need to override the other three, which is a problem because those skills need
to be returned and I don't know how without having them.  It's possible that
they could be fetched from the result of get_ExpectedOfficerSkills()?  Oh, I see....
`OfficerSkill` is just an enum, so maybe it's possible...

* bool get_HasSkillToResolve() - tried this, but doesn't work
* bool HasAtLeastOneSkillAndGetIt(OfficerState, OfficerSkill& _skillTested)
* bool HasSkillAtStepAndGetIt(OfficerState, int _stepIndex, OfficerSkill& _skillTested)
* bool HasSkillAtStepAndGetIt(OfficerState, int _stepIndex, int _skillByStep, OfficerSkill& _skillTested)
* void RememberCommandoStates (ExpeditionProgress)
* List<OfficerSkill> get_ExpectedOfficerSkills

### OfficerSkill

* Demolition
* Hack
* Persuasion
* Piloting
* SharpSenses
* Fight
* Engineering
* Erudition
* Discretion

### ExpeditionSituationStepResult

* 0010 - ExpeditionSituation (ExpeditionSituation)
* 0018 - OutcomeResult (OutcomeResult)
* 0030 - TestedSkill (System.Nullable[OfficerSkill])
* 0038 - SituationResultType (SituationResultType)
* 003C - InjuriesAmount
* 0040 - WasOvercome (Boolean)
* 0044 - InjuredCommandoAmount
* 0048 - DiedCommandoAmount
* 004C - OfficerIsOutOfCombat (Boolean)
* 0050 - OfficerInjuriesAmount
* 0054 - HasResolvedSituation (Boolean)

* 0048 - DiedCommandoAmount


### SituationResultType

* Failure (0?)
* Success (1?)
* Neutral (2?)

### ExpeditionProgress


## Enum: ExpeditionSituationType

* Artefact
* Predicament
* Treasure
* Final
* Danger
