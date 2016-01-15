state FastTravel in W3TutorialManagerUIHandler extends TutHandlerBaseState
{
	private const var FAST_TRAVEL, INTERACTION : name;
		default INTERACTION = 'TutorialFastTravelInteraction';
		default FAST_TRAVEL = 'TutorialFastTravelHighlight';
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState(prevStateName);
		CloseHint(INTERACTION);
		theGame.GetTutorialSystem().MarkMessageAsSeen(INTERACTION);
		FactsAdd("tut_FT_interaction_finish");
		ShowHint(FAST_TRAVEL, 0.58f, 0.6f, ETHDT_Infinite);
	}
	event OnLeaveState( nextStateName : name )
	{
		CloseHint(FAST_TRAVEL);
		theGame.GetTutorialSystem().MarkMessageAsSeen(FAST_TRAVEL);
		super.OnLeaveState(nextStateName);
	}
}
exec function tut_ft()
{
	TutorialMessagesEnable(true);
	theGame.GetTutorialSystem().TutorialStart(false);
	TutorialScript('fast_travel', '');
}
