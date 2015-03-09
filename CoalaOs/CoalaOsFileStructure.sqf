coala_FileSystem = [["C:", 0, 0, [1,2, 17, 18, 19, 20], 1], 
					["Arma", 1, 0, [6,7,10,14,15,16], 1], 
					["Windows", 2, 0, [5,8,9], 1], 
					["image.jpg", 3, 0, [], 0, MISSION_ROOT + "CoalaOs\Images\617x.jpg", "image"], 
					["Image2.Jpeg", 4, 1, [], 0, MISSION_ROOT + "CoalaOs\Images\tank.jpg", "image"], 
					["SuperImportantFile.Jpeg", 5, 2, [], 0, MISSION_ROOT + "CoalaOs\Images\tank.jpg", "image"], 
					["Arma3.exe", 6, 1, [], 0, "", "exe"], 
					["Arma3.Jpeg", 7, 1, [], 0, MISSION_ROOT + "CoalaOs\Images\tank.jpg", "image"], 
					["Windows7.exe", 8, 2, [], 0, "", "exe"], 
					["Windows8.exe", 9, 2, [], 0, "", "exe"],
					["Addons", 10, 1, [11, 12, 13], 1],
					["JSRS.pbo", 11, 10, [], 0, "", "exe"],
					["TFR.pbo", 12, 10, [], 0, "", "exe"],
					["RHS.pbo", 13, 10, [], 0, "", "exe"],
					["video.mp4", 14, 2, [], 0, "\A3\Missions_F_EPA\video\A_in_intro.ogv", "video"],
					["video1.mp4", 15, 2, [], 0, "\A3\Missions_F_EPA\video\A_hub_quotation.ogv", "video"],
					["video2.mp4", 16, 2, [], 0, "\A3\Missions_F_EPA\video\A_in_quotation.ogv", "video"],
					["surveilence.exe", 17, 0, [], 0, "CoalaOs\Programs\CoalaOsSurveilence.sqf", "exe", "surveilence"],
					["frontcam.exe", 18, 0, [], 0, "CoalaOs\Programs\CoalaOsFrontcam.sqf", "exe", "frontcam"],
					["Bodycam.exe", 19, 0, [], 0, "CoalaOs\Programs\CoalaOsBodyCam.sqf", "exe", "bodycam"],
					["BlueforTracker.exe", 20, 0, [], 0, "CoalaOs\Programs\BlueforTracker.sqf", "exe", "bluefortracker"]];
					
coala_ActivePrograms = [];
coala_currentFolderId = 0;
coala_currentFolder = coala_FileSystem select coala_currentFolderId;
coala_currentFolderName = format["%1\", coala_currentFolder select coala_currentFolderId];

fncoala_addFolder = 
{
	//[FolderName, parentId] call fncoala_addFolder;
	_success = "Successfully created the folder.";
	
	_folderName = _this select 0;
	_parentId = _this select 1;
	if(count (toArray _folderName) > 0) then
	{
		_newId = count coala_FileSystem;
					// name      , id     , parent id, children, isfolder?
		_newFolder = [_folderName, _newId , _parentId, []      , 1];
		
		//beim parent einspeichern
		(coala_FileSystem select _parentId) set [count(coala_FileSystem select _parentId), _newId];
		coala_FileSystem set [count coala_FileSystem, _newFolder];
	}
	else
	{
		_success = "Could not create the folder: No name given";
	};
	_return = _success
};

fncoala_getSubFolders = 
{
	//[FolderId] call fncoala_getSubFolders
	_folderId = _this select 0;
	_subFolderIds = (coala_FileSystem select _folderId) select 3;
	_folders = [];
	
	{
		_curFolder = coala_FileSystem select _x;
		_folders set [count _folders, _curFolder];
	}forEach _subFolderIds;
	
	//hint str(_folders);
	_folders
};

fncoala_getSubFolderIdFromname = 
{
	//[subFolderName] call fncoala_getSubFolderIdFromname
	_subFolderName = _this select 0;
	_id = -1;
	if(count (toArray _subFolderName) > 0) then
	{
		_folders = [coala_currentFolderId] call fncoala_getSubFolders;
		{
			if(_x select 0 == _subFolderName) then
			{
				_didFind = true;
				_id = _x select 1;
			};
		}
		foreach _folders;
	};
	
	_id
};

fncoala_getCompleteFolderName = 
{
	//[folderId] call fncoala_getCompleteFolderName
	_folderId = _this select 0;
	_folder = coala_FileSystem select _folderId;
	_fullPath = _folder select 0;
	hint format["id: %1", _fullPath];
	while{_folder select 1 != _folder select 2} do
	{
		_parentFolder = coala_FileSystem select (_folder select 2);
		_fullPath = format["%2\%1", _fullPath, _parentFolder select 0];
		
		_folder = _parentFolder;
	};
	_fullPath
};

fncoala_getFileWithName = 
{
	//[fileName] call fncoala_getFileWithName;
	_fileName = _this select 0;
	_fileId = -1;
	_toFindFile = [];
	
	_allCurFiles = coala_currentFolder select 3;
	{
		_curFile = coala_FileSystem select _x;
		if((_curFile) select 0 == _fileName) then
		{
			_fileId = _curFile select 1;
			_toFindFile = _curFile;
		};
	}
	foreach _allCurFiles;
	
	_toFindFile
};









