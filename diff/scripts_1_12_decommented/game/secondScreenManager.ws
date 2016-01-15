import class CR4SecondScreenManagerScriptProxy extends CObject
{
	import final function SendGlobalMapPins( mappins : array< SCommonMapPinInstance > );
	import final function SendAreaMapPins( areaType: int, mappins :array< SCommonMapPinInstance > );
	import final function SendGameMenuOpen();
	import final function SendGameMenuClose();
	import final function SendFastTravelEnable();
	import final function SendFastTravelDisable();
	import final function PrintJsonObjectsMemoryUsage();
	private function FastTravelLocal( mapPinTag: name ) : void
	{
	}
	private function FastTravelGlobal( areaType: int, mapPinTag: name ) : void
	{
	}
}
