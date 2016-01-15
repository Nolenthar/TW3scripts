state HighLevelQuests in W3TutorialManagerUIHandler extends TutHandlerBaseState
{
	private const var DESCRIPTION : name;
	private var isClosing : bool;
		default DESCRIPTION = 'TutorialHighLevelQuests';
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState(prevStateName);
		isClosing = false;
		ShowHint(DESCRIPTION, 0.3, 0.6, ETHDT_Input);
	}
	event OnLeaveState( nextStateName : name )
	{
		isClosing = true;
		CloseHint(DESCRIPTION);
		theGame.GetTutorialSystem().MarkMessageAsSeen(DESCRIPTION);
		super.OnLeaveState(nextStateName);
	}
}
