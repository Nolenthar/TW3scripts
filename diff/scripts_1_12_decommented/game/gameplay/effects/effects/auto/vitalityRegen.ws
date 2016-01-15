class W3Effect_AutoVitalityRegen extends W3AutoRegenEffect
{
	private var regenModeIsCombat : bool;
	private var cachedPlayer : CR4Player;
		default regenStat = CRS_Vitality;
		default effectType = EET_AutoVitalityRegen;
		default regenModeIsCombat = false;
	event OnEffectAdded(optional customParams : W3BuffCustomParams)
	{
		super.OnEffectAdded(customParams);
		if(isOnPlayer)
			cachedPlayer = (CR4Player)target;
	}
	public function OnLoad(t : CActor, eff : W3EffectManager)
	{
		super.OnLoad(t, eff);
		if(isOnPlayer)
			cachedPlayer = (CR4Player)target;
	}
	event OnUpdate(deltaTime : float)
	{
		if(isOnPlayer)
		{
			regenModeIsCombat = cachedPlayer.IsInCombat();
			if(regenModeIsCombat)
				attributeName = 'vitalityCombatRegen';
			else
				attributeName = RegenStatEnumToName(regenStat);
			SetEffectValue();
		}
		super.OnUpdate(deltaTime);
		if( target.GetStatPercents( BCS_Vitality ) >= 1.0f && !target.HasAbility('Runeword 4 _Stats', true))
		{
			target.StopVitalityRegen();
		}
	}
	protected function SetEffectValue()
	{
		effectValue = target.GetAttributeValue(attributeName);
	}
}
