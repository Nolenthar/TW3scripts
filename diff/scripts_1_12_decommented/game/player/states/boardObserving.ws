state BoardObserving in CPlayer
{
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState( prevStateName );
	}
	event OnLeaveState( nextStateName : name )
	{
		super.OnLeaveState( nextStateName );
	}
}
