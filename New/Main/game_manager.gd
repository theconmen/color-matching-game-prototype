extends Node2D
class_name GameManager

#Game Manager is responsible for loading and unloading mingames based on certain signals
#Mini game reference list is kept in mini game reference autoload for use

@onready var loss_screen = $GameLost


func _ready() -> void:
	SignalBus.mini_game_won.connect(_on_mini_game_won)
	SignalBus.player_lost.connect(_on_mini_game_lost)
	loss_screen.visible = false
	change_minigame()

	
#handle whenever the minigame is won
func _on_mini_game_won(_game):
	change_minigame()
	
func _on_mini_game_lost():
	$GameLost.visible = true
	get_tree().paused = true
	
# handle changing the mini_game
func change_minigame():
	var children = self.get_children()
	var next_minigame = pick_next_minigame()
	for child in children:
		if child.is_in_group('Mini_games'):
			child.queue_free()
	add_child(next_minigame)
	
# pick a random next minigame and return a reference to that minigame
func pick_next_minigame():
	var next_minigame = MiniGameReference.MINI_GAMES.values().pick_random()
	if next_minigame == MiniGameReference.MINI_GAMES.LongSimonSays:
		return MiniGameReference.long_simon_says.instantiate()
	elif next_minigame == MiniGameReference.MINI_GAMES.ShortSimonSays:
		return MiniGameReference.short_simon_says.instantiate()
	elif next_minigame == MiniGameReference.MINI_GAMES.MemoryGame:
		return MiniGameReference.memory_game.instantiate()
	
