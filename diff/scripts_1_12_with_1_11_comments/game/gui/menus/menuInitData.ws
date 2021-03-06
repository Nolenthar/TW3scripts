class W3MenuInitData extends CObject
{
	public var ignoreSaveSystem:bool;
	
	private var m_defaultState:name;
	
	public function getDefaultState():name
	{
		return m_defaultState;
	}
	public function setDefaultState(value:name):void
	{
		m_defaultState = value;
	}
}

class W3InventoryInitData extends W3MenuInitData
{
	public var containerNPC   : CGameplayEntity;
	public var filterTagsList : array<name>;
}

class W3MapInitData extends W3MenuInitData
{
	private var m_triggeredExitEntity			: bool;
	private var m_usedFastTravelEntity			: CEntity;
	private var m_isSailing						: bool;			default m_isSailing = false;
	
	function GetTriggeredExitEntity() : bool
	{
		return m_triggeredExitEntity;
	}
	
	function SetTriggeredExitEntity( triggeredExitEntity : bool )
	{
		m_triggeredExitEntity = triggeredExitEntity;
	}
	
	function GetUsedFastTravelEntity() : CEntity
	{
		return m_usedFastTravelEntity;
	}
	
	function SetUsedFastTravelEntity( entity : CEntity )
	{
		m_usedFastTravelEntity = entity;
	}
	
	function GetIsSailing() : bool
	{
		return m_isSailing;
	}
	
	function SetIsSailing( isSailing : bool )
	{
		m_isSailing = isSailing;
	}
}

class W3MainMenuInitData extends W3MenuInitData
{
	private var m_panelXOffset : int;
	
	public function GetPanelXOffset() : int
	{
		return m_panelXOffset;
	}
	
	public function SetPanelXOffset( value : int )
	{
		m_panelXOffset = value;
	}
}