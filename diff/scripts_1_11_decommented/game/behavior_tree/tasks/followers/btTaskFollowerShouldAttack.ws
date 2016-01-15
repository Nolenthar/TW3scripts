class CBTTasFollowerShouldAttack extends IBehTreeTask
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
		if ( combatDataStorage.IsAFollower() && GetCombatTarget() != thePlayer.GetTarget() )
			return true;
		return combatDataStorage.ShouldAttack( GetLocalTime() );
	}
	function OnActivate() : EBTNodeStatus
	{
		return BTNS_Active;
	}
}
class CBTTasFollowerShouldAttackDef extends IBehTreeFollowerTaskDefinition
{
	default instanceClass = 'CBTTasFollowerShouldAttack';
}
