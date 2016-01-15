class W3Effect_AutoEssenceRegen extends W3AutoRegenEffect
{
	default effectType = EET_AutoEssenceRegen;
	default regenStat = CRS_Essence;
	event OnUpdate(dt : float)
	{
		super.OnUpdate( dt );
		if( target.GetStatPercents( BCS_Essence ) >= 1.0f )
		{
			target.StopEssenceRegen();
		}
	}
}
