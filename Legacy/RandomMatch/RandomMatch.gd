extends Node2D

@onready var color_circle = preload("uid://coelioq7h5jva")
@onready var main_screen = preload("uid://ci65qcv2o5v4a")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_win_con_met.connect(_on_player_win_con_met)
	SignalBus.exit_to_main_button_pressed.connect(_on_exit_to_main_menu_pressed)
	SignalBus.continue_game_button_pressed.connect(_on_continue_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed('esc'):
		open_pause_screen()


func _on_color_spawn_timeout() -> void:
	spawn_color_circle()
	
# Code to spawn the color circles
func spawn_color_circle():
	var new_color_circle = color_circle.instantiate()
	var result = set_color_circle_position_rotation()
	new_color_circle.position = result[0]
	new_color_circle.rotation = result[1]
	new_color_circle.linear_velocity = Vector2(randf_range(150.0, 250.0), 0.0).rotated(result[1])
	add_child(new_color_circle)
	
func set_color_circle_position_rotation():
	var circle_spawn_location = $SpawnPath/ColorSpawnPath
	circle_spawn_location.progress_ratio = randf()
	var direction = circle_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	return [circle_spawn_location.position, direction]


func _on_player_win_con_met():
	$WinScreen.visible = true
	get_tree().paused = true
	
func _on_exit_to_main_menu_pressed():
	$WinScreen.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_screen)
	
func open_pause_screen():
	$WinScreen.visible = true
	$WinScreen/Continue.visible = true
	get_tree().paused = true
	
func _on_continue_button_pressed():
	$WinScreen.visible = false
	$WinScreen/Continue.visible = false
	get_tree().paused = false
	
	
