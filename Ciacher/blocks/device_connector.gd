extends PanelContainer

@onready var connectionStatus : Label = $VBoxContainer/_/status
@onready var deviceStatus : Label = $VBoxContainer/_/YesNo
@onready var settingsTab : AcceptDialog = $SettingsTab

func _ready():
	var devices : Dictionary = get_connected_devices()
	for port in devices:
		if devices[port] == 'idk the name':
			connectionStatus.text = 'Device is connected! 📥'
			deviceStatus.set_yesno(true)
			Config.PORT = port
			return
	connectionStatus.text = 'Device is not connected!'
	deviceStatus.set_yesno(false)
	Config.PORT = 'COM3'
	
func get_connected_devices() -> Dictionary:
	var result = []
	var output : Dictionary = {}
	
	OS.execute('powershell', ['-Command','"Get-WmiObject Win32_SerialPort | Select-Object DeviceID,Description"'], result)

	for i in result[0].split("\r\n").slice(3):
		var pare : PackedStringArray = i.split('     ')
		if len(pare) > 1:
			output[pare[0]] = pare[1]
	return output


func _on_open_settings_pressed():
	settingsTab.popup_centered()
