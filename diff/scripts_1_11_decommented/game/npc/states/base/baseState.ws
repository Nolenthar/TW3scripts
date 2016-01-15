import state Base in CNewNPC
{
	event OnEnterState( prevStateName : name )
	{
		parent.ActionCancelAll();
	}
};
import state ReactingBase in CNewNPC extends Base
{
};
