import class CCommunitySystem extends IGameSystem
{
	import var communitySpawnInitializer : ISpawnTreeInitializerAI;
	function Init()
	{
		communitySpawnInitializer = new ISpawnTreeInitializerCommunityAI in this;
		communitySpawnInitializer.Init();
	}
};
import function DumpCommunityAgentsCPP();
exec function DumpCommunityAgents()
{
	DumpCommunityAgentsCPP();
}
