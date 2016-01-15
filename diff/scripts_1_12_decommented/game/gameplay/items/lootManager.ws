import class CR4LootManager extends IGameSystem
{
	import final function SetCurrentArea( areaName : string );
	import final function GetCurrentArea() : string;
	public function OnAreaChanged(newArea : EAreaName)
	{
		SetCurrentArea( AreaTypeToName( newArea ) );
		LogRandomLoot("CR4LootManager.OnAreaChanged: active area is now <<" + GetCurrentArea() + ">>" );
	}
}
