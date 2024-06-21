extends Control


@onready var scanner_menue : AcceptDialog = $Scan
@onready var beginButton : Button = $HBoxContainer/VBoxContainer/_/_/start_menue/begin

func _ready():
	print(Time.get_datetime_string_from_system())

func _process(delta):
	beginButton.disabled = Config.PORT == ''

func _on_begin_pressed():
	scanner_menue.popup_centered()

