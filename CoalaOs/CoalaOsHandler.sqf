coalaVideoPlayer = nil;
coalaLifeFeed = nil;

myDrinkLoad = 
{ 
	private ["_display","_idc","_ctrl"]; 
	_display = _this select 0; 
	_idc = -1; 
	_ctrl = _display displayCtrl _idc; 
	_this select 0 displayCtrl -1 ctrlEnable false;
	coalaVideoPlayer = _display displayCtrl 1100;
	coalaLifeFeed = _display displayCtrl 1101;
	
	//missionNamespace setVariable [configName ((missionConfigFile/"MyDrink/controls/BGBox_1401") select 0), 10];
	_ding = getArray(missionConfigFile >> "MyDrink" >> "controls");
	
	
	
	_backgroundControl = ["RscPicture", 
	MISSION_ROOT + "CoalaOs\Images\tank.jpg", 
	10 * GUI_GRID_W + GUI_GRID_X, 
	-0.43 * GUI_GRID_H + GUI_GRID_Y,
	10 * GUI_GRID_W,
	10 * GUI_GRID_H, _display] call addCtrl;
	
	//_ding = _ding + [_backgroundControl];
	
	//missionNamespace setVariable [configName (missionConfigFile/"MyDrink"/"controls"), _ding];
	
	
	_ding = getArray(missionConfigFile >> "MyDrink" >> "controls");
	hint str(_ding);
	
	_textbox = ((_display) displayCtrl 1400);
	//_textbox ctrlSetPosition [100, 100, 0,0];
	//_textbox ctrlCommit 0;
	
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
