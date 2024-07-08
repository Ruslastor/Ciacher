extends AcceptDialog

@onready var file_dialog : FileDialog = $FileDialog
@onready var path_file : LineEdit = $PanelContainer/VBoxContainer/HBoxContainer/path
@onready var scanningTime : LineEdit = $PanelContainer/VBoxContainer/HBoxContainer3/path

func _on_files_pressed():
	file_dialog.popup()



func _on_file_dialog_file_selected(path):
	path_file.text = path
	Config.PATH_TO_EXE = path



func _on_path_text_changed(new_text : String):
	if new_text.is_valid_float() and visible:
		Config.SCANNING_TIME_S = float(new_text)


func _on_about_to_popup():
	scanningTime.text = str(Config.SCANNING_TIME_S)
	path_file.text = Config.PATH_TO_EXE
