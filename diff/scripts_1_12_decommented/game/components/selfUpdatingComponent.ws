import abstract class CSelfUpdatingComponent extends CScriptedComponent
{
	import final function StartTicking();
	import final function StopTicking();
	import final function GetIsTicking() : bool;
}
