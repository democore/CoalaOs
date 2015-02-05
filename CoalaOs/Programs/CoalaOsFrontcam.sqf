fncoala_startfrontcam = 
{
	/* create render surface */ 
	ctrlSetText[1101, "#(argb,512,512,1)r2t(uavrtt,1)"];
	/* create camera and stream to render surface */ 
	cam = "camera" camCreate (getPos player);//([(getPos player select 0),(getPos player select 1) + 1,getPos player select 2]);
	
	cam cameraEffect ["Internal", "Back", "uavrtt"]; 
	cam camSetTarget player;
	cam attachTo [player, [0.1, 0.75, 1.5] ];
	cam camSetFov 0.8; 
	
	cam camCommit 0;
};

fncoala_stopfrontcam = 
{
	cam cameraEffect ["terminate","back"]; 
	camDestroy cam;
};

call fncoala_startfrontcam;