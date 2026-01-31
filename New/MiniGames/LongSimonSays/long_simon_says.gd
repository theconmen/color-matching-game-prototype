extends Node2D
class_name LongSimonSays

#@onready var child_array = $ColorOptions.get_children()
var color_num : int = 0
var solutions_array = []
var answers_count: int = 0
var sections_won: int = 0
var base_num_of_answers: int = 3
var difficulty_scale: int = 0
var enum_reference := MiniGameReference.MINI_GAMES.LongSimonSays
var game_timer_length: float = 3.5
var num_of_color_options: int = 12
@onready var guess_timer := $GuessTimer
@onready var progress_bar := $ProgressBar
@onready var grid_container = $CanvasLayer/ColorContainer
@onready var color_options = $ColorOptions
var color_base: PackedScene = load('uid://cb083mnw8oavl')


#ideas on difficulty increase
# make things faster
# show more color options
# add more colors at a time
# make the random colors closer together in color
# etc



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.color_left_clicked.connect(_on_color_left_clicked)
	SignalBus.mini_game_section_won.connect(_on_mini_game_section_won)
	SignalBus.mini_game_ready.emit(enum_reference)
	$ColorOptions.visible = false
	$SimonColor.set_new_color(Color(0.0, 0.0, 0.0))
	progress_bar.max_value = game_timer_length
	difficulty_scale = get_difficulty_scale()
	manage_difficulty_scale()
	generate_color_options()
	start()
	
	
func _process(_delta) -> void:
	if guess_timer.time_left <= guess_timer.wait_time:
		progress_bar.value = guess_timer.time_left

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
	
	
func pick_next_simon_color(amount: int = base_num_of_answers):
	var child_array = color_options.get_children()
	for i in range(amount):
		solutions_array.append(child_array.pick_random())
	

func start():
	hide_puzzle()
	# difficulty scaler could become a var to put into the "pick next simon color"
	pick_next_simon_color()
	for solution in solutions_array:
		$SimonColor.set_new_color(Color(0.0, 0.0, 0.0))
		$BetweenColors.start()
		await $BetweenColors.timeout
		$SimonColor.set_new_color(solution.current_color)
		$ShowColor.start()
		await $ShowColor.timeout
	show_puzzle()

func show_puzzle():
	$ColorOptions.visible = true
	$SimonColor.visible = false
	guess_timer.start(game_timer_length)
	

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
		guess_timer.stop()
		SignalBus.mini_game_section_won.emit(enum_reference)
		start()
		

func hide_puzzle():
	$ColorOptions.visible = false
	$SimonColor.visible = true
	
	
func _on_mini_game_section_won(game):
	if game == enum_reference:
		sections_won += 1
		if sections_won == 1:
			SignalBus.mini_game_won.emit(enum_reference)
			sections_won = 0

			
func get_difficulty_scale():
	return MiniGameReference.difficulty_scale[enum_reference]		


func manage_difficulty_scale():
	if difficulty_scale % 3 == 1:
		# animation "More!"
		base_num_of_answers += 1
	elif difficulty_scale % 3 == 2:
		# animation "Faster!"
		game_timer_length -= 0.2
	else:
		pass


func _on_guess_timer_timeout() -> void:
	SignalBus.player_lost.emit()
