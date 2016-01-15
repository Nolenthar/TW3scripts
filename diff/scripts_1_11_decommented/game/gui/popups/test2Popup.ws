class CR4Test2Popup extends CR4Popup
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
exec function test2popup()
{
	theGame.RequestPopup( 'Test2Popup' );
}
exec function test2popup2()
{
	theGame.ClosePopup( 'Test2Popup' );
}
