class CBTTaskShouldBecomeAFollower extends IBehTreeTask
{
	protected var storageHandler : CAIStorageHandler;
	protected var combatDataStorage : CHumanAICombatStorage;
	function Initialize()
	{
		storageHandler = InitializeCombatStorage();
		combatDataStorage = (CHumanAICombatStorage)storageHandler.Get();
	}
	function OnActivate() : EBTNodeStatus
	{
		if ( GetActor().HasTag(theGame.params.TAG_NPC_IN_PARTY) )
			combatDataStorage.BecomeAFollower();
		else
			combatDataStorage.NoLongerFollowing();
		return BTNS_Active;
	}
}
class CBTTaskShouldBecomeAFollowerDef extends IBehTreeFollowerTaskDefinition
{
	default instanceClass = 'CBTTaskShouldBecomeAFollower';
}
