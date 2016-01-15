class W3QuestCond_NpcStance extends CQCActorScriptedCondition
{
	editable var stance 	: ENpcStance;
	function Evaluate( act : CActor ) : bool
	{
		var l_result		: bool;
		var l_npc			: CNewNPC;
		l_npc = (CNewNPC) act;
		if( !l_npc ) return false;
		l_result = ( l_npc.GetCurrentStance() == stance );
		return l_result;
	}
}
