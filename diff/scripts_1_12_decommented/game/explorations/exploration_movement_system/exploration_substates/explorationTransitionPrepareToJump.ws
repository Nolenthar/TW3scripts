class CxplorationTransitionPrepareToJump extends CExplorationStateTransitionAbstract
{
	private function InitializeSpecific( _Exploration : CExplorationStateManager )
	{
		if( !IsNameValid( m_StateNameN ) )
		{
			m_StateNameN	= 'TransitionPrepareToJump';
		}
		if( !IsNameValid( m_TransitionOriginStateN ) )
		{
			m_TransitionOriginStateN	= 'PrepareJump';
		}
		if( !IsNameValid( m_TransitionEndStateN ) )
		{
			m_TransitionEndStateN	= 'Jump';
		}
		m_StateTypeE	= EST_OnAir;
	}
	private function AddDefaultStateChangesSpecific()
	{
	}
	function StateWantsToEnter() : bool
	{
		return false;
	}
	function StateCanEnter( curStateName : name ) : bool
	{
		return true;
	}
	private function StateEnterSpecific( prevStateName : name )
	{
		SetReadyToChangeTo( m_TransitionEndStateN );
	}
	function StateChangePrecheck( )	: name
	{
		return super.StateChangePrecheck();
	}
	protected function StateUpdateSpecific( _Dt : float )
	{
	}
	private function StateExitSpecific( nextStateName : name )
	{
	}
	function CanInteract( ) :bool
	{
		return false;
	}
}
