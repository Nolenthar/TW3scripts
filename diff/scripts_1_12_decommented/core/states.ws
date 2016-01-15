import class CScriptableState extends IScriptable
{
	import function IsActive() : bool;
	import function GetStateName() : name;
	event OnEnterState( prevStateName : name ) {}
	event OnLeaveState( nextStateName : name ) {}
	import function CanEnterState( prevStateName : name ) : bool;
	import function CanLeaveState( nextStateName : name ) : bool;
	import function BeginState( prevStateName : name );
	import function EndState( nextStateName : name );
	import function ContinuedState();
	import function PausedState();
}
