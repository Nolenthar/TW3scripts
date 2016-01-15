class BTTaskCompleteOnAnimEvent extends IBehTreeTask
{
	editable var animEvent			: name;
	editable var sucess				: bool;
	function OnAnimEvent( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo ) : bool
	{
		if ( animEventName == animEvent )
		{
			Complete( sucess );
		}
		return true;
	}
}
class BTTaskCompleteOnAnimEventDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'BTTaskCompleteOnAnimEvent';
	editable var animEvent			: name;
	editable var sucess				: bool;
	default sucess = true;
	hint success = "Should the task report success or fail?";
	function InitializeEvents()
	{
		super.InitializeEvents();
		if ( IsNameValid( animEvent ) )
		{
			listenToAnimEvents.PushBack( animEvent );
		}
	}
}
