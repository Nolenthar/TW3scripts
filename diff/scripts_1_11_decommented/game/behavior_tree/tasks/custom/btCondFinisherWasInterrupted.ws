class BTCondFinisherWasInterrupted extends IBehTreeTask
{
	function IsAvailable() : bool
	{
		var l_availability	: bool;
		l_availability = GetNPC().WasFinisherAnimInterrupted();
		return l_availability;
	}
	function OnDeactivate()
	{
		GetNPC().ResetFinisherAnimInterruptionState();
	}
}
class BTCondFinisherWasInterruptedDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'BTCondFinisherWasInterrupted';
};
