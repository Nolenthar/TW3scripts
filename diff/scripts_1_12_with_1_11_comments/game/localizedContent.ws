/***********************************************************************/
/** Witcher Script file
/***********************************************************************/
/** Localized content
/** Copyright © 2010
/***********************************************************************/

import function GetLocStringById( stringId : int ) : string;

import function GetLocStringByKey( stringKey : string ) : string;

// if no translation were found, returnes stringKey prefixed with '#'
import function GetLocStringByKeyExt( stringKey : string ) : string;

// Assume this function is expensive as it replaces characters in a string based on chosen language. 
// Should be saved for user inputted content where we have no control over what the string contains
import function FixStringForFont( originalString : string ) : string;

// returns localised string with item name for given item name
function GetItemCategoryLocalisedString(cat : name) : string
{
	if(!IsNameValid(cat))
		return "";

	return GetLocStringByKeyExt("item_category_" + StrReplaceAll( StrLower(NameToString(cat)), " ", "_") );
}

// returns localized string with attribute name
function GetAttributeNameLocStr(attName : name, isMult : bool) : string
{
	if(isMult)
		return GetLocStringByKeyExt("attribute_name_"+StrLower(attName)+"_mult");
	else
		return GetLocStringByKeyExt("attribute_name_"+StrLower(attName));
}

// returns localized string with attribute name
function GetLocStringByKeyExtWithParams(stringKey : string , optional intParamsArray : array<int>, optional floatParamsArray : array<float>, optional stringParamsArray : array<string>, optional addNbspTag:bool) : string
{
	var i : int;
	var resultString : string;
	var prefix : string;
	
	resultString = GetLocStringByKeyExt( stringKey );
	
	if (addNbspTag)
	{
		prefix = "&nbsp;";
	}
	else
	{
		prefix = "";
	}
	
	for( i = 0; i < intParamsArray.Size(); i += 1 )
	{
		resultString = StrReplace( resultString, "$I$", prefix + IntToString(intParamsArray[i]) ); // #B "$I"+i+"$" - it will be safer to number parameters
	}
	for( i = 0; i < floatParamsArray.Size(); i += 1 )
	{
		resultString = StrReplace( resultString, "$F$", prefix + NoTrailZeros(floatParamsArray[i]) );
	}
	for( i = 0; i < stringParamsArray.Size(); i += 1 )
	{
		resultString = StrReplace( resultString, "$S$", prefix + stringParamsArray[i] );
	}
	
	return resultString;
}

// returns localized string with attribute name
function GetLocStringByIdWithParams( stringId : int , optional intParamsArray : array<int>, optional floatParamsArray : array<float>, optional stringParamsArray : array<string>) : string
{
	var i : int;
	var resultString : string;
	
	resultString = GetLocStringById( stringId );

	for( i = 0; i < intParamsArray.Size(); i += 1 )
	{
		resultString = StrReplace( resultString, "$I$", IntToString(intParamsArray[i]) ); // #B "$I"+i+"$" - it will be safer to number parameters
	}
	for( i = 0; i < floatParamsArray.Size(); i += 1 )
	{
		resultString = StrReplace( resultString, "$F$", NoTrailZeros(floatParamsArray[i]) );
	}
	for( i = 0; i < stringParamsArray.Size(); i += 1 )
	{
		resultString = StrReplace( resultString, "$S$", stringParamsArray[i] );
	}
	
	return resultString;
}

function GetItemTooltipText(item : SItemUniqueId, inv : CInventoryComponent) : string
{
	var itemStats : array<SAttributeTooltip>;
	var i, price : int;
	var nam, descript, fluff, category, strStats : string;
	
	inv.GetTooltipData(item, nam, descript, price, category, itemStats, fluff);
	strStats = "";
	for(i=0; i<itemStats.Size(); i+=1)
	{
		strStats += itemStats[i].attributeName + " ";
		if( itemStats[i].percentageValue )
		{
			strStats += NoTrailZeros(itemStats[i].value * 100 ) + " %<br>";
		}
		else
		{
			strStats += NoTrailZeros(itemStats[i].value) + "<br>";
		}
	}	
	return GetLocStringByKeyExt(nam) + "<br>" + category + "<br><br>" + strStats + "<br><br>" + GetLocStringByKeyExt(descript) + "<br><br>" + fluff + "<br><br>" + "fixme_Price: " + price;
}

function GetBaseStatLocalizedName(stat : EBaseCharacterStats) : string
{
	switch(stat)
	{
		case BCS_Vitality : return GetLocStringByKeyExt("vitality");
		case BCS_Stamina : return GetLocStringByKeyExt("stamina");
		case BCS_Toxicity : return GetLocStringByKeyExt("toxicity");
		case BCS_Focus : return GetLocStringByKeyExt("focus");
		case BCS_Air : return GetLocStringByKeyExt("air");
		case BCS_Panic : return GetLocStringByKeyExt("panic");
		default : return "";
	}
}

function GetBaseStatLocalizedDesc(stat : EBaseCharacterStats) : string
{
	switch(stat)
	{
		case BCS_Vitality : return GetLocStringByKeyExt("vitality_desc");
		case BCS_Stamina : return GetLocStringByKeyExt("stamina_desc");
		case BCS_Toxicity : return GetLocStringByKeyExt("toxicity_desc");
		case BCS_Focus : return GetLocStringByKeyExt("focus_desc");
		case BCS_Air : return GetLocStringByKeyExt("air_desc");
		case BCS_Panic : return GetLocStringByKeyExt("panic_desc");
		default : return "";
	}
}

function GetRegenStatLocalizedName(stat : ECharacterRegenStats) : string
{
	switch(stat)
	{
		case CRS_Vitality : return GetLocStringByKeyExt("vitalityRegen");
		case CRS_Stamina : return GetLocStringByKeyExt("staminaRegen");
		default : return "";
	}
}

function GetRegenStatLocalizedDesc(stat : ECharacterRegenStats) : string
{
	switch(stat)
	{
		case CRS_Vitality : return GetLocStringByKeyExt("vitalityRegen_desc");
		case CRS_Stamina : return GetLocStringByKeyExt("staminaRegen_desc");
		default : return "";
	}
}

function GetPowerStatLocalizedName(stat : ECharacterPowerStats) : string
{
	switch(stat)
	{
		case CPS_AttackPower : return GetLocStringByKeyExt("attack_power");
		case CPS_SpellPower : return GetLocStringByKeyExt("spell_power");
		default : return "";
	}
}

function GetPowerStatLocalizedDesc(stat : ECharacterPowerStats) : string
{
	switch(stat)
	{
		case CPS_AttackPower : return GetLocStringByKeyExt("attack_power_desc");
		case CPS_SpellPower : return GetLocStringByKeyExt("spell_power_desc");
		default : return "";
	}
}

function GetResistStatLocalizedName(s : ECharacterDefenseStats, isPointResistance : bool) : string
{
	if(isPointResistance)
	{
		switch(s)
		{
			case CDS_PhysicalRes :	return GetLocStringByKeyExt("physical_resistance");
			case CDS_PoisonRes :	return GetLocStringByKeyExt( "poison_resistance");
			case CDS_FireRes :		return GetLocStringByKeyExt( "fire_resistance");
			case CDS_FrostRes :		return GetLocStringByKeyExt( "frost_resistance");
			case CDS_ShockRes :		return GetLocStringByKeyExt( "shock_resistance");
			case CDS_ForceRes :		return GetLocStringByKeyExt( "force_resistance");
			default :				return "";
		}
	}
	else
	{
		switch(s)
		{
			case CDS_PhysicalRes :	return GetLocStringByKeyExt( "physical_resistance_perc");
			case CDS_BleedingRes : 	return GetLocStringByKeyExt( "bleeding_resistance_perc");
			case CDS_PoisonRes :	return GetLocStringByKeyExt( "poison_resistance_perc");
			case CDS_FireRes :		return GetLocStringByKeyExt( "fire_resistance_perc");
			case CDS_FrostRes :		return GetLocStringByKeyExt( "frost_resistance_perc");
			case CDS_ShockRes :		return GetLocStringByKeyExt( "shock_resistance_perc");
			case CDS_ForceRes :		return GetLocStringByKeyExt( "force_resistance_perc");
			case CDS_WillRes :		return GetLocStringByKeyExt( "will_resistance_perc");
			case CDS_BurningRes : 	return GetLocStringByKeyExt( "burning_resistance_perc");
			default :				return "";
		}
	}
}

function GetResistStatLocalizedDesc(s : ECharacterDefenseStats, isPointResistance : bool) : string
{
	if(isPointResistance)
	{
		switch(s)
		{
			case CDS_PhysicalRes :	return GetLocStringByKeyExt( "physical_resistance_desc");
			case CDS_PoisonRes :	return GetLocStringByKeyExt( "poison_resistance_desc");
			case CDS_FireRes :		return GetLocStringByKeyExt( "fire_resistance_desc");
			case CDS_FrostRes :		return GetLocStringByKeyExt( "frost_resistance_desc");
			case CDS_ShockRes :		return GetLocStringByKeyExt( "shock_resistance_desc");
			case CDS_ForceRes :		return GetLocStringByKeyExt( "force_resistance_desc");
			default :				return "";
		}
	}
	else
	{
		switch(s)
		{
			case CDS_PhysicalRes :	return GetLocStringByKeyExt( "physical_resistance_perc_desc");
			case CDS_BleedingRes : 	return GetLocStringByKeyExt( "bleeding_resistance_perc_desc");
			case CDS_PoisonRes :	return GetLocStringByKeyExt( "poison_resistance_perc_desc");
			case CDS_FireRes :		return GetLocStringByKeyExt( "fire_resistance_perc_desc");
			case CDS_FrostRes :		return GetLocStringByKeyExt( "frost_resistance_perc_desc");
			case CDS_ShockRes :		return GetLocStringByKeyExt( "shock_resistance_perc_desc");
			case CDS_ForceRes :		return GetLocStringByKeyExt( "force_resistance_perc_desc");
			case CDS_WillRes :		return GetLocStringByKeyExt( "will_resistance_perc_desc");
			case CDS_BurningRes : 	return GetLocStringByKeyExt( "burning_resistance_perc_desc");
			default :				return "";
		}
	}
}

//checks if string has any localization tags
function HasLolcalizationTags(s : string) : bool
{
	return StrFindFirst(s, "<<") >= 0;
}

function GetIconByPlatform(tag : string) : string
{
	var icon : string;
	//patch 1.12 begin
	var isGamepad : bool;
	isGamepad = theInput.LastUsedGamepad() || theInput.GetLastUsedGamepadType() == GT_Steam;
	//patch 1.12 end
	if (tag == "GUI_GwintPass")
	{
		//patch 1.12 begin
		if(isGamepad)
		//patch 1.12 end
			icon = GetIconForKey(IK_Pad_Y_TRIANGLE, true);
		else
			icon = GetIconForKey(IK_Space);
	}
	if (tag == "GUI_GwintChoose")
	{
		//patch 1.12 begin
		if(isGamepad)
		//patch 1.12 end
			icon = GetIconForKey(IK_Pad_A_CROSS, true);
		else
			icon = GetIconForKey(IK_Enter);
	}
	else if(tag == "GUI_GwintZoom")
	{
		//patch 1.12 begin
		if(isGamepad)
		//patch 1.12 end
			icon = GetIconForKey(IK_Pad_RightTrigger);
		else
			icon = GetIconForKey(IK_Shift);
	}
	else if (tag == "GUI_GwintLeader")
	{
		//patch 1.12 begin
		if(isGamepad)
		//patch 1.12 end
			icon = GetIconForKey(IK_Pad_X_SQUARE, true);
		else
			icon = GetIconForKey(IK_X);	
	}
	else if (tag == "GUI_Close")
	{
		//patch 1.12 begin
		if(isGamepad)
		//patch 1.12 end
			icon = GetIconForKey(IK_Pad_B_CIRCLE, true);
		else
			icon = GetIconForKey(IK_Escape);	
	}
	
	return icon;
}

//Parses text and replaces tags (images, controls keys) to their icons.
//In case of keyboard tags some might be replaced to text as we don't do icons for those, eg. [Enter]
//If action has more than one key then you can specify the index youn want by placing it after comma inside tag.
//For example GI_AxisLeftY binds to W and S. Using <<GI_AxisLeftY>> gives [W] and using <<GI_AxisLeftY,1>> gives [S].
function ReplaceTagsToIcons(s : string) : string
{
	var start, stop, keyIdx, commaIdx : int;
	var tag, icon, keyIdxAsString, bracketOpeningSymbol, bracketClosingSymbol : string;
	var keys : array<EInputKey>;
	
	var alterAttackKeysPC 	    : array< EInputKey >;
	var attackModKeysPC 	    : array< EInputKey >;
	
	while(true)
	{
		//find next unparsed tag
		start = StrFindFirst(s, "<<");
		if(start < 0)
			break;
		
		stop = StrFindFirst(s, ">>");
		if(stop < 0)
			break;
			
		//some broken tags - first close then open
		if(stop < start)
		{
			//erase broken tag
			s = StrReplace(s, ">>", "");
			continue;
		}
		
		//get tag string
		tag = StrMid(s, start+2, stop-start-2);
				
		//check for array index request e.g. GI_AxisLeftY,1
		commaIdx = StrFindFirst(tag, ",");
		if(commaIdx >= 0)
		{
			keyIdxAsString = StrRight(tag, StrLen(tag) - commaIdx - 1);
			keyIdx = StringToInt(keyIdxAsString);
			tag = StrLeft(tag, commaIdx);
		}
		else
		{
			keyIdx = 0;
		}
		
		//input check - assume tag is an action and try to get key assigned to it
		
		//---------------------------------------------------
		// #Y2 Hack for attack tutorials
		// AttackWithAlternateHeavy
		// AttackWithAlternateLight
		// SpecialAttackWithAlternateLight
		// SpecialAttackWithAlternateHeavy
		// PCAlternate
		
		if (tag == "PCAlternate")
		{
			keys.Clear();
			attackModKeysPC.Clear();
			alterAttackKeysPC.Clear();
			
			theInput.GetPCKeysForAction('AttackWithAlternateHeavy', keys );
			theInput.GetPCKeysForAction('AttackWithAlternateLight', alterAttackKeysPC );
			theInput.GetPCKeysForAction('PCAlternate', attackModKeysPC );
			
			if (attackModKeysPC.Size() > 0 && alterAttackKeysPC.Size() > 0 && attackModKeysPC[0] != IK_None && alterAttackKeysPC[0] != IK_None)
			{
				icon = GetIconForKey(attackModKeysPC[0]);
			}
			else			
			{
				icon = "##"; // NONE if we have heavy attack bound
			}
		}
		else
		if (tag == "AttackWithAlternateLight_mod" || tag == "SpecialAttackWithAlternateLight_mod")
		{
			// light attack as a part of heavy attack text:
			// <<PCAlternate>> oraz <<SpecialAttackWithAlternateLight_mod>> aby wykonać specjalny atak silny.
			
			keys.Clear();
			attackModKeysPC.Clear();
			alterAttackKeysPC.Clear();
			
			theInput.GetPCKeysForAction('AttackWithAlternateHeavy', keys );
			theInput.GetPCKeysForAction('AttackWithAlternateLight', alterAttackKeysPC );
			theInput.GetPCKeysForAction('PCAlternate', attackModKeysPC );
			
			if (attackModKeysPC.Size() > 0 && alterAttackKeysPC.Size() > 0 && attackModKeysPC[0] != IK_None && alterAttackKeysPC[0] != IK_None)
			{
				icon = GetIconForKey(alterAttackKeysPC[0]);
			}
			else
			if (keys.Size() > 0 && keys[0] != IK_None)
			{
				icon = GetIconForKey(keys[0]);
			}
			else
			{
				keys.Clear();
				theInput.GetCurrentKeysForActionStr(tag, keys);
				theInput.GetPCKeysForAction('AttackWithAlternateLight', keys );
				if (keys.Size() > 0 && keys[0] != IK_None) 
				{
					icon = GetIconForKey(keys[0]);
				}
				else
				{
					icon = "##";
				}
			}
			
		}
		else
		if (tag == "AttackWithAlternateLight" || tag == "SpecialAttackWithAlternateLight")
		{
			keys.Clear();
			theInput.GetCurrentKeysForActionStr(tag, keys);
			theInput.GetPCKeysForAction('AttackWithAlternateLight', keys );
			
			if (keys.Size() > 0 && keys[0] != IK_None) 
			{
				icon = GetIconForKey(keys[0]);
			}
			else
			{
				alterAttackKeysPC.Clear();
				attackModKeysPC.Clear();
				
				theInput.GetPCKeysForAction('AttackWithAlternateHeavy', alterAttackKeysPC );
				theInput.GetPCKeysForAction('PCAlternate', attackModKeysPC );
				
				if (attackModKeysPC.Size() > 0 && alterAttackKeysPC.Size() > 0 && attackModKeysPC[0] != IK_None && alterAttackKeysPC[0] != IK_None)
				{
					icon = GetIconForKey(alterAttackKeysPC[0]) + " + " + GetIconForKey(attackModKeysPC[0]);
				}
				else
				{
					icon = "##"; // none
				}
			}
		}
		else 
		if (tag == "AttackWithAlternateHeavy" || tag == "SpecialAttackWithAlternateHeavy")
		{
			keys.Clear();
			alterAttackKeysPC.Clear();
			attackModKeysPC.Clear();
			
			theInput.GetPCKeysForAction('AttackWithAlternateHeavy', keys );
			theInput.GetPCKeysForAction('AttackWithAlternateLight', alterAttackKeysPC );
			theInput.GetPCKeysForAction('PCAlternate', attackModKeysPC );
			
			if (attackModKeysPC.Size() > 0 && alterAttackKeysPC.Size() > 0 && attackModKeysPC[0] != IK_None && alterAttackKeysPC[0] != IK_None)
			{
				icon = GetIconForKey(alterAttackKeysPC[0]);
			}
			else
			{
				icon = GetIconForKey(keys[0]);
			}
		}
		else
		{
			keys.Clear();
			theInput.GetCurrentKeysForActionStr(tag, keys);
			
			//get replacement string
			if(keys.Size() == 0)
			{
				//tag is not an action so it's a general icon tag
				icon = GetIconForTag(tag);
			}
			else
			{
				//get icon string from input key
				icon = GetIconForKey(keys[keyIdx]);
			}
		}
		
		//replace tag with icon
		if(StrStartsWith(icon, "##"))
		{
			//unmapped key (or broken TAG!)
			GetBracketSymbols(bracketOpeningSymbol, bracketClosingSymbol);
			icon = " " + bracketOpeningSymbol + "<font color=\"" + theGame.params.KEYBOARD_KEY_FONT_COLOR + "\">" + GetLocStringByKeyExt("input_device_key_name_IK_none") + "</font>" + bracketClosingSymbol + " ";
			s = StrReplaceAll(s, "<<" + tag + ">>", icon);
		}
		else if(commaIdx >= 0)
		{
			s = StrReplaceAll(s, "<<" + tag + "," + keyIdxAsString +">>", icon);
		}
		else
		{
			s = StrReplaceAll(s, "<<" + tag + ">>", icon);
		}
	}

	return s;
}

//Gets full icon string for input key.
//It's either a html tag to insert image or a string in case of keyboard, eg. "[Backspace]"
function GetIconForKey(key : EInputKey, optional isGuiKey:bool) : string
{
	var inGameConfigWrapper : CInGameConfigWrapper;
	var configValue : bool;
	
	var icon, keyText        : string;
	var bracketOpeningSymbol : string;
	var bracketClosingSymbol : string;
	
	if (isGuiKey && (key == IK_Pad_A_CROSS || key == IK_Pad_B_CIRCLE))
	{
		inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();
		configValue = inGameConfigWrapper.GetVarValue('Controls', 'SwapAcceptCancel');
		if (configValue )
		{
			if (key == IK_Pad_A_CROSS)
			{
				key = IK_Pad_B_CIRCLE;
			}
			else
			if (key == IK_Pad_B_CIRCLE)
			{
				key = IK_Pad_A_CROSS;
			}
		}
	}
	
	//get image file name from given input key
	icon = GetIconNameForKey(key);
	
	GetBracketSymbols(bracketOpeningSymbol, bracketClosingSymbol);
	if(icon == "")
	{
		//if no image, it's a keyboard key
		switch(key)
		{
			//for special keys we have localized strings (e.g. backspace, space)
			case IK_Backspace:
			case IK_Tab:
			case IK_Enter:
			case IK_Shift:
			case IK_Ctrl:
			case IK_Alt:
			case IK_Pause:
			case IK_CapsLock:
			case IK_Escape:
			case IK_Space:
			case IK_PageUp:
			case IK_PageDown:
			case IK_End:
			case IK_Home:
			case IK_Left:
			case IK_Up:
			case IK_Right:
			case IK_Down:
			case IK_Select:
			case IK_Print:
			case IK_Execute:
			case IK_PrintScrn:
			case IK_Insert:
			case IK_Delete:
			case IK_NumPad0:
			case IK_NumPad1:
			case IK_NumPad2:
			case IK_NumPad3:
			case IK_NumPad4:
			case IK_NumPad5:
			case IK_NumPad6:
			case IK_NumPad7:
			case IK_NumPad8:
			case IK_NumPad9:
			case IK_NumStar:
			case IK_NumPlus:
			case IK_Separator:
			case IK_NumMinus:
			case IK_NumPeriod:
			case IK_NumSlash:
			case IK_NumLock:
			case IK_ScrollLock:
			case IK_LShift:
			case IK_RShift:
			case IK_LControl:
			case IK_RControl:
			case IK_Mouse4:
			case IK_Mouse5:
			case IK_Mouse6:
			case IK_Mouse7:
			case IK_Mouse8:
				keyText = GetLocStringByKeyExt("input_device_key_name_" + key);
				break;
				
			//for generic ones we just take it's char
			default:
				keyText = StrChar(key);
		}
		icon = " " + bracketOpeningSymbol + "<font color=\"" + theGame.params.KEYBOARD_KEY_FONT_COLOR + "\">" + keyText + "</font>" + bracketClosingSymbol + " ";
	}
	else
	{
		icon = GetHTMLForICO(icon);
	}
	
	return icon;
}

function GetHoldLabel():string
{
	var bracketOpeningSymbol : string;
	var bracketClosingSymbol : string;
	
	GetBracketSymbols(bracketOpeningSymbol, bracketClosingSymbol);
	return "<font color=\"#CD7D03\">" + bracketOpeningSymbol + GetLocStringByKeyExt("ControlLayout_hold") + bracketClosingSymbol + "</font>";
}

function GetBracketSymbols(out openingSymbol:string, out closingSymbol:string, optional isRoundBrackets:bool):void
{
	var language, audioLanguage : string;
	
	theGame.GetGameLanguageName(audioLanguage,language);
	if (language == "AR")
	{
		openingSymbol = "";
		closingSymbol = "";
	}
	else
	{
		if (isRoundBrackets)
		{
			openingSymbol = "(";
			closingSymbol = ")";
		}
		else
		{
			openingSymbol = "[";
			closingSymbol = "]";
		}
	}
}

//gets html string icon
function GetHTMLForICO(icon : string) : string
{
	//we use vspace as we cannot align it vertically at the moment
	
	// #Y Sorry, hack for PC
	if (icon == "Mouse_LeftBtn" || icon == "Mouse_RightBtn" || icon == "Mouse_MiddleBtn" || icon == "Mouse_ScrollUp" || icon == "Mouse_ScrollDown")
	{
		icon = " <img src=\"" + icon + ".png\" vspace=\"-10\" />";
	}
	else
	{
		icon = " <img src=\"" + icon + ".png\" vspace=\"-20\" />";
	}

	return icon;
}

function GetHTMLForMouseICO(icon : string) : string
{
	//we use vspace as we cannot align it vertically at the moment
	icon = " <img src=\"" + icon + ".png\" vspace=\"-10\" />";

	return icon;
}

function GetHTMLForItemICO(icon : string, optional vspace : float) : string
{
	//we use vspace as we cannot align it vertically at the moment
	if (vspace == 0)
	{
		icon = " <img src=\"" + icon + ".png\" vspace=\"-10\" />";
	}
	else
	{
		icon = " <img src=\"" + icon + ".png\" vspace=\"" + NoTrailZeros(vspace) + "\" />";
	}

	return icon;
}

//gets html string icon
function GetBookTexture(tag : string) : string
{
	var retStr : string;
	//we use vspace as we cannot align it vertically at the moment
	retStr = "<p align=\"center\">"+" <img src=\"" + tag + ".png\" vspace=\"-20\" align=\"middle\" /> "+ "</p>";

	return retStr;
}

//gets icon file name for given tag (not an input key!)
function GetIconForTag(tag : string) : string
{
	var icon : string;
	
	if(tag == "GUI_LootPanel_LootAll")				icon = GetIconForKey(IK_Pad_A_CROSS, true);
	else if(tag == "GUI_PC_LootPanel_LootAll")			icon = GetIconForKey(IK_Space);
	else if(tag == "GI_AxisRight")					icon = GetHTMLForICO(GetPadFileName("RS"));
	else if(tag == "GI_AxisLeft")					icon = GetHTMLForICO(GetPadFileName("LS"));
	else if(tag == "GUI_LootPanel_Close")			icon = GetIconForKey(IK_Pad_B_CIRCLE, true);
	else if(tag == "GUI_PC_LootPanel_Close")		icon = GetIconForKey(IK_Escape);
	else if(tag == "GUI_MoveDown")					icon = GetIconForKey(IK_Pad_DigitDown);
	else if(tag == "GUI_MoveUp")					icon = GetIconForKey(IK_Pad_DigitUp);
	else if(tag == "GUI_Navigate")					icon = GetHTMLForICO(GetPadFileName("LS"));
	else if(tag == "GUI_SwitchTabLeft")				icon = GetIconForKey(IK_Pad_LeftTrigger);
	else if(tag == "GUI_SwitchTabRight")			icon = GetIconForKey(IK_Pad_RightTrigger);
	else if(tag == "GUI_SwitchPageLeft")			icon = GetIconForKey(IK_Pad_LeftShoulder);
	else if(tag == "GUI_SwitchPageRight")			icon = GetIconForKey(IK_Pad_RightShoulder);
	else if(tag == "GUI_SwitchInnerTabLeft")		icon = GetIconForKey(IK_Pad_LeftShoulder);
	else if(tag == "GUI_SwitchInnerTabRight")		icon = GetIconForKey(IK_Pad_RightShoulder);
	else if(tag == "GUI_Select")					icon = GetIconForKey(IK_Pad_A_CROSS, true);
	else if(tag == "GUI_Select2")					icon = GetIconForKey(IK_Pad_X_SQUARE, true);	
	else if(tag == "GUI_NavigateUpDown")			icon = GetIconForKey(IK_Pad_LeftAxisY);
	else if(tag == "ICO_DialogAxii")				icon = GetHTMLForItemICO("ICO_AxiiIcoPin");
	else if(tag == "ICO_DialogShop")				icon = GetHTMLForItemICO("ICO_ShopIcoDialog");	
	else if(tag == "ICO_QuestGiver")				icon = GetHTMLForItemICO("ICO_QuestIcoPin");
	else if(tag == "ICO_DialogGwint")				icon = GetHTMLForItemICO("ICO_DialogGwint");
	else if(tag == "ICO_NoticeBoard" || tag == "ICO_Noticeboard")	icon = GetHTMLForItemICO("ICO_NoticeBoard");
	else if(tag == "PAD_LSUp")						icon = GetHTMLForICO(GetPadFileName("LS_Up"));
	else if(tag == "PAD_LS_LeftRight")				icon = GetHTMLForICO(GetPadFileName("LS_LeftRight"));
	else if(tag == "ICO_DialogEnd")					icon = GetHTMLForItemICO("ICO_DialogEnd");
	else if(tag == "GUI_RS_Press")					icon = GetHTMLForICO(GetPadFileName("RS_PRESS"));
	else if(tag == "GUI_DPAD_LeftRight")			icon = GetHTMLForICO(GetPadFileName("Cross_LeftRight"));
	else if(tag == "IK_LeftMouse")					icon = GetIconForKey(IK_LeftMouse);
	else if(tag == "IK_RightMouse")					icon = GetIconForKey(IK_RightMouse);
	else if(tag == "Mouse")							icon = GetHTMLForICO("Mouse_Pan");
	else if(tag == "GUI_PC_Close")					icon = GetIconForKey(IK_Escape);	
	else
	{
		//out of memory, let's party!
		return GetIconOrColorForTag2(tag);
	}
	
	if(icon == "")
	{
		LogLocalization("GetIconForTag: cannot find icon for tag <<" + tag + ">>");
		icon = "##_" + tag + "_##";
	}
		
	return icon;
}

function GetIconOrColorForTag2(tag : string) : string
{
	var icon : string;
	
	if(tag == "ICO_ActiveQuestPin")					icon = GetHTMLForItemICO("ICO_ActiveQuestPin");
	else if(tag == "ICO_NewQuest")					icon = GetHTMLForItemICO("ICO_NewQuest");
	else if(tag == "ICO_EP1Quest")					icon = GetHTMLForItemICO("ICO_EP1Quest", -25);
	else if(tag == "ICO_Destructible")				icon = GetHTMLForItemICO("ICO_Destructible");
	else if(tag == "ICO_BoatFastTravel")			icon = GetHTMLForItemICO("ICO_minimap_harbor"); // old- ICO_BoatFastTravel
	else if(tag == "ICO_Overencumbered")			icon = GetHTMLForItemICO("ICO_Overencumbered");
	else if(tag == "ICO_UnknownPOI")				icon = GetHTMLForItemICO("ICO_UnknownPOI");
	else if(tag == "ICO_ThunderboltPotion")			icon = GetHTMLForItemICO("ICO_ThunderboltPotion");
	else if(tag == "ICO_ArmorUpgrade")				icon = GetHTMLForItemICO("ICO_ArmorUpgrade");
	else if(tag == "ICO_Rune")						icon = GetHTMLForItemICO("ICO_Rune");
	else if(tag == "ICO_Skull")						icon = GetHTMLForItemICO("ICO_Skull");
	else if(tag == "ICO_DungeonCrawl")			    icon = GetHTMLForItemICO("ICO_DungeonCrawl");
	else if(tag == "ICO_ShopMapPin")				icon = GetHTMLForItemICO("ICO_ShopIcoPin");
	//patch 1.12 begin
	else if(tag == "ICO_Enchanter")					icon = GetHTMLForItemICO("ICO_Enchanter", -2);
	//patch 1.12 end
	else if(tag == "IK_Tab")						icon = GetIconForKey(IK_Tab);
	else
	{
		//out of memory, let's party!
		return GetIconOrColorForTag3(tag);
	}
	
	if(icon == "")
	{
		LogLocalization("GetIconForTag: cannot find icon for tag <<" + tag + ">>");
		icon = "##_" + tag + "_##";
	}
		
	return icon;
}

function GetIconOrColorForTag3(tag : string) : string
{
	var icon : string;
	//patch 1.12 begin
	var isGamepad : bool;
	isGamepad = theInput.LastUsedGamepad() || theInput.GetLastUsedGamepadType() == GT_Steam;
	//patch 1.12 end
	
	if(tag == "ICO_Armorer")						icon = GetHTMLForItemICO("ICO_minimap_armorer");
	else if(tag == "ICO_Smith")						icon = GetHTMLForItemICO("ICO_minimap_blacksmith");
	else if(tag == "ICO_Herbalist")					icon = GetHTMLForItemICO("ICO_minimap_herbalist");
	else if(tag == "ICO_Alchemist")					icon = GetHTMLForItemICO("ICO_minimap_alchemist");
	else if(tag == "ICO_PlaceOfPower")				icon = GetHTMLForItemICO("ICO_place_of_power");
	else if(tag == "ICO_MonsterNest")				icon = GetHTMLForItemICO("ICO_minimap_monster_nest");
	else if(tag == "ICO_RepairArmor")				icon = GetHTMLForItemICO("ICO_minimap_repair");
	else if(tag == "ICO_RepairWeapons")				icon = GetHTMLForItemICO("ICO_minimap_repair_whetstone");
	else if(tag == "ICO_Harbor")					icon = GetHTMLForItemICO("ICO_minimap_harbor");
	else if(tag == "GUI_PC_Select")					icon = GetIconForKey(IK_Enter);
	else if(tag == "GUI_PC_SwitchPageLeft")			icon = GetIconForKey(IK_PageUp);
	else if(tag == "GUI_PC_SwitchPageRight")		icon = GetIconForKey(IK_PageDown);
	else if(tag == "ICO_HiddenTreasure")			icon = GetHTMLForItemICO("ICO_TresureHunt");
	else if(tag == "ICO_Dungeon")					icon = GetHTMLForItemICO("ICO_cave_entrance");
	else if(tag == "ICO_MerchantRescue")			icon = GetHTMLForItemICO("ICO_Cage");
	else if(tag == "ICO_SpoilsOfWar")				icon = GetHTMLForItemICO("ICO_spoils_of_war");
	else if(tag == "ICO_Contraband")				icon = GetHTMLForItemICO("ICO_contraband");
	else if(tag == "ICO_BossAndTreasure")			icon = GetHTMLForItemICO("ICO_boss_and_treasure");
	else if(tag == "ICO_TownRescue")				icon = GetHTMLForItemICO("ICO_town_rescue");
	else if(tag == "ICO_BanditCampfire")			icon = GetHTMLForItemICO("ICO_bandit_campfire");
	else if(tag == "ICO_FastTravel")				icon = GetHTMLForItemICO("ICO_minimap_fast_travel");
	else if(tag == "GUI_LS_Press")					icon = GetHTMLForICO(GetPadFileName("LS_Thumb"));
	else if(tag == "ICO_Stash")						icon = GetHTMLForItemICO("ICO_Stash");
	
	else if(tag == "GUI_Close" || tag == "GUI_GwintPass" || tag == "GUI_GwintZoom" || tag == "GUI_GwintChoose" || tag == "GUI_GwintLeader")
	{
		icon = GetIconByPlatform(tag);
	}
	else if(tag == "Color_Gwint")
	{
		icon = " <font color=\"#CD7D03\">"; //#J this is because stupid replaceall is removing mah spaces
	}
	else if(tag == "Color_Gwint2")
	{
		icon = " <font color=\"#EF1919\">"; //#J this is because stupid replaceall is removing mah spaces
	}
	else if(tag == "End_Color")
	{
		icon = "</font> ";
	}
	else if (tag == "GUI_GwintFactionLeft")
	{
		//patch 1.12 begin
		if( isGamepad )
		//patch 1.12 end
			icon = GetIconForKey(IK_Pad_LeftShoulder);
		else
			icon = GetIconForKey(IK_1);
	}
	else if (tag == "GUI_GwintFactionRight")
	{
		//patch 1.12 begin
		if( isGamepad )
		//patch 1.12 end
			icon = GetIconForKey(IK_Pad_RightShoulder);
		else
			icon = GetIconForKey(IK_3);
	}
	else if (tag == "GUI_GwintPass")
	{
		//patch 1.12 begin
		if( isGamepad )
		//patch 1.12 end
			icon = GetIconForKey(IK_Pad_Y_TRIANGLE);
		else
			icon = GetIconForKey(IK_Escape);
	}
	else if( IsBookTextureTag(tag) )				icon = GetBookTexture(tag);
	
	if(icon == "")
	{
		LogLocalization("GetIconForTag: cannot find icon for tag <<" + tag + ">>");
		icon = "##_" + tag + "_##";
	}
		
	return icon;
}

//Returns name of icon file for given input key (pc/pad)
function GetIconNameForKey(key : EInputKey) : string
{
	if(key == IK_Pad_A_CROSS)			return GetPadFileName("A");
	if(key == IK_Pad_B_CIRCLE)			return GetPadFileName("B");
	if(key == IK_Pad_X_SQUARE)			return GetPadFileName("X");
	if(key == IK_Pad_Y_TRIANGLE)		return GetPadFileName("Y");
	if(key == IK_Pad_LeftThumb)			return GetPadFileName("LS_Thumb");
	if(key == IK_Pad_RightThumb)		return GetPadFileName("RS_Thumb");
	if(key == IK_Pad_LeftShoulder)		return GetPadFileName("LB");
	if(key == IK_Pad_RightShoulder)		return GetPadFileName("RB");
	if(key == IK_Pad_LeftTrigger)		return GetPadFileName("LT");
	if(key == IK_Pad_RightTrigger)		return GetPadFileName("RT");
	if(key == IK_Pad_Start)				return GetPadFileName("Start");
	if(key == IK_Pad_Back_Select)		return GetPadFileName("Back");
	if(key == IK_Pad_DigitUp)			return GetPadFileName("Cross_Up");
	if(key == IK_Pad_DigitDown)			return GetPadFileName("Cross_Down");
	if(key == IK_Pad_DigitLeft)			return GetPadFileName("Cross_Left");
	if(key == IK_Pad_DigitRight)		return GetPadFileName("Cross_Right");
	if(key == IK_Pad_LeftAxisY)			return GetPadFileName("LS_Up_Down");
	if(key == IK_LeftMouse)				return "Mouse_LeftBtn";
	if(key == IK_RightMouse)			return "Mouse_RightBtn";
	if(key == IK_MiddleMouse)			return "Mouse_MiddleBtn";
	if(key == IK_MouseWheelUp)			return "Mouse_ScrollUp";
	if(key == IK_MouseWheelDown)		return "Mouse_ScrollDown";
	if(key == IK_PS4_TOUCH_PRESS)		return GetPadFileName("TouchPad");
	
	return "";
}

//given general button type, returns proper icon filename for pad: xbox or ps4
function GetPadFileName(type : string) : string
{
	//patch 1.12 begin
	var platformPrefix:string;
	//patch 1.12 end
	if(theInput.UsesPlaystationPadScript())
	{
		//ps4 icons
		switch(type)
		{
			case "LS" :					return "ICO_PlayS_L3";
			case "RS" :					return "ICO_PlayS_R3";
			case "LS_Thumb"	:			return "ICO_PlayS_L3_hold";
			case "RS_Thumb"	:			return "ICO_PlayS_R3_hold";
			case "RS_PRESS"	:			return "ICO_PlayS_R3_hold";
			case "LS_Up_Down" : 		return "ICO_PlayS_L3_scroll";
			case "LS_LeftRight" : 		return "ICO_PlayS_L3_tabs";
			case "RS_Up" : 				return "ICO_PlayS_R3_up";
			case "RS_Down" : 			return "ICO_PlayS_R3_down";
			case "LS_Up" : 				return "ICO_PlayS_L3_up";
			case "Cross_Right" : 		return "ICO_PlayS_dpad_right";
			case "Cross_Left" : 		return "ICO_PlayS_dpad_left";
			case "Cross_Up" : 			return "ICO_PlayS_dpad_up";
			case "Cross_Down" : 		return "ICO_PlayS_dpad_down";
			case "Cross_LeftRight" :  	return "ICO_PlayS_dpad_left_right";
			case "Back" : 				return "ICO_PlayS_Share";
			case "Start" : 				return "ICO_PlayS_Touchpad";
			case "RT" : 				return "ICO_PlayS_R2";
			case "LT" : 				return "ICO_PlayS_L2";
			case "LB" : 				return "ICO_PlayS_L1";
			case "RB" : 				return "ICO_PlayS_R1";
			case "A" : 					return "ICO_PlayS_X";
			case "B" : 					return "ICO_PlayS_Circle";
			case "X" : 					return "ICO_PlayS_Square";
			case "Y" : 					return "ICO_PlayS_Triangle";
			case "TouchPad" :			return "ICO_PlayS_Touchpad";
		}
	}
	else
	{
		//patch 1.12 begin
		if (theInput.GetLastUsedGamepadType() == GT_Steam)
		{
			platformPrefix = "_Steam_";
		}
		else
		{
			platformPrefix = "_Xbox_";
		}
		switch(type)
		{
			case "LS" :					return "ICO" + platformPrefix + "L";
			case "RS" :					return "ICO" + platformPrefix + "R";
			case "LS_Thumb"	:			return "ICO" + platformPrefix + "L_hold";
			case "RS_Thumb"	:			return "ICO" + platformPrefix + "R_hold";
			case "RS_PRESS"	:			return "ICO" + platformPrefix + "R_hold";
			case "LS_Up_Down" : 		return "ICO" + platformPrefix + "L_scroll";
			case "LS_LeftRight" : 		return "ICO" + platformPrefix + "L_tabs";
			case "RS_Up" : 				return "ICO" + platformPrefix + "R_up";
			case "RS_Down" : 			return "ICO" + platformPrefix + "R_down";
			case "LS_Up" : 				return "ICO" + platformPrefix + "L_up";
			case "Cross_Right" : 		return "ICO" + platformPrefix + "dpad_right";
			case "Cross_Left" : 		return "ICO" + platformPrefix + "dpad_left";
			case "Cross_Up" : 			return "ICO" + platformPrefix + "dpad_up";
			case "Cross_Down" : 		return "ICO" + platformPrefix + "dpad_down";
			case "Cross_LeftRight" :  	return "ICO" + platformPrefix + "dpad_left_right";
			case "Back" : 				return "ICO" + platformPrefix + "Back";
			case "Start" : 				return "ICO" + platformPrefix + "Start";
			case "RT" : 				return "ICO" + platformPrefix + "RT";
			case "LT" : 				return "ICO" + platformPrefix + "LT";
			case "LB" : 				return "ICO" + platformPrefix + "LB";
			case "RB" : 				return "ICO" + platformPrefix + "RB";
			case "A" : 					return "ICO" + platformPrefix + "A";
			case "B" : 					return "ICO" + platformPrefix + "B";
			case "X" : 					return "ICO" + platformPrefix + "X";
			case "Y" : 					return "ICO" + platformPrefix + "Y";
		}
		//patch 1.12 end
	}
	
	return "";
}

exec function hintloc()
{
	var m_tutorialHintDataObj : W3TutorialPopupData;
	var str : string;
	
	theGame.GetTutorialSystem().TutorialStart(false);
	
	str = "Press <<Jump>> to jump, <<GUI_LootPanel_LootAll>> in lootpanel on pad to loot all. We also have shop icons like this: <<ICO_DialogShop>>";
	str = ReplaceTagsToIcons(str);
	
	m_tutorialHintDataObj = new W3TutorialPopupData in theGame;
	m_tutorialHintDataObj.managerRef = theGame.GetTutorialSystem();
	m_tutorialHintDataObj.scriptTag = 'aaa';
	m_tutorialHintDataObj.messageText = str;
	m_tutorialHintDataObj.duration = 5000;
	
	theGame.RequestMenu('TutorialPopupMenu', m_tutorialHintDataObj);
}

//////////////////////////////////////////////////////////////////
//////////////////  @TESTING ICONS  //////////////////////////////
//////////////////////////////////////////////////////////////////

function DEBUG_Test_GetIconForTag(out text : string, tag : string)
{
	text += "<br/>" + tag + "     #" + GetIconForTag(tag) + "#";
}

function DEBUG_Test_GetIconNameForKey(out text : string, key : EInputKey)
{
	var ico : string;
	
	ico = GetIconNameForKey(key);
	text += "<br/>" + key + ", icoFile=" + ico + "      #" + GetHTMLForICO(ico) + "#";
}

exec function tutico(optional num : int)
{
	var tag, key : string;
	var message : W3TutorialPopupData;
	
	//enable tutorials
	TutorialMessagesEnable(true);
	theGame.GetTutorialSystem().TutorialStart(false);	
	message = new W3TutorialPopupData in theGame;
	message.managerRef = theGame.GetTutorialSystem();
	message.scriptTag = 'aaa';
	message.duration = -1;
	message.autosize = false;
	
	//close any old messages
	theGame.ClosePopup( 'TutorialPopup');
		
	switch(num)
	{
		case 0 : 
			DEBUG_Test_GetIconForTag(tag, "GUI_LootPanel_LootAll");
			DEBUG_Test_GetIconForTag(tag, "GUI_PC_LootPanel_LootAll");
			DEBUG_Test_GetIconForTag(tag, "GI_AxisRight");
			DEBUG_Test_GetIconForTag(tag, "GI_AxisLeft");
			DEBUG_Test_GetIconForTag(tag, "GUI_LootPanel_Close");
			DEBUG_Test_GetIconForTag(tag, "GUI_PC_LootPanel_Close");
			DEBUG_Test_GetIconForTag(tag, "GUI_MoveDown");
			DEBUG_Test_GetIconForTag(tag, "GUI_MoveUp");
			DEBUG_Test_GetIconForTag(tag, "GUI_Navigate");
			DEBUG_Test_GetIconForTag(tag, "GUI_SwitchTabLeft");
			break;
		case 1 :
			DEBUG_Test_GetIconForTag(tag, "GUI_SwitchTabRight");
			DEBUG_Test_GetIconForTag(tag, "GUI_SwitchPageLeft");
			DEBUG_Test_GetIconForTag(tag, "GUI_SwitchPageRight");
			DEBUG_Test_GetIconForTag(tag, "GUI_SwitchInnerTabLeft");
			DEBUG_Test_GetIconForTag(tag, "GUI_SwitchInnerTabRight");
			DEBUG_Test_GetIconForTag(tag, "GUI_Select");
			DEBUG_Test_GetIconForTag(tag, "GUI_Select2");
			DEBUG_Test_GetIconForTag(tag, "GUI_Close");
			DEBUG_Test_GetIconForTag(tag, "GUI_PC_Close");
			DEBUG_Test_GetIconForTag(tag, "GUI_NavigateUpDown");
			break;
		case 2 :
			DEBUG_Test_GetIconForTag(tag, "ICO_DialogAxii");
			DEBUG_Test_GetIconForTag(tag, "ICO_DialogShop");
			DEBUG_Test_GetIconForTag(tag, "ICO_QuestGiver");
			DEBUG_Test_GetIconForTag(tag, "ICO_DialogGwint");
			DEBUG_Test_GetIconForTag(tag, "PAD_LSUp");
			DEBUG_Test_GetIconForTag(tag, "ICO_DialogEnd");
			DEBUG_Test_GetIconForTag(tag, "GUI_RS_Press");
			DEBUG_Test_GetIconForTag(tag, "GUI_DPAD_LeftRight");
			DEBUG_Test_GetIconForTag(tag, "PAD_LS_LeftRight");
			break;
		case 3 :
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_A_CROSS);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_B_CIRCLE);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_X_SQUARE);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_Y_TRIANGLE);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_LeftThumb);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_RightThumb);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_LeftShoulder);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_RightShoulder);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_LeftTrigger);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_RightTrigger);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_Start);
			break;
		case 4 :		
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_Back_Select);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_DigitUp);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_DigitDown);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_DigitLeft);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_DigitRight);
			DEBUG_Test_GetIconNameForKey(tag, IK_Pad_LeftAxisY);
			DEBUG_Test_GetIconNameForKey(tag, IK_LeftMouse);
			DEBUG_Test_GetIconNameForKey(tag, IK_RightMouse);
			DEBUG_Test_GetIconNameForKey(tag, IK_MiddleMouse);
			DEBUG_Test_GetIconNameForKey(tag, IK_MouseWheelUp);
			DEBUG_Test_GetIconNameForKey(tag, IK_MouseWheelDown);
			break;
		default :
			return;
	}
	
	message.messageText = tag;
	theGame.RequestPopup( 'TutorialPopup',  message );
}

exec function testLocKeyboardKeyNames()
{
	LogChannel('aaa', IK_Backspace + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Backspace"));
	LogChannel('aaa', IK_Tab + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Tab"));
	LogChannel('aaa', IK_Enter + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Enter"));
	LogChannel('aaa', IK_Shift + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Shift"));
	LogChannel('aaa', IK_Ctrl + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Ctrl"));
	LogChannel('aaa', IK_Alt + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Alt"));
	LogChannel('aaa', IK_Pause + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Pause"));
	LogChannel('aaa', IK_CapsLock + " - " + GetLocStringByKeyExt("input_device_key_name_IK_CapsLock"));
	LogChannel('aaa', IK_Escape + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Escape"));
	LogChannel('aaa', IK_Space + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Space"));
	LogChannel('aaa', IK_PageUp + " - " + GetLocStringByKeyExt("input_device_key_name_IK_PageUp"));
	LogChannel('aaa', IK_PageDown + " - " + GetLocStringByKeyExt("input_device_key_name_IK_PageDown"));
	LogChannel('aaa', IK_End + " - " + GetLocStringByKeyExt("input_device_key_name_IK_End"));
	LogChannel('aaa', IK_Home + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Home"));
	LogChannel('aaa', IK_Left + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Left"));
	LogChannel('aaa', IK_Up + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Up"));
	LogChannel('aaa', IK_Right + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Right"));
	LogChannel('aaa', IK_Down + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Down"));
	LogChannel('aaa', IK_Select + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Select"));
	LogChannel('aaa', IK_Print + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Print"));
	LogChannel('aaa', IK_Execute + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Execute"));
	LogChannel('aaa', IK_PrintScrn + " - " + GetLocStringByKeyExt("input_device_key_name_IK_PrintScrn"));
	LogChannel('aaa', IK_Insert + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Insert"));
	LogChannel('aaa', IK_Delete + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Delete"));
	LogChannel('aaa', IK_NumPad0 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumPad0"));
	LogChannel('aaa', IK_NumPad1 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumPad1"));
	LogChannel('aaa', IK_NumPad2 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumPad2"));
	LogChannel('aaa', IK_NumPad3 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumPad3"));
	LogChannel('aaa', IK_NumPad4 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumPad4"));
	LogChannel('aaa', IK_NumPad5 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumPad5"));
	LogChannel('aaa', IK_NumPad6 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumPad6"));
	LogChannel('aaa', IK_NumPad7 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumPad7"));
	LogChannel('aaa', IK_NumPad8 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumPad8"));
	LogChannel('aaa', IK_NumPad9 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumPad9"));
	LogChannel('aaa', IK_NumStar + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumStar"));
	LogChannel('aaa', IK_NumPlus + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumPlus"));
	LogChannel('aaa', IK_Separator + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Separator"));
	LogChannel('aaa', IK_NumMinus + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumMinus"));
	LogChannel('aaa', IK_NumPeriod + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumPeriod"));
	LogChannel('aaa', IK_NumSlash + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumSlash"));
	LogChannel('aaa', IK_NumLock + " - " + GetLocStringByKeyExt("input_device_key_name_IK_NumLock"));
	LogChannel('aaa', IK_ScrollLock + " - " + GetLocStringByKeyExt("input_device_key_name_IK_ScrollLock"));
	LogChannel('aaa', IK_LShift + " - " + GetLocStringByKeyExt("input_device_key_name_IK_LShift"));
	LogChannel('aaa', IK_RShift + " - " + GetLocStringByKeyExt("input_device_key_name_IK_RShift"));
	LogChannel('aaa', IK_LControl + " - " + GetLocStringByKeyExt("input_device_key_name_IK_LControl"));
	LogChannel('aaa', IK_RControl + " - " + GetLocStringByKeyExt("input_device_key_name_IK_RControl"));
	LogChannel('aaa', IK_Mouse4 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Mouse4"));
	LogChannel('aaa', IK_Mouse5 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Mouse5"));
	LogChannel('aaa', IK_Mouse6 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Mouse6"));
	LogChannel('aaa', IK_Mouse7 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Mouse7"));
	LogChannel('aaa', IK_Mouse8 + " - " + GetLocStringByKeyExt("input_device_key_name_IK_Mouse8"));
}
