extends Node2D

@onready var shader = $Icon.material
@export var r: float = 0
@export var g: float = 0
@export var b: float = 0
@export var current_color : Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ColorTracker.current_game != ColorTracker.GAME.PuzzleRace:
		set_random_color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_random_color():
	r = randf_range(0,1)
	g = randf_range(0,1)
	b = randf_range(0,1)
	print(r)
	print(g)
	print(b)
	set_color()
	
func set_color():
	if ColorTracker.current_game != ColorTracker.GAME.PuzzleRace:
		current_color = Color(r,g,b,1)
		shader.set_shader_parameter("override_color", current_color)
		SignalBus.main_color_new_color.emit(current_color)
	else:
		shader.set_shader_parameter("override_color", current_color)
		SignalBus.main_color_new_color.emit(current_color)
