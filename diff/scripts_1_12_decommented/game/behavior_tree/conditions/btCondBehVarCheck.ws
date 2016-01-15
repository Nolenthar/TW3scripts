class CBTCondBehVarCheck extends IBehTreeTask
{
	public var behVarName	: name;
	public var behVarValue	: int;
	function IsAvailable() : bool
	{
		var value : float = GetActor().GetBehaviorVariable( behVarName );
		return value == behVarValue;
	}
};
class CBTCondBehVarCheckDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'CBTCondBehVarCheck';
	editable var behVarName 	: name;
	editable var behVarValue 	: int;
};
