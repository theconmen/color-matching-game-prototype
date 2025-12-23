extends CanvasLayer

var win_lose_text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_win_con_met.connect(_change_to_win_label)
	SignalBus.player_loss_con_met.connect(_change_to_loss_label)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$WinLabel.text = win_lose_text


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
	
func _change_to_win_label():
	win_lose_text = "You Win!"
	_hide_pause_label()
	
func _change_to_loss_label():
	win_lose_text = "You Lose :("
	_hide_pause_label()
