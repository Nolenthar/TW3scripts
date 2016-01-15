import struct SBoatDestructionVolume
{
	import var volumeCorners : Vector;
    import var volumeLocalPosition : Vector;
    import var areaHealth : Float;
};
struct SBoatPartsConfig
{
	editable var destructionVolumeIndex : int;
	editable saved var parts : array<SBoatDesctructionPart>;
};
struct SBoatDesctructionPart
{
	editable var hpFalloffThreshold : float;
	editable var componentName : string;
	saved var isPartDropped : bool;
};
