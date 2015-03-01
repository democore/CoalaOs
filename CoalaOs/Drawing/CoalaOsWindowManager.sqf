GUI_GRID_W = 0.025;
GUI_GRID_H = 0.04;
GUI_GRID_X = 0;
GUI_GRID_Y = 0;
_display = _this select 0;

addCtrl = 
{
	_type = _this select 0;
	_text = _this select 1;
	_x = _this select 2;
	_y = _this select 3;
	_w = _this select 4;
	_h = _this select 5;
	_toCreate = (_this select 6) ctrlCreate [_type, 1834];
	hint str(_toCreate);
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
	-2.55 * GUI_GRID_W + GUI_GRID_X, 
	-0.43 * GUI_GRID_H + GUI_GRID_Y,
	44.9 * GUI_GRID_W,
	21.1 * GUI_GRID_H, _display] call addCtrl;
};

fnCoala_DrawWindow = 
{
	_control = ["RscPicture", 
	MISSION_ROOT + "CoalaOs\Images\background.jpg", 
	0 * GUI_GRID_W + GUI_GRID_X, 
	0 * GUI_GRID_H + GUI_GRID_Y,
	20 * GUI_GRID_W,
	10 * GUI_GRID_H, _display] call addCtrl;
	_control ctrlSetBackgroundColor [1, 0, 0, 1]
};





















