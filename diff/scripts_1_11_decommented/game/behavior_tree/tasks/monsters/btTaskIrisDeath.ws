class BTTaskIrisDeath extends IBehTreeTask
{
	function OnActivate() : EBTNodeStatus
	{
		var i						: int;
		var l_npc 					: W3NightWraithIris;
		var l_availablePaintings 	: array<CNode>;
		l_npc = (W3NightWraithIris) GetNPC();
		l_npc.StopEffect('drained_paint');
		return BTNS_Active;
	}
}
class BTTaskIrisDeathDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'BTTaskIrisDeath';
}
