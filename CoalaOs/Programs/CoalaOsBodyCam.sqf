/*
	File: CoalaOsBodyCam.sqf
	Creator: Niky
	Date: 11.03.2015
*/

_parameters = _this select 0;
_processId = _this select 1;
_fileName = _this select 2;
_cam = nil;

fncoala_startbodycam = 
{
	//hint str(_parameters);
	missionNamespace setVariable [format["%1%2", _processId, "cam"], "none"];
	
	_x = 1;
	_y = 1;
	if(count _parameters > 2) then
	{
		_x = parseNumber (_parameters select 2);
		_y = parseNumber (_parameters select 3);
	};
	
	_programWindow = [_x,_y,30,15, _fileName] call fnCoala_DrawWindow;
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;
	missionNamespace setVariable [format["%1%2", _processId, "window"], _programWindow];
	
	_pos = ctrlposition (_programWindow select 0);
	_prog = ([_processId] call fncoala_getProgramEntryById);
	_prog set [7, [(_pos select 0) / GUI_GRID_W + GUI_GRID_X, (_pos select 1) / GUI_GRID_H + GUI_GRID_Y]];
	
	_renderSurface = ["RscPicture", "", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _renderSurface, [0,0,30,15 - 1.5]] call fnCoala_addControlToWindow;
	
	_direction = ["RscText", "", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _direction, [11,0,4,1]] call fnCoala_addControlToWindow;
	
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
		_programWindow = missionNamespace getVariable format["%1%2", _control, "programWindow"];
		_direction = missionNamespace getVariable format["%1%2", _control, "direction"];
		
		_selectedPlayer = (_allPlayers select _selectedIndex) select 0;
		
		// head direction: https://community.bistudio.com/wiki/eyeDirection
		//gab schon cam
		if(str(_oldCam) != str("none")) then
		{
			_playerId = str(netId _selectedPlayer);
			_oldCam attachTo [vehicle _selectedPlayer, [-0.05,0.1,0.08], "Head"];
			_oldCam camCommit 0;
			[_selectedPlayer, _oldCam, _processId, _direction] spawn checkActiveCameraPosition;
		}
		else
		{
			//gab noch keine cam
			_playerId = str(netId _selectedPlayer);
			_renderSurface ctrlSetText "#(argb,512,512,1)r2t(" + str(_processId) + ",1)";
			
			_cam = "camera" camCreate [0,0,0]; 
			_cam cameraEffect ["Internal", "Back", str(_processId)];
			_cam attachTo [vehicle _selectedPlayer, [-0.05,0.1,0.05], "Head"];
			_cam camCommit 0;
			missionNamespace setVariable [format["%1%2", _processId, "cam"], _cam];
			missionNamespace setVariable [format["%1%2", _processId, "playerId"], _playerId];
			[_selectedPlayer, _cam, _processId, _direction] spawn checkActiveCameraPosition;
		};
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
	missionNamespace setVariable [format["%1%2", _processId, "programActive"], "1"];
	missionNamespace setVariable [format["%1%2", _playerSelection, "renderSurface"], _renderSurface];
	missionNamespace setVariable [format["%1%2", _playerSelection, "programWindow"], _programWindow];
	missionNamespace setVariable [format["%1%2", _playerSelection, "direction"], _direction];
	_playerSelection lbSetCurSel 0;
	
	[_processId, _playerSelection] spawn keepListUpdated;
};

keepListUpdated = 
{
	_processId = _this select 0;
	_playerSelection = _this select 1;
	
	_active = missionNamespace getVariable format["%1%2", _processId, "programActive"];
	while{_active == "1"} do
	{
		sleep 5;
		
		lbClear _playerSelection;
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
		
		_active = missionNamespace getVariable format["%1%2", _processId, "programActive"];
	};
};

checkActiveCameraPosition = 
{
	_player = _this select 0;
	_cam = _this select 1;
	_processId = _this select 2;
	_directionControl = _this select 3;
	_vehicle = vehicle _player;
	while {(missionNamespace getVariable format["%1%2", _processId, "programActive"] != "0")} do
	{
		if(_vehicle != vehicle _player) then
		{
			_cam attachTo [vehicle _player, [-0.05,0.15,0.08], "Head"];
			_vehicle = vehicle _player;
		};
		_directionControl ctrlSetText format["Dir: %1", str(floor(getDir _vehicle))];
		
		_dir =  [_vehicle] call CBA_fnc_modelHeadDir;
		_pitch = (_dir select 2) - 10;
		
		[_cam, [_pitch, 0, 0]] call fnc_SetPitchBankYaw;
			
		sleep 0.08;
	};
};

fnc_SetPitchBankYaw = { 
    private ["_object","_rotations","_aroundX","_aroundY","_aroundZ","_dirX","_dirY","_dirZ","_upX","_upY","_upZ","_dir","_up","_dirXTemp",
    "_upXTemp"];
    _object = _this select 0; 
    _rotations = _this select 1; 
    _aroundX = _rotations select 0; 
    _aroundY = _rotations select 1; 
    _aroundZ = (360 - (_rotations select 2)) - 360; 
    _dirX = 0; 
    _dirY = 1; 
    _dirZ = 0; 
    _upX = 0; 
    _upY = 0; 
    _upZ = 1; 
    if (_aroundX != 0) then { 
        _dirY = cos _aroundX; 
        _dirZ = sin _aroundX; 
        _upY = -sin _aroundX; 
        _upZ = cos _aroundX; 
    }; 
    if (_aroundY != 0) then { 
        _dirX = _dirZ * sin _aroundY; 
        _dirZ = _dirZ * cos _aroundY; 
        _upX = _upZ * sin _aroundY; 
        _upZ = _upZ * cos _aroundY; 
    }; 
    if (_aroundZ != 0) then { 
        _dirXTemp = _dirX; 
        _dirX = (_dirXTemp* cos _aroundZ) - (_dirY * sin _aroundZ); 
        _dirY = (_dirY * cos _aroundZ) + (_dirXTemp * sin _aroundZ);        
        _upXTemp = _upX; 
        _upX = (_upXTemp * cos _aroundZ) - (_upY * sin _aroundZ); 
        _upY = (_upY * cos _aroundZ) + (_upXTemp * sin _aroundZ); 		
    }; 
    _dir = [_dirX,_dirY,_dirZ]; 
    _up = [_upX,_upY,_upZ]; 
    _object setVectorDirAndUp [_dir,_up]; 
};  

fncoala_stopbodycam = 
{
	_procId = _this select 0;
	_programWindow = missionNamespace getVariable format["%1%2", _procId, "window"];
	//hint format["bla. %1",  str([_procId] call fncoala_getProgramEntryById)];
	
	missionNamespace setVariable [format["%1%2", _procId, "programActive"], "0"];
	_cam = missionNamespace getVariable format["%1%2", _procId, "cam"];
	if(str(_cam) != "<null>") then
	{
		_cam cameraEffect ["terminate","back"]; 
		camDestroy _cam;
	};
};

call fncoala_startbodycam;