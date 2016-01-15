import class ISpawnTreeBaseNode extends CObject
{
	import var nodeName	: name;
}
import class ISpawnTreeBranch extends ISpawnTreeBaseNode
{
}
import class ISpawnTreeDecorator extends ISpawnTreeBranch
{
}
import class ISpawnTreeScriptedDecorator extends ISpawnTreeDecorator
{
}
class CRatClue_SpawnTreeDecorator extends ISpawnTreeScriptedDecorator
{
	function OnActivate( encounter : CEncounter ) : IScriptable
	{
		return NULL;
	}
	function OnDeactivate( encounter : CEncounter )
	{
	}
	function GetFriendlyName() : string
	{
		return "RatClueDecorator";
	}
	latent function Main( userData : IScriptable )
	{
		Swarm_DisableLair( 'lair_rats', false );
		Sleep( 5.0 );
		return;
	}
}
class CCrowClue_SpawnTreeDecorator extends ISpawnTreeScriptedDecorator
{
	function OnActivate( encounter : CEncounter ) : IScriptable
	{
		return NULL;
	}
	function OnDeactivate( encounter : CEncounter )
	{
	}
	function GetFriendlyName() : string
	{
		return "CrowClueDecorator";
	}
	latent function Main( userData : IScriptable )
	{
		Swarm_DisableLair( 'lair_crows', false );
		Sleep( 10.0 );
		FlyingSwarm_RequestAllGroupsInstantDespawn( 'lair_crows' );
		return;
	}
}
