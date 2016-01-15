import state Base in CPlayer
{
	import final function CreateNoSaveLock();
	function CanAccesFastTravel( target : W3FastTravelEntity ) : bool
	{
		return true;
	}
}
