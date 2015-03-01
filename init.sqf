enableSaving [false, false];

MISSION_ROOT = call { 
private "_arr"; 
_arr = toArray __FILE__; 
_arr resize (count _arr - 8); 
toString _arr 
};

player addaction ["anzeigen", "CoalaOs\CoalaOsMain.sqf"];
