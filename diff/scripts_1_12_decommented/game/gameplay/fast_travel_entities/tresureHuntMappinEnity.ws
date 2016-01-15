class W3TreasureHuntMappinEntity extends CR4MapPinEntity
{
	default radius = 20;
	private saved var mappinSet : bool;
	private var isDisabled 		: bool;
	event OnAreaEnter( area : CTriggerAreaComponent, activator : CComponent )
	{
		if ( entityName != '' && !mappinSet && !isDisabled  )
		{
			Enable ();
		}
	}
	public function Enable ()
	{
		var mapManager : CCommonMapManager = theGame.GetCommonMapManager();
		mapManager.SetEntityMapPinDiscoveredScript (  false, entityName, true );
		mappinSet = true;
	}
	public function Disable ()
	{
		var mapManager : CCommonMapManager = theGame.GetCommonMapManager();
		isDisabled = true;
		mapManager.SetEntityMapPinDiscoveredScript( false, entityName, false);
	}
}
