extends Node2D

@onready var main_screen = preload("uid://ci65qcv2o5v4a")
@onready var Row_one = $Row1
@onready var Row_two = $Row2
@onready var Row_three = $Row3
var increment_counter: int
var color_helper

@onready var color_circle = preload('uid://do5fcpkunr1c8')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_win_con_met.connect(_on_player_win_con_met)
	SignalBus.exit_to_main_button_pressed.connect(_on_exit_to_main_menu_pressed)
	SignalBus.continue_game_button_pressed.connect(_on_continue_button_pressed)
	SignalBus.valid_puzzle_found.connect(create_puzzle)
		
	color_helper = PuzzleRaceColorHelper.new()
	color_helper.generate_puzzle()
	

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
	
# get colors from the color helper
# randomly assign one to each row	
func assign_colors():
	increment_counter = 0
	for row in color_helper.final_color_dict:
		increment_counter += 1
		for i in color_helper.final_color_dict[row]:
			# create new color circle and assign it the new color
			var new_color_circle = color_circle.instantiate()
			new_color_circle.starting_color = i
			
			if i in color_helper.color_solutions.values():
				new_color_circle.solution_label = 'Solution'
			else:
				new_color_circle.solution_label = 'Decoy'
				
			# assign to correct row
			if increment_counter == 1:
				Row_one.add_child(new_color_circle)
			elif increment_counter == 2:
				Row_two.add_child(new_color_circle)
			else:
				Row_three.add_child(new_color_circle)
				
# make the player color the correct color
func assign_player_color():
	$PlayerColor.replace_and_set_new_color(color_helper.player_color)
	
	
# assign the main color from color helper
func assign_main_color():
	$MainColor.set_color(color_helper.main_color)
	

func create_puzzle():
	assign_colors()
	assign_main_color()
	assign_player_color()
	
	
func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
