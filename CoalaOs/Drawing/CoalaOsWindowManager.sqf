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
			if(ctrlText _x == "cmd") then
			{
				[_x] call fnCoala_FocusWindow;
			};
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
	
	if(count _this > 6) then
	{
		_toCreate ctrlAddEventHandler ["MouseEnter",
		{
			(_this select 0) ctrlSetBackgroundColor [1, 1, 1, 0.3];
			(_this select 0) ctrlCommit 0;
			//hint "mouseEnter";
		}];
		_toCreate ctrlAddEventHandler ["MouseExit",
		{
			(_this select 0) ctrlSetBackgroundColor [0, 0, 0, 0];
			(_this select 0) ctrlCommit 0;
			//hint "mouseExit";
		}];
	};
	
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

fnCoala_addFolderToExplorer = 
{
	hint "got called";
	_newWindow = _this select 0;
	_cur = _this select 1;
	_yIndex = _this select 2;
	_breaker = _this select 3;
	_counter = _this select 4;
	
	_imageName = "folder";
	if(count _cur > 6) then
	{
		if(_cur select 6 == "image") then
		{
			_imageName = "image";
		};
		if(_cur select 6 == "exe") then
		{
			_imageName = "exe";
		};
	};
	
	_folderCtrl = ["RscPicture", MISSION_ROOT + "CoalaOs\Images\" + _imageName + ".paa", 0,0,0,0] call addCtrl;
	_folderCtrl ctrlEnable true;
	[_folderCtrl, _cur, "folderStructure"] call fnCoala_addVariableToControl;
	_folderCtrl ctrlAddEventHandler ["MouseButtonDblClick",
	{
		_folderInfo = [_this select 0, "folderStructure"] call fnCoala_getVariableToControl;
		_folders = [_this select 0] call fnCoala_getWindowFromControl;
		[format["cd %1", (_folderInfo select 0)], _folders] call fnCoala_changeExplorerPath;
		hint str(format["%1", _folders]);
	}];
	
	_name = (_cur select 0);
	_folderCtrlText = ["RscText", _name, 0,0,0,0] call addCtrl;
	_folderCtrlText ctrlSetFontHeight 0.03;
	_folderCtrlText ctrlSetTextColor [0,0,0,1]; 
	_folderCtrlText ctrlSetTooltip _name;
	
	[_newWindow select 0, _folderCtrl, 
	[0.5 + _counter * 4 + 1 * _counter,_yIndex * 5 + 0.2,4,4]] call fnCoala_addControlToWindow;
	
	[_newWindow select 0, _folderCtrlText, 
	[0.5 + _counter * 4 + 1 * _counter,_yIndex * 5 + 3.8,4,1]] call fnCoala_addControlToWindow;
	
	if(_breaker == _counter) then
	{
		_yIndex = _yIndex + 1;
		_counter = 0;
	}
	else
	{
		_counter = _counter + 1;
	};
	[_yIndex, _counter]
};

fnCoala_changeExplorerPath = 
{
	_command = _this select 0;
	_newWindow = _this select 1;
	[_newWindow select 0] call fnCoala_CloseWindow;
	_newWindow = [5,5, "Explorer - C:\"] call fnCoala_DrawWindow;
	[_command] call fncoala_excecuteCommandFromNonConsole;
	_folders = ["ls"] call fncoala_excecuteCommandFromNonConsole;
	_yIndex = 0;
	_breaker = 3;
	_counter = 0;
	_folders = [[".."]] + _folders;
	{
		_cur = (_folders select _forEachIndex);
		
		_imageName = "folder";
		if(count _cur > 6) then
		{
			if(_cur select 6 == "image") then
			{
				_imageName = "image";
			};
			if(_cur select 6 == "exe") then
			{
				_imageName = "exe";
			};
		};
		_folderCtrl = ["RscPicture", MISSION_ROOT + "CoalaOs\Images\" + _imageName + ".paa", 0,0,0,0] call addCtrl;
		_folderCtrl ctrlEnable true;
		[_folderCtrl, _cur, "folderStructure"] call fnCoala_addVariableToControl;
		_folderCtrl ctrlAddEventHandler ["MouseButtonDblClick",
		{
			
			_folderInfo = [_this select 0, "folderStructure"] call fnCoala_getVariableToControl;
			if(count _folderInfo > 4) then
			{
				if(_folderInfo select 4 == 1) then
				{
					_folders = [_this select 0] call fnCoala_getWindowFromControl;
					[format["cd %1", (_folderInfo select 0)], _folders] call fnCoala_changeExplorerPath;	
				}
				else
				{
					[format["open %1", (_folderInfo select 0)]] call fncoala_excecuteCommandFromNonConsole;
				};
			}
			else
			{
				_folders = [_this select 0] call fnCoala_getWindowFromControl;
				[format["cd %1", (_folderInfo select 0)], _folders] call fnCoala_changeExplorerPath;	
			};
		}];
		
		_name = (_cur select 0);
		_folderCtrlText = ["RscText", _name, 0,0,0,0] call addCtrl;
		_folderCtrlText ctrlSetFontHeight 0.03;
		_folderCtrlText ctrlSetTextColor [0,0,0,1]; 
		_folderCtrlText ctrlSetTooltip _name;
		
		[_newWindow select 0, _folderCtrl, 
		[0.5 + _counter * 4 + 1 * _counter,_yIndex * 5 + 0.2,4,4]] call fnCoala_addControlToWindow;
		
		[_newWindow select 0, _folderCtrlText, 
		[0.5 + _counter * 4 + 1 * _counter,_yIndex * 5 + 3.8,4,1]] call fnCoala_addControlToWindow;
		
		if(_breaker == _counter) then
		{
			_yIndex = _yIndex + 1;
			_counter = 0;
		}
		else
		{
			_counter = _counter + 1;
		};
	}
	foreach _folders;
};

fnCoala_DrawDesktop = 
{
	_HardDrive = ["RscPicture", 
	MISSION_ROOT + "CoalaOs\Images\Hard-Drive-icon.paa", 
	-2, 0, 4, 3, true] call addCtrl;
	_HardDrive ctrlEnable true;
	_HardDrive ctrlAddEventHandler ["MouseButtonDblClick",
	{
		_newWindow = [5,5, "Explorer - C:\"] call fnCoala_DrawWindow;
		["", _newWindow] call fnCoala_changeExplorerPath;
	}];
	
	_windowName = ["RscText", 
	"C:\", 
	-0.7, 
	(-0.43) + 2.8,
	2,
	1.5, false] call addCtrl;
	_windowName ctrlEnable true;
	
	_taskBar = ["RscBackground", 
	"", 
	-2.55, 
	21.1 - 1.8,
	44.9,
	1.5] call addCtrl;
	_r = 24;
	_g = 31;
	_b = 28;
	_taskBar ctrlSetBackgroundColor [_r/255, _g/255, _b/255, 1];
	_taskBar ctrlSetForegroundColor [_r/255, _g/255, _b/255, 1];
	
	_startMenuButton = ["RscPicture",
	MISSION_ROOT + "CoalaOs\Images\startmenu.paa",
	-2.55 + 0.3,
	21.1 - 1.8,
	1.7,
	1.7] call addCtrl;
	
	_cmd = ["RscPicture", 
	MISSION_ROOT + "CoalaOs\Images\cmd.paa", 
	5, 
	0.19,
	3.6,
	2.6] call addCtrl;
	_cmd ctrlEnable true;
	_cmd ctrlAddEventHandler ["MouseButtonDblClick",
	{
		_newWindow = [5,5, "cmd"] call fnCoala_DrawWindow;
		[_newWindow select 0, coalaConsole, [0,0,20,10.5]] call fnCoala_addControlToWindow;
	}];
	
	_cmdName = ["RscText", 
	"cmd", 
	5.5, 
	(-0.43) + 2.8,
	20,
	1.5] call addCtrl;
	
	_browser = ["RscPicture", 
	MISSION_ROOT + "CoalaOs\Images\browser.paa", 
	11, 
	0.19,
	3.6,
	2.6] call addCtrl;
	_browser ctrlEnable true;
	_browser ctrlAddEventHandler ["MouseButtonDblClick",
	{
		_newWindow = [5,5, "Browser"] call fnCoala_DrawWindow;
		_browserCtrl = ["RscHTML", "", 0,0,0,0] call addCtrl;
		_browserCtrl ctrlSetBackgroundColor [0,0,0,1];
		[_newWindow select 0, _browserCtrl, 
		[0,0,20,10.5]] call fnCoala_addControlToWindow;
		_browserCtrl htmlLoad "http://google.de";
	}];
	
	_browserName = ["RscText", 
	"Browser", 
	11, 
	(-0.43) + 2.8,
	20,
	1.5] call addCtrl;
	
	
};

setXYVersatz = 
{
	missionNamespace setVariable [ format["%1xPlus", str(_this select 0)], (_this select 1) * GUI_GRID_W];
	missionNamespace setVariable [ format["%1yPlus", str(_this select 0)], (_this select 2) * GUI_GRID_H];
	//hint format["%1", (_this select 1)* GUI_GRID_W];
};

fnCoala_CloseWindow = 
{
	_control = _this select 0;
	_window = [_control] call fnCoala_getWindowFromControl;
	
	_processId = [_window select 0, "processID"] call fnCoala_getVariableToControl;
	if(str(_processId) != "<null>") then
	{
		[format["close %1", _processId]] call fncoala_excecuteCommandFromNonConsole;
	};
	
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
	12] call addCtrl;
	[_windowBackground, 0, 0] call setXYVersatz;
	
	_topBar = ["RscBackground", 
	"", 
	(_this select 0), 
	(_this select 1),
	20,
	1.5] call addCtrl;
	[_topBar, 0, 0] call setXYVersatz;
	_topBar ctrlEnable true;
	_r = 24;
	_g = 31;
	_b = 28;
	_topBar ctrlSetBackgroundColor [_r/255, _g/255, _b/255, 1];
	_topBar ctrlSetForegroundColor [_r/255, _g/255, _b/255, 1];
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
		[_x, _allControls] call fnCoala_addVariableToControl;
		[_x, "Basic", "type"] call fnCoala_addVariableToControl;
	}
	foreach _allControls;
	_allControls
};

//currently crashes arma after a few trys
fnCoala_clearWindow = 
{
	_windowControl = _this select 0;
	_controls = [_windowControl] call fnCoala_getWindowFromControl;
	{
		_controlType = [_x, "type"] call fnCoala_getVariableToControl;
		if(_controLType == "added") then
		{
			ctrlDelete _x;
		};
	} foreach _controls;
};

fnCoala_addVariableToControl = 
{
	_control = _this select 0;
	_variable = _this select 1;
	_varName = "";
	if(count _this > 2) then
	{
		_varName = _this select 2;
		//hint "varname was added";
	};
	//hint str(_this);
	missionNamespace setVariable [format["%1%2", str(_control), _varName], _variable];
};

fnCoala_getVariableToControl = 
{
	_control = _this select 0;
	_varName = "";
	if(count _this > 1) then
	{
		_varName = _this select 1;
	};
	_variable = missionNamespace getVariable format["%1%2", str(_control), _varName];
	_variable
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

//_this select 0 -> wo es hinzugefügt werden soll
//_this select 1 -> das control das hinzugefügt werden soll
//(Optional) _this select 2 -> [x,y,h,w] wobei 0,0 oben links im window des Controls aus _this select 0 ist
fnCoala_addControlToWindow = 
{
	_control = _this select 0;
	_toAddControl = _this select 1;
	
	_allControls = missionNamespace getVariable str(_control);
	_allControls = _allControls + [_toAddControl];
	
	
	_window = [_control] call fnCoala_getWindowFromControl;
	
	[_toAddControl, "added", "type"] call fnCoala_addVariableToControl;
	{
		_x setVariable ["otherElements", _allControls];
		[_x, _allControls] call fnCoala_addVariableToControl;
	} foreach _window;
	
	if(count _this > 2) then
	{
		_pos = _this select 2;
		_zeroPos = ctrlPosition (_allControls select 0);
		
		_newX = (_zeroPos select 0) + ((_pos select 0) * GUI_GRID_W);
		_newY = (_zeroPos select 1) + (1.5 * GUI_GRID_H) + ((_pos select 1) * GUI_GRID_H);
		_newW = (_pos select 2) * GUI_GRID_W;
		_newH = (_pos select 3) * GUI_GRID_H;
		
		_toAddControl ctrlSetPosition[_newX, _newY, _newW, _newH];
		[_toAddControl, (_zeroPos select 0) + (_pos select 0), (_zeroPos select 1) + (_pos select 1)] call setXYVersatz;
		
		_toAddControl ctrlCommit 0;
	};
};

fnCoala_showDialog = 
{
	_text = _this select 0;
	_headerText = _this select 1;
	
	_newWindow = [5,5, _headerText] call fnCoala_DrawWindow;
	_textRsc = ["RscText", _text, 0, 0, 10, 5] call addCtrl;
	[_newWindow select 0, _textRsc, [0, 0, 20, 10.5]] call fnCoala_addControlToWindow;
};
















