state CraftingSet in W3TutorialManagerUIHandler extends TutHandlerBaseState
{
	private const var SET : name;
		default SET	= 'TutorialCraftingSets';
	event OnLeaveState( nextStateName : name )
	{
		CloseHint(SET);
		if(theGame.GetTutorialSystem().HasSeenTutorial(SET))
			super.OnLeaveState(nextStateName);
	}
	event OnCraftedSetItem()
	{
		ShowHint(SET, theGame.params.TUT_POS_ALCHEMY_X, theGame.params.TUT_POS_ALCHEMY_Y, ETHDT_Input);
		theGame.GetTutorialSystem().MarkMessageAsSeen(SET);
	}
}
