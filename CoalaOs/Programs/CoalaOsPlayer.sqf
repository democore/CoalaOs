_file = _this select 0;

fncoala_startplayer = 
{
	//_ok = createDialog "playerclass";
	//cutrsc ["player","PLAIN"];
	coalaVideoPlayer ctrlSetText format["%1", _file select 5];
	//Video_rsc ctrlSetText format["%1", _file select 5];
	hint format["%1", _file select 5];
};

fncoala_stopplayer = 
{
	coalaVideoPlayer ctrlSetText "";
};

call fncoala_startplayer;