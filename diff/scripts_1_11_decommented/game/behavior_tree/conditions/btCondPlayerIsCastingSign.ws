class BTCondPlayerIsCastingSign extends IBehTreeTask
{
	public var sign 				: ESignType;
	function IsAvailable() : bool
	{
		var l_currentCastSign 	: ESignType;
		if( !thePlayer.IsInCombatAction() )
			return false;
		if( thePlayer.GetBehaviorVariable( 'combatActionType') != (int)CAT_CastSign )
			return false;
		l_currentCastSign = thePlayer.GetCurrentlyCastSign();
		if( l_currentCastSign == sign )
			return true;
		else
			return false;
	}
}
class BTCondPlayerIsCastingSignDef extends IBehTreeConditionalTaskDefinition
{
	default instanceClass = 'BTCondPlayerIsCastingSign';
	editable var sign 				: ESignType;
}
