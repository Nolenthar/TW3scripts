class CR4TestPopup extends CR4Popup
{
	event  OnConfigUI()
	{
		LogChannel( 'TestPopup', "OnConfigUI" );
	}
	event  OnClosingPopup()
	{
		LogChannel( 'TestPopup', "OnClosingPopup" );
	}
	event  OnClosePopup()
	{
		ClosePopup();
		LogChannel( 'TestPopup', "OnClosePopup" );
	}
}
exec function testpopup()
{
	theGame.RequestPopup( 'TestPopup' );
}
exec function testpopup2()
{
	theGame.ClosePopup( 'TestPopup' );
}
