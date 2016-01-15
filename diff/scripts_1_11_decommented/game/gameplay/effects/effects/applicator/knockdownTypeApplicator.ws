class W3Effect_KnockdownTypeApplicator extends W3ApplicatorEffect
{
	private saved var customEffectValue : SAbilityAttributeValue;
	private saved var customDuration : float;
	private saved var customAbilityName : name;
	default effectType = EET_KnockdownTypeApplicator;
	default isNegative = true;
	default isPositive = false;
	event OnEffectAdded(optional customParams : W3BuffCustomParams)
	{
		var aardPower	: float;
		var tags : array<name>;
		var i : int;
		var appliedType : EEffectType;
		var null : SAbilityAttributeValue;
		var npc : CNewNPC;
		var params : SCustomEffectParams;
		var mutagen : CBaseGameplayEffect;
		var min, max : SAbilityAttributeValue;
		var encumbranceBonus : float;
		if (target == thePlayer && thePlayer.HasBuff(EET_Mutagen08))
		{
			mutagen = thePlayer.GetBuff(EET_Mutagen08);
			theGame.GetDefinitionsManager().GetAbilityAttributeValue(mutagen.GetAbilityName(), 'resistGainRate', min, max);
			encumbranceBonus = GetWitcherPlayer().GetEncumbrance() * CalculateAttributeValue(GetAttributeRandomizedValue(min, max));
			resistance += encumbranceBonus / 100;
		}
		if(isOnPlayer)
		{
			thePlayer.OnRangedForceHolster( true, true, false );
		}
		if(effectValue.valueMultiplicative + effectValue.valueAdditive > 0)
			aardPower = effectValue.valueMultiplicative * ( 1 - resistance ) / (1 + effectValue.valueAdditive/100);
		else
			aardPower = creatorPowerStat.valueMultiplicative * ( 1 - resistance ) / (1 + creatorPowerStat.valueAdditive/100);
		npc = (CNewNPC)target;
		if(npc && npc.HasShieldedAbility() )
		{
			if ( npc.IsShielded(GetCreator()) )
			{
				if ( aardPower >= 1.2 )
					appliedType = EET_LongStagger;
				else
					appliedType = EET_Stagger;
			}
			else
			{
				if ( aardPower >= 1.2 )
					appliedType = EET_Knockdown;
				if ( aardPower >= 1.0 )
					appliedType = EET_LongStagger;
				else
					appliedType = EET_Stagger;
			}
		}
		else if ( target.HasAbility( 'mon_type_huge' ) )
		{
			if ( aardPower >= 1.2 )
				appliedType = EET_LongStagger;
			else
				appliedType = EET_Stagger;
		}
		else if ( target.HasAbility( 'WeakToAard' ) )
		{
			appliedType = EET_Knockdown;
		}
		else if( aardPower >= 1.2 )
		{
			appliedType = EET_HeavyKnockdown;
		}
		else if( aardPower >= 0.95 )
		{
			appliedType = EET_Knockdown;
		}
		else if( aardPower >= 0.75 )
		{
			appliedType = EET_LongStagger;
		}
		else
		{
			appliedType = EET_Stagger;
		}
		appliedType = ModifyHitSeverityBuff(target, appliedType);
		params.effectType = appliedType;
		params.creator = GetCreator();
		params.sourceName = sourceName;
		params.isSignEffect = isSignEffect;
		params.customPowerStatValue = creatorPowerStat;
		params.customAbilityName = customAbilityName;
		params.duration = customDuration;
		params.effectValue = customEffectValue;
		target.AddEffectCustom(params);
		isActive = true;
		duration = 0;
	}
	public function Init(params : SEffectInitInfo)
	{
		customDuration = params.duration;
		customEffectValue = params.customEffectValue;
		customAbilityName = params.customAbilityName;
		super.Init(params);
	}
}
