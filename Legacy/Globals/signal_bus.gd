extends Node

#Scene Navigation signals
signal random_match_game_selected
signal RGB_race_game_selected
signal puzzle_race_game_selected
signal quick_match_game_selected

# UI scene
signal exit_to_main_button_pressed()
signal continue_game_button_pressed()

#RandomMatch signals
signal color_circle_left_click(color)
signal color_circle_right_click(color)
signal player_new_color(color)
signal main_color_new_color(color)
signal player_win_con_met()

#Puzzle race signals
signal valid_puzzle_found

#Quick match signls
signal player_loss_con_met
signal quick_match_puzzle_generated
