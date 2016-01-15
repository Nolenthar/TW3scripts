import function PhysxDebugger( host : string ) : bool;
import function SetPhysicalEventOnCollision( triggerObject : CComponent, optional receiverObject : CObject, optional onEventName : name ) : bool;
import function SetPhysicalEventOnTriggerFocusFound( triggerObject : CComponent, optional receiverObject : CObject, optional onEventName : name ) : bool;
import function SetPhysicalEventOnTriggerFocusLost( triggerObject : CComponent, optional receiverObject : CObject, optional onEventName : name ) : bool;
exec function Pvd( host : string ) : bool
{
	return PhysxDebugger( host );
}
