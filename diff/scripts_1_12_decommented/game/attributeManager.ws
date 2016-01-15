import class CDebugAttributesManager extends CObject
{
	import final function AddAttribute( debugName : name, propertyName : name, context : IScriptable, optional groupName : name ) : bool;
}
exec function AT()
{
	var player : CPlayer;
	player = thePlayer;
	theDebug.AddAttribute( 'bUseRunLSHold', 'bUseRunLSHold', player );
	theDebug.AddAttribute( 'bUseRunLSToggle', 'bUseRunLSToggle', player );
	theDebug.AddAttribute( 'bForcedCombat', 'bForcedCombat', player );
	theDebug.AddAttribute( 'PlayerHealth', 'initialHealth', player, 'InitialValues' );
}
