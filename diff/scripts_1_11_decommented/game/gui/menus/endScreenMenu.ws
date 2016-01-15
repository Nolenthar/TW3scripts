class CR4EndScreenMenu extends CR4StartScreenMenu
{
	event  OnConfigUI()
	{
		super.OnConfigUI();
	}
	event  OnCloseMenu()
	{
		theGame.FadeInAsync(thePlayer.GetStartScreenFadeInDuration());
		thePlayer.SetEndScreenIsOpened(false);
		CloseMenu();
		theInput.RestoreContext( 'EMPTY_CONTEXT', true );
	}
	event OnKeyPress()
	{
	}
}
