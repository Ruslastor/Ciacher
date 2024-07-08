extends Label


func set_yesno(to : bool) -> void:
	if to:
		text = '✅'
	else:
		text = '⛔'

func set_loading() -> void:
	text = '🔄'
