extends Node

var game_manager = load('uid://dmqro2rnqi8pl')

# TODO: need to figure out difficulty scaling options and how I am swtiching mini games

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.single_player_game_selected.connect(_on_single_player_selected)
	

func _on_single_player_selected():
	get_tree().change_scene_to_packed(game_manager)
