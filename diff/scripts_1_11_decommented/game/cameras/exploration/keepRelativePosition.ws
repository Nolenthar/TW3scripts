class CCameraPivotPositionControllerKeepRelative extends ICustomCameraScriptedPivotPositionController
{
	private	var	offset	: Vector;
	private	var	isSet	: bool;		default	isSet	= false;
	protected function ControllerUpdate( out currentPosition : Vector, out currentVelocity : Vector, timeDelta : float )
	{
		if( !isSet )
		{
			offset	= currentPosition - thePlayer.GetWorldPosition();
			isSet	= true;
		}
		currentPosition = thePlayer.GetWorldPosition() + offset;
	}
	protected function ControllerActivate( currentOffset : float )
	{
		isSet	= false;
	}
}
