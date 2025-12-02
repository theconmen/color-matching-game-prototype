extends Node

var player_color: Color
var main_color: Color
const WIN_CON: float = 0.05
const WIN_CON_TESTER = 1

#Other Win Con ideas
# average distance to clor - current
# distance to most prominent color
# distance to most prominent color + average
# distance to most prominent color + relative distances for other colors


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.main_color_new_color.connect(_update_main_color)
	SignalBus.player_new_color.connect(_update_player_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_main_color(new_color: Color):
	main_color = new_color
	check_player_win_con()
	
func _update_player_color(new_color: Color):
	player_color = new_color
	check_player_win_con()
	
func check_player_win_con():
	# check different win cons
	# average distance win con
	if WIN_CON_TESTER == 1:
		var avg_color_difference = abs(((main_color.r - player_color.r) + (main_color.g - player_color.g) + (main_color.b - player_color.b))/3)
		if avg_color_difference <= WIN_CON:
			SignalBus.player_win_con_met.emit()
	# godot's is equal approx function
	if WIN_CON_TESTER == 2:
		if main_color.is_equal_approx(player_color):
			SignalBus.player_win_con_met.emit()
	#if WIN_CON_TESTER == 3:
		
		
		
