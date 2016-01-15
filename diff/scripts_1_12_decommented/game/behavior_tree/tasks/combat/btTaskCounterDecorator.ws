class CBTTaskCounterDecorator extends IBehTreeTask
{
	function OnActivate() : EBTNodeStatus
	{
		GetNPC().SetIsCountering(true);
		return BTNS_Active;
	}
	function OnDeactivate()
	{
		GetNPC().SetIsCountering(false);
	}
}
class CBTTaskCounterDecoratorDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskCounterDecorator';
}
