class W3Mutagen18_Effect extends W3Mutagen_Effect
{
	default effectType = EET_Mutagen18;
	default dontAddAbilityOnTarget = true;
	event OnEffectRemoved()
	{
		super.OnEffectRemoved();
		target.RemoveAbilityAll(abilityName);
	}
}
