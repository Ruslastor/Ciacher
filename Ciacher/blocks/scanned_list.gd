extends PanelContainer


const list_element : PackedScene = preload("res://blocks/scanned_list_element.tscn")
@onready var constainer : VBoxContainer = $_/_/_/_/list
@onready var database_option : OptionButton = $_/_2/daySelect
@onready var info_lael : Label = $_/HBoxContainer/Info
@onready var title : HBoxContainer = $_/_/_/title



func _ready():
	get_database_list()
	display_databases()
	

func display_databases() -> void:
	for i in database_option.item_count:
		database_option.remove_item(i)
	for i in Config.DATABASES:
		database_option.add_item(i)

func get_database_list() -> void:
	Config.DATABASES = []
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
	
	if !(Config.get_name_for_today_database() in Config.DATABASES):
		var file = FileAccess.open(Config.PATH_TO_DATABASES.path_join(Config.get_name_for_today_database())+'.cdb' , FileAccess.WRITE)
		file.close()
		Config.DATABASES.append(Config.get_name_for_today_database()+'.cdb');
		
func use_database(db_name : String) -> void:
	var file = FileAccess.open(Config.PATH_TO_DATABASES.path_join(db_name), FileAccess.READ)
	var records : PackedStringArray = file.get_as_text().split('\n')
	if records[0] == '':
		title.visible = false
		info_lael.visible = false
		return
	for record in records:
		var new_record : PanelContainer = list_element.instantiate()
		constainer.add_child(new_record)
		var data : PackedStringArray = record.split('\t')
		
		#record_timestamp : String, serial_num : String, soft_date : String, user_verified : String
		
		new_record.set_data(get_pretty_datetime_string(data[1]), data[0], data[2].get_slice("#", 7))
	
	title.visible = true
	info_lael.visible = true
	info_lael.text = 'Total amount: ' + str(len(records))


func get_pretty_datetime_string(time_string : String):
	var date_time : PackedStringArray = time_string.split("T")
	var date : PackedStringArray = date_time[0].split('-')
	var result : String = date[2]+' '
	
	match date[1]:
		'01':
			result += 'Jan' 
		'02':
			result += 'Feb' 
		'03':
			result += 'Mar' 
		'04':
			result += 'Apr' 
		'05':
			result += 'May' 
		'06':
			result += 'Jun' 
		'07':
			result += 'Jul' 
		'08':
			result += 'Aug' 
		'09':
			result += 'Sep' 
		'10':
			result += 'Oct' 
		'11':
			result += 'Nov' 
		'12':
			result += 'Dec' 
	
	result += " " + date[0] + " at " + date_time[1].erase(5, 3)
	return result

func _on_day_select_item_selected(index):
	for i in constainer.get_children():
		i.queue_free()
	use_database(database_option.get_item_text(index))



