extends Node2D
class_name LongSimonSays

@onready var child_array = $ColorOptions.get_children()
var color_num : int = 0
var solutions_array = []
var answers_count: int = 0

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
	SignalBus.mini_game_ready.emit(MiniGameReference.MINI_GAMES.LongSimonSays)
	$ColorOptions.visible = false
	$SimonColor.set_new_color(Color(0.0, 0.0, 0.0))
	$GameLost.visible = false
	generate_color_options()
	start()


func generate_color_options():
	var color_array = ColorFunctions.generate_random_colors(len(child_array))
	for child in child_array:
		child.set_new_color(color_array[0])
		color_array.remove_at(0)
	
	
func pick_next_simon_color(amount = 1):
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
		
		start()
		
func _on_player_lost():
	$GameLost.visible = true
	get_tree().paused = true
		

func hide_puzzle():
	$ColorOptions.visible = false
	$SimonColor.visible = true
		
	
