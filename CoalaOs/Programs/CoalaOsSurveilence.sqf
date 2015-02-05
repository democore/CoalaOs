_parameters = _this select 0;

cam = nil;
uav = nil;
fncoala_startsurveilence = 
{
	/* create render surface */ 
	ctrlSetText[1101, "#(argb,512,512,1)r2t(uavrtt,1)"];
	
	/* create uav and make it fly */ 
	uav = createVehicle ["B_UAV_01_F", player modelToWorld [0,100,100], [], 0, "FLY"]; 
	createVehicleCrew uav; 
	uav lockCameraTo [player, [0]]; 
	uav flyInHeight 100; 
	//uav hideObjectGlobal true;
	
	/* add loiter waypoint */ 
	_wp = group uav addWaypoint [position player, 0]; 
	_wp setWaypointType "LOITER"; 
	_wp setWaypointLoiterType "CIRCLE_L"; 
	_wp setWaypointLoiterRadius 100; 
	
	/* create camera and stream to render surface */ 
	cam = "camera" camCreate [0,0,0]; 
	cam cameraEffect ["Internal", "Back", "uavrtt"]; 
	
	/* attach cam to gunner cam position */ 
	cam attachTo [uav, [0,0,0], "PiP0_pos"]; 
	
	/* make it zoom in a little */ 
	cam camSetFov 1; 
	
	/* switch cam to thermal */ 
	if(count _parameters > 2) then
	{
		"uavrtt" setPiPEffect [parseNumber(_parameters select 2)]; 
	}
	else
	{
		"uavrtt" setPiPEffect [0]; 
	};
	
	/* adjust cam orientation */ 
	MissionEventHandler = addMissionEventHandler ["Draw3D", { 
		_dir = (uav selectionPosition "PiP0_pos") vectorFromTo (uav selectionPosition "PiP0_dir"); 
		cam setVectorDirAndUp [ _dir, _dir vectorCrossProduct [-(_dir select 1), _dir select 0, 0]]; 
	}];
};

fncoala_stopsurveilence = 
{
	cam cameraEffect ["terminate","back"]; 
	camDestroy cam;
	removeMissionEventHandler ["Draw3D",MissionEventHandler];
	
	deleteVehicle uav;
};

call fncoala_startsurveilence;