extends Control

@onready var shader = $Sprite2D.material
var starting_color: Color
# used in the additinoal subtraction logic and sent in the signal when clicked
var current_color: Color = Color(1,1,1,1)
var color_label: String
var solution_label: String

func _ready() -> void:
	#shader.setup_local_to_scene()
	set_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Label.text = solution_label
	pass


# emit signal based on click-type that happened
func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#print("click area signal sent")
	if event.is_action_pressed("left_click"):
		match ColorTracker.current_game:
			ColorTracker.GAME.RGBRace:
				if color_label == 'Red':
					var send_color = Color(0.05,0,0)
					SignalBus.color_circle_left_click.emit(send_color)
				elif color_label == 'Green':
					var send_color = Color(0,0.05,0)
					SignalBus.color_circle_left_click.emit(send_color)
				elif color_label == 'Blue':
					var send_color = Color(0,0,0.05)
					SignalBus.color_circle_left_click.emit(send_color)
				else:
					print("I shouldn't be here...")
			ColorTracker.GAME.PuzzleRace:
				SignalBus.color_circle_left_click.emit(current_color)
	#subtracting isn't working!
	if event.is_action_pressed("right_click"):
		match ColorTracker.current_game:
			ColorTracker.GAME.RGBRace:
				if color_label == 'Red':
					var send_color = Color(0.05,0,0)
					SignalBus.color_circle_right_click.emit(send_color)
				elif color_label == 'Green':
					var send_color = Color(0,0.05,0)
					SignalBus.color_circle_right_click.emit(send_color)
				elif color_label == 'Blue':
					var send_color = Color(0,0,0.05)
					SignalBus.color_circle_right_click.emit(send_color)
				else:
					print("I shouldn't be here...")
			ColorTracker.GAME.PuzzleRace:
				SignalBus.color_circle_left_click.emit(current_color)

# set the color of the shader and update the current_color var
func set_color():
	shader.set_shader_parameter("override_color", starting_color)
	current_color = starting_color
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
