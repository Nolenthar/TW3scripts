class CBTTaskStopEffectIfActive extends IBehTreeTask
{
	var npc					: CNewNPC;
	var effectName			: name;
	var onActivate			: bool;
	var onDeactivate		: bool;
	function OnActivate() : EBTNodeStatus
	{
		if( onActivate )
		{
			npc = GetNPC();
			npc.StopEffectIfActive(	effectName );
		}
		return BTNS_Active;
	}
	function OnDeactivate()
	{
		if( onDeactivate )
		{
			npc = GetNPC();
			npc.StopEffectIfActive(	effectName );
		}
	}
}
class CBTTaskStopEffectIfActiveDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskStopEffectIfActive';
	editable var effectName			: name;
	editable var onActivate			: bool;
	editable var onDeactivate		: bool;
}
class CBTTaskIsEffectActive extends IBehTreeTask
{
	var npc					: CNewNPC;
	var effectName			: name;
	function IsAvailable() : bool
	{
		npc = GetNPC();
		return npc.IsEffectActive( effectName );
	}
}
class CBTTaskIsEffectActiveDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskIsEffectActive';
	var npc							: CNewNPC;
	editable var effectName			: name;
}
