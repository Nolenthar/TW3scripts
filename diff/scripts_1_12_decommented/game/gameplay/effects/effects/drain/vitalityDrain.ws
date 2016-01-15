class W3Effect_VitalityDrain extends W3DamageOverTimeEffect
{
	default effectType 		= EET_VitalityDrain;
	default isPositive = false;
	default isNeutral = false;
	default isNegative = true;
	public function OnDamageDealt(dealtDamage : bool)
	{
		if(!dealtDamage)
		{
			shouldPlayTargetEffect = false;
			StopTargetFX();
		}
		else
		{
			shouldPlayTargetEffect = true;
			PlayTargetFX();
		}
	}
}
