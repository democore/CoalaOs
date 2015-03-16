/*
	File: CoalaOsBlueforTracker.sqf
	Creator: Niky
	Date: 11.03.2015
*/

_parameters = _this select 0;
_processId = _this select 1;
_fileName = _this select 2;

fncoala_startbluefortracker = 
{
	_width = 40;
	_height = 25;
	_programWindow = [0,0,_width,_height, _fileName] call fnCoala_DrawWindow;
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;
	
	_map = ["RscMapControl", "", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _map, [0,0,_width,_height - 1.5]] call fnCoala_addControlToWindow;
	
	_map ctrlAddEventHandler 
	["Draw", 
	{
		{
			_searchFor = ["tf_rt1523g", "tf_rt1523g_big", "tf_rt1523g_sage", "tf_rt1523g_green", "tf_rt1523g_black", "tf_rt1523g_fabric",
						  "tf_rt1523g_bwmod", "tf_rt1523g_big_bwmod", "tf_rt1523g_big_rhs", "tf_rt1523g_rhs"];
			if(((playerSide == side _x) || (side player == side _x)) && (((backpack _x) in _searchFor) || ((commander vehicle _x == _x) && (vehicle _x != _x)))) then
			{
				_name = name _x;
				if((commander vehicle _x == _x) && (vehicle _x != _x)) then
				{
					_name = format["%1 - %2", _name, getText (configFile >> "CfgVehicles" >> typeOf (vehicle _x) >> "displayname")];
				};
				_this select 0 drawIcon 
				[ 
					getText (configFile >> "CfgVehicles" >> typeOf (vehicle _x) >> "icon"),//"iconman", //zu finden unter Arma 3\Addons\ui_f_data.pbo\map\... einfach _ca.paa weglassen
					[0,0,0.7,0.7], 
					getPos _x, 
					40, 
					40, 
					getDir _x, 
					_name, 
					1, 
					0.05, 
					"TahomaB", 
					"right" 
				];
			};
		} foreach allUnits;
	}];
};

fncoala_stopbluefortracker = 
{
	
};

call fncoala_startbluefortracker;