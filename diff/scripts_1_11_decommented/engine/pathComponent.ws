import class CPathComponent extends CComponent
{
	import final function FindClosestEdge( point : Vector ) : int;
	import final function GetAlphaOnEdge( point : Vector, edgeIdx : int, optional epsilon : float  ) : float;
	import final function GetClosestPointOnPath   ( point : Vector, optional epsilon : float  ) : Vector;
	import final function GetClosestPointOnPathExt( point : Vector, out edgeIdx : int, out edgeAlpha : float,
													optional epsilon : float  ) : Vector;
	import final function GetDistanceToPath( point : Vector, optional epsilon : float  ) : float;
	import final function GetNextPointOnPath( point : Vector, distance : float, out isEndOfPath : bool, optional epsilon : float  ) : Vector;
	import final function GetNextPointOnPathExt( out edgeIdx : int, out edgeAlpha : float, distance : float, out isEndOfPath : bool, optional epsilon : float  ) : Vector;
	import final function GetPointsCount() : int;
	import final function GetWorldPoint( index : int ) : Vector;
}
