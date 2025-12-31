extends Node2D

@onready var shader = $Sprite2D.material
var r: float
var g: float
var b: float
@export var current_color: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ColorTracker.current_game != ColorTracker.GAME.PuzzleRace and ColorTracker.current_game != ColorTracker.GAME.QuickMatch:
		set_random_color()
	SignalBus.color_circle_left_click.connect(_on_color_circle_left_click)
	SignalBus.color_circle_right_click.connect(_on_color_circle_right_click)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_random_color():
	r = randf_range(0,1)
	g = randf_range(0,1)
	b = randf_range(0,1)
	var color_set = Color(r,g,b,1)
	return color_set


func _on_color_circle_left_click(incoming_color : Color):
	match ColorTracker.current_game:
		ColorTracker.GAME.RandomMatch:
			average_and_set_new_color(incoming_color)
		ColorTracker.GAME.RGBRace:
			add_and_set_new_color(incoming_color)
		ColorTracker.GAME.PuzzleRace:
			average_and_set_new_color(incoming_color)
		ColorTracker.GAME.QuickMatch:
			average_and_set_new_color(incoming_color)
	
	
func _on_color_circle_right_click(incoming_color : Color):
	match ColorTracker.current_game:
		ColorTracker.GAME.RandomMatch:
			replace_and_set_new_color(incoming_color)
		ColorTracker.GAME.RGBRace:
			subtract_and_set_new_color(incoming_color)
		ColorTracker.GAME.PuzzleRace:
			average_and_set_new_color(incoming_color)
		ColorTracker.GAME.QuickMatch:
			average_and_set_new_color(incoming_color)


func average_and_set_new_color(color):
	var new_color: Color
	new_color.r = clamp((current_color.r + color.r)/2, 0, 1)
	new_color.g = clamp((current_color.g + color.g)/2, 0, 1)
	new_color.b = clamp((current_color.b + color.b)/2, 0, 1)
	set_color(new_color)
	print("player color:", new_color)
	
func replace_and_set_new_color(color):
	var new_color: Color
	new_color = color
	set_color(new_color)


func set_color(new_color: Color):
	shader.set_shader_parameter("override_color", new_color)
	current_color = new_color
	SignalBus.player_new_color.emit(current_color)
	
	
func set_random_color():
	var new_color = get_random_color()
	set_color(new_color)
	
func add_and_set_new_color(color):
	var new_color: Color
	new_color.r = clamp((current_color.r + color.r), 0, 1)
	new_color.g = clamp((current_color.g + color.g), 0, 1)
	new_color.b = clamp((current_color.b + color.b), 0, 1)
	set_color(new_color)
	
func subtract_and_set_new_color(color):
	var new_color: Color
	new_color.r = clamp((current_color.r - color.r), 0, 1)
	new_color.g = clamp((current_color.g - color.g), 0, 1)
	new_color.b = clamp((current_color.b - color.b), 0, 1)
	set_color(new_color)



	#new_color.r = clamp((current_color.r - color.r), 0, 1)
	#new_color.g = clamp((current_color.g - color.g), 0, 1)
	#new_color.b = clamp((current_color.b - color.b), 0, 1)
