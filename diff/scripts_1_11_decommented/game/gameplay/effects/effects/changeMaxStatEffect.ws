abstract class W3ChangeMaxStatEffect extends CBaseGameplayEffect
{
	protected saved var stat : EBaseCharacterStats;
		default isPositive = true;
	public function Init(params : SEffectInitInfo)
	{
		attributeName = StatEnumToName(stat);
		super.Init(params);
	}
}
