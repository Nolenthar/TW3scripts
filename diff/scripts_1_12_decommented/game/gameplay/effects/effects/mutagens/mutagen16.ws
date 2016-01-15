class W3Mutagen16_Effect extends W3Mutagen_Effect
{
	default effectType = EET_Mutagen16;
	event OnEffectAddedPost()
	{
		super.OnEffectAddedPost();
		UpdateEncumbrance();
	}
	event OnEffectRemoved()
	{
		super.OnEffectRemoved();
		UpdateEncumbrance();
	}
	private final function UpdateEncumbrance()
	{
		var invMenu : CR4InventoryMenu;
		if(isOnPlayer)
		{
			GetWitcherPlayer().UpdateEncumbrance();
			invMenu = (CR4InventoryMenu) ((CR4MenuBase)theGame.GetGuiManager().GetRootMenu()).GetLastChild();
			if(invMenu)
				invMenu.UpdateEncumbranceInfo();
		}
	}
}
