extends Node2D
class_name MemoryGame

@onready var child_array = $ColorOptions.get_children()
@onready var time_bar := $TimerBar
var color_num : int = 0
var solutions_array = []
var answers_count: int = 0
var sections_won: int = 0
var color_selected_array: Array[ColorBase] = []
var difficulty_scale: int = 0
var enum_reference := MiniGameReference.MINI_GAMES.MemoryGame
var game_timer_length: float = 3.5

#ideas on difficulty increase
# switch around the color squares every once in a while
# make things faster
# show more color options
# start from the end
# add more colors at a time
# etc

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.color_left_clicked.connect(_on_color_left_clicked)
	SignalBus.mini_game_ready.emit(enum_reference)
	$ColorOptions.visible = true
	time_bar.max_value = game_timer_length
	time_bar.value = game_timer_length
	difficulty_scale = get_difficulty_scale()
	manage_difficulty_scale()
	generate_color_options()
	
func _process(_delta: float) -> void:
	time_bar.value = $PuzzleTime.time_left

func generate_color_options():
	#choose 3 colors for the whole array - with 12 color options
	var color_array: Array = ColorFunctions.generate_random_colors((len(child_array)/4.0))
	# populate color array with the 3 color options
	for i in range(2):
		color_array.append_array(color_array.duplicate())
	color_array.shuffle()
	for child in child_array:
		child.set_new_color(color_array[0])
		hide_child(child)
		color_array.remove_at(0)
	$PuzzleTime.start(game_timer_length)


func show_puzzle():
	for child in child_array:
		child.set_covered(false)
		

func show_child(child):
	child.set_covered(false)


func hide_puzzle():
	for child in child_array:
		child.set_covered(true)
		
		
func hide_child(child):
	child.set_covered(true)
	

func _on_color_left_clicked(color_object_clicked: ColorBase, _color):
	if len(color_selected_array) <= 2:
		show_child(color_object_clicked)
		color_selected_array.append(color_object_clicked)
	
	if len(color_selected_array) >= 2:
		if ColorFunctions.do_colors_match_exact(color_selected_array[0].current_color, color_selected_array[1].current_color):
			$PuzzleTime.stop()
			#wait before it goes to the win screen or empties the array so they can see what happened
			$ShowColor.start()
			await $ShowColor.timeout
			#TODO: replace with player actually winning! Looks like they lose rn
			SignalBus.mini_game_won.emit(enum_reference)
		else:
			$ShowColor.start()
			await $ShowColor.timeout
			for child in color_selected_array:
				hide_child(child)
			color_selected_array = []
	
	
func get_difficulty_scale():
	return MiniGameReference.difficulty_scale[enum_reference]		


func manage_difficulty_scale():
	if difficulty_scale % 3 == 1:
		# animation "More!"
		# TODO: add dynamically added color circles
		pass
	elif difficulty_scale % 3 == 2:
		# animation "Faster!"
		game_timer_length -= 0.2
	else:
		# TODO: change amount of colors
		pass

func _on_puzzle_time_timeout() -> void:
	SignalBus.player_lost.emit()
