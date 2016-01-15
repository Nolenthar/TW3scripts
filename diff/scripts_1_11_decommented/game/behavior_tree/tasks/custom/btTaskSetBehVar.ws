class CBTTaskSetBehVar extends IBehTreeTask
{
	var behVarName 		: name;
	var behVarValue		: float;
	var inAllBehGraphs	: bool;
	var onDeactivate	: bool;
	function OnActivate() : EBTNodeStatus
	{
		if( onDeactivate ) return BTNS_Active;
		GetNPC().SetBehaviorVariable( behVarName, behVarValue, inAllBehGraphs );
		return BTNS_Active;
	}
	function OnDeactivate()
	{
		if( onDeactivate )
		{
			GetNPC().SetBehaviorVariable( behVarName, behVarValue, inAllBehGraphs );
		}
	}
};
class CBTTaskSetBehVarDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskSetBehVar';
	editable var behVarName 	: CBehTreeValCName;
	editable var behVarValue	: CBehTreeValFloat;
	editable var inAllBehGraphs	: bool;
	editable var onDeactivate	: bool;
};
