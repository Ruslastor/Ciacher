extends AcceptDialog

@onready var inpt : LineEdit = $scan/scanerInput
@onready var invalid : AcceptDialog = $Invalid
@onready var alreadyIn : ConfirmationDialog = $RevriteInDatabase
@onready var alreadyInText : Label = $RevriteInDatabase/PanelContainer/RichTextLabel
@onready var comportNotWorking : AcceptDialog = $ComportNotWorking

@onready var flashButon : Button = $scan/FLASH

@onready var scenner : VBoxContainer = $scan
@onready var uploader : VBoxContainer = $uploader
@onready var upload_progress : ProgressBar = $uploader/_2/_/progress

@onready var infoSDate :Label = $scan/parser/_/_4/_2/SoftDate
@onready var infoType :Label = $scan/parser/_/_4/_2/Type
@onready var infoSNum :Label = $scan/parser/_/_4/_2/SerialNumber

@onready var statusIndicator : Label = $uploader/_2/_/YesNo

@onready var parserSpace : CenterContainer = $scan/parser

var started_flashing : bool=false



var scaner_input_time_elapsed : float = 0
func _process(delta):
	if started_flashing:
		scaner_input_time_elapsed += delta
		if scaner_input_time_elapsed > Config.SCANNING_TIME_S:
			begin_flashing()
			
			scaner_input_time_elapsed = 0
			started_flashing = false
		
		
	if scenner.visible and inpt.text == '':
		inpt.grab_focus()




var flashing_record : Record
var flashing_record_containing_db : String
func begin_flashing() -> void:
	flashing_record = Record.new(inpt.text)
	if !flashing_record.is_valid():
		invalid.popup_centered()
		return
	
	infoSDate.text = flashing_record.soft_date
	infoSNum.text = flashing_record.serial_number
	infoType.text = flashing_record.type_as_str()
	parserSpace.visible = true
	
	flashing_record_containing_db = flashing_record.exists_in_databases()
	if flashing_record_containing_db != '':
		alreadyInText.text = 'The number you entered was already flashed on ' + flashing_record_containing_db + ',\n do you want to continue?'
		alreadyIn.popup_centered()
		return
	flashButon.visible = true
	

	
func flash() -> void:
	open_progress()
	var tween : Tween = create_tween()
	var result = []
	tween.tween_property(upload_progress, "value", 60, 3)
	
	OS.execute(Config.PATH_TO_EXE, flashing_record.get_arguments_for_flasher(), result)
	
	#if 'COM3 open failed' in result[0]:
	#	comportNotWorking.popup()
	#	return
	
	flashing_record.add_record_to_db(Config.CURRENT_DATABASE)
	tween.connect('finished', Callable(finished))
	tween.tween_property(upload_progress, "value", 100, 0.3)
	
	Config.SCANNED_ELEMENTT_LIST.use_database(Config.CURRENT_DATABASE)

func finished() -> void:
	statusIndicator.set_yesno(true)

func _on_revrite_in_database_confirmed():
	flashing_record.delete_record_from_db(flashing_record_containing_db)
	inpt.text = ''
	flash()#†

func open_progress() -> void:
	scenner.visible = false
	upload_progress.value = 0
	uploader.visible = true
	size = Vector2.ZERO
	statusIndicator.set_loading()

func _on_scaner_input_text_changed(new_text):
	if new_text != '':
		started_flashing = true



func _on_about_to_popup():
	scenner.visible = true
	upload_progress.value = 0
	uploader.visible = false
	inpt.text = ''
	parserSpace.visible = false
	statusIndicator.set_loading()
	get_ok_button().visible = false
	flashButon.visible = false
	size = Vector2.ZERO

func _on_flash_pressed():
	flash()#†
