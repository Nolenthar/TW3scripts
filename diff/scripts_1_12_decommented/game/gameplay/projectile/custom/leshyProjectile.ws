class W3LeshyRootProjectile extends CProjectileTrajectory
		var victim 			: CGameplayEntity;
		
				theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
				GCameraShake(1.0, true, fxEntity.GetWorldPosition(), 30.0f);
		var attributeName 	: name;
		var victims 		: array<CGameplayEntity>;
		var rootDmg 		: float;
		var i 				: int;
		attributeName = GetBasicAttackDamageAttributeName(theGame.params.ATTACK_NAME_HEAVY, theGame.params.DAMAGE_NAME_PHYSICAL);
		
		FindGameplayEntitiesInRange( victims, fxEntity, 2, 99, , FLAG_OnlyAliveActors );
		if ( victims.Size() > 0 )
		{
			for ( i = 0 ; i < victims.Size() ; i += 1 )
			{
				if ( !((CActor)victims[i]).IsCurrentlyDodging() )
				{
					action.Initialize( (CGameplayEntity)caster, victims[i], this, caster.GetName()+"_"+"root_projectile", EHRT_Light, CPS_AttackPower, false, true, false, false);
					action.AddDamage(theGame.params.DAMAGE_NAME_RENDING, rootDmg );
					theGame.damageMgr.ProcessAction( action );
					victims[i].OnRootHit();
				}
			}
		}
		delete action;
		var normal : Vector;
		
			theGame.GetWorld().StaticTrace( projPos + Vector(0,0,3), projPos - Vector(0,0,3), projPos, normal );
			DelayDamage( 0.3 );
		var attributeName : name;
			attributeName = GetBasicAttackDamageAttributeName(theGame.params.ATTACK_NAME_LIGHT, theGame.params.DAMAGE_NAME_PHYSICAL);