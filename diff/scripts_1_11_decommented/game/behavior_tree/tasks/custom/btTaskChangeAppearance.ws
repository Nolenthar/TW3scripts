class CBTTaskChangeAppearance extends IBehTreeTask
{
	public var appearanceName		: name;
	public var onActivate 			: bool;
	public var onDectivate 		: bool;
	function OnActivate() : EBTNodeStatus
	{
		if ( onActivate )
		{
			GetActor().SetAppearance(appearanceName);
		}
		return BTNS_Active;
	}
	function OnDeactivate()
	{
		if ( onDectivate )
		{
			GetActor().SetAppearance(appearanceName);
		}
	}
}
class CBTTaskChangeAppearanceDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskChangeAppearance';
	editable var appearanceName		: name;
	editable var onActivate 		: bool;
	editable var onDectivate 		: bool;
}
