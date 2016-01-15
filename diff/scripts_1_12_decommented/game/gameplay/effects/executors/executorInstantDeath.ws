class W3Executor_InstantDeath extends IInstantEffectExecutor
{
	default executorName = 'InstantDeath';
	public function Execute( executor : CGameplayEntity, target : CActor, optional source : string ) : bool
	{
		if(target)
		{
			target.Kill(executor);
			return true;
		}
		return false;
	}
}
