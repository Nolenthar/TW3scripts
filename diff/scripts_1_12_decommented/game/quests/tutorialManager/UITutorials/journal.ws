state JournalQuest in W3TutorialManagerUIHandler extends TutHandlerBaseState
{
	private const var TUTORIAL : name;
		default TUTORIAL = 'TutorialJournalQuests';
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState(prevStateName);
		ShowHint(TUTORIAL, 0.3, 0.6, ETHDT_Infinite);
	}
	event OnLeaveState( nextStateName : name )
	{
		CloseHint(TUTORIAL);
		super.OnLeaveState(nextStateName);
	}
	event OnMenuClosing(menuName : name)
	{
		if(menuName == 'JournalQuestMenu')
			QuitState();
	}
}
exec function jour()
{
	TutorialMessagesEnable(true);
	theGame.GetTutorialSystem().TutorialStart(false);
	TutorialScript('journal', '');
}
