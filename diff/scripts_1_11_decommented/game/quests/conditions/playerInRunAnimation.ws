class W3QuestCond_PlayerInRunAnimation extends CQuestScriptedCondition
{
	function Evaluate() : bool
	{
		return thePlayer.IsInRunAnimation();
	}
}
