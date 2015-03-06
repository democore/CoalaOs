_parameters = _this select 0;
_processId = _this select 1;
_fileName = _this select 2;
_cam = nil;

fncoala_startbodycam = 
{
	missionNamespace setVariable [format["%1%2", _processId, "cam"], nil];
	
	_programWindow = [5,5, _fileName] call fnCoala_DrawWindow;
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;
	
	_renderSurface = ["RscPicture", "", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _renderSurface, [0,0,20,10.5]] call fnCoala_addControlToWindow;
	
	_playerSelection = ["RscCombo", "", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _playerSelection, [0,0,10,1]] call fnCoala_addControlToWindow;
	_playerSelection ctrlAddEventHandler ["LBSelChanged",
	{
		_control = _this select 0;
		_selectedIndex = lbCurSel _control;
		_allPlayers = missionNamespace getVariable format["%1%2", _control, "players"];
		_renderSurface = missionNamespace getVariable format["%1%2", _control, "renderSurface"];
		_processId = missionNamespace getVariable format["%1%2", _control, "processId"];
		_oldCam = missionNamespace getVariable format["%1%2", _processId, "cam"];
		if(_oldCam != nil) then
		{
			_oldCam cameraEffect ["terminate","back"]; 
			camDestroy _oldCam;
		};
		
		_selectedPlayer = (_allPlayers select _selectedIndex) select 0;
		_playerId = str(netId _selectedPlayer);
		
		hint str(_renderSurface);
		_renderSurface ctrlSetText "#(argb,512,512,1)r2t(" + _playerId + ",1)";
		
		_cam = "camera" camCreate [0,0,0]; 
		_cam cameraEffect ["Internal", "Back", _playerId]; 
		_cam attachTo [_selectedPlayer, [0,0,2]];
		_cam camCommit 0;
		
		missionNamespace setVariable [format["%1%2", _processId, "cam"], _cam];
	}];
	
	_allPlayers = []; 
	{ 
		if (isPlayer _x) 
		then
		{ 
			_allPlayers pushBack [_x, name _x]; 
			_playerSelection lbAdd (name _x);
		}; 
	} forEach playableUnits;
	missionNamespace setVariable [format["%1%2", _playerSelection, "players"], _allPlayers];
	missionNamespace setVariable [format["%1%2", _playerSelection, "processId"], _processId];
	missionNamespace setVariable [format["%1%2", _playerSelection, "renderSurface"], _renderSurface];
	_playerSelection lbSetCurSel 0;
	
	
};

fncoala_stopbodycam = 
{
	_procId = _this select 0;
	_cam = missionNamespace getVariable format["%1%2", _procId, "cam"];
	if(str(_cam) != "<null>") then
	{
		_cam cameraEffect ["terminate","back"]; 
		camDestroy _cam;
	};
};

call fncoala_startbodycam;