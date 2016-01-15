class BTTaskManageAnimatedMovement extends IBehTreeTask
{
	public var onDeactivate		: bool;
	public var flag				: bool;
	function OnActivate() : EBTNodeStatus
	{
		if( !onDeactivate )
		{
			Execute( flag );
		}
		return BTNS_Active;
	}
	private function OnDeactivate()
	{
		if( onDeactivate )
		{
			Execute( flag );
		}
	}
	private final function Execute( _Flag : bool )
	{
		var npc : CNewNPC = GetNPC();
		if( _Flag )
		{
			((CMovingPhysicalAgentComponent)npc.GetMovingAgentComponent()).SetAnimatedMovement( true );
		}
		else
		{
			((CMovingPhysicalAgentComponent)npc.GetMovingAgentComponent()).SetAnimatedMovement( false );
		}
	}
}
class BTTaskManageAnimatedMovementDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'BTTaskManageAnimatedMovement';
	editable var onDeactivate		: bool;
	editable var overrideOnly		: bool;
	editable var flag				: bool;
}
