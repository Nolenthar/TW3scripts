class W3QuestCond_ActorSpeed extends CQCActorScriptedCondition
{
	editable var condition 	: ECompareOp;
	editable var speed 		: float;
	default condition = CO_GreaterEq;
	function Evaluate( act : CActor ) : bool
	{
		var l_movingAgent 	: CMovingAgentComponent;
		var l_currentSpeed	: float;
		var l_result		: bool;
		l_movingAgent 	= act.GetMovingAgentComponent();
		l_currentSpeed 	= l_movingAgent.GetSpeed();
		l_result 		= ProcessCompare( condition, l_currentSpeed, speed);
		return l_result;
	}
}
