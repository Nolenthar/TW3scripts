import class CGameplayEffectsComponent extends CComponent
{
	import final function SetGameplayEffectFlag( flag : EEntityGameplayEffectFlags, value : bool );
	import final function GetGameplayEffectFlag( flag : EEntityGameplayEffectFlags ) : bool;
	import final function ResetGameplayEffectFlag( flag : EEntityGameplayEffectFlags ) : bool;
}
function GetGameplayEffectsComponent( entity : CEntity ) : CGameplayEffectsComponent
{
	if(entity)
		return ( CGameplayEffectsComponent )entity.GetComponentByClassName( 'CGameplayEffectsComponent' );
	return NULL;
}
