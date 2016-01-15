class CBTTaskRaiseAnimationEvent extends IBehTreeTask
{
	var eventName : CName;
	var forceEvent : Bool;
	function OnActivate() : EBTNodeStatus
	{
		var owner : CActor = GetActor();
		if ( forceEvent == false )
		{
			owner.RaiseEvent( eventName );
		}
		else
		{
			owner.RaiseForceEvent( eventName );
		}
		return BTNS_Active;
	}
};
class CBTTaskRaiseAnimationEventDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskRaiseAnimationEvent';
	editable var eventName : CName;
	editable var forceEvent : Bool;
};
