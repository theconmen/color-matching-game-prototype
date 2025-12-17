extends Node2D

@onready var main_screen = preload("uid://ci65qcv2o5v4a")
@onready var Row_one = $Row1
@onready var Row_two = $Row2
@onready var Row_three = $Row3

@onready var color_circle = preload('uid://do5fcpkunr1c8')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_win_con_met.connect(_on_player_win_con_met)
	SignalBus.exit_to_main_button_pressed.connect(_on_exit_to_main_menu_pressed)
	SignalBus.continue_game_button_pressed.connect(_on_continue_button_pressed)
	
	for i in range(3):
		var new_color_circle = color_circle.instantiate()
		new_color_circle.starting_color = Color((i*.3),0,0,1)
		Row_one.add_child(new_color_circle)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed('esc'):
		open_pause_screen()


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
