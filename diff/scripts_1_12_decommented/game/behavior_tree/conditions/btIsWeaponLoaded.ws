class CBTCondIsWeaponLoaded extends IBehTreeTask
{
	private var storageHandler : CAIStorageHandler;
	protected var combatDataStorage : CHumanAICombatStorage;
	function IsAvailable() : bool
	{
		if( combatDataStorage.GetProjectile() || combatDataStorage.ReturnWeaponSubTypeForActiveCombatStyle() == 0 )
		{
			return true;
		}
		return false;
	}
	function Initialize()
	{
		storageHandler = InitializeCombatStorage();
		combatDataStorage = (CHumanAICombatStorage)storageHandler.Get();
	}
};
class CBTCondIsWeaponLoadedDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'CBTCondIsWeaponLoaded';
};
