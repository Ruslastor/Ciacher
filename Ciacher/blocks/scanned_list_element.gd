extends PanelContainer

@onready var recordTime : Label = $HBoxContainer/Time
@onready var serialNum : Label = $HBoxContainer/Id
@onready var softwareDate : Label = $HBoxContainer/SoftwhareDate
@onready var typeLabel : Label = $HBoxContainer/Type

func set_data(record : Record) -> void:
	recordTime.text = record.timestamp
	serialNum.text = str(record.serial_number)
	softwareDate.text = record.soft_date
	typeLabel.text = record.type_as_str()
