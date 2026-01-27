extends Node2D
class_name ShortSimonSays

@onready var child_array = $ColorOptions.get_children()
@onready var time_bar = $ProgressBar
var color_num : int = 0
var solutions_array = []
var answers_count: int = 0
var sections_won: int = 0
var difficulty_scale: int = 0
var enum_reference := MiniGameReference.MINI_GAMES.ShortSimonSays
var game_timer_length: float = 2

#ideas on difficulty increase
# make things faster
# show more color options
# etc

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.color_left_clicked.connect(_on_color_left_clicked)
	SignalBus.mini_game_section_won.connect(_on_mini_game_section_won)
	SignalBus.mini_game_ready.emit(MiniGameReference.MINI_GAMES.ShortSimonSays)
	$ColorOptions.visible = false
	$SimonColor.set_new_color(Color(0.0, 0.0, 0.0))
	time_bar.max_value = game_timer_length
	time_bar.value = game_timer_length
	difficulty_scale = get_difficulty_scale()
	manage_difficulty_scale()
	generate_color_options()
	start()
	

func _process(_delta: float) -> void:
	time_bar.value = $PuzzleTimer.time_left


func generate_color_options():
	var color_array = ColorFunctions.generate_random_colors(len(child_array))
	for child in child_array:
		child.set_new_color(color_array[0])
		color_array.remove_at(0)
	
	
func pick_next_simon_color(amount: int = 1):
	for i in range(amount):
		solutions_array = []
		solutions_array.append(child_array.pick_random())
	

func start():
	hide_puzzle()
	# difficulty scaler could become a var to put into the "pick next simon color"
	generate_color_options()
	pick_next_simon_color()
	for solution in solutions_array:
		$SimonColor.set_new_color(solution.current_color)
		$ShowColor.start()
		await $ShowColor.timeout
	show_puzzle()

func show_puzzle():
	$ColorOptions.visible = true
	$SimonColor.visible = false
	$PuzzleTimer.start(game_timer_length)

func _on_color_left_clicked(answer, _color):
	if answer == solutions_array[answers_count]:
		#will be some "correct" thingy but for now nothing
		pass
	else:
		SignalBus.player_lost.emit()
	answers_count += 1
	
	# they beat the mini game if the amount of times they answered is more than the amount of solutinos there are
	if answers_count >= len(solutions_array):
		answers_count = 0
		SignalBus.mini_game_section_won.emit(MiniGameReference.MINI_GAMES.ShortSimonSays)
		$PuzzleTimer.stop()
		start()
		

func hide_puzzle():
	$ColorOptions.visible = false
	$SimonColor.visible = true
	
	
func _on_mini_game_section_won(game):
	if game == MiniGameReference.MINI_GAMES.ShortSimonSays:
		sections_won += 1
		if sections_won == 3:
			SignalBus.mini_game_won.emit(MiniGameReference.MINI_GAMES.ShortSimonSays)
			sections_won = 0
	
func get_difficulty_scale():
	return MiniGameReference.difficulty_scale[enum_reference]		


func manage_difficulty_scale():
	if difficulty_scale % 3 == 1:
		# animation "More!"
		# TODO: add dynamically added color circles
		pass
	elif difficulty_scale % 3 == 2:
		# animation "Faster!"
		game_timer_length -= 0.1
	else:
		pass


func _on_puzzle_timer_timeout() -> void:
	SignalBus.player_lost.emit()
