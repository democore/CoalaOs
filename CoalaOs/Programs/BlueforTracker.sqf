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
	_x = 1;
	_y = 1;
	if(count _parameters > 2) then
	{
		_x = parseNumber (_parameters select 2);
		_y = parseNumber (_parameters select 3);
	};
	_programWindow = [_x,_y,_width,_height, _fileName] call fnCoala_DrawWindow;
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;
	
	_pos = ctrlposition (_programWindow select 0);
	_prog = ([_processId] call fncoala_getProgramEntryById);
	_prog set [7, [(_pos select 0) / GUI_GRID_W + GUI_GRID_X, (_pos select 1) / GUI_GRID_H + GUI_GRID_Y]];
	
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
	_map ctrlAddEventHandler
	["MouseButtonDblClick",
	{
		//TODO: Find a way to add markers that can be deleted by user on map....... cannot find a solution right now..
		
		/*_WorldCoord = (_this select 0) posScreenToWorld [_this select 2,_this select 3];
		hint format["%1 %2", str(_WorldCoord select 0), str(_WorldCoord select 1)];
		_marker = createMarker [str(_WorldCoord), _WorldCoord];
		_marker setMarkerShape "ICON";
		_marker setMarkerBrush "Solid";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerType "DOT";
		
		_aMarker = vehicleVarName _x;
		_aMarker = createMarkerLocal [_aMarker,_WorldCoord];
		_aMarker setMarkerShapeLocal "ICON";
		_aMarker setMarkerTypeLocal "mil_dot";
		//_aMarker setMarkerTextLocal _unitName;
		_aMarker setMarkerSizeLocal [1,1];
		//_aMarker setmarkerDirLocal (getdir _x);
		_aMarker setMarkerPosLocal (_WorldCoord);
		//_aMarker setMarkerTextLocal _unitName;
		_aMarker setMarkerColorLocal "ColorGreen";*/
	}];
};

fncoala_stopbluefortracker = 
{
	
};

call fncoala_startbluefortracker;