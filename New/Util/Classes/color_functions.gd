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

static func generate_random_colors(amount: float):
	var color_array = []
	var ratio = 1.0/amount
	var hue = randf() # Random starting point each time
	var negative = randi_range(1,2)
	
	for i in range(amount):
		color_array.append(Color.from_hsv(
			(hue + randf_range(0.01,0.05)),
			randf_range(0.8, 0.95),
			randf_range(0.8, 0.95)
		))
		hue +=  ratio
	
	return color_array
