class CBTTaskSirenAttack extends CBTTaskAttack
{
	function OnAnimEvent( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo ) : bool
	{
		var actors : array<CActor>;
		var i : int;
		var npc : CNewNPC = GetNPC();
		if ( animEventName == 'AttackScream' )
		{
			actors = npc.GetAttackableNPCsAndPlayersInRange(12);
			for ( i = 0 ; i < actors.Size(); i+=1)
			{
				if ( !actors[i].HasAbility( 'mon_siren' ))
				{
					actors[i].AddEffectDefault(EET_Stagger, npc, 'siren_attack' );
				}
			}
			return true;
		}
		return super.OnAnimEvent( animEventName, animEventType, animInfo);
	}
}
class CBTTaskSirenAttackDef extends CBTTaskAttackDef
{
	default instanceClass = 'CBTTaskSirenAttack';
}
