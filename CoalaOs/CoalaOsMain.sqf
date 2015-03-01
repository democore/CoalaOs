/*    ___..._           _...___
   /'--.._ `'-="""=-'` _..--'\
   |   ~. )  _     _  ( .~   |
    \  '~/   a  _  a   \~'  /
     \  `|     / \     |`  /
      `'--\    \_/    /--'`
          .'._  J__.-'.
         / /  '-/_ `-  \
        / -"-'-.  '-.__/
        \__,-.\/     | `\
        /  ;---.  .--'   |
       |     /\'-'      /
       '.___.\   _.--;'`)
              '-'     `"*/
coalaFunctionsInit = execVM "CoalaOs\CoalaOsFunctions.sqf";
coalaHandlerInit = execVM "CoalaOs\CoalaOsHandler.sqf";
coalaFileInit = execVM "CoalaOs\CoalaOsFileStructure.sqf";

waitUntil { scriptDone coalaFunctionsInit && scriptDone coalaHandlerInit && scriptDone coalaFileInit };

_laptop = "Land_Laptop_unfolded_F" createVehicle position player;
_laptop attachTo [player, [0, 0.8, 1.5] ];
_laptop setDir (180);
hideObject _laptop;

_ok = createDialog "MyDrink";
_CRLF = toString [0x0D, 0x0A];

_welcomeText = format["Coala OS [Version 1.34.483]%1Copyright (c) 2015 Legion Corporation. All rights reserved. jk.%1%1%2 ", _CRLF, coala_currentFolderName];
ctrlSetText [1400, _welcomeText];

waitUntil { (!dialog) or (!alive player) }; // hit ESC to close it 

if(!alive player) then
{
	closeDialog 2;
};

//kill remaining processes
{
	call compile format["call fncoala_stop%1", _x select 4];
}
foreach coala_ActivePrograms;

deleteVehicle _laptop;