import class CPhantomComponent extends CComponent
{
	import final function Activate();
	import final function Deactivate();
	import final function GetTriggeringCollisionGroupNames( out names : array< name > );
	import final function GetNumObjectsInside(): int;
}
