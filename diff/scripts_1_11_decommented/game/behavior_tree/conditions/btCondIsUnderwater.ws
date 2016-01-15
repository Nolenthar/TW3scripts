class CBTCondIsUnderwater extends IBehTreeTask
{
	public var minSubmergeDepth	: float;
	final function IsAvailable() : bool
	{
		var subDepth : float;
		subDepth = ((CMovingPhysicalAgentComponent) GetNPC().GetMovingAgentComponent()).GetSubmergeDepth();
		if( subDepth < minSubmergeDepth * -1 )
		{
			return true;
		}
		return false;
	}
};
class CBTCondIsUnderwaterDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'CBTCondIsUnderwater';
	private editable var minSubmergeDepth	: float;
	hint 	minSubmergeDepth = "Depth to be submerged in to be considered underwater";
	default minSubmergeDepth = 1;
};
