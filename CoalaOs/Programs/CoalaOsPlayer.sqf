/*
	File: CoalaOsPlayer.sqf
	Creator: Niky
	Date: 11.03.2015
*/

_file = _this select 0;
_processId = _this select 1;

fncoala_startplayer = 
{
	_programWindow = [1,1,30,15, _file select 0] call fnCoala_DrawWindow;
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;
	
	_renderSurface = ["RscPicture", "", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _renderSurface, [0,0,30,15 - 1.5]] call fnCoala_addControlToWindow;
	_renderSurface ctrlSetText format["%1", _file select 5];
};

fncoala_stopplayer = 
{
	//coalaVideoPlayer ctrlSetText "";
};

call fncoala_startplayer;