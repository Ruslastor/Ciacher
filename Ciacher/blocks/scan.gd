extends AcceptDialog

@onready var inpt : LineEdit = $scan/scanerInput
@onready var invalid : AcceptDialog = $Invalid
@onready var alreadyIn : ConfirmationDialog = $RevriteInDatabase
@onready var comportNotWorking : AcceptDialog = $ComportNotWorking

@onready var scenner : VBoxContainer = $scan
@onready var uploader : VBoxContainer = $uploader
@onready var upload_progress : ProgressBar = $uploader/progress


var started_flashing : bool=false


func _ready():
	get_ok_button().visible = false

var scaner_input_time_elapsed : float = 0
func _process(delta):
	if started_flashing:
		scaner_input_time_elapsed += delta
		if scaner_input_time_elapsed > Config.SCANNING_TIME_S:
			begin_flashing()
			scaner_input_time_elapsed = 0
			started_flashing = false
		
		
	if visible and inpt.text == '':
		inpt.grab_focus()




var serial_number : int
var type : int 
var date : String
var full_string : String
var already_in_database : String
var operating_database : String

func begin_flashing() -> void:
	operating_database = Config.get_name_for_today_database()
	full_string = inpt.text
	var parsed_input : PackedStringArray = full_string.split('#')
	
	print(parsed_input)
	print(Time.get_datetime_dict_from_system())
	
	if len(parsed_input) < 8:
		invalid.popup_centered()
		return
	
	serial_number = int(parsed_input[8])
	type = int(parsed_input[4])
	date = parsed_input[7]
	
	already_in_database = serial_number_already_in_databases(str(serial_number))
	if already_in_database != '':
		$RevriteInDatabase/PanelContainer/RichTextLabel.text = "The device you scanned is already in\n" + already_in_database + ". Do you want to continue?"
		alreadyIn.popup_centered()
		return
	
	flash()
	
	

func flash() -> void:
	var result = []
	var tween : Tween = create_tween()
	scenner.visible = false
	upload_progress.value = 0
	uploader.visible = true
	
	print(['-port=' + Config.PORT, str(type), date, str(serial_number)])
	
	tween.tween_property(upload_progress, "value", 20, 0.3)
	OS.execute(Config.PATH_TO_EXE, ['-port=' + Config.PORT, str(type), date, str(serial_number)], result)
	
	tween.tween_property(upload_progress, "value", 40, 0.3)
	if 'COM3 open failed' in result[0]:
		comportNotWorking.popup()
		return
	
	add_new_to_today_database()
	#database_list.append(Config.get_name_for_today_database()+'.cdb');


func serial_number_already_in_databases(serial_number : String) -> String:
	for path in Config.DATABASES:
		var file = FileAccess.open(Config.PATH_TO_DATABASES.path_join(path), FileAccess.READ)
		for line in file.get_as_text().split('\n'):
			if serial_number == line.get_slice('\t', 0):
				file.close()
				return path
		file.close()
	return ''

func clear_input():
	inpt.text = ''


func _on_scaner_input_text_changed(new_text):
	if new_text != '':
		started_flashing = true


func _on_revrite_in_database_confirmed():
	flash()
	delete_already_existing()
	


func add_new_to_today_database():
	var file = FileAccess.open(Config.PATH_TO_DATABASES.path_join(operating_database), FileAccess.READ)
	var dict : Dictionary = {}
	for i in file.get_as_text().split('\n'):
		dict[i.get_slice('\t', 0)] = i
	dict[str(serial_number)] = full_string
	file.close()
	file = FileAccess.open(Config.PATH_TO_DATABASES.path_join(operating_database), FileAccess.WRITE)
	file.store_string('\n'.join(dict.values()))
	file.close()


func delete_already_existing():
	var file = FileAccess.open(Config.PATH_TO_DATABASES.path_join(already_in_database), FileAccess.READ)
	var dict : Dictionary = {}
	for i in file.get_as_text().split('\n'):
		if i.get_slice('\t', 0) == str(serial_number):
			continue
		dict[i.get_slice('\t', 0)] = i
	file.close()
	file = FileAccess.open(Config.PATH_TO_DATABASES.path_join(already_in_database), FileAccess.WRITE)
	file.store_string('\n'.join(dict.values()))
	file.close()
