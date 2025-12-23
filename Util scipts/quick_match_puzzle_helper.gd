class_name QuickMatchPuzzleHelper

var player_color: Color
var main_color: Color
var solution_color: Color
var decoy_colors := []
var player_r_range: float
var player_g_range: float
var player_b_range: float

var all_colors_array := []

# Called when the node enters the scene tree for the first time.
func generate_puzzle():
	find_main_color()
	find_player_color()
	find_solution_color()
	find_decoy_colors()
	arrange_colors_array()
	SignalBus.quick_match_puzzle_generated.emit()
	
	#if check_puzzle():
		#SignalBus.quick_match_puzzle_generated.emit()
	#else:
		#decoy_colors = []
		#generate_puzzle()
	
func find_main_color():
	main_color = Color(randf_range(0.3, 0.7),randf_range(0.3, 0.7),randf_range(0.3, 0.7))

func find_player_color():
	if main_color.r <= 0.5:
		player_r_range = main_color.r
	elif main_color.r > 0.5:
		player_r_range = 1 - main_color.r
		
	if main_color.g <= 0.5:
		player_g_range = main_color.g
	elif main_color.g > 0.5:
		player_g_range = 1 - main_color.g
		
	if main_color.b <= 0.5:
		player_b_range = main_color.b
	elif main_color.b > 0.5:
		player_b_range = 1 - main_color.b
	
	var player_r_value = randf_range(main_color.r - player_r_range, main_color.r + player_r_range)
	var player_g_value = randf_range(main_color.g - player_g_range, main_color.g + player_g_range)
	var player_b_value = randf_range(main_color.b - player_b_range, main_color.b + player_b_range)
	
	player_color = Color(player_r_value, player_g_value, player_b_value)
	
func find_solution_color():
	solution_color = Color(
		(main_color.r * 2) - player_color.r,
		(main_color.g * 2) - player_color.g,
		(main_color.b * 2) - player_color.b,
	)
	
func find_decoy_colors():
	var color1 = Color(randf(), randf(), randf())
	var color2 = Color(randf(), randf(), randf())
	decoy_colors = [color1, color2]
	
	
func arrange_colors_array():
	all_colors_array = decoy_colors
	all_colors_array.append(solution_color)
	all_colors_array.shuffle()
	
	
#func check_puzzle(tolerance: float = 0.02) -> bool:
	#var result = average_colors(player_color, solution_color)
	#
	## Check if final result is close enough to main_color
	#var distance = color_distance(result, main_color)
	#
	#print("Solution validation:")
	#print("  Final result: ", result)
	#print("  Target (main): ", main_color)
	#print("  Distance: ", distance)
	#print("  Valid: ", distance < tolerance)
	#
	#return distance < tolerance
	#
#func average_colors(c1: Color, c2: Color) -> Color:
	#return Color(
		#(c1.r + c2.r) / 2,
		#(c1.g + c2.g) / 2,
		#(c1.b + c2.b) / 2
	#)
#
#func color_distance(c1: Color, c2: Color) -> float:
	#return abs(c1.r - c2.r) + abs(c1.g - c2.g) + abs(c1.b - c2.b)
