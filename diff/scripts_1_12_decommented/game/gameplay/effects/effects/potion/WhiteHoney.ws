class W3Potion_WhiteHoney extends CBaseGameplayEffect
{
	default effectType = EET_WhiteHoney;
	event OnEffectAdded(optional customParams : W3BuffCustomParams)
	{
		var exceptions : array<CBaseGameplayEffect>;
		var wolf : CBaseGameplayEffect;
		super.OnEffectAdded(customParams);
		target.ForceSetStat(BCS_Toxicity, 0);
		exceptions.PushBack(this);
		wolf = thePlayer.GetBuff(EET_WolfHour);
		if(wolf)
			exceptions.PushBack(wolf);
		thePlayer.RemoveAllPotionEffects(exceptions);
	}
}
