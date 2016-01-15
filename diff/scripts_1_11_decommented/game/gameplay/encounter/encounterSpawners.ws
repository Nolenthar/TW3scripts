import abstract class ISpawnTreeSpawnerInitializer extends ISpawnTreeInitializer
{
};
import class CSpawnTreeInitializerWaypointSpawner extends ISpawnTreeSpawnerInitializer
{
	import public var spawner : CSpawnTreeWaypointSpawner;
};
import class CSpawnTreeInitializerActionpointSpawner extends ISpawnTreeSpawnerInitializer
{
	import public var spawner : CSpawnTreeActionPointSpawner;
};
import struct CSpawnTreeWaypointSpawner
{
	import var visibility : ESpawnTreeSpawnVisibility;
	import var spawnpointDelay : float;
	import var tags : TagList;
};
import struct CSpawnTreeActionPointSpawner
{
	import var visibility : ESpawnTreeSpawnVisibility;
	import var spawnpointDelay : float;
	import var tags : TagList;
	import var categories : array< name >;
};
enum EEncounterSpawnGroup
{
	ESG_Quest,
	ESG_Important,
	ESG_CoreCommunity,
	ESG_SecondaryCommunity,
	ESG_OptionalCommunity,
};
