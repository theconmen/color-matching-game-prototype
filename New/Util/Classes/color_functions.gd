class_name ColorFunctions

static func do_colors_match_simple(color_one: Color, color_two: Color, tolerance: float = 0.03) -> bool:
	if abs(color_one.r - color_two.r) < tolerance and abs(color_one.g - color_two.g) < tolerance and abs(color_one.b - color_two.b) < tolerance:
		return true
	else:
		return false
		
static func do_colors_match_dominant(color_one: Color, color_two: Color, dominant_tolerance: float = 0.02, other_tolerance: float = 0.1) -> bool:
	var color_one_dominant_channel = get_dominant_color(color_one)
	var color_two_dominant_channel = get_dominant_color(color_two)
	if color_one_dominant_channel == color_two_dominant_channel:
		if color_one_dominant_channel == 'Red':
			if abs(color_one.r - color_two.r) <= dominant_tolerance and abs(color_one.g - color_two.g) <= other_tolerance and abs(color_one.b - color_two.b) <= other_tolerance:
				return true
			else:
				return false
		elif color_one_dominant_channel =='Green':
			if abs(color_one.r - color_two.r) <= other_tolerance and abs(color_one.g - color_two.g) <= dominant_tolerance and abs(color_one.b - color_two.b) <= other_tolerance:
				return true
			else:
				return false
		elif color_one_dominant_channel =='Blue':
			if abs(color_one.r - color_two.r) <= other_tolerance and abs(color_one.g - color_two.g) <= other_tolerance and abs(color_one.b - color_two.b) <= dominant_tolerance:
				return true
			else:
				return false
		else:
			print("Incorrect color given")
			return false
	else:
		return false

static func get_dominant_color(color):
	var max_value = max(color.r, max(color.g, color.b))
	if color.r == max_value:
		return "Red"
	elif color.g == max_value:
		return "Green"
	else:
		return "Blue"
		
		
static func do_colors_match_exact(color_one: Color, color_two: Color) -> bool:
	return color_one.is_equal_approx(color_two)


static func generate_random_colors(amount: int):
	var color_array = []
	var color: Color
	for i in range(amount):
		color = generate_random_color()
		color_array.append(color)
	return color_array

static func generate_random_color():
	return Color(randf(), randf(), randf())
	
	
static func 
