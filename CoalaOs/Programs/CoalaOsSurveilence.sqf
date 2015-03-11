_parameters = _this select 0;
_processId = _this select 1;
_fileName = _this select 2;
_uav = nil;
_cam = nil;

fncoala_startsurveilence = 
{
	missionNamespace setVariable [format["%1%2", _processId, "cam"], nil];
	_width = 30;
	_height = 20;
	_programWindow = [1, 1, _width, _height, _fileName] call fnCoala_DrawWindow;
	_renderSurface = ["RscPicture", "", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _renderSurface, [0,0,_width,_height - 1.5]] call fnCoala_addControlToWindow;
	
	_btnNormal = ["RscButton", "0", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnNormal, [0,0,1,1]] call fnCoala_addControlToWindow;
	_btnNormal ctrlAddEventHandler ["MouseButtonDown",
	{
		_camId = missionNamespace getVariable format["%1%2", _this select 0, "_uavId"];
		_camId setPiPEffect [0];
	}];
	missionNamespace setVariable [format["%1%2", _processId, "_btnNormal"], _btnNormal];
	
	_btnNV = ["RscButton", "1", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnNV, [1.1,0,1,1]] call fnCoala_addControlToWindow;
	_btnNV ctrlAddEventHandler ["MouseButtonDown",
	{
		_camId = missionNamespace getVariable format["%1%2", _this select 0, "_uavId"];
		_camId setPiPEffect [1];
	}];
	missionNamespace setVariable [format["%1%2", _processId, "_btnNV"], _btnNV];
	
	_btnWarm = ["RscButton", "2", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnWarm, [2.2,0,1,1]] call fnCoala_addControlToWindow;
	_btnWarm ctrlAddEventHandler ["MouseButtonDown",
	{
		_camId = missionNamespace getVariable format["%1%2", _this select 0, "_uavId"];
		_camId setPiPEffect [2];
	}];
	missionNamespace setVariable [format["%1%2", _processId, "_btnWarm"], _btnWarm];
	
	
	_btnPlus = ["RscButton", "+", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnPlus, [1.1,1.1,1,1]] call fnCoala_addControlToWindow;
	_btnPlus ctrlAddEventHandler ["MouseButtonDown",
	{
		_id = missionNamespace getVariable format["%1%2", _this select 0, "_camId"];
		_fov = missionNamespace getVariable format["%1%2", _id, "_fov"];
		_fov = _fov - 0.1;
		missionNamespace setVariable [format["%1%2", _id, "_fov"], _fov];
	}];
	missionNamespace setVariable [format["%1%2", _processId, "_btnPlus"], _btnPlus];
	
	_btnMinus = ["RscButton", "-", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnMinus, [0,1.1,1,1]] call fnCoala_addControlToWindow;
	_btnMinus ctrlAddEventHandler ["MouseButtonDown",
	{
		_id = missionNamespace getVariable format["%1%2", _this select 0, "_camId"];
		_fov = missionNamespace getVariable format["%1%2", _id, "_fov"];
		_fov = _fov + 0.1;
		missionNamespace setVariable [format["%1%2", _id, "_fov"], _fov];
	}];
	missionNamespace setVariable [format["%1%2", _processId, "_btnMinus"], _btnMinus];
	
	
	_playerSelection = ["RscCombo", "", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _playerSelection, [0,3.2,10,1]] call fnCoala_addControlToWindow;
	_playerSelection ctrlAddEventHandler ["LBSelChanged",
	{
		_control = _this select 0;
		_selectedIndex = lbCurSel _control;
		if(_selectedIndex != -1) then
		{
			_allDrones = missionNamespace getVariable format["%1%2", _control, "allDrones"];
			_renderSurface = missionNamespace getVariable format["%1%2", _control, "renderSurface"];
			_processId = missionNamespace getVariable format["%1%2", _control, "processId"];
			_oldCam = missionNamespace getVariable format["%1%2", _processId, "cam"];
			if(_oldCam != nil) then
			{
				_oldCam cameraEffect ["terminate","back"]; 
				camDestroy _oldCam;
			};
			
			_selectedDrone = (_allDrones select _selectedIndex);
			_droneId = str(netId _selectedDrone);
			
			hint str(_renderSurface);
			_renderSurface ctrlSetText "#(argb,512,512,1)r2t(" + _playerId + ",1)";
			
			[_selectedDrone, _processId, _renderSurface] call setActiveDrone;
		};
	}];
	
	[_playerSelection, _processId] spawn keepDronesListUpdated;
	
	_textHeight = ["RscText", "100m", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _textHeight, [4.4,1.1,3,1]] call fnCoala_addControlToWindow;
	
	missionNamespace setVariable [format["%1%2", _playerSelection, "renderSurface"], _renderSurface];
	missionNamespace setVariable [format["%1%2", _playerSelection, "processId"], _processId];
	
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;
	
	
	_allDrones = [];
	{
		_name = getText(configFile >> "cfgVehicles" >> typeOf _x >> "DisplayName");
		//hint _name;
		if(typeOf _x == "B_UAV_01_F") then
		{
			_allDrones = _allDrones + [_x];
			_playerSelection lbAdd (_name);
		};
	} foreach vehicles;
	missionNamespace setVariable [format["%1%2", _playerSelection, "allDrones"], _allDrones];
	
	_playerSelection lbSetCurSel 0;
};

setActiveDrone = 
{
	_uav = _this select 0;
	_processId = _this select 1;
	_renderSurface = _this select 2;
	
	_camId = str(netId _uav);
	missionNamespace setVariable [format["%1%2", _processId, "_uavId"], _camId];
	
	/* create render surface */ 
	_renderSurface ctrlSetText "#(argb,512,512,1)r2t(" + _camId + ",1)";
	
	/* create camera and stream to render surface */ 
	_cam = "camera" camCreate [0,0,0]; 
	_cam cameraEffect ["Internal", "Back", _camId]; 
	
	/* attach cam to gunner cam position */ 
	_cam attachTo [_uav, [0,0,0], "PiP0_pos"]; 
	
	/* make it zoom in a little */ 
	_cam camSetFov 1; 
	
	//_cam camSetTarget player;
	
	/* switch cam to thermal */ 
	if(count _parameters > 2) then
	{
		_camId setPiPEffect [parseNumber(_parameters select 2)]; 
	}
	else
	{
		_camId setPiPEffect [0]; 
	};
	_cam camCommit 0;
	
	/* adjust cam orientation */ 
	
	_btnNormal = missionNamespace getVariable format["%1%2", _processId, "_btnNormal"];
	_btnNV = missionNamespace getVariable format["%1%2", _processId, "_btnNV"];
	_btnWarm = missionNamespace getVariable format["%1%2", _processId, "_btnWarm"];
	_btnPlus = missionNamespace getVariable format["%1%2", _processId, "_btnPlus"];
	_btnMinus = missionNamespace getVariable format["%1%2", _processId, "_btnMinus"];
	
	missionNamespace setVariable [format["%1%2", _processId, "cam"], _cam];
	missionNamespace setVariable [format["%1%2", _processId, "_cam"], _cam];
	missionNamespace setVariable [format["%1%2", _processId, "_uav"], _uav];
	
	missionNamespace setVariable [format["%1%2", _btnNormal, "_uavId"], _camId];
	missionNamespace setVariable [format["%1%2", _btnNV, "_uavId"], _camId];
	missionNamespace setVariable [format["%1%2", _btnWarm, "_uavId"], _camId];
	
	missionNamespace setVariable [format["%1%2", _btnPlus, "_camId"], _camId];
	missionNamespace setVariable [format["%1%2", _btnMinus, "_camId"], _camId];
	
	missionNamespace setVariable [format["%1%2", _camId, "_cam"], _cam];
	missionNamespace setVariable [format["%1%2", _camId, "_fov"], 1];
	missionNamespace setVariable [format["%1%2", _camId, "_height"], 100];
	missionNamespace setVariable [format["%1%2", _camId, "_uav"], _uav];
	
	missionNamespace setVariable [format["%1%2", _processId, "_doMovement"], "true"];
	[_uav, _cam, _processId, _camId] spawn doCamMovement;
};

keepDronesListUpdated = 
{
	_playerSelection = _this select 0;
	_processId = _this select 0;
	missionNamespace setVariable [format["%1%2", _processId, "programActive"], "1"];
	
	_active = missionNamespace getVariable format["%1%2", _processId, "programActive"];
	while {_active == "1"} do
	{
		lbClear _playerSelection;
		_allDrones = [];
		{
			_name = getText(configFile >> "cfgVehicles" >> typeOf _x >> "DisplayName");
			//hint _name;
			if(typeOf _x == "B_UAV_01_F") then
			{
				_allDrones = _allDrones + [_x];
				_playerSelection lbAdd (_name);
			};
		} foreach vehicles;
		missionNamespace setVariable [format["%1%2", _playerSelection, "allDrones"], _allDrones];
		sleep 1;
		_active = missionNamespace getVariable [format["%1%2", _processId, "programActive"], "0"];
	};
};

doCamMovement = 
{
	_uav = _this select 0;
	_cam = _this select 1;
	_procId = _this select 2;
	_id = _this select 3;
	_isAllowed = "true";
	while{_isAllowed == "true" || str(_isAllowed) == "<null>"} do
	{
		_dir = (_uav selectionPosition "PiP0_pos") vectorFromTo (_uav selectionPosition "PiP0_dir"); 
		_cam setVectorDirAndUp [ _dir, _dir vectorCrossProduct [-(_dir select 1), _dir select 0, 0]];
		_fov = nil;
		_fov = missionNamespace getVariable format["%1%2", _id, "_fov"];
		if(str(_fov) != "<null>") then
		{
			_cam camSetFov _fov; 
			_cam camCommit 0;
		};
		sleep 0.1;
		_isAllowed = missionNamespace getVariable format["%1%2", _procId, "_doMovement"];
	};	
	
	_cam cameraEffect ["terminate","back"]; 
	camDestroy _cam;
};

fncoala_stopsurveilence = 
{
	_procId = _this select 0;
	_cam = missionNamespace getVariable format["%1%2", _procId, "_cam"];
	_uav = missionNamespace getVariable format["%1%2", _procId, "_uav"];
	_cam cameraEffect ["terminate","back"]; 
	camDestroy _cam;
	missionNamespace setVariable [format["%1%2", _procId, "_doMovement"], "false"];
	missionNamespace setVariable [format["%1%2", _procId, "programActive"], "0"];
};

call fncoala_startsurveilence;