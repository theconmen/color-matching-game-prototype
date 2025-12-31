extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.single_player_game_selected.connect(_on_single_player_selected)
	

func _on_single_player_selected():
	pass
