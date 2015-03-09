_parameters = _this select 0;
_processId = _this select 1;
_fileName = _this select 2;

fncoala_startbluefortracker = 
{
	_width = 40;
	_height = 25;
	_programWindow = [1,1,_width,_height, _fileName] call fnCoala_DrawWindow;
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;
	
	_map = ["RscMapControl", "", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _map, [0,0,_width,_height - 1.5]] call fnCoala_addControlToWindow;
	
	_map ctrlAddEventHandler 
	["Draw", 
	{
		{
			_this select 0 drawIcon 
			[ 
				"iconlogic", //zu finden unter Arma 3\Addons\ui_f_data.pbo\map\... einfach _ca.paa weglassen
				[0,0,0,1], 
				getPos _x, 
				24, 
				24, 
				getDir _x, 
				name _x, 
				1, 
				0.03, 
				"TahomaB", 
				"right" 
			];
		} foreach allUnits;
	}];
};

fncoala_stopbluefortracker = 
{
	
};

call fncoala_startbluefortracker;