class_name PuzzleRaceColorHelper

var main_color: Color = Color(0,0,0,1)
var player_color: Color = Color(0.5,0.4,0.3,1)
var color_solutions := {"row 0": 0, "row 1": 0, "row 2": 0}
var color_decoys := {"row 0": [], "row 1": [], "row 2": []}
var final_color_dict := {"row 0": [], "row 1": [], "row 2": []}

# needs to call the other functions and
# return what the player value needs to be, what the main color needs to be,
# what the decoy colors should be
# what the solving colors should be
func generate_puzzle(rows=3):
	find_player_color()
	find_main_color(player_color)
	find_color_solutions()
	
	if not is_solution_valid():
		print("Solution invalid, regenerating...")
		color_solutions = {"row 0": 0, "row 1": 0, "row 2": 0}
		color_decoys = {"row 0": [], "row 1": [], "row 2": []}
		final_color_dict = {"row 0": [], "row 1": [], "row 2": []}
		generate_puzzle()
		return
	else:	
		find_decoy_colors()
		organize_final_color_dict()
		SignalBus.valid_puzzle_found.emit()
		print(final_color_dict)

#
# figure out the x number of decoy colors corresponding to 2x where x is number of rows
func find_decoy_colors():
	for row in color_decoys:
		var color1 = Color(randf(), randf(), randf())
		var color2 = Color(randf(), randf(), randf())
		color_decoys[row] = [color1, color2]
	print(color_decoys)
	

# figure out what the player color should be, should be able to be any value basically
func find_player_color():
	player_color = Color(randf(), randf(), randf())
	
	
func find_color_solutions():
	# Work backwards from target, picking random intermediate averages
	
	# Pick a random second_avg (the color after mixing first two colors)
	# It should be somewhere between player_color and main_color
	var second_avg = Color(
		lerp(player_color.r, main_color.r, randf_range(0.3, 0.7)),
		lerp(player_color.g, main_color.g, randf_range(0.3, 0.7)),
		lerp(player_color.b, main_color.b, randf_range(0.3, 0.7))
	)
	
	# Calculate color3 needed to get from second_avg to main_color
	# avg(second_avg + color3) = main_color
	# color3 = (main_color * 2) - second_avg
	var color3 = Color(
		(main_color.r * 2) - second_avg.r,
		(main_color.g * 2) - second_avg.g,
		(main_color.b * 2) - second_avg.b
	)
	
	# Pick a random first_avg (the color after mixing just the first color)
	# It should be somewhere between player_color and second_avg
	var first_avg = Color(
		lerp(player_color.r, second_avg.r, randf_range(0.3, 0.7)),
		lerp(player_color.g, second_avg.g, randf_range(0.3, 0.7)),
		lerp(player_color.b, second_avg.b, randf_range(0.3, 0.7))
	)
	
	# Calculate color2 needed to get from first_avg to second_avg
	# avg(first_avg + color2) = second_avg
	# color2 = (second_avg * 2) - first_avg
	var color2 = Color(
		(second_avg.r * 2) - first_avg.r,
		(second_avg.g * 2) - first_avg.g,
		(second_avg.b * 2) - first_avg.b
	)
	
	# Calculate color1 needed to get from player_color to first_avg
	# avg(player_color + color1) = first_avg
	# color1 = (first_avg * 2) - player_color
	var color1 = Color(
		(first_avg.r * 2) - player_color.r,
		(first_avg.g * 2) - player_color.g,
		(first_avg.b * 2) - player_color.b
	)
	
	# Clamp all colors to valid range [0, 1]
	color1 = clamp_color(color1)
	color2 = clamp_color(color2)
	color3 = clamp_color(color3)
	
	# Shuffle and assign to rows
	var color_array = [color1, color2, color3]
	color_array.shuffle()
	
	for row in color_solutions:
		color_solutions[row] = color_array[0]
		color_array.pop_front()
	
	print(color_solutions)

# Helper function to clamp color values
func clamp_color(color: Color) -> Color:
	return Color(
		clamp(color.r, 0, 1),
		clamp(color.g, 0, 1),
		clamp(color.b, 0, 1)
	)
	
# this logic could be improved to be a little more interesting and inclusive of colors
func find_main_color(player_color):
	main_color = Color(randf_range(0.15, 0.85),randf_range(0.15, 0.85),randf_range(0.15, 0.85))
	

# get the color decoys and the puzzle solutions into a randomized dict that will be used in the puzzle race main scene
# TODO: change this so that the the arrays are in dict form so it's easy to tell what the solution should be
func organize_final_color_dict():
	for row in final_color_dict:
		var color_array = color_decoys[row]
		color_array.append(color_solutions[row])
		color_array.shuffle()
		final_color_dict[row] = color_array
		
		
func is_solution_valid(tolerance: float = 0.02) -> bool:
	# Start with player color and sequentially average with each solution color
	var result = player_color
	
	# Average with each color in order (row 0, row 1, row 2)
	for i in range(color_solutions.size()):
		var row_key = "row " + str(i)
		var color = color_solutions[row_key]
		result = average_colors(result, color)
	
	# Check if final result is close enough to main_color
	var distance = color_distance(result, main_color)
	
	print("Solution validation:")
	print("  Final result: ", result)
	print("  Target (main): ", main_color)
	print("  Distance: ", distance)
	print("  Valid: ", distance < tolerance)
	
	return distance < tolerance

func average_colors(c1: Color, c2: Color) -> Color:
	return Color(
		(c1.r + c2.r) / 2,
		(c1.g + c2.g) / 2,
		(c1.b + c2.b) / 2
	)

func color_distance(c1: Color, c2: Color) -> float:
	return abs(c1.r - c2.r) + abs(c1.g - c2.g) + abs(c1.b - c2.b)
