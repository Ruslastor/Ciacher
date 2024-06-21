extends AcceptDialog

@onready var file_dialog : FileDialog = $FileDialog
@onready var path_file : LineEdit = $PanelContainer/VBoxContainer/HBoxContainer/path


func _on_files_pressed():
	file_dialog.popup()



func _on_file_dialog_file_selected(path):
	path_file.text = path
	Config.PATH_TO_EXE = path

