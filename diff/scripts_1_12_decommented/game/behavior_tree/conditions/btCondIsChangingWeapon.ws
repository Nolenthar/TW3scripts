class BTCondIsChangingWeapon extends IBehTreeTask
{
	private var storageHandler : CAIStorageHandler;
	protected var combatDataStorage : CHumanAICombatStorage;
	function IsAvailable() : bool
	{
		InitializeCombatDataStorage();
		return combatDataStorage.IsProcessingItems();
	}
	function InitializeCombatDataStorage()
	{
		if ( !combatDataStorage )
		{
			storageHandler = InitializeCombatStorage();
			combatDataStorage = (CHumanAICombatStorage)storageHandler.Get();
		}
	}
}
class BTCondIsChangingWeaponDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'BTCondIsChangingWeapon';
}
class BTCondDoesChangingWeaponRequiresIdle extends IBehTreeTask
{
	private var storageHandler : CAIStorageHandler;
	protected var combatDataStorage : CHumanAICombatStorage;
	function IsAvailable() : bool
	{
		InitializeCombatDataStorage();
		return combatDataStorage.DoesProcessingRequiresIdle();
	}
	function InitializeCombatDataStorage()
	{
		if ( !combatDataStorage )
		{
			storageHandler = InitializeCombatStorage();
			combatDataStorage = (CHumanAICombatStorage)storageHandler.Get();
		}
	}
}
class BTCondDoesChangingWeaponRequiresIdleDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'BTCondDoesChangingWeaponRequiresIdle';
}
