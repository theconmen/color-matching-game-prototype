extends Control

@onready var great_label: Label = $Label
@export var play_label_animation: bool = false

func _on_visibility_changed() -> void:
	if visible:
		get_tree().paused = true
		play_entry_animation()
		

func play_entry_animation():
	# Get viewport width
	var screen_width = get_viewport_rect().size.x
	
	# Calculate center based on viewport, not label size
	var label_width = great_label.get_rect().size.x
	 #get center of screen
	var target_pos = screen_width/2.0 - label_width/2.0
	
	# Set the label off screen
	great_label.global_position.x = screen_width
	await get_tree().process_frame
	
	var tween = create_tween()
	
	# Tween for moving the label in
	tween.tween_property(great_label, 'global_position:x', target_pos, 0.3).set_trans(Tween.TRANS_EXPO)
	
	# Tween for moving the label in center
	tween.tween_property(great_label, 'global_position:x', target_pos - 100, 1.0).set_trans(Tween.TRANS_LINEAR)
	
	# Tween for moving the label out
	tween.tween_property(great_label, 'global_position:x', 0 - label_width, 0.3).set_trans(Tween.TRANS_EXPO)
	
	# Give GameManager go ahead to continue
	await tween.finished
	await get_tree().create_timer(0.05).timeout
	get_tree().paused = false
	SignalBus.mini_game_win_animation_finished.emit()
