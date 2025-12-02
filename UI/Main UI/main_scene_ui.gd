extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_random_match_pressed() -> void:
	SignalBus.random_match_game_selected.emit()


func _on_rgb_race_pressed() -> void:
	SignalBus.RGB_race_game_selected.emit()
