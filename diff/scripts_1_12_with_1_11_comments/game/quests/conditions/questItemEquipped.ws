/***********************************************************************/
/** Copyright © 2012-2013
/** Author : Rafal Jarczewski, Tomek Kozera
/***********************************************************************/

class W3QuestCond_IsItemEquipped_Listener extends IGlobalEventScriptedListener
{
	public var condition : W3QuestCond_IsItemEquipped;
	
	event OnGlobalEventName( eventCategory : EGlobalEventCategory, eventType : EGlobalEventType, eventParam : name )
	{
		if ( condition )
		{
			condition.EvaluateImpl();
		}	
	}
}

class W3QuestCond_IsItemEquipped extends CQuestScriptedCondition
{
	editable var itemName 		: name;
	editable var categoryName 	: name;

	var isFulfilled				: bool;
	var listener				: W3QuestCond_IsItemEquipped_Listener;

	function RegisterListener( flag : bool )
	{
		if ( flag )
		{
			listener = new W3QuestCond_IsItemEquipped_Listener in this;
			listener.condition = this;
			theGame.GetGlobalEventsManager().AddListener( GetGlobalEventCategory( SEC_OnItemEquipped ), listener );
			EvaluateImpl();
		}
		else
		{
			theGame.GetGlobalEventsManager().RemoveListener( GetGlobalEventCategory( SEC_OnItemEquipped ), listener );
			delete listener;
			listener = NULL;		
		}
	}	
	
	function Activate()
	{
		EvaluateImpl();
		if ( !isFulfilled )
		{
			RegisterListener( true );
		}		
	}
	
	function Deactivate()
	{
		if ( listener )
		{
			RegisterListener( false );
		}
	}

	function Evaluate() : bool
	{
		if ( !isFulfilled && !listener )
		{
			RegisterListener( true );
		}
		return isFulfilled;
	}
		
	function EvaluateImpl()
	{
		var player : W3PlayerWitcher;

		player = GetWitcherPlayer();
		if ( player )
		{
			if ( IsNameValid( itemName ) )
			{			
				isFulfilled = player.IsItemEquippedByName( itemName );
			}
			else if ( IsNameValid( categoryName ) )
			{
				isFulfilled = player.IsItemEquippedByCategoryName( categoryName );
			}
		}
	}
}
