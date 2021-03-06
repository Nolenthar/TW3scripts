class CBTCondIsTargetInWater extends IBehTreeTask
{
	var boatCounts	: bool;
	function IsAvailable() : bool
	{
		if ( GetCombatTarget() == thePlayer )
		{
			if( boatCounts && thePlayer.IsSailing() )
			{
				return true;
			}
			return thePlayer.IsSwimming() || thePlayer.OnCheckDiving();
		}
		return GetCombatTarget().IsSwimming();
	}
};
class CBTCondIsTargetInWaterDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'CBTCondIsTargetInWater';
	editable var boatCounts	: bool;
	default boatCounts = true;
	hint boatCounts = "Is being on a boat considered as being in water?";
};
class CBTCondIsTargetUnderwater extends IBehTreeTask
{
	function IsAvailable() : bool
	{
		if ( GetCombatTarget() == thePlayer )
		{
			return thePlayer.OnCheckDiving();
		}
		return false;
	}
};
class CBTCondIsTargetUnderwaterDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'CBTCondIsTargetUnderwater';
};
