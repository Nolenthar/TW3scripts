class CBTTasFollowerShouldKeepDistanceToPlayer extends IBehTreeTask
{
	protected var storageHandler : CAIStorageHandler;
	protected var combatDataStorage : CHumanAICombatStorage;
	function Initialize()
	{
		storageHandler = InitializeCombatStorage();
		combatDataStorage = (CHumanAICombatStorage)storageHandler.Get();
	}
	function IsAvailable() : bool
	{
		if ( combatDataStorage.ShouldKeepDistanceToPlayer() )
		{
			if ( GetActionTarget() != thePlayer )
				SetActionTarget(thePlayer);
			return true;
		}
		return false;
	}
	function OnActivate() : EBTNodeStatus
	{
		return BTNS_Active;
	}
}
class CBTTasFollowerShouldKeepDistanceToPlayerDef extends IBehTreeFollowerTaskDefinition
{
	default instanceClass = 'CBTTasFollowerShouldKeepDistanceToPlayer';
}
