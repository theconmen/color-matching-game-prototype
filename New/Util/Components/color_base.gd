extends AnimatableBody2D

class_name ColorBase
## used as the base for color changing or color clicking with other functionality to be added as components to this class

@export var current_color: Color
@export var clickable: bool = true
@onready var sprite_material = $Icon.material


func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if clickable:
		if event.is_action_pressed("left_click"):
			SignalBus.color_left_clicked.emit(self, current_color)
		elif event.is_action_pressed("right_click"):
			SignalBus.color_right_clicked.emit(self, current_color)
	else:
		pass


## takes new color in as argument, sets shader to new color, then sends out color changed signal containing itself, old color, and new color
func set_new_color(color: Color):
	var old_color = current_color
	current_color = color
	#$Icon.self_modulate = color
	sprite_material.set_shader_parameter("override_color", current_color)
	SignalBus.color_changed.emit(self, old_color, current_color)
	
