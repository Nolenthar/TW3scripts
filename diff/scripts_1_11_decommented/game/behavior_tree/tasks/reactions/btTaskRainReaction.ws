class CBTTaskRainReaction extends IBehTreeTask
{
	protected var storageHandler 	: CAIStorageHandler;
	protected var reactionDataStorage : CAIStorageReactionData;
	function IsAvailable() : bool
	{
		return true;
	}
	function OnActivate() : EBTNodeStatus
	{
		return BTNS_Active;
	}
	latent function Main() : EBTNodeStatus
	{
		return BTNS_Completed;
	}
	function Initialize()
	{
		storageHandler = new CAIStorageHandler in this;
		storageHandler.Initialize( 'ReactionData', '*CAIStorageReactionData', this );
		reactionDataStorage = (CAIStorageReactionData)storageHandler.Get();
	}
}
class CBTTaskRainReactionDef extends IBehTreeReactionTaskDefinition
{
	default instanceClass = 'CBTTaskRainReaction';
}
