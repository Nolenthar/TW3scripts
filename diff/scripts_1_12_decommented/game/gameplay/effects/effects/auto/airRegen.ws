class W3Effect_AutoAirRegen extends W3AutoRegenEffect
{
	default effectType = EET_AutoAirRegen;
	default regenStat = CRS_Air;
	event OnUpdate(dt : float)
	{
		super.OnUpdate( dt );
		if( target.GetStatPercents( BCS_Air ) >= 1.0f )
		{
			target.StopAirRegen();
		}
	}
}
