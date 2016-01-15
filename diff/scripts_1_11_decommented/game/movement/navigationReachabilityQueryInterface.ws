import class CNavigationReachabilityQueryInterface extends IScriptable
{
	import final function GetLastOutput( optional queryValidTime : float ) : EAsyncTestResult;
	import final function GetOutputClosestDistance() : float;
	import final function GetOutputClosestEntity() : CEntity;
	import final function TestActorsList
		( testType : ENavigationReachabilityTestType
		, originActor : CActor
		, list : array< CActor >
		, optional safeSpotTolerance : float
		, optional pathfindDinstanceLimit : float )
		: EAsyncTestResult;
};
