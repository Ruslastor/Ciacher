extends Label


func set_yesno(to : bool) -> void:
	if to:
		text = '✅'
	else:
		text = '⛔'
