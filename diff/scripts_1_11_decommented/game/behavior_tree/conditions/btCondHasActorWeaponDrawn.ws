class CBTCondHasActorWeaponDrawn extends IBehTreeTask
{
	function IsAvailable() : bool
	{
		var actor : CActor = GetActor();
		if( actor.HasWeaponDrawn( false ) )
		{
			return true;
		}
		return false;
	}
};
class CBTCondHasActorWeaponDrawnDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'CBTCondHasActorWeaponDrawn';
};
