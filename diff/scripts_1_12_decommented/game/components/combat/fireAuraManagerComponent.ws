class W3FireAuraManagerComponent extends CR4Component
{
	editable var fireAuraEffect			: name;
	hint fireAuraEffect		= "effect to play or stop when the fire aura is activated or deactivated";
	private var m_PostFxOnGroundCmp		: W3PostFXOnGroundComponent;
	event OnComponentAttached()
	{
		var l_actor : CActor;
		l_actor = (CActor) GetEntity();
		l_actor.AddAnimEventChildCallback(this,'ActivateFireAura','OnAnimEvent_ActivateFireAura');
		l_actor.AddAnimEventChildCallback(this,'DeactivateFireAura','OnAnimEvent_DeactivateFireAura');
		m_PostFxOnGroundCmp = (W3PostFXOnGroundComponent) l_actor.GetComponentByClassName('W3PostFXOnGroundComponent');
	}
	event OnAardHit ( )
	{
		DeactivateAura();
	}
	event OnIgniHit ( )
	{
		ActivateAura();
	}
	public function DeactivateAura()
	{
		var l_actor : CActor;
		l_actor = (CActor) GetEntity();
		l_actor.StopEffect( fireAuraEffect );
		l_actor.PauseEffects( EET_FireAura, '', true);
		m_PostFxOnGroundCmp.StopTicking();
	}
	public function ActivateAura()
	{
		var l_actor : CActor;
		l_actor = (CActor) GetEntity();
		l_actor.PlayEffectSingle( fireAuraEffect );
		l_actor.ResumeEffects( EET_FireAura, '');
		m_PostFxOnGroundCmp.StartTicking();
	}
	event OnAnimEvent_ActivateFireAura( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		ActivateAura();
	}
	event OnAnimEvent_DeactivateFireAura( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		DeactivateAura();
	}
}
