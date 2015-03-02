GUI_GRID_W = 0.025;
GUI_GRID_H = 0.04;
GUI_GRID_X = 0;
GUI_GRID_Y = 0;
coalaMouseX = 0;
coalaMouseY = 0;
isMouseDown = 0;
coalaWindowId = 1801;

coalaDisplay displayAddEventHandler ["MouseMoving",
{
	[_this]call checkAndMoveWindow;
	coalaMouseX = _this select 1; 
	coalaMouseY = _this select 2; 
}];

coalaDisplay displayAddEventHandler ["MouseButtonUp",
{
	isMouseDown = 0;
	//hint "mouse up";
}];

checkAndMoveWindow = 
{
	if(isMouseDown == 1) then
	{
		_coalaActiveControl = missionNamespace getVariable "coalaActiveControl";
		//hint format["%1 %2 %3", coalaMouseX, coalaMouseY, str(count activeControl)];
		{
			_pos = ctrlPosition _x;
			_xVersatz = missionNamespace getVariable format["%1xPlus", str(_x)];
			_yVersatz = missionNamespace getVariable format["%1yPlus", str(_x)];
			_newX = (_pos select 0) + (coalaMouseX * 0.004);
			_newY = (_pos select 1) + (coalaMouseY * 0.0057);
			if(_newX > 0.558539 + _xVersatz) then
			{
				_newX = 0.558539 + _xVersatz;
			};
			if(_newX < -0.063 + _xVersatz) then
			{
				_newX = -0.063 + _xVersatz;
			};
			if(_newY > 0.710971 + _yVersatz) then
			{
				_newY = 0.710971 + _yVersatz;
			};
			if(_newY < -0.017 + _yVersatz) then
			{
				_newY = -0.017 + _yVersatz;
			};
			_x ctrlSetPosition [_newX, _newY, _pos select 2, _pos select 3]; 
			_x ctrlCommit 0;
		} foreach _coalaActiveControl;
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
	_toCreate = coalaDisplay ctrlCreate [_type, coalaWindowId];
	coalaWindowId = coalaWindowId + 1;
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
	
	_HardDrive ctrlEnable true;
	_HardDrive ctrlAddEventHandler ["MouseButtonDblClick",
	{
		[5,5, "Windowname"] call fnCoala_DrawWindow;
	}];
	
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
	
	_startMenuButton = ["RscPicture",
	MISSION_ROOT + "CoalaOs\Images\startmenu.paa",
	-2.55 + 0.3,
	21.1 - 1.8,
	1.7,
	1.7] call addCtrl;
	
};

setXYVersatz = 
{
	missionNamespace setVariable [ format["%1xPlus", str(_this select 0)], (_this select 1) * GUI_GRID_W];
	missionNamespace setVariable [ format["%1yPlus", str(_this select 0)], (_this select 2) * GUI_GRID_H];
	hint format["%1", (_this select 1)* GUI_GRID_W];
};

fnCoala_CloseWindow = 
{
	_control = _this select 0;
	_window = [_control] call fnCoala_getWindowFromControl;
	{
		ctrlDelete _x;
	}
	foreach _window;
};

fnCoala_DrawWindow = 
{
	_windowBackground = ["RscPicture", 
	MISSION_ROOT + "CoalaOs\Images\windowBackground.jpg", 
	(_this select 0), 
	(_this select 1),
	20,
	10] call addCtrl;
	[_windowBackground, 0, 0] call setXYVersatz;
	
	_topBar = ["RscBackground", 
	"", 
	(_this select 0), 
	(_this select 1),
	20,
	1.5] call addCtrl;
	[_topBar, 0, 0] call setXYVersatz;
	_topBar ctrlEnable true;
	_topBar ctrlAddEventHandler ["MouseButtonDown",
	{
		isMouseDown = 1; 
		[_this select 0] call fnCoala_FocusWindow;
		_coalaActiveControl = [_this select 0] call fnCoala_getWindowFromControl;
		missionNamespace setVariable ["coalaActiveControl", _coalaActiveControl];
	}];
	
	_windowName = ["RscText", 
	(_this select 2), 
	((_this select 0)), 
	(_this select 1),
	18.5,
	1.5] call addCtrl;
	[_windowName, 0, 0] call setXYVersatz;
	_windowName ctrlEnable true;
	_windowName ctrlAddEventHandler ["MouseButtonDown",
	{
		isMouseDown = 1; 
		[_this select 0] call fnCoala_FocusWindow;
		_coalaActiveControl = [_this select 0] call fnCoala_getWindowFromControl;
		missionNamespace setVariable ["coalaActiveControl", _coalaActiveControl];
	}];
	
	_close = ["RscPicture", 
	MISSION_ROOT + "CoalaOs\Images\close.paa", 
	((_this select 0) + 18.5), 
	(_this select 1),
	1.5,
	1.5] call addCtrl;
	[_close, 18.5, 0] call setXYVersatz;
	_close ctrlEnable true;
	_close ctrlAddEventHandler ["MouseButtonDown",
	{
		[_this select 0] call fnCoala_CloseWindow;
	}];
	
	_allControls = [_windowBackground, _topBar, _close, _windowName];
	{
		_x setVariable ["otherElements", _allControls];
		_x ctrlCommit 0;
		missionNamespace setVariable [str(_x), _allControls];
	}
	foreach _allControls;
	_allControls
};

//Gibt einen Array mit allen Controls die zum Fenster des gegebenen Controls zurück
fnCoala_getWindowFromControl = 
{
	_window = missionNamespace getVariable str(_this select 0);
	_window
};

fnCoala_FocusWindow = 
{
	_control = _this select 0;
	_window = [_control] call fnCoala_getWindowFromControl;
	{
		ctrlSetFocus _x;
	} foreach _window;
	ctrlSetFocus _control;
};


















