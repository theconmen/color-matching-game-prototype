extends Node

# for use as reference to different mini games as an enum and as a class list and to see the current minigame being played

var long_simon_says: PackedScene = load('uid://ojcsaaew2nt2')

var current_game

enum MINI_GAMES {LongSimonSays}


func _ready() -> void:
	SignalBus.mini_game_ready.connect(_on_mini_game_ready)
	

func _on_mini_game_ready(game):
	current_game = game
