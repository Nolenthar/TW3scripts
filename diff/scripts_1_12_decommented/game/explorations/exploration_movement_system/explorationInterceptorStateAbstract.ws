class CExplorationInterceptorStateAbstract extends CExplorationStateTransitionAbstract
{
	protected	editable	var			m_InterceptStateN	: name;
	public function IsMachForThisStates( _FromN, _ToN : name ) : bool
	{
		return m_InterceptStateN == _ToN;
	}
}
