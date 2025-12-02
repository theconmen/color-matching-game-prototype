extends Node2D

@onready var shader = $Icon.material
@export var r: float
@export var g: float
@export var b: float
@export var current_color : Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_random_color()
	shader.set_shader_parameter("override_color", Color(r,g,b,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_random_color():
	r = randf_range(0,1)
	g = randf_range(0,1)
	b = randf_range(0,1)
	current_color = Color(r,g,b,1)
	SignalBus.main_color_new_color.emit(current_color)
