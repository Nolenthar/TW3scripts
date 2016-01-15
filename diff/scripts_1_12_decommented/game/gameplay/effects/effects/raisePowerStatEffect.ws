abstract class W3RaisePowerStatEffect extends CBaseGameplayEffect
{
	protected saved var stat : ECharacterPowerStats;
	default isPositive = true;
	default isNeutral = false;
	default isNegative = false;
	public function Init(params : SEffectInitInfo)
	{
		attributeName = PowerStatEnumToName(stat);
		super.Init(params);
	}
}
