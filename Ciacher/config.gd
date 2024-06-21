extends Node

var PATH_TO_DATABASES : String = 'user://databases'
var PATH_TO_EXE : String = 'C:/Users/admin/Desktop/CLAR_reflashing_2023.06.22.exe'
var PORT : String = 'COM3'
var TYPE : int = 12

var SCANNING_TIME_S : float = 1

var DATABASES : PackedStringArray = []

func get_name_for_today_database() -> String:
	var data : Dictionary = Time.get_datetime_dict_from_system()
	return str(data.year).erase(0, 2)+single_to_double(str(data.month))+single_to_double(str(data.day))

func single_to_double(a : String) -> String:
	if len(a) > 1:
		return a
	return '0'+a
