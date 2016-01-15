abstract class W3AutoRegenEffect extends W3RegenEffect
{
	default duration = -1;
	protected function SetEffectValue()
	{
		if(regenStat != CRS_Undefined)
			effectValue = target.GetAttributeValue( RegenStatEnumToName(regenStat) );
	}
}
