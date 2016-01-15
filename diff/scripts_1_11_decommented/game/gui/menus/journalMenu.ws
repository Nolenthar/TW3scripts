class CR4JournalMenu extends CR4MenuBase
{
	private var m_menuNames : array< name >;
	event  OnConfigUI()
	{
		var l_flashObject			: CScriptedFlashObject;
		var l_flashArray			: CScriptedFlashArray;
		super.OnConfigUI();
		m_menuNames.PushBack( 'JournalQuestMenu' );
		m_menuNames.PushBack( 'JournalQuestMenu' );
		m_menuNames.PushBack( 'JournalQuestMenu' );
	}
	event  OnCloseMenu()
	{
		var commonMenu : CR4CommonMenu;
		CloseMenu();
		if( m_parentMenu )
		{
			m_parentMenu.ChildRequestCloseMenu();
		}
	}
	event  OnJournalTabSelected( index : int )
	{
		var menu : CR4MenuBase;
		if ( index >= 0 && index < m_menuNames.Size() )
		{
			menu = (CR4MenuBase)GetSubMenu();
			if ( menu )
			{
				menu.SetParentMenu(NULL);
				menu.OnCloseMenu();
			}
			RequestSubMenu( m_menuNames[ index ] );
		}
	}
	event OnTrackQuest( _QuestID : int )
	{
		LogChannel('KURWA'," journalMenu OnTrackQuest( _QuestID "+  _QuestID );
	}
}
