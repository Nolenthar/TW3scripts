class W3TrapAlarm extends W3Trap
{
	private editable var alarmSoundString		: string;
	public function Activate( optional _Target: CNode ):void
	{
		SoundEvent( alarmSoundString );
		super.Activate( _Target );
	}
}
