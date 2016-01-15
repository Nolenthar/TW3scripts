enum EBackgroundNPCWomanWork
{
	EBNWW_None,
	EBNWW_Listening,
	EBNWW_Sweeping_floor,
	EBNWW_Washing_cloth,
	EBNWW_Brushing_floor_man,
	EBNWW_Leaning_against_fence,
	EBNWW_Sex
}
class W3NPCBackgroundWoman extends CGameplayEntity
{
	public editable var work : EBackgroundNPCWomanWork;
	event OnSpawned(spawnData : SEntitySpawnData)
	{
		SetBehaviorVariable('WorkTypeEnum_Single',(int)work);
	}
}
