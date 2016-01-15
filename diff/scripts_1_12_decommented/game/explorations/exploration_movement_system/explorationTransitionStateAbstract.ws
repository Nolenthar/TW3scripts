class CExplorationStateTransitionAbstract extends CExplorationStateAbstract
{
	protected	editable	var			m_TransitionOriginStateN	: name;
	protected	editable	var			m_TransitionEndStateN		: name;
	public function IsMachForThisStates( _FromN, _ToN : name ) : bool
	{
		if( IsNameValid( m_TransitionOriginStateN ) && _FromN != m_TransitionOriginStateN )
		{
			return false;
		}
		if( IsNameValid( m_TransitionEndStateN ) && _ToN != m_TransitionEndStateN )
		{
			return false;
		}
		return _FromN == m_TransitionOriginStateN && m_TransitionEndStateN == _ToN;
	}
}
