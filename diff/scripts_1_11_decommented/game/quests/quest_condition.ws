import abstract class CQuestScriptedCondition extends IQuestCondition
{
	function Activate();
	function Deactivate();
	function Evaluate() : bool;
};
