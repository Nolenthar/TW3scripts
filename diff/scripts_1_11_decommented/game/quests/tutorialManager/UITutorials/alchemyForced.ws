state ForcedAlchemy in W3TutorialManagerUIHandler extends TutHandlerBaseState
{
	private const var ALCHEMY_GO_TO : name;
		default ALCHEMY_GO_TO = 'TutorialAlchemyForcedEnterAlchemy';
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState(prevStateName);
		theGame.GetTutorialSystem().uiHandler.LockCloseUIPanels(true);
		CloseHint('TutorialAlchemyForcedOpenMenu');
		ShowHint(ALCHEMY_GO_TO, 0.35f, 0.6f, ETHDT_Infinite);
		thePlayer.inv.RemoveItemByName('Thunderbolt 1', -1);
	}
	event OnLeaveState( nextStateName : name )
	{
		CloseHint(ALCHEMY_GO_TO);
		super.OnLeaveState(nextStateName);
	}
}
