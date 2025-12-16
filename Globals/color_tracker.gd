extends Node

var player_color: Color
var main_color: Color
const WIN_CON: float = 0.05
enum GAME {RandomMatch, RGBRace, PuzzleRace, QuickMatch}
var current_game
var main_dominant_channel
var player_dominant_channel
enum WIN_CON_TYPE {avg, dominant_avg, exact_match}
var current_win_con_type = WIN_CON_TYPE.dominant_avg

#Other Win Con ideas
# average distance to clor - current
# distance to most prominent color
# distance to most prominent color + average
# distance to most prominent color + relative distances for other colors


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.main_color_new_color.connect(_update_main_color)
	SignalBus.player_new_color.connect(_update_player_color)
	SignalBus.random_match_game_selected.connect(set_game_to_random_match)
	SignalBus.RGB_race_game_selected.connect(set_game_to_rgb_race)
	SignalBus.puzzle_race_game_selected.connect(set_game_to_puzzle_race)
	SignalBus.quick_match_game_selected.connect(set_game_to_quick_match)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_main_color(new_color: Color):
	main_color = new_color
	main_dominant_channel = get_dominant_channel(main_color)
	print(str(main_color))
	check_player_win_con()
	
func _update_player_color(new_color: Color):
	player_color = new_color
	player_dominant_channel = get_dominant_channel(player_color)
	print(str(player_color))
	check_player_win_con()
	
func check_player_win_con():
	# check different win cons
	match current_game:
		GAME.RandomMatch:
			match current_win_con_type:
				WIN_CON_TYPE.avg:
					check_avg_win_con(main_color, player_color)
				WIN_CON_TYPE.dominant_avg:
					check_dominant_channel_avg_win_con(main_color, player_color)
		GAME.RGBRace:
			match current_win_con_type:
				WIN_CON_TYPE.avg:
					check_avg_win_con(main_color, player_color)
				WIN_CON_TYPE.dominant_avg:
					check_dominant_channel_avg_win_con(main_color, player_color)
		GAME.PuzzleRace:
			check_exact_color_win_con(main_color, player_color)
		GAME.QuickMatch:
			check_exact_color_win_con(main_color, player_color)
		
		
func set_game_to_random_match():
	current_game = GAME.RandomMatch
	
func set_game_to_rgb_race():
	current_game= GAME.RGBRace

func set_game_to_puzzle_race():
	current_game = GAME.PuzzleRace
	
func set_game_to_quick_match():
	current_game = GAME.PuzzleRace
		

func get_dominant_channel(color: Color) -> String:
	var max_value = max(color.r, max(color.g, color.b))
	if color.r == max_value:
		return "Red"
	elif color.g == max_value:
		return "Green"
	else:
		return "Blue"
		
		
func check_avg_win_con(main: Color, player: Color):
	var avg_color_difference = abs(((main.r - player.r) + (main.g - player.g) + (main.b - player.b))/3)
	if avg_color_difference <= WIN_CON:
			SignalBus.player_win_con_met.emit()
			
			
func check_dominant_channel_avg_win_con(main: Color, player: Color):
	if main_dominant_channel == player_dominant_channel:
		if main_dominant_channel == 'Red':
			if abs(main.r - player.r) <= WIN_CON:
				SignalBus.player_win_con_met.emit()
		elif main_dominant_channel == 'Green':
			if abs(main.g - player.g) <= WIN_CON:
				SignalBus.player_win_con_met.emit()
		elif main_dominant_channel == 'Blue':
			if abs(main.b - player.b) <= WIN_CON:
				SignalBus.player_win_con_met.emit()
	else:
		pass
		
		
func check_exact_color_win_con(main: Color, player: Color):
	if main == player:
		SignalBus.player_win_con_met.emit()
		
