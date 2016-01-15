class CBTTaskCondReactionEvent extends IBehTreeTask
{
	var reactionEventName	: name;
	var eventReceived		: bool;
	function IsAvailable() : bool
	{
		if ( eventReceived )
		{
			return true;
		}
		return false;
	}
	function OnDeactivate()
	{
		eventReceived = false;
	}
	function OnGameplayEvent( eventName : name ) : bool
	{
		if ( eventName == reactionEventName )
		{
			eventReceived = true;
			return true;
		}
		return false;
	}
};
class CBTTaskCondReactionEventDef extends IBehTreeReactionTaskDefinition
{
	default instanceClass = 'CBTTaskCondReactionEvent';
	editable var reactionEventName	: name;
	function InitializeEvents()
	{
		super.InitializeEvents();
		if ( IsNameValid( reactionEventName ) )
		{
			listenToGameplayEvents.PushBack( reactionEventName );
		}
	}
};
