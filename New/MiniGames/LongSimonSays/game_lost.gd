extends CanvasLayer

@onready var main_menu = load('uid://ci65qcv2o5v4a')

#TODO: change scene switch handling to the game_manager scene

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu)
