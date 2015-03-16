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
	missionNamespace setVariable [format["%1%2", _processId, "cam"], "none"];
	
	_programWindow = [1,1,30,15, _fileName] call fnCoala_DrawWindow;
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;
	
	_renderSurface = ["RscPicture", "", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _renderSurface, [0,0,30,15 - 1.5]] call fnCoala_addControlToWindow;
	
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
		
		_selectedPlayer = (_allPlayers select _selectedIndex) select 0;
		
		//gab schon cam
		if(str(_oldCam) != str("none")) then
		{
			_playerId = str(netId _selectedPlayer);
			_oldCam attachTo [vehicle _selectedPlayer, [-0.05,0.1,0.08], "Head"];
			_oldCam camCommit 0;
			[_selectedPlayer, _oldCam, _processId] spawn checkActiveCameraPosition;
		}
		else
		{
			//gab noch keine cam
			_playerId = str(netId _selectedPlayer);
			_renderSurface ctrlSetText "#(argb,512,512,1)r2t(" + str(_processId) + ",1)";
			
			_cam = "camera" camCreate [0,0,0]; 
			_cam cameraEffect ["Internal", "Back", str(_processId)];
			_cam attachTo [vehicle _selectedPlayer, [-0.05,0.1,0.08], "Head"];
			_cam camCommit 0;
			missionNamespace setVariable [format["%1%2", _processId, "cam"], _cam];
			missionNamespace setVariable [format["%1%2", _processId, "playerId"], _playerId];
			[_selectedPlayer, _oldCam, _processId, _playerId] spawn checkActiveCameraPosition;
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
	_vehicle = vehicle _player;
	
	while {(missionNamespace getVariable format["%1%2", _processId, "programActive"] != "0")} do
	{
		if(_vehicle != vehicle _player) then
		{
			_cam attachTo [vehicle _player, [-0.05,0.1,0.08], "Head"];
			_vehicle = vehicle _player;
		};
		sleep 1;
	};
};

fncoala_stopbodycam = 
{
	_procId = _this select 0;
	missionNamespace setVariable [format["%1%2", _procId, "programActive"], "0"];
	_cam = missionNamespace getVariable format["%1%2", _procId, "cam"];
	if(str(_cam) != "<null>") then
	{
		_cam cameraEffect ["terminate","back"]; 
		camDestroy _cam;
	};
};

call fncoala_startbodycam;