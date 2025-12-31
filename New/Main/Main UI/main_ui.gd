extends CanvasLayer

func _on_single_player_pressed() -> void:
	SignalBus.single_player_game_selected.emit()
