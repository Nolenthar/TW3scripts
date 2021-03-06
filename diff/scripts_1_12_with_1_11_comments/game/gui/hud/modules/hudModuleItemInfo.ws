
enum HudItemInfoBinding
{
	HudItemInfoBinding_item1 = 0,
	HudItemInfoBinding_potion1 = 1,
	HudItemInfoBinding_potion2 = 2,
	HudItemInfoBinding_potion3 = 3,
	HudItemInfoBinding_potion4 = 4
};

//patch 1.12 begin
struct SHudItemInfo
{
	var m_icon		: string;
	var m_category	: string;
	var m_itemName	: string;
	var m_ammoStr	: string;
	var m_btn		: int;
	var m_pcBtn		: int;
};
//patch 1.12 end

class CR4HudModuleItemInfo extends CR4HudModuleBase
{
	private var m_currentItemSelected 	: SItemUniqueId;
	private var m_currentItemOnSlot1 	: SItemUniqueId;
	private var m_currentItemOnSlot2 	: SItemUniqueId;
	private var m_currentItemOnSlot3 	: SItemUniqueId;
	private var m_currentItemOnSlot4 	: SItemUniqueId;
	
	private var m_lastBoltItem : SItemUniqueId;

	private var m_currentItemSelectedAmmo	: int;
	private var m_currentItemOnSlot1Ammo	: int;
	private var m_currentItemOnSlot2Ammo	: int;
	private var m_currentItemOnSlot3Ammo	: int;
	private var m_currentItemOnSlot4Ammo	: int;

	private var m_fxEnableSFF : CScriptedFlashFunction;
	private var m_fxUpdateElementSFF : CScriptedFlashFunction;
	private var m_fxHideSlotsSFF : CScriptedFlashFunction;
	private var m_fxSetAlwaysDisplayed : CScriptedFlashFunction;
	private var m_flashValueStorage : CScriptedFlashValueStorage;
	private var m_fxSetItemInfo : CScriptedFlashFunction;
	private var m_fxSwitchAnimation : CScriptedFlashFunction;
	private var m_fxShowButtonHints : CScriptedFlashFunction;
	private var m_IsPlayerCiri					: bool;
	default m_IsPlayerCiri = false;
	//patch 1.12 begin
	//private var cached_item0, cached_item1, cached_item2 : SItemUniqueId;
	//patch 1.12 end
	private var m_runword6Applied : bool;
	//patch 1.12 begin
	private var m_previousShowButtonHints		: int;						default m_previousShowButtonHints    = -1;
	private var m_previousSetItemInfo			: array< SHudItemInfo >;
	//patch 1.12 end
	
	event /* flash */ OnConfigUI()
	{
		var flashModule : CScriptedFlashSprite;
		var hud : CR4ScriptedHud;

		m_anchorName = "mcAnchorItemInfo";
		m_flashValueStorage = GetModuleFlashValueStorage();
		super.OnConfigUI();

		flashModule 			= GetModuleFlash();	
		m_fxEnableSFF			= flashModule.GetMemberFlashFunction( "EnableElement" );
		m_fxUpdateElementSFF	= flashModule.GetMemberFlashFunction( "UpdateElement" );
		m_fxHideSlotsSFF		= flashModule.GetMemberFlashFunction( "HideSlots" );
		m_fxSetAlwaysDisplayed	= flashModule.GetMemberFlashFunction( "setAlwaysDisplayed" );
		m_fxSetItemInfo 		= flashModule.GetMemberFlashFunction( "setItemInfo" );
		m_fxSwitchAnimation		= flashModule.GetMemberFlashFunction( "animatePotionSwitch" );
		m_fxShowButtonHints		= flashModule.GetMemberFlashFunction( "showButtonHints" );
		//patch 1.12 begin
		m_previousSetItemInfo.Resize( EnumGetMax( 'HudItemInfoBinding' ) + 1 );
		//patch 1.12 end
		
		ClearItems();
		
		SetTickInterval( 0.25 );
		
		hud = (CR4ScriptedHud)theGame.GetHud();
		
		if (hud)
		{
			hud.UpdateHudConfig('ItemInfoModule', true);
		}
		
		m_runword6Applied = GetWitcherPlayer().HasRunewordActive('Runeword 6 _Stats');
	}
	
	event OnTick( timeDelta : float )
	{
		var item0, item1, item2 : SItemUniqueId;
		var alterItem1, alterItem2 : SItemUniqueId;
		var switchAnimation : int;
		var playerInv : CInventoryComponent;
		//patch 1.12 begin
		var witcherPlayer : W3PlayerWitcher;
		//patch 1.12 end
		var runword6Applied  : bool;
		var forcedIconUpdate : bool;
		
		if ( !CanTick( timeDelta ) )
		{
			return true;
		}
		//patch 1.12 begin
		witcherPlayer = GetWitcherPlayer();
		//patch 1.12 end
		if( m_IsPlayerCiri != thePlayer.IsCiri() )
		{
			m_IsPlayerCiri = thePlayer.IsCiri();
			if( m_IsPlayerCiri )
			{
				ClearItems();
			}
			m_fxHideSlotsSFF.InvokeSelfOneArg(FlashArgBool(!m_IsPlayerCiri));
		}
		
		if( m_IsPlayerCiri )
		{
			item0 = GetCiriItem();
			UpdateItem( item0, m_currentItemSelected, m_currentItemSelectedAmmo, HudItemInfoBinding_item1, 0 );
		}
		else
		{
			//patch 1.12 begin
			item0 = witcherPlayer.GetSelectedItemId();
			if ( theInput.LastUsedGamepad() )
			{
				witcherPlayer.GetItemEquippedOnSlot( witcherPlayer.GetSelectedPotionSlotUpper(), item1 );
				witcherPlayer.GetItemEquippedOnSlot( witcherPlayer.GetSelectedPotionSlotLower(), item2 );
				if ( witcherPlayer.GetSelectedPotionSlotUpper() == EES_Potion1)
 				{
					witcherPlayer.GetItemEquippedOnSlot( EES_Potion3, alterItem1 );
 				}
 				else
 				{
					witcherPlayer.GetItemEquippedOnSlot( EES_Potion1, alterItem1 );
 				}
				if ( witcherPlayer.GetSelectedPotionSlotLower() == EES_Potion2)
 				{
					witcherPlayer.GetItemEquippedOnSlot( EES_Potion4, alterItem2 );
 				}
 				else
 				{
					witcherPlayer.GetItemEquippedOnSlot( EES_Potion2, alterItem2 );
 				}
 				playerInv = thePlayer.GetInventory();
				if ( !playerInv.IsIdValid(item1) && playerInv.IsIdValid( alterItem1 ) )
 				{
					witcherPlayer.FlipSelectedPotion( true );
 				}
				else if ( !playerInv.IsIdValid(item2) && playerInv.IsIdValid( alterItem2 ) )
 				{
					witcherPlayer.FlipSelectedPotion( false );
 				}
				else if ( m_currentItemOnSlot1 == alterItem1 )
 				{
 					switchAnimation = 1;
 				}
				else if ( m_currentItemOnSlot2 == alterItem2 )
				//patch 1.12 end
				{
					switchAnimation = 2;
				}
				else
				{
					switchAnimation = -1;
				}
			}
			else
			{
				switchAnimation = -1;
				//patch 1.12 begin
				witcherPlayer.GetItemEquippedOnSlot( EES_Potion1, item1 );
				witcherPlayer.GetItemEquippedOnSlot( EES_Potion2, item2 );
				witcherPlayer.GetItemEquippedOnSlot( EES_Potion3, alterItem1 );
				witcherPlayer.GetItemEquippedOnSlot( EES_Potion4, alterItem2 );
				//patch 1.12 end
			}
			
			//patch 1.12 begin
			runword6Applied = witcherPlayer.HasRunewordActive('Runeword 6 _Stats');
			//patch 1.12 end
			
			if (m_runword6Applied != runword6Applied)
			{
				m_runword6Applied = runword6Applied;
				forcedIconUpdate = true;
			}
			else
			{
				forcedIconUpdate = false;
			}
			//patch 1.12 begin
			UpdateItem( item0,      m_currentItemSelected, m_currentItemSelectedAmmo, HudItemInfoBinding_item1,   0, forcedIconUpdate );
			UpdateItem( item1,      m_currentItemOnSlot1,  m_currentItemOnSlot1Ammo,  HudItemInfoBinding_potion1, 1, forcedIconUpdate );
			UpdateItem( item2,      m_currentItemOnSlot2,  m_currentItemOnSlot2Ammo,  HudItemInfoBinding_potion2, 2, forcedIconUpdate );
			UpdateItem( alterItem1, m_currentItemOnSlot3,  m_currentItemOnSlot3Ammo,  HudItemInfoBinding_potion3, 3, forcedIconUpdate );
			UpdateItem( alterItem2, m_currentItemOnSlot4,  m_currentItemOnSlot4Ammo,  HudItemInfoBinding_potion4, 4, forcedIconUpdate );
			if ( switchAnimation != -1 )
			{
				m_fxSwitchAnimation.InvokeSelfOneArg( FlashArgInt( switchAnimation ) );
			}
			//patch 1.12 end
		}
		
		//always display quickslots when the player is not at full health
		if ( thePlayer.IsCombatMusicEnabled() || thePlayer.GetHealthPercents() < 1.f )
			SetAlwaysDisplayed( true );
		else
			SetAlwaysDisplayed( false );
	}
	
	function GetCiriItem() : SItemUniqueId
	{
		//patch 1.12 begin
		var dummy : SItemUniqueId;
		//patch 1.12 end
		var ret : array<SItemUniqueId>;
		
		ret = thePlayer.GetInventory().GetItemsByName('q403_ciri_meteor');
		
		//patch 1.12 begin
		if ( ret.Size() )
		{
			return ret[0];
		}
		return dummy;
		//patch 1.12 end
	}
	
	public function ResetItems()
	{
		//patch 1.12 begin
		var dummy : SItemUniqueId;
		m_currentItemSelected = dummy;
		m_currentItemOnSlot1  = dummy;
		m_currentItemOnSlot2  = dummy;
		m_currentItemOnSlot3  = dummy;
		m_currentItemOnSlot4  = dummy;
		//patch 1.12 end
	}
	
	public function UpdateItem( out currItem : SItemUniqueId, out prevItem : SItemUniqueId, out prevItemAmmo : int, bindingID : HudItemInfoBinding, slotId : int, optional forceUpdate:bool )
	{
		var updateItem : bool;
		var ammo : int;
		var tempItem : SItemUniqueId;
		var dummy : SItemUniqueId;
		
		updateItem = false;
		ammo = 0;
		
		if ( prevItem != currItem || forceUpdate)
		{
			updateItem = true;
			prevItem = currItem;
		}
		if ( thePlayer.GetInventory().IsIdValid( currItem ) )
		{
			if ( thePlayer.GetInventory().IsItemSingletonItem( currItem ) )
			{
				ammo = thePlayer.inv.SingletonItemGetAmmo( currItem );
				if ( prevItemAmmo != ammo )
				{
					updateItem = true;
					prevItemAmmo = ammo;
				}
			}
			else if( thePlayer.GetInventory().IsItemCrossbow( currItem ) )
			{				
				GetWitcherPlayer().GetItemEquippedOnSlot(EES_Bolt, tempItem);
				ammo = thePlayer.GetInventory().GetItemQuantity( tempItem );
				if ( prevItemAmmo != ammo )
				{
					updateItem = true;
					prevItemAmmo = ammo;
					
				}
				
				if (!updateItem && m_lastBoltItem != tempItem)
				{
					updateItem = true;
				}
				
				m_lastBoltItem = tempItem;
			}
			else if( thePlayer.GetInventory().ItemHasTag( currItem, 'Edibles' ) )
			{				
				ammo = thePlayer.GetInventory().GetItemQuantity( currItem );
				if ( prevItemAmmo != ammo )
				{
					updateItem = true;
					prevItemAmmo = ammo;
				}
			}
			else
			{
				prevItemAmmo = -1;
				if ( slotId == 1 ) UpdateItemData( dummy, HudItemInfoBinding_potion1 );
				if ( slotId == 2 ) UpdateItemData( dummy, HudItemInfoBinding_potion2 );
				if ( slotId == 3 ) UpdateItemData( dummy, HudItemInfoBinding_potion3 );
				if ( slotId == 4 ) UpdateItemData( dummy, HudItemInfoBinding_potion4 );
			}
		}
		else
		{
			prevItemAmmo = -1;
			if ( slotId == 1 ) UpdateItemData( dummy, HudItemInfoBinding_potion1 );
			if ( slotId == 2 ) UpdateItemData( dummy, HudItemInfoBinding_potion2 );		
			if ( slotId == 3 ) UpdateItemData( dummy, HudItemInfoBinding_potion3 );
			if ( slotId == 4 ) UpdateItemData( dummy, HudItemInfoBinding_potion4 );		
		}
		if ( updateItem )
		{
			UpdateItemData( currItem, bindingID );
		}
	}

	public function ClearItems()
	{
		var dummy : SItemUniqueId;
		
		UpdateItemData( dummy, HudItemInfoBinding_item1 );
		UpdateItemData( dummy, HudItemInfoBinding_potion1 );
		UpdateItemData( dummy, HudItemInfoBinding_potion2 );
		UpdateItemData( dummy, HudItemInfoBinding_potion3 );
		UpdateItemData( dummy, HudItemInfoBinding_potion4 );
		m_currentItemSelected = dummy;
		m_currentItemOnSlot1 = dummy;
		m_currentItemOnSlot2 = dummy;
	}
	
	public function UpdateItemData(item : SItemUniqueId, bindingID : HudItemInfoBinding)
	{
		//patch 1.12 begin
		var maxAmmo  : int;
		//patch 1.12 end
		var ammo : int;
		var ammoStr : string;
		var itemName : string;
		var fontColor : string;
		var icon : string;
		var category : string;
		var btn:int;
		var pcBtn : int;
		var inventory : CInventoryComponent;
		//patch 1.12 begin
		var currentShowButtonHints : bool;
		var itemInfo : SHudItemInfo;
		//patch 1.12 end
		
		if( !thePlayer.GetInventory().IsIdValid( item ) )
		{
			icon = "";
			category = "";
			itemName = "";
			ammoStr = "";
			btn = 0;
			pcBtn = -1;
		}
		else
		{
			inventory = thePlayer.GetInventory();
			
			icon = inventory.GetItemIconPathByUniqueID(item);
			category = inventory.GetItemCategory(item);
			
			itemName = inventory.GetItemLocalizedNameByUniqueID(item);
			itemName = GetLocStringByKeyExt( itemName );
			fontColor = "<font color=\"#FFFFFF\">";
			
			if( inventory.ItemHasTag(item, 'Edibles' ) )
			{			
				if (GetWitcherPlayer().HasRunewordActive('Runeword 6 _Stats') )
				{
					icon = "icons/inventory/food/food_dumpling_64x64.png";
				}
				
				if( inventory.ItemHasTag(item, 'InfiniteUse') )
				{
					ammoStr = fontColor + "∞" + "</font>";
				}
				else
				{
					ammo = thePlayer.inv.GetItemQuantity(item);
					ammoStr = fontColor + ammo + "</font>";
				}
			}
			else if( inventory.IsItemSingletonItem(item) )
			{
				//patch 1.12 begin
				maxAmmo = thePlayer.inv.SingletonItemGetMaxAmmo(item);
				if (maxAmmo > 0) //potential bug?
 				{
					if( ammo == 0 )
					{
						fontColor = "<font color=\"#FF0000\">";
					}
					ammoStr = fontColor + ammo + "/" + maxAmmo + "</font>";
				}
				else
				{
					ammoStr = "";
 				}
				//patch 1.12 end
			}
			else
			{
				if( inventory.IsItemCrossbow(item) )
				{				
					GetWitcherPlayer().GetItemEquippedOnSlot(EES_Bolt, item);
					ammo = inventory.GetItemQuantity( item );
					
					if( inventory.ItemHasTag(item, theGame.params.TAG_INFINITE_AMMO) )
					{
						ammoStr = fontColor + "∞" + "</font>";
					}
					else
					{
						if( ammo == 0 )
						{
							fontColor = "<font color=\"#FF0000\">";
						}
						
						ammoStr = fontColor + ammo + "</font>";
					}
				}
				else
				{
					ammoStr = "";
				}
			}	
			
			itemName = fontColor+itemName + "</font>";
			
			pcBtn = GetPCKeyByBinding( bindingID );
			btn = GetKeyByBinding( bindingID );
			//patch 1.12 begin
			//m_fxShowButtonHints.InvokeSelfOneArg( FlashArgBool( theInput.GetContext() == 'RadialMenu' ) );
			currentShowButtonHints = ( theInput.GetContext() == 'RadialMenu' );
			if ( m_previousShowButtonHints != (int)currentShowButtonHints )
			{
				m_previousShowButtonHints = (int)currentShowButtonHints;
				m_fxShowButtonHints.InvokeSelfOneArg( FlashArgBool( currentShowButtonHints ) );
			}
		}
		itemInfo = m_previousSetItemInfo[ bindingID ];
		if ( itemInfo.m_icon     != icon ||
			 itemInfo.m_category != category ||
			 itemInfo.m_itemName != itemName ||
			 itemInfo.m_ammoStr  != ammoStr ||
			 itemInfo.m_btn      != btn ||
			 itemInfo.m_pcBtn    != pcBtn )
		{
			m_previousSetItemInfo[ bindingID ].m_icon     = icon;
			m_previousSetItemInfo[ bindingID ].m_category = category;
			m_previousSetItemInfo[ bindingID ].m_itemName = itemName;
			m_previousSetItemInfo[ bindingID ].m_ammoStr  = ammoStr;
			m_previousSetItemInfo[ bindingID ].m_btn      = btn;
			m_previousSetItemInfo[ bindingID ].m_pcBtn    = pcBtn;
			m_fxSetItemInfo.InvokeSelfSevenArgs(FlashArgInt(bindingID), FlashArgString(icon), FlashArgString(category), FlashArgString(itemName), FlashArgString(ammoStr), FlashArgInt(btn), FlashArgInt(pcBtn));
		}
		//m_fxSetItemInfo.InvokeSelfSevenArgs(FlashArgInt(bindingID), FlashArgString(icon), FlashArgString(category), FlashArgString(itemName), FlashArgString(ammoStr), FlashArgInt(btn), FlashArgInt(pcBtn));
		//patch 1.12 end
	}
	
	private function GetKeyByBinding(bindingName : HudItemInfoBinding) : int
	{
		var outKeys : array< EInputKey >;
		switch(bindingName)
		{
			case HudItemInfoBinding_item1 :
				theInput.GetPadKeysForAction('ThrowItem',outKeys);
				//theInput.GetCurrentKeysForAction('ThrowItem',outKeys);
				break;
			case HudItemInfoBinding_potion1 :
				theInput.GetPadKeysForAction('DrinkPotion1',outKeys);
				//theInput.GetCurrentKeysForAction('DrinkPotion1',outKeys);
				break;
			case HudItemInfoBinding_potion2 :
				theInput.GetPadKeysForAction('DrinkPotion2',outKeys);
				//theInput.GetCurrentKeysForAction('DrinkPotion2',outKeys);
				break;
			default:
				return -1;
		}
		return outKeys[0];
	}
	
	private function GetPCKeyByBinding(bindingName : HudItemInfoBinding) : int
	{
		var outKeys : array< EInputKey >;
		switch(bindingName)
		{
			case HudItemInfoBinding_item1 :
				theInput.GetPCKeysForAction('ThrowItem',outKeys);
				break;
				
			case HudItemInfoBinding_potion1 :
				theInput.GetPCKeysForAction('DrinkPotion1',outKeys);
				break;
			case HudItemInfoBinding_potion2 :
				theInput.GetPCKeysForAction('DrinkPotion2',outKeys);
				break;
			case HudItemInfoBinding_potion3 :
				theInput.GetPCKeysForAction('DrinkPotion3',outKeys);
				break;
			case HudItemInfoBinding_potion4 :
				theInput.GetPCKeysForAction('DrinkPotion4',outKeys);
				break;
			
			/*
			case HudItemInfoBinding_potion1 :
				if(GetWitcherPlayer().GetSelectedPotionSlotUpper() == EES_Potion1)
					theInput.GetPCKeysForAction('DrinkPotion1',outKeys);
				else
					theInput.GetPCKeysForAction('DrinkPotion3',outKeys);
				break;
				
			case HudItemInfoBinding_potion2 :
				
				if(GetWitcherPlayer().GetSelectedPotionSlotLower() == EES_Potion2)
					theInput.GetPCKeysForAction('DrinkPotion2',outKeys);
				else
					theInput.GetPCKeysForAction('DrinkPotion4',outKeys);
				break;
			*/
				
			default:
				return -1;
		}
		return outKeys[0];
	}
	
	protected function UpdatePosition(anchorX:float, anchorY:float) : void
	{
		var l_flashModule 		: CScriptedFlashSprite;
		var tempX				: float;
		var tempY				: float;
		
		l_flashModule 	= GetModuleFlash();
		//theGame.GetUIHorizontalFrameScale()
		//theGame.GetUIVerticalFrameScale()
		
		// #J SUPER LAME
		tempX = anchorX + (300.0 * (1.0 - theGame.GetUIHorizontalFrameScale()));
		tempY = anchorY - (200.0 * (1.0 - theGame.GetUIVerticalFrameScale())); 
		
		l_flashModule.SetX( tempX );
		l_flashModule.SetY( tempY );	
	}
		
	public function ForceShowElement() : void
	{
		m_fxUpdateElementSFF.InvokeSelf();
	}	
	
	public function EnableElement( enable : bool ) : void
	{
		//m_fxEnableSFF.InvokeSelfOneArg( FlashArgBool( enable ) ); 
	}	
	
	public function ShowElementIgnoreState( show : bool, optional bImmediately : bool ) : void
	{
		if( m_bEnabled )
		{
			m_fxShowElementSFF.InvokeSelfThreeArgs( FlashArgBool( show ), FlashArgBool( bImmediately ), FlashArgBool( true ) );
		}
	}	
	
	public function SetAlwaysDisplayed( value : bool )
	{
		m_fxSetAlwaysDisplayed.InvokeSelfOneArg(FlashArgBool(value));
	}
}

exec function eitem( enable : bool )
{
	var hud : CR4ScriptedHud;
	var module : CR4HudModuleItemInfo;

	hud = (CR4ScriptedHud)theGame.GetHud();
	if( hud )
	{
		module = (CR4HudModuleItemInfo)hud.GetHudModule("ItemInfoModule");
		module.EnableElement( enable );
	}
}