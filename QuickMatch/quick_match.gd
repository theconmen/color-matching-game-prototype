extends Node2D

#Game where you need to match a color to another color through an average color in between quickly
#Fail states: click wrong color, you lose. Take too long, you lose
#Win state: counter goes up when you get one correct
#3 second timer, 3 colors to choose from

#TODO what to do if the colors don't match - kind of a big problem with how I have things architected rn

@onready var main_screen = preload("uid://ci65qcv2o5v4a")
@onready var color_circle = preload('uid://do5fcpkunr1c8')
var counter: int = 0
var timer_text
var color_helper
@onready var circle_one := $StaticCircle
@onready var circle_two := $StaticCircle2
@onready var circle_three := $StaticCircle3
@onready var circle_array = [circle_one, circle_two, circle_three]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_win_con_met.connect(_on_player_win_con_met)
	SignalBus.exit_to_main_button_pressed.connect(_on_exit_to_main_menu_pressed)
	SignalBus.continue_game_button_pressed.connect(_on_continue_button_pressed)
	SignalBus.player_loss_con_met.connect(_on_player_loss_con_met)
	SignalBus.quick_match_puzzle_generated.connect(_get_rest_of_puzzle)
	generate_new_puzzle()


func _process(delta: float) -> void:
	if Input.is_action_pressed('esc'):
		open_pause_screen()
	
	timer_text = round($RoundTimer.time_left)
	$Counter.text = str("Your Score:", counter)
	$TimerLabel.text = str(timer_text)
	
	
func _on_player_win_con_met():
	counter += 1
	generate_new_puzzle()
	restart_timer()
	
	
func _on_player_loss_con_met():
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
	
	
func generate_new_puzzle():
	color_helper = QuickMatchPuzzleHelper.new()
	color_helper.generate_puzzle()
	
#has to go on signal to ensure everything is good
func _get_rest_of_puzzle():
	assign_player_color()
	assign_main_color()
	assign_circle_colors()
	
	
func assign_player_color():
	$PlayerColor.replace_and_set_new_color(color_helper.player_color)
	
	
func assign_main_color():
	$MainColor.set_color(color_helper.main_color)
	
#TODO: This is horrible coding design, need to fix how this works
func assign_circle_colors():
	var increment = 0
	for i in color_helper.all_colors_array:
		circle_array[increment].starting_color = i
		circle_array[increment].set_color()
		increment += 1


func restart_timer():
	$RoundTimer.start()
	

func _on_round_timer_timeout() -> void:
	SignalBus.player_loss_con_met.emit()
	
