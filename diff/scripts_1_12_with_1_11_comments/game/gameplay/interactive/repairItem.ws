/***********************************************************************/
/** Copyright © 2013-2014
/** Author : Tomek Kozera
/***********************************************************************/

//Class for world interactive item repair items (e.g. whetstone, armor repair table)
class W3ItemRepairObject extends CR4MapPinEntity
{
	private editable var repairSword, repairArmor : bool;
	public editable var chargesArmor, chargesWeapon : int;
	private optional autobind interactionComp : CInteractionComponent = single;	//it's mandatory but this (optional keyword) is the only hackfix for xbox log spam now
	
		default repairSword = false;
		default repairArmor = false;
		default chargesArmor = 50;
		default chargesWeapon = 200;
		
		hint chargesArmor = "For how many armor hits will the buff be active";
		hint chargesWeapon = "For how many weapon attack will the buff be active";
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	event OnSpawned(spawnData : SEntitySpawnData)
	{
		AddTimer('WaitForPlayerSpawn', 0.3, true);
		
		if ( repairArmor )
		{
			AddTag('Armorer');
		}	
		if ( repairSword )
		{
			AddTag('Blacksmith');
		}
	}
	
	event OnAreaEnter( area : CTriggerAreaComponent, activator : CComponent )
	{
		var mapManager : CCommonMapManager = theGame.GetCommonMapManager();

		if( interactionComp && ( activator.GetEntity() == GetWitcherPlayer() ) )
		{
			interactionComp.SetEnabled(CheckIfPlayerCanInteract());
			mapManager.SetEntityMapPinDiscoveredScript( false, entityName, true );
		}
	}
	
	public function IsWeaponRepairEntity() : bool
	{
		return repairSword;
	}
	
	//FINAL HACK - waiting till thePlayer will not be NULL
	timer function WaitForPlayerSpawn(dt : float, id : int)
	{
		if( !interactionComp || !thePlayer )
		{
			return;
		}
			
		interactionComp.SetEnabled( CheckIfPlayerCanInteract() );
		RemoveTimer('WaitForPlayerSpawn');
	}
	
	public function CheckIfPlayerCanInteract() : bool
	{
		return true;
	}
	
	event OnAreaExit( area : CTriggerAreaComponent, activator : CComponent )
	{
		if( interactionComp )
		{
			interactionComp.SetEnabled(false);
		}
	}
		
	event OnInteraction( actionName : string, activator : CEntity )
	{	
		//if(thePlayer.inv.AddRepairObjectItemBonuses(repairArmor, repairSword, chargesArmor, chargesWeapon))
		if(GetWitcherPlayer().AddRepairObjectBuff(repairArmor, repairSword))
		{
			//UI info
			GetWitcherPlayer().DisplayHudMessage(GetLocStringByKeyExt("panel_hud_message_repair_done"));
			
			//sound
			if(repairSword)
			{
				SoundEvent("gui_inventory_silversword_attach");
			}
			else
			{
				SoundEvent("gui_inventory_armor_attach");
			}
			
			//patch 1.12 begin
			//fade
			//theGame.FadeOutAsync();
			//AddTimer('FadeInTimer', 1);
			//patch 1.12 end
		}
		else
		{
			//nothing to upgrade
			GetWitcherPlayer().DisplayHudMessage(GetLocStringByKeyExt("panel_hud_message_repair_nothing"));
		}
		
		//tutorial
		if(ShouldProcessTutorial('TutorialRepairObjects'))
		{
			FactsAdd("tut_repair_interaction",1);
		}
	}
	
	private timer function FadeInTimer(dt : float, id : int)
	{
		theGame.FadeInAsync();
	}
	
	public final function RepairsSword() : bool
	{
		return repairSword;
	}
	
	public final function RepairsArmor() : bool
	{
		return repairArmor;
	}
}