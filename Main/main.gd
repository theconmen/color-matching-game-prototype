extends Node

@onready var RandomMatch: PackedScene = load("uid://dkbhys3yb3puy")
@onready var RGBRace: PackedScene = load("uid://dogly64edrtnt")
@onready var PuzzleRace: PackedScene = load('uid://bqrn7bb8oo7sr')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.random_match_game_selected.connect(_on_random_match_game_selected)
	SignalBus.RGB_race_game_selected.connect(_on_rgb_race_game_selected)
	SignalBus.puzzle_race_game_selected.connect(_on_puzzle_race_game_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_random_match_game_selected():
	get_tree().change_scene_to_packed(RandomMatch)
	

func _on_rgb_race_game_selected():
	get_tree().change_scene_to_packed(RGBRace)
	
func _on_puzzle_race_game_selected():
	get_tree().change_scene_to_packed(PuzzleRace)
