class CBTTaskRootPitch extends IBehTreeTask
{
	private var mac : CMovingPhysicalAgentComponent;
	function OnActivate() : EBTNodeStatus
	{
		if ( !mac )
		{
			mac = (CMovingPhysicalAgentComponent)GetActor().GetRootAnimatedComponent();
		}
		return BTNS_Active;
	}
	latent function Main() : EBTNodeStatus
	{
		while( true )
		{
			SleepOneFrame();
		}
		return BTNS_Active;
	}
}
class CBTTaskRootPitchDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskRootPitch';
}
