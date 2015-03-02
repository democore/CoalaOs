GUI_GRID_W = 0.025;
GUI_GRID_H = 0.04;
GUI_GRID_X = 0;
GUI_GRID_Y = 0;
coalaMouseX = 0;
coalaMouseY = 0;
isMouseDown = false;
activeControl = [];

coalaDisplay displayAddEventHandler ["MouseMoving",
{
	[_this]call checkAndMoveWindow;
	coalaMouseX = _this select 1; 
	coalaMouseY = _this select 2; 
}];

checkAndMoveWindow = 
{
	hint str (count activeControl);
	if(count activeControl > 0) then
	{
		hint "moving1";
		if(isMouseDown == true) then
		{
			hint "moving";
		};
	};
};

addCtrl = 
{
	_type = _this select 0;
	_text = _this select 1;
	_x = (_this select 2) * GUI_GRID_W + GUI_GRID_X;
	_y = (_this select 3) * GUI_GRID_H + GUI_GRID_Y;
	_w = (_this select 4) * GUI_GRID_W;
	_h = (_this select 5) * GUI_GRID_H;
	_toCreate = coalaDisplay ctrlCreate [_type, 1834];
	//hint str(_toCreate);
	if(_text != "") then
	{
		_toCreate ctrlSetText _text;
	};
	_toCreate ctrlSetPosition [_x, _y, _w, _h];
	
	_toCreate ctrlCommit 0;
	_toCreate
};

fnCoala_drawBackgroundImage =
{
	_backgroundControl = ["RscPicture", 
	MISSION_ROOT + "CoalaOs\Images\background.jpg", 
	-2.55, 
	-0.43,
	44.9,
	21.1] call addCtrl;
};

fnCoala_DrawDesktop = 
{
	_HardDrive = ["RscPicture", 
	MISSION_ROOT + "CoalaOs\Images\Hard-Drive-icon.paa", 
	-2, 
	0,
	4,
	3] call addCtrl;
	
	_windowName = ["RscText", 
	"C", 
	-0.5, 
	(-0.43) + 2.8,
	20,
	1.5] call addCtrl;
	
	_taskBar = ["RscBackground", 
	"", 
	-2.55, 
	21.1 - 1.8,
	44.9,
	1.5] call addCtrl;
	_windowBackground ctrlSetForegroundColor [1, 0, 0, 1];
	_windowBackground ctrlSetBackgroundColor [1, 0, 0, 1];
	_windowBackground ctrlCommit 0;
};

fnCoala_DrawWindow = 
{
	_windowBackground = ["RscPicture", 
	MISSION_ROOT + "CoalaOs\Images\windowBackground.jpg", 
	(_this select 0), 
	(_this select 1),
	20,
	10] call addCtrl;
	
	_topBar = ["RscBackground", 
	"", 
	(_this select 0), 
	(_this select 1),
	20,
	1.5] call addCtrl;
	 
	_close = ["RscPicture", 
	MISSION_ROOT + "CoalaOs\Images\close.paa", 
	((_this select 0) + 18.5), 
	(_this select 1),
	1.5,
	1.5] call addCtrl;
	
	_windowName = ["RscText", 
	(_this select 2), 
	((_this select 0)), 
	(_this select 1),
	20,
	1.5] call addCtrl;
	
	_allControls = [_windowBackground, _topBar, _close, _windowName];
	{
		_x setVariable ["otherElements", _allControls];
		_x ctrlEnable true;
		_x ctrlAddEventHandler ["MouseButtonDown",
		{
			isMouseDown = true; 
			activeControl = _allControls;
			hint "mouse down";
		}];
		_x ctrlCommit 0;
	}
	foreach _allControls;
		
	_allControls
};





















