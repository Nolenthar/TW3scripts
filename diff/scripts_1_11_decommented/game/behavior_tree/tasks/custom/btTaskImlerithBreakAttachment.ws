class CBTTaskImlerithBreakAttachment extends IBehTreeTask
{
	var rigidMeshComp : CRigidMeshComponent;
	function OnAnimEvent( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo ) : bool
	{
		if( animEventName == 'BreakAttachmentShield' )
		{
			GetNPC().shieldDebris.BreakAttachment();
			rigidMeshComp = (CRigidMeshComponent)GetNPC().shieldDebris.GetComponentByClassName( 'CRigidMeshComponent' );
			rigidMeshComp.SetEnabled( true );
			return true;
		}
		return false;
	}
};
class CBTTaskImlerithBreakAttachmentDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskImlerithBreakAttachment';
};
