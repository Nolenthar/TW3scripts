////////////////////////////////////////////////////////////////////
// CBTTaskSailorMountBoat
class CBTTaskSailorMountBoat extends IBehTreeTask
{
	var boatTag 			: name;
	var aiStorageHandler 	: CAIStorageHandler;
	var instantMount		: bool;
	
	function Initialize()
	{		
		aiStorageHandler = new CAIStorageHandler in this;
		aiStorageHandler.Initialize( 'RiderData', '*CAIStorageRiderData', this );
		aiStorageHandler.Get();
	}
    latent function Main() : EBTNodeStatus
    {        
        var actor       : CActor = GetActor();
        var riderData 	: CAIStorageRiderData;
        var boatEntity	: CEntity;
        var mountType	: EMountType = MT_instant;
        
        // [ Step ] Find boat entity
		boatEntity = theGame.GetEntityByTag( boatTag );
		if( !boatEntity )
		{
			return BTNS_Failed;
		}
		riderData		= (CAIStorageRiderData)aiStorageHandler.Get();
		EntityHandleSet( riderData.sharedParams.boat, boatEntity );
		
		if ( instantMount == false )
		{
			mountType = MT_normal;
		}
        
        actor.SignalGameplayEventParamInt( 'RidingManagerMountBoat', mountType );
		
		while ( true )
		{
			if ( riderData.GetRidingManagerCurrentTask() == RMT_None && riderData.sharedParams.mountStatus == VMS_mounted )
			{
				if ( riderData.ridingManagerMountError )
				{
					return BTNS_Failed;
				}
				return BTNS_Completed;
			}
			SleepOneFrame();
		}		
        return BTNS_Completed;
    }
}
// CBTTaskSailorMountBoatDef
class CBTTaskSailorMountBoatDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskSailorMountBoat';

	editable var boatTag 		: CBehTreeValCName;
	editable var instantMount	: CBehTreeValBool;
	
	default instantMount = true;
}

////////////////////////////////////////////////////////////////////
// CBTTaskSailorDismountBoat
class CBTTaskSailorDismountBoat extends IBehTreeTask
{
	var aiStorageHandler 	: CAIStorageHandler;
	
	function Initialize()
	{		
		aiStorageHandler = new CAIStorageHandler in this;
		aiStorageHandler.Initialize( 'RiderData', '*CAIStorageRiderData', this );
		aiStorageHandler.Get();
	}
    latent function Main() : EBTNodeStatus
    {
        var actor       : CActor = GetActor();
        var riderData 	: CAIStorageRiderData;
        riderData		= (CAIStorageRiderData)aiStorageHandler.Get();
        actor.SignalGameplayEventParamInt( 'RidingManagerDismountBoat', DT_instant );
		
		while ( true )
		{
			if ( riderData.GetRidingManagerCurrentTask() == RMT_None && riderData.sharedParams.mountStatus == VMS_dismounted )
			{
				if ( riderData.ridingManagerMountError )
				{
					return BTNS_Failed;
				}
				return BTNS_Completed;
			}
			SleepOneFrame();
		}	
		EntityHandleSet( riderData.sharedParams.boat, NULL );
        return BTNS_Completed;
    }
 
}
// CBTTaskSailorDismountBoatDef
class CBTTaskSailorDismountBoatDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskSailorDismountBoat';
}


////////////////////////////////////////////////////////////////////
// CBTTaskCondIsMountedOnBoat
class CBTTaskCondIsMountedOnBoat extends IBehTreeTask
{
	var aiStorageHandler 	: CAIStorageHandler;
	var riderData 	: CAIStorageRiderData;
	
	
	function IsAvailable() : bool
	{
		if ( !riderData )
			riderData		= (CAIStorageRiderData)aiStorageHandler.Get();
			
		if ( riderData && riderData.sharedParams && EntityHandleGet( riderData.sharedParams.boat ) )
		{
			return true;
		}
		
		return false;
	}
	
	function Initialize()
	{		
		aiStorageHandler = new CAIStorageHandler in this;
		aiStorageHandler.Initialize( 'RiderData', '*CAIStorageRiderData', this );
		aiStorageHandler.Get();
	}
}

// CBTTaskSailorDismountBoatDef
class CBTTaskCondIsMountedOnBoatDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskCondIsMountedOnBoat';
}


////////////////////////////////////////////////////////////////////
// CBTTaskTeleportToEntity
class CBTTaskTeleportToEntity extends IBehTreeTask
{
	var entityTag : name;
	
	function OnActivate() : EBTNodeStatus
	{
		var actor 			: CActor = GetActor();
		var targetEntity 	: CEntity;
		targetEntity = theGame.GetEntityByTag( entityTag );
		if ( targetEntity )
		{
			actor.TeleportWithRotation( targetEntity.GetWorldPosition(), targetEntity.GetWorldRotation() );
		}
		return BTNS_Completed;
	}
}
// CBTTaskTeleportToEntityDef
class CBTTaskTeleportToEntityDef extends IBehTreeTaskDefinition
{
	default instanceClass = 'CBTTaskTeleportToEntity';

	editable var entityTag : CBehTreeValCName;
}