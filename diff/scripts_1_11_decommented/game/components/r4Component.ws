class CR4Component extends CScriptedComponent
{
	public function IgniHit()
	{
		OnIgniHit();
	}
	public function AardHit ()
	{
		OnAardHit();
	}
	event OnIgniHit()
	{
	}
	event OnAardHit()
	{
	}
}
