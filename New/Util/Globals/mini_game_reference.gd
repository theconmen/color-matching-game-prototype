extends Node

# for use as reference to different mini games as an enum and as a class list and to see the current minigame being played

var long_simon_says: PackedScene = load('uid://ojcsaaew2nt2')
var short_simon_says: PackedScene = load('uid://bcdto52kfdap6')
var memory_game: PackedScene = load('uid://oblkbnrxuyrg')
var difficulty_scale: Dictionary = {MINI_GAMES.LongSimonSays: 0, MINI_GAMES.ShortSimonSays: 0, 
									MINI_GAMES.MemoryGame: 0}

var current_game

enum MINI_GAMES {LongSimonSays, ShortSimonSays, MemoryGame}


func _ready() -> void:
	SignalBus.mini_game_ready.connect(_on_mini_game_ready)
	SignalBus.mini_game_won.connect(_on_mini_game_won)
	SignalBus.player_lost.connect(_on_player_lost)
	

func _on_mini_game_ready(game):
	current_game = game
	

func _on_mini_game_won(game):
	difficulty_scale[game] += 1
	print(difficulty_scale)
	
	
func _on_player_lost():
	for game in difficulty_scale:
		difficulty_scale[game] = 0
