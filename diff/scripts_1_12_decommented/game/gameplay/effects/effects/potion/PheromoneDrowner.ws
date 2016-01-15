class  W3Potion_PheromoneDrowner extends W3Potion_Pheromone
{
	default effectType = EET_PheromoneDrowner;
	event OnEffectAdded(optional customParams : W3BuffCustomParams)
	{
		super.OnEffectAdded(customParams);
		theGame.SetGlobalAttitude( 'AG_drowner', 'player', AIA_Friendly );
	}
	event OnEffectRemoved()
	{
		super.OnEffectRemoved();
		theGame.SetGlobalAttitude( 'AG_drowner', 'player', AIA_Hostile );
	}
}
