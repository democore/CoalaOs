enableSaving [false, false];

MISSION_ROOT = call { 
private "_arr"; 
_arr = toArray __FILE__; 
_arr resize (count _arr - 8); 
toString _arr 
};

player addaction ["Open CoalaOs", "CoalaOs\CoalaOsMain.sqf", player, 1, true, true, "", 
"(backpack player) in ['tf_rt1523g', 'tf_rt1523g_big', 'tf_rt1523g_sage', 'tf_rt1523g_green', 'tf_rt1523g_black', 'tf_rt1523g_fabric','tf_rt1523g_bwmod', 'tf_rt1523g_big_bwmod', 'tf_rt1523g_big_rhs', 'tf_rt1523g_rhs']"
];


