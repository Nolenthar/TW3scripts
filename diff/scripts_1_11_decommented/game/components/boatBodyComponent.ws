import statemachine class CBoatBodyComponent extends CRigidMeshComponent
{
	default autoState = 'Idle';
    event OnComponentAttached()
	{
		GotoStateAuto();
	}
	event OnCutsceneStarted(){}
	event OnCutsceneEnded(){}
	import function TriggerCutsceneStart();
	import function TriggerCutsceneEnd();
}
