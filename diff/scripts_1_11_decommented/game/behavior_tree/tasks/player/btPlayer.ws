abstract class IBehTreePlayerTaskDefinition extends IBehTreeTaskDefinition
{
};
abstract class IBehTreePlayerConditionalTaskDefinition extends IBehTreeConditionalTaskDefinition
{
};
class CBTTaskPlayerActionDecorator extends IBehTreeTask
{
	public var completeOnInput : bool;
	private var prevContext : name;
	function OnActivate() : EBTNodeStatus
	{
		if( GetActor() != thePlayer && GetNPC().GetHorseComponent() != thePlayer.GetUsedHorseComponent() )
			return BTNS_Failed;
		prevContext = theInput.GetContext();
		theInput.SetContext( 'ScriptedAction' );
		return BTNS_Active;
	}
	latent function Main() : EBTNodeStatus
	{
		while( true )
		{
			if( ( theInput.GetContext() != 'ScriptedAction' ) && ( theInput.GetContext() != 'EMPTY_CONTEXT' ) )
			{
				prevContext = theInput.GetContext();
				theInput.SetContext( 'ScriptedAction' );
			}
			SleepOneFrame();
		}
		return BTNS_Active;
	}
	function OnDeactivate()
	{
		var currentState : name;
		var contextName : name;
		if ( theInput.GetContext() != 'ScriptedAction' )
			return;
		currentState = thePlayer.GetCurrentStateName();
		switch( currentState )
		{
			case 'Combat' :
			case 'CombatSteel' :
			case 'CombatSilver' :
			case 'CombatFists' :
				contextName = thePlayer.GetCombatInputContext();
				break;
			case 'HorseRiding' :
				contextName = 'Horse';
				break;
			default :
				contextName = thePlayer.GetExplorationInputContext();
				break;
		}
		if( IsNameValid( contextName ) )
		{
			theInput.SetContext( contextName );
		}
	}
	function OnListenedGameplayEvent( eventName : name ) : bool
	{
		if( eventName == 'StopPlayerActionOnInput' && completeOnInput )
		{
			Complete( true );
			return true;
		}
		else if( eventName == 'StopPlayerAction' )
		{
			Complete( true );
			return true;
		}
		return false;
	}
}
class CBTTaskPlayerActionDecoratorDef extends IBehTreePlayerTaskDefinition
{
	default instanceClass = 'CBTTaskPlayerActionDecorator';
	editable var completeOnInput : CBehTreeValBool;
	function InitializeEvents()
	{
		super.InitializeEvents();
		listenToGameplayEvents.PushBack( 'StopPlayerActionOnInput' );
		listenToGameplayEvents.PushBack( 'StopPlayerAction' );
	}
}
