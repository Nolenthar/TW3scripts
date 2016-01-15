class W3QuestCond_TutorialIsInitialized extends CQuestScriptedCondition
{
	function Evaluate() : bool
	{
		return theGame.GetTutorialSystem() && theGame.GetTutorialSystem().IsRunning();
	}
}
