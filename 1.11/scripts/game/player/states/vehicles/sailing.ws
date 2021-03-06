/***********************************************************************/
/** Witcher Script file
/***********************************************************************/
/** Copyright © 2013 CDProjektRed
/** Author : ?
/**			 Tomasz Kozera
			 Wojtek Żerek
/***********************************************************************/

state Sailing in CR4Player extends UseGenericVehicle
{
	private var boatLogic : CBoatComponent;
	private var remainingSlideDuration : float;
	private var vehicleCombatMgr : W3VehicleCombatManager;
	private var dismountRequest : bool;
	
	private const var angleToSeatFromBack : float;
	private const var angleToSeatFromForward : float;	
	
	default remainingSlideDuration = 0.f;
	default angleToSeatFromBack	= 150.0f;
	default angleToSeatFromForward = 30.0f;
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	// INIT, ENTER, LEAVE //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	protected function Init()
	{
		super.Init();

		if( !vehicleCombatMgr )
		{
			vehicleCombatMgr = new W3VehicleCombatManager in this;
		}
		
		parent.UnblockAction( EIAB_Crossbow, 'DismountVehicle2' );	
		dismountRequest = false;
		
		vehicleCombatMgr.Setup( parent, vehicle );
		vehicleCombatMgr.GotoStateAuto();
		vehicle.SetCombatManager( vehicleCombatMgr );
		
		parent.SetOrientationTarget( OT_Camera );
		
		boatLogic = (CBoatComponent)vehicle; // what's this for? vehicleCleanup
		ProcessBoatSailing();
	}
	
	event OnEnterState( prevStateName : name )
	{
		var commonMapManager : CCommonMapManager = theGame.GetCommonMapManager();
		
		super.OnEnterState( prevStateName );
		
		theTelemetry.Log( TE_STATE_SAILING );
		
		parent.SetBehaviorVariable( 'keepSpineUpright', 0.f );	
		commonMapManager.NotifyPlayerMountedBoat();
		
		InitCamera();
	}
	
	event OnLeaveState( nextStateName : name )
	{ 
		var commonMapManager : CCommonMapManager = theGame.GetCommonMapManager();
		
		theInput.SetContext( parent.GetExplorationInputContext() );	
		
		parent.SetBehaviorVariable( 'keepSpineUpright', 1.f );
		commonMapManager.NotifyPlayerDismountedBoat();		
		
		super.OnLeaveState( nextStateName );
		
		theInput.GetContext();
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	// MAIN LOOP, DISMOUNTING //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	entry function ProcessBoatSailing()
	{
		var axis : float;
		
		parent.SetCleanupFunction( 'SailingCleanup' );
		
		LogAssert( vehicle, "Sailing::ProcessBoatSailing - vehicle is null" );
				
		while( !dismountRequest )
		{
			FindTarget();
			
			Sleep( 0.2f );
			
			//FIXME change to actual boat direction so that it would work when the NPC is steering the boat
			//axis = theInput.GetActionValue( 'GI_AxisLeftX' );
			//if(axis < -0.1 || axis > 0.1)
			//	boatLogic.SetSailDir( SignF( theInput.GetActionValue( 'GI_AxisLeftX' ) ) );
		}
		
		parent.ClearCleanupFunction();
		
		((CPlayerStateDismountBoat)parent.GetState('DismountBoat')).SetupState( boatLogic, DT_normal );
		((CPlayerStateDismountBoat)parent.GetState('DismountBoat')).DismountFromPassenger( false );
		parent.GotoState( 'DismountBoat', true );
	}
	
	cleanup function SailingCleanup()
	{
		vehicle.ToggleVehicleCamera( false );
		
		vehicle.OnDismountStarted( parent );
		vehicle.OnDismountFinished( parent, thePlayer.GetRiderData().sharedParams.vehicleSlot );	
		
		parent.EnableCollisions( true );		
		parent.RegisterCollisionEventsListener();
	}
	
	function DismountVehicle()
	{
		dismountRequest = true;
	}
	
	event OnReactToBeingHit( damageAction : W3DamageAction )
	{
		var boatHitDirection : int;
		var angleDistance : float;
		var target : CNode;
		
		target = damageAction.attacker;
		
		if ( target )
		{
			angleDistance = NodeToNodeAngleDistance(target,parent);
			if ( AbsF(angleDistance) < 45 )
				boatHitDirection = 0; // front
			else if ( AbsF(angleDistance) > 135 )
				boatHitDirection = 1; // back
			else if ( angleDistance > 45 )
				boatHitDirection = 3; // left
			else if ( angleDistance < -45 )
				boatHitDirection = 2; // right
			else
				boatHitDirection = 0; // front
			
		}
		else
		{
			boatHitDirection = 0;
		}
		
		parent.SetBehaviorVariable( 'boatHitDirection', boatHitDirection);
		
		virtual_parent.OnReactToBeingHit( damageAction );
	}
	
	// MS: This is commented out because geralt falls through the boat when he ragdolls while mounted on boat
	/*event OnDeath( damageAction : W3DamageAction )
	{
		virtual_parent.OnDeath( damageAction );
		parent.SetKinematic(false);
		parent.EnableCollisions( true );
	}*/
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// CAMERA //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private var angleDamper	: float;
	private var offsetDamper : float;
	private var rudderDamper : float;
	private var cameraSide : float;
	
	default rudderDamper = 0.f;
	default cameraSide = 1.f;
	
	private function InitCamera()
	{
		//camera.ChangePivotPositionController( 'Boat_PC' );
		camera.ChangePivotRotationController( 'Boat_RC' );
		camera.ChangePivotDistanceController( 'Boat_DC' );
	}
	
	
	private final function GetGearRatio( gear : int ) : float
	{
		if( ( gear == 1 ) || ( gear == -1 ) )
		{
			return 1.0f;
		}
		
		if( gear == 2 )
		{
			return 1.5f;
		}
		
		if( gear == 3 )
		{
			return 2.2f;
		}
		
		return 0.0f;
	}
	
	event OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
	{
		var turnFactor  : float;
		var velocityRatio : float;		
		var sailCameraOffset : float;
		
		var fovDistPitch : Vector;
		var offsetZ : float;
		var offsetUp : Vector;
		var sailOffset : float;
		var boatComponent: CBoatComponent;
		
		var boatPPC : CCustomCameraBoatPPC;
		var cameraToBoatDot : float;
		var turnFactorSum : float;
		
		parent.UpdateLookAtTarget();
		
		boatComponent = (CBoatComponent)vehicle;
		if( boatComponent )
		{
			boatComponent.localSpaceCameraTurnPercent = VecDot2D( camera.GetHeadingVector(), VecCross( boatComponent.GetHeadingVector(), Vector( 0.0f, 0.0f, 1.0f ) ) );
			
			// Clamp it
			if( AbsF( boatComponent.localSpaceCameraTurnPercent ) < 0.1f )
			{
				boatComponent.localSpaceCameraTurnPercent = 0.0f;
			}
			
			// If we look backward set max tilt
			if( VecDot2D( camera.GetHeadingVector(), boatComponent.GetHeadingVector() ) < 0.0f )
			{
				boatComponent.localSpaceCameraTurnPercent = SgnF( boatComponent.localSpaceCameraTurnPercent );
			}
		}
		
		ShouldEnableBoatMusic();

		turnFactor	= theInput.GetActionValue( 'GI_AxisLeftX' );		
		// Combie global space camera view with standard rudder turning
		turnFactorSum = AbsF( turnFactor + boatComponent.localSpaceCameraTurnPercent );		
		if( turnFactorSum > 1.0f )
		{
			turnFactorSum = AbsF( turnFactor * 2.0f + boatComponent.localSpaceCameraTurnPercent );
			turnFactor = ( turnFactor * 2.0f ) / turnFactorSum + boatComponent.localSpaceCameraTurnPercent / turnFactorSum;
		}
		else
		{
			turnFactor = turnFactor + boatComponent.localSpaceCameraTurnPercent;
		}	
		
		LogChannel('Boat', "Rudder turn factor: " + turnFactor );
		
		// Damp rudder turning
		rudderDamper = rudderDamper + dt * 6.f * ( turnFactor - rudderDamper );	
		LogChannel('Boat', "Rudder damper: " + rudderDamper );
		
		boatLogic.SetRudderDir( virtual_parent, rudderDamper );
		
		if( this.vehicleCombatMgr.IsInCombatAction() )
		{
			moveData.pivotRotationController.SetDesiredHeading( moveData.pivotRotationValue.Yaw );	
		}
		else
		{
			moveData.pivotRotationController.SetDesiredHeading( parent.GetHeading() - rudderDamper * 20.f );		
		}

		if( vehicleCombatMgr.OnGameCameraTick( moveData, dt ) )
		{
			return true;
		}
		
		theGame.GetGameCamera().ChangePivotDistanceController( 'Boat_DC' );
		theGame.GetGameCamera().ChangePivotRotationController( 'Boat_RC' );
		//theGame.GetGameCamera().ChangePivotPositionController( 'Boat_PC' );
		
		// HACK
		moveData.pivotRotationController = theGame.GetGameCamera().GetActivePivotRotationController();
		moveData.pivotDistanceController = theGame.GetGameCamera().GetActivePivotDistanceController();
		moveData.pivotPositionController = theGame.GetGameCamera().GetActivePivotPositionController();
		// END HACK	
		
		if( boatLogic.GameCameraTick( fovDistPitch, offsetZ, sailOffset, dt, false ) )
		{
			boatPPC = ( CCustomCameraBoatPPC )moveData.pivotPositionController;
			if( boatPPC )
			{
				offsetUp = Vector( 0.0f, 0.0f, offsetZ );
				boatPPC.SetPivotOffset( offsetUp );
			}

			moveData.pivotRotationController.SetDesiredPitch( fovDistPitch.Z );
			moveData.pivotDistanceController.SetDesiredDistance( fovDistPitch.Y );
			
			sailCameraOffset = boatLogic.GetSailTilt() * sailOffset;
			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( sailCameraOffset, 0.f, 0.f ), 0.5f, dt );
		}
		
		return true;
	}
	
	event OnGameCameraPostTick( out moveData : SCameraMovementData, dt : float )
	{
		if ( super.OnGameCameraPostTick( moveData, dt ) )
			return true;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// PRIVATE FUNCTIONS ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function CanAccesFastTravel( target : W3FastTravelEntity ) : bool // not actually private
	{
		return target.canBeReachedByBoat;
	}
	
	public function TriggerDrowning()
	{
		if( vehicleCombatMgr )
		{
			vehicleCombatMgr.OnForceItemActionAbort();
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SAILING PASSIVE /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

state SailingPassive in CR4Player extends UseGenericVehicle
{
	private var boatLogic : CBoatComponent;
	private var dismountRequest : bool;
	private var vehicleCombatMgr : W3VehicleCombatManager;
	private var rudderDamper : float;
	
	default rudderDamper = 0.f;
	default dismountRequest = false;
	
	protected function Init()
	{
		super.Init();
		boatLogic = (CBoatComponent)vehicle;
	}
	
	event OnEnterState( prevStateName : name )
	{
		var commonMapManager : CCommonMapManager = theGame.GetCommonMapManager();
		
		super.OnEnterState(prevStateName);
		
		if( !vehicleCombatMgr )
		{
			vehicleCombatMgr = new W3VehicleCombatManager in this;
		}
	
		dismountRequest = false;
		
		vehicleCombatMgr.Setup( parent, vehicle );
		vehicleCombatMgr.GotoStateAuto();
		vehicle.SetCombatManager( vehicleCombatMgr );		
		
		ProcessBoatSailingPassive();
				
		theGame.GetGameCamera().SetAllowAutoRotation( false );
		commonMapManager.NotifyPlayerMountedBoat();
	}
	
	event OnLeaveState( nextStateName : name )
	{
		var commonMapManager : CCommonMapManager = theGame.GetCommonMapManager();
		
		super.OnLeaveState( nextStateName );
		theGame.GetGameCamera().SetAllowAutoRotation( true );
		commonMapManager.NotifyPlayerDismountedBoat();
	}	
	
	entry function ProcessBoatSailingPassive()
	{
		var axis : float;
		
		parent.EnableCollisions( false );
		
		//attach
		theSound.SoundEvent( "boat_sail_temp_loop" );
		theSound.EnterGameState(ESGS_Boat);	
		parent.CreateAttachment( boatLogic.GetEntity(), 'seat_passenger' );	

		//idle
		while( !dismountRequest )
		{
			FindTarget();
			Sleep( 0.2f );
		}
				
		parent.ClearCleanupFunction();
		
		((CPlayerStateDismountBoat)parent.GetState('DismountBoat')).SetupState( boatLogic, DT_normal );
		((CPlayerStateDismountBoat)parent.GetState('DismountBoat')).DismountFromPassenger( true );
		parent.GotoState( 'DismountBoat', true );
	}
	function DismountVehicle()
	{
		dismountRequest = true;
	}
	
	event OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
	{
		var turnFactor  : float;
		var velocityRatio : float;		
		var sailCameraOffset : float;
		
		var fovDistPitch : Vector;
		var offsetZ : float;
		var offsetUp : Vector;
		var sailOffset : float;
		
		var boatPPC : CCustomCameraBoatPPC;
		
		parent.UpdateLookAtTarget();
		
		ShouldEnableBoatMusic();
		
		//turnFactor	= theInput.GetActionValue( 'GI_AxisLeftX' );
		rudderDamper = rudderDamper + dt * 6.f * ( turnFactor - rudderDamper );	
		boatLogic.SetRudderDir( virtual_parent, rudderDamper );
		
		if ( this.vehicleCombatMgr.IsInCombatAction() )
		{
			moveData.pivotRotationController.minPitch = -55.f;
			moveData.pivotRotationController.maxPitch = theGame.GetGameplayConfigFloatValue( 'debugA' );
			moveData.pivotRotationController.SetDesiredHeading( moveData.pivotRotationValue.Yaw );
		}
		else
		{
			moveData.pivotRotationController.minPitch = -55.f;
			moveData.pivotRotationController.maxPitch = -3;
			moveData.pivotRotationController.SetDesiredHeading( parent.GetHeading() - rudderDamper * 20.f );
		}
		
		if( vehicleCombatMgr.OnGameCameraTick( moveData, dt ) )
		{
			return true;
		}
		
		theGame.GetGameCamera().ChangePivotDistanceController( 'Boat_DC' );
		theGame.GetGameCamera().ChangePivotRotationController( 'Boat_RC' );
		//theGame.GetGameCamera().ChangePivotPositionController( 'Boat_PC' );
		
		// HACK
		moveData.pivotRotationController = theGame.GetGameCamera().GetActivePivotRotationController();
		moveData.pivotDistanceController = theGame.GetGameCamera().GetActivePivotDistanceController();
		moveData.pivotPositionController = theGame.GetGameCamera().GetActivePivotPositionController();
		// END HACK			
		
		if( boatLogic.GameCameraTick( fovDistPitch, offsetZ, sailOffset, dt, true ) )
		{
			camera.fov = fovDistPitch.X;
			
			boatPPC = ( CCustomCameraBoatPPC )moveData.pivotPositionController;
			if( boatPPC )
			{
				offsetUp = Vector( 0.0f, 0.0f, offsetZ );
				boatPPC.SetPivotOffset( offsetUp );
			}

			moveData.pivotRotationController.SetDesiredPitch( fovDistPitch.Z );
			moveData.pivotDistanceController.SetDesiredDistance( fovDistPitch.Y );
			
			sailCameraOffset = boatLogic.GetSailTilt() * sailOffset;
			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( sailCameraOffset, 0.f, 0.f ), 0.5f, dt );
		}
		
		return true;
	}
	
	event OnGameCameraPostTick( out moveData : SCameraMovementData, dt : float )
	{
		if ( super.OnGameCameraPostTick( moveData, dt ) )
			return true;
	}
	
	// MS: This is commented out because geralt falls through the boat when he ragdolls while mounted on boat
	/*event OnDeath( damageAction : W3DamageAction )
	{
		virtual_parent.OnDeath( damageAction );
		parent.SetKinematic(false);
		parent.EnableCollisions( true );
	}*/
}
