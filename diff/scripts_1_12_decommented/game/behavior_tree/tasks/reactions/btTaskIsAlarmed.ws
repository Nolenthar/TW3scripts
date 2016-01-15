class CBTTaskIsAlarmed extends IBehTreeTask
{
	protected var storageHandler 	: CAIStorageHandler;
	protected var reactionDataStorage : CAIStorageReactionData;
	function IsAvailable() : bool
	{
		return reactionDataStorage.IsAlarmed(GetLocalTime());
	}
	function OnActivate() : EBTNodeStatus
	{
		return BTNS_Active;
	}
	function Initialize()
	{
		storageHandler = new CAIStorageHandler in this;
		storageHandler.Initialize( 'ReactionData', '*CAIStorageReactionData', this );
		reactionDataStorage = (CAIStorageReactionData)storageHandler.Get();
	}
}
class CBTTaskIsAlarmedDef extends IBehTreeReactionTaskDefinition
{
	default instanceClass = 'CBTTaskIsAlarmed';
}
class CBTTaskIsAngry extends IBehTreeTask
{
	protected var storageHandler 	: CAIStorageHandler;
	protected var reactionDataStorage : CAIStorageReactionData;
	function IsAvailable() : bool
	{
		return reactionDataStorage.IsAngry(GetLocalTime());
	}
	function OnActivate() : EBTNodeStatus
	{
		return BTNS_Active;
	}
	function Initialize()
	{
		storageHandler = new CAIStorageHandler in this;
		storageHandler.Initialize( 'ReactionData', '*CAIStorageReactionData', this );
		reactionDataStorage = (CAIStorageReactionData)storageHandler.Get();
	}
}
class CBTTaskIsAngryDef extends IBehTreeReactionTaskDefinition
{
	default instanceClass = 'CBTTaskIsAngry';
}
