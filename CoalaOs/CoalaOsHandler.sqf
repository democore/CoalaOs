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
	
	_keyDown = _display displayAddEventHandler ["KeyDown", 
	{
		_key = _this select 1;
		if((_key == 28)) then //enter
		{
			_input = ctrlText 1400;
			_command = [_input] call fncoala_getLastInsert;
			[_command] call fncoala_excecuteCommand;
			[ctrlText 1400] call fncoala_removeTopLine;
		};
	}];
};
