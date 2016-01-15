class W3TrapWolfPit extends W3Trap
{
	event OnAreaEnter( area : CTriggerAreaComponent, activator : CComponent )
	{
		var l_actor	: CActor;
		l_actor = (CActor) activator.GetEntity();
		l_actor.Kill(true);
	}
}
