extends PanelContainer

@onready var recordTime : Label = $HBoxContainer/Time
@onready var serialNum : Label = $HBoxContainer/Id
@onready var softwareDate : Label = $HBoxContainer/SoftwhareDate

func set_data(record_timestamp : String, serial_num : String, soft_date : String) -> void:
	recordTime.text = record_timestamp
	serialNum.text = serial_num
	softwareDate.text = soft_date
