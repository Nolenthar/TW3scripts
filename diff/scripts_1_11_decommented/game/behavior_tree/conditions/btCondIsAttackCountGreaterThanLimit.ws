class CBTCondIsAttackCountGreaterThanLimit extends IBehTreeTask
{
	private var storageHandler : CAIStorageHandler;
	protected var combatDataStorage : CExtendedAICombatStorage;
	public var attackCountLimit		: int;
	public var attackName			: name;
	function IsAvailable() : bool
	{
		var attackCount : int;
		attackCount = combatDataStorage.GetAttackCount( attackName );
		if ( combatDataStorage.GetAttackCount( attackName ) >= attackCountLimit )
			return true;
		else
			return false;
	}
	function Initialize()
	{
		storageHandler = InitializeCombatStorage();
		combatDataStorage = (CExtendedAICombatStorage)storageHandler.Get();
	}
};
class CBTCondIsAttackCountGreaterThanLimitDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'CBTCondIsAttackCountGreaterThanLimit';
	editable var attackName				: name;
	editable var attackCountLimit		: int;
	default attackName = '';
	default attackCountLimit = 0;
};
class CBTModifyAttackCount extends IBehTreeTask
{
	private var storageHandler : CAIStorageHandler;
	protected var combatDataStorage : CExtendedAICombatStorage;
	public var attackName			: name;
	public var resetAttackCount		: bool;
	public var incrementAttackCount : bool;
	function IsAvailable() : bool
	{
		return true;
	}
	latent function Main() : EBTNodeStatus
	{
		if ( incrementAttackCount )
			combatDataStorage.IncrementAttackCount( attackName );
		if ( resetAttackCount )
			combatDataStorage.ClearAttackCount( attackName );
		return BTNS_Completed;
	}
	function Initialize()
	{
		storageHandler = InitializeCombatStorage();
		combatDataStorage = (CExtendedAICombatStorage)storageHandler.Get();
	}
};
class CBTModifyAttackCountDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'CBTModifyAttackCount';
	editable var attackName				: name;
	editable var incrementAttackCount	: bool;
	editable var resetAttackCount		: bool;
	default attackName = '';
	default incrementAttackCount = false;
	default resetAttackCount = false;
};