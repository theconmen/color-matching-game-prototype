extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_win_con_met.connect(_hide_pause_label)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	SignalBus.continue_game_button_pressed.emit()
	_show_pause_label()


func _on_exit_to_main_pressed() -> void:
	SignalBus.exit_to_main_button_pressed.emit()
	_show_pause_label()

func _hide_pause_label():
	$PauseLabel.visible = false
	$WinLabel.visible = true
	
func _show_pause_label():
	$PauseLabel.visible = true
	$WinLabel.visible = false
