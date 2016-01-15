class W3Effect_AutoMoraleRegen extends W3AutoRegenEffect
{
	default effectType = EET_AutoMoraleRegen;
	default regenStat = CRS_Morale;
	event OnUpdate(dt : float)
	{
		super.OnUpdate( dt );
		if( target.GetStatPercents( BCS_Morale ) >= 1.0f )
		{
			target.StopMoraleRegen();
		}
	}
}
