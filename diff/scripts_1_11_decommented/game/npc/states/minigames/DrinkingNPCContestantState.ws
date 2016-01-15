state DrinkingNPCContestant in CNewNPC
{
	event OnEnterState( prevStateName : name )
	{
		parent.DisableLookAt();
		DrinkingNPCContestantStateInit();
	}
	entry function DrinkingNPCContestantStateInit()
	{
		parent.ActivateAndSyncBehavior('drinking_contestant');
	}
}
