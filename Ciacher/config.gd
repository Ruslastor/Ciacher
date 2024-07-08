extends Node

var DATABASES_DIRECTORY : String = 'user://databases'
var PATH_TO_EXE : String = 'C:/Users/admin/Desktop/CLAR_reflashing_2023.06.22.exe'
var PORT : String = 'COM3'
var TYPE : int = 12

var SCANNING_TIME_S : float = 1

var SCANNED_ELEMENTT_LIST : PanelContainer

var CURRENT_DATABASE : String
func _ready():
	CURRENT_DATABASE = Time.get_date_string_from_system() + '.cdb'
	get_databases()


var DATABASES : PackedStringArray = []
func get_databases() -> void:
	DATABASES = []
	var dir = DirAccess.open('user://')
	if !dir.dir_exists('databases'):
		dir.make_dir('databases')
	dir.change_dir('user://databases')
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with('.cdb'):
				Config.DATABASES.append(file_name)
			file_name = dir.get_next()
	
	if !(CURRENT_DATABASE in Config.DATABASES):
		var file = FileAccess.open(DATABASES_DIRECTORY.path_join(CURRENT_DATABASE) , FileAccess.WRITE)
		file.close()
		DATABASES.append(CURRENT_DATABASE)


#-----------------------------------------------------
func single_to_double(a : String) -> String:
	if len(a) > 1:
		return a
	return '0'+a
