class W3MinimapZoomScaleTrigger extends CGameplayEntity
{
	private editable var zoomScale : float;
	default zoomScale = 1.0f;
	private var previousZoomScale : float;
	event OnAreaEnter( area : CTriggerAreaComponent, activator : CComponent )
	{
	}
	event OnAreaExit( area : CTriggerAreaComponent, activator : CComponent )
	{
	}
}
