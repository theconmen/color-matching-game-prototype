extends Node

#Scene Navigation signals
signal single_player_game_selected()

# UI scene
signal exit_to_main_button_pressed()
signal continue_game_button_pressed()

#GamePlay signals
signal color_changed(object, old_color, new_color)
signal color_left_clicked(object, color)
signal color_right_clicked(object, color)
signal player_lost()
#game should be the enum from mini_game_reference
signal mini_game_section_won(game)
signal mini_game_won(game)
signal mini_game_ready(game)

signal mini_game_round_completed()
