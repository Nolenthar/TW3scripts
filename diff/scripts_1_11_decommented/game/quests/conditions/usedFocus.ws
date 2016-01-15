class W3QuestCond_UsedFocus extends CQuestScriptedCondition
{
	editable var inverted : bool;
	editable var duration : float;
	default duration = 0.0f;
	saved var timeStart : float;
	default timeStart 	= 0.0f;
	function Evaluate() : bool
	{
		if ( IsInUse() )
		{
			if ( timeStart == 0.0f )
			{
				timeStart = theGame.GetEngineTimeAsSeconds();
			}
			if ( theGame.GetEngineTimeAsSeconds() - timeStart >= duration )
			{
				return true;
			}
		}
		else
		{
			timeStart = 0.0f;
		}
		return false;
	}
	private function IsInUse() : bool
	{
		if ( inverted )
		{
			return !theGame.IsFocusModeActive();
		}
		return theGame.IsFocusModeActive();
	}
}
