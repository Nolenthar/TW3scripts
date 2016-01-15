import function LoadResource( resource : string, optional isDepotPath : bool ) : CResource;
import latent function LoadResourceAsync( resource : string, optional isDepotPath : bool ) : CResource;
import class CResource extends CObject
{
	import final function GetPath() : string;
}
