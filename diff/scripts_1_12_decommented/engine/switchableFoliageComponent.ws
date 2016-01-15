import class CSwitchableFoliageComponent extends CComponent
{
	private var currEntryName : name;
	public function SetAndSaveEntry( entryName : name )
	{
		currEntryName = entryName;
		SetEntry( currEntryName );
	}
	public function GetEntry() : name
	{
		return currEntryName;
	}
	import private final function SetEntry( entryName : name );
}
