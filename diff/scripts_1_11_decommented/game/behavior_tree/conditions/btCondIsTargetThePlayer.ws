class CBTCondIsTargetThePlayer extends IBehTreeTask
{
	public var useCombatTarget : bool;
	function IsAvailable() : bool
	{
		return GetTarget() == thePlayer;
	}
	function GetTarget() : CActor
	{
		if ( useCombatTarget )
			return GetCombatTarget();
		else
			return (CActor)GetActionTarget();
	}
};
class CBTCondIsTargetThePlayerDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'CBTCondIsTargetThePlayer';
	editable var useCombatTarget : bool;
	default useCombatTarget = true;
};
