class W3SavedAppearanceEntity extends CGameplayEntity
{
	saved var appearanceName	: name;
	default appearanceName		= '';
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		if ( IsNameValid( appearanceName ) && spawnData.restored )
		{
			ApplyAppearance( appearanceName );
		}
	}
	public function SetAppearance( appName : name )
	{
		appearanceName = appName;
		ApplyAppearance( appName );
	}
}
