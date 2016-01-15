state NewIdle in CNewNPC extends Base
{
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState(prevStateName);
		this.IdleInit();
	}
	event OnLeaveState( nextStateName : name )
	{
		super.OnLeaveState(nextStateName);
	}
	entry function IdleInit()
	{
		parent.ActivateAndSyncBehavior('Exploration');
		StateIdle();
	}
	latent function StateIdle()
	{
		while ( true )
		{
			Sleep( 10.0f );
		}
	}
}
