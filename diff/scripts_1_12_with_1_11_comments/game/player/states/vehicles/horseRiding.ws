state HorseRiding in CR4Player extends UseGenericVehicle
{
	private var dismountRequest : bool;
	private var vehicleCombatMgr : W3HorseCombatManager;
	
	private var meleeTicketRequest 	: int;
	private var rangeTicketRequest 	: int;
	
	private var scabbardsComp : CAnimatedComponent;
	
	default meleeTicketRequest		= -1;
	default rangeTicketRequest		= -1;

	private var initCamera : bool;
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	// INIT, ENTER, LEAVE //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	protected function Init()
	{
		super.Init();

		if( !vehicleCombatMgr )
		{
			vehicleCombatMgr = new W3HorseCombatManager in this;
		}
		
		vehicleCombatMgr.Setup( parent, vehicle );
		vehicleCombatMgr.GotoStateAuto();
		vehicle.SetCombatManager( vehicleCombatMgr );
		
		initCamera = true;
		
		CheckForWeapons();
		
		ProcessHorseRiding();
	}
	
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState(prevStateName);
		
		//patch 1.12 begin
		theTelemetry.LogWithName(TE_STATE_HORSE_RIDING);
		//patch 1.12 end
		
		ChangeTicketPool( true );
		
		scabbardsComp = (CAnimatedComponent)( parent.GetComponent( "scabbards_skeleton" ) );
		scabbardsComp.SetBehaviorVariable( 'onHorse', 0.5 );
		
		thePlayer.SoundEvent( "amb_g_speed_wind_start", 'head' );
		
		// enlarge combat radius
		parent.findMoveTargetDistMin = 20.f;
		
		parent.AddTimer( 'EnableDynamicCanter', 0.5 );
		
		parent.SetBehaviorVariable('playerRider', 1.f );
		
		dismountRequest = false;
	}
	
	event OnLeaveState( nextStateName : name )
	{ 
		var camera : CCustomCamera;
		
		camera = (CCustomCamera)theCamera.GetTopmostCameraObject();
		
		camera.EnableManualControl(true);
		cameraManualRotationDisabled = false;
		
		if( nextStateName == 'PlayerDialogScene' || nextStateName == 'NpcDialogScene' )
		{
			((W3HorseComponent)vehicle).OnStopTheVehicleInstant();
			parent.SignalGameplayEventParamInt( 'RidingManagerDismountHorse', DT_instant | DT_fromScript );
		}
		else
		{
			theGame.ActivateHorseCamera( false, 0.f );
		}
		
		ChangeTicketPool( false );
		
		camera.fov = 60;

		scabbardsComp.SetBehaviorVariable( 'onHorse', 0.0 );
		
		thePlayer.SoundEvent( "amb_g_speed_wind_stop", 'head' );
		
		//make combat radius smaller again
		parent.findMoveTargetDistMin = 10.f;
		
		vehicleCombatMgr.Destroy();
		
		dismountRequest = false;
		
		super.OnLeaveState(nextStateName);
	}
	
	event OnCombatStart()
	{
		parent.OnCombatStart();
		parent.AddTimer( 'DrawWeaponIfNeeded', 0.f);
	}
	
	event OnCombatFinished()
	{
		virtual_parent.OnCombatFinished();
		parent.RemoveTimer('DrawWeaponIfNeeded');
	}

	event OnDismountActionScriptCallback()
	{
		((W3HorseComponent)vehicle).OnHorseDismount();
	}
	
	timer function DrawWeaponIfNeeded( dt: float, id : int )
	{
		if( parent.IsInCombat() )
		{
			if ( parent.GetTarget() )
			{
				vehicleCombatMgr.OnDrawWeaponRequest();
				parent.RemoveTimer('DrawWeaponIfNeeded');
			}
		}
		else
			parent.RemoveTimer('DrawWeaponIfNeeded');
	}
	
	timer function EnableDynamicCanter( dt: float, id : int )
	{
		var horseComp : W3HorseComponent;
		
		horseComp = (W3HorseComponent)(((CR4PlayerStateHorseRiding)thePlayer.GetState( 'HorseRiding' )).vehicle);
		horseComp.OnEnableCanter();
	}
	
	event OnDeath( damageAction : W3DamageAction )
	{
		var target : CNode;
		var dismountDirection : float;
		var angleDistance : float;
		
		target = damageAction.attacker;
		
		if ( target )
		{
			angleDistance = NodeToNodeAngleDistance(target,virtual_parent);
			if ( AbsF(angleDistance) < 50 )
				dismountDirection = 0.f;
			else if ( angleDistance <= -50 )
				dismountDirection = 1.f;
			else
				dismountDirection = 2.f;
		}
		else
		{
			dismountDirection = 0.f;
		}
		virtual_parent.SetBehaviorVariable('dismountDirection', dismountDirection );
		
		virtual_parent.OnDeath( damageAction );
		
		parent.ClearCleanupFunction();
		PlayerDied();
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	// MAIN LOOP, DISMOUNTING //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	entry function ProcessHorseRiding()
	{
		parent.SetCleanupFunction( 'RidingCleanup' );
		
		LogAssert( vehicle, "HorseRiding::ProcessHorseRiding - vehicle is null" );
		
		Sleep( 0.1f );
		
		while( !dismountRequest )
		{
			FindTarget();

			parent.BreakPheromoneEffect();
	
			Sleep( 0.2f );
		}
		if ( parent.IsAlive() )
		{
			parent.ClearCleanupFunction();
			parent.GotoState( 'DismountHorse', true );
		}
		
	}
	
	entry function PlayerDied()
	{
		var playerHorseRiderSharedParams : CHorseRiderSharedParams;
		parent.RaiseForceEvent( 'Death' );
		parent.BreakAttachment();
		parent.WaitForBehaviorNodeDeactivation('dismountRagdollEnd',0.5);
		parent.SetKinematic(false);
		parent.EnableCollisions( true );
		parent.EnableCharacterCollisions( true );
		parent.RegisterCollisionEventsListener();
		((W3HorseComponent)vehicle).OnDismountStarted(parent);
		parent.GetRiderData().OnInstantDismount(parent);
		playerHorseRiderSharedParams = parent.GetRiderData().sharedParams;
		playerHorseRiderSharedParams.mountStatus = VMS_dismounted;
		((W3HorseComponent)vehicle).OnDismountFinished(parent,EVS_driver_slot);
		parent.SetUsedVehicle( NULL );
	}
	
	cleanup function RidingCleanup()
	{
		vehicle.ToggleVehicleCamera( false );
		
		// Do not call this here but maybe use instant dismount ?
		//vehicle.OnDismountStarted( parent );
		//vehicle.OnDismountFinished( parent );
		parent.SignalGameplayEventParamInt( 'RidingManagerDismountHorse', DT_instant | DT_fromScript );
		
		parent.EnableCharacterCollisions( true );
		parent.RegisterCollisionEventsListener();
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// CAMERA //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	private var currDesiredDist : float;
	private var cameraManualRotationDisabled : bool;
	
	private var wasTrailCameraActive : bool;
	private var trailCameraTimeStamp, trailCameraCooldown : float;
		
	default trailCameraCooldown = 1.5;
	default wasTrailCameraActive = false;

	event OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
	{	
		var camera : CCustomCamera;
		
		if ( !cameraManualRotationDisabled && parent.IsCameraLockedToTarget())
		{
			camera = (CCustomCamera)theCamera.GetTopmostCameraObject();
			camera.EnableManualControl(false);
			cameraManualRotationDisabled = true;
		}
		else if ( cameraManualRotationDisabled && !parent.IsCameraLockedToTarget() )
		{
			camera = (CCustomCamera)theCamera.GetTopmostCameraObject();
			camera.EnableManualControl(true);
			cameraManualRotationDisabled = false;
		}
		
		parent.UpdateLookAtTarget();
		return vehicleCombatMgr.OnGameCameraTick( moveData, dt );
	}
	
	event OnGameCameraPostTick( out moveData : SCameraMovementData, dt : float )
	{
		var camera 					: CCustomCamera;
		var horseSpeed				: float;
		var horseComp				: W3HorseComponent;
		var shouldStopCamera		: bool;
		var angleDistanceBetweenCameraAndHorse : float;
		
		
		if ( !parent.IsAlive() )
		{
			moveData.pivotDistanceController.SetDesiredDistance( 4.0 );
			moveData.pivotPositionController.SetDesiredPosition( parent.GetWorldPosition() );
			moveData.pivotRotationController.SetDesiredPitch( -40 );
			return true;
		}
		
		camera = (CCustomCamera)theCamera.GetTopmostCameraObject();
		
		if ( super.OnGameCameraPostTick( moveData, dt ) )
		{	
			if ( parent.IsCameraLockedToTarget() )
			{
				moveData.pivotDistanceController.SetDesiredDistance( 3.5f, 3.f );
				currDesiredDist = 3.5f;			
			}
			else
			{
				moveData.pivotDistanceController.SetDesiredDistance( 2.2f, 3.f );
				currDesiredDist = 2.2f;
			}
			return true;
		}
		
		horseComp = (W3HorseComponent)vehicle;
		
		if ( vehicleCombatMgr.IsInSwordAttackCombatAction() )
		{
			moveData.pivotDistanceController.SetDesiredDistance( 5.4f );
			currDesiredDist = 5.4;
		}
		else if ( !horseComp.inCanter && !horseComp.inGallop && !horseComp.OnCheckHorseJump() )
		{
			moveData.pivotDistanceController.SetDesiredDistance( 2.4 );
			currDesiredDist = 2.4;
			//theGame.GetGameplayConfigFloatValue( 'debugA' ) );
			//moveData.pivotRotationController.SetDesiredPitch( horseComp.GetCurrentPitch() - 10 );//theGame.GetGameplayConfigFloatValue( 'debugB' ) );
			if ( !horseComp.OnCheckHorseJump() )
				moveData.pivotRotationController.SetDesiredPitch( horseComp.GetCurrentPitch() - 10 );
		}
		else if ( horseComp.inCanter && !horseComp.OnCheckHorseJump() )
		{
			moveData.pivotDistanceController.SetDesiredDistance( 4.9f );
			currDesiredDist = 4.9;
		}
		else if ( horseComp.inGallop && !horseComp.OnCheckHorseJump() )
		{
			moveData.pivotDistanceController.SetDesiredDistance( 4.1f );
			currDesiredDist = 4.1;
		}
		
		if ( horseComp.OnCheckHorseJump() )
		{
			moveData.pivotDistanceController.SetDesiredDistance( currDesiredDist );
		}
		else
		{
			moveData.pivotRotationController.SetDesiredPitch( horseComp.GetCurrentPitch() - 10 );
		}
		
		if ( vehicleCombatMgr.IsInSwordAttackCombatAction() || horseComp.inCanter )
		{
			shouldStopCamera = false;
		}
		else
			shouldStopCamera = false;//parent.IsInCombat();
			
		DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector(0,0,0), 0.3f, dt );			
		
		if( horseComp.cameraMode == 1 )
		{
			if( !camera.IsManualControledHor() && horseComp.inputApplied )
			{
				if( !horseComp.inCanter && !horseComp.inGallop && !vehicleCombatMgr.IsInSwordAttackCombatAction() ) // follow camera
				{
					if( trailCameraTimeStamp + trailCameraCooldown > theGame.GetEngineTimeAsSeconds() ) // to avoid weird shot when manually moving camera after having trail camera active
					{
						parent.OnGameCameraPostTick( moveData, dt );
						return shouldStopCamera;
					}
					else if( trailCameraTimeStamp + trailCameraCooldown < theGame.GetEngineTimeAsSeconds() && wasTrailCameraActive )
					{
						moveData.pivotRotationVelocity.Yaw = 0.0; // to avoid weird shot when going back from trail camera to follow camera
						wasTrailCameraActive = false;
					}
				
					angleDistanceBetweenCameraAndHorse = AbsF( AngleDistance( VecHeading( theCamera.GetCameraDirection() ), parent.GetHeading() ) );
					
					if( angleDistanceBetweenCameraAndHorse < 30.0 )
						moveData.pivotRotationController.SetDesiredHeading( parent.GetHeading(), 0.5 );
					else if( angleDistanceBetweenCameraAndHorse < 90.0 )
						moveData.pivotRotationController.SetDesiredHeading( parent.GetHeading(), 0.35 );
					else
						moveData.pivotRotationController.SetDesiredHeading( parent.GetHeading(), 0.2 );
						
					parent.OnGameCameraPostTick( moveData, dt );
					return true;	
				}
				else // trail camera
				{
					wasTrailCameraActive = true;
					trailCameraTimeStamp = theGame.GetEngineTimeAsSeconds();
				}
			}
			else // manual control
			{
				if( wasTrailCameraActive ) 
				{
					moveData.pivotRotationVelocity.Yaw = 0.0; // to avoid weird shot when going back from trail camera to manual control
					wasTrailCameraActive = false;
				}
			}
		}
		
		parent.OnGameCameraPostTick( moveData, dt );

		return shouldStopCamera;
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// PRIVATE FUNCTIONS ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private function CheckForWeapons()
	{
		if( parent.GetCurrentMeleeWeaponType() == PW_Steel || parent.GetCurrentMeleeWeaponType() == PW_Silver )
		{
			OnDrawWeaponStart();
		}
	}
	
	function ChangeTicketPool( apply : bool )
	{
		var combatData : CCombatDataComponent;
		
		combatData = parent.GetCombatDataComponent();
		
		if ( apply )
		{
			if ( meleeTicketRequest	== -1 )
			{
				//adds +400 to ticket pool
				meleeTicketRequest = combatData.TicketSourceOverrideRequest( 'TICKET_Melee', 400, 0.0 );
			}
			if ( rangeTicketRequest == -1 )
			{
				//adds +100 to ticket pool
				rangeTicketRequest = combatData.TicketSourceOverrideRequest( 'TICKET_Range', 100, 0.0 );
			}
		}
		else
		{
			if ( meleeTicketRequest != -1 && combatData.TicketSourceClearRequest( 'TICKET_Melee', meleeTicketRequest ) )
			{
				meleeTicketRequest = -1;
			}
			if ( rangeTicketRequest != -1 && combatData.TicketSourceClearRequest( 'TICKET_Range', rangeTicketRequest ) )
			{
				rangeTicketRequest = -1;
			}
		}
	}	
	
	function DismountVehicle()
	{
		dismountRequest = true;
	}
	
	private function HorseHit()
	{
		var action : W3DamageAction;
		var targets : array<CActor>;
		var victims : array<CActor>;
		var attackpoint : Vector;
		var size, i : int;
		
		parent.GetVisibleEnemies( targets );
		
		attackpoint = parent.GetWorldPosition() + parent.GetWorldForward() * 1.5f;
		size = targets.Size();
		for( i = 0; i < size; i += 1 )
		{
			if( VecLengthSquared( targets[i].GetWorldPosition() - attackpoint ) < 1.f )
			{
				victims.PushBack( targets[i] );
			}
		}
		
		if( victims.Size() > 0 )
		{
			action = new W3DamageAction in this;
			action.Initialize( parent, victims[0], vehicle, parent.GetName(), EHRT_Heavy, CPS_AttackPower, true,false,false,false );
			action.AddDamage( theGame.params.DAMAGE_NAME_BLUDGEONING, 50.f );
			
			theGame.damageMgr.ProcessAction( action );
			
			delete action;
		}
	}
		
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// EVENTS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	event OnAnimEvent_ActionBlend( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		if ( animEventType == AET_DurationStart )
				parent.SetBIsCombatActionAllowed( true );
				
		virtual_parent.OnAnimEvent_ActionBlend( animEventName, animEventType, animInfo );
	}
	
	event OnAnimEvent_Sign( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		vehicleCombatMgr.OnProcessAnimEvent( animEventName );
	}
	
	event OnAnimEvent_Throwable( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		vehicleCombatMgr.OnProcessAnimEvent( animEventName );
	}
	
	event OnDrawWeaponStart()
	{
		parent.SetBehaviorVariable( 'isHoldingWeaponR', 1.f, true );
		parent.SetBehaviorVariable( 'swordAdditiveBlendWeight', 1.f );
	}
	
	event OnHolsterWeaponStart()
	{
		parent.SetBehaviorVariable( 'isHoldingWeaponR', 0.f, true );
		parent.SetBehaviorVariable( 'swordAdditiveBlendWeight', 0.f );
	}
	
	event OnTakeDamage( action : W3DamageAction)
	{
		virtual_parent.OnTakeDamage( action );
	}
	
	event OnRaiseSignEvent()
	{
		return vehicleCombatMgr.OnRaiseSignEvent();
	}
	
	// Do nothing
	event OnProcessCastingOrientation( isContinueCasting : bool ) {}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// COMBAT ACTIONS //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class W3HorseCombatManager extends W3VehicleCombatManager
{
	default autoState = 'HorseNull';
}

state HorseNull in W3HorseCombatManager extends Null
{
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState( prevStateName );
		
		if( prevStateName != 'InAir' )
			((W3HorseComponent)parent.vehicle).OnCombatActionEnd();
	}
}
