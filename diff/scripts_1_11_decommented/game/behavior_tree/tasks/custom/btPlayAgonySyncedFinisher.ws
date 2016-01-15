class CBTTaskPlayAgonySyncedFinisher extends CBTTaskPlaySyncedAnimation
{
	function IsAvailable() : bool
	{
		var owner : CNewNPC = GetNPC();
		return super.IsAvailable();
		return owner.IsInFinisherAnim();
	}
	function OnActivate() : EBTNodeStatus
	{
		return super.OnActivate();
	}
	function OnDeactivate()
	{
		var owner : CNewNPC = GetNPC();
		super.OnDeactivate();
		owner.FinisherAnimEnd();
	}
	function OnAnimEvent( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo ) : bool
	{
		return false;
	}
}
class CBTTaskPlayAgonySyncedFinisherDef extends CBTTaskPlaySyncedAnimationDef
{
	default instanceClass = 'CBTTaskPlayAgonySyncedFinisher';
}
