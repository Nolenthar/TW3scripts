class CBTCondHasTag extends IBehTreeTask
{
	public var tag		: name;
	function IsAvailable() : bool
	{
		return GetActor().HasTag( tag );
	}
};
class CBTCondHasTagDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'CBTCondHasTag';
	editable var tag		: name;
};
