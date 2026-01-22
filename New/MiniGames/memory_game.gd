extends Node2D
class_name MemoryGame

@onready var child_array = $ColorOptions.get_children()
@onready var time_bar := $TimerBar
var color_num : int = 0
var solutions_array = []
var answers_count: int = 0
var sections_won: int = 0
var color_selected_array: Array[ColorBase] = []

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
	SignalBus.player_lost.connect(_on_player_lost)
	SignalBus.mini_game_section_won.connect(_on_mini_game_section_won)
	SignalBus.mini_game_ready.emit(MiniGameReference.MINI_GAMES.MemoryGame)
	$ColorOptions.visible = true
	$GameLost.visible = false
	time_bar.max_value = $PuzzleTime.wait_time
	time_bar.value = $PuzzleTime.wait_time
	generate_color_options()
	
func _process(_delta: float) -> void:
	time_bar.value = $PuzzleTime.time_left

func generate_color_options():
	#choose 3 colors for the whole array - with 12 color options
	var color_array = ColorFunctions.generate_random_colors((len(child_array)/4.0))
	# populate color array with the 3 color options
	for i in range(2):
		color_array.append_array(color_array.duplicate())
	color_array.shuffle()
	for child in child_array:
		child.set_new_color(color_array[0])
		hide_child(child)
		color_array.remove_at(0)
	$PuzzleTime.start()


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
			$GameLost/youLose.text = 'Yoiu Win!'
			_on_player_lost()
			SignalBus.mini_game_won.emit(MiniGameReference.MINI_GAMES.MemoryGame)
		else:
			$ShowColor.start()
			await $ShowColor.timeout
			for child in color_selected_array:
				hide_child(child)
			color_selected_array = []
			

func _on_player_lost():
	$GameLost.visible = true
	get_tree().paused = true
	
	
func _on_mini_game_section_won(game):
	if game == MiniGameReference.MINI_GAMES.MemoryGame:
		sections_won += 1
		if sections_won == 3:
			SignalBus.mini_game_won.emit(MiniGameReference.MINI_GAMES.MemoryGame)
			sections_won = 0
	

func _on_puzzle_time_timeout() -> void:
	_on_player_lost()
