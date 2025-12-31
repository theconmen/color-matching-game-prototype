extends Node2D

@onready var shader = $Sprite2D.material
var r: float
var g: float
var b: float
# used in the additinoal subtraction logic and sent in the signal when clicked
var current_color: Color

func _ready() -> void:
	#shader.setup_local_to_scene()
	get_random_color()
	set_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_random_color():
	r = randf_range(0,1)
	g = randf_range(0,1)
	b = randf_range(0,1)

# emit signal based on click-type that happened
func _on_click_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#print("click area signal sent")
	if event.is_action_pressed("left_click"):
		SignalBus.color_circle_left_click.emit(current_color)
		queue_free()
	if event.is_action_pressed("right_click"):
		SignalBus.color_circle_right_click.emit(current_color)
		queue_free()

# set the color of the shader and update the current_color var
func set_color():
	shader.set_shader_parameter("override_color", Color(r,g,b,1))
	current_color = Color(r,g,b,1)
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
