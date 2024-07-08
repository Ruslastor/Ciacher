class_name Record
extends RefCounted

enum ZType{UP2, UP12}

var code : String
var serial_number : String
var type : ZType 
var soft_date : String
var valid_code : bool
var timestamp : String

func _init(code : String) -> void:
	var parsed_input : PackedStringArray = code.split('#')
	if len(parsed_input) < 8:
		valid_code = false
		return
	self.code = code
	self.serial_number = parsed_input[8]
	if int(parsed_input[4]) == 2:
		self.type = ZType.UP2
	else:
		self.type = ZType.UP12
	soft_date = parsed_input[7]
	self.timestamp = Time.get_time_string_from_system()
	valid_code = true


func exists_in_databases() -> String:
	for path in Config.DATABASES:
		var file = FileAccess.open(Config.DATABASES_DIRECTORY.path_join(path), FileAccess.READ)
		for line in file.get_as_text().split('\n'):
			if serial_number == line.get_slice('\t', 0):
				file.close()
				return path
		file.close()
	return ''

static func create_from_database_line(db_line : String) -> Record:
	print(db_line.split('\t'))
	var data : PackedStringArray = db_line.split('\t')#     serial_num     code      record_timestamp
	var rec : Record = Record.new(data[1])
	rec.timestamp = data[2]
	return rec

func is_valid() -> bool:
	return valid_code

func type_as_str() -> String:
	if type == ZType.UP2:
		return '2'
	return '12'

func get_arguments_for_flasher() -> PackedStringArray:
	if type == ZType.UP2:
		return ['-port=' + Config.PORT, '2', soft_date, serial_number]
	return ['-port=' + Config.PORT, '12', soft_date, serial_number]


func add_record_to_db(path : String) -> void:
	var file = FileAccess.open(Config.DATABASES_DIRECTORY.path_join(path), FileAccess.READ)
	var result : String = file.get_as_text()
	if result != '':
		result += '\n'
	file.close()
	file = FileAccess.open(Config.DATABASES_DIRECTORY.path_join(path), FileAccess.WRITE)
	file.store_string(result + serial_number+'\t'+code+'\t'+timestamp)
	file.close()

func delete_record_from_db(path : String) ->void:
	var file = FileAccess.open(Config.DATABASES_DIRECTORY.path_join(path), FileAccess.READ)
	var data : PackedStringArray = []
	for line in file.get_as_text().split('\n'):
		if line.get_slice('\t', 0) != serial_number:
			data.push_back(line)
	file.close()
	file = FileAccess.open(Config.DATABASES_DIRECTORY.path_join(path), FileAccess.WRITE)
	file.store_string('\n'.join(data))
	file.close()
	
	
