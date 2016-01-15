class BTCondIsGuarded extends IBehTreeTask
{
	function IsAvailable() : bool
	{
		return GetActor().IsGuarded();
	}
}
class BTCondIsGuardedDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'BTCondIsGuarded';
}
class BTCondIsTargetGuarded extends IBehTreeTask
{
	function IsAvailable() : bool
	{
		return GetCombatTarget().IsGuarded();
	}
}
class BTCondIsTargetGuardedDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'BTCondIsTargetGuarded';
}
