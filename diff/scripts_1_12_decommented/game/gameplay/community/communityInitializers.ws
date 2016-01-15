class CSpawnTreeInitializerSetImmortality extends ISpawnTreeScriptedInitializer
{
	editable var immortalityMode : EActorImmortalityMode;
	function GetEditorFriendlyName() : string
	{
		return "SetImmortality";
	}
	function Init( actor : CActor ) : bool
	{
		var npc : CNewNPC;
		actor.SetImmortalityMode( immortalityMode, AIC_Default );
		npc = (CNewNPC)actor;
		if ( npc )
			npc.SetImmortalityInitialized();
		return true;
	}
};
