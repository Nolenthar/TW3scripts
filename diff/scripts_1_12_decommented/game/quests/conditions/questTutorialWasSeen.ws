class W3QuestCond_TutorialWasSeen extends CQuestScriptedCondition
{
	editable var tutorialScriptTag : name;
	function Evaluate() : bool
	{
		if(theGame.GetTutorialSystem() && theGame.GetTutorialSystem().IsRunning())
			return theGame.GetTutorialSystem().HasSeenTutorial(tutorialScriptTag);
		return false;
	}
}
