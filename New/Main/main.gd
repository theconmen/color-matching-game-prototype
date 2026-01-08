extends Node


# TODO: need to figure out difficulty scaling options and how I am swtiching mini games

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.single_player_game_selected.connect(_on_single_player_selected)
	

func _on_single_player_selected():
	pass
