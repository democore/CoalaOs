coalaVideoPlayer = nil;
coalaLifeFeed = nil;
coalaDisplay = nil;
coalaConsole = nil;

myDrinkLoad = 
{ 
	private ["_display","_idc","_ctrl"]; 
	_display = _this select 0; 
	coalaDisplay = _display;
	_idc = -1; 
	_ctrl = _display displayCtrl _idc; 
	_this select 0 displayCtrl -1 ctrlEnable false;
	execVM "CoalaOs\Drawing\CoalaOsWindowManager.sqf"
	call fnCoala_drawBackgroundImage;
	call fnCoala_DrawDesktop;
	
	coalaConsole = ((_display) displayCtrl 1400);
	coalaConsole ctrlSetPosition [100, 100, 0,0];
	coalaConsole ctrlCommit 0;
	
	_keyDown = _display displayAddEventHandler ["KeyDown", 
	{
		_key = _this select 1;
			ctrlSetText[2001, "got here 0"];
		if((_key == 28)) then //enter
		{
			_input = ctrlText 1400;
			_command = [_input] call fncoala_getLastInsert;
			[_command] call fncoala_excecuteCommand;
			_consoleText = ctrlText 1400;
			[_consoleText] call fncoala_removeTopLine;
		};
	}];
};
