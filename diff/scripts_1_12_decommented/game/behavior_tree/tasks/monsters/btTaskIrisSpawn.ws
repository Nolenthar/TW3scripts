class BTTaskIrisTask extends IBehTreeTask
{}
class BTTaskIrisSpawn extends BTTaskIrisTask
{
	private var m_Painting : CEntity;
	function OnActivate() : EBTNodeStatus
	{
		var l_iris 		: 	W3NightWraithIris;
		l_iris = (W3NightWraithIris) GetNPC();
		m_Painting = (CEntity) l_iris.GetClosestPainting();
		return BTNS_Active;
	}
	private function OnDeactivate()
	{
		m_Painting.StopEffect('ghost_appear');
	}
}
class BTTaskIrisSpawnDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'BTTaskIrisSpawn';
}
