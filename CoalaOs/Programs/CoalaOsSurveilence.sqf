_parameters = _this select 0;
_processId = _this select 1;
_fileName = _this select 2;
_uav = nil;
_cam = nil;

fncoala_startsurveilence = 
{
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
	_btnNV = ["RscButton", "1", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnNV, [1.1,0,1,1]] call fnCoala_addControlToWindow;
	_btnNV ctrlAddEventHandler ["MouseButtonDown",
	{
		_camId = missionNamespace getVariable format["%1%2", _this select 0, "_uavId"];
		_camId setPiPEffect [1];
	}];
	_btnWarm = ["RscButton", "2", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnWarm, [2.2,0,1,1]] call fnCoala_addControlToWindow;
	_btnWarm ctrlAddEventHandler ["MouseButtonDown",
	{
		_camId = missionNamespace getVariable format["%1%2", _this select 0, "_uavId"];
		_camId setPiPEffect [2];
	}];
	
	_btnPlus = ["RscButton", "+", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnPlus, [1.1,1.1,1,1]] call fnCoala_addControlToWindow;
	_btnPlus ctrlAddEventHandler ["MouseButtonDown",
	{
		_id = missionNamespace getVariable format["%1%2", _this select 0, "_camId"];
		_fov = missionNamespace getVariable format["%1%2", _id, "_fov"];
		_fov = _fov - 0.1;
		hint str(_fov);
		missionNamespace setVariable [format["%1%2", _id, "_fov"], _fov];
	}];
	_btnMinus = ["RscButton", "-", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnMinus, [0,1.1,1,1]] call fnCoala_addControlToWindow;
	_btnMinus ctrlAddEventHandler ["MouseButtonDown",
	{
		_id = missionNamespace getVariable format["%1%2", _this select 0, "_camId"];
		_fov = missionNamespace getVariable format["%1%2", _id, "_fov"];
		_fov = _fov + 0.1;
		hint str(_fov);
		missionNamespace setVariable [format["%1%2", _id, "_fov"], _fov];
	}];
	
	_btnStop = ["RscButton", "Stop", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnStop, [3.3,0,3,1]] call fnCoala_addControlToWindow;
	_btnStop ctrlAddEventHandler ["MouseButtonDown",
	{
		_group = missionNamespace getVariable format["%1%2", _this select 0, "_group"];
		while {(count (waypoints _group)) > 0} do 
		{ 
			deleteWaypoint ((waypoints _group) select 0); 
		};
	}];
	_btnRotate = ["RscButton", "Move", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnRotate, [6.4,0,3,1]] call fnCoala_addControlToWindow;
	_btnRotate ctrlAddEventHandler ["MouseButtonDown",
	{
		_uav = missionNamespace getVariable format["%1%2", _this select 0, "_uav"];
		_wp = group _uav addWaypoint [position player, 0]; 
		_wp setWaypointType "LOITER"; 
		_wp setWaypointLoiterType "CIRCLE_L"; 
		_wp setWaypointLoiterRadius 100; 
	}];
	
	_btnUp = ["RscButton", "↑", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnUp, [2.2,1.1,1,1]] call fnCoala_addControlToWindow;
	_btnUp ctrlAddEventHandler ["MouseButtonDown",
	{
		_uavId = missionNamespace getVariable format["%1%2", _this select 0, "_camId"];
		_uav = missionNamespace getVariable format["%1%2", _uavId, "_uav"];
		_height = missionNamespace getVariable format["%1%2", _uavId, "_height"];
		_height = _height + 10;
		missionNamespace setVariable [format["%1%2", _uavId, "_height"], _height];
	}];
	_btnDown = ["RscButton", "↓", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _btnDown, [3.3,1.1,1,1]] call fnCoala_addControlToWindow;
	_btnDown ctrlAddEventHandler ["MouseButtonDown",
	{
		_uavId = missionNamespace getVariable format["%1%2", _this select 0, "_camId"];
		_uav = missionNamespace getVariable format["%1%2", _uavId, "_uav"];
		_height = missionNamespace getVariable format["%1%2", _uavId, "_height"];
		_height = _height - 10;
		missionNamespace setVariable [format["%1%2", _uavId, "_height"], _height];
	}];
	
	_textHeight = ["RscText", "100m", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _textHeight, [4.4,1.1,3,1]] call fnCoala_addControlToWindow;
	
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;
	
	/* create uav and make it fly */ 
	_uav = createVehicle ["B_UAV_01_F", player modelToWorld [0,100,100], [], 0, "FLY"]; 
	createVehicleCrew _uav; 
	_uav lockCameraTo [player, [0]]; 
	_uav flyInHeight 100; 
	
	missionNamespace setVariable [format["%1%2", _processId, "_uavId"], str(netId _uav)];
	_camId = missionNamespace getVariable format["%1%2", _processId, "_uavId"];
	
	
	[_camId] call fnCoala_debug;
	
	//uav hideObjectGlobal true;
	
	/* create render surface */ 
	_renderSurface ctrlSetText "#(argb,512,512,1)r2t(" + _camId + ",1)";
	
	/* add loiter waypoint */ 
	_wp = group _uav addWaypoint [position player, 0]; 
	_wp setWaypointType "LOITER"; 
	_wp setWaypointLoiterType "CIRCLE_L"; 
	_wp setWaypointLoiterRadius 100; 
	
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
	
	missionNamespace setVariable [format["%1%2", _processId, "_cam"], _cam];
	missionNamespace setVariable [format["%1%2", _processId, "_uav"], _uav];
	
	missionNamespace setVariable [format["%1%2", _btnNormal, "_uavId"], _camId];
	missionNamespace setVariable [format["%1%2", _btnNV, "_uavId"], _camId];
	missionNamespace setVariable [format["%1%2", _btnWarm, "_uavId"], _camId];
	missionNamespace setVariable [format["%1%2", _btnStop, "_group"], (group _uav)];
	missionNamespace setVariable [format["%1%2", _btnRotate, "_uav"], _uav];
	missionNamespace setVariable [format["%1%2", _btnUp, "_camId"], _camId];
	missionNamespace setVariable [format["%1%2", _btnDown, "_camId"], _camId];
	
	missionNamespace setVariable [format["%1%2", _btnPlus, "_camId"], _camId];
	missionNamespace setVariable [format["%1%2", _btnMinus, "_camId"], _camId];
	
	missionNamespace setVariable [format["%1%2", _camId, "_cam"], _cam];
	missionNamespace setVariable [format["%1%2", _camId, "_fov"], 1];
	missionNamespace setVariable [format["%1%2", _camId, "_height"], 100];
	missionNamespace setVariable [format["%1%2", _camId, "_uav"], _uav];
	
	missionNamespace setVariable [format["%1%2", _processId, "_doMovement"], "true"];
	[_uav, _cam, _processId, _camId] spawn doCamMovement;
	[_uav, _camId, _processId, _textHeight] spawn setDroneHeight;
};

setDroneHeight = 
{
	_uav = _this select 0;
	_id = _this select 1;
	_procId = _this select 2;
	_textHeight = _this select 3;
	_isAllowed = "true";
	_lastHeight = 100;
	while{_isAllowed == "true" || str(_isAllowed) == "<null>"} do
	{
		_height = missionNamespace getVariable format["%1%2", _id, "_height"];
		if(_height != _lastHeight) then
		{
			_uav flyInHeight _height;
			_lastHeight = _height;
		};
		_isAllowed = missionNamespace getVariable format["%1%2", _procId, "_doMovement"];
		hint format["checked height %1", _height];
		
		_textHeight ctrlSetText format["%1m", str( floor((getPos _uav) select 2) )];
		sleep 1;
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
		//[str(_procId)] call fnCoala_debug;
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
	deleteVehicle _uav;
};

fncoala_stopsurveilence = 
{
	_procId = _this select 0;
	_cam = missionNamespace getVariable format["%1%2", _procId, "_cam"];
	_uav = missionNamespace getVariable format["%1%2", _procId, "_uav"];
	missionNamespace setVariable [format["%1%2", _procId, "_doMovement"], "false"];
};

call fncoala_startsurveilence;