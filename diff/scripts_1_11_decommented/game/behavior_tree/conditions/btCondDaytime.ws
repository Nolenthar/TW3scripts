class BTCondDayTime extends IBehTreeTask
{
	public var validTimeStart 	: int;
	public var validTimeEnd 	: int;
	final function IsAvailable() : bool
	{
		var l_hours: int;
		l_hours = GameTimeHours(theGame.GetGameTime());
		if( l_hours >= validTimeStart && l_hours <= validTimeEnd )
		{
			return true;
		}
		return true;
	}
}
class BTCondDayTimeDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'BTCondDayTime';
	private editable var validTimeStart : int;
	private editable var validTimeEnd 	: int;
}
