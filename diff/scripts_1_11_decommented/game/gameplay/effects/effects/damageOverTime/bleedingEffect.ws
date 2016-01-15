class W3Effect_Bleeding extends W3DamageOverTimeEffect
{
	default effectType = EET_Bleeding;
	default resistStat = CDS_BleedingRes;
	public function OnDamageDealt(dealtDamage : bool)
	{
		if(!dealtDamage)
		{
			shouldPlayTargetEffect = false;
			if(target.IsEffectActive(targetEffectName))
				StopTargetFX();
		}
		else
		{
			shouldPlayTargetEffect = true;
			if(!target.IsEffectActive(targetEffectName))
				PlayTargetFX();
		}
	}
}
