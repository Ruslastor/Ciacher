extends PanelContainer


const list_element : PackedScene = preload("res://blocks/scanned_list_element.tscn")
@onready var constainer : VBoxContainer = $_/_/_/_/list
@onready var database_option : OptionButton = $_/_2/_2/daySelect
@onready var info_lael : Label = $_/_3/_/Info
@onready var title : HBoxContainer = $_/_/_/_2/title

func _ready():
	Config.SCANNED_ELEMENTT_LIST = self
	display_databases()
	use_database(Config.CURRENT_DATABASE)

func display_databases() -> void:
	for i in database_option.item_count:
		database_option.remove_item(i)
	database_option.add_item('Select List📜')
	database_option.add_separator()
	for i in Config.DATABASES:
		database_option.add_item(i)

func use_database(db_name : String) -> void:
	for i in constainer.get_children():
		i.queue_free()
		
	var file = FileAccess.open(Config.DATABASES_DIRECTORY.path_join(db_name), FileAccess.READ)
	var records : PackedStringArray = file.get_as_text().split('\n')
	if records[0] == '':
		title.visible = false
		info_lael.visible = false
		return
	for record in records:
		if record == '':
			continue
		var new_record_displayer : PanelContainer = list_element.instantiate()
		#record_timestamp     serial_num     soft_date
		constainer.add_child(new_record_displayer)
		new_record_displayer.set_data(Record.create_from_database_line(record))
	title.visible = true
	info_lael.visible = true
	info_lael.text = 'Total amount: ' + str(len(records))


func _on_day_select_item_selected(index):
	use_database(database_option.get_item_text(index))



