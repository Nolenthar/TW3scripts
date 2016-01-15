import class CGameFastForwardSystem extends IGameSystem
{
	import function BeginFastForward( optional dontSpawnHostilesClose : bool , optional coverWithBlackscreen : bool  );
	import function AllowFastForwardSelfCompletion();
	import function RequestFastForwardShutdown( optional coverWithBlackscreen : bool );
	import function EndFastForward();
};
