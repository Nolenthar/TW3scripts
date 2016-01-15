class CBTCondAppearanceName extends IBehTreeTask
{
	var appearanceName : name;
	function IsAvailable() : bool
	{
		var owner : CActor = GetActor();
		var currentAppearance : name;
		currentAppearance = owner.GetAppearance();
		if( currentAppearance == appearanceName )
		{
			return true;
		}
		else
		{
			return false;
		}
	}
};
class CBTCondAppearanceNameDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'CBTCondAppearanceName';
	editable var appearanceName : name;
};
