abstract class W3Effect_Shrine extends CBaseGameplayEffect
{
	private saved var isFromMutagen23 : bool;
	default isPositive = true;
	event OnEffectAdded(optional customParams : W3BuffCustomParams)
	{
		var shrineParams : W3ShrineEffectParams;
		super.OnEffectAdded(customParams);
		shrineParams = (W3ShrineEffectParams)customParams;
		if(shrineParams)
			isFromMutagen23 = shrineParams.isFromMutagen23;
	}
	public final function IsFromMutagen23() : bool		{return isFromMutagen23;}
}
class W3ShrineEffectParams extends W3BuffCustomParams
{
	var isFromMutagen23 : bool;
}
