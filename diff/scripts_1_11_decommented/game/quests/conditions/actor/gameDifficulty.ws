class W3QuestCond_gameDifficulty extends CQuestScriptedCondition
{
	editable var targetDifficulty : EDifficultyMode;
	function Evaluate() : bool
	{
		if(theGame.GetDifficultyMode() == targetDifficulty)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}
