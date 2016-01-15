class W3QuestCond_DialogChoiceCondition extends CQuestScriptedCondition
{
	private editable var dialogChoice : EDialogActionIcon;
	private editable var onOptionSelected : bool;
	function Evaluate() : bool
	{
		var flags, set : int;
		if(!theGame.IsDialogOrCutscenePlaying() || theGame.isCutscenePlaying)
			return false;
		if(onOptionSelected)
		{
			set = GameplayFactsQuerySum('dialog_used_choice_is_set');
		}
		else
		{
			set = GameplayFactsQuerySum('dialog_choice_is_set');
		}
		if(set <= 0)
			return false;
		if(dialogChoice == 0)
		{
			return true;
		}
		else
		{
			if(onOptionSelected)
			{
				flags = GameplayFactsQuerySum('dialog_used_choice_flags');
			}
			else
			{
				flags = GameplayFactsQuerySum('dialog_choice_flags');
			}
			return flags & dialogChoice;
		}
	}
}
