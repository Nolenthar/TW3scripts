class W3Potion_Pheromone extends CBaseGameplayEffect
{
	private saved var abilityNameStr : string;
	protected function GetSelfInteraction( e : CBaseGameplayEffect) : EEffectInteract
	{
		if(abilityName != e.abilityName)
			return EI_Pass;
		return super.GetSelfInteraction(e);
	}
}
