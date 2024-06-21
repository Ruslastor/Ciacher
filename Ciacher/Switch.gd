extends PanelContainer

@onready var inv : ColorRect = $_/inv
@onready var vis : ColorRect = $_/vis

func _ready():
	vis.custom_minimum_size.x = size.x/2

var target_size : float = 0.0


var expanded  :bool =false


func _on_two_pressed():
	
	if expanded:
		target_size = 0.0
	else:
		target_size = size.x/2
	expanded = !expanded
	
	var tween : Tween = create_tween()
	tween.tween_property(inv, 'custom_minimum_size', Vector2(target_size, 0), 0.25)
	
