class_name PuzzleRaceColorHelper

var main_color: Color = Color(0,0,0,1)
var player_color: Color = Color(0.5,0.4,0.3,1)
var color_solutions := {"row 0": 0, "row 1": 0, "row 2": 0}
var color_decoys := {"row 0": 0, "row 1": 0, "row 2": 0}

# needs to call the other functions and
# return what the player value needs to be, what the main color needs to be,
# what the decoy colors should be
# what the solving colors should be
func generate_puzzle(rows=3):
	find_player_color()
	find_main_color(player_color)
	color_solutions = find_color_solutions()
	color_decoys = find_decoy_colors()


# figure out the x number of colors corresponding to x number of rows
func find_color_solutions():
	var needed_sum = Color(
		(main_color.r * 4) - player_color.r,
		(main_color.g * 4) - player_color.g,
		(main_color.b * 4) - player_color.b
	)
	
	# Generate the solution colors (same logic as before)
	#TODO: need to figure out a way to make this work for more rows later
	var color1 = Color(
		randf_range(0, needed_sum.r),
		randf_range(0, needed_sum.g),
		randf_range(0, needed_sum.b)
	)
	
	var color2 = Color(
		randf_range(0, needed_sum.r - color1.r),
		randf_range(0, needed_sum.g - color1.g),
		randf_range(0, needed_sum.b - color1.b)
	)
	
	var color3 = Color(
		needed_sum.r - color1.r - color2.r,
		needed_sum.g - color1.g - color2.g,
		needed_sum.b - color1.b - color2.b
	)
	
	var color_array = [color1, color2, color3]
	color_array.shuffle()
	
	
	for row in color_solutions:
		color_solutions[row] = color_array[0]
		color_array.pop_front()
	print(color_solutions)
	

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
	
	
# this logic could be improved to be a little more interesting and inclusive of colors
func find_main_color(player_color):
	main_color = Color(randf_range(0.15, 0.85),randf_range(0.15, 0.85),randf_range(0.15, 0.85))
