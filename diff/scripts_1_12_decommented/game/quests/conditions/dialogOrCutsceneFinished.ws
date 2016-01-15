class W3QuestCond_DialogOrCutsceneFinished extends CQuestScriptedCondition
{
	editable var inverted		: bool;
	function Evaluate() : bool
	{
		if ( inverted )
		{
			return theGame.IsDialogOrCutscenePlaying();
		}
		return !theGame.IsDialogOrCutscenePlaying();
	}
}
