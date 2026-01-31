extends Node2D
class_name ShortSimonSays

#@onready var child_array = $ColorOptions.get_children()
@onready var time_bar = $ProgressBar
@onready var grid_container = $GridContainer
@onready var color_options = $ColorOptions
var color_base: PackedScene = load('uid://cb083mnw8oavl')
@export var num_of_color_options: int = 8
var color_num : int = 0
var solutions_array = []
var answers_count: int = 0
var sections_won: int = 0
var difficulty_scale: int = 0
var enum_reference := MiniGameReference.MINI_GAMES.ShortSimonSays
var game_timer_length: float = 4.0

#ideas on difficulty increase
# make things faster
# show more color options
# etc

#TODO: add breakpoints where new mechanics get added to game

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
	if difficulty_scale > 0:
		manage_difficulty_scale()
	#generate_color_options()
	start()
	

func _process(_delta: float) -> void:
	time_bar.value = $PuzzleTimer.time_left


#dynamically create color options and assign them to the appropriate spots based on the grid container
func generate_color_options():
	var color_array = ColorFunctions.generate_random_colors(num_of_color_options)
	for color in color_array:
		var new_control = Control.new()
		grid_container.add_child(new_control)
		var new_color: ColorBase = color_base.instantiate()
		color_options.add_child(new_color)
		new_color.set_new_color(color)
	call_deferred('set_new_color_positions')

func set_new_color_positions():
	var color_solutions_array = color_options.get_children()
	var color_container_array = grid_container.get_children()
	for i in len(color_solutions_array):
		color_solutions_array[i].set_new_position(color_container_array[i].global_position)
	
	
func pick_next_simon_color(amount: int = 1):
	var child_array = color_options.get_children()
	for i in range(amount):
		#temp until I figure out how this scaling works
		solutions_array = []
		solutions_array.append(child_array.pick_random())
	

func start():
	hide_puzzle()
	# difficulty scaler could become a var to put into the "pick next simon color"
	remove_previous_color_options()
	await get_tree().process_frame
	generate_color_options()
	pick_next_simon_color()
	for solution in solutions_array:
		$SimonColor.set_new_color(solution.current_color)
		$ShowColor.start()
		await $ShowColor.timeout
	show_puzzle()
	

func remove_previous_color_options():
	for child in color_options.get_children():
		child.queue_free()
	for child in grid_container.get_children():
		child.queue_free()

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
		print('more')
		for i in range(difficulty_scale/3):
			if num_of_color_options < 16:
				num_of_color_options += 1
	elif difficulty_scale % 3 == 2:
		# animation "Faster!"
		print('faster')
		for i in range(difficulty_scale/3):
			if game_timer_length > 2.0:
				game_timer_length -= 0.1
	elif difficulty_scale % 5 == 0:
		#TODO: increase amount of colors to guess by adding new simon colors that show at the same time
		print('pass')
		pass
	else:
		print('No conditions met')


func _on_puzzle_timer_timeout() -> void:
	SignalBus.player_lost.emit()
