class W3NPCBackgroundNew extends CEntity
{
	editable var behaviorWorkNumber : int;
	editable var randomized : bool;
	editable var maxWorkNumber : int;
	editable var excludeIdle : bool;
	event OnSpawned(spawnData : SEntitySpawnData)
	{
		if(randomized)
		{
			if(excludeIdle)
			{
				SetBehaviorVariable( 'WorkTypeEnum_Single', RandRange(maxWorkNumber) +1 );
			}
			else
			{
				SetBehaviorVariable( 'WorkTypeEnum_Single', RandRange(maxWorkNumber +1) );
			}
		}
		else
		{
			SetBehaviorVariable( 'WorkTypeEnum_Single', behaviorWorkNumber);
		}
	}
}
