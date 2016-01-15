class W3Stash extends CInteractiveEntity
{
	event OnInteraction( actionName : string, activator : CEntity )
	{
		if(activator != thePlayer)
			return false;
		theGame.GameplayFactsAdd("stashMode", 1);
		theGame.RequestMenuWithBackground( 'InventoryMenu', 'CommonMenu' );
	}
}
