import abstract class IActorLatentAction extends IAIParameters
{
	function ConvertToActionTree( parentObj : IScriptable ) : IAIActionTree
	{
		return NULL;
	}
}
import abstract class IPresetActorLatentAction extends IActorLatentAction
{
	import var resName : string;
}
