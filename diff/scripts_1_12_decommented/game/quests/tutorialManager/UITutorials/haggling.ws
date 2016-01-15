state Haggling in W3TutorialManagerUIHandler extends TutHandlerBaseState
{
	private const var DESCRIPTION : name;
	private var isClosing : bool;
		default DESCRIPTION = 'TutorialHaggling';
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState(prevStateName);
		isClosing = false;
		ShowHint(DESCRIPTION, 0.7, 0.3, , , true);
	}
	event OnLeaveState( nextStateName : name )
	{
		isClosing = true;
		CloseHint(DESCRIPTION);
		theGame.GetTutorialSystem().MarkMessageAsSeen(DESCRIPTION);
		super.OnLeaveState(nextStateName);
	}
}
