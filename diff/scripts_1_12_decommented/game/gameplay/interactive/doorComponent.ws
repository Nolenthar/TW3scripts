import class CDoorComponent extends CInteractionComponent
{
	import function Open( force : bool, unlock : bool );
	import function Close( force : bool );
	import function IsOpen() : bool;
	import function IsLocked() : bool;
	import function AddForceImpulse( origin : Vector, force : float );
	import function InstantClose();
	import function InstantOpen( unlock : bool );
	import function AddDoorUser( actor : CActor );
	import function EnebleDoors( enable : bool );
	import function IsInteractive( ) : bool;
	import function IsTrapdoor( ) : bool;
	import function InvertMatrixForDoor( m : Matrix ) : Matrix;
	import function Unsuppress();
}
