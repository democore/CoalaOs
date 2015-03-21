/*
	File: CoalaOsChatty.sqf
	Creator: Niky
	Date: 18.03.2015
*/

_processId = _this select 1;
_fileName = _this select 2;

fncoala_startChatty = 
{
	_width = 40;
	_height = 25;
	_programWindow = [0,0,_width,_height, _fileName] call fnCoala_DrawWindow;
	[_programWindow select 0, _processId, "processID"] call fnCoala_addVariableToControl;
	
	_textInput = ["RscEdit", "", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _textInput, [1, _height - (2 + 1.5), _width - 6, 1.5]] call fnCoala_addControlToWindow;
	missionNamespace setVariable [format["%1%2", _textInput, "_processId"], _processId];
	_textInput ctrlAddEventHandler ["KeyDown",
	{
		//check pressed key -> 28 = Enter
		if(_this select 1 == 28) then
		{
			_thisControl = _this select 0;
			_processId = missionNamespace getVariable format["%1%2", _thisControl, "_processId"];
			_input = missionNamespace getVariable format["%1%2", _processId, "_textInput"];
			
			//Check if there is any text in the input
			_len = count (toArray (ctrlText _input));
			if(_len > 0) then
			{
				[[[ctrlText _input, name player], 
				{
					_lastTextMessages = missionNamespace getVariable ["_lastTextMessages", []];
					_lastTextMessages = _lastTextMessages + [format["%1: %2", _this select 1, _this select 0]];
					missionNamespace setVariable ["_lastTextMessages", _lastTextMessages];
				}
				], "BIS_fnc_spawn", true, false, false] call BIS_fnc_MP;
				_input ctrlSetText "";
			};
		};
	}];
	
	_sendButton = ["RscButton", "Send", 0,0,0,0] call addCtrl;
	[_programWindow select 0, _sendButton, [_width - 4.5, _height - (2 + 1.55), 4, 1.5]] call fnCoala_addControlToWindow;
	_sendButton ctrlAddEventHandler ["MouseButtonDown",
	{
		_thisControl = _this select 0;
		_processId = missionNamespace getVariable format["%1%2", _thisControl, "_processId"];
		_input = missionNamespace getVariable format["%1%2", _processId, "_textInput"];
		
		_len = count (toArray (ctrlText _input));
		if(_len > 0) then
		{
			_front = format["%1 %2", name player, call fnCoala_getTimeString];
			[[[_front, ctrlText _input], 
			{
				_lastTextMessages = missionNamespace getVariable ["lastTextMessages", []];
				_lastTextMessages = _lastTextMessages + [format["%1: %2", _this select 0, _this select 1]];
				missionNamespace setVariable [lastTextMessages, _lastTextMessages];
			}
			], "BIS_fnc_spawn", true, false, false] call BIS_fnc_MP;
			_input ctrlSetText "";
		};
	}];
	
	missionNamespace setVariable [format["%1%2", _sendButton, "_processId"], _processId];
	missionNamespace setVariable [format["%1%2", _textInput, "_processId"], _processId];
	
	missionNamespace setVariable [format["%1%2", _processId, "_sendButton"], _sendButton];
	missionNamespace setVariable [format["%1%2", _processId, "_textInput"], _textInput];
	missionNamespace setVariable [format["%1%2", _processId, "ProcessRunning"], "1"];
	
	//draw the text fields to show the received messages
	[_width, _height, _processId] call fnChatt_drawTextFields;

	//start the receiver for the textmessages
	[_processId] spawn fnChatty_receiveMessages;
};

//create the single textfield, representing the received messages
fnChatt_drawTextFields = 
{
	_width = _this select 0;
	_height = _this select 1;
	_processId = _this select 2;
	
	_textY = -1.5;
	_textHeight = 1.5;
	_textWidth = _width - 2;
	_textX = 0.5;
	
	_index = 0;
	
	while{_textY < _height - 5} do
	{
		_textField = ["RscText", "", 0,0,0,0] call addCtrl;
		_textField ctrlSetTextColor [0, 0, 0, 1];
		[_programWindow select 0, _textField, [_textX, _textY, _textWidth, _textHeight]] call fnCoala_addControlToWindow;
		
		missionNamespace setVariable [format["%1_textField%2", _processId, _index], _textField];
		
		_textY = _textY + 1.5;
		_index = _index + 1;
	};
	
	missionNamespace setVariable [format["%1%2", _processId, "maxIndex"], _index];
};

//push every message in the textbox above it. 
fnChatte_pushMessagesUp = 
{
	_maxIndex = missionNamespace getVariable format["%1%2", _processId, "maxIndex"];
	_index = _maxIndex - 1;
	_savedText = "";
	while {_index > 0} do
	{
		_textField = missionNamespace getVariable format["%1_textField%2", _processId, _index];
		_curSavedText = ctrlText _textField;
		_textField ctrlSetText _savedText;
		_savedText = _curSavedText;
		_index = _index - 1;
	};
};
fnChatty_receiveMessages = 
{
	_processId = _this select 0;
	_processRunning = missionNamespace getVariable format["%1%2", _processId, "ProcessRunning"];
	_lastTextMessages = missionNamespace getVariable ["lastTextMessages", []];
	while {_processRunning == "1"} do
	{
		if(count _lastTextMessages > 0) then
		{
			_message = _lastTextMessages select ((count _lastTextMessages) - 1);
			_maxIndex = missionNamespace getVariable format["%1%2", _processId, "maxIndex"];
			call fnChatte_pushMessagesUp;
			_textField = missionNamespace getVariable format["%1_textField%2", _processId, _maxIndex - 1];
			_textField ctrlSetText _message;
			
			
			_lastTextMessages = _lastTextMessages - [_message];
			missionNamespace setVariable [lastTextMessages, _lastTextMessages];
		}
		else
		{
			_lastTextMessages = missionNamespace getVariable ["lastTextMessages", []];
		};
		sleep 0.2;
		_lastTextMessages = missionNamespace getVariable ["_lastTextMessages", []];
		_processRunning = missionNamespace getVariable format["%1%2", _processId, "ProcessRunning"];
	};
};

fncoala_stopChatty = 
{
	_procId = _this select 0;
	missionNamespace setVariable [format["%1%2", _procId, "ProcessRunning"], "0"];
};
call fncoala_startChatty;


















